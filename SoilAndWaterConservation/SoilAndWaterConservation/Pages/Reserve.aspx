<%@ Page Title="水土保持服務團諮詢預約" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Reserve.aspx.cs" Inherits="Pages_Reserve" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript" src="../Scripts/Reserve.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            getTownOption('dl_town');
            genCalendarDate(nowdate);
            
            $('#tbReserveContent').val('');
            $('#ReserveCalendar').show();
            $('#ReserveDetail').hide();
        })

    </script>
    <div id="ReserveCalendar">
        <div class="jumbotron div-center div-cal-title" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            水土保持服務團諮詢預約
        </div>
        <div class="container-fluid">
            <div class="col-md-12 div-center" style="font-size: 26px">
                <span>所在公所：</span><select id="dl_town" style="width: 100%" onchange="genCalendarDate('now')">
                </select>
            </div>
            <div class="col-md-4 div-center">
                <span style="cursor: pointer; font-size: 26px" onclick="genCalendarDate('pre')"><i class="fas fa-arrow-circle-left"></i>上一周</span>
            </div>
            <div class="col-md-4 div-center">
                <span style="cursor: pointer; font-size: 26px" onclick="genCalendarDate('now')"><i class="fas fa-home"></i>本周</span>
            </div>
            <div class="col-md-4 div-center">
                <span style="cursor: pointer; font-size: 26px" onclick="genCalendarDate('next')">下一周<i class="fas fa-arrow-circle-right"></i></span>
            </div>
            <table class="reserve-table">
                <tbody>
                    <tr>
                        <td class="reserve-td-column-week">
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span style="font-size: 18pt; color: white; font-weight: bold;">時段</span>
                            </p>
                        </td>
                        <td class="reserve-td-column-week">
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span style="font-size: 18pt; color: white; font-weight: bold;">星期一</span>
                            </p>
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span id="Dayoftheweek1Date" style="font-size: 18pt; font-family: Calibri; color: white; font-weight: bold;"></span>
                            </p>
                        </td>
                        <td class="reserve-td-column-week">
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span style="font-size: 18pt; color: white; font-weight: bold;">星期二</span>
                            </p>
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span id="Dayoftheweek2Date" style="font-size: 18pt; font-family: Calibri; color: white; font-weight: bold;"></span>
                            </p>
                        </td>
                        <td class="reserve-td-column-week">
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span style="font-size: 18pt; color: white; font-weight: bold;">星期三</span>
                            </p>
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span id="Dayoftheweek3Date" style="font-size: 18pt; font-family: Calibri; color: white; font-weight: bold;"></span>
                            </p>
                        </td>
                        <td class="reserve-td-column-week">
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span style="font-size: 18pt; color: white; font-weight: bold;">星期四</span>
                            </p>
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span id="Dayoftheweek4Date" style="font-size: 18pt; font-family: Calibri; color: white; font-weight: bold;"></span>
                            </p>
                        </td>
                        <td class="reserve-td-column-week">
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span style="font-size: 18pt; color: white; font-weight: bold;">星期五</span>
                            </p>
                            <p style="margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;">
                                <span id="Dayoftheweek5Date" style="font-size: 18pt; font-family: Calibri; color: white; font-weight: bold;"></span>
                            </p>
                        </td>
                    </tr>
                    <tr id="tr-calendar_morning">
                    </tr>
                    <tr id="tr-calendar_afternoon">
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="ReserveDetail">
        <div class="jumbotron div-center div-cal-title" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            水土保持服務團諮詢預約
        </div>
        <div class="container-fluid">
            <div class="col-md-12 div-center" style="font-size: 26px">
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center;">
                        預約日期:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbReserveDate" readonly="readonly" style="background-color: lightgray;min-width: 100%;"  />
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        預約時段:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <select id="dlReserveTimeType" style="min-width: 100%;">
                        </select>
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        *預約人:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbReservePerson" style="min-width: 100%;"/>
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        *連絡電話:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbReservePhone" style="min-width: 100%;"/>
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        電子郵件:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" id="tbReserveMail" style="min-width: 100%;" />
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        地點:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="text" readonly="readonly" id="tbReserveTown" style="background-color: lightgray;min-width: 100%;"  />
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <div class="col-md-1" style="font-size: 20px; text-align: right">
                    </div>
                    <div class="col-md-4" style="font-size: 20px; text-align: center">
                        *諮詢事項類別:
                    </div>
                    <div class="col-md-7" style="font-size: 20px; text-align: left">
                        <input type="checkbox" id="cbReserveItemType1" class="cbReserveItemType" value="水土保持申請程序諮詢">
                        <label for="cbReserveItemType1">水土保持申請程序諮詢</label>
                        <input type="checkbox" id="cbReserveItemType2" class="cbReserveItemType" value="水土保持處理技術輔導">
                        <label for="cbReserveItemType2">水土保持處理技術輔導</label><br />
                        <input type="checkbox" id="cbReserveItemType3" class="cbReserveItemType" value="水土保持設施檢查輔導">
                        <label for="cbReserveItemType3">水土保持設施檢查輔導</label>
                        <input type="checkbox" id="cbReserveItemType4" class="cbReserveItemType" value="水土保持違規改正輔導">
                        <label for="cbReserveItemType4">水土保持違規改正輔導</label><br />
                        <input type="checkbox" id="cbReserveItemType5" class="cbReserveItemType" value="山坡地災害之搶修輔導">
                        <label for="cbReserveItemType5">山坡地災害之搶修輔導</label>
                        <input type="checkbox" id="cbReserveItemType6" class="cbReserveItemType" value="山坡地地質諮詢">
                        <label for="cbReserveItemType6">山坡地地質諮詢</label>
                    </div>
                    <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                        <div class="col-md-1" style="font-size: 20px; text-align: right">
                        </div>
                        <div class="col-md-4" style="font-size: 20px; text-align: center">
                            說明:
                        </div>
                        <div class="col-md-7" style="font-size: 20px; text-align: left">
                            <textarea id="tbReserveContent" rows="8" cols="300" style="min-width: 100%;">

                    </textarea>
                        </div>
                        <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                            <div class="col-md-1" style="font-size: 20px; text-align: right">
                            </div>
                            <div class="col-md-4" style="font-size: 20px; text-align: center">
                                <asp:Label runat="server">驗證碼</asp:Label>
                            </div>
                            <div class="col-md-7" style="font-size: 20px; text-align: left">
                                <asp:TextBox ID="tbCheck" runat="server" class="form-control" placeholder="請輸入驗證碼"></asp:TextBox>
                                <img id="imgValidate" class="img-fluid" src="../Service/Validation.ashx" alt="" />
                                <button onclick="return reloadcode();" class="fas fa-sync-alt"></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12 div-center" style="margin-bottom: 10px;">
                    <input type="button" value="確定預約" onclick="SaveReserve()" />
                    <input type="button" value="取消" onclick="CloseReserveDetail()" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

