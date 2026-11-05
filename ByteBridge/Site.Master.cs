using System;
using System.Web.Security;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Logout_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Session.Abandon();
        Response.Redirect("Default.aspx", true);
    }
}
