<%@ Page Title="管理人員登入" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Account_Login" Async="true" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <script>
        $(document).ready(function () {
            $("#MainContent_txtCheck").on('keyup', function (e) {
                if (e.key === 'Enter' || e.keyCode === 13) {
                    $("#MainContent_btnLogin").click();
                }
            });
        })
    </script>
    <h2 class="col-md-12 div-center"><%: Title %></h2>

    <div class="row">
        <div class="col-md-12">
            <section id="loginForm">
                <div class="form-horizontal" style="font-size: 16px">
                    <asp:PlaceHolder runat="server" ID="ErrorMessage" Visible="false">
                        <p class="text-danger">
                            <asp:Literal runat="server" ID="FailureText" />
                        </p>
                    </asp:PlaceHolder>
                    <div class="form-group" style="font-size: 20px">
                        <asp:Label runat="server" AssociatedControlID="UserName" CssClass="col-md-5 control-label">帳號</asp:Label>
                        <div class="col-md-7" style="font-size: 20px">
                            <asp:TextBox runat="server" ID="UserName" CssClass="form-control" placeholder="請輸入管理者帳號" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="UserName"
                                CssClass="text-danger" ErrorMessage="必須填寫使用者名稱欄位。" />
                        </div>
                    </div>
                    <div class="form-group" style="font-size: 20px">
                        <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-5 control-label">密碼</asp:Label>
                        <div class="col-md-7" style="font-size: 20px">
                            <asp:TextBox runat="server" ID="Password" TextMode="Password" CssClass="form-control" placeholder="請輸入密碼" />
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="Password" CssClass="text-danger" ErrorMessage="必須填寫密碼欄位。" />
                        </div>
                    </div>
                    <div class="form-group" style="font-size: 20px">
                        <asp:Label runat="server" AssociatedControlID="Password" CssClass="col-md-5 control-label">驗證碼</asp:Label>
                        <div class="col-md-7">
                            <div class="col">
                                <asp:TextBox ID="txtCheck" runat="server" class="form-control" placeholder="請輸入驗證碼"></asp:TextBox>
                            </div>
                            <div>
                                <img id="imgValidate" class="img-fluid" src="../Service/Validation.ashx" alt="" />
                                <button onclick="return reloadcode();" class="fas fa-sync-alt"></button>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-md-offset-5 col-md-7">
                            <asp:Button runat="server" ID="btnLogin" OnClick="LogIn" Text="登入" CssClass="btn btn-primary" />
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</asp:Content>

