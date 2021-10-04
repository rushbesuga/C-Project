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
        url: '../Service/ReserveManageHandler.ashx?Type=genCalendarDate&NowDate=' + nowdate_,
        dataType: "json",
        success: function (response) {
            nowdate = nowdate_;
            var aDate = response.split(',');
            var Time09_10Html = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">09:00-10:00</span>' +
                '</p >' +
                '</td >';
            var Time10_11Html = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">10:00-11:00</span>' +
                '</p >' +
                '</td >';
            var Time11_12Html = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">11:00-12:00</span>' +
                '</p >' +
                '</td >';
            var Time13_14Html = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">13:00-14:00</span>' +
                '</p >' +
                '</td >';
            var Time14_15Html = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">14:00-15:00</span>' +
                '</p >' +
                '</td >';
            var Time15_16Html = '<td style="border-width: 3pt 1pt 1pt;height:150px; border-style: solid; border-color: white; background: rgb(207, 213, 234); text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;">' +
                '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
                '<span style="font-size: 18pt;">15:00-16:00</span>' +
                '</p >' +
                '</td >';
            for (var i = 0; i <= aDate.length; i++) {
                var spanId = '#Dayoftheweek' + (i + 1) + 'Date';
                $(spanId).text(aDate[i]);
            }
            var time = '09:00-10:00|10:00-11:00|11:00-12:00|13:00-14:00|14:00-15:00|15:00-16:00'
            var atime = time.split('|');
            for (var i = 0; i < aDate.length; i++) {
                for (var j = 0; j < atime.length; j++) {
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: '../Service/ReserveManageHandler.ashx?Type=GetAdminReserveData&ReserveTime=' + atime[j] + '&NowDate=' + aDate[i] + '&TownID=' + $('#dl_town').val(),
                        dataType: "json",
                        success: function (responseMorning) {
                            var now__ = new Date();
                            var DataDate = Date.parse(aDate[i]);
                            if (DataDate > now__) {
                                if (atime[j] == '09:00-10:00') {
                                    Time09_10Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], false)
                                }
                                else if (atime[j] == '10:00-11:00') {
                                    Time10_11Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], false)
                                }
                                else if (atime[j] == '11:00-12:00') {
                                    Time11_12Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], false)
                                }
                                else if (atime[j] == '13:00-14:00') {
                                    Time13_14Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], false)
                                }
                                else if (atime[j] == '14:00-15:00') {
                                    Time14_15Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], false)
                                }
                                else if (atime[j] == '15:00-16:00') {
                                    Time15_16Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], false)
                                }
                            }
                            else {
                                if (atime[j] == '09:00-10:00') {
                                    Time09_10Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], true)
                                }
                                else if (atime[j] == '10:00-11:00') {
                                    Time10_11Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], true)
                                }
                                else if (atime[j] == '11:00-12:00') {
                                    Time11_12Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], true)
                                }
                                else if (atime[j] == '13:00-14:00') {
                                    Time13_14Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], true)
                                }
                                else if (atime[j] == '14:00-15:00') {
                                    Time14_15Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], true)
                                }
                                else if (atime[j] == '15:00-16:00') {
                                    Time15_16Html += genTimeTd(responseMorning[1].text, responseMorning[0].color, aDate[i], atime[j], true)
                                }
                            }
                        },
                        error: function (thrownError) {
                        }
                    });
                }
            }

            $('#tr-calendar_09_10').html(Time09_10Html);
            $('#tr-calendar_10_11').html(Time10_11Html);
            $('#tr-calendar_11_12').html(Time11_12Html);
            $('#tr-calendar_13_14').html(Time13_14Html);
            $('#tr-calendar_14_15').html(Time14_15Html);
            $('#tr-calendar_15_16').html(Time15_16Html);
        },
        error: function (thrownError) {
        }
    });
}

function genTimeTd(isReserve, tdColor, date, time, overtime) {
    var tdHtml = '';

    if (isReserve == '已約' && overtime == false) {
        tdHtml = '<td style="cursor:pointer; border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: ' + tdColor + '; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;" onclick="OpenReserveWindows(\'' + date + '\',\'' + time + '\',\'' + isReserve + '\',\'' + overtime + '\',true);">' +
            '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
            '<span style="font-size: 18pt;">' + isReserve + '</span>' +
            '</p >' +
            '</td >';
    }
    else if (isReserve == '可預約' && overtime == false) {
        tdHtml = '<td style="cursor:pointer;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: ' + tdColor + '; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;" onclick="OpenReserveWindows(\'' + date + '\',\'' + time + '\',\'' + isReserve + '\',\'' + overtime + '\',false);">' +
            '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
            '<span style="font-size: 18pt;">' + isReserve + '</span>' +
            '</p >' +
            '</td >';
    }
    else if (isReserve == '已約' && overtime == true) {
        tdHtml = '<td style="cursor:pointer; border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: gray; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;" onclick="OpenReserveWindows(\'' + date + '\',\'' + time + '\',\'' + isReserve + '\',\'' + overtime + '\',false);">' +
            '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
            '<span style="font-size: 18pt;">' + isReserve + '</span>' +
            '</p >' +
            '</td >';
    }
    else if (isReserve == '可預約' && overtime == true) {
        tdHtml = '<td style="cursor:pointer;border-width: 3pt 1pt 1pt; border-style: solid; border-color: white; background: gray; text-align: center; vertical-align: middle; color: windowtext; font-size: 18pt; font-family: Arial; border-image: initial;" onclick="OpenReserveWindows(\'' + date + '\',\'' + time + '\',\'' + isReserve + '\',\'' + overtime + '\',false);">' +
            '<p style = "margin-top: 0pt; margin-bottom: 0pt; margin-left: 0in; direction: ltr; unicode-bidi: embed; word-break: normal;" >' +
            '<span style="font-size: 18pt;">' + isReserve + '</span>' +
            '</p >' +
            '</td >';
    }
    return tdHtml;
}

function OpenReserveWindows(ReserveDate, ReserveTime, isReserve, overtime, delBtnVisble) {
    if (delBtnVisble) {
        $('#btn_del_reserve').show();
    }
    else {
        $('#btn_del_reserve').hide();
    }
    $('#ReserveCalendar').hide();
    $('#ReserveDetail').show();
    resetReserveForm();
    if (isReserve == '已約' || overtime == true) {
        $('#dlReserveTimeType').empty();
        $('#dlReserveTimeType').append(new Option(ReserveTime, ReserveTime));
        $('#tbReserveDate').attr('readonly', 'readonly');
        $('#dlReserveTimeType').attr('readonly', 'readonly');
        $('#tbReservePerson').removeAttr('readonly');
        $('#tbReservePhone').removeAttr('readonly');
        $('#tbReserveMail').removeAttr('readonly');
        $('#tbReserveTown').attr('readonly', 'readonly');
    }
    else {
        $('#dlReserveTimeType').empty();
        $('#dlReserveTimeType').append(new Option(ReserveTime, ReserveTime));
        $('#tbReserveDate').attr('readonly', 'readonly');
        $('#dlReserveTimeType').attr('readonly', 'readonly');
    }
    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/ReserveManageHandler.ashx?Type=GetReserveData&ReserveDate=' + ReserveDate + '&ReserveTime=' + ReserveTime + '&TownID=' + $('#dl_town').val(),
        dataType: "json",
        success: function (data) {
            if (data.length != 0) {
                $('#tbReserveDate').val(ReserveDate);
                $('#dlReserveTimeType').val(ReserveTime);
                $('#tbReservePerson').val(data[0].reserve_person_name);
                $('#tbReservePhone').val(data[0].reserve_phone);
                $('#tbReserveMail').val(data[0].reserve_person_email);
                $('#tbReserveTown').val(data[0].reserve_town_name);
                for (var i = 0; i < $('.cbReserveItemType').length; i++) {
                    var a_reserve_item_type = data[0].reserve_item_type.split('|');
                    for (var j = 0; j < a_reserve_item_type.length; j++) {
                        if ($('.cbReserveItemType')[i].value == a_reserve_item_type[j]) {
                            $('.cbReserveItemType')[i].checked = true;
                        }
                    }
                }
                $('#tbReserveContent').val(data[0].reserve_content);
                $('#tbEngineer').val(data[0].reserve_engineer);
                $('#tbEngineerResponse').val(data[0].reserve_engineer_response);
            }
            else {
                $('#tbReserveDate').val(ReserveDate);
                $('#dlReserveTimeType').val(ReserveTime);
                $('#tbReservePerson').val('');
                $('#tbReservePhone').val('');
                $('#tbReserveMail').val('');
                $('#tbReserveTown').val($('#dl_town').find('option:selected').text());
                for (var i = 0; i < $('.cbReserveItemType').length; i++) {
                    $('.cbReserveItemType')[i].checked = false;
                }
                $('#tbReserveContent').val('');
                $('#tbEngineer').val('');
                $('#tbEngineerResponse').val('');
            }
        },
        error: function (thrownError) {
        }
    });

}

function resetReserveForm() {
    $('#tbReserveDate').val('');
    $('#dlReserveTimeType').val('');
    $('#tbReservePerson').val('');
    $('#tbReservePhone').val('');
    $('#tbReserveMail').val('');
    $('#tbReserveTown').val('');
    for (var i = 0; i < $('.cbReserveItemType').length; i++) {
        $('.cbReserveItemType')[i].checked = false;
    }
    $('#tbReserveContent').val('');
    $('#tbEngineer').val('');
    $('#tbEngineerResponse').val('');
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
    formData.append('ReserveTownName', $("#tbReserveTown").val());
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
    formData.append('ReserveEngineer', $("#tbEngineer").val());
    formData.append('ReserveEngineerResponse', $("#tbEngineerResponse").val());

    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/ReserveManageHandler.ashx?Type=SaveReserve',
        processData: false,
        contentType: false,
        dataType: "json",
        data: formData,
        success: function (data) {
            alert(data)
            CloseReserveDetail();
        },
        error: function (thrownError) {
        }
    });
}

function DelReserve() {
    if (confirm("確定要刪除嗎？")) {
        var formData = new FormData();
        formData.append('ReserveDate', $('#tbReserveDate').val());
        formData.append('ReserveTimeType', $('#dlReserveTimeType').val());
        formData.append('ReserveTownName', $("#tbReserveTown").val());
        $.ajax({
            type: "POST",
            async: false,
            url: '../Service/ReserveManageHandler.ashx?Type=DelReserve',
            processData: false,
            contentType: false,
            dataType: "json",
            data: formData,
            success: function (data) {
                alert(data)
                CloseReserveDetail();
            },
            error: function (thrownError) {
            }
        });
    }
    else {
        return false;
    }
}

function ExportReort() {
    var url = '../Service/ReserveManageHandler.ashx?Type=ExportReport&WeekStartDate=' + $('#Dayoftheweek1Date').text().replaceAll('/', '-') + '&WeekEndDate=' + $('#Dayoftheweek5Date').text().replaceAll('/', '-');
    window.open(url, "_blank");
}

function CloseReserveDetail() {
    resetReserveForm();
    $('#ReserveCalendar').show();
    $('#ReserveDetail').hide();
    genCalendarDate('now');
}