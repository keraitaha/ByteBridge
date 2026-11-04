using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Notes : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RequireLogin();
        if (IsPostBack) return;

        LessonChoice.DataSource = Db.Table("SELECT Id,Title FROM Lessons ORDER BY TopicId,SortOrder,Id");
        LessonChoice.DataTextField = "Title";
        LessonChoice.DataValueField = "Id";
        LessonChoice.DataBind();
        LessonChoice.Items.Insert(0, new ListItem("None (optional)", "0"));

        int id = Number(Request.QueryString["edit"]);
        if (id > 0)
        {
            DataTable rows = Db.Table("SELECT * FROM Notes WHERE Id=@p0 AND UserId=@p1", id, UserId);
            if (rows.Rows.Count == 0)
            {
                EditorPanel.Visible = false;
                Message("Note not found.", true);
            }
            else
            {
                DataRow row = rows.Rows[0];
                EditorHeading.Text = "Edit your note";
                NoteTitle.Text = row["Title"].ToString();
                NoteBody.Text = row["Body"].ToString();
                LessonChoice.SelectedValue = row["LessonId"] == DBNull.Value ? "0" : row["LessonId"].ToString();
            }
        }

        BindNotes();
        if (Request.QueryString["saved"] == "1") Message("Note saved.");
        if (Request.QueryString["deleted"] == "1") Message("Note deleted.");
    }

    void BindNotes()
    {
        DataTable rows = Db.Table("SELECT n.Id,n.Title,n.Body,l.Title AS LessonTitle FROM Notes n LEFT JOIN Lessons l ON l.Id=n.LessonId WHERE n.UserId=@p0 ORDER BY n.CreatedAt DESC,n.Id DESC", UserId);
        EmptyNotes.Visible = rows.Rows.Count == 0;
        NoteList.DataSource = rows;
        NoteList.DataBind();
    }

    protected void SaveNote_Click(object sender, EventArgs e)
    {
        RequireLogin();

        string title = NoteTitle.Text.Trim();
        string body = NoteBody.Text.Trim();
        int lesson = Number(LessonChoice.SelectedValue);

        if (title.Length == 0 || title.Length > 100 || body.Length == 0 || body.Length > 3000)
        {
            Message("Enter a title (up to 100 characters) and a note (up to 3000).", true);
            return;
        }

        if (lesson != 0 && Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Lessons WHERE Id=@p0", lesson)) == 0)
        {
            Message("Choose an existing lesson or leave it unlinked.", true);
            return;
        }

        object related = lesson == 0 ? (object)DBNull.Value : lesson;
        int id = Number(Request.QueryString["edit"]);
        if (id > 0)
        {
            int changed = Db.Run("UPDATE Notes SET Title=@p0,Body=@p1,LessonId=@p2 WHERE Id=@p3 AND UserId=@p4", title, body, related, id, UserId);
            if (changed == 0)
            {
                Message("Note not found.", true);
                return;
            }
        }
        else
        {
            Db.Run("INSERT INTO Notes(UserId,LessonId,Title,Body,CreatedAt) VALUES(@p0,@p1,@p2,@p3,SYSUTCDATETIME())", UserId, related, title, body);
        }

        Go("Notes.aspx?saved=1");
    }

    protected void NoteList_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;

        DataRowView row = (DataRowView)e.Item.DataItem;
        ((Label)e.Item.FindControl("RelatedLesson")).Text = row["LessonTitle"] == DBNull.Value ? "General note" : Safe(row["LessonTitle"]);
        ((Label)e.Item.FindControl("SavedTitle")).Text = Safe(row["Title"]);
        ((Label)e.Item.FindControl("SavedBody")).Text = Safe(row["Body"]);
        ((HyperLink)e.Item.FindControl("EditLink")).NavigateUrl = "Notes.aspx?edit=" + row["Id"];
        ((LinkButton)e.Item.FindControl("DeleteLink")).CommandArgument = row["Id"].ToString();
    }

    protected void NoteList_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        RequireLogin();
        if (e.CommandName != "Remove") return;

        int changed = Db.Run("DELETE FROM Notes WHERE Id=@p0 AND UserId=@p1", Number(e.CommandArgument.ToString()), UserId);
        if (changed == 0)
        {
            Message("Note not found.", true);
            return;
        }

        Go("Notes.aspx?deleted=1");
    }
}
