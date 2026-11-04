using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Flashcards : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RequireLogin();
        if (IsPostBack) return;
        TopicChoice.DataSource = Db.Table("SELECT Id,Title FROM Topics ORDER BY Id");
        TopicChoice.DataTextField = "Title"; TopicChoice.DataValueField = "Id"; TopicChoice.DataBind();
        TopicChoice.Items.Insert(0, new ListItem("None (optional)", "0"));
        int id = Number(Request.QueryString["edit"]);
        if (id > 0)
        {
            DataTable rows = Db.Table("SELECT * FROM Flashcards WHERE Id=@p0 AND UserId=@p1", id, UserId);
            if (rows.Rows.Count == 0) { EditorPanel.Visible = false; Message("Flashcard not found.", true); }
            else
            {
                DataRow row = rows.Rows[0]; EditorHeading.Text = "Edit your flashcard";
                CardFront.Text = row["Front"].ToString(); CardBack.Text = row["Back"].ToString();
                TopicChoice.SelectedValue = row["TopicId"] == DBNull.Value ? "0" : row["TopicId"].ToString();
            }
        }
        BindCards();
        if (Request.QueryString["saved"] == "1") Message("Flashcard saved.");
        if (Request.QueryString["deleted"] == "1") Message("Flashcard deleted.");
    }

    void BindCards()
    {
        DataTable rows = Db.Table("SELECT f.Id,f.Front,f.Back,t.Title AS TopicTitle FROM Flashcards f LEFT JOIN Topics t ON t.Id=f.TopicId WHERE f.UserId=@p0 ORDER BY f.CreatedAt DESC,f.Id DESC", UserId);
        EmptyCards.Visible = rows.Rows.Count == 0; CardList.DataSource = rows; CardList.DataBind();
    }

    protected void SaveCard_Click(object sender, EventArgs e)
    {
        RequireLogin();
        string front = CardFront.Text.Trim(); string back = CardBack.Text.Trim(); int topic = Number(TopicChoice.SelectedValue);
        if (front.Length == 0 || front.Length > 400 || back.Length == 0 || back.Length > 400) { Message("Enter a question and answer, each up to 400 characters.", true); return; }
        if (topic != 0 && Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Topics WHERE Id=@p0", topic)) == 0) { Message("Choose an existing path or leave it unlinked.", true); return; }
        object related = topic == 0 ? (object)DBNull.Value : topic;
        int id = Number(Request.QueryString["edit"]);
        if (id > 0)
        {
            int changed = Db.Run("UPDATE Flashcards SET Front=@p0,Back=@p1,TopicId=@p2 WHERE Id=@p3 AND UserId=@p4", front, back, related, id, UserId);
            if (changed == 0) { Message("Flashcard not found.", true); return; }
        }
        else Db.Run("INSERT INTO Flashcards(UserId,TopicId,Front,Back,CreatedAt) VALUES(@p0,@p1,@p2,@p3,SYSUTCDATETIME())", UserId, related, front, back);
        Go("Flashcards.aspx?saved=1");
    }

    protected void CardList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Label)e.Item.FindControl("RelatedTopic")).Text = row["TopicTitle"] == DBNull.Value ? "General practice" : Safe(row["TopicTitle"]);
        ((Label)e.Item.FindControl("SavedFront")).Text = Safe(row["Front"]);
        ((Label)e.Item.FindControl("SavedBack")).Text = Safe(row["Back"]);
        ((HyperLink)e.Item.FindControl("EditLink")).NavigateUrl = "Flashcards.aspx?edit=" + row["Id"];
        ((LinkButton)e.Item.FindControl("DeleteLink")).CommandArgument = row["Id"].ToString();
    }

    protected void CardList_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        RequireLogin();
        if (e.CommandName != "Remove") return;
        int changed = Db.Run("DELETE FROM Flashcards WHERE Id=@p0 AND UserId=@p1", Number(e.CommandArgument.ToString()), UserId);
        if (changed == 0) { Message("Flashcard not found.", true); return; }
        Go("Flashcards.aspx?deleted=1");
    }
}
