<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Dashboard" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Dashboard - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
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
</asp:Content>
