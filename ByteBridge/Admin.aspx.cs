using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Admin : BasePage
{
    string Mode { get { return Request.QueryString["mode"] ?? ""; } }
    int EditId { get { return Number(Request.QueryString["edit"]); } }

    protected void Page_Load(object sender, EventArgs e)
    {
        RequireAdmin();
        bool manage = Mode == "topics" || Mode == "lessons" || Mode == "questions";
        OverviewPanel.Visible = !manage; ManagePanel.Visible = manage;
        TopicEditor.Visible = Mode == "topics"; LessonEditor.Visible = Mode == "lessons"; QuestionEditor.Visible = Mode == "questions";
        if (IsPostBack) return;
        if (!manage)
        {
            TopicCount.Text = Db.Value("SELECT COUNT(*) FROM Topics").ToString(); LessonCount.Text = Db.Value("SELECT COUNT(*) FROM Lessons").ToString(); QuestionCount.Text = Db.Value("SELECT COUNT(*) FROM Questions").ToString();
            MemberCount.Text = Db.Value("SELECT COUNT(*) FROM Users WHERE Role='Member'").ToString(); return;
        }
        ManageHeading.Text = "Manage " + Mode; NewLink.NavigateUrl = "Admin.aspx?mode=" + Mode;
        FillTopics(LessonTopic); FillTopics(QuestionTopic); LessonOrder.Text = "1";
        if (EditId > 0) LoadEditor();
        BindRecords();
        if (Request.QueryString["saved"] == "1") Message("Record saved.");
        if (Request.QueryString["deleted"] == "1") Message("Record deleted.");
    }

    void FillTopics(DropDownList list)
    {
        list.DataSource = Db.Table("SELECT Id,Title FROM Topics ORDER BY Id"); list.DataTextField = "Title"; list.DataValueField = "Id"; list.DataBind();
        list.Items.Insert(0, new ListItem("Choose a learning path", "0"));
    }

    string TableName()
    {
        if (Mode == "topics") return "Topics";
        if (Mode == "lessons") return "Lessons";
        return "Questions";
    }

    void LoadEditor()
    {
        DataTable rows = Db.Table("SELECT * FROM " + TableName() + " WHERE Id=@p0", EditId);
        if (rows.Rows.Count == 0) { TopicEditor.Visible = false; LessonEditor.Visible = false; QuestionEditor.Visible = false; Message("Record not found.", true); return; }
        DataRow row = rows.Rows[0];
        if (Mode == "topics") { TopicTitle.Text = row["Title"].ToString(); TopicDescription.Text = row["Description"].ToString(); }
        if (Mode == "lessons")
        {
            LessonTopic.SelectedValue = row["TopicId"].ToString(); LessonTitle.Text = row["Title"].ToString(); LessonSummary.Text = row["Summary"].ToString(); LessonBody.Text = row["Body"].ToString();
            LessonCode.Text = row["CodeSample"].ToString(); LessonReminder.Text = row["Reminder"].ToString(); LessonOrder.Text = row["SortOrder"].ToString();
        }
        if (Mode == "questions")
        {
            QuestionTopic.SelectedValue = row["TopicId"].ToString(); QuestionPrompt.Text = row["Prompt"].ToString();
            OptionA.Text = row["OptionA"].ToString(); OptionB.Text = row["OptionB"].ToString(); OptionC.Text = row["OptionC"].ToString(); OptionD.Text = row["OptionD"].ToString(); CorrectChoice.SelectedValue = row["CorrectOption"].ToString();
        }
    }

    void BindRecords()
    {
        DataTable rows;
        if (Mode == "topics") rows = Db.Table("SELECT Id,Title,Description AS Summary FROM Topics ORDER BY Id");
        else if (Mode == "lessons") rows = Db.Table("SELECT l.Id,l.Title,t.Title AS Summary FROM Lessons l INNER JOIN Topics t ON t.Id=l.TopicId ORDER BY l.TopicId,l.SortOrder,l.Id");
        else rows = Db.Table("SELECT q.Id,q.Prompt AS Title,t.Title AS Summary FROM Questions q INNER JOIN Topics t ON t.Id=q.TopicId ORDER BY q.TopicId,q.Id");
        EmptyRecords.Visible = rows.Rows.Count == 0; RecordList.DataSource = rows; RecordList.DataBind();
    }

    bool ValidText(string text, int maximum) { return !String.IsNullOrWhiteSpace(text) && text.Trim().Length <= maximum; }
    bool ValidTopic(int id) { return Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Topics WHERE Id=@p0", id)) == 1; }
    void Saved() { Go("Admin.aspx?mode=" + Mode + "&saved=1"); }

    protected void SaveTopic_Click(object sender, EventArgs e)
    {
        RequireAdmin();
        if (Mode != "topics") return;
        string title = TopicTitle.Text.Trim(); string description = TopicDescription.Text.Trim();
        if (!ValidText(title, 80) || !ValidText(description, 500)) { Message("Enter a title (up to 80 characters) and description (up to 500).", true); return; }
        if (Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Topics WHERE LOWER(Title)=LOWER(@p0) AND Id<>@p1", title, EditId)) > 0) { Message("This topic title is already used.", true); return; }
        try
        {
            if (EditId > 0)
            {
                if (Db.Run("UPDATE Topics SET Title=@p0,Description=@p1 WHERE Id=@p2", title, description, EditId) == 0) { Message("Topic not found.", true); return; }
            }
            else Db.Run("INSERT INTO Topics(Title,Description,ImagePath) VALUES(@p0,@p1,@p2)", title, description, "assets/topic.svg");
            Saved();
        }
        catch (SqlException) { Message("This topic conflicts with existing data. Refresh and try again.", true); }
    }

    protected void SaveLesson_Click(object sender, EventArgs e)
    {
        RequireAdmin();
        if (Mode != "lessons") return;
        int topic = Number(LessonTopic.SelectedValue); int order = Number(LessonOrder.Text);
        string title = LessonTitle.Text.Trim(); string summary = LessonSummary.Text.Trim(); string body = LessonBody.Text.Trim(); string code = LessonCode.Text.Trim(); string reminder = LessonReminder.Text.Trim();
        if (!ValidTopic(topic)) { Message("Choose an existing learning path.", true); return; }
        if (!ValidText(title, 100) || !ValidText(summary, 250) || !ValidText(body, 4000) || code.Length > 3000 || reminder.Length > 500) { Message("Check the lesson limits: title 100, summary 250, explanation 4000, code 3000 and reminder 500 characters.", true); return; }
        if (order < 1 || order > 99) { Message("Lesson order must be from 1 to 99.", true); return; }
        try
        {
            if (EditId > 0)
            {
                if (Db.Run("UPDATE Lessons SET TopicId=@p0,Title=@p1,Summary=@p2,Body=@p3,CodeSample=@p4,Reminder=@p5,SortOrder=@p6 WHERE Id=@p7", topic, title, summary, body, code, reminder, order, EditId) == 0) { Message("Lesson not found.", true); return; }
            }
            else Db.Run("INSERT INTO Lessons(TopicId,Title,Summary,Body,CodeSample,Reminder,SortOrder) VALUES(@p0,@p1,@p2,@p3,@p4,@p5,@p6)", topic, title, summary, body, code, reminder, order);
            Saved();
        }
        catch (SqlException) { Message("This lesson conflicts with existing data. Refresh and try again.", true); }
    }

    protected void SaveQuestion_Click(object sender, EventArgs e)
    {
        RequireAdmin();
        if (Mode != "questions") return;
        int topic = Number(QuestionTopic.SelectedValue); string prompt = QuestionPrompt.Text.Trim();
        string a = OptionA.Text.Trim(); string b = OptionB.Text.Trim(); string c = OptionC.Text.Trim(); string d = OptionD.Text.Trim(); string answer = CorrectChoice.SelectedValue;
        if (!ValidTopic(topic)) { Message("Choose an existing learning path.", true); return; }
        if (!ValidText(prompt, 300) || !ValidText(a, 200) || !ValidText(b, 200) || !ValidText(c, 200) || !ValidText(d, 200)) { Message("Enter a question (up to 300 characters) and all four options (up to 200 each).", true); return; }
        if (answer != "A" && answer != "B" && answer != "C" && answer != "D") { Message("Choose one correct answer: A, B, C or D.", true); return; }
        try
        {
            if (EditId > 0)
            {
                if (Db.Run("UPDATE Questions SET TopicId=@p0,Prompt=@p1,OptionA=@p2,OptionB=@p3,OptionC=@p4,OptionD=@p5,CorrectOption=@p6 WHERE Id=@p7", topic, prompt, a, b, c, d, answer, EditId) == 0) { Message("Question not found.", true); return; }
            }
            else Db.Run("INSERT INTO Questions(TopicId,Prompt,OptionA,OptionB,OptionC,OptionD,CorrectOption) VALUES(@p0,@p1,@p2,@p3,@p4,@p5,@p6)", topic, prompt, a, b, c, d, answer);
            Saved();
        }
        catch (SqlException) { Message("This question conflicts with existing data. Refresh and try again.", true); }
    }

    protected void RecordList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Label)e.Item.FindControl("RecordTitle")).Text = Safe(row["Title"]); ((Label)e.Item.FindControl("RecordSummary")).Text = Safe(row["Summary"]);
        ((HyperLink)e.Item.FindControl("EditLink")).NavigateUrl = "Admin.aspx?mode=" + Mode + "&edit=" + row["Id"];
        ((LinkButton)e.Item.FindControl("DeleteLink")).CommandArgument = row["Id"].ToString();
    }

    protected void RecordList_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        RequireAdmin();
        if (e.CommandName != "Remove" || (Mode != "topics" && Mode != "lessons" && Mode != "questions")) return;
        int id = Number(e.CommandArgument.ToString());
        if (Mode == "topics" && (Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Lessons WHERE TopicId=@p0", id)) > 0 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Questions WHERE TopicId=@p0", id)) > 0 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Attempts WHERE TopicId=@p0", id)) > 0 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Flashcards WHERE TopicId=@p0", id)) > 0)) { Message("Remove related lessons, questions and flashcard links before deleting this topic. Saved quiz attempts also protect it.", true); return; }
        if (Mode == "lessons" && (Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Progress WHERE LessonId=@p0", id)) > 0 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Notes WHERE LessonId=@p0", id)) > 0 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Exercises WHERE LessonId=@p0", id)) > 0 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Lessons WHERE PrerequisiteId=@p0", id)) > 0 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Reflections WHERE LessonId=@p0", id)) > 0)) { Message("This lesson has progress, notes, exercises or a following lesson and cannot be deleted.", true); return; }
        try
        {
            if (Db.Run("DELETE FROM " + TableName() + " WHERE Id=@p0", id) == 0) { Message("Record not found.", true); return; }
            Go("Admin.aspx?mode=" + Mode + "&deleted=1");
        }
        catch (SqlException) { Message("This record still has related data and cannot be deleted.", true); }
    }
}
