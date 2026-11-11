<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="Quizzes" %>

<asp:Content ID="TitleBlock" ContentPlaceHolderID="TitleContent" runat="server">Quizzes - ByteBridge</asp:Content>
<asp:Content ID="MainBlock" ContentPlaceHolderID="MainContent" runat="server">
    <a class="back-link" href="Paths.aspx">Back to lessons</a>
    <asp:Panel ID="CatalogPanel" runat="server">
        <h1>A quick check of what you know.</h1>
        <p>No timer. No pressure. Every attempt is a chance to learn.</p>
        <div class="grid three">
            <asp:Repeater ID="QuizList" runat="server" OnItemDataBound="Quiz_Bound">
                <ItemTemplate>
                    <article class="card">
                        <h3>
                            <asp:Literal ID="TopicTitle" runat="server" Mode="Encode" /></h3>
                        <p>
                            <asp:Literal ID="QuestionCount" runat="server" Mode="Encode" />
                            multiple-choice questions</p>
                        <asp:HyperLink ID="StartLink" runat="server" CssClass="button">Start quiz</asp:HyperLink>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
    <asp:Panel ID="QuizPanel" runat="server">
        <h1>
            <asp:Literal ID="QuizTitle" runat="server" Mode="Encode" /></h1>
        <p>Choose one answer for each question. The server calculates and saves your result.</p>
        <asp:Repeater ID="QuestionList" runat="server" OnItemDataBound="Question_Bound">
            <ItemTemplate>
                <fieldset class="question panel">
                    <legend>
                        <asp:Literal ID="Prompt" runat="server" Mode="Encode" /></legend>
                    <asp:RadioButtonList ID="Choices" runat="server" CssClass="quiz-options" RepeatLayout="Flow" />
                </fieldset>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Button ID="SubmitQuiz" runat="server" Text="Check my answers" OnClick="Submit_Click" />
    </asp:Panel>
</asp:Content>
