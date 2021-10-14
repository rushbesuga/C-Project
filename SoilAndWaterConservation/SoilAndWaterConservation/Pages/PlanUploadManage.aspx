<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="PlanUploadManage.aspx.cs" Inherits="Pages_PlanUploadManage" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField runat="server" ID="hidlevelcontrol" />
    <link href="../Scripts/jquery-ui-1.12.1/jquery-ui.css" rel="stylesheet" />
    <script src="../Scripts/jquery-ui-1.12.1/jquery-ui.min.js"></script>
    <link href="../Scripts/jquery-ui-1.12.1/jquery-ui.theme.min.css" rel="stylesheet" />
    <link href="/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src='/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/js/jquery.jqGrid.min.js' type="text/javascript"></script>
    <script src='/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/js/i18n/grid.locale-tw.js' type="text/javascript"></script>
    <script src='/Scripts/PlanUpload.js' type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            loadjqgrid();
        })

    </script>
    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">簡易水土保持計畫書上傳資料維護-總表</a>
        </div>
        <div class="col-md-12 div-right" style="margin-bottom: 10px;">

            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right">
                    <label>計畫名稱或案號關鍵字</label>
                </div>
                <div class="col-md-9 div-left">
                    <input type="text" id="filter" style="min-width: 100%">
                </div>
            </div>

            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right">
                    <label>上傳起訖時間</label>
                </div>
                <div class="col-md-9 div-left">
                    <input type="date" id="startdate">-
                    <input type="date" id="enddate">
                    <input type="button" value="送出查詢" onclick="reloadgrid()" />
                </div>
            </div>
        </div>
        <div class="col-md-12 div-left">
            <input type="button" id="btnadd" value="新增案件" onclick="location.href = 'PlanUpload.aspx?id=0'" />
        </div>
        <div class="col-md-12" >
            <table id="PlanUploadGrid"></table>
            <div id="pager"></div>
        </div>
        <div class="col-md-12 div-right">
            <input type="button" value="匯出" onclick="exportexcel()">
        </div>

    </div>

</asp:Content>
