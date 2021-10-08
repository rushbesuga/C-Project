<%@ Page Title="產生案件QRCODE" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="PlanQrcode.aspx.cs" Inherits="Pages_PlanQrcode" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript" src="../Scripts/PlanQrcode.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var plan_id = findGetParameter('plan_id');
            GetData(plan_id);
        })

    </script>
    <div id="PlanQrcode">
        <div class="jumbotron div-center div-cal-main-title" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            案件QRCODE
        </div>
        <div class="col-md-12 div-card-2" style="font-size: 20px">
            <table align="center">
                <tr>
                    <td align="right" style="width:120px"><span class="div-left">核定函案號：</span></td>
                    <td align="left"><span id="tbPlanCaseNo"></span></td>
                </tr>
                <tr>
                    <td align="right" style="width:120px"><span class="div-left">案件名稱：</span></td>
                    <td align="left"><span id="tbPlanName"></span></td>
                </tr>
                <tr>
                    <td align="right" style="width:120px"><span class="div-left">核定日期：</span></td>
                    <td align="left"><span id="tbPlanAuditDate"></span></td>
                </tr>
            </table>
            
        </div>

        <div class="col-md-12 div-center" style="font-size: 20px">
            <img id="img_qrcode" src="" />
        </div>
        <div class="col-md-12 div-center" style="font-size: 20px">
            <input type="button" id="btnPrint" value="列印" onclick="PagePrint()" />
            <input type="button" id="btnCancel" value="取消" onclick="CancelPage()" />
        </div>
    </div>
</asp:Content>

