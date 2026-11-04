<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Dashboard" %>

<!doctype html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard - ByteBridge</title>
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
            <a class="back-link button secondary small" href="Dashboard.aspx">Back to dashboard</a>
            <div class="page-heading">
                <h1>
                    <asp:Label ID="Welcome" runat="server" /></h1>
                <p class="muted">A little progress is still progress. Find your next small step.</p>
            </div>
            <section class="stats">
                <div class="stat">
                    <strong>
                        <asp:Label ID="Completion" runat="server" /></strong>Lessons complete
                </div>
                <div class="stat">
                    <strong>
                        <asp:Label ID="LatestScore" runat="server" /></strong>Latest quiz
                </div>
                <div class="stat">
                    <strong>
                        <asp:Label ID="Experience" runat="server" /></strong>Practice XP
                </div>
            </section>
            <asp:Panel ID="AdminPanel" runat="server" Visible="false" CssClass="panel">
                <h2>Administrator tools</h2>
                <p>You are signed in as an administrator. Manage the learning content for everyone.</p>
                <section class="stats">
                    <div class="stat">
                        <strong>
                            <asp:Label ID="AdminTopics" runat="server" /></strong>Topics
                    </div>
                    <div class="stat">
                        <strong>
                            <asp:Label ID="AdminLessons" runat="server" /></strong>Lessons
                    </div>
                    <div class="stat">
                        <strong>
                            <asp:Label ID="AdminQuestions" runat="server" /></strong>Quiz questions
                    </div>
                    <div class="stat">
                        <strong>
                            <asp:Label ID="AdminMembers" runat="server" /></strong>Members
                    </div>
                </section>
                <div class="actions">
                    <a class="button" href="Admin.aspx">Open admin studio</a>
                    <a class="button secondary" href="Admin.aspx?mode=lessons">Manage lessons</a>
                    <a class="button secondary" href="Admin.aspx?mode=questions">Manage questions</a>
                </div>
            </asp:Panel>
            <section class="panel">
                <h2>Your next small step</h2>
                <p>Read a short lesson, complete a coding exercise, then explain the idea in your own words.</p>
                <div class="actions">
                    <a class="button" href="Practice.aspx">Open your skill tree</a>
                    <a class="button secondary" href="Paths.aspx">Browse lessons</a>
                </div>
            </section>
            <div class="section-heading">
                <h2>Your study space</h2>
            </div>
            <div class="grid three">
                <article class="card">
                    <h3>Your own words</h3>
                    <p>
                        <asp:Label ID="NoteCount" runat="server" />
                        personal notes to revisit.</p>
                    <a href="Notes.aspx">Open notes</a>
                </article>
                <article class="card">
                    <h3>Recall, then reveal</h3>
                    <p>Use your own flashcards to practice.</p>
                    <a href="Flashcards.aspx">Open flashcards</a>
                </article>
                <article class="card">
                    <h3>Look back</h3>
                    <p>Every quiz attempt is saved.</p>
                    <a href="Results.aspx">See quiz results</a>
                </article>
            </div>
            <div class="section-heading">
                <h2>Your lesson progress</h2>
            </div>
            <section class="panel">
                <asp:Repeater ID="ProgressList" runat="server" OnItemDataBound="ProgressList_ItemDataBound">
                    <ItemTemplate>
                        <article class="progress-row">
                            <div class="row">
                                <div>
                                    <h3>
                                        <asp:Label ID="LessonTitle" runat="server" /></h3>
                                    <p class="muted">
                                        <asp:Label ID="LessonStatus" runat="server" /></p>
                                </div>
                                <asp:HyperLink ID="ReadLink" runat="server" CssClass="button secondary small" Text="Read lesson" />
                            </div>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>
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
