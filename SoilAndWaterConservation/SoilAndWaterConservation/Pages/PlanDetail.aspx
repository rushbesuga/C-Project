<%@ Page Title="簡易水土保持計畫進度維護" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PlanDetail.aspx.cs" Inherits="Pages_PlanDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript" src="../Scripts/PlanDetail.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
        })

    </script>
    <div id="PlanDetail">
        <div class="jumbotron div-center div-cal-main-title" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            簡易水土保持計畫書申請進度維護
        </div>
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>核定函案號(必)：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbPlanCaseNo" style="min-width: 100%" />
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>案件名稱(必)：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbPlanName" style="min-width: 100%" />
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>核定日期(必)：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbPlanAuditDate" style="min-width: 100%" />
    </div>
    <div class="col-md-12 div-center" style="font-size: 20px">
        <input type="hidden" name="tbPlanId">
        <BR />
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>案件狀態：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbPlanStatus" readonly="readonly" style="min-width: 100%;background-color:lightgray" />
    </div>
    <div class="col-md-3 div-right" style="font-size: 20px">
        <input type="checkbox" id="cbStartWorkExtend1st" class="cbWorkExtend" value="第一次開工展延">
        <label for="cbStartWorkExtend1st">第一次開工展延</label>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbStartWorkExtend1st" style="min-width: 100%;" />
    </div>
    <div class="col-md-3 div-right" style="font-size: 20px">
        <input type="checkbox" id="cbStartWorkExtend2nd" class="cbWorkExtend" value="第二次開工展延">
        <label for="cbStartWorkExtend2nd">第二次開工展延</label>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbStartWorkExtend2nd" style="min-width: 100%;" />
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>申報開工期限：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbStartWorkExpirationDate" readonly="readonly" style="min-width: 100%;background-color:lightgray" />
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>申報開工日期：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbStartWorkDate" style="min-width: 100%;" />
    </div>
    <div class="col-md-3 div-right" style="font-size: 20px">
        <input type="checkbox" id="cbFinishWorkExtendDate1st" class="cbWorkExtend" value="第一次完工展延">
        <label for="cbFinishWorkExtendDate1st">第一次開工展延</label>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbFinishWorkExtendDate1st" style="min-width: 100%;" />
    </div>
    <div class="col-md-3 div-right" style="font-size: 20px">
        <input type="checkbox" id="cbFinishWorkExtendDate2nd" class="cbWorkExtend" value="tbFinishWorkExtendDate2nd">
        <label for="cbFinishWorkExtendDate2nd">第二次開工展延</label>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbFinishWorkExtendDate2nd" style="min-width: 100%;" />
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>申報完工期限：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbFinishWorkExpirationDate" readonly="readonly" style="min-width: 100%;background-color:lightgray" />
    </div>
    <div class="col-md-3 div-right div-card-2" style="font-size: 20px">
        <span>申報完工日期：</span>
    </div>
    <div class="col-md-9 div-center" style="font-size: 20px">
        <input type="text" id="tbFinishWorkDate" style="min-width: 100%;" />
    </div>
    <div class="col-md-12 div-center" style="font-size: 20px">
        <BR />
    </div>
    <div class="col-md-12 div-center" style="font-size: 20px">
        <input type="button" id="btnSavePlan" value="儲存" onclick="SavePlan()" />
        <input type="button" id="btnDelPlan" value="刪除" onclick="DelPlan()" />
        <input type="button" id="btnCancel" value="取消" onclick="ClosePlanDetail()" />
    </div>
</asp:Content>
