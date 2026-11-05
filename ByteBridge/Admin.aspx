<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Admin" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Admin - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link button secondary small" href="Dashboard.aspx">Back to dashboard</a>
    <div class="page-heading">
        <h1>Content studio</h1>
        <p class="muted">Keep every lesson short, useful and easy to understand.</p>
    </div>
    <nav class="actions">
        <a class="button secondary" href="Admin.aspx">Overview</a>
        <a class="button secondary" href="Admin.aspx?mode=topics">Topics</a>
        <a class="button secondary" href="Admin.aspx?mode=lessons">Lessons</a>
        <a class="button secondary" href="Admin.aspx?mode=questions">Quiz questions</a>
        <a class="button secondary" href="Admin.aspx?mode=users">Users</a>
    </nav>
    <asp:Panel ID="OverviewPanel" runat="server">
        <section class="stats">
            <div class="stat">
                <strong>
                    <asp:Label ID="TopicCount" runat="server" /></strong>Learning paths
            </div>
            <div class="stat">
                <strong>
                    <asp:Label ID="LessonCount" runat="server" /></strong>Lessons
            </div>
            <div class="stat">
                <strong>
                    <asp:Label ID="QuestionCount" runat="server" /></strong>Questions
            </div>
        </section>
        <p class="muted">
            <asp:Label ID="MemberCount" runat="server" />
            registered members</p>
        <section class="panel">
            <h2>A small, complete learning library</h2>
            <p>Use the tabs above to create, edit or remove content. Existing student work is protected: related records must not be deleted accidentally.</p>
        </section>
    </asp:Panel>
    <asp:Panel ID="ManagePanel" runat="server" Visible="false">
        <div class="section-heading">
            <h2>
                <asp:Label ID="ManageHeading" runat="server" /></h2>
            <asp:HyperLink ID="NewLink" runat="server" Text="Create a new record" CssClass="button secondary" />
        </div>
        <asp:Panel ID="TopicEditor" runat="server" CssClass="panel" Visible="false">
            <h3>Topic details</h3>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="TopicTitle" Text="Title" />
                <asp:TextBox ID="TopicTitle" runat="server" MaxLength="80" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="TopicDescription" Text="Description" />
                <asp:TextBox ID="TopicDescription" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="4" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="TopicImage" Text="Topic image (optional)" />
                <asp:FileUpload ID="TopicImage" runat="server" accept=".png,.jpg,.jpeg,.gif,.svg,.webp" />
                <asp:Image ID="CurrentImage" runat="server" Visible="false" CssClass="topic-image" Width="96" Height="96" />
                <p class="muted">PNG, JPG, GIF, SVG or WEBP up to 2 MB</p>
            </div>
            <asp:Button ID="SaveTopic" runat="server" Text="Save topic" OnClick="SaveTopic_Click" />
        </asp:Panel>
        <asp:Panel ID="LessonEditor" runat="server" CssClass="panel" Visible="false">
            <h3>Lesson details</h3>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="LessonTopic" Text="Learning path" />
                <asp:DropDownList ID="LessonTopic" runat="server" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="LessonTitle" Text="Title" />
                <asp:TextBox ID="LessonTitle" runat="server" MaxLength="100" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="LessonSummary" Text="Short summary" />
                <asp:TextBox ID="LessonSummary" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="3" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="LessonBody" Text="Objective and explanation" />
                <asp:TextBox ID="LessonBody" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="7" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="LessonCode" Text="Code example (optional)" />
                <asp:TextBox ID="LessonCode" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="5" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="LessonReminder" Text="Reminder (optional)" />
                <asp:TextBox ID="LessonReminder" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="3" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="LessonOrder" Text="Lesson order (1-99)" />
                <asp:TextBox ID="LessonOrder" runat="server" TextMode="Number" />
            </div>
            <p class="muted">New lessons are independent reading lessons. Existing skill-tree prerequisites are preserved when editing.</p>
            <asp:Button ID="SaveLesson" runat="server" Text="Save lesson" OnClick="SaveLesson_Click" />
        </asp:Panel>
        <asp:Panel ID="QuestionEditor" runat="server" CssClass="panel" Visible="false">
            <h3>Question details</h3>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="QuestionTopic" Text="Learning path" />
                <asp:DropDownList ID="QuestionTopic" runat="server" />
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="QuestionPrompt" Text="Question" />
                <asp:TextBox ID="QuestionPrompt" runat="server" TextMode="MultiLine" ValidateRequestMode="Disabled" Rows="3" />
            </div>
            <div class="form-grid">
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="OptionA" Text="Option A" />
                    <asp:TextBox ID="OptionA" runat="server" MaxLength="200" />
                </div>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="OptionB" Text="Option B" />
                    <asp:TextBox ID="OptionB" runat="server" MaxLength="200" />
                </div>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="OptionC" Text="Option C" />
                    <asp:TextBox ID="OptionC" runat="server" MaxLength="200" />
                </div>
                <div class="field">
                    <asp:Label runat="server" AssociatedControlID="OptionD" Text="Option D" />
                    <asp:TextBox ID="OptionD" runat="server" MaxLength="200" />
                </div>
            </div>
            <div class="field">
                <asp:Label runat="server" AssociatedControlID="CorrectChoice" Text="Correct answer" />
                <asp:DropDownList ID="CorrectChoice" runat="server">
                    <asp:ListItem Value="A">A</asp:ListItem>
                    <asp:ListItem Value="B">B</asp:ListItem>
                    <asp:ListItem Value="C">C</asp:ListItem>
                    <asp:ListItem Value="D">D</asp:ListItem>
                </asp:DropDownList>
            </div>
            <asp:Button ID="SaveQuestion" runat="server" Text="Save question" OnClick="SaveQuestion_Click" />
        </asp:Panel>
        <div class="section-heading">
            <h2>Saved records</h2>
        </div>
        <asp:Label ID="EmptyRecords" runat="server" CssClass="empty" Text="There are no records yet." />
        <section class="panel">
            <asp:Repeater ID="RecordList" runat="server" OnItemDataBound="RecordList_ItemDataBound" OnItemCommand="RecordList_ItemCommand">
                <ItemTemplate>
                    <article class="record">
                        <h3>
                            <asp:Label ID="RecordTitle" runat="server" /></h3>
                        <p class="muted">
                            <asp:Label ID="RecordSummary" runat="server" /></p>
                        <div class="record-actions">
                            <asp:HyperLink ID="EditLink" runat="server" Text="Edit" CssClass="button secondary small" />
                            <asp:LinkButton ID="DeleteLink" runat="server" Text="Delete" CssClass="button danger small" CommandName="Remove" data-confirm="Delete this record? This cannot be undone." />
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </section>
    </asp:Panel>
    <asp:Panel ID="UserPanel" runat="server" Visible="false">
        <div class="section-heading">
            <h2>Manage users</h2>
        </div>
        <p class="muted">Change a member into an administrator or delete an account.</p>
        <asp:Label ID="EmptyUsers" runat="server" CssClass="empty" Text="There are no users yet." Visible="false" />
        <section class="panel">
            <asp:Repeater ID="UserList" runat="server" OnItemDataBound="UserList_ItemDataBound" OnItemCommand="UserList_ItemCommand">
                <ItemTemplate>
                    <article class="record">
                        <h3>
                            <asp:Label ID="UserName" runat="server" /></h3>
                        <p class="muted">
                            <asp:Label ID="UserEmail" runat="server" /></p>
                        <p>Role:
                            <asp:Label ID="UserRole" runat="server" /></p>
                        <div class="record-actions">
                            <asp:LinkButton ID="PromoteLink" runat="server" CssClass="button secondary small" CommandName="MakeAdmin" Text="Make administrator" />
                            <asp:LinkButton ID="DemoteLink" runat="server" CssClass="button secondary small" CommandName="MakeMember" Text="Make member" />
                            <asp:LinkButton ID="DeleteUser" runat="server" CssClass="button danger small" CommandName="RemoveUser" Text="Delete" data-confirm="Delete this user? This cannot be undone." />
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </section>
    </asp:Panel>
</asp:Content>
