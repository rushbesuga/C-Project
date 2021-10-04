﻿function loadjqgrid() {
    $("#QAGrid").jqGrid({
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_data',
        async: false,
        datatype: 'json',
        jsonReader: {
            repeatitems: false
        },
        mtype: 'GET',
        colModel: [
            { name: 'row_id', label: '編號', },
            {
                name: 'row_title', label: '標題', formatter: 'showlink', formatter: addLink
            },
            { name: 'row_createtime', label: '發布日期' },
        ],
        pager: '#pager',
        width: '100%',
        height: '100%',
        shrinkToFit: true,
        autowidth: true,
        rowNum: 10,
        rowList: [5, 10, 20, 50],
        sortname: 'Name',
        sortorder: "asc",
        viewrecords: true,
        loadonce: true
    });
}
function addLink(cellvalue, options, rowObject) {
    return "<a href='CheckQA.aspx?id=" + rowObject.row_id + "'>" + cellvalue+"</a>";
}
function searchdata() {
    $("#QAGrid").jqGrid('setGridParam', {
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_data_Filter&Filter=' + $("#filter").val(),
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');

}
function loadmaintenancejqgrid() {
    $("#QAGrid").jqGrid({
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_maintenance_data',
        async: false,
        datatype: 'json',
        jsonReader: {
            repeatitems: false
        },
        mtype: 'GET',
        colModel: [
            { name: 'row_id', label: '編號' },
            { name: 'row_createtime', label: '時間' },
            { name: 'row_title', label: '標題' },
            { name: 'row_name', label: '發問者' },
            { name: 'row_recovery_punlic', label: '已處理' },
            { name: 'row_recovery_procflag', label: '公開回復' },
            {
                name: '編輯', lable: '', formatter: showButton
            },
        ],
        pager: '#pager',
        width: '100%',
        height: '100%',
        shrinkToFit: true,
        autowidth: true,
        rowNum: 10,
        rowList: [5, 10, 20, 50],
        sortname: 'Name',
        sortorder: "asc",
        viewrecords: true,
        loadonce: true
    });
    function showButton(cellvalue, options, rowObject) {
        return "<button type='button'  onclick='gotopage(" + rowObject.row_id + ")'>選擇 </button>";
    }
}

function gotopage(row_id) {

    location.href = 'RecoveryQA.aspx?id=' + row_id;
}

function clearfilter() {
    document.getElementById("filter").value = '';
}

function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    var items = location.search.substr(1).split("&");
    for (var index = 0; index < items.length; index++) {
        tmp = items[index].split("=");
        if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
    }
    return result;
}

function getQAandMessageBoardDetail() {
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_maintenance_Details&id=' + findGetParameter('id'),
        dataType: "json",
        success: function (response) {
            $('#tbid').val(response[0].row_id);
            $('#tbname').val(response[0].row_name);
            //$('#tbname').text(response[].plan_audit_cal_price);
            if (response[0].row_gender == '1')
                $('#rbfeamle').attr("checked", true);
            else
                $('#rbmale').attr("checked", true);
            $('#tbphone').val(response[0].row_phone);
            $('#tbemail').val(response[0].row_email);
            $('#tbemailtitle').val(response[0].row_title);
            $('#tbcontent').val(response[0].row_content);
            $('#tbrecovery_time').val(response[0].row_recovery_time);
            $('#tbrecovery_name').val(response[0].row_recovery_name);
            $('#tbrecovery_title').val(response[0].row_recovery_title);
            $('#tbrecovery_content').val(response[0].row_recovery_content);
            if (response[0].row_recovery_public == '1')
                $('#rbunpublic').attr("checked", true);
            else
                $('#rbpublic').attr("checked", true);
            if (response[0].row_recovery_procflag == '1')
                $('#rbunprocflag').attr("checked", true);
            else
                $('#rbprocflag').attr("checked", true);

        },
        error: function (thrownError) {
        }
    });
}
function searchmaintenancedata() {
    $("#QAGrid").jqGrid('setGridParam', {
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_maintenance_data_filter&Filter=' + $("#filter").val() + '&date=' + $("#date").val(),
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');

}
function saverecoveryqa() {
    var data;
    data = new FormData();
    data.append('id', $('#tbid').val());
    data.append('recoveryname', $('#tbrecovery_name').val());
    data.append('recoverytitle', $('#tbrecovery_title').val());
    data.append('recoverycontent', $('#tbrecovery_content').val());
    data.append('public', $("input[name='public']:checked").val());
    data.append('procflage', $("input[name='public']:checked").val());
    $.ajax({
        url: '../Service/QAandMessageBoardHandler.ashx?Type=save_recovery_data',
        data: data,
        processData: false,
        contentType: false,
        type: 'POST',
        success: function () {
            alert('儲存成功');
            location.href = 'QAmaintenance.aspx';
        },
        error: function (thrownError) {

            alert('儲存失敗');
        }
    });
}