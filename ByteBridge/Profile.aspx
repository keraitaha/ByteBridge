<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="MemberProfile" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Profile - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link button secondary small" href="Dashboard.aspx">Back to dashboard</a>
    <section class="narrow panel">
        <div class="page-heading">
            <h1>Your account</h1>
            <p class="muted">Update the name shown in your study space.</p>
        </div>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="EmailAddress" Text="Email address" />
            <asp:TextBox ID="EmailAddress" runat="server" ReadOnly="true" />
        </div>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="NameInput" Text="Display name" />
            <asp:TextBox ID="NameInput" runat="server" MaxLength="60" />
        </div>
        <asp:Button ID="SaveProfile" runat="server" Text="Save display name" OnClick="SaveProfile_Click" />
        <div class="actions">
            <a class="button secondary" href="Results.aspx">Quiz history</a>
            <a class="button secondary" href="Flashcards.aspx">Flashcards</a>
            <asp:HyperLink ID="AdminLink" runat="server" NavigateUrl="Admin.aspx" Text="Admin studio" CssClass="button secondary" />
        </div>
    </section>
</asp:Content>
