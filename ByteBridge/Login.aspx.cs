using System;
using System.Data;
using System.Web.Security;
public partial class Login : BasePage
{
    protected void Page_Load(object sender, EventArgs e) { if(SignedIn) Go("Dashboard.aspx"); }
    protected void Login_Click(object sender, EventArgs e)
    {
        string email=Email.Text.Trim().ToLowerInvariant();
        if(email.Length>254 || Password.Text.Length>128) { Message("Email or password is incorrect.",true); return; }
        DataTable users=Db.Table("SELECT * FROM Users WHERE Email=@p0",email);
        if(users.Rows.Count==0 || !Db.PasswordMatches(Password.Text,users.Rows[0]["PasswordSalt"].ToString(),users.Rows[0]["PasswordHash"].ToString()))
        { Message("Email or password is incorrect.",true); return; }
        FormsAuthentication.SetAuthCookie(users.Rows[0]["Id"].ToString(),false);
        Go("Dashboard.aspx");
    }
}
