using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Paths : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TopicFilter.Items.Add(new ListItem("All learning paths", "0"));
            foreach (DataRow row in Db.Table("SELECT Id,Title FROM Topics ORDER BY Id").Rows)
                TopicFilter.Items.Add(new ListItem(row["Title"].ToString(), row["Id"].ToString()));

            ListItem selected = TopicFilter.Items.FindByValue(Number(Request.QueryString["topic"]).ToString());
            if (selected != null)
                TopicFilter.SelectedValue = selected.Value;
        }

        BindLessons();
    }

    protected void Filter_Changed(object sender, EventArgs e)
    {
        BindLessons();
    }

    private void BindLessons()
    {
        int id = Number(TopicFilter.SelectedValue);
        DataTable rows = Db.Table("SELECT l.*,t.Title AS PathTitle FROM Lessons l JOIN Topics t ON l.TopicId=t.Id WHERE @p0=0 OR l.TopicId=@p0 ORDER BY l.TopicId,l.SortOrder,l.Id", id);
        LessonList.DataSource = rows;
        LessonList.DataBind();
        EmptyMessage.Visible = rows.Rows.Count == 0;
    }

    protected void Lesson_Bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Literal)e.Item.FindControl("PathTitle")).Text = row["PathTitle"].ToString();
        ((Literal)e.Item.FindControl("LessonTitle")).Text = row["Title"].ToString();
        ((Literal)e.Item.FindControl("Summary")).Text = row["Summary"].ToString();
        ((HyperLink)e.Item.FindControl("ReadLink")).NavigateUrl = "Lesson.aspx?id=" + row["Id"];
    }
}
