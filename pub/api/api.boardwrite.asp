        <form method="post" name="fbbs">
		<input type="hidden" name="pagec" value="1">
		<input type="hidden" name="tid" value="0">
		<input type="hidden" name="ref" value="0">
		<input type="hidden" name="step" value="0">
		<input type="hidden" name="level" value="0">

			제  목<br>
			<input type="text" name="title" id="wtitle" style="width:100%;">
			<textarea name="editor1" id="editor1" rows="10" cols="80" >
                
            </textarea>

		  <div class='set blue' style="float:left;">
			<a href="javascript:mx.writeOk()" class='btn pri ico'  style="content:'\f040'">글쓰기</a>
		  </div>		

		  <div class='set blue'  style="float:left;">
			<a href="javascript:javascript:mx.SendPacket(this, {'CMD':mx.CMD_BOARD, 'PG':'<%=pagec%>','TID':'<%=tid%>','SS':'<%=searchstr%>'})" class='btn pri'  style="content:'\f040'">목록</a>
		  </div>		
		</form>


<form id="file-form" action="upload_file.php" method="POST" enctype="multipart/form-data">
  <input type="file" id="file-select" name="photos[]" multiple  accept="image/*" style='margin-right:5px;'>
  <span class="text" id="upper">&nbsp;&nbsp;&nbsp;</span><span class="text">&nbsp;*.gif, jpg, jpeg, png 확장자</span>
  <input type="hidden" id="tid" name="tid" value="">
  <input type="submit" id="upload-button" value="파일올리기">
  <input type="button" id="my-upload-img" value="내파일목록" onmousedown="bbs.ExecuteCommand('myFileCmd')">
   <!-- [내가 올린 파일 목록 보기 삭제기능 넣기 0인전체 크기를 를 구해서 넘으면 지우라고 해야지] -->
</form>