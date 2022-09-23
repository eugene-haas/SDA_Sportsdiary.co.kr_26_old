<%
	If hasown(oJSONoutput, "IDX") = "ok" Then  
		pidx = chkStrRpl(oJSONoutput.IDX,"")
	End If
	If hasown(oJSONoutput, "IMGNO") = "ok" Then  
		imgno = chkStrRpl(oJSONoutput.IMGNO,"")
	End If

	Set db = new clsDBHelper


	'출전선수 정보
'	fld = " gametitlename "
	SQL = "SELECT top 1 profileIMG" & imgno & "  FROM tblplayer   WHERE delyn in ( 'N' ,'W') and playeridx = " & pidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
	If Not rs.EOF Then
		arM = rs.GetRows()

		imgurl = arM(0,0)
	End If
%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">사진업로드<%=SQL%></button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">



            <div class="box-body">



			<form id="FILEFORM" method="post" enctype="multipart/form-data" action="" style="padding:10px;overflow:hidden;">
				<h5>이미지 파일</h5>

				<div>
					<input type="hidden" id="hpidx" name="hpidx" value="<%=pidx%>">
					<input type="hidden" id="imgno" name="imgno" value="<%=imgno%>">
					<input type="file" id="ufile" name="ufile" style="display:inline-block;">
					<a class="btn btn-primary" href="javascript:mx.fileUp();">전송</a>
				</div>

				<div id="files" class="files" style="margin-top:10px;">
					<%If imgurl <> "" then%>
					<img src="http://upload.sportsdiary.co.kr/sportsdiary<%=imgurl%>" style="width:150px">
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

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
