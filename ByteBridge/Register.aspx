<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Register" %>

<!doctype html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sign up - ByteBridge</title>
    <link rel="stylesheet" href="styles/base.css">
    <link rel="stylesheet" href="styles/layout.css">
    <link rel="stylesheet" href="styles/forms.css">
    <link rel="stylesheet" href="styles/components.css">
    <link rel="stylesheet" href="styles/responsive.css">
    <script src="scripts/site.js" defer></script>
</head>
<body>
    <a class="skip-link" href="#main">Skip to content</a>
    <form id="MainForm" runat="server">
        <asp:HiddenField ID="CsrfToken" runat="server" />
        <header class="site-header">
            <div class="container header-row">
                <a class="brand" href="Default.aspx">Byte<span>Bridge</span></a>
                <nav class="desktop-nav" aria-label="Main navigation">
                    <a href="Paths.aspx">Learn</a>
                    <a href="Practice.aspx">Skill tree</a>
                    <a href="Quizzes.aspx">Quizzes</a>
                    <a href="Dashboard.aspx">My progress</a>
                    <a href="Login.aspx" id="LoginLink" runat="server">Log in</a>
                </nav>
                <details class="menu">
                    <summary>Menu</summary>
                    <nav aria-label="All pages">
                        <a href="Default.aspx">Home</a>
                        <a href="Paths.aspx">Lessons</a>
                        <a href="Practice.aspx">Skill tree</a>
                        <a href="Quizzes.aspx">Quizzes</a>
                        <a href="Results.aspx">Results</a>
                        <a href="Dashboard.aspx">Dashboard</a>
                        <a href="Notes.aspx">Notes</a>
                        <a href="Flashcards.aspx">Flashcards</a>
                        <a href="Profile.aspx">Profile</a>
                        <a href="About.aspx">About</a>
                        <a href="Admin.aspx">Admin studio</a>
                        <a href="Login.aspx">Log in</a>
                        <a href="Register.aspx">Sign up</a>
                    </nav>
                </details>
                <asp:Label ID="SignedInName" runat="server" CssClass="signed-in-name" />
                <asp:LinkButton ID="LogoutButton" runat="server" OnClick="Logout_Click" CssClass="secondary small" CausesValidation="false">Log out</asp:LinkButton>
            </div>
        </header>
        <main id="main" class="container">
            <asp:Label ID="Notice" runat="server" CssClass="notice" Visible="false" />
            <a class="back-link" href="Default.aspx">Back to home</a>
            <section class="panel narrow">
                <h1>Your learning starts here.</h1>
                <p>Create a member account to save your progress.</p>
                <asp:ValidationSummary ID="RegisterSummary" runat="server" CssClass="notice error" ValidationGroup="Register" HeaderText="Please fix the following:" />
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="NameInput">Display name</asp:Label>
                    <asp:TextBox ID="NameInput" runat="server" MaxLength="60" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="NameInput" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter a display name." Text="Enter a display name." />
                </div>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="Email">Email address</asp:Label>
                    <asp:TextBox ID="Email" runat="server" TextMode="Email" MaxLength="254" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter your email address." Text="Enter your email address." />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="Email" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Enter a valid email address." Text="Enter a valid email address." />
                </div>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
                    <asp:TextBox ID="Password" runat="server" TextMode="Password" MaxLength="128" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter a password." Text="Enter a password." />
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="Password" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,128}$" ErrorMessage="Use 6-128 characters with uppercase, lowercase and a number." Text="Use 6-128 characters with uppercase, lowercase and a number." />
                </div>
                <p class="muted">Use at least 6 characters with uppercase, lowercase and a number.</p>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="ConfirmPassword">Confirm password</asp:Label>
                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" MaxLength="128" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Confirm your password." Text="Confirm your password." />
                    <asp:CompareValidator runat="server" ControlToValidate="ConfirmPassword" ControlToCompare="Password" Operator="Equal" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="The passwords do not match." Text="The passwords do not match." />
                </div>
                <asp:Button ID="RegisterButton" runat="server" Text="Create account" OnClick="Register_Click" ValidationGroup="Register" />
                <div class="actions">
                    <a href="Login.aspx">Already have an account? Log in</a>
                </div>
            </section>
        </main>
        <footer class="footer container">ByteBridge. Small steps. Real understanding. <a href="About.aspx">About this project</a></footer>
        <nav class="phone-nav" aria-label="Phone navigation">
            <a href="Dashboard.aspx"><span>Today</span></a>
            <a href="Paths.aspx"><span>Learn</span></a>
            <a href="Practice.aspx"><span>Skills</span></a>
            <a href="Quizzes.aspx"><span aria-hidden="true">?</span><span>Quiz</span></a>
            <a href="Profile.aspx"><span>Account</span></a>
        </nav>
    </form>
</body>
</html>
