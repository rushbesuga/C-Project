<%@ Page Title="水土保持常見問答 我要發問" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="CheckQA.aspx.cs" Inherits="Pages_CheckQA" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <link href="../css/table.css" rel="stylesheet" />
    <script src='/Scripts/QAandMessageBoard.js' type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            getQAandMessageBoardDetail();
        })
    </script>
    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">Q&A</a>
        </div>
          <div class="col-md-12 div-center" style="margin-bottom: 10px; ">
        <div class="col-md-12 div-center" style="margin-bottom: 10px;border-radius:10px ;background-color:#E9E6E6">
              <a class="div-cal-main-title">民眾問題</a>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">

                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center; ">
                    編號:
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <input type="text" readonly="readonly" id="tbid" style="background-color: grey;" />
                </div>

            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">

                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center; ">
                    姓名(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <input type="text" readonly="readonly" id="tbname" style="background-color: grey;" />
                    <input type="radio" id="rbmale" name="sex" onclick="return false" />
                    <label>先生</label>
                    <input type="radio" id="rbfeamle" name="sex" onclick="return false" />
                    <label>小姐</label>
                </div>

            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center; ">
                    聯絡人電話(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <input type="text" readonly="readonly" id="tbphone" style="background-color: grey;" />
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center;">
                    電子信箱(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <input type="text" readonly="readonly" id="tbemail" style="background-color: grey;" />
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center;">
                    信件主旨(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <input type="text" readonly="readonly" id="tbemailtitle" style="background-color: grey;" />
                </div>
            </div>
            <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                <div class="col-md-1" style="font-size: 20px; text-align: right">
                </div>
                <div class="col-md-4" style="font-size: 20px; text-align: center; ">
                    問題內容(*必填):
                </div>
                <div class="col-md-7" style="font-size: 20px; text-align: left">
                    <input type="text" readonly="readonly" id="tbcontent" style="min-height: 150px; min-width: 200px; background-color: grey;" />
                </div>
            </div>
            </div >
            <div class="col-md-12 div-center" style="margin-bottom: 10px;  border-radius:10px ;background-color:#B0AAA8">
                 <a class="div-cal-main-title">客服人員回覆</a>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        回復時間:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbrecovery_time" style="min-width: 200px" />
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        回復人員:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbrecovery_name" style="min-width: 200px" />
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        回復主旨:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbrecovery_title" style="min-width: 200px" />
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        回覆內容:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbrecovery_content" style="min-height: 150px; min-width: 200px" />
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        公開回覆:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="radio" id="rbpublic" name="public" value="0" />
                        <label>公開回覆</label>
                        <input type="radio" id="rbunpublic" name="public" value="1" />
                        <label>不公開回覆</label><br>
                        <input type="radio" id="rbprocflag" name="flag" value="0" />
                        <label>已處理</label>
                        <input type="radio" id="rbunprocflag" name="flag" value="1" />
                        <label>未處理</label>
                    </div>
                </div>

                <div class="col-md-12 div-center" style="margin-bottom: 10px; font-size: 20px">
                    <input type="button" id="btnsendemail" style="background-color: lightseagreen;" value="發送郵件" />
                    <input type="button" id="btnsend" style="background-color: lightseagreen;" value="儲存" onclick="saveReplyQA()" />
                    <input type="button" id="btnclear" style="background-color: grey;" value="取消" onclick="location.href = 'QAmaintenance.aspx'" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
