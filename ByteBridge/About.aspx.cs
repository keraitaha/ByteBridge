using System;

public partial class About : BasePage
{
    protected global::System.Web.UI.HtmlControls.HtmlAnchor CreateAccountLink;

    protected void Page_Load(object sender, EventArgs e)
    {
        CreateAccountLink.Visible = !SignedIn;
    }
}
