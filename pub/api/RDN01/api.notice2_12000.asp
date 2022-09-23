<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
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

	tablename = "tblTotalBoard_file "
	strFieldName = " FILENAME  "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql & "  from " & tablename
	strSql = strSql &  " WHERE TotalBoard_SEQ = " & reqseq
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then

		e_ProfileIMG			= rs(0)
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
				<%Select case chkno%>
				<%Case "1"%>
				<h5>HWP,DOC,PDF,EXL,JPG,PNG</h5>
				<%Case "2"%>
				<h5>JPG,PNG  (120*161) 크기로 맞추어서 올려주세요</h5>
				<%End Select %>
				<div>
					<input type="hidden" id="SC" name="SC" value="<%=sitecode%>">
					<input type="hidden" id="SEQ" name="SEQ" value="<%=reqseq%>">
					<input type="hidden" id="SENDPRE" name="SENDPRE" value="<%=SENDPRE%>">
					<input type="hidden" id="CHKNO" name="CHKNO" value="<%=chkno%>">

					<input type="file" id="upfile" name="upfile" style="display:inline-block;">
					<a class="btn btn-primary" href="javascript:mx.fileUpload();">전송</a>
				</div>

				<div id="files" class="files" style="margin-top:10px;">
					<%If e_ProfileIMG <> "" then%>
					<img src = "<%=CONST_UPHTTP%><%=e_ProfileIMG%>">
					<%=CONST_UPHTTP%><%=e_ProfileIMG%>
					<%End if%>
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

