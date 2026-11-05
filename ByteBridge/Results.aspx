<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Results.aspx.cs" Inherits="Results" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Results - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link button secondary small" href="Dashboard.aspx">Back to dashboard</a>
    <div class="page-heading">
        <h1>Your quiz results</h1>
        <p class="muted">Every attempt is another chance to learn. Take a quiz again whenever you like.</p>
    </div>
    <div class="actions">
        <a class="button" href="Quizzes.aspx">Choose a quiz</a>
        <a class="button secondary" href="Practice.aspx">Practice a skill</a>
    </div>
    <div class="section-heading">
        <h2>Your history</h2>
    </div>
    <asp:Label ID="EmptyResults" runat="server" CssClass="empty" Text="Take your first quiz to see a result here." />
    <div class="grid two">
        <asp:Repeater ID="AttemptList" runat="server" OnItemDataBound="AttemptList_ItemDataBound">
            <ItemTemplate>
                <article class="card">
                    <div class="row">
                        <div>
                            <h3>
                                <asp:Label ID="TopicTitle" runat="server" /></h3>
                            <p>
                                <asp:Label ID="ScoreText" runat="server" /></p>
                            <p class="muted">
                                <asp:Label ID="AttemptDate" runat="server" /></p>
                        </div>
                        <asp:HyperLink ID="RetakeLink" runat="server" CssClass="button secondary small" Text="Try again" />
                    </div>
                </article>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
