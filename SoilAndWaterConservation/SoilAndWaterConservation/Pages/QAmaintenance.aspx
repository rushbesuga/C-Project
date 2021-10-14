<%@ Page Title="水土保持常見問答維護" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="QAmaintenance.aspx.cs" Inherits="Pages_QAmaintenance" %>

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
            loadmaintenancejqgrid();
        })

    </script>
    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">水土保持常見問答維護</a>
        </div>
        <div class="col-md-12 " style="margin-bottom: 10px;">
            <div class="col-md-12 " style="margin-bottom: 10px;">
                <div class="col-md-2" style="margin-bottom: 10px;">
                    <label>關鍵字：</label>
                </div>
                <div class="col-md-3" style="margin-bottom: 10px;">
                    <input type="text" id="filter">
                </div>
                <div class="col-md-7 right" style="margin-bottom: 10px;">
                    <input type="radio" id="rdproc" value="2" name="procflag" />
                    <label>全部</label>
                    <input type="radio" value="0" name="procflag" />
                    <label>已處理</label>
                    <input type="radio" value="1" name="procflag" />
                    <label>未處理</label>
                </div>
            </div>
            <div class="col-md-12" style="margin-bottom: 10px;">
                <div class="col-md-2 " style="margin-bottom: 10px;">
                    <label>日期：</label>
                </div>
                <div class="col-md-3" style="margin-bottom: 10px;">
                    <input type="date" id="date">
                </div>
                <div class="col-md-7 " style="margin-bottom: 10px;">
                    <input type="button" class="" style="" value="送出查詢" onclick="searchmaintenancedata()" />
                </div>
            </div>
            <div class="col-md-12 " style="margin-bottom: 10px;">
                <table id="QAGrid"></table>
                <div id="pager"></div>
            </div>
        </div>
    </div>

</asp:Content>

