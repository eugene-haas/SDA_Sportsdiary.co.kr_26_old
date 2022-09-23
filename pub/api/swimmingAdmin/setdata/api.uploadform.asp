<%
	If hasown(oJSONoutput, "TIDX") = "ok" Then  
		tidx = chkStrRpl(oJSONoutput.TIDX,"")
	End If


	Set db = new clsDBHelper


	'출전선수 정보
	fld = " gametitlename "
	SQL = "SELECT top 4 " & fld & "  FROM sd_gameTitle   WHERE delyn = 'N' and  gametitleidx = " & tidx
'
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
	If Not rs.EOF Then
		arM = rs.GetRows()
	End If
%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">출전명단 업로드</button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">



            <div class="box-body">



			<form id="FILEFORM" method="post" enctype="multipart/form-data" action="" style="padding:10px;overflow:hidden;">
				<h5>exl만 허용</h5>

				<div>
					<input type="hidden" id="gametitleidx" name="gametitleidx" value="<%=tidx%>">
					<input type="file" id="exlfile" name="exlfile" style="display:inline-block;">
					<a class="btn btn-primary" href="javascript:mx.fileUpload();">전송</a>
				</div>

				<div id="files" class="files" style="margin-top:10px;">
				
				</div>
				맨위에 타이틀을 붙여서 업로드 하여주십시오. 없을시 한명 누락될수 있습니다.
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
