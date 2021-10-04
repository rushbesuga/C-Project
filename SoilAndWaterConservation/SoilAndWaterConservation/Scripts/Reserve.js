var now = new Date();
var nowdate = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDate()
var week = new Date().getDay();
if (week == 6) {
    now = addDays(now, 2);
    nowdate = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDate()
}
else if (week == 0) {
    now = addDays(now, 1);
    nowdate = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDate()
}
function addDays(date, days) {
    var result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
}

function genCalendarDate(nowdate_) {
    if (nowdate_ == 'next') {
        anowdate = nowdate.split('-');
        nowdate_ = addDays(new Date(anowdate[0], anowdate[1] - 1, anowdate[2]), 7);
        nowdate_ = nowdate_.getFullYear() + '-' + (nowdate_.getMonth() + 1) + '-' + nowdate_.getDate()
    }
    else if (nowdate_ == 'pre') {
        anowdate = nowdate.split('-');
        nowdate_ = addDays(new Date(anowdate[0], anowdate[1] - 1, anowdate[2]), -7);
        nowdate_ = nowdate_.getFullYear() + '-' + (nowdate_.getMonth() + 1) + '-' + nowdate_.getDate()
    }
    else if (nowdate_ == 'now') {
        now = new Date();
        nowdate_ = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDate()
    }
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/ReserveHandler.ashx?Type=genCalendarDate&NowDate=' + nowdate_ ,
        dataType: "json",
        success: function (response) {
            nowdate = nowdate_;
            var aDate = response.split(',');
            var MorningHtml = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">上午</span>' +
                '</p >' +
                '</td >';
            var AfternoonHtml = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">下午</span>' +
                '</p >' +
                '</td >';
            for (var i = 0; i <= aDate.length; i++) {
                var spanId = '#Dayoftheweek' + (i + 1) + 'Date';
                $(spanId).text(aDate[i]);
            }
            for (var i = 0; i < aDate.length; i++) {
                $.ajax({
                    type: "GET",
                    async: false,
                    url: '../Service/ReserveHandler.ashx?Type=GetNormalReserveData&TimeType=Morning&NowDate=' + aDate[i] + '&TownID=' + $('#dl_town').val(),
                    dataType: "json",
                    success: function (responseMorning) {
                        var now__ = new Date();
                        var DataDate = Date.parse(aDate[i]);
                        if (DataDate > now__) {
                            if (responseMorning[1].text == '已約') {
                                MorningHtml += '<td style="cursor:not-allowed; border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: ' + responseMorning[0].color + '; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">' + responseMorning[1].text + '</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                            else {
                                MorningHtml += '<td style="cursor:pointer;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: ' + responseMorning[0].color + '; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;" onclick="OpenReserveWindows(\'' + aDate[i] + '\',\'Morning\');">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">' + responseMorning[1].text + '</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                        }
                        else {
                            if (responseMorning[1].text == '已約') {
                                MorningHtml += '<td style="cursor:not-allowed; border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: gray; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">已超過時間無法預約</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                            else {
                                MorningHtml += '<td style="cursor:not-allowed;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: gray; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">已超過時間無法預約</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                        }
                    },
                    error: function (thrownError) {
                    }
                });
                $.ajax({
                    type: "GET",
                    async: false,
                    url: '../Service/ReserveHandler.ashx?Type=GetNormalReserveData&TimeType=Afternoon&NowDate=' + aDate[i] + '&TownID=' + $('#dl_town').val(),
                    dataType: "json",
                    success: function (responseAfteroon) {
                        var now__ = new Date();
                        var DataDate = Date.parse(aDate[i]);
                        if (DataDate > now__) {
                            if (responseAfteroon[1].text == '已約') {
                                AfternoonHtml += '<td style="cursor:not-allowed;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: ' + responseAfteroon[0].color + '; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">' + responseAfteroon[1].text + '</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                            else {
                                AfternoonHtml += '<td style="cursor:pointer;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: ' + responseAfteroon[0].color + '; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;" onclick="OpenReserveWindows(\'' + aDate[i] + '\',\'Afternoon\');">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">' + responseAfteroon[1].text + '</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                        }
                        else {
                            if (responseAfteroon[1].text == '已約') {
                                AfternoonHtml += '<td style="cursor:not-allowed;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: gray; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">已超過時間無法預約</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                            else {
                                AfternoonHtml += '<td style="cursor:not-allowed;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: gray; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;" onclick="OpenReserveWindows(\'' + aDate[i] + '\',\'Afternoon\');">' +
                                    '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                                    '<span style="font-size: 18pt;">已超過時間無法預約</span>' +
                                    '</p >' +
                                    '</td >';
                            }
                        }
                    },
                    error: function (thrownError) {
                    }
                });
            }

            $('#tr-calendar_morning').html(MorningHtml);
            $('#tr-calendar_afternoon').html(AfternoonHtml);
        },
        error: function (thrownError) {
        }
    });
}

function OpenReserveWindows(ReserveDate,ReserveTimeType) {
    $('#ReserveCalendar').hide();
    $('#ReserveDetail').show(); 
    $('#tbReserveDate').val(ReserveDate);
    $('#tbReserveTown').val($("#dl_town option:selected").text());
    $('#dlReserveTimeType').empty();
    if (ReserveTimeType == 'Morning') {
        $('#dlReserveTimeType').append(new Option('09:00-10:00', '09:00-10:00'));
        $('#dlReserveTimeType').append(new Option('10:00-11:00', '10:00-11:00'));
        $('#dlReserveTimeType').append(new Option('11:00-12:00', '11:00-12:00'));
    }
    else {
        $('#dlReserveTimeType').append(new Option('13:00-14:00', '13:00-14:00'));
        $('#dlReserveTimeType').append(new Option('14:00-15:00', '14:00-15:00'));
        $('#dlReserveTimeType').append(new Option('15:00-16:00', '15:00-16:00'));
    }

}

function SaveReserve() {
    var formData = new FormData();
    formData.append('UserValidation', $('#MainContent_tbCheck').val());
    formData.append('ReserveDate', $('#tbReserveDate').val());
    formData.append('ReserveTimeType', $('#dlReserveTimeType').val());
    formData.append('ReservePerson', $('#tbReservePerson').val());
    formData.append('ReservePhone', $('#tbReservePhone').val());
    formData.append('ReserveMail', $('#tbReserveMail').val());
    formData.append('ReserveTown', $("#dl_town option:selected").val());
    var chooseReserveItem = '';
    for (var i = 0; i < $('.cbReserveItemType').length; i++) {
        if ($('.cbReserveItemType')[i].checked == true) {
            if (i != $('.cbReserveItemType').length - 1)
                chooseReserveItem += $('.cbReserveItemType')[i].value + '|';
            else
                chooseReserveItem += $('.cbReserveItemType')[i].value;
        }
        else {
            if (i != $('.cbReserveItemType').length - 1)
                chooseReserveItem += ' |';
            else
                chooseReserveItem += ' ';

        }
    }
    formData.append('ReserveItemType', chooseReserveItem);
    formData.append('ReserveContent', $('#tbReserveContent').val());

    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/ReserveHandler.ashx?Type=SaveReserve',
        processData: false,
        contentType: false,
        dataType: "json",
        data: formData,
        success: function (data) {
            alert(data)
        },
        error: function (thrownError) {
        }
    });
}

function CloseReserveDetail() {
    $('#ReserveCalendar').show();
    $('#ReserveDetail').hide();
}