using System;
using System.Data;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class Practice : BasePage
{
    private int lessonId;
    private bool unlocked;

    protected void Page_Load(object sender, EventArgs e)
    {
        RequireLogin(); lessonId = Number(Request.QueryString["lesson"]);
        ChallengePanel.Visible = lessonId > 0;
        if (lessonId > 0)
        {
            DataTable lessons = Db.Table("SELECT * FROM Lessons WHERE Id=@p0", lessonId);
            if (lessons.Rows.Count == 0) { ChallengePanel.Visible = false; Message("Skill not found.", true); }
            else
            {
                DataRow lesson = lessons.Rows[0];
                int parent = Number(lesson["PrerequisiteId"].ToString());
                unlocked = parent == 0 || Db.SkillPassed(UserId, parent);
                SkillTitle.Text = lesson["Title"].ToString();
                ReadLesson.NavigateUrl = "Lesson.aspx?id=" + lessonId;
                ExercisePanel.Visible = unlocked;
                ReflectionPanel.Visible = unlocked && SolvedCount(lessonId) == ExerciseTotal(lessonId) && ExerciseTotal(lessonId) > 0;
                SkillStatus.Text = unlocked ? "Complete each different challenge, then practise explaining the idea." : "Finish the exercises and explanation for the earlier skill before practising this one.";
                if (!IsPostBack && unlocked)
                {
                    LoadExercise();
                    Explanation.Text = Convert.ToString(Db.Value("SELECT Explanation FROM Reflections WHERE UserId=@p0 AND LessonId=@p1", UserId, lessonId));
                }
            }
        }
        BindTree();
    }

    private int SolvedCount(int id)
    { return Convert.ToInt32(Db.Value("SELECT COUNT(DISTINCT e.Id) FROM Exercises e JOIN PracticeAttempts a ON a.ExerciseId=e.Id WHERE e.LessonId=@p0 AND a.UserId=@p1 AND a.Correct=1", id, UserId)); }
    private int ExerciseTotal(int id)
    { return Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Exercises WHERE LessonId=@p0", id)); }

    private void LoadExercise()
    {
        DataTable exercises = Db.Table("SELECT e.* FROM Exercises e WHERE LessonId=@p0 ORDER BY CASE WHEN EXISTS (SELECT 1 FROM PracticeAttempts a WHERE a.ExerciseId=e.Id AND a.UserId=@p1 AND a.Correct=1) THEN 1 ELSE 0 END,e.SortOrder,e.Id", lessonId, UserId);
        if (exercises.Rows.Count == 0) { ExercisePanel.Visible = false; Message("This skill has no challenges yet."); return; }
        int index = 0;
        if (SolvedCount(lessonId) == exercises.Rows.Count) index = Number(Convert.ToString(ViewState["Round"])) % exercises.Rows.Count;
        DataRow row = exercises.Rows[index];
        ViewState["ExerciseId"] = row["Id"];
        ExercisePrompt.Text = row["Prompt"].ToString(); Starter.Text = row["Starter"].ToString(); Answer.Text = "";
    }

    protected void Check_Click(object sender, EventArgs e)
    {
        RequireLogin();
        if (!unlocked) { Message("Complete the earlier skill first.", true); return; }
        int id = Number(Convert.ToString(ViewState["ExerciseId"]));
        DataTable rows = Db.Table("SELECT e.*,l.TopicId FROM Exercises e JOIN Lessons l ON l.Id=e.LessonId WHERE e.Id=@p0 AND e.LessonId=@p1", id, lessonId);
        if (rows.Rows.Count == 0) { Message("The exercise changed. Reload and try again.", true); return; }
        if (Answer.Text.Trim().Length == 0 || Answer.Text.Length > 200) { Message("Enter a short answer for the blank.", true); return; }
        DataRow exercise = rows.Rows[0];
        // Use the example's exact spelling so case-sensitive identifiers are learned correctly.
        bool correct = string.Equals(Answer.Text.Trim(), exercise["Answer"].ToString().Trim(), StringComparison.Ordinal);
        bool previouslySolved = Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM PracticeAttempts WHERE UserId=@p0 AND ExerciseId=@p1 AND Correct=1", UserId, id)) > 0;
        Db.Run("INSERT INTO PracticeAttempts(UserId,ExerciseId,Correct) VALUES(@p0,@p1,@p2)", UserId, id, correct);
        if (correct)
        {
            Message((previouslySolved ? "Correct. Useful practice, with no extra XP. " : "Correct. +10 XP for a new exercise. ") + exercise["Explanation"]);
            ViewState["Round"] = Number(Convert.ToString(ViewState["Round"])) + 1;
            LoadExercise();
        }
        else Message("Not quite. " + exercise["Explanation"] + " Revisit the lesson and try again.", true);
        ReflectionPanel.Visible = SolvedCount(lessonId) == ExerciseTotal(lessonId);
        BindTree();
    }

    protected void Reflect_Click(object sender, EventArgs e)
    {
        RequireLogin();
        if (!unlocked || ExerciseTotal(lessonId) == 0 || SolvedCount(lessonId) != ExerciseTotal(lessonId)) { Message("Solve all different challenges in this skill first.", true); return; }
        string text = Explanation.Text.Trim();
        if (text.Length < 40 || text.Length > 1500 || !TraceCheck.Checked || !WhyCheck.Checked || !ChangeCheck.Checked) { Message("Write 40–1500 characters and complete all three self-checks.", true); return; }
        int saved = Db.Run("UPDATE Reflections SET Explanation=@p0,ExplainedAt=SYSUTCDATETIME() WHERE UserId=@p1 AND LessonId=@p2", text, UserId, lessonId);
        if (saved == 0) Db.Run("INSERT INTO Reflections(UserId,LessonId,Explanation) VALUES(@p0,@p1,@p2)", UserId, lessonId, text);
        Message(saved == 0 ? "Self-check saved. +5 XP. The next skill is now available. Revisit this one whenever you need." : "Your explanation has been updated. Repeating a self-check does not add XP.");
        BindTree();
    }

    private void BindTree()
    {
        int solved = Convert.ToInt32(Db.Value("SELECT COUNT(DISTINCT ExerciseId) FROM PracticeAttempts WHERE UserId=@p0 AND Correct=1", UserId));
        int explained = Convert.ToInt32(Db.Value("SELECT COUNT(*) FROM Reflections WHERE UserId=@p0", UserId));
        XpCount.Text = (solved * 10 + explained * 5).ToString(); ExerciseCount.Text = solved.ToString();
        DataTable nodes = Db.Table("SELECT l.*,t.Title AS PathTitle FROM Lessons l JOIN Topics t ON t.Id=l.TopicId ORDER BY l.TopicId,l.SortOrder,l.Id");
        int passed = 0; foreach (DataRow row in nodes.Rows) if (Db.SkillPassed(UserId, Convert.ToInt32(row["Id"]))) passed++;
        SkillCount.Text = passed + "/" + nodes.Rows.Count;
        BranchList.DataSource = Db.Table("SELECT Id,Title FROM Topics ORDER BY Id"); BranchList.DataBind();
    }

    protected void Branch_Bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
        DataRowView topic = (DataRowView)e.Item.DataItem;
        ((Literal)e.Item.FindControl("BranchTitle")).Text = topic["Title"].ToString();
        Repeater list = (Repeater)e.Item.FindControl("NodeList");
        list.DataSource = Db.Table("SELECT l.*,t.Title AS PathTitle FROM Lessons l JOIN Topics t ON t.Id=l.TopicId WHERE l.TopicId=@p0 ORDER BY l.SortOrder,l.Id", topic["Id"]);
        list.DataBind();
    }

    protected void Node_Bound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem) return;
        DataRowView row = (DataRowView)e.Item.DataItem;
        int id = Convert.ToInt32(row["Id"]); int parent = Number(row["PrerequisiteId"].ToString());
        bool available = parent == 0 || Db.SkillPassed(UserId, parent); bool passed = Db.SkillPassed(UserId, id);
        ((Literal)e.Item.FindControl("PathTitle")).Text = row["PathTitle"].ToString();
        ((Literal)e.Item.FindControl("NodeTitle")).Text = row["Title"].ToString();
        ((Literal)e.Item.FindControl("NodeStatus")).Text = passed ? "Practised + explained. Revisit any time." : available ? SolvedCount(id) + "/" + ExerciseTotal(id) + " challenges solved. Ready to practise." : "Locked practice: finish the previous skill. Reading is open.";
        HyperLink practice = (HyperLink)e.Item.FindControl("NodeLink"); practice.NavigateUrl = "Practice.aspx?lesson=" + id; practice.Enabled = available; practice.Text = passed ? "Practise again" : available ? "Practise" : "Locked";
        ((HyperLink)e.Item.FindControl("LessonLink")).NavigateUrl = "Lesson.aspx?id=" + id;
        ((HtmlGenericControl)e.Item.FindControl("NodeCard")).Attributes["class"] = "skill-node " + (passed ? "skill-passed" : available ? "skill-open" : "skill-locked");
    }
}
