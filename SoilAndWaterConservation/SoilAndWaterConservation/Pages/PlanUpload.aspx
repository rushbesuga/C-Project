<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="PlanUpload.aspx.cs" Inherits="Pages_PlanUpload" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src='/Scripts/PlanUpload.js' type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            getplandata();
        })

    </script>
    <div class="container-fluid">
        <div class="jumbotron div-center" style="background-color: white; padding-bottom: 0px; padding-top: 0px">
            <a class="div-cal-main-title">簡易水土保持計畫書上傳資料維護-資料上傳</a>
        </div>
        <div class="col-md-12 div-right" style="margin-bottom: 10px;">
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <label>核定函案號：</label>
                </div>
                <div class="col-md-9 div-right" style="margin-bottom: 10px;">
                    <input type="text" id="tbcasno" style="min-width: 100%" />
                </div>
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <label>計畫名稱：</label>
                </div>
                <div class="col-md-9 div-right" style="margin-bottom: 10px;">
                    <input type="text" id="tbname" style="min-width: 100%" />
                </div>
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <label>附件一：</label>
                </div>
                <div class="col-md-6 div-right" style="margin-bottom: 10px;">
                    <input type="file" id="file1" name="filename" accept=".pdf, .doc, .docx, .xls, .xlsx, .jpg, .jpeg, .png">
                </div>
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <input type="button" id="btnuploadfile1" value="上傳檔案" onclick="fileupload('1')">
                    <input type="button" id="btndeletefile1" value="刪除檔案" onclick="filedelete('1')">
                </div>
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                </div>
                <div class="col-md-6 div-left" style="margin-bottom: 10px;">
                    已上傳檔案：
                      <label id="filename1" />
                </div>
                <input type="text" id="filetype1" hidden />
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <label>附件二：</label>
                </div>
                <div class="col-md-6 div-right" style="margin-bottom: 10px;">
                    <input type="file" id="file2" name="filename" accept=".pdf, .doc, .docx, .xls">
                </div>
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <input type="button" id="btnuploadfile2" value="上傳檔案" onclick="fileupload('2')">
                    <input type="button" id="btndeletefile2" value="刪除檔案" onclick="filedelete('3')">
                </div>
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                </div>
                <div class="col-md-6 div-left" style="margin-bottom: 10px;">
                    已上傳檔案：
                      <label id="filename2" />
                </div>
                <input type="text" id="filetype2" hidden />
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <label>附件三：</label>
                </div>
                <div class="col-md-6 div-right" style="margin-bottom: 10px;">
                    <input type="file" id="file3" name="filename" accept=".pdf, .doc, .docx, .xls">
                </div>
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <input type="button" id="btnuploadfile3" value="上傳檔案" onclick="fileupload('3')">
                    <input type="button" id="btndeletefile3" value="刪除檔案" onclick="filedelete('3')">
                </div>
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                </div>
                <div class="col-md-6 div-left" style="margin-bottom: 10px;">
                    已上傳檔案：
                      <label id="filename3" />
                </div>
                <input type="text" id="filetype3" hidden />
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-3 div-right" style="margin-bottom: 10px;">
                    <label>備註：</label>
                </div>
                <div class="col-md-9 div-right" style="margin-bottom: 10px;">
                    <textarea id="taremark" style="min-width: 100%">  </textarea>
                </div>
            </div>
            <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                <div class="col-md-12 div-right" style="margin-bottom: 10px;">
                    <input type="button" style="" value="儲存" onclick="saveplanuploaddata()" />
                    
                    <input type="button" style="" value="取消" onclick="cancelupload()" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
