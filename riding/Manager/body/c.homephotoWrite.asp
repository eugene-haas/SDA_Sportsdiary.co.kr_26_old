<%
flag = request("flag")

viewContents = null
modBoardTitle = ""
modBoardContents = ""
URIINFO = "/home/homephotoWrite.asp"
if flag = "mod" Then
  seq = request("seq")

  sql = "select TITLE, CONTENTS "_
  &" from tblTotalBoard "_
  &" where SEQ = '"& seq &"'"

  Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
  if not rs.eof then
    viewContents = rs.GetRows()
  end if
  set rs = Nothing
  modBoardTitle = viewContents(0,0)
  modBoardContents = viewContents(1,0)

  URIINFO = "/home/homephotoView.asp"
end if

%>
<script type='text/javascript'>

  function OK_Link(){
	  if (document.getElementById('board_title').value =='')
	  {
		  alert('제목을 입력해 주시기 바랍니다');
		  return;
	  }
	  document.form1.submit();
  }
  function OK_update(){
	  if (document.getElementById('board_title').value =='')
	  {
		  alert('제목을 입력해 주시기 바랍니다');
		  return;
	  }
	  document.form1.submit();
  }
</script>


  <!--<form id="form1" name="form1" action="/pub/up/imgUpload.riding.asp" method="post" ENCTYPE="multipart/form-data">-->
  <form id="form1" name="form1" action="/pub/up/homePhotoImgUpload.riding.asp" method="post" ENCTYPE="multipart/form-data">
  <input type="hidden" name="ReturnURI" value="<%=URIINFO%>">
  <input type="hidden" name="total_board_seq" value="<%=seq%>">
  <input type="hidden" name="flag" value="<%=flag%>">

		<div class="admin_content">
			<div class="page_title"><h1>이미지관리 > 등록</h1></div>

			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">

				<div class="form-group">

					<label class="col-sm-1 control-label">제목</label>
					<div class="col-sm-4">
						<input type="text" id="board_title" name="board_title" class="form-control" value="<%=modBoardTitle%>">
					</div>
				</div>

				<div class="form-group">
					<label class="col-sm-1 control-label">이미지등록</label>
					<div class="col-sm-2">
						<div class="input-group">
						<label class="control-label" ><input multiple="multiple"  type="file" name="iFile" id="iFile_1"/>  </label>(다중파일 선택가능)
						</div>
					</div>
				</div>

				<div class="form-group">
					<label class="col-sm-1 control-label">내용</label>
					<div class="col-sm-2" style="width:90%;">
						<textarea id="board_contents" name="board_contents" placeholder="내용을 입력해 주세요" class="form-control" style="height:200px;"><%=modBoardContents%></textarea>
					</div> 
				</div>

				<div class="btn-group flr" role="group" aria-label="...">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="<%if flag = "mod" then%>OK_update()<%else%>OK_Link()<%end if%>;" accesskey="i">저장</a>
					<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./homephoto.asp'" accesskey="i">목록</a>
				</div>

			</div>
			<!-- e: 정보 검색 -->
		</div>

  </form>
