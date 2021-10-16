<%@ Page Title="簡易水土保持計畫進度維護" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PlanManage.aspx.cs" Inherits="Pages_PlanManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:HiddenField runat="server" ID="hidlevelcontrol" />
    <link href="../Scripts/jquery-ui-1.12.1/jquery-ui.css" rel="stylesheet" />
    <script src="../Scripts/jquery-ui-1.12.1/jquery-ui.min.js"></script>
    <link href="../Scripts/jquery-ui-1.12.1/jquery-ui.theme.min.css" rel="stylesheet" />
    <link href="/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/css/ui.jqgrid.css" rel="stylesheet" type="text/css" />
    <script src='/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/js/jquery.jqGrid.min.js' type="text/javascript"></script>
    <script src='/Scripts/Guriddo_jqGrid_JS_5.5.5-Trial/js/i18n/grid.locale-tw.js' type="text/javascript"></script>
    <script type="text/javascript" src="../Scripts/PlanManage.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            loadjqgrid();
        })

    </script>
    <div id="PlanManage">
        <div class="jumbotron div-center div-cal-main-title" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            簡易水土保持計畫書申請進度維護
        </div>
        <div class="col-md-3 div-right" style="font-size: 20px">
            <span>計畫名稱或案號關鍵字：</span>
        </div>
        <div class="col-md-9 div-center" style="font-size: 20px">
            <input type="text" id="tbKeyword" style="min-width: 100%" />
        </div>
        <div class="col-md-3 div-right" style="font-size: 20px">
            <span>狀態：</span>
        </div>
        <div class="col-md-9 div-left" style="font-size: 20px">
            <input type="checkbox" id="cbPlanStatusItemType1" class="cbPlanStatusItemType" value="已核定">
            <label for="cbPlanStatusItemType1">已核定</label>
            <input type="checkbox" id="cbPlanStatusItemType2" class="cbPlanStatusItemType" value="施工中">
            <label for="cbPlanStatusItemType2">施工中</label>
            <input type="checkbox" id="cbPlanStatusItemType3" class="cbPlanStatusItemType" value="已完工">
            <label for="cbPlanStatusItemType3">已完工</label>
        </div>
        <div class="col-md-3 div-right" style="font-size: 20px;">
            <label>日期類別：</label>
        </div>
        <div class="col-md-8 div-left" style="font-size: 20px;">
            <select id="dl_dev_type">
                <option value="plan_audit_date">核定日</option>
                <option value="plan_start_work_expiration_date">開工期限</option>
                <option value="plan_start_work_date">申報開工日</option>
                <option value="plan_finish_work_expiration_date">完工期限</option>
                <option value="plan_finish_work_date">申報完工日</option>
            </select>
            起始日:
            <input type="date" id="StartDate">
            結束日:
            <input type="date" id="EndDate">
        </div>
        <div class="col-md-1 div-right" style="font-size: 20px;">
            <input type="button" value="查詢" onclick="btnQueryPlanData();" />
        </div>
        <div class="col-md-12 div-right" style="font-size: 20px;">
            <span><br /></span>
        </div>
        <div class="col-md-6 div-right" style="font-size: 20px;">
            <input type="button" style="min-width:100%" value="快查：10日內失效案件" onclick="btnQuickQueryPlanData(10);" />
        </div>
        <div class="col-md-6 div-left" style="font-size: 20px;">
            <input type="button" style="min-width:100%" value="快查：3日內失效案件" onclick="btnQuickQueryPlanData(3);" />
        </div>
        <div class="col-md-12 div-right" style="font-size: 20px;">
            <span><br /></span>
        </div>
        <div class="col-md-12 div-left" style="font-size: 20px;">
            <input type="button" id="btnadd" value="新增" onclick="btnAddPlan();" />
        </div>
        <div class="col-md-12 div-center" style="margin-bottom: 10px;">
            <table id="grid"></table>
            <div id="pager"></div>
        </div>
    </div>
</asp:Content>

