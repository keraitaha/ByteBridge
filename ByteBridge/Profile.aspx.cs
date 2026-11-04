using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class MemberProfile : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        RequireLogin();
        AdminLink.Visible = IsAdmin;
        if (IsPostBack) return;

        DataRow account = Db.Table("SELECT Email,DisplayName FROM Users WHERE Id=@p0", UserId).Rows[0];
        EmailAddress.Text = account["Email"].ToString();
        NameInput.Text = account["DisplayName"].ToString();
        if (Request.QueryString["saved"] == "1") Message("Display name saved.");
    }

    protected void SaveProfile_Click(object sender, EventArgs e)
    {
        RequireLogin();
        string name = NameInput.Text.Trim();
        if (name.Length == 0 || name.Length > 60)
        {
            Message("Enter a display name from 1 to 60 characters.", true);
            return;
        }

        Db.Run("UPDATE Users SET DisplayName=@p0 WHERE Id=@p1", name, UserId);
        Go("Profile.aspx?saved=1");
    }
}
