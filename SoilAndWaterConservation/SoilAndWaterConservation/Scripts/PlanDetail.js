function ClosePlanDetail() {
    window.location = "PlanManage";
}

function resetDate(source_obj_id, target_obj_id) {
    var source_date = $('#' + source_obj_id).val();
    if (source_date != '') {
        var ExtendDate = AddMonthDate(source_date, 6);
        $('#' + target_obj_id).val(ExtendDate);
    }
}

function checkWorkExtend1st(obj) {
    if (obj.checked) {
        var StartWorkExpirationDate = $('#tbStartWorkExpirationDate').val();
        var result = CheckCanExtend(StartWorkExpirationDate, 10);
        if (result == "true") {
            var today = new Date().format('yyyy-MM-dd');
            var ExtendDate = AddMonthDate(today, 6);
            $('#tbStartWorkExtendDate1st').val(today); 
            $('#tbStartWorkExpirationDate').val(ExtendDate);
            $('#tbStartWorkExtendDate1st').removeAttr('readonly');
            $('#tbStartWorkExtendDate1st').css("background-color", "");;
        }
        else {
            alert('開工期限超過10天，不可申請延展');
            obj.checked = false;
        }
    }
    else {
        $('#tbStartWorkExtendDate1st').val('');
        $('#tbStartWorkExtendDate1st').attr('readonly', 'readonly');
        $('#tbStartWorkExtendDate1st').css("background-color", "lightgray"); 
        CalStartWorkExpirationDate();
    }
}

function checkWorkExtend2nd(obj) {
    if (obj.checked) {
        if ($('#tbStartWorkExtendDate1st').val() != '') {
            var StartWorkExpirationDate = $('#tbStartWorkExpirationDate').val();
            var result = CheckCanExtend(StartWorkExpirationDate, 10);
            if (result == "true") {
                var today = new Date().format('yyyy-MM-dd');
                var ExtendDate = AddMonthDate(today, 6);
                $('#tbStartWorkExtendDate2nd').val(today);
                $('#tbStartWorkExpirationDate').val(ExtendDate);
                $('#tbStartWorkExtendDate2nd').removeAttr('readonly');
                $('#tbStartWorkExtendDate2nd').css("background-color", "");;
            }
            else {
                alert('開工期限超過10天，不可申請延展');
                obj.checked = false;
            }
        }
        else {
            alert('尚未第一次開工展延');
            obj.checked = false;
        }
    }
    else {
        $('#tbStartWorkExtendDate2nd').val('');
        var date = $('#tbStartWorkExtendDate1st').val();
        var ExtendDate = AddMonthDate(date, 6);
        $('#tbStartWorkExpirationDate').val(ExtendDate);
        $('#tbStartWorkExtendDate2nd').attr('readonly', 'readonly');
        $('#tbStartWorkExtendDate2nd').css("background-color", "lightgray"); 
    }
}

function checkFinishWorkExtend1st(obj) {
    if (obj.checked) {
        var FinishWorkExpirationDate = $('#tbFinishWorkExpirationDate').val();
        var result = CheckCanExtend(FinishWorkExpirationDate, 10);
        if (result == "true") {
            var today = new Date().format('yyyy-MM-dd');
            var ExtendDate = AddMonthDate(today, 6);
            $('#tbFinishWorkExtendDate1st').val(today);
            $('#tbFinishWorkExpirationDate').val(ExtendDate);
            $('#tbFinishWorkExtendDate1st').removeAttr('readonly');
            $('#tbFinishWorkExtendDate1st').css("background-color", "");;
        }
        else {
            alert('完工期限超過10天，不可申請延展');
            obj.checked = false;
        }
    }
    else {
        $('#tbFinishWorkExtendDate1st').val('');
        $('#tbFinishWorkExtendDate1st').attr('readonly', 'readonly');
        $('#tbFinishWorkExtendDate1st').css("background-color", "lightgray"); 
        CalFinishWorkExpirationDate();
    }
}

function checkFinishWorkExtend2nd(obj) {
    if (obj.checked) {
        if ($('#tbFinishWorkExtendDate1st').val() != '') {
            var FinishWorkExpirationDate = $('#tbFinishWorkExpirationDate').val();
            var result = CheckCanExtend(FinishWorkExpirationDate, 10);
            if (result == "true") {
                var today = new Date().format('yyyy-MM-dd');
                var ExtendDate = AddMonthDate(today, 6);
                $('#tbFinishWorkExtendDate2nd').val(today);
                $('#tbFinishWorkExpirationDate').val(ExtendDate);
                $('#tbFinishWorkExtendDate2nd').removeAttr('readonly');
                $('#tbFinishWorkExtendDate2nd').css("background-color", "");;
            }
            else {
                alert('完工期限超過10天，不可申請延展');
                obj.checked = false;
            }
        }
        else {
            alert('尚未第一次完工展延');
            obj.checked = false;
        }
    }
    else {
        $('#tbFinishWorkExtendDate2nd').val('');
        var date = $('#tbFinishWorkExtendDate1st').val();
        var ExtendDate = AddMonthDate(date, 6);
        $('#tbFinishWorkExpirationDate').val(ExtendDate);
        $('#tbFinishWorkExtendDate2nd').attr('readonly', 'readonly');
        $('#tbFinishWorkExtendDate2nd').css("background-color", "lightgray"); 
    }
}

function GetPlanDetailData() {

}
function CalStartWorkExpirationDate() {
    var getDate = AddYearDate($('#tbPlanAuditDate').val()).replaceAll('/','-');
    $('#tbStartWorkExpirationDate').val(getDate);
    ChangePlanStatus();
}
function CalFinishWorkExpirationDate() {
    var getDate = AddYearDate($('#tbStartWorkDate').val());
    $('#tbFinishWorkExpirationDate').val(getDate);
    ChangePlanStatus();
}
function CheckCanExtend(ExpirationDate, days) {
    var result = ''
    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/PlanDetailHandler.ashx?Type=CheckCanExtend&expiration_date=' + ExpirationDate + '&how_days=' + days,
        dataType: "json",
        success: function (data) {
            result = data;
        },
        error: function (thrownError) {
        }
    });
    return result;
}
function AddYearDate(date) {
    var result = ''
    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/PlanDetailHandler.ashx?Type=CalStartWorkExpirationDate&base_date=' + date,
        dataType: "json",
        success: function (data) {
            result = data;
        },
        error: function (thrownError) {
        }
    });
    return result;
} 
function AddMonthDate(date,addMonth) {
    var result = ''
    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/PlanDetailHandler.ashx?Type=CalAddMonth&base_date=' + date + '&add_month=' + addMonth,
        dataType: "json",
        success: function (data) {
            result = data;
        },
        error: function (thrownError) {
        }
    });
    return result;
}
function AddDaysDate(date,days) {
    var result = ''
    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/PlanDetailHandler.ashx?Type=CalDaysDate&base_date=' + date + '&add_days=' + days,
        dataType: "json",
        success: function (data) {
            result = data;
        },
        error: function (thrownError) {
        }
    });
    return result;
}
function ChangePlanStatus() {
    var PlanAuditDate = $('#tbPlanAuditDate').val();
    var StartWorkDate = $('#tbStartWorkDate').val();
    var FinishWorkDate = $('#tbFinishWorkDate').val();
    var status = '';
    if (PlanAuditDate != '' && StartWorkDate == '' && FinishWorkDate == '')
        status = '已核定';
    else if (PlanAuditDate != '' && StartWorkDate != '' && FinishWorkDate == '')
        status = '施工中';
    else if (PlanAuditDate != '' && StartWorkDate != '' && FinishWorkDate != '')
        status = '已完工';
    $('#tbPlanStatus').val(status);
}
function SavePlan(action) {
    var action = findGetParameter('action');
    var plan_id = findGetParameter('plan_id');
    var formData = new FormData();
    formData.append('action', action);
    formData.append('plan_id', plan_id);
    formData.append('plan_case_no', $('#tbPlanCaseNo').val());
    formData.append('plan_name', $('#tbPlanName').val());
    formData.append('plan_audit_date', $('#tbPlanAuditDate').val());
    formData.append('plan_status', $('#tbPlanStatus').val());
    formData.append('plan_start_work_entend_date_1st', $('#tbStartWorkExtendDate1st').val());
    formData.append('plan_start_work_entend_date_2nd', $('#tbStartWorkExtendDate2nd').val());
    formData.append('plan_start_work_expiration_date', $('#tbStartWorkExpirationDate').val());
    formData.append('plan_start_work_date', $('#tbStartWorkDate').val());
    formData.append('plan_finish_work_extend_date_1st', $("#tbFinishWorkExtendDate1st").val());
    formData.append('plan_finish_work_extend_date_2nd', $("#tbFinishWorkExtendDate2nd").val());
    formData.append('plan_finish_work_expiration_date', $("#tbFinishWorkExpirationDate").val());
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
            alert('儲存成功');
            ClosePlanDetail();
        },
        error: function (thrownError) {
        }
    });
}

function EditLoadData(plan_id) {
    $.ajax({
        type: "POST",
        async: false,
        url: '../Service/PlanDetailHandler.ashx?Type=LoadData&plan_id=' + plan_id,
        dataType: "json",
        success: function (data) {
            $("#tbPlanId").val(data[0].plan_id);
            $("#tbPlanCaseNo").val(data[0].plan_case_no);
            $("#tbPlanName").val(data[0].plan_name);
            $("#tbPlanAuditDate").val(data[0].plan_audit_date);
            $("#tbPlanStatus").val(data[0].plan_status);
            $("#tbStartWorkExtendDate1st").val(data[0].plan_start_work_extend_date_1st);
            if (data[0].plan_start_work_extend_date_1st != '') {
                $("#cbStartWorkExtendDate1st").attr("disabled", true);
                $("#cbStartWorkExtendDate1st").prop('checked', true);
            }
            $("#tbStartWorkExtendDate2nd").val(data[0].plan_start_work_extend_date_2nd);
            if (data[0].plan_start_work_extend_date_2nd != '') {
                $("#cbStartWorkExtendDate2nd").attr("disabled", true);
                $("#cbStartWorkExtendDate2nd").prop('checked', true);
            }
            $("#tbStartWorkExpirationDate").val(data[0].plan_start_work_expiration_date);
            $("#tbStartWorkDate").val(data[0].plan_start_work_date);
            $("#tbFinishWorkExtendDate1st").val(data[0].plan_finish_work_extend_date_1st);
            if (data[0].plan_finish_work_extend_date_1st != '') {
                $("#cbFinishWorkExtendDate1st").attr("disabled", true);
                $("#cbFinishWorkExtendDate1st").prop('checked', true);
            }
            $("#tbFinishWorkExtendDate2nd").val(data[0].plan_finish_work_extend_date_2nd);
            if (data[0].plan_finish_work_extend_date_2nd != '') {
                $("#cbFinishWorkExtendDate2nd").attr("disabled", true);
                $("#cbFinishWorkExtendDate2nd").prop('checked', true);
            }
            $("#tbFinishWorkExpirationDate").val(data[0].plan_finish_work_expiration_date);
            $("#tbFinishWorkDate").val(data[0].plan_finish_work_date);
        },
        error: function (thrownError) {
        }
    });
}


function DelPlanData(plan_id) {
    if (confirm("確定要刪除嗎？")) {
        $.ajax({
            type: "POST",
            async: false,
            url: '../Service/PlanDetailHandler.ashx?Type=DelPlanData&plan_id=' + plan_id,
            dataType: "json",
            success: function (data) {
                alert('刪除成功');
                ClosePlanDetail();
            },
            error: function (thrownError) {
            }
        });
    }
}