using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TopicList.DataSource = Db.Table("SELECT * FROM Topics ORDER BY Id");
        TopicList.DataBind();
    }

    protected void Topic_Bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Literal)e.Item.FindControl("TopicTitle")).Text = row["Title"].ToString();
        ((Literal)e.Item.FindControl("TopicDescription")).Text = row["Description"].ToString();
        Image image = (Image)e.Item.FindControl("TopicImage");
        image.ImageUrl = row["ImagePath"].ToString();
        image.AlternateText = row["Title"].ToString() + " illustration";
        ((HyperLink)e.Item.FindControl("TopicLink")).NavigateUrl = "Paths.aspx?topic=" + row["Id"];
    }
}
