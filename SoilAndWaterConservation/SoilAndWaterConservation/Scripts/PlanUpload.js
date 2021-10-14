function loadjqgrid() {
    $("#PlanUploadGrid").jqGrid({
        url: '../Service/PlanUpload.ashx?Type=tbl_planupload_data&Filter=' + $('#filter').val() + '&startdate=' + $('#startdate').val() + '&enddate=' + $('#enddate').val(),
        async: false,
        datatype: 'json',
        jsonReader: {
            repeatitems: false
        },
        mtype: 'GET',
        colModel: [
            { name: 'plan_id', label: '編號', hidden: true },
            { name: 'plan_upload_case_no', label: '核定文號' },
            { name: 'plan_upload_name', label: '計畫名稱', align: 'center' },
            { name: 'plan_upload_date', label: '上傳日期', align: 'center' },
            { name: 'plan_upload_file_id_1', label: '檔案編號', hidden: true },
            { name: 'plan_upload_file_name_1', width: 200, label: '附件一', align: 'center', formatter: downloadfile1 },
            { name: 'plan_upload_file_type_1', label: '檔案類型', hidden: true },
            { name: 'plan_upload_file_id_2', label: '檔案編號', hidden: true },
            { name: 'plan_upload_file_name_2', width: 200, label: '附件二', align: 'center', formatter: downloadfile2 },
            { name: 'plan_upload_file_type_2', label: '檔案類型', hidden: true },
            { name: 'plan_upload_file_id_3', label: '檔案編號', hidden: true },
            { name: 'plan_upload_file_name_3', width: 200, label: '附件三', align: 'center', formatter: downloadfile3 },
            { name: 'plan_upload_file_type_3', label: '檔案類型', hidden: true },
            {
                name: '編輯', lable: '', formatter: showButton, align: 'center'
            },
        ],
        pager: '#pager',
        width: '100%',
        height: '100%',
        width: null,
        shrinkToFit: false,
        autowidth: true,
        rowNum: 10,
        rowList: [5, 10, 20, 50],
        sortname: 'Name',
        sortorder: "asc",
        viewrecords: true,
        loadonce: true
    });
    function showButton(cellvalue, options, rowObject) {
        return '<button type="button"  onclick="gotopage(\'' + rowObject.plan_upload_case_no + '\')">選擇</button><button type="button"  onclick="delMessage(\'' + rowObject.plan_upload_case_no + '\')">刪除</button>';
    }
    function downloadfile1(cellvalue, options, rowObject) {
        if (rowObject.plan_upload_file_name_1 != "")
            return '<button type="button" style="border:none;background:white;color:blue;text-decoration:underline;" onclick="ExportReort(\'' + rowObject.plan_upload_case_no + '\', \'' + rowObject.plan_upload_file_id_1 + '\')">' + rowObject.plan_upload_file_name_1 + '</button>';
        else
            return '<a></a>'
    }
    function downloadfile2(cellvalue, options, rowObject) {
        if (rowObject.plan_upload_file_name_2 != "")
            return '<button type="button" style="border:none;background:white;color:blue;text-decoration:underline;" onclick="ExportReort(\'' + rowObject.plan_upload_case_no + '\', \'' + rowObject.plan_upload_file_id_2 + '\')">' + rowObject.plan_upload_file_name_2 + '</button>';
        else
            return '<a></a>'
    }
    function downloadfile3(cellvalue, options, rowObject) {
        if (rowObject.plan_upload_file_name_3 != "")
            return '<button type="button" style="border:none;background:white;color:blue;text-decoration:underline;" onclick="ExportReort(\'' + rowObject.plan_upload_case_no + '\', \'' + rowObject.plan_upload_file_id_3 + '\')">' + rowObject.plan_upload_file_name_3 + '</button>';
        else
            return '<a></a>'
    }
    if ($('#MainContent_hidlevelcontrol').val() == "0") {
        $('#btnadd').show();
    }
    else if ($('#MainContent_hidlevelcontrol').val() == "1") {

        $("#PlanUploadGrid").jqGrid('setColProp', '編輯', { width: 0 });
        jQuery("#PlanUploadGrid").setGridParam().hideCol("編輯").trigger("reloadGrid");
        $('#btnadd').hide();
    }
}
function reloadgrid() {
    $("#PlanUploadGrid").jqGrid('setGridParam', {
        url: '../Service/PlanUpload.ashx?Type=tbl_planupload_data&Filter=' + $('#filter').val() + '&startdate=' + $('#startdate').val() + '&enddate=' + $('#enddate').val(),
        async: false,
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');
}
function gotopage(plan_id) {

    location.href = 'PlanUpload.aspx?id=' + plan_id;
}
function searchdata() {
    $("#PlanUploadGrid").jqGrid('setGridParam', {
        url: '../Service/PlanUpload.ashx?Type=tbl_planupload_data&id=' + findGetParameter('id') + '&startdate' + findGetParameter('startdate') + '&enddate' + findGetParameter('enddate'),
        datatype: 'json',
        page: 1
    }).trigger('reloadGrid');
}
function fileupload(file_id) {
    if ($('#tbcasno').val() == "") {
        alert('請輸入核定函號');
        return;
    }
    //## 宣告一個FormData
    var data = new FormData();
    //## 將檔案append FormData
    var files = $('#file' + file_id)[0].files;
    if (files[0].size > 5242880) {
        alert('檔案超過限制大小5MB')
        return;
    }
    if (files.length > 0) {
        data.append("UploadedFile", files[0]);
        data.append("file_id", $('#tbcasno').val() + '_' + file_id);
    }
    if (files[0] == null) {
        alert('請選擇檔案');
        return;
    }
    $.ajax({
        type: "POST",
        url: '../Service/PlanUpload.ashx?Type=plan_upload_file',
        async: false,
        dataType: "text",
        contentType: false,         // 告诉jQuery不要去這置Content-Type
        processData: false,         // 告诉jQuery不要去處理發送的數據 
        data: data,
        success: function (message) {
            var filename = $('#filename' + file_id);
            filename.html(files[0].name);
            alert('檔案上傳成功');
        },
        error: function (thrownError) {
            alert('檔案上傳失敗');
        }
    });

}
function filedelete(file_id) {
    if (confirm("確定要刪除嗎？")) {
        if ($('#tbcasno').val() == "") {
            alert('請輸入核定函號');
            return;
        }
        //## 宣告一個FormData
        var data = new FormData();
        //## 將檔案append FormData
        data.append("file_id", $('#tbcasno').val() + '_' + file_id);
        $.ajax({
            type: "POST",
            url: '../Service/PlanUpload.ashx?Type=plan_delete_file',
            async: false,
            dataType: "text",
            contentType: false,         // 告诉jQuery不要去這置Content-Type
            processData: false,         // 告诉jQuery不要去處理發送的數據 
            data: data,
            success: function (message) {
                alert('檔案刪除成功');
                var file = $('#filename' + file_id)
                file.html('');
            },
            error: function (thrownError) {
                alert('檔案刪除失敗');
            }
        });
    }
    else {
        return false;
    }
}
function saveplanuploaddata() {

    if ($('#tbcasno').val() == "") {
        alert('請輸入核定函號');
        return;
    }
    else if ($('#tbcasno').val() == "") {
        alert('請輸入計畫名稱');
        return;
    }
    if ($('#file1')[0].files != null) {
        fileupload('1');
    }
    if ($('#file2')[0].files != null) {
        fileupload('2');
    }
    if ($('#file3')[0].files != null) {
        fileupload('3');
    }
    //## 宣告一個FormData
    var data = new FormData();
    //## 將檔案append FormData
    data.append("id", $('#tbcasno').val());
    data.append("name", $('#tbname').val());
    data.append("remark", $('#taremark').val());

    var files = $('#file1')[0].files;
    if (files.length > 0) {
        data.append("file1name", files[0].name);
        data.append("file1type", files[0].type);
    }
    else if ($('#filename1').text().trim() != "") {
        data.append("file1name", $('#filename1').text());
        data.append("file1type", $('#filetype1').val());
    }
    else {
        data.append("file1name", "");
        data.append("file1type", "");
    }
    files = $('#file2')[0].files;
    if (files.length > 0) {
        data.append("file2name", files[0].name);
        data.append("file2type", files[0].type);
    }
    else if ($('#filename2').text().trim() != "") {
        data.append("file2name", $('#filename2').text());
        data.append("file2type", $('#filetype2').val());
    }
    else {
        data.append("file2name", "");
        data.append("file2type", "");
    }
    files = $('#file3')[0].files;
    if (files.length > 0) {
        data.append("file3name", files[0].name);
        data.append("file3type", files[0].type);
    }
    else if ($('#filename3').text().trim() != "") {
        data.append("file3name", $('#filename3').text());
        data.append("file3type", $('#filetype3').val());
    }
    else {
        data.append("file3name", "");
        data.append("file3type", "");
    }
    $.ajax({
        type: "POST",
        url: '../Service/PlanUpload.ashx?Type=save_plan_data',
        async: false,
        dataType: "text",
        contentType: false,         // 告诉jQuery不要去這置Content-Type
        processData: false,         // 告诉jQuery不要去處理發送的數據 
        data: data,
        success: function (message) {
            alert('儲存成功');
        },
        error: function (thrownError) {
            alert('儲存失敗');
        }
    });

    location.href = 'PlanUploadManage.aspx';
}
function getplandata() {
    if (findGetParameter('id') != 0)
        $.ajax({
            type: "GET",
            async: false,
            url: '../Service/PlanUpload.ashx?Type=loadplanuploaddata&id=' + findGetParameter('id'),
            dataType: "json",
            success: function (response) {
                $('#tbcasno').val(response[0].plan_upload_case_no);
                $('#tbname').val(response[0].plan_upload_name);
                $('#filename1').html(response[0].plan_upload_file_name_1);
                $('#filetype1').val(response[0].plan_upload_file_type_1);
                $('#filename2').html(response[0].plan_upload_file_name_2);
                $('#filetype2').val(response[0].plan_upload_file_type_2);
                $('#filename3').html(response[0].plan_upload_file_name_3);
                $('#filetype3').val(response[0].plan_upload_file_type_3);
                $('#taremark').val(response[0].plan_upload_remark);
            },
            error: function (thrownError) {
            }
        });
}
function delMessage(plan_id) {
    if (confirm("確定要刪除嗎？")) {
        $.ajax({
            type: "GET",
            async: false,
            url: '../Service/PlanUpload.ashx?Type=deleteplanuploaddata&id=' + plan_id,
            dataType: "text",
            success: function () {
                alert('刪除成功')
                reloadgrid();
            },
            error: function (thrownError) {
                alert('刪除失敗')
            }
        });
    } else {
        return false;
    }
}
function ExportReort(sid, fileid) {
    var url = '../Service/PlanUpload.ashx?Type=ExportFile&id=' + sid + '&file_id=' + fileid;
    window.open(url, "_blank");
}
function exportexcel() {
    var url = '../Service/PlanUpload.ashx?Type=exportexcel&Filter=' + $('#filter').val() + '&startdate=' + $('#startdate').val() + '&enddate=' + $('#enddate').val();
    window.open(url, "_blank");
}
function cancelupload() {
    var data = new FormData();
    //## 將檔案append FormData
    data.append("file_id", $('#tbcasno').val());
    $.ajax({
        type: "POST",
        url: '../Service/PlanUpload.ashx?Type=plan_delete_file_all',
        async: false,
        dataType: "text",
        contentType: false,         // 告诉jQuery不要去這置Content-Type
        processData: false,         // 告诉jQuery不要去處理發送的數據 
        data: data,
        success: function (message) {
        },
        error: function (thrownError) {
        }
    });
    location.href = 'PlanUploadManage.aspx';
}
