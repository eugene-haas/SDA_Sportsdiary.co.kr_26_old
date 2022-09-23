
	<!-- left fulldown menu -->
  <nav class="nav" role="navigation">
    <ul class="nav__list">
	  <%
		pagename = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))
		Select Case pagename
		Case "contest.asp","makeplayer.asp","maketeam.asp","gamehost.asp","contestplayer.asp","titlecode.asp","SmsSearch.asp"
		mno = 1
		Case "contestlevel.asp"
		mno = 0
		%><li><a href="./contest.asp" id="btnsave" class="btn back_btn">< 이전으로가기</a></li><%
		Case Else
		mno = 0
		End Select 




	  'mno = request.cookies("mno")'선택된 메뉴번호
	  If mno = "" Then
		  mno = 0
	  End if

	  'leftmenuarr = array("관리자관리", "선수관리","대회관리","경기관리","소속관리")
If CDbl(ADGRADE) > 500 then
	  leftmenuarr = array("대회관리")
	  'leftmenuarr = array("대회관리","기록","게시판")
Else
	  leftmenuarr = array("대회관리")
End if

	 sm2 = ubound(leftmenuarr)

    Dim smenudata(6)
	Dim smenucmd(6)

    'smenudata(0)="관리자관리|태블릿신청|일별관리자수|월별통계"
    'smenudata(1)="팀코드관리|회원명단|선수명단|지도자명단"

If CDbl(ADGRADE) > 500 then

	smenudata(0)="대회정보관리|선수관리|팀관리|대회주최|대회등급관리|랭킹포인트관리|문자발송"
    'smenudata(1)="랭킹순위"
	'smenudata(2)="회원관리|공지사항|Q&A게시판|FAQ게시판"

    'smenucmd(0)="mx.CMD_TABLELIST|mx.CMD_DBBASIC|3|3"
    'smenucmd(1)="mx.CMD_IISINFO|3|./PlayerInfo.asp|3"

	smenucmd(0)="./contest.asp|./makePlayer.asp|./makeTeam.asp|./gamehost.asp|./titleCode.asp|./Rankplayer.asp|./SmsSearch.asp|"
    'smenucmd(1)="mx.CMD_USERINFO"
    'smenucmd(2)="mx.CMD_USERINFO|3|3|3"
Else

	smenudata(0)="대회정보관리"
	smenucmd(0)="./contest.asp"

End if


	  For n = 0 To sm2
		dowmu = Split(smenudata(n),"|")
		dowcmd = Split(smenucmd(n),"|")

	  %>
	  <li>
        <input id="group-<%=n+1%>" type="checkbox" hidden  <%If n = Cdbl(mno-1) then%>checked<%End if%>/>
        <label for="group-<%=n+1%>"><span class="fa fa-angle-right"></span> <%=leftmenuarr(n)%></label>
        <ul class="group-list">
		<%
		linkno = 0		  
		For x = 0 To ubound(dowmu)
			If InStr(dowcmd(x), ".asp") > 0 Then
			  Response.write "<li><a href="""&dowcmd(x)&""">"& dowmu(x) &"</a></li>"			
			else
			  Response.write "<li><a href=""javascript:mx.SendPacket(this, {'CMD':"&dowcmd(x)&"});"">"& dowmu(x) &"</a></li>"
			End if
		Next
		%>
        </ul>
      </li>
	  <%next%>
    </ul>



	<%If CDbl(ADGRADE) > 500 then%>
		<a href="findcontestplayer.asp"  >대회신청정보</a>
	<%End if%>
	<!-- <a href="http://tennisadmin.sportsdiary.co.kr/gamerullfree.asp?tidx=28&ridx=20105001"  >본선대진생성</a>	   -->
	<a href="/gamerull3.asp?tidx=28&ridx=20105001"  >(신)본선대진생성</a>

<%
'#################################
If USER_IP = "118.33.86.240-" Then
	If CDbl(ADGRADE) > 500 then
	%>
		<hr width="100%" style="margin:0;padding:0;">
		<a href="rank2017.asp"  >랭킹포인트업로드</a>
		<a href="tool.asp"   >선수정리</a>
		<a href="http://tennis.sportsdiary.co.kr/tennis/SD_OS/testadmin.asp" target="_blank"   >테스트데이터삭제</a>
		<a href="tennisDbCenter.asp"   >NEW테스트데이터삭제</a>
		<a href="operator.asp"   >운영자관리</a>
		<hr width="100%" style="margin:0;padding:0;">

	<%
	End if
End if%>

<%If USER_IP = "118.33.86.240" Then%>
<a href="operator.asp"   >운영자관리</a>
<%End if%>

	<!-- <a href="gamerull.asp" >본선대진생성</a> -->
	<a href="http://ikata.sportsdiary.co.kr/Katalanking/player_lanking/list.asp" target="_blank">랭킹순위</a>

	<%If CDbl(ADGRADE) > 500 then%>	
		<%If USER_IP = "118.33.86.240-" Then%>
		<a href="gamedebug.asp" >경기운영디버그</a>
		<a href="dataupload.asp" >예선편성표등록</a>
		<%End if%>
	<%else%>
<%End if%>

 
  <%If USER_IP = "118.33.86.240" Then%>
	<a href="tennisDbCenter.asp"   >테이블백업</a>
  <%End if%>


	<a href="http://www.ikata.org/board/bbs/board.php?bo_table=apply_modi"   target="_blank">참가신청변경요청</a>

  </nav>	