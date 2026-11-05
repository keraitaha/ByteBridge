<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Register" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Sign up - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link" href="Default.aspx">Back to home</a>
    <section class="panel narrow">
        <h1>Your learning starts here.</h1>
        <p>Create a member account to save your progress.</p>
        <asp:ValidationSummary ID="RegisterSummary" runat="server" CssClass="notice error" ValidationGroup="Register" HeaderText="Please fix the following:" />
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="NameInput">Display name</asp:Label>
            <asp:TextBox ID="NameInput" runat="server" MaxLength="60" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="NameInput" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter a display name." Text="Enter a display name." />
        </div>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="Email">Email address</asp:Label>
            <asp:TextBox ID="Email" runat="server" TextMode="Email" MaxLength="254" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="Email" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter your email address." Text="Enter your email address." />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="Email" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Enter a valid email address." Text="Enter a valid email address." />
        </div>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="Password">Password</asp:Label>
            <asp:TextBox ID="Password" runat="server" TextMode="Password" MaxLength="128" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Enter a password." Text="Enter a password." />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="Password" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,128}$" ErrorMessage="Use 6-128 characters with uppercase, lowercase and a number." Text="Use 6-128 characters with uppercase, lowercase and a number." />
        </div>
        <p class="muted">Use at least 6 characters with uppercase, lowercase and a number.</p>
        <div class="field">
            <asp:Label runat="server" AssociatedControlID="ConfirmPassword">Confirm password</asp:Label>
            <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" MaxLength="128" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="ConfirmPassword" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="Confirm your password." Text="Confirm your password." />
            <asp:CompareValidator runat="server" ControlToValidate="ConfirmPassword" ControlToCompare="Password" Operator="Equal" ValidationGroup="Register" Display="Dynamic" CssClass="field-error" ErrorMessage="The passwords do not match." Text="The passwords do not match." />
        </div>
        <asp:Button ID="RegisterButton" runat="server" Text="Create account" OnClick="Register_Click" ValidationGroup="Register" />
        <div class="actions">
            <a href="Login.aspx">Already have an account? Log in</a>
        </div>
    </section>
</asp:Content>
