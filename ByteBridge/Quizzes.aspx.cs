using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Quizzes : BasePage
{
    private int topicId;
    private DataTable quizRows;

    // Radio controls must exist before ASP.NET restores their posted choices.
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        topicId = Number(Request.QueryString["topic"]);
        QuizPanel.Visible = topicId > 0; CatalogPanel.Visible = topicId == 0;
        if (topicId > 0)
        {
            RequireLogin();
            quizRows = Db.Table("SELECT * FROM Questions WHERE TopicId=@p0 ORDER BY Id", topicId);
            QuestionList.DataSource = quizRows; QuestionList.DataBind();
            QuizTitle.Text = Convert.ToString(Db.Value("SELECT Title FROM Topics WHERE Id=@p0", topicId)) + " quiz";
            if (quizRows.Rows.Count == 0) { QuizPanel.Visible = false; Message("This topic has no quiz yet.", true); }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (topicId == 0)
        {
            QuizList.DataSource = Db.Table("SELECT t.Id,t.Title,COUNT(q.Id) AS QuestionCount FROM Topics t LEFT JOIN Questions q ON q.TopicId=t.Id GROUP BY t.Id,t.Title ORDER BY t.Id");
            QuizList.DataBind();
        }
        else if (!IsPostBack)
        {
            // The answer snapshot stays on the server. Only a random reference goes in viewstate.
            string key = "Quiz:" + Guid.NewGuid().ToString("N");
            ViewState["QuizKey"] = key;
            Session[key] = quizRows;
        }
    }

    protected void Quiz_Bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Literal)e.Item.FindControl("TopicTitle")).Text = row["Title"].ToString();
        ((Literal)e.Item.FindControl("QuestionCount")).Text = row["QuestionCount"].ToString();
        HyperLink link = (HyperLink)e.Item.FindControl("StartLink");
        link.NavigateUrl = SignedIn ? "Quizzes.aspx?topic=" + row["Id"] : "Login.aspx";
        if (Convert.ToInt32(row["QuestionCount"]) == 0) { link.Text = "Questions coming soon"; link.Enabled = false; }
    }

    protected void Question_Bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Literal)e.Item.FindControl("Prompt")).Text = row["Prompt"].ToString();
        RadioButtonList choices = (RadioButtonList)e.Item.FindControl("Choices");
        foreach (string letter in new string[] { "A", "B", "C", "D" })
            choices.Items.Add(new ListItem(Safe(row["Option" + letter]), letter));
    }

    protected void Submit_Click(object sender, EventArgs e)
    {
        RequireLogin();
        string key = Convert.ToString(ViewState["QuizKey"]);
        DataTable original = Session[key] as DataTable;
        if (original == null || quizRows.Rows.Count == 0 || original.Rows.Count != quizRows.Rows.Count)
        { Message("The quiz changed or expired. Reload and try again.", true); return; }

        // Do not match old posted answers to a changed set of questions.
        for (int index = 0; index < original.Rows.Count; index++)
        {
            foreach (string column in new string[] { "Id", "Prompt", "OptionA", "OptionB", "OptionC", "OptionD", "CorrectOption" })
                if (!original.Rows[index][column].Equals(quizRows.Rows[index][column]))
                { Message("The quiz changed or expired. Reload and try again.", true); return; }
        }

        int score = 0;
        for (int index = 0; index < original.Rows.Count; index++)
        {
            string choice = ((RadioButtonList)QuestionList.Items[index].FindControl("Choices")).SelectedValue;
            if (choice != "A" && choice != "B" && choice != "C" && choice != "D")
            { Message("Answer every question before checking your answers.", true); return; }
            if (choice == original.Rows[index]["CorrectOption"].ToString()) score++;
        }
        Db.Run("INSERT INTO Attempts(UserId,TopicId,Score,Total) VALUES(@p0,@p1,@p2,@p3)", UserId, topicId, score, original.Rows.Count);
        Session.Remove(key);
        Go("Results.aspx?saved=1");
    }
}
