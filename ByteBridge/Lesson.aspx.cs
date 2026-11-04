using System;
using System.Data;
public partial class Lesson : BasePage
{
    private int lessonId;
    protected void Page_Load(object sender,EventArgs e)
    {
        lessonId=Number(Request.QueryString["id"]); DataTable rows=Db.Table("SELECT l.*,t.Title AS PathTitle,t.ImagePath FROM Lessons l JOIN Topics t ON l.TopicId=t.Id WHERE l.Id=@p0",lessonId);
        if(rows.Rows.Count==0) { LessonPanel.Visible=false; Message("This lesson does not exist.",true); return; }
        DataRow row=rows.Rows[0]; PathTitle.Text=row["PathTitle"].ToString(); LessonTitle.Text=row["Title"].ToString(); Summary.Text=row["Summary"].ToString(); Illustration.ImageUrl=row["ImagePath"].ToString(); Illustration.AlternateText=row["PathTitle"].ToString()+" illustration";
        MemberContent.Visible=SignedIn; CompletePanel.Visible=SignedIn; PreviewPanel.Visible=!SignedIn;
        if(SignedIn) { Body.Text=row["Body"].ToString(); Code.Text=row["CodeSample"].ToString(); Reminder.Text=row["Reminder"].ToString(); PracticeLink.NavigateUrl="Practice.aspx?lesson="+lessonId;
            if(!IsPostBack) { object confidence=Db.Value("SELECT Confidence FROM Progress WHERE UserId=@p0 AND LessonId=@p1",UserId,lessonId); if(confidence!=null) { Confidence.SelectedValue=confidence.ToString(); CompleteButton.Text="Update confidence"; } }
        }
    }
    protected void Complete_Click(object sender,EventArgs e)
    {
        RequireLogin(); int confidence=Number(Confidence.SelectedValue);
        if(confidence<1 || confidence>5 || Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Lessons WHERE Id=@p0",lessonId))==0) { Message("Choose a confidence from 1 to 5 for an existing lesson.",true); return; }
        int updated=Db.Run("UPDATE Progress SET Confidence=@p0,CompletedAt=SYSUTCDATETIME() WHERE UserId=@p1 AND LessonId=@p2",confidence,UserId,lessonId);
        if(updated==0) Db.Run("INSERT INTO Progress(UserId,LessonId,Confidence) VALUES(@p0,@p1,@p2)",UserId,lessonId,confidence);
        CompleteButton.Text="Update confidence"; Message("Lesson complete. Your confidence is saved.");
    }
}
