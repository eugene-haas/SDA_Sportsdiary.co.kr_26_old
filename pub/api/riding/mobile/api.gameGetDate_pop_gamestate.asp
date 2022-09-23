<%
'#############################################
'경기일정 팝업
'#############################################
	'request

	Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
    tidx = fInject(oJSONoutput.tidx)
  End if

  function replaceHTML(html)
  	html = replace(html,"&lt;","<")
  	html = replace(html,"&quot;","""")
  	html = replace(html,"&gt;",">")
  	html = replace(html,"&amp;","&")
  	replaceHTML = html
  end function

	if tidx = "undefined" Then tidx = "0"

  sql = "select isnull(summary,''),noticetype,summaryimg,filenames from sd_TennisTitle where GameTitleIDX = '"& tidx &"'"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  innerHtml = ""
  if not rs.eof Then
    innerHtml = replaceHTML(rs(0))
	noticetype = rs(1)
	imgs = rs(2)
	files = rs(3)
	Select Case CStr(noticetype)
	Case "1" 'html 공지
		contents = innerHtml
	Case "2" '이미지 공지
		If isnull(imgs) = True Then
			contents = innerHtml
		Else
			imgarr = Split(imgs,";")
			For i = 0 To ubound(imgarr)

				contents = contents & "<img src="""&CONST_UPIMG& imgarr(i)&"""><br>"
			next
		End If
	End select
  end If
  
	'첨부파일이 있다면
	If isnull(files) = False And files <> "" Then

		filearr = Split(files,";")
		For i = 0 To ubound(filearr)

			pnm = LCase(Mid(filearr(i), InStrRev(filearr(i), "/") + 1))	
			addfilehtml = addfilehtml & "<a href="""&CONST_UPIMG& filearr(i)&""">"&pnm&"</a><br>"
		next
	End if

  db.Dispose
  Set db = Nothing



%>
<!-- div class="contestFile__inner" v-bind:class="{s_nofile: !addFile, s_on: addFileView}">
  <button class="contestFile__filebtn m_ibarea" @click="addFileShow">
    <p>첨부파일</p><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/arrow_drop_down_solid_@3x.png" alt=""></div><span>2개</span>
  </button>
  <button class="contestFile__allsave m_ibarea" v-if="addFile" @click="fileDownAll">
    <p>모두저장</p><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/download_navy_@3x.png" alt=""></div>
  </button>
</div>

<div class="contestFile__list [ _fileList ]" v-if="addFileList!='0'">

	<a href="다운로드경로" class="contestFile__down" download>
		<p>파일명입니다.</p>
		<div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/download_gray_@3x.png" alt=""></div>
	</a>

</div -->


<%=addfilehtml%>

<div class="contest__info">
	<div><%=contents%></div>
</div>
