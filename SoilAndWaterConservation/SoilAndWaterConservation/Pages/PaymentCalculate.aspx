<%@ Page Title="水土保持金工程相關費用試算" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="PaymentCalculate.aspx.cs" Inherits="Pages_PaymentCalculate" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="../Scripts/PaymentCalculate.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            getDevOption();
        })

    </script>
    <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
        <a class="div-cal-main-title">水土保持金工程相關費用試算</a>
    </div>
    <div class="row content-text">
        <div class="col-md-12 div-center div-card">
            <div class="col-md-12  div-cal-title">
                <i class="fas fa-award"></i>
                水土保持計畫書審查費<i class="fas fa-award"></i>
            </div>
            <div class="col-md-4 div-left">
                開發面積(公頃)
            </div>
            <div class="col-md-6 div-center">
                <input type="text" id="txbPlanArea" style="min-width:100%;"/>
            </div>
            <div class="col-md-2 div-center">
                <input type="button" value="開始計算" onclick="getPlanAuditCalPrice();" />
            </div>

            <div class="col-md-12 div-left">
                試算金額：需新台幣
                <label id="plan_audit_cal_price" style="color: red;"></label>
                元
            </div>
        </div>


        <div class="col-md-12 div-center div-card">
            <div class="col-md-12  div-cal-title">
                <i class="fas fa-award"></i>
                水土保持規劃書審查費<i class="fas fa-award"></i>
            </div>
            <div class="col-md-4 div-left">
                開發面積(公頃)
            </div>
            <div class="col-md-6 div-center">
                <input type="text" id="txbPlanningArea" style="min-width:100%;" />
            </div>
            <div class="col-md-2 div-center">
                <input type="button" value="開始計算" onclick="getPlanningAuditCalPrice();" />
            </div>

            <div class="col-md-12 div-left">
                試算金額：需新台幣
                <label id="planning_audit_cal_price" style="color: red"></label>
                元
            </div>
        </div>
        <div class="col-md-12 div-center div-card">
            <div class="col-md-12 div-cal-title">
                <i class="fas fa-award"></i>
                水土保持保證金<i class="fas fa-award"></i>
            </div>
            <div class="col-md-4 div-left">
                水土保持計畫總工程造價
            </div>
            <div class="col-md-6 div-center">
                <input type="text" id="dev_total_amount" style="min-width:100%;" />
            </div>
            <div class="col-md-2 div-left">
                元
            </div>
            <div class="col-md-4 div-left">
                開發利用類別
            </div>
            <div class="col-md-6 div-center">
                <select id="dl_dev_type" style="min-width:100%;">
                    <option>請選擇開發類別</option>
                </select>
            </div>
            <div class="col-md-2 div-center">
                <input type="button" value="開始計算" onclick="getDevCalPrice();" />
            </div>

            <div class="col-md-12 div-left">
                試算金額：共需新台幣
                <label id="dev_cal_price" style="color: red"></label>
                元
            </div>

            <div class="col-md-12 div-left">
                <table border="1" style="width: 100%">
                    <tr>
                        <td style="font-size: smaller">
                            <p>
                                ※ 計算方式依據「水土保持保證金繳納及保管運用辦法」辦理。
                            </p>
                            <p>
                                ※ 水土保持保證金=主管機關核定之水土保持計畫總工程造價*比例額度。(應繳納之比例額度)
                            </p>
                            <p>
                                ※ 水土保持計畫經主管機關核定分期施工者，其保證金，依核定之各期水土保持計畫工程造價之一定比例額度計算。
                            </p>
                            <p>
                                ※ 應繳保證金之數額計算至新台幣萬元為止，未滿萬元部分不計。
                            </p>
                            <p style="color:red">
                                水土保持計畫由各級政府機關、國營事業機構或公立學校興辦者，免繳納保證金
                            </p>
                        </td>
                    </tr>
                </table>
                <br/>
            </div>
        </div>
        <div class="col-md-12 div-center div-card">
            <div class="col-md-12  div-cal-title">
                <i class="fas fa-award"></i>
                計畫變更審查費<i class="fas fa-award"></i>
            </div>
            <div class="col-md-4 div-left">
                原審查費
            </div>
            <div class="col-md-6 div-center">
                <input type="text" id="txbAuditOriginalPrice" style="min-width:100%;"/>
            </div>
            <div class="col-md-2 div-left">
                元
            </div>
            <div class="col-md-4 div-left">
                原工程造價
            </div>
            <div class="col-md-6 div-center">
                <input type="text" id="txbMakeOriginalPrice" style="min-width:100%;" />
            </div>
            <div class="col-md-2 div-left">
                元
            </div>
            <div class="col-md-4 div-left">
                變更工程造價
            </div>
            <div class="col-md-6 div-center">
                <input type="text" id="txbChangeMakePrice" style="min-width:100%;" />
            </div>
            <div class="col-md-2 div-left">
                元
            </div>
            <div class="col-md-10 div-left">
                試算金額：需新台幣
                <label id="plan_change_cal_price" style="color: red"></label>
                元
            </div>
            <div class="col-md-2 div-center">
                <input type="button" value="開始計算" onclick="getPlanChangeCalPrice();" />
            </div>
            <div class="col-md-12 div-left">
                <table border="1" style="width: 100%">
                    <tr>
                        <td style="font-size: smaller">
                            <p>
                                ※ 計算方式依據「水土保持計畫審查收費標準」第二條規定辦理。
                            </p>
                        </td>
                    </tr>
                </table>
                <br/>
            </div>

        </div>
        

        <div class="row">
        </div>
</asp:Content>


