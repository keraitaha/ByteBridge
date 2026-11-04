using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Results : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RequireLogin();
        if (IsPostBack) return;

        DataTable rows = Db.Table("SELECT a.Id,a.TopicId,a.Score,a.Total,a.AttemptedAt,t.Title FROM Attempts a INNER JOIN Topics t ON t.Id=a.TopicId WHERE a.UserId=@p0 ORDER BY a.AttemptedAt DESC,a.Id DESC", UserId);
        EmptyResults.Visible = rows.Rows.Count == 0;
        AttemptList.DataSource = rows;
        AttemptList.DataBind();
        if (Request.QueryString["saved"] == "1") Message("Your quiz result has been saved.");
    }

    protected void AttemptList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;
        int total = Convert.ToInt32(row["Total"]);
        int score = Convert.ToInt32(row["Score"]);
        ((Label)e.Item.FindControl("TopicTitle")).Text = Safe(row["Title"]);
        ((Label)e.Item.FindControl("ScoreText")).Text = score + " / " + total + " correct - " + (total == 0 ? 0 : (int)Math.Round(100.0 * score / total)) + "%";
        ((Label)e.Item.FindControl("AttemptDate")).Text = Convert.ToDateTime(row["AttemptedAt"]).ToString("dd MMM yyyy, HH:mm") + " UTC";
        ((HyperLink)e.Item.FindControl("RetakeLink")).NavigateUrl = "Quizzes.aspx?topic=" + row["TopicId"];
    }
}
