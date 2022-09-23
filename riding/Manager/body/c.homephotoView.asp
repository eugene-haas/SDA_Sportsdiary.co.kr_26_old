<%
If request("seq") = "" Then
  'Response.redirect "./contest.asp"
  Response.redirect "./homephoto.asp"
  Response.End
End if

total_board_seq = request("seq")

sql = "select SEQ,TITLE,REGNAME,left(convert(varchar, REGDATE,121),11) REGDATE,VISIT,DelYN,CONTENTS "_
&" from tblTotalBoard"_
&" where cate = '0' and SEQ ='"&total_board_seq&"'"

viewContents = null
Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
if not rs.eof then
  viewContents = rs.GetRows()
end if
set rs = Nothing

if isnull(viewContents) Then
  response.write "<script type='text/javascript'>"
  response.write "alert('경고 : 잘못된 접근!');"
  response.write "history.back();"
  response.write "</script>"
  response.end
end if
%>
<script type='text/javascript'>
function Image_Delete(total_board_seq, seq){
  if(confirm("해당 사진을 삭제하시겠습니까?")){
    //var strAjaxUrl="/pub/ajax/riding/photoDelete.asp?board_seq=" + board_seq + "&seq="+ seq +"";
	var strAjaxUrl="/pub/ajax/riding/imageDelete.asp?total_board_seq=" + total_board_seq + "&seq="+ seq +"";
    var retDATA="";
    $.ajax({
      type: 'GET',
      url: strAjaxUrl,
      dataType: 'html',
      success: function(retDATA) {
        if(retDATA){
          document.getElementById('photoArea').innerHTML = retDATA;
        }
      }
    }); //close $.ajax(
  }
}

function photo_delete(seq){
  if(confirm("정말 삭제하시겠습니까?")){
    location.href="./homephotoDel.asp?seq="+seq;
  }
}

function photo_update(seq){
  location.href="./homephotowrite.asp?seq="+ seq+"&flag=mod";
}
</script>

		<div class="admin_content">
					<!-- s: 정보 검색 -->
					<div class="info_serch form-horizontal" id="gameinput_area">

					<div class="form-group">

					<label class="col-sm-1 control-label">대회명</label>
					<label class="col-sm-1 control-label"  style="width:900px;text-align:left;"><%=viewContents(1,0)%></label>
					</div>

					<div class="form-group">
					<label class="col-sm-1 control-label">작성자</label>
					<label class="col-sm-1 control-label" style="text-align:left;"><%=viewContents(2,0)%></label>
					<label class="col-sm-1 control-label">작성일</label>
					<label class="col-sm-1 control-label" style="text-align:left;"><%=viewContents(3,0)%></label>
					<label class="col-sm-1 control-label">조회수</label>
					<label class="col-sm-1 control-label" style="text-align:left;"><%=viewContents(4,0)%></label>
					</div>

			</div>
			<!-- e: 정보 검색 -->
		</div>

  <div class="table-responsive" style="margin:10px;">
    <table cellspacing="0" cellpadding="0" class="table table-hover">
      <thead>
        <tr>
          <td colspan="2">
					<div class="btn-group pull-right" style="margin:3px;">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./homephoto.asp'" accesskey="i">목록</a>
					<a href="#" id="btnsave" class="btn btn-primary" onclick="photo_update('<%=total_board_seq%>')" accesskey="d">수정</a>
					<a href="#" id="btnsave" class="btn btn-primary" onclick="photo_delete('<%=total_board_seq%>')" accesskey="d">삭제</a>
					</div>
		  
		  </td>

		</tr>
      </thead>
      <tbody  class="gametitle">
	  
        <tr>
			<th>이미지</th>
			<td id="photoArea">
	<%
	  viewContents_photo = null
	  'sql_photo = "select Photo,idx from sd_Tennis_Stadium_Sketch_Photo where delyn = 'N' and Sketch_idx = '"& viewContents(9,0) &"' order by idx asc"
	  sql_photo = "select SEQ, TotalBoard_SEQ, FILENAME from tblTotalBoard_File where DelYN = 'N' and TotalBoard_SEQ = '"& viewContents(0,0) &"' order by SEQ asc"
	  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
	  if not rs_photo.eof then
		viewContents_photo = rs_photo.GetRows()
	  end if
	  set rs = Nothing

	  if isnull(viewContents_photo) = false Then
		for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
		  %>
		  <img src='http://Upload.sportsdiary.co.kr/sportsdiary<%=viewContents_photo(2,i)%>'>
		  <a href="javascript:Image_Delete('<%=viewContents(0,0)%>','<%=viewContents_photo(0,i)%>')"  class="btn btn-primary">이미지 삭제</a><br>
		  <%
		Next
	  end if
	%>
			</td>
		</tr>
		<tr>
			<th>내용</th>
			<td><%=viewContents(6,0)%></td>
		</tr>

	  </tbody>
    </table>
  </div>


<br><br><br><br>