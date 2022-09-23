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
	Dim d1str, d2str, d3str, linkfilename,d3selectstr
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

  						  If InStr(linkfilename,".") >  0  Then		
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
						  End if
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


		<li class="active treeview">
		  <a href="#">
            <i class="fa fa-folder"></i> <span><%=arrLF(1)(2, ar)%></span> <i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul <%If ar = Cdbl(mno) then%>class="treeview-menu menu-open" style="display: block;"<%Else%>class="treeview-menu" style="display:none;"<%End if%>>
            
			<%
				For ar2 = LBound(arrLF(2), 2) To UBound(arrLF(2), 2)
					admidx2 = arrLF(2)(0, ar2)
					LFD2 = arrLF(2)(3, ar2)
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
											  d3selectstr = d3str
											  End if
												%><li <%If Split(pagename,".")(0) = Split(linkfilename,".")(0) Then%>class="active"<%End if%>>
												<a href="<%=leftlink%>" <%=bodyTarget%>>
												<%If Split(pagename,".")(0) = Split(linkfilename,".")(0) Then%>
												<i class="fa fa-circle-o text-aqua"></i>
												<%else%>
												<i class="fa fa-circle-o"></i>
												<%End if%>
												<%=d3str%></a></li><%
										End If
									Next
								End if

					End if
				Next			
			%>
          </ul>
        </li>
		<%
		Next
	End if

	setLeftMenu = d1str&"|"&d3selectstr

End Function

%>




		<%
			'Cookies_aID = "20170703"  'test
			If Cookies_aID =  "" Then
				Response.redirect "/pub/login/admLogin.asp"
				Response.end
			End if
			'menustr =  setLeftMenu(db, PAGENAME, Cookies_aID, logouturl, reqjson, chkrule, B_ConStr)

			menustr = Split(menustr,"|")
			'Response.write menustr  //패스지정할때 사용
		%>




<!-- /////////////////////// -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
     

      <!-- /.search form -->
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu">
	


		<li class="active treeview">
		  <a href="#">
            <i class="fa fa-folder"></i> <span>대회관리</span> <i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul class="treeview-menu menu-open" style="display: block;">
		  <!-- <ul class="treeview-menu" style="display:none;"> -->

			<li <%If pagename="01.sample.asp" Or InStr(pagename,"05.sample") > 0 then%>class="active"<%End if%>>
			<a href="/01.sample.asp" >
			<i class="fa fa-circle-o<%If pagename="01.sample.asp" Or InStr(pagename,"05.sample") > 0 then%> text-aqua<%End if%>"></i>
			대회정보관리</a></li>

					<li <%If pagename="02.sample.asp" then%>class="active"<%End if%>>
					<a href="/02.sample.asp" >
					<i class="fa fa-circle-o<%If pagename="02.sample.asp" then%> text-aqua<%End if%>"></i>
					선수관리</a></li>

					<li <%If pagename="03.sample.asp" then%>class="active"<%End if%>>
					<a href="/03.sample.asp" >
					<i class="fa fa-circle-o<%If pagename="03.sample.asp" then%> text-aqua<%End if%>"></i>
					소속관리</a></li>
          </ul>
        </li>
		


		<li class="active treeview">
		  <a href="#">
            <i class="fa fa-folder"></i> <span>참가신청</span> <i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul class="treeview-menu" style="display:none;">
            
			<li <%If pagename="04.sample.asp" then%>class="active"<%End if%>>
				<a href="/04.sample.asp" >
				<i class="fa fa-circle-o<%If pagename="04.sample.asp" then%> text-aqua<%End if%>"></i>
				참가신청현황</a></li>
          </ul>
        </li>

		<li class="active treeview">
		  <a href="#">
            <i class="fa fa-folder"></i> <span>대회운영</span> <i class="fa fa-angle-left pull-right"></i>
          </a>
          <ul class="treeview-menu" style="display:none;">
            
			<li <%If pagename="06.sample.asp" then%>class="active"<%End if%>>
												<a href="06.sample.asp" >
												
												<i class="fa fa-circle-o<%If pagename="06.sample.asp" then%> text-aqua<%End if%>"></i>
												경기운영관리</a></li>
          </ul>
        </li>
		

	  </ul>
    </section>
    <!-- /.sidebar -->
  </aside>




