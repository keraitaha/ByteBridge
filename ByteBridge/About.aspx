<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="About" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">About - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link" href="Default.aspx">Back to home</a>
    <h1>A bridge to your first website.</h1>
    <section class="panel">
        <h2>Learn without the overwhelm</h2>
        <p>ByteBridge teaches HTML, CSS, JavaScript, C#, ASP.NET and SQL through short lessons, practice questions and reflection. Guests can explore; members save their work; administrators maintain content.</p>
        <h2>A little challenge, a little progress</h2>
        <p>Your skill tree rewards new exercises completed, rather than points for repeating the same answer. You can revisit any unlocked skill. Explanation prompts help you practice describing what code does and why.</p>
        <p>Progress is a practice record, not a promise of mastery. Try explaining a code example without looking, then return to anything you cannot yet describe.</p>
        <div class="actions">
            <a href="Paths.aspx" class="button">Explore lessons</a>
            <a href="Register.aspx" class="button secondary" id="CreateAccountLink" runat="server">Create an account</a>
        </div>
    </section>
</asp:Content>
