function ClosePlanDetail() {
    window.location = "PlanManage";
}

function GetPlanDetailData() {

}

function SavePlan(action) {
    var action = findGetParameter('action');
    var formData = new FormData();
    formData.append('action', action);
    formData.append('plan_id', $('#tbPlanId').val());
    formData.append('plan_case_no', $('#tbPlanCaseNo').val());
    formData.append('plan_name', $('#tbPlanName').val());
    formData.append('plan_audit_date', $('#tbPlanAuditDate').val());
    formData.append('plan_start_work_entend_1st', $('#tbStartWorkExtend1st').val());
    formData.append('plan_start_work_entend_2nd', $('#tbStartWorkExtend2nd').val());
    formData.append('plan_start_work_date', $('#tbStartWorkDate').val());
    formData.append('plan_finish_work_extend_date_1st', $("#tbFinishWorkExtendDate1st").val());
    formData.append('plan_finish_work_extend_date_2nd', $("#tbFinishWorkExtendDate2nd").val());
    formData.append('plan_finish_work_date', $("#tbFinishWorkDate").val());
    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/PlanDetailHandler.ashx?Type=SavePlan',
        processData: false,
        contentType: false,
        dataType: "json",
        data: formData,
        success: function (data) {
            alert(data)
            ClosePlanDetail();
        },
        error: function (thrownError) {
        }
    });
}