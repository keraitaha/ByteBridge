<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Log in - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link" href="Default.aspx">Back to home</a>
    <section class="panel narrow">
        <h1>Welcome back.</h1>
        <p>Log in to your learning space.</p>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="Email">Email address</asp:Label>
            <asp:TextBox ID="Email" runat="server" TextMode="Email" MaxLength="254" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" ValidationGroup="Login" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter your email address." Text="Enter your email address." />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="Email" ValidationGroup="Login" Display="Dynamic" CssClass="field-error" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Enter a valid email address." Text="Enter a valid email address." />
        </div>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
            <asp:TextBox ID="Password" runat="server" TextMode="Password" MaxLength="128" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" ValidationGroup="Login" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter your password." Text="Enter your password." />
        </div>
        <asp:Button ID="LoginButton" runat="server" Text="Log in" OnClick="Login_Click" ValidationGroup="Login" />
        <div class="actions">
            <a href="Register.aspx">New here? Create an account</a>
        </div>
    </section>
</asp:Content>
