<%
'----------------------------------------------------------------------
'@description
'	왼쪽메뉴를 자동으로 구성한다.
'	왼쪽메뉴 현재 위치를 파악한 후 열어준다.
'	관리자 계정의 권한에 맞는지 검사한다.
'@param
'	db : 오픈한 database ref
'	dbopentype : dbopentypeA(class) , else (기본형태)
'	pagename : 비교한 현재 페이지명
'	loginID : 로그인한 관리자 계정
'@return
'	(string) 패스정보를 반환한다.
'----------------------------------------------------------------------
Function setLeftMenu(ByRef db, ByVal pagename, ByVal loginID, ByVal logoutpage, ByVal req, ByVal chkrule, ByVal open_ConStr)

	Dim mno,mno2, i,j, SQL, rs, ar, LFD1, LFD2, LFDCNT, ar2, newWindow, bodyTarget, leftlink, admidx1,adminidx2 ,collapsed, panelcollapse,returnpage
	Dim d1str, d2str, d3str, linkfilename
	Dim arrLF(3)

	'3댑스까지만 사용
	For i = 2 To 4

		SQL = "EXEC AdminMember_Menu_S '" & i & "','','','" & loginID & "','','','','','"&Sitecode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, open_ConStr)

		If Not rs.EOF Then
			arrLF(i-1) = rs.GetRows()
		End if
	Next
	'3댑스까지만 사용

	'댑스 1일때 mno 구하기
	mno = -1
	mno2 = -1
	i = 0
	If IsArray(arrLF(1)) Then
		For ar = LBound(arrLF(1), 2) To UBound(arrLF(1), 2)
		j = 0
		LFD1 = arrLF(1)(1, ar)

		If IsArray(arrLF(2)) Then
		For ar2 = LBound(arrLF(2), 2) To UBound(arrLF(2), 2)

			If LFD1 = arrLF(2)(1, ar2) Then

				If IsArray(arrLF(3)) Then
				For ar3 = LBound(arrLF(3), 2) To UBound(arrLF(3), 2)
				LFD2 = arrLF(2)(3, ar2)
						If LFD2 = arrLF(3)(4, ar3) Then

						  '##########"
						  leftlink = LCase(arrLF(3)(6, ar3))
						  linkfilename = LCase(Mid(leftlink, InStrRev(leftlink, "/") + 1))
						  If Split(pagename,".")(0) = Split(linkfilename,".")(0) Then
							'열어야할 현재 메뉴 번호
							mno = i
							mno2 = j
							returnpage = leftlink
						  ElseIf pagename = "index.asp" Then
                              mno = 999
                              mno2 = 999
                              returnpage = leftlink
						  End If
						  '##########"

						End If
				Next
				End If

			End if
		j = j + 1
		Next
		End if

		i = i + 1
		Next
	End if

	'접근권한 없음 (메뉴를 타고 들어가는 페이지 처리는? 예: contestlevel.asp)
	If (CDbl(mno) = -1 Or CDbl(mno2) =  -1) And chkrule = true Then
		%>
		<script type="text/javascript">
		<!--
			px.obj = <%=req%>;
			px.obj.returnurl = "<%=returnpage%>";
			px.go(px.obj, "<%=logoutpage%>");
		//-->
		</script>
		<%
		Response.end
	End if
	'접근권한 없음

	'##################################
	'print
	'##################################
	If IsArray(arrLF(1)) Then
		For ar = LBound(arrLF(1), 2) To UBound(arrLF(1), 2)

		admidx1 = arrLF(1)(0, ar)

		LFD1 = arrLF(1)(1, ar)
		If ar = Cdbl(mno) Then '오픈
			collapsed = "on"
			panelcollapse = " in"
			d1str = arrLF(1)(2, ar) '첫번째주소.
		Else
			collapsed = "collapsed"
			panelcollapse = ""
		End if
		%>

				  
		<li>
			<input id="group-<%=ar+1%>" type="checkbox" hidden  <%If ar = Cdbl(mno) then%>checked<%End if%>/><!-- 현재 메뉴번호랑같다면 열고 -->
			<label for="group-<%=ar+1%>"><span class="fa fa-angle-right"></span><%=arrLF(1)(2, ar)%></label>
				<%
						Response.write "<ul class=""group-list"">"

						For ar2 = LBound(arrLF(2), 2) To UBound(arrLF(2), 2)
							admidx2 = arrLF(2)(0, ar2)
							LFD2 = arrLF(2)(3, ar2)
							'If LFD1 = arrLF(2)(1, ar2) And admidx2 = "1" OR "4" then
							If LFD1 = arrLF(2)(1, ar2) then

										If IsArray(arrLF(3)) Then
											For ar3 = LBound(arrLF(3), 2) To UBound(arrLF(3), 2)

												If LFD2 = arrLF(3)(4, ar3) Then
													  newWindow = arrLF(3)(7, ar3) 'YN
													  If newWindow = "Y" Then
														bodyTarget = " target=""_blank"" "
													  Else
														bodyTarget = ""
													  End If

													  leftlink = LCase(arrLF(3)(6, ar3))
													  linkfilename = LCase(Mid(leftlink, InStrRev(leftlink, "/") + 1))
													  d3str = arrLF(3)(1, ar3)

													  If Split(pagename,".")(0) = Split(linkfilename,".")(0) Then
														d3str = d3str & " ▶"
													  End If
									 
													  Response.write "<li><a href="""&leftlink&""" "&bodyTarget&">"&d3str&"</a></li>"
												End If
											Next
										End if

							End if
						Next

						Response.write "</ul>"
				%>
		</li>
		<%
		Next
	End if

	setLeftMenu = d1str&"|"&d3str

End Function

%>





  <nav class="nav" role="navigation">
    <ul class="nav__list">
<%
	'Cookies_aID = "20170703"  'test
	If Cookies_aID =  "" Then
		Response.redirect "/pub/login/admLogin.asp"
		Response.end
	End if
	menustr =  setLeftMenu(db, PAGENAME, Cookies_aID, logouturl, reqjson, chkrule, B_ConStr)

	'menustr = Split(menustr,"|")

	'Response.write menustr  //패스지정할때 사용
%>

    <ul>
  </nav>







<%If fdjskaljfdskl= "1" then%>



<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->




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


  </nav>	


  <%End if%>