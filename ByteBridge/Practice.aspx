<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Practice.aspx.cs" Inherits="Practice" %>

<!doctype html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Skill tree - ByteBridge</title>
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
            <a class="back-link" href="Paths.aspx">Back to lessons</a>
            <h1>Grow your coding skills.</h1>
            <p>Small challenges, one idea at a time. Read any lesson; unlock practice by finishing its earlier skill.</p>
            <div class="stats">
                <div class="stat">
                    <strong>
                        <asp:Literal ID="XpCount" runat="server" Mode="Encode" /></strong>Practice XP
                </div>
                <div class="stat">
                    <strong>
                        <asp:Literal ID="SkillCount" runat="server" Mode="Encode" /></strong>Skills practiced
                </div>
                <div class="stat">
                    <strong>
                        <asp:Literal ID="ExerciseCount" runat="server" Mode="Encode" /></strong>Different exercises solved
                </div>
            </div>
            <asp:Panel ID="ChallengePanel" runat="server" CssClass="panel challenge">
                <h2>
                    <asp:Literal ID="SkillTitle" runat="server" Mode="Encode" /></h2>
                <p>
                    <asp:Literal ID="SkillStatus" runat="server" Mode="Encode" />
                </p>
                <asp:HyperLink ID="ReadLesson" runat="server">Read this lesson first</asp:HyperLink>
                <asp:Panel ID="ExercisePanel" runat="server">
                    <h3>Fill the gap</h3>
                    <p>
                        <asp:Literal ID="ExercisePrompt" runat="server" Mode="Encode" />
                    </p>
                    <pre><code><asp:Literal ID="Starter" runat="server" Mode="Encode"/></code></pre>
                    <div class="field">
                        <asp:Label runat="server" AssociatedControlID="Answer">Your answer for the blank</asp:Label>
                        <asp:TextBox ID="Answer" runat="server" MaxLength="200" autocomplete="off" />
                    </div>
                    <asp:Button ID="CheckButton" runat="server" OnClick="Check_Click" Text="Check and continue" />
                    <p class="muted">Use the spelling and capitalisation shown in the lesson. Newly solved exercises earn 10 XP. Repeating a solved exercise is useful practice and earns no extra XP. These small checks do not replace compiling a complete program.</p>
                </asp:Panel>
                <asp:Panel ID="ReflectionPanel" runat="server">
                    <h3>Teach it back</h3>
                    <p>Without copying the example, explain what triggers this code, what goes in, what comes out and why the main line works. Try speaking your answer aloud too.</p>
                    <div class="field">
                        <asp:Label runat="server" AssociatedControlID="Explanation">Your explanation (40-1500 characters)</asp:Label>
                        <asp:TextBox ID="Explanation" runat="server" TextMode="MultiLine" MaxLength="1500" />
                    </div>
                    <label class="check-line">
                        <asp:CheckBox ID="TraceCheck" runat="server" />I can trace the input and output.</label>
                    <label class="check-line">
                        <asp:CheckBox ID="WhyCheck" runat="server" />I can explain why the key line works.</label>
                    <label class="check-line">
                        <asp:CheckBox ID="ChangeCheck" runat="server" />I can describe what would happen if it changed.</label>
                    <asp:Button ID="ReflectButton" runat="server" Text="Save my self-check" OnClick="Reflect_Click" />
                    <p class="muted">This is your own assessment, not an automatic grade of your explanation. Ask a classmate to challenge it. First explanations earn 5 XP and open the next skill.</p>
                </asp:Panel>
            </asp:Panel>
            <div class="section-heading">
                <h2>Your skill tree</h2>
                <p class="muted">Open then solve three different challenges then explain then unlock.</p>
            </div>
            <div class="skill-tree">
                <asp:Repeater ID="BranchList" runat="server" OnItemDataBound="Branch_Bound">
                    <ItemTemplate>
                        <section class="skill-branch">
                            <h2>
                                <asp:Literal ID="BranchTitle" runat="server" Mode="Encode" /></h2>
                            <asp:Repeater ID="NodeList" runat="server" OnItemDataBound="Node_Bound">
                                <ItemTemplate>
                                    <article id="NodeCard" runat="server" class="skill-node">
                                        <p class="muted">
                                            <asp:Literal ID="PathTitle" runat="server" Mode="Encode" />
                                        </p>
                                        <h3>
                                            <asp:Literal ID="NodeTitle" runat="server" Mode="Encode" /></h3>
                                        <p>
                                            <asp:Literal ID="NodeStatus" runat="server" Mode="Encode" />
                                        </p>
                                        <div class="actions">
                                            <asp:HyperLink ID="NodeLink" runat="server" CssClass="button secondary">Practice</asp:HyperLink>
                                            <asp:HyperLink ID="LessonLink" runat="server">Read lesson</asp:HyperLink>
                                        </div>
                                    </article>
                                </ItemTemplate>
                            </asp:Repeater>
                        </section>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
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
