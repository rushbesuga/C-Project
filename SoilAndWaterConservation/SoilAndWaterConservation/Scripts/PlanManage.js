function loadjqgrid() {
    $("#grid").jqGrid({
        url: '',
        async: false,
        datatype: 'json',
        jsonReader: {
            repeatitems: false
        },
        mtype: 'GET',
        colModel: [
            { name: 'plan_id', label: '操作', align: 'center', formatter: showButton },
            { name: 'plan_name', label: '計畫名稱' },
            { name: 'plan_case_no', label: '案號', align: 'center' },
            { name: 'plan_status', label: '案件狀態', align: 'center' },
            { name: 'plan_start_work_extend', label: '申請開工展延', align: 'center' },
            { name: 'plan_start_work_expiration_date', label: '開工期限' },
            { name: 'plan_finish_work_extend', label: '申請完工展延' },
            { name: 'plan_finish_work_date', label: '核定完工日期' },
            { name: 'plan_id', label: 'QRCODE', formatter: showQRButton}
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
    function showFuncButton(cellvalue, options, rowObject) {
        return "<button type='button'  onclick='btnEditPlan(" + rowObject.plan_id + ")'>編輯</button>&nbsp;<button type='button'  onclick='btnDelPlan(" + rowObject.plan_id + ")'>刪除</button>";
    }
    function showQRButton(cellvalue, options, rowObject) {
        return "<button type='button'  onclick='btnQrcodePage(" + rowObject.plan_id + ")'>QRCODE</button>";
    }
}
function btnAddPlan() {
    window.location = "PlanDetail?action=add";
}
function btnEditPlan(plan_id) {
    window.location = "PlanDetail?action=edit&plan_id=" + plan_id;
}
function btnDelPlan(plan_id) {
    window.location = "PlanDetail?action=del&plan_id=" + plan_id;
}
function btnQrcodePage(plan_id) {
    window.location = "QRCODE?plan_id=" + plan_id;
}