function loadjqgrid() {
    $("#QAGrid").jqGrid({
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_data',
        async: false,
        datatype: 'json',
        jsonReader: {
            repeatitems: false
        },
        mtype: 'GET',
        colModel: [
            { name: 'row_id', label: '編號', hidden: true },
            { name: 'row_recovery_title', label: '標題' },
            { name: 'row_createtime', label: '發布日期', align: 'center',width:40},
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
        rownumbers: true,
        rownumWidth: 100,
        loadonce: true,
        onSelectRow: function (ids) {
            if (ids != null) {
                location.href = 'CheckQA.aspx?id=' + $("#QAGrid").jqGrid('getCell', ids, 'row_id') ;
            }
        }
    });
    $("#QAGrid").jqGrid("setLabel", "rn", "編號");
}
function searchdata() {
    $("#QAGrid").jqGrid('setGridParam', {
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_data&Filter=' + $("#filter").val(),
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
            { name: 'row_id', label: '編號', hidden: true , },
            { name: 'row_title', label: '標題', align: 'left'},
            { name: 'row_name', label: '發問者', align: 'center', width: 80},
            { name: 'row_recovery_punlic', label: '公開回復', align: 'center', width: 80},
            { name: 'row_recovery_procflag', label: '已處理', align: 'center', width: 80 },
            { name: 'row_createtime', label: '時間', align: 'center' },
            {
                name: '編輯', lable: '', formatter: showButton, align: 'center', width: 100
            },
        ],
        pager: '#pager',
        width: '100%',
        height: '100%',
        shrinkToFit: true,
        autowidth: true,
        rowNum: 10,
        rownumbers: true,
        rownumWidth:80,
        rowList: [5, 10, 20, 50],
        sortname: 'Name',
        sortorder: "asc",
        viewrecords: true,
        loadonce: true
    });

    $("#QAGrid").jqGrid("setLabel", "rn", "編號");
    function showButton(cellvalue, options, rowObject) {
        return "<button type='button'  onclick='gotopage(" + rowObject.row_id + ")'>選擇</button>&nbsp;<button type='button'  onclick='delMessage(" + rowObject.row_id + ")'>刪除</button>";
    }

    $('#rdproc').attr("checked", true);
}

function delMessage(row_id) {

    if (confirm("確定要刪除嗎？")) {
        $.ajax({
            url: '../Service/QAandMessageBoardHandler.ashx?Type=delMessage&id=' + row_id,
            type: 'GEt',
            success: function () {
                alert('刪除成功');
                searchmaintenancedata();
            },
            error: function (thrownError) {

                alert('儲存失敗');
            }
        });
    }
    else {
        return false;
    }
}

function gotopage(row_id) {

    location.href = 'ReplyQA.aspx?id=' + row_id;
}

function clearfilter() {
    document.getElementById("filter").value = '';
}


function getQAandMessageBoardDetail() {
    $.ajax({
        type: "GET",
        async: false, 
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_Details&id=' + findGetParameter('id'),
        dataType: "json",
        success: function (response) {
            $('#tbid').val(response[0].row_id);
            $('#tbname').val(response[0].row_name);
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
            //ChekcQA.aspx使用
            $('#title').html(response[0].row_recovery_title);
            $('#content').html(response[0].row_recovery_content);

            $('#Remark').html('發布人員:' + response[0].row_recovery_name + '&nbsp|&nbsp' + '更新日期:' + response[0].row_recovery_time);
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
function getQAandMessageBoardmaintenanceDetail() {
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
        url: '../Service/QAandMessageBoardHandler.ashx?Type=tbl_qaandmessage_maintenance_data_filter&Filter=' + $("#filter").val() + '&date=' + $("#date").val() + '&proc=' + $("input[name='procflag']:checked").val(),
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');
}
function saveReplyQA() {
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