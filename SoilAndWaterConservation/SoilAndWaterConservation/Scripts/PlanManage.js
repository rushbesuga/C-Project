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
            { name: 'plan_id', label: '操作', align: 'center', formatter: showFuncButton },
            { name: 'plan_id', label: 'QRCODE', align: 'center', formatter: showQRButton },
            { name: 'plan_name', label: '計畫名稱', align: 'left' },
            { name: 'plan_case_no', label: '案號', align: 'center', align: 'left' },
            { name: 'plan_status', label: '案件狀態', align: 'center', align: 'center' },
            { name: 'plan_start_work_extend_date', label: '申請開工展延', align: 'center' },
            { name: 'plan_start_work_expiration_date', label: '開工期限', align: 'center' },
            { name: 'plan_finish_work_extend_date', label: '申請完工展延', align: 'center' },
            { name: 'plan_finish_work_date', label: '核定完工日期', align: 'center' }
        ],
        pager: '#pager',
        width: '100%',
        height: '100%',
        shrinkToFit: false,
        autowidth: true,
        rowNum: 10,
        rowList: [5, 10, 20, 50],
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

    $("#grid").jqGrid('setGridParam', {
        url: '../Service/PlanManageHandler.ashx?Type=QuickQuery&Days='+day,
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');
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