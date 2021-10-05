<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="SendQA.aspx.cs" Inherits="Pages_SendQA" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script src='/Scripts/QAandMessageBoard.js' type="text/javascript"></script>
  
    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">Q&A</a>
        </div>
        <div class="col-md-12 div-center" style="margin-bottom: 10px;">

            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    姓名(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox id="tbname" runat="server" style="min-width: 70%"/>
                    <asp:RadioButton id="rbmale" runat="server" GroupName="sex"  style="min-width: 15%"/>
                    <label>先生</label>
                    <asp:RadioButton id="rbfeamle" runat="server" GroupName="sex"  style="min-width: 15%"/>
                    <label>小姐</label>
                </div>

            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    聯絡人電話(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="tbphone" runat="server" style="min-width: 100%"/>
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    電子信箱(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="tbemail" runat="server" style="min-width: 100%"/>
                </div>
            </div>
              <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
            <div class="col-md-4" style="font-size: 20px; text-align: center;">
                信件主旨(*必填):
            </div>
            <div class="col-md-7" style="font-size: 20px; text-align: left">
                <asp:TextBox ID="tbemailtitle" runat="server" style="min-width: 100%"/>
            </div>
                  </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                  <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    問題內容(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="tbcontent" runat="server" style="min-height: 150px; min-width: 100%"/>
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                  <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div  class="col-md-4" style="font-size: 20px; text-align: center">
                    <asp:Label runat="server">驗證碼</asp:Label>
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="txtCheck" runat="server" class="form-control" placeholder="請輸入驗證碼"></asp:TextBox>
                    <img id="imgValidate" class="img-fluid" src="../Service/Validation.ashx" alt="" />
                    <button onclick="return reloadcode();" class="fas fa-sync-alt"></button>
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px; font-size:20px">
                <asp:Button runat="server"  id="btnsend" style="background-color: lightseagreen;" text="完成送出" onclick="btnsend_Click"  />
                <asp:Button runat="server" id="btnclear" style="background-color: grey;" text="重新輸入" onclick="btnclear_Click" />
            </div>
        </div>
    </div>

</asp:Content>
