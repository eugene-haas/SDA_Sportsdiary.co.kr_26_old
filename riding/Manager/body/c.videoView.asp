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

sql = "select GameTitleIDX,GameTitleName,gameNa,gameTypeE,gameTypeA,gameTypeL,pid,regdate,readnum,seq from "_
&" (select "_
&" STT.GameTitleIDX "_
&" ,STT.GameTitleName+' '+DD.TeamGbNm+' '+DD.levelNm+' '+DD.ridingclass+' '+DD.ridingclasshelp as GameTitleName "_
&" ,STT.gameNa "_
&" ,STT.gameTypeE "_
&" ,STT.gameTypeA "_
&" ,STT.gameTypeL "_
&" ,SRB.pid "_
&" ,replace(convert(varchar(10),SRB.Writeday,120),'-','.') as regdate "_
&" ,(select sum (a.readnum) from sd_RidingBoard_c a where a.seq = SRB.seq) as readnum "_
&" ,SRB.seq "_
&" from sd_TennisTitle STT "_
&" inner join sd_RidingBoard SRB on STT.GameTitleIDX = SRB.titleIDX "_
&" left join  "_
&" ( "_
&" 	select   "_
&" 	GameTitleIDX,  "_
&" 	gameno,  "_
&"  gbidx   "_
&"  from tblRGameLevel where DelYN = 'N'  "_
&"  group by GameTitleIDX,gameno,gbidx  "_
&" ) BB on SRB.levelNo = BB.gameno and SRB.titleIDX = STT.GameTitleIDX "_
&" left join tblTeamGbInfo DD on BB.GbIDX = DD.TeamGbIDX "_
&" where STT.DelYN = 'N' "& strWhere &" "_
&" ) A "_
&" where GameTitleIDX = '"& idx &"' and seq = '"& sketch_idx &"'"

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
function Video_Result(sketch_idx, idx){
  if(confirm("해당 영상을 삭제하시겠습니까?")){
    var strAjaxUrl="/pub/ajax/riding/videoDelete.asp?seq=" + sketch_idx + "&idx="+ idx +"";
    var retDATA="";
    $.ajax({
      type: 'GET',
      url: strAjaxUrl,
      dataType: 'html',
      success: function(retDATA) {
        if(retDATA){
          document.getElementById('videoArea').innerHTML = retDATA;
        }
      }
    }); //close $.ajax(
  }
}

function Video_insert(title,videoID,video_idx){
  strAjaxUrl = "/pub/ajax/riding/videoInsert.asp?videoid="+ videoID +"&video_idx="+video_idx+"&title=" + encodeURI(title);
  var retDATA="";
  $.ajax({
    type: 'GET',
    url: strAjaxUrl,
    dataType: 'html',
    success: function(retDATA) {
      if(retDATA){
        document.getElementById('videoArea').innerHTML = retDATA;
      }
    }
  }); //close $.ajax(
}
//TGROql_Xbl4
function getYoutubeTitle(video_idx,videoID) {
	var key, url
	key = "AIzaSyCd7b044KUd09iNRw-IVJZ8eYhQV73vrvY";
	url = "https://www.googleapis.com/youtube/v3/videos?id="+videoID+"&key="+key+"&fields=items(id,snippet(channelId,title))&part=snippet";
	$.ajax({
		url: url,
		dataType:'json',
		success:function(data){
			var result, videoTitle;
			result = data;
			videoTitle = result.items[0].snippet.title;
      Video_insert(videoTitle,videoID,video_idx);
		}
  });
}

function video_delete(seq){
  if(confirm("정말 삭제하시겠습니까?")){
    location.href="/videoDel.asp?seq="+seq;
  }
}

function previewVideo( e ) {
  var obj = {};
  var inputUrl, videoId, url;
  inputUrl = e;
  if ( inputUrl ) {
      // videoId = inputUrl.split("watch?v=")[1].substring(0, 11);
			videoId = getIdFromUrl(inputUrl);
      if ( videoId ) {
        url = "https://www.youtube.com/embed/" + videoId;
        $("#ytbFrame").attr('src', url);
      } else {
        alert("정상적인 주소가 아닙니다.");
      };
  } else {
    alert("주소를 입력해주세요.");
  };
}

function getIdFromUrl( videoUrl ) {
	var videoID;
	if ( videoUrl.indexOf("watch?v=") >= 0 ) {
		videoID = videoUrl.split("watch?v=")[1].substring(0, 11);
		return videoID;
	} else if ( videoUrl.indexOf("https://youtu.be/") >= 0 ) {
		videoID = videoUrl.split("https://youtu.be/")[1].substring(0, 11);
		return videoID;
	} else {
		return false;
	};
}

</script>










		<div class="admin_content">
			<div class="page_title"><h1>경기영상 > <%=viewContents(1,0)%></h1></div>


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
          <th>
			<div class="btn-group pull-right" style="margin:3px;">
			<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./video.asp'" accesskey="i">목록</a>
			<a href="#" id="btnsave" class="btn btn-primary" onclick="video_delete('<%=sketch_idx%>')" accesskey="d">삭제</a>
			</div>

		  </th>

		</tr>
      </thead>
      <tbody  class="gametitle">


        <tr>
			<td>


				  <label class="control-label col-sm-1">URL</label>
				  <div class="col-sm-2">
					<div class="input-group" style="width:800px;">
					  <input type="text" name="YTBURL" id="YTBURL" placeholder="ex) bbQwFTjIoTE" class="form-control " style="width:500px;">
					  <a href="javascript:getYoutubeTitle('<%=viewContents(9,0)%>',document.getElementById('YTBURL').value);" class="btn btn-primary">유튜브 URL 영상추가</a>
					  <!-- <input type="button" value="추가" onclick="getYoutubeTitle('<%=viewContents(9,0)%>',document.getElementById('YTBURL').value);"> -->
					  <input type="hidden" name="YTBTITLE" id="YTBTITLE">
					</div>
				  </div>

			</td>
		</tr>


        <tr>
			<td id="videoArea">
				<%
				  viewContents_photo = null
				  sql_photo = "select filename,idx from sd_RidingBoard_c where seq = '"& viewContents(9,0) &"' order by idx asc"
				  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
				  if not rs_photo.eof then
					viewContents_photo = rs_photo.GetRows()
				  end if
				  set rs = Nothing

				  if isnull(viewContents_photo) = false Then
					for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
					  %>
					  https://www.youtube.com/watch?v=<%=viewContents_photo(0,i)%>
					  <a href = 'javascript:previewVideo("https://www.youtube.com/watch?v=<%=viewContents_photo(0,i)%>")' class="btn btn-primary"> 미리보기</a>
					  <a href = 'javascript:Video_Result(<%=viewContents(9,0)%>,<%=viewContents_photo(1,i)%>)'  class="btn btn-danger">삭제</a>   <br/><br/>
					  <%
					Next
				  end if
				%>
			</td>
		</tr>


	  </tbody>
    </table>
  </div>

	<div class="form-group" style="margin:10px;">
	<span id="videoPreviewArea">
	  <iframe id="ytbFrame" src="" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
	</span>
	</div>
















<br><br><br><br>

<%If fdsafdsfdsfsd = "막아두고" then%>
	<div class="admin_content">
	  <a name="contenttop"></a>

	  <div class="btn-group pull-right">
		<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./video.asp'" accesskey="i">목록</a>
		<a href="#" id="btnsave" class="btn btn-primary" onclick="video_delete('<%=sketch_idx%>')" accesskey="d">삭제</a>
	  </div>

	  <div class="page_title"><h1>경기영상 > View - <%=viewContents(1,0)%></h1></div>
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
		  <label class="control-label col-sm-1">URL</label>
		  <div class="col-sm-2">
					<div class="input-group">
			  <input type="text" name="YTBURL" id="YTBURL" placeholder="ex) bbQwFTjIoTE"> <input type="button" value="추가" onclick="getYoutubeTitle('<%=viewContents(9,0)%>',document.getElementById('YTBURL').value);">
			  <input type="hidden" name="YTBTITLE" id="YTBTITLE">
			</div>
		  </div>
		</div>
		<div class="form-group">
		<span id="videoArea">
	<%
	  viewContents_photo = null
	  sql_photo = "select filename,idx from sd_RidingBoard_c where seq = '"& viewContents(9,0) &"' order by idx asc"
	  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
	  if not rs_photo.eof then
		viewContents_photo = rs_photo.GetRows()
	  end if
	  set rs = Nothing

	  if isnull(viewContents_photo) = false Then
		for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
		  response.write "https://www.youtube.com/watch?v="& viewContents_photo(0,i) &" <input type='button' value='미리보기' onclick='previewVideo(""https://www.youtube.com/watch?v="& viewContents_photo(0,i) &""")'> <input type='button' value='삭제' onclick='Video_Result("& viewContents(9,0) &","& viewContents_photo(1,i) &")'><br/><br/>"
		Next
	  end if
	%>
		</span>
		</div>

		<div class="form-group">
		<span id="videoPreviewArea">
		  <iframe id="ytbFrame" src="" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
		</span>
		</div>
	  </div>




	</div>
<%End if%>
