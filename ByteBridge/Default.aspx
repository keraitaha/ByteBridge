<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Default" %>

<!doctype html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Welcome - ByteBridge</title>
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
            <section class="hero">
                <div class="hero-copy">
                    <h1>Build your understanding. One small lesson at a time.</h1>
                    <p>Short lessons, tiny coding challenges and a skill tree that grows with you. Learn the web by making sense of its building blocks.</p>
                    <div class="actions">
                        <a class="button" href="Paths.aspx">Start learning</a>
                        <a class="button secondary" href="Practice.aspx">Explore your skill tree</a>
                    </div>
                </div>
                <div class="hero-example">
                    <p>A little code. A new beginning.</p>
                    <pre><code>&lt;main&gt;
  &lt;h1&gt;Hello, world.&lt;/h1&gt;
  &lt;p&gt;I made this.&lt;/p&gt;
&lt;/main&gt;</code></pre>
                    <p>Read it. Try it. Explain it in your own words.</p>
                </div>
            </section>
            <div class="section-heading">
                <h2>Choose your starting point</h2>
            </div>
            <div class="grid three">
                <asp:Repeater ID="TopicList" runat="server" OnItemDataBound="Topic_Bound">
                    <ItemTemplate>
                        <article class="card path-card">
                            <asp:Image ID="TopicImage" runat="server" CssClass="topic-image" Width="64" Height="64" />
                            <h3>
                                <asp:Literal ID="TopicTitle" runat="server" Mode="Encode" /></h3>
                            <p>
                                <asp:Literal ID="TopicDescription" runat="server" Mode="Encode" />
                            </p>
                            <asp:HyperLink ID="TopicLink" runat="server" CssClass="button secondary">View lessons</asp:HyperLink>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <section class="flow">
                <div class="step">
                    <h3>Understand</h3>
                    <p>A short explanation and a code example give each idea a shape.</p>
                </div>
                <div class="step">
                    <h3>Practice</h3>
                    <p>Complete small exercises, revisit mistakes and unlock the next skill.</p>
                </div>
                <div class="step">
                    <h3>Explain</h3>
                    <p>Teach the idea back to yourself. Knowing why matters as much as getting it right.</p>
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
