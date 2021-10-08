function GetData(plan_id) {
    $.ajax({
        type: "POST",
        async: true,
        url: '../Service/PlanUserViewHandler.ashx?Type=getPlanData&plan_id=' + plan_id,
        dataType: "json",
        success: function (data) {
            $("#tbPlanCaseNo").html(data[0].plan_case_no);
            $("#tbPlanName").html(data[0].plan_name);
            $("#tbPlanAuditDate").html(data[0].plan_audit_date);
            $("#tbPlanStatus").html(data[0].plan_status);
            $("#tbStartWorkExpirationDate").html(data[0].plan_start_work_expiration_date);
            $("#tbStartWorkExpirationRemainingDays").html(data[0].plan_start_work_expiration_Remaining_days);
            $("#tbFinishWorkExpirationDate").html(data[0].plan_finish_work_expiration_date);
            $("#tbFinishWorkExpirationRemainingDays").html(data[0].plan_finish_work_expiration_Remaining_days);
        },
        error: function (thrownError) {
        }
    });
}