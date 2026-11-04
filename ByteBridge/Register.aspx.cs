using System;
using System.Data;
using System.Linq;
using System.Net.Mail;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI.WebControls;

public partial class Register : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (SignedIn) Go("Dashboard.aspx");
    }

    protected void Register_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        string email = Email.Text.Trim().ToLowerInvariant();
        string name = NameInput.Text.Trim();
        string password = Password.Text;

        if (name.Length < 1 || name.Length > 60)
        {
            Message("Enter a display name of 1-60 characters.", true);
            return;
        }

        try
        {
            if (email.Length > 254 || new MailAddress(email).Address != email || !email.Contains("@"))
                throw new FormatException();
        }
        catch (FormatException)
        {
            Message("Enter a valid email address.", true);
            return;
        }

        if (password.Length < 6 || password.Length > 128 || !password.Any(char.IsUpper) || !password.Any(char.IsLower) || !password.Any(char.IsDigit))
        {
            Message("Use 6-128 characters with uppercase, lowercase and a number.", true);
            return;
        }

        if (password != ConfirmPassword.Text)
        {
            Message("The passwords do not match.", true);
            return;
        }

        if (Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Users WHERE Email=@p0", email)) > 0)
        {
            Message("That email is already registered.", true);
            return;
        }

        try
        {
            Db.CreateUser(email, name, password, "Member");
        }
        catch (SqlException)
        {
            Message("This email could not be registered. Try logging in.", true);
            return;
        }

        string id = Db.Value("SELECT Id FROM Users WHERE Email=@p0", email).ToString();
        FormsAuthentication.SetAuthCookie(id, false);
        Go("Dashboard.aspx");
    }
}
