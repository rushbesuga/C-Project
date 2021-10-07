<%@ Page Title="水土保持常見問答 我要發問" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="CheckQA.aspx.cs" Inherits="Pages_CheckQA" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <link href="../css/table.css" rel="stylesheet" />
    <script src='/Scripts/QAandMessageBoard.js' type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            getQAandMessageBoardDetail();
        })
    </script>
    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">水土保持常見問答</a>
        </div>
        <div class="col-md-12 div-left" style="margin-bottom: 10px;">
            <div class="col-md-12 div-card-2" style="margin-bottom: 10px; background-color: lightgray; font-size: 25px">
                <label id="title"></label>

            </div>
            <div class="col-md-12 div-left" style="margin-bottom: 10px;">
                <label id="content"></label>
            </div>
            <div class="col-md-12 div-left" style="margin-bottom: 10px; border-top:double">
                <label id="Remark"></label>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px; font-size: 20px;">
                <input type="button" id="btnback" value="回上一頁" onclick="location.href = 'QAandmessageboard.aspx'" />
            </div>
        </div>
    </div>

</asp:Content>
