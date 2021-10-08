<%@ Page Title="查詢計畫進度" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PlanUserView.aspx.cs" Inherits="Pages_PlanUserView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript" src="../Scripts/PlanUserView.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var plan_id = findGetParameter('plan_id');
            GetData(plan_id);
        })

    </script>
    <div id="PlanDetail">
        <div class="jumbotron div-center div-cal-main-title" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            查詢計畫進度
        </div>
    </div>
    <div class="col-md-12 div-right div-card-2" style="font-size: 20px">
        <table align="center">
                <tr>
                    <td align="right" style="width:150px"><span class="div-left">核定函案號：</span></td>
                    <td align="left"><span id="tbPlanCaseNo"></span></td>
                    <td align="left"></td>
                </tr>
                <tr>
                    <td align="right" style="width:150px"><span class="div-left">案件名稱：</span></td>
                    <td align="left"><span id="tbPlanName"></span></td>
                    <td align="left"></td>
                </tr>
                <tr>
                    <td align="right" style="width:150px"><span class="div-left">核定日期：</span></td>
                    <td align="left"><span id="tbPlanAuditDate"></span></td>
                    <td align="left"></td>
                </tr>
                <tr>
                    <td align="right" style="width:150px"><span class="div-left">案件狀態：</span></td>
                    <td align="left"><span id="tbPlanStatus"></span></td>
                    <td align="left"></td>
                </tr>
                <tr>
                    <td align="right" style="width:150px"><span class="div-left">開工期限：</span></td>
                    <td align="left"><span id="tbStartWorkExpirationDate"></span></td>
                    <td align="right">剩餘天數：<span id="tbStartWorkExpirationRemainingDays"></span></td>
                </tr>
                <tr>
                    <td align="right" style="width:150px"><span class="div-left">完工期限：</span></td>
                    <td align="left"><span id="tbFinishWorkExpirationDate"></span></td>
                    <td align="right">剩餘天數：<span id="tbFinishWorkExpirationRemainingDays"></span></td>
                </tr>
            </table>
    </div>

</asp:Content>

