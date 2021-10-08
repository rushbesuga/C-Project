function GetData(plan_id) {
    $.ajax({
        type: "POST",
        async: true,
        url: '../Service/PlanQrcodeHandler.ashx?Type=getPlanData&plan_id=' + plan_id,
        dataType: "json",
        success: function (data) {
            $("#tbPlanCaseNo").html(data[0].plan_case_no);
            $("#tbPlanName").html(data[0].plan_name);
            $("#tbPlanAuditDate").html(data[0].plan_audit_date);
            getQrcode(plan_id);
        },
        error: function (thrownError) {
        }
    });
}

function getQrcode(plan_id) {
    $.ajax({
        type: "POST",
        async: true,
        url: '../Service/PlanQrcodeHandler.ashx?Type=getBarcode&plan_id=' + plan_id + '&WebUrl=' + window.location.href.split('PlanQrcode')[0]+'PlanUserView.aspx',
        dataType: "json",
        success: function (data) {
            $("#img_qrcode").attr("src", "data:image/jpg;base64,"+ data);
        },
        error: function (thrownError) {
        }
    });
}

function PagePrint() {
    
    $("#btnCancel").hide();
    $("#btnPrint").hide();
    $('footer').hide();
    
    window.print();
    $("#btnCancel").show();
    $("#btnPrint").show();
    $('footer').show();
}

function CancelPage() {
    window.location = "PlanManage";
}