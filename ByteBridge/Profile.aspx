<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Profile.aspx.cs" Inherits="MemberProfile" %>
<!doctype html>
<html lang="en">
<head runat="server"><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Profile · ByteBridge</title><link rel="stylesheet" href="styles/site.css"><script src="scripts/site.js" defer></script></head>
<body>
<a class="skip-link" href="#main">Skip to content</a>
<form id="MainForm" runat="server">
<asp:HiddenField ID="CsrfToken" runat="server" />
<header class="site-header"><div class="container header-row"><a class="brand" href="Default.aspx">Byte<span>Bridge</span></a><nav class="desktop-nav" aria-label="Main navigation"><a href="Paths.aspx">Learn</a><a href="Practice.aspx">Skill tree</a><a href="Quizzes.aspx">Quizzes</a><a href="Dashboard.aspx">My progress</a><a href="Login.aspx" id="LoginLink" runat="server">Log in</a></nav><details class="menu"><summary>Menu</summary><nav aria-label="All pages"><a href="Default.aspx">Home</a><a href="Paths.aspx">Lessons</a><a href="Practice.aspx">Skill tree</a><a href="Quizzes.aspx">Quizzes</a><a href="Results.aspx">Results</a><a href="Dashboard.aspx">Dashboard</a><a href="Notes.aspx">Notes</a><a href="Flashcards.aspx">Flashcards</a><a href="Profile.aspx">Profile</a><a href="About.aspx">About</a><a href="Admin.aspx">Admin studio</a><a href="Login.aspx">Log in</a><a href="Register.aspx">Sign up</a></nav></details><asp:Label ID="SignedInName" runat="server" CssClass="signed-in-name" /><asp:LinkButton ID="LogoutButton" runat="server" OnClick="Logout_Click" CssClass="secondary small" CausesValidation="false">Log out</asp:LinkButton></div></header>
<main id="main" class="container"><asp:Label ID="Notice" runat="server" CssClass="notice" Visible="false" />
<a class="back-link button secondary small" href="Dashboard.aspx">Back to dashboard</a>
<section class="narrow panel"><div class="page-heading"><h1>Your account</h1><p class="muted">Update the name shown in your study space.</p></div><div class="field"><asp:Label runat="server" AssociatedControlID="EmailAddress" Text="Email address" /><asp:TextBox ID="EmailAddress" runat="server" ReadOnly="true" /></div><div class="field"><asp:Label runat="server" AssociatedControlID="NameInput" Text="Display name" /><asp:TextBox ID="NameInput" runat="server" MaxLength="60" /></div><asp:Button ID="SaveProfile" runat="server" Text="Save display name" OnClick="SaveProfile_Click" /><div class="actions"><a class="button secondary" href="Results.aspx">Quiz history</a><a class="button secondary" href="Flashcards.aspx">Flashcards</a><asp:HyperLink ID="AdminLink" runat="server" NavigateUrl="Admin.aspx" Text="Admin studio" CssClass="button secondary" /></div></section>

</main>
<footer class="footer container">ByteBridge. Small steps. Real understanding. <a href="About.aspx">About this project</a></footer>
<nav class="phone-nav" aria-label="Phone navigation"><a href="Dashboard.aspx"><span aria-hidden="true">⌂</span><span>Today</span></a><a href="Paths.aspx"><span aria-hidden="true">▤</span><span>Learn</span></a><a href="Practice.aspx"><span aria-hidden="true">◇</span><span>Skills</span></a><a href="Quizzes.aspx"><span aria-hidden="true">?</span><span>Quiz</span></a><a href="Profile.aspx"><span aria-hidden="true">○</span><span>Account</span></a></nav>
</form></body></html>
