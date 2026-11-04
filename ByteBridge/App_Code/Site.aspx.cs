using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

// Small shared database helpers. Every value uses a SQL parameter.
public static class Db
{
    private static bool ready;
    private static readonly object setupLock = new object();
    private static string connectionString;

    public static DataTable Table(string sql, params object[] values)
    {
        using (SqlConnection connection = new SqlConnection(connectionString))
        using (SqlCommand command = Command(connection, sql, values))
        using (SqlDataAdapter adapter = new SqlDataAdapter(command))
        {
            DataTable table = new DataTable();
            adapter.Fill(table);
            return table;
        }
    }
    public static object Value(string sql, params object[] values)
    {
        using (SqlConnection connection = new SqlConnection(connectionString))
        using (SqlCommand command = Command(connection, sql, values))
        { connection.Open(); return command.ExecuteScalar(); }
    }
    public static int Run(string sql, params object[] values)
    {
        using (SqlConnection connection = new SqlConnection(connectionString))
        using (SqlCommand command = Command(connection, sql, values))
        { connection.Open(); return command.ExecuteNonQuery(); }
    }
    public static int Add(string sql, params object[] values)
    { return Convert.ToInt32(Value(sql + "; SELECT CAST(SCOPE_IDENTITY() AS int);", values)); }

    private static SqlCommand Command(SqlConnection connection, string sql, object[] values)
    {
        SqlCommand command = new SqlCommand(sql, connection);
        for (int index = 0; index < values.Length; index++)
            command.Parameters.AddWithValue("@p" + index, values[index] ?? DBNull.Value);
        return command;
    }

    // Run once for this website folder; a restart never overwrites saved work.
    public static void Initialize()
    {
        lock (setupLock)
        {
            if (ready) return;
            string folder = HttpContext.Current.Server.MapPath("~/App_Data");
            Directory.CreateDirectory(folder);
            string file = Path.Combine(folder, "ByteBridge.mdf");
            string suffix;
            using (SHA256 hash = SHA256.Create())
                suffix = BitConverter.ToString(hash.ComputeHash(Encoding.UTF8.GetBytes(folder.ToLowerInvariant()))).Replace("-", "").Substring(0, 10);
            string database = "ByteBridge_" + suffix;
            if (!File.Exists(file))
            {
                using (SqlConnection master = new SqlConnection("Data Source=(LocalDB)\\MSSQLLocalDB;Initial Catalog=master;Integrated Security=True;Connect Timeout=60"))
                {
                    master.Open();
                    string safeFile = file.Replace("'", "''");
                    string log = Path.Combine(folder, "ByteBridge_log.ldf").Replace("'", "''");
                    using (SqlCommand create = new SqlCommand("CREATE DATABASE [" + database + "] ON PRIMARY (NAME=N'ByteBridge', FILENAME=N'" + safeFile + "') LOG ON (NAME=N'ByteBridge_log', FILENAME=N'" + log + "')", master))
                        create.ExecuteNonQuery();
                }
            }
            else
            {
                // An extracted copy has a different folder. Attach both of its local files explicitly.
                using (SqlConnection master = new SqlConnection("Data Source=(LocalDB)\\MSSQLLocalDB;Initial Catalog=master;Integrated Security=True;Connect Timeout=60"))
                {
                    master.Open();
                    using (SqlCommand exists = new SqlCommand("SELECT COUNT(*) FROM sys.databases WHERE name=@p0", master))
                    {
                        exists.Parameters.AddWithValue("@p0", database);
                        if (Convert.ToInt32(exists.ExecuteScalar()) == 0)
                        {
                            string dataFile = file.Replace("'", "''");
                            string logFile = Path.Combine(folder, "ByteBridge_log.ldf").Replace("'", "''");
                            using (SqlCommand attach = new SqlCommand("CREATE DATABASE [" + database + "] ON (FILENAME=N'" + dataFile + "'), (FILENAME=N'" + logFile + "') FOR ATTACH", master))
                                attach.ExecuteNonQuery();
                        }
                    }
                }
            }
            SqlConnectionStringBuilder settings = new SqlConnectionStringBuilder();
            settings.DataSource = "(LocalDB)\\MSSQLLocalDB";
            settings.InitialCatalog = database;
            settings.AttachDBFilename = file;
            settings.IntegratedSecurity = true;
            settings.ConnectTimeout = 60;
            connectionString = settings.ConnectionString;
            if (Value("SELECT OBJECT_ID('Users')") == DBNull.Value)
            {
                // Commit first setup together. A failed seed can be retried safely.
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        SeedRun(connection, transaction, File.ReadAllText(Path.Combine(folder, "Setup.sql")));
                        Seed(Path.Combine(folder, "Seed.xml"), connection, transaction);
                        SeedRun(connection, transaction, UserInsert, UserValues("member@bytebridge.local", "Learning member", "Learn123!", "Member"));
                        SeedRun(connection, transaction, UserInsert, UserValues("admin@bytebridge.local", "Administrator", "Admin123!", "Admin"));
                        transaction.Commit();
                    }
                }
            }
            ready = true;
        }
    }

    private static void SeedRun(SqlConnection connection, SqlTransaction transaction, string sql, params object[] values)
    {
        using (SqlCommand command = Command(connection, sql, values))
        { command.Transaction = transaction; command.ExecuteNonQuery(); }
    }

    private static void Seed(string file, SqlConnection connection, SqlTransaction transaction)
    {
        XElement seed = XElement.Load(file);
        foreach (XElement topic in seed.Element("topics").Elements("topic"))
            SeedRun(connection, transaction, "SET IDENTITY_INSERT Topics ON; INSERT INTO Topics(Id,Title,Description,ImagePath) VALUES(@p0,@p1,@p2,@p3); SET IDENTITY_INSERT Topics OFF;", (int)topic.Attribute("id"), (string)topic.Attribute("title"), (string)topic.Attribute("description"), (string)topic.Attribute("image"));
        foreach (XElement lesson in seed.Element("lessons").Elements("lesson"))
            SeedRun(connection, transaction, "SET IDENTITY_INSERT Lessons ON; INSERT INTO Lessons(Id,TopicId,Title,Summary,Body,CodeSample,Reminder,SortOrder) VALUES(@p0,@p1,@p2,@p3,@p4,@p5,@p6,@p7); SET IDENTITY_INSERT Lessons OFF;", (int)lesson.Attribute("id"), (int)lesson.Attribute("topicId"), (string)lesson.Element("title"), (string)lesson.Element("summary"), (string)lesson.Element("body"), (string)lesson.Element("code"), (string)lesson.Element("reminder"), (int)lesson.Attribute("order"));
        foreach (XElement lesson in seed.Element("lessons").Elements("lesson"))
        {
            int prerequisite;
            if (int.TryParse((string)lesson.Attribute("prerequisiteId"), out prerequisite))
                SeedRun(connection, transaction, "UPDATE Lessons SET PrerequisiteId=@p0 WHERE Id=@p1", prerequisite, (int)lesson.Attribute("id"));
        }
        foreach (XElement question in seed.Element("questions").Elements("question"))
            SeedRun(connection, transaction, "SET IDENTITY_INSERT Questions ON; INSERT INTO Questions(Id,TopicId,Prompt,OptionA,OptionB,OptionC,OptionD,CorrectOption) VALUES(@p0,@p1,@p2,@p3,@p4,@p5,@p6,@p7); SET IDENTITY_INSERT Questions OFF;", (int)question.Attribute("id"), (int)question.Attribute("topicId"), (string)question.Element("prompt"), (string)question.Element("a"), (string)question.Element("b"), (string)question.Element("c"), (string)question.Element("d"), (string)question.Attribute("answer"));
        foreach (XElement exercise in seed.Element("exercises").Elements("exercise"))
            SeedRun(connection, transaction, "SET IDENTITY_INSERT Exercises ON; INSERT INTO Exercises(Id,LessonId,Prompt,Starter,Answer,Explanation,SortOrder) VALUES(@p0,@p1,@p2,@p3,@p4,@p5,@p6); SET IDENTITY_INSERT Exercises OFF;", (int)exercise.Attribute("id"), (int)exercise.Attribute("lessonId"), (string)exercise.Element("prompt"), (string)exercise.Element("starter"), (string)exercise.Element("answer"), (string)exercise.Element("explanation"), (int)exercise.Attribute("order"));
    }

    public static void CreateUser(string email, string name, string password, string role)
    { Run(UserInsert, UserValues(email, name, password, role)); }

    private const string UserInsert = "INSERT INTO Users(Email,DisplayName,PasswordSalt,PasswordHash,Role) VALUES(@p0,@p1,@p2,@p3,@p4)";
    private static object[] UserValues(string email, string name, string password, string role)
    {
        byte[] salt = new byte[16];
        using (RandomNumberGenerator random = RandomNumberGenerator.Create()) random.GetBytes(salt);
        string saltText = Convert.ToBase64String(salt);
        return new object[] { email, name, saltText, PasswordHash(password, saltText), role };
    }
    public static string PasswordHash(string password, string salt)
    {
        using (Rfc2898DeriveBytes hash = new Rfc2898DeriveBytes(password, Convert.FromBase64String(salt), 100000, HashAlgorithmName.SHA256))
            return Convert.ToBase64String(hash.GetBytes(32));
    }
    public static bool PasswordMatches(string password, string salt, string expected)
    {
        byte[] actual = Convert.FromBase64String(PasswordHash(password, salt));
        byte[] stored = Convert.FromBase64String(expected);
        int difference = actual.Length ^ stored.Length;
        for (int index = 0; index < actual.Length && index < stored.Length; index++) difference |= actual[index] ^ stored[index];
        return difference == 0;
    }

    public static bool SkillPassed(int userId, int lessonId)
    {
        int total = Convert.ToInt32(Value("SELECT COUNT(*) FROM Exercises WHERE LessonId=@p0", lessonId));
        int passed = Convert.ToInt32(Value("SELECT COUNT(DISTINCT e.Id) FROM Exercises e JOIN PracticeAttempts a ON e.Id=a.ExerciseId WHERE e.LessonId=@p0 AND a.UserId=@p1 AND a.Correct=1", lessonId, userId));
        int explained = Convert.ToInt32(Value("SELECT COUNT(*) FROM Reflections WHERE UserId=@p0 AND LessonId=@p1", userId, lessonId));
        return total > 0 && passed == total && explained > 0;
    }
}

// Shared page behaviour, not a new framework. Pages still have their own events.
public class BasePage : Page
{
    public int UserId { get; private set; }
    public string DisplayName { get; private set; }
    public bool IsAdmin { get; private set; }
    public bool SignedIn { get { return UserId > 0; } }

    protected override void OnInit(EventArgs e)
    {
        Db.Initialize();
        ViewStateUserKey = Session.SessionID;
        if (Session["FormToken"] == null)
        {
            byte[] bytes = new byte[24];
            using (RandomNumberGenerator random = RandomNumberGenerator.Create()) random.GetBytes(bytes);
            Session["FormToken"] = Convert.ToBase64String(bytes);
        }
        if (Context.User.Identity.IsAuthenticated)
        {
            int id = Number(Context.User.Identity.Name);
            DataTable users = Db.Table("SELECT Id,DisplayName,Role FROM Users WHERE Id=@p0", id);
            if (users.Rows.Count > 0)
            {
                UserId = id; DisplayName = users.Rows[0]["DisplayName"].ToString(); IsAdmin = users.Rows[0]["Role"].ToString() == "Admin";
            }
        }
        base.OnInit(e);
    }
    protected override void OnPreLoad(EventArgs e)
    {
        HiddenField token = FindDeep(this, "CsrfToken") as HiddenField;
        if (IsPostBack && (token == null || Request.Form[token.UniqueID] != (string)Session["FormToken"]))
            throw new HttpException(400, "This form expired. Refresh the page and try again.");
        if (token != null) token.Value = (string)Session["FormToken"];
        base.OnPreLoad(e);
    }
    protected override void OnPreRender(EventArgs e)
    {
        Control logout = FindDeep(this, "LogoutButton");
        if (logout != null) logout.Visible = SignedIn;
        Label name = FindDeep(this, "SignedInName") as Label;
        if (name != null) { name.Visible = SignedIn; name.Text = Safe(DisplayName); }
        Control login = FindDeep(this, "LoginLink");
        if (login != null) login.Visible = !SignedIn;
        if (SignedIn) Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        base.OnPreRender(e);
    }
    private static Control FindDeep(Control parent, string id)
    {
        if (parent.ID == id) return parent;
        foreach (Control child in parent.Controls)
        { Control found = FindDeep(child, id); if (found != null) return found; }
        return null;
    }
    public void RequireLogin() { if (!SignedIn) Go("Login.aspx"); }
    public void RequireAdmin() { RequireLogin(); if (!IsAdmin) Go("Default.aspx"); }
    public void Go(string url) { Response.Redirect(url, true); }
    public int Number(string value) { int result; return int.TryParse(value, out result) ? result : 0; }
    public string Safe(object value) { return HttpUtility.HtmlEncode(Convert.ToString(value)); }
    public void Message(string text, bool error = false)
    {
        Label notice = FindDeep(this, "Notice") as Label;
        if (notice != null) { notice.Text = Safe(text); notice.CssClass = "notice " + (error ? "error" : "success"); notice.Visible = true; }
    }
    protected void Logout_Click(object sender, EventArgs e)
    { FormsAuthentication.SignOut(); Session.Abandon(); Go("Default.aspx"); }
}

