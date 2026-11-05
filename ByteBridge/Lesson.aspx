<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Lesson.aspx.cs" Inherits="Lesson" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Study a lesson - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link" href="Paths.aspx">Back to lessons</a>
    <asp:Panel ID="LessonPanel" runat="server" CssClass="panel lesson">
        <p class="badge">
            <asp:Literal ID="PathTitle" runat="server" Mode="Encode" /></p>
        <h1>
            <asp:Literal ID="LessonTitle" runat="server" Mode="Encode" /></h1>
        <p>
            <asp:Literal ID="Summary" runat="server" Mode="Encode" /></p>
        <asp:Panel ID="MemberContent" runat="server">
            <div class="lesson-text">
                <asp:Literal ID="Body" runat="server" Mode="Encode" /></div>
            <h2>See it in code</h2>
            <pre><code><asp:Literal ID="Code" runat="server" Mode="Encode"/></code></pre>
            <p class="notice">
                <asp:Literal ID="Reminder" runat="server" Mode="Encode" /></p>
        </asp:Panel>
        <asp:Panel ID="PreviewPanel" runat="server" CssClass="notice">
            <p>This is a lesson preview. Log in for the full explanation and code.</p>
            <a href="Login.aspx" class="button">Log in to continue</a>
        </asp:Panel>
        <asp:Panel ID="CompletePanel" runat="server">
            <h2>How did that feel?</h2>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="Confidence">Your confidence</asp:Label>
                <asp:DropDownList ID="Confidence" runat="server">
                    <asp:ListItem Value="0">Choose confidence</asp:ListItem>
                    <asp:ListItem Value="1">1 / 5 - just starting</asp:ListItem>
                    <asp:ListItem Value="2">2 / 5</asp:ListItem>
                    <asp:ListItem Value="3">3 / 5</asp:ListItem>
                    <asp:ListItem Value="4">4 / 5</asp:ListItem>
                    <asp:ListItem Value="5">5 / 5 - feeling confident</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="actions">
                <asp:Button ID="CompleteButton" runat="server" Text="Mark lesson complete" OnClick="Complete_Click" />
                <asp:HyperLink ID="PracticeLink" runat="server" CssClass="button secondary">Practice this skill</asp:HyperLink>
            </div>
        </asp:Panel>
    </asp:Panel>
</asp:Content>
