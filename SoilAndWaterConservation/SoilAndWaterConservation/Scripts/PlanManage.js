function loadjqgrid() {
    $("#grid").jqGrid({
        url: '../Service/PlanManageHandler.ashx?Type=GetPlanDetailData&Keyword=&ChoosePlanStatustItem=&DateType=&StartDate=&EndDate=',
        async: false,
        datatype: 'json',
        jsonReader: {
            repeatitems: false
        },
        mtype: 'GET',
        colModel: [
            { name: 'row_id', label: '序號', align: 'center' },
            { name: 'plan_id', label: '操作', align: 'center', formatter: showFuncButton },
            { name: 'plan_id_qrcode', label: 'QRCODE', align: 'center', formatter: showQRButton },
            { name: 'plan_name', label: '計畫名稱', align: 'left' },
            { name: 'plan_case_no', label: '案號', align: 'center', align: 'left' },
            { name: 'plan_status', label: '案件狀態', align: 'center', align: 'center' },
            { name: 'plan_start_work_extend_date', label: '申請開工展延', align: 'center' },
            { name: 'plan_start_work_expiration_date', label: '開工期限', align: 'center' },
            { name: 'plan_finish_work_extend_date', label: '申請完工展延', align: 'center' },
            { name: 'plan_finish_work_date', label: '核定完工日期', align: 'center' },
            { name: 'plan_undertaker', label: '承辦人', align: 'center', align: 'center' }
        ],
        pager: '#pager',
        width: '100%',
        height: '100%',
        shrinkToFit: false,
        autowidth: true,
        rowNum: 30,
        rowList: [30,50, 100, 200],
        sortname: 'Name',
        sortorder: "asc",
        viewrecords: true,
        loadonce: true
    });
    function showFuncButton(cellvalue, options, rowObject) {
        return "<button type='button'  onclick='btnEditPlan(" + rowObject.plan_id + ")'>編輯</button>&nbsp;<button type='button'  onclick='btnDelPlan(" + rowObject.plan_id + ")'>刪除</button>";
    }
    function showQRButton(cellvalue, options, rowObject) {
        return "<button type='button'  onclick='btnQrcodePage(" + rowObject.plan_id + ")'>QRCODE</button>";
    } 
    $('#btnadd').show();
    //if ($('#MainContent_hidlevelcontrol').val() == "0") {
        
    //}
    //else if ($('#MainContent_hidlevelcontrol').val() == "1") {
    //    $("#grid").jqGrid('setColProp', 'plan_id', { width: 0 });
    //    jQuery("#grid").setGridParam().hideCol("plan_id").trigger("reloadGrid");
    //    $('#btnadd').hide();
    //}
}
function btnQueryPlanData() {
    var choosePlanStatustItem = '';
    for (var i = 0; i < $('.cbPlanStatusItemType').length; i++) {
        if ($('.cbPlanStatusItemType')[i].checked == true) {
            if (i != $('.cbPlanStatusItemType').length - 1)
                choosePlanStatustItem += $('.cbPlanStatusItemType')[i].value + '|';
            else
                choosePlanStatustItem += $('.cbPlanStatusItemType')[i].value;
        }
    }
    $("#grid").jqGrid('setGridParam', {
        url: '../Service/PlanManageHandler.ashx?Type=GetPlanDetailData&Keyword=' + $('#tbKeyword').val() + '&ChoosePlanStatustItem=' + choosePlanStatustItem + '&DateType=' + $('#dl_dev_type').val() + '&StartDate=' + $('#StartDate').val() + '&EndDate=' + $('#EndDate').val(),
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');
}

function btnQuickQueryPlanData(day) {
    $('#tbKeyword').val('');
    $('#cbPlanStatusItemType1').prop("checked", false);
    $('#cbPlanStatusItemType2').prop("checked", false); 
    $('#cbPlanStatusItemType3').prop("checked", false);
    $('#StartDate').val('');
    $('#EndDate').val('');
    $("#grid").jqGrid('setGridParam', {
        url: '../Service/PlanManageHandler.ashx?Type=QuickQuery&Days='+day,
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');
}
function exportExcel() {
    $('#grid').jqGrid('hideCol', ["plan_id", "plan_id_qrcode"]);
    var dt = new Date();
    var month = dt.getMonth();
    if ((month + 1).toString().length < 2)
        month = '0' + (month + 1).toString();
    else
        month = (month + 1).toString();
    var day = dt.getDate();
    if (day.toString().length < 2)
        day = '0' + day.toString();
    else
        day = day.toString();
    var hour = dt.getHours();
    if (hour.toString().length < 2)
        hour = '0' + hour.toString();
    else
        hour = hour.toString();
    var minutes = dt.getMinutes();
    if (minutes.toString().length < 2)
        minutes = '0' + minutes.toString();
    else
        minutes = minutes.toString();
    var sec = dt.getSeconds();
    if (sec.toString().length < 2)
        sec = '0' + sec.toString();
    else
        sec = sec.toString();
    var msec = dt.getMilliseconds();
    if (msec.toString().length == 2 )
        sec = '0' + sec.toString();
    else if (msec.toString().length == 1)
        sec = '00' + sec.toString();
    else
        sec = sec.toString();
    var fileDate = dt.getFullYear().toString() + month + day + hour + minutes + sec + sec; 

    alert(fileDate)
    $("#grid").jqGrid("exportToExcel", {
        includeLabels: true,
        includeGroupHeader: true,
        includeFooter: true,
        fileName: fileDate+"_簡易水土保持計畫清單.xlsx",
        maxlength: 80 // maxlength for visible string data
    })
    $('#grid').jqGrid('showCol', ["plan_id", "plan_id_qrcode"]);
}
function btnAddPlan() {
    window.location = "PlanDetail?action=add";
}
function btnEditPlan(plan_id) {
    window.location = "PlanDetail?action=edit&plan_id=" + plan_id;
}
function btnDelPlan(plan_id) {
    if (confirm("確定要刪除嗎？")) {
        $.ajax({
            type: "POST",
            async: false,
            url: '../Service/PlanDetailHandler.ashx?Type=DelPlanData&plan_id=' + plan_id,
            dataType: "json",
            success: function (data) {
                alert('刪除成功');
                btnQueryPlanData();
            },
            error: function (thrownError) {
            }
        });
    }
}
function btnQrcodePage(plan_id) {
    window.location = "PlanQrcode?plan_id=" + plan_id;
}
