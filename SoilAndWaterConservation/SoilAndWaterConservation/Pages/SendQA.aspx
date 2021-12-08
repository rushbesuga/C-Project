<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="SendQA.aspx.cs" Inherits="Pages_SendQA" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script src='/Scripts/QAandMessageBoard.js' type="text/javascript"></script>

    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">水土保持常見問答-我要發問</a>
        </div>
        <div class="col-md-12 div-center" style="margin-bottom: 10px;">

            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    姓名(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="tbname" runat="server" Style="min-width: 70%" />
                    <asp:RadioButton ID="rbmale" runat="server" GroupName="sex" Style="min-width: 15%" />
                    <label>先生</label>
                    <asp:RadioButton ID="rbfeamle" runat="server" GroupName="sex" Style="min-width: 15%" />
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
                    <asp:TextBox ID="tbphone" runat="server" Style="min-width: 100%" />
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    電子信箱(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="tbemail" runat="server" Style="min-width: 100%" />
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center;">
                    信件主旨(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="tbemailtitle" runat="server" Style="min-width: 100%" />
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    問題內容(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <textarea id="tbcontent" runat="server" style="min-height: 150px; min-width: 100%">
                        </textarea>
                </div>

            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    是否公開:
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:RadioButton ID="rbpublic" runat="server" GroupName="rbpublic" text="公開問答"/>
                    <asp:RadioButton ID="rbunpublic" runat="server" GroupName="rbpublic" text="不公開問答" />
                    &nbsp<label style="color:darkred"> ※如選擇公開回答待管理者回覆後才顯示內容 </label>
                    <%--<input type="radio" id="rbpublic" name="public" value="0" />
                    <label>公開問答</label>
                    <input type="radio" id="rbunpublic" name="public" value="1" checked/>
                    <label>不公開問答</label><br>--%>
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center">
                    <asp:Label runat="server">驗證碼</asp:Label>
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <asp:TextBox ID="txtCheck" runat="server" class="form-control" placeholder="請輸入驗證碼"></asp:TextBox>
                    <img id="imgValidate" class="img-fluid" src="../Service/Validation.ashx" alt="" />
                    <button onclick="return reloadcode();" class="fas fa-sync-alt"></button>
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px; font-size: 20px">
                <asp:Button runat="server" ID="btnsend" Style="background-color: lightseagreen;" Text="完成送出" OnClick="btnsend_Click" />
                <asp:Button runat="server" ID="btnclear" Style="background-color: grey;" Text="重新輸入" OnClick="btnclear_Click" />
            </div>
        </div>
    </div>

</asp:Content>
