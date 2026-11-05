<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Default" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Welcome - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <section class="hero">
        <div class="hero-copy">
            <h1>Build your understanding. One small lesson at a time.</h1>
            <p>Short lessons, tiny coding challenges and a skill tree that grows with you. Learn the web by making sense of its building blocks.</p>
            <div class="actions">
                <a class="button" href="Paths.aspx">Start learning</a>
                <a class="button secondary" href="Practice.aspx">Explore your skill tree</a>
            </div>
        </div>
        <div class="hero-example">
            <p>A little code. A new beginning.</p>
            <pre><code>&lt;main&gt;
  &lt;h1&gt;Hello, world.&lt;/h1&gt;
  &lt;p&gt;I made this.&lt;/p&gt;
&lt;/main&gt;</code></pre>
            <p>Read it. Try it. Explain it in your own words.</p>
        </div>
    </section>
    <div class="section-heading">
        <h2>Choose your starting point</h2>
    </div>
    <div class="grid three">
        <asp:Repeater ID="TopicList" runat="server" OnItemDataBound="Topic_Bound">
            <ItemTemplate>
                <article class="card path-card">
                    <asp:Image ID="TopicImage" runat="server" CssClass="topic-image" Width="64" Height="64" />
                    <h3>
                        <asp:Literal ID="TopicTitle" runat="server" Mode="Encode" /></h3>
                    <p>
                        <asp:Literal ID="TopicDescription" runat="server" Mode="Encode" />
                    </p>
                    <asp:HyperLink ID="TopicLink" runat="server" CssClass="button secondary">View lessons</asp:HyperLink>
                </article>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <section class="flow">
        <div class="step">
            <h3>Understand</h3>
            <p>A short explanation and a code example give each idea a shape.</p>
        </div>
        <div class="step">
            <h3>Practice</h3>
            <p>Complete small exercises, revisit mistakes and unlock the next skill.</p>
        </div>
        <div class="step">
            <h3>Explain</h3>
            <p>Teach the idea back to yourself. Knowing why matters as much as getting it right.</p>
        </div>
    </section>
</asp:Content>
