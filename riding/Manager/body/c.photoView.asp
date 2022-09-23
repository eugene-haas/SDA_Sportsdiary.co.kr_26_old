<%
function codecheck(gubun)
  select case gubun
    case "F"
      codecheck = "국제"
    case Else
      codecheck = "국내"
  end select
end function

If request("idx") = "" Then
  Response.redirect "./contest.asp"
  Response.End
End if

idx = request("idx")
sketch_idx = request("sketch_idx")

sql = "select GameTitleIDX,GameTitleName,gameNa,gameTypeE,gameTypeA,gameTypeL,UserName,regdate,ViewCnt,Idx "_
&" from "_
&" (select "_
&"	STT.GameTitleIDX, "_
&"	STT.GameTitleName , "_
&"	STT.gameNa , "_
&"	STT.gameTypeE , "_
&"	STT.gameTypeA , "_
&"	STT.gameTypeL , "_
&"	STSS.UserName , "_
&"	replace(convert(varchar(19),STSS.Writeday,120),'-','.') as regdate , "_
&"	STSS.ViewCnt, "_
&" 	STSS.Idx "_
&"	from sd_TennisTitle STT inner join sd_Tennis_Stadium_Sketch STSS on STT.GameTitleIDX = STSS.GameTitleIDX and STSS.Delyn = 'N' "_
&"	where STT.DelYN = 'N' ) A "_
&" where GameTitleIDX = '"& idx &"' and idx = '"& sketch_idx &"'"

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
function Sketch_Result(sketch_idx, idx){
  if(confirm("해당 사진을 삭제하시겠습니까?")){
    var strAjaxUrl="/pub/ajax/riding/photoDelete.asp?sketch_idx=" + sketch_idx + "&idx="+ idx +"";
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

function Sketch_delete(sketch_idx){
  if(confirm("정말 삭제하시겠습니까?")){
    location.href="/photoDel.asp?sketch_idx="+sketch_idx;
  }
}

function Sketch_update(idx,sketch_idx){
  location.href="/photowrite.asp?idx="+ idx +"&sketch_idx="+sketch_idx+"&flag=mod";
}
</script>










		<div class="admin_content">
			<div class="page_title"><h1>현장스케치 > <%=viewContents(1,0)%></h1></div>






					<!-- s: 정보 검색 -->
					<div class="info_serch form-horizontal" id="gameinput_area">

					<div class="form-group">

					<label class="col-sm-1 control-label">대회명</label>
					<label class="col-sm-1 control-label"  style="width:900px;text-align:left;"><%=viewContents(1,0)%>
					

					&nbsp;&nbsp;[
					<%
					  response.write codecheck(viewContents(2,0))
					  if viewContents(3,0) = "Y" then response.write "/" & "전문"
					  if viewContents(4,0) = "Y" then response.write "/" & "생활"
					  if viewContents(5,0) = "Y" then response.write "/" & "유소년"
					%>
					  ]					

					
					</label>
					<!-- <div class="col-sm-2" style="width:500px;"><%=viewContents(1,0)%></div> -->

<!-- 
					<div class="col-sm-2">
					  <label class="control-label" style="float:left;">[
					<%
					  response.write codecheck(viewContents(2,0))
					  if viewContents(3,0) = "Y" then response.write "/" & "전문"
					  if viewContents(4,0) = "Y" then response.write "/" & "생활"
					  if viewContents(5,0) = "Y" then response.write "/" & "유소년"
					%>
					  ]</label>
					</div> -->
					</div>

					<div class="form-group">
					<label class="col-sm-1 control-label">작성자</label>
					<label class="col-sm-1 control-label" style="text-align:left;"><%=viewContents(6,0)%></label>
					<label class="col-sm-1 control-label">작성일</label>
					<label class="col-sm-1 control-label" style="text-align:left;"><%=Left(viewContents(7,0),10)%></label>
					<label class="col-sm-1 control-label">조회수</label>
					<label class="col-sm-1 control-label" style="text-align:left;"><%=viewContents(8,0)%></label>
					</div>










			</div>
			<!-- e: 정보 검색 -->
		</div>



  <div class="table-responsive" style="margin:10px;">
    <table cellspacing="0" cellpadding="0" class="table table-hover">
      <thead>
        <tr>
          <th>현장스케치

		  
					<div class="btn-group pull-right" style="margin:3px;">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./photo.asp'" accesskey="i">목록</a>
					<a href="#" id="btnsave" class="btn btn-primary" onclick="Sketch_update('<%=idx%>','<%=sketch_idx%>')" accesskey="d">수정</a>
					<a href="#" id="btnsave" class="btn btn-primary" onclick="Sketch_delete('<%=sketch_idx%>')" accesskey="d">삭제</a>
					</div>
		  
		  </th>

		</tr>
      </thead>
      <tbody  class="gametitle">
	  
        <tr>
			<td id="photoArea">
	<%
	  viewContents_photo = null
	  sql_photo = "select Photo,idx from sd_Tennis_Stadium_Sketch_Photo where delyn = 'N' and Sketch_idx = '"& viewContents(9,0) &"' order by idx asc"
	  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
	  if not rs_photo.eof then
		viewContents_photo = rs_photo.GetRows()
	  end if
	  set rs = Nothing

	  if isnull(viewContents_photo) = false Then
		for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
		  %>
		  <img src='http://Upload.sportsdiary.co.kr/sportsdiary<%=viewContents_photo(0,i)%>'>
		  <a href="javascript:Sketch_Result('<%=viewContents(9,0)%>','<%=viewContents_photo(1,i)%>')"  class="btn btn-primary">이미지 삭제</a><br>
		  <%
		Next
	  end if
	%>
			</td>
		</tr>


	  </tbody>
    </table>
  </div>






<!-- ///아래는 이전 소스/////////////////////////////////////////////////////////////////////////////////////////////// -->
<%If aaaaddddd= "fdsafkds" then%>

	<div class="admin_content">
	  <a name="contenttop"></a>

	  <div class="btn-group pull-right">
		<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./photo.asp'" accesskey="i">목록</a>
		<a href="#" id="btnsave" class="btn btn-primary" onclick="Sketch_update('<%=idx%>','<%=sketch_idx%>')" accesskey="d">수정</a>
		<a href="#" id="btnsave" class="btn btn-primary" onclick="Sketch_delete('<%=sketch_idx%>')" accesskey="d">삭제</a>
	  </div>

	  <div class="page_title"><h1>현장스케치 > View - <%=viewContents(1,0)%></h1></div>

	  <div class="form-horizontal">
		<div class="form-group">
		  <label class="control-label col-sm-1">대회명</label>
		  <div class="col-sm-2">
					<div class="input-group">
			  <label class="control-label" style="float:left;"><%=viewContents(1,0)%></label>
			</div>
		  </div>
		  <label class="control-label col-sm-1">국제구분</label>
		  <div class="col-sm-2">
					<div class="input-group">
			  <label class="control-label" style="float:left;">
			<%
			  response.write codecheck(viewContents(2,0))
			  if viewContents(3,0) = "Y" then response.write "/" & "전문"
			  if viewContents(4,0) = "Y" then response.write "/" & "생활"
			  if viewContents(5,0) = "Y" then response.write "/" & "유소년"
			%>
			  </label>
			</div>
		  </div>
		</div>
		<div class="form-group">
		  <label class="control-label col-sm-1">작성자</label>
		  <div class="col-sm-2">
					<div class="input-group">
			  <label class="control-label" style="float:left;"><%=viewContents(6,0)%></label>
			</div>
		  </div>
		  <label class="control-label col-sm-1">작성일</label>
		  <div class="col-sm-2">
					<div class="input-group">
			  <label class="control-label" style="float:left;"><%=viewContents(7,0)%></label>
			</div>
		  </div>
		  <label class="control-label col-sm-1">조회수</label>
		  <div class="col-sm-2">
					<div class="input-group">
			  <label class="control-label" style="float:left;"><%=viewContents(8,0)%></label>
			</div>
		  </div>
		</div>

		
		
		<div class="form-group">
		<span id="photoArea">
	<%
	  viewContents_photo = null
	  sql_photo = "select Photo,idx from sd_Tennis_Stadium_Sketch_Photo where delyn = 'N' and Sketch_idx = '"& viewContents(9,0) &"' order by idx asc"
	  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
	  if not rs_photo.eof then
		viewContents_photo = rs_photo.GetRows()
	  end if
	  set rs = Nothing

	  if isnull(viewContents_photo) = false Then
		for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
		  response.write "<img src='http://Upload.sportsdiary.co.kr/sportsdiary"& viewContents_photo(0,i) & "'><input type='button' value='삭제' onclick='Sketch_Result("& viewContents(9,0) &","& viewContents_photo(1,i) &")'><br/>"
		Next
	  end if
	%>
		</span>
		</div>
	  </div>




	</div>
<%End if%>

<br><br><br><br>