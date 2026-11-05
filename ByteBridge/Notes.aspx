<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Notes.aspx.cs" Inherits="Notes" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Notes - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link button secondary small" href="Dashboard.aspx">Back to dashboard</a>
    <div class="page-heading">
        <h1>A place for your own words</h1>
        <p class="muted">Keep a thought, or connect a note to a lesson.</p>
    </div>
    <asp:Panel ID="EditorPanel" runat="server" CssClass="panel">
        <h2>
            <asp:Label ID="EditorHeading" runat="server" Text="Write a note" /></h2>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="NoteTitle" Text="Title" />
            <asp:TextBox ID="NoteTitle" runat="server" MaxLength="100" />
        </div>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="NoteBody" Text="Your note" />
            <asp:TextBox ID="NoteBody" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="5" />
        </div>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="LessonChoice" Text="Related lesson (optional)" />
            <asp:DropDownList ID="LessonChoice" runat="server" />
        </div>
        <div class="actions">
            <asp:Button ID="SaveNote" runat="server" Text="Save note" OnClick="SaveNote_Click" />
            <a class="button secondary" href="Notes.aspx">Clear / cancel</a>
        </div>
    </asp:Panel>
    <div class="section-heading">
        <h2>Your notes</h2>
    </div>
    <asp:Label ID="EmptyNotes" runat="server" CssClass="empty" Text="Your first note can start with one sentence." />
    <div class="grid two">
        <asp:Repeater ID="NoteList" runat="server" OnItemDataBound="NoteList_ItemDataBound" OnItemCommand="NoteList_ItemCommand">
            <ItemTemplate>
                <article class="card">
                    <p class="muted">
                        <asp:Label ID="RelatedLesson" runat="server" /></p>
                    <h3>
                        <asp:Label ID="SavedTitle" runat="server" /></h3>
                    <p class="lesson-text">
                        <asp:Label ID="SavedBody" runat="server" /></p>
                    <div class="record-actions">
                        <asp:HyperLink ID="EditLink" runat="server" CssClass="button secondary small" Text="Edit" />
                        <asp:LinkButton ID="DeleteLink" runat="server" CommandName="Remove" CssClass="button danger small" Text="Delete" data-confirm="Delete this note? This cannot be undone." />
                    </div>
                </article>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
