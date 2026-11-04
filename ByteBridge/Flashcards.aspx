<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Flashcards.aspx.cs" Inherits="Flashcards" %>

<!doctype html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Flashcards - ByteBridge</title>
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
                <h1>Make the ideas stick</h1>
                <p class="muted">Recall an answer in your own words before revealing it.</p>
            </div>
            <asp:Panel ID="EditorPanel" runat="server" CssClass="panel">
                <h2>
                    <asp:Label ID="EditorHeading" runat="server" Text="Create a flashcard" /></h2>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="CardFront" Text="Question / front" />
                    <asp:TextBox ID="CardFront" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="3" />
                </div>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="CardBack" Text="Answer / back" />
                    <asp:TextBox ID="CardBack" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="3" />
                </div>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="TopicChoice" Text="Related learning path (optional)" />
                    <asp:DropDownList ID="TopicChoice" runat="server" />
                </div>
                <div class="actions">
                    <asp:Button ID="SaveCard" runat="server" Text="Save flashcard" OnClick="SaveCard_Click" />
                    <a class="button secondary" href="Flashcards.aspx">Clear / cancel</a>
                </div>
            </asp:Panel>
            <div class="section-heading">
                <h2>Your flashcards</h2>
            </div>
            <asp:Label ID="EmptyCards" runat="server" CssClass="empty" Text="Create your first question and answer card." />
            <div class="grid two">
                <asp:Repeater ID="CardList" runat="server" OnItemDataBound="CardList_ItemDataBound" OnItemCommand="CardList_ItemCommand">
                    <ItemTemplate>
                        <article class="card flashcard">
                            <p class="muted">
                                <asp:Label ID="RelatedTopic" runat="server" /></p>
                            <h3>
                                <asp:Label ID="SavedFront" runat="server" /></h3>
                            <details>
                                <summary>Reveal answer</summary>
                                <p class="flash-answer">
                                    <asp:Label ID="SavedBack" runat="server" /></p>
                            </details>
                            <div class="record-actions">
                                <asp:HyperLink ID="EditLink" runat="server" CssClass="button secondary small" Text="Edit" />
                                <asp:LinkButton ID="DeleteLink" runat="server" CommandName="Remove" CssClass="button danger small" Text="Delete" data-confirm="Delete this flashcard? This cannot be undone." />
                            </div>
                        </article>
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
