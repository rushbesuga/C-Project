﻿function loadDataCount() {

    if ($('#MainContent_hidlevelcontrol').val() == "0") {
        $('#admin-default-left').show();
        $('#admin-default-center').show();
        $('#admin-default-right').show();
        $('#admin-default-down-left').hide();
        $('#admin-default-down-center').show();
        $('#admin-default-down-right').hide();
    }
    else if ($('#MainContent_hidlevelcontrol').val() == "1") {
        $('#admin-default-left').show();
        $('#admin-default-center').hide();
        $('#admin-default-right').hide();
        $('#admin-default-down-left').show();
        $('#admin-default-down-center').hide();
        $('#admin-default-down-right').show();
    }

    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/Default_AdminHandler.ashx?Type=GetDataCount',
        dataType: "json",
        success: function (data) {
            $('#plan_audit').html(data[0].已核可);
            $('#plan_start').html(data[0].施工中);
            $('#plan_un_start').html(data[0].已完工);
            $('#plan_finish').html(data[0].未開工);
            $('#plan_un_finish').html(data[0].未完工);
            $('#reserve_fix').html(data[0].諮詢已處置);
            $('#reserve_un_fix').html(data[0].諮詢未處置);
            $('#qa_fix').html(data[0].問答已處置);
            $('#qa_un_fix').html(data[0].問答未處置);
            $('#upload_count').html(data[0].完成上傳數);
        },
        error: function (thrownError) {
        }
    });
}