using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Dashboard : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RequireLogin();
        if (IsPostBack) return;

        Welcome.Text = Safe("Welcome back, " + DisplayName + ".");
        Completion.Text = Db.Value("SELECT COUNT(*) FROM Progress WHERE UserId=@p0", UserId) + "/" + Db.Value("SELECT COUNT(*) FROM Lessons");
        DataTable latest = Db.Table("SELECT TOP 1 Score,Total FROM Attempts WHERE UserId=@p0 ORDER BY AttemptedAt DESC,Id DESC", UserId);
        LatestScore.Text = latest.Rows.Count == 0 ? "-" : latest.Rows[0]["Score"] + "/" + latest.Rows[0]["Total"];
        int correct = Convert.ToInt32(Db.Value("SELECT COUNT(DISTINCT ExerciseId) FROM PracticeAttempts WHERE UserId=@p0 AND Correct=1", UserId));
        int explained = Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Reflections WHERE UserId=@p0", UserId));
        Experience.Text = (correct * 10 + explained * 5).ToString();
        NoteCount.Text = Db.Value("SELECT COUNT(*) FROM Notes WHERE UserId=@p0", UserId).ToString();

        AdminPanel.Visible = IsAdmin;
        if (IsAdmin)
        {
            AdminTopics.Text = Db.Value("SELECT COUNT(*) FROM Topics").ToString();
            AdminLessons.Text = Db.Value("SELECT COUNT(*) FROM Lessons").ToString();
            AdminQuestions.Text = Db.Value("SELECT COUNT(*) FROM Questions").ToString();
            AdminMembers.Text = Db.Value("SELECT COUNT(*) FROM Users").ToString();
        }
        ProgressList.DataSource = Db.Table("SELECT l.Id,l.Title,p.Confidence,p.CompletedAt FROM Lessons l LEFT JOIN Progress p ON p.LessonId=l.Id AND p.UserId=@p0 ORDER BY l.TopicId,l.SortOrder,l.Id", UserId);
        ProgressList.DataBind();
    }

    protected void ProgressList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Label)e.Item.FindControl("LessonTitle")).Text = Safe(row["Title"]);
        ((Label)e.Item.FindControl("LessonStatus")).Text = row["Confidence"] == DBNull.Value ? "Not started" : "Completed - confidence " + row["Confidence"] + "/5 - " + Convert.ToDateTime(row["CompletedAt"]).ToString("dd MMM yyyy, HH:mm") + " UTC";
        ((HyperLink)e.Item.FindControl("ReadLink")).NavigateUrl = "Lesson.aspx?id=" + row["Id"];
    }
}
