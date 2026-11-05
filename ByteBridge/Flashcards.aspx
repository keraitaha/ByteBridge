<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Flashcards.aspx.cs" Inherits="Flashcards" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Flashcards - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
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
</asp:Content>
