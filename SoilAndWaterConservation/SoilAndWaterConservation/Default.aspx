<%@ Page Title="首頁" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron div-center" style="background-color:white;padding-bottom:0px;padding-top:0px">
        <image class="img-responsive" src="images/banner.png"></image>
    </div>

    <div class="row">
        <div class="col-md-4 div-center">
            <a href="Pages/PaymentCalculate"><image class="IndexImage" src="images/user-default-left.png"></image></a>
        </div>
        <div class="col-md-4 div-center">
            <a href="Pages/Reserve"><image class="IndexImage" src="images/user-default-center.png"></image></a>
        </div>
        <div class="col-md-4 div-center">
            <a href="Pages/QAandMessageBoard"><image class="IndexImage" src="images/user-default-right.png"></image></a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4 div-center">
            <a href="https://serv.swcb.gov.tw/" target="_blank">
            <image class="BottomIndexImage " src="images/hyperlink.png" href></image>
                </a>
        </div>
    </div>
</asp:Content>
