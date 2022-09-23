<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":30002,""SENDPRE"":""rule_"",""IDX"":53}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	CMD = oJSONoutput.Get("CMD")
	SENDPRE = oJSONoutput.Get("SENDPRE")

'#############################################
	'request
	If hasown(oJSONoutput, "SEQ") = "ok" then
		reqseq = oJSONoutput.Get("SEQ")
		If isnumeric(reqseq) = False Then
			Response.end
		End if
	End if

	If hasown(oJSONoutput, "CHKNO") = "ok" then
		chkno = oJSONoutput.Get("CHKNO")
	End If


	Set db = new clsDBHelper

	tablename = "tblSimpleBoard"
	strFieldName = " CATE,TITLE,FILE_PATH,FILE_NAME  "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql & "  from " & tablename
	strSql = strSql &  " WHERE seq = " & reqseq
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)

	If Not rs.eof Then

		e_cate			= rs(0)
		e_title			= rs(1)
		e_file_path		= rs(2)
		e_file_name		= rs(3)
		e_seq				= reqseq
	End if

	db.Dispose
	Set db = Nothing


%>
<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">파일업로드</button></h4>
    </div>

    <div class="modal-body">
      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">

            <div class="box-body">


			<form id="FILEFORM" name ="FILEFORM" method="post" enctype="multipart/form-data" action="" style="padding:10px;overflow:hidden;">
				<h5>HWP,DOC,PDF,EXL,JPG,PNG</h5>
				<div>
					<input type="hidden" id="SC" name="SC" value="<%=sitecode%>">
					<input type="hidden" id="SEQ" name="SEQ" value="<%=reqseq%>">
					<input type="hidden" id="SENDPRE" name="SENDPRE" value="<%=SENDPRE%>">
					<input type="hidden" id="CHKNO" name="CHKNO" value="<%=chkno%>">

					<input type="file" id="upfile" name="upfile" style="display:inline-block;">
					<a class="btn btn-primary" href="javascript:mx.fileUpload();">전송</a>
				</div>

				<div id="files" class="files" style="margin-top:10px;">
					<%=CONST_UPHTTP%><%=e_file_path & e_file_name%>
				</div>

			</form>


            </div>
          </div>
        </div>

	  </div>
	<%'#######################################################%>
      </div>
    </div>

  </div>
</div>
