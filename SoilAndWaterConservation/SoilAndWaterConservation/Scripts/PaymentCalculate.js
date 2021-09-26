//取得開發利用類別
function getDevOption() {
    $('#dl_dev_type').empty();
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/PaymentCalculateHandler.ashx?Type=GetDevOption',
        dataType: "json",
        success: function (response) {
            $('#dl_dev_type').append('請選擇開發類別','')
            for (var i = 0; i < response.length; i++) {
                $('#dl_dev_type').append(new Option(response[i].margin_name, response[i].margin_type_id));
            }
        },
        error: function (thrownError) {
        }
    });
}

//計算水土保持保證金
function getDevCalPrice() {
    $('#dev_cal_price').val('');
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/PaymentCalculateHandler.ashx?Type=GetDevCalPrice&margin_type_id=' + $('#dl_dev_type').val() + '&dev_total_amount=' + $('#dev_total_amount').val(),
        dataType: "json",
        success: function (response) {
            $('#dev_cal_price').text(toCurrency(response[0].margin_price));
        },
        error: function (thrownError) {
        }
    });
}

//計算計畫變更審查費
function getPlanChangeCalPrice() {
    $('#plan_change_cal_price').val('');
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/PaymentCalculateHandler.ashx?Type=GetPlanChangeCalPrice&AuditOriginalPrice=' + $('#txbAuditOriginalPrice').val() + '&MakeOriginalPrice=' + $('#txbMakeOriginalPrice').val() + '&ChangeMakePrice=' + $('#txbChangeMakePrice').val(),
        dataType: "json",
        success: function (response) {
            $('#plan_change_cal_price').text(toCurrency(response[0].change_audit_price));
        },
        error: function (thrownError) {
        }
    });
}

//計算水土保持計畫書審查費
function getPlanAuditCalPrice() {
    $('#plan_audit_cal_price').val('');
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/PaymentCalculateHandler.ashx?Type=GetPlanAuditCalPrice&Area=' + $('#txbPlanArea').val(),
        dataType: "json",
        success: function (response) {
            $('#plan_audit_cal_price').text(toCurrency(response[0].plan_audit_cal_price));
        },
        error: function (thrownError) {
        }
    });
}

//計算水土保持規劃書審查費
function getPlanningAuditCalPrice() {
    $('#planning_audit_cal_price').val('');
    $.ajax({
        type: "GET",
        async: false,
        url: '../Service/PaymentCalculateHandler.ashx?Type=GetPlanningAuditCalPrice&Area=' + $('#txbPlanningArea').val(),
        dataType: "json",
        success: function (response) {
            $('#planning_audit_cal_price').text(toCurrency(response[0].planning_audit_cal_price));
        },
        error: function (thrownError) {
        }
    });
}