<%@ Page Title="水土保持常見問答" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="QAandmessageboard.aspx.cs" Inherits="Pages_QAandMessageBoard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="../Scripts/jquery-ui-1.12.1/jquery-ui.css" rel="stylesheet" />
    <script src="../Scripts/jquery-ui-1.12.1/jquery-ui.min.js"></script>
    <link href="../Scripts/jquery-ui-1.12.1/jquery-ui.theme.min.css" rel="stylesheet" />
    <link href="/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src='/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/js/jquery.jqGrid.min.js' type="text/javascript"></script>
    <script src='/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/js/i18n/grid.locale-tw.js' type="text/javascript"></script>
    <script src='/Scripts/QAandMessageBoard.js' type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            loadjqgrid();
        })

    </script>
    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">水土保持常見問答</a>
        </div>
        <div class="col-md-12 div-right" style="margin-bottom: 10px;">
            <label>關鍵字：</label>
            <input type="text" id="filter">
            <input type="button"  value="送出查詢" onclick="searchdata()" />
            <input type="button" style="margin-bottom:10px" value="清除內容" onclick="clearfilter()" />
            <table id="QAGrid" ></table>
            <div id="pager"></div>
        </div>
        <div class="col-md-12 div-right">
            <input type="button" style="" value="我要發問" onclick="location.href='SendQA.aspx'" />
        </div>
    </div>

</asp:Content>
