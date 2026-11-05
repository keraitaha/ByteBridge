<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Paths.aspx.cs" Inherits="Paths" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Lessons - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link" href="Default.aspx">Back to home</a>
    <h1>Find your next small step.</h1>
    <p>Browse every lesson freely. Practice skills unlock as you complete earlier challenges.</p>
    <div class="field">
        <asp:Label runat="server" AssociatedControlID="TopicFilter">Learning path</asp:Label>
        <asp:DropDownList ID="TopicFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed" />
    </div>
    <div class="grid two">
        <asp:Repeater ID="LessonList" runat="server" OnItemDataBound="Lesson_Bound">
            <ItemTemplate>
                <article class="card">
                    <p class="muted">
                        <asp:Literal ID="PathTitle" runat="server" Mode="Encode" />
                    </p>
                    <h3>
                        <asp:Literal ID="LessonTitle" runat="server" Mode="Encode" /></h3>
                    <p>
                        <asp:Literal ID="Summary" runat="server" Mode="Encode" />
                    </p>
                    <asp:HyperLink ID="ReadLink" runat="server" CssClass="button secondary">Read lesson</asp:HyperLink>
                </article>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:Label ID="EmptyMessage" runat="server" Text="No lessons in this path yet." Visible="false" CssClass="empty" />
</asp:Content>
