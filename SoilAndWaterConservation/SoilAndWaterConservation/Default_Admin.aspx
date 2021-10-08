<%@ Page Title="管理者模式" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default_Admin.aspx.cs" Inherits="_Default_Admin" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-md-4 div-center">
            <a href="Pages/PlanManage"><image class="IndexImage" src="images/admin-default-left.png"></image></a>
        </div>
        <div class="col-md-4 div-center">
            <a href="Pages/ReserveManage"><image class="IndexImage" src="images/admin-default-center.png"></image></a>
        </div>
        <div class="col-md-4 div-center">
            <a href="Pages/PlanUpload"><image class="IndexImage" src="images/admin-default-right.png"></image></a>
        </div>
    </div>
    <div class="row">
        <%--<div class="col-md-4 div-center">
            <a href="Pages/PlanQrcode"><image class="IndexImage" src="images/admin-default-down-left.png"></image></a>
        </div>--%>
        <div class="col-md-6 div-center">
            <a href="Pages/QAMaintenance"><image class="IndexImage" src="images/admin-default-down-center.png"></image></a>
        </div>
        <div class="col-md-6 div-center">
            <a href="Pages/PlanQUeryDownload"><image class="IndexImage" src="images/admin-default-down-right.png"></image></a>
        </div>
    </div>
    <div class="row">
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">項目</th>
                    <th scope="col">核可</th>
                    <th scope="col">完成</th>
                    <th scope="col">未完成</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>簡易水土保持計畫</td>
                    <td><div><img class="led-light" src="images/green-light.gif">件已核可</div></td>
                    <td><div><img class="led-light" src="images/green-light.gif">件已報開工</div></td>
                    <td><div><img class="led-light" src="images/red-light.gif">件未報開工</div></td>
                </tr>
                <tr>
                    <td></td>
                    <td><div></td>
                    <td><div><img class="led-light" src="images/green-light.gif">件已報完工</div></td>
                    <td><div><img class="led-light" src="images/red-light.gif">件未報完工</div></td>
                </tr>
                <tr>
                    <td>諮詢服務</td>
                    <td></td>
                    <td><div><img class="led-light" src="images/green-light.gif">件已處置</div></td>
                    <td><div><img class="led-light" src="images/red-light.gif">件未處置</div></td>
                </tr>
                <tr>
                    <td>民眾問答</td>
                    <td></td>
                    <td><div><img class="led-light" src="images/green-light.gif">件已處置</div></td>
                    <td><div><img class="led-light" src="images/red-light.gif">件未處置</div></td>
                </tr>
                <tr>
                    <td>已上傳簡易水保計畫書</td>
                    <td></td>
                    <td><div><img class="led-light" src="images/green-light.gif">件已完成上傳</div></td>
                    <td></td>
                </tr>
            </tbody>
        </table>
    </div>


</asp:Content>
