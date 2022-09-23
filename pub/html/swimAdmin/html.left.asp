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


		<!-- <li> -->
		<div class="card">
			<!--
			<input id="group-<%=ar+1%>" type="checkbox" hidden  <%If ar = Cdbl(mno) then%>checked<%End if%>/><!-- 현재 메뉴번호랑같다면 열고 -->
			<!-- <label for="group-<%=ar+1%>"><span class="glyphicon glyphicon-menu-right"></span><%=arrLF(1)(2, ar)%></label> -->
			<button class="btn btn-link <%If ar = Cdbl(mno) then%><%Else%>collapsed<%End if%>" data-toggle="collapse" data-target="#group-<%=ar+1%>" aria-expanded="<%If ar = Cdbl(mno) then%>true<%Else%>false<%End if%>" aria-controls="group-<%=ar+1%>"><%=arrLF(1)(2, ar)%><span class="glyphicon glyphicon-menu-right"></span></button>
				<%
						<!-- '.Response.write "<ul class=""group-list"">" -->
						If ar = Cdbl(mno) then
						Response.write "<div id=""group-"&ar+1&""" class=""collapse in""  data-parent=""#accordion"">"
						Else
						Response.write "<div id=""group-"&ar+1&""" class=""collapse""  data-parent=""#accordion"">"
						End If
						Response.write "<div class=""card-body"">"
						
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
														
														<!-- 														
														'If Split(pagename,".")(0) = Split(linkfilename,".")(0) Then
														'd3str = d3str & "<span class=""glyphicon glyphicon-triangle-right""></span>"
														'End If
														'Response.write "<li><a href="""&leftlink&""" "&bodyTarget&">"&d3str&"</a></li>"
													-->
														If Split(pagename,".")(0) = Split(linkfilename,".")(0) Then
														d3str = d3str & "<span class=""glyphicon glyphicon-triangle-right""></span>"
														Response.write "<a href="""&leftlink&""" "&bodyTarget&" class=""active"">"&d3str&"</a>"
														Else
														Response.write "<a href="""&leftlink&""" "&bodyTarget&">"&d3str&"</a>"
														End If
														
												End If
											Next
										End if

							End if
						Next

						Response.write "</div>"
						Response.write "</div>"
						<!-- Response.write "</ul>" -->
				%>
		</div>
		<!-- </li> -->
		<%
		Next
	End if

	setLeftMenu = d1str&"|"&d3str

End Function

%>





  <nav class="nav" role="navigation">
    <!-- <ul class="nav__list"> -->
    <div id="accordion">
<%
	'Cookies_aID = "20170703"  'test
	If Cookies_aID =  "" Then
		Response.redirect "/pub/login/admLogin.asp"
		Response.end
	End if
	menustr =  setLeftMenu(db, PAGENAME, Cookies_aID, logouturl, reqjson, chkrule, B_ConStr)

	menustr = Split(menustr,"|")
	'Response.write menustr  //패스지정할때 사용
%>

    </div>
    <!-- <ul> -->
  </nav>




