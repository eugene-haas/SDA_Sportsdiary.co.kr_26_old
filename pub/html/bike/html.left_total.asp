<!-- left fulldown menu -->
<%
Sub setLeftMenu(ByRef db, ByVal dbopentype , ByVal pagename, ByVal loginID)

Dim mno, i, SQL, rs, ar, LFD1, LFD2, LFDCNT, ar2, newWindow, bodyTarget, leftlink
Dim arrLF(3)

'열어야할 현재 메뉴 번호
Select Case pagename
Case "contest2.asp"
mno = 1
Case "contestlevel.asp","player.asp"
mno = 0
Case Else
mno = 0
End Select 
'열어야할 현재 메뉴 번호

If mno = "" Then
  mno = 0
End If
%>
<nav class="nav" role="navigation">
    <ul class="nav__list">
	<%
	'3댑스까지만 사용
	For i = 2 To 4
		SQL = "EXEC AdminMember_Menu_S '" & i & "','','','" & loginID & "','','','','',''"
		If dbopentype = "dbopentypeA" then
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		Else
			Set rs = db.Execute(SQL)
		End if
		If Not rs.EOF Then 
			arrLF(i-1) = rs.GetRows() 
		End if
	Next
	'3댑스까지만 사용

	If IsArray(arrLF(1)) Then
		For ar = LBound(arrLF(1), 2) To UBound(arrLF(1), 2) 
		LFD1 = arrLF(1)(1, ar)
		%>
		  <li>
			<input id="group-<%=ar+1%>" type="checkbox" hidden  <%If ar = Cdbl(mno-1) then%>checked<%End if%>/>
			<label for="group-<%=ar+1%>"><span class="fa fa-angle-right"></span> <%=arrLF(1)(2, ar)%></label>
			<ul class="group-list">

				<%
				If IsArray(arrLF(2)) Then

					'두번째 댑스의 갯수 확인
					LFDCNT = 0
					For ar2 = LBound(arrLF(2), 2) To UBound(arrLF(2), 2) 
						If LFD1 = arrLF(2)(1, ar2) Then
							LFD2 = arrLF(2)(3, ar2)
							LFDCNT = LFDCNT + 1
						End if
					next
					'두번째 댑스의 갯수 확인

					If LFDCNT > 1 Then '2댑스가 1개라면
						For ar2 = LBound(arrLF(2), 2) To UBound(arrLF(2), 2) 
							LFD2 = arrLF(2)(3, ar2) 
							If LFD1 = arrLF(2)(1, ar2) then
							%>
							  <li style="border-left: solid 3px yellow;">
								<input id="group-<%=ar2+100%>" type="checkbox" hidden  <%If ar2 = Cdbl(mno-1) then%>checked<%End if%>/>
								<label for="group-<%=ar2+100%>"><span class="fa fa-angle-right"></span> <%=arrLF(2)(4, ar2)%></label>
								<ul class="group-list">
								<%
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
											  If InStr(leftlink, "./") > 0  Then
												leftlink = Replace(leftlink, "./","/Admin/main/AdminMenu/")
											  End If
				
											  Response.write "<li><a href="""&leftlink&""" "&bodyTarget&">"&arrLF(3)(5, ar3)&"</a></li>"
										End If
									Next
								End if
								%>
								</ul>
							  <li>		
							<%
							End if
						Next 
					Else
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
								  If InStr(leftlink, "./") > 0  Then
									leftlink = Replace(leftlink, "./","/Admin/main/AdminMenu/")
								  End If
	
								  Response.write "<li><a href="""&leftlink&""" "&bodyTarget&">"&arrLF(3)(1, ar3)&"</a></li>"
							End If
						Next
						End if
					End if
				End if
				%>

			</ul>
		  <li>		
		<%
		Next 
	End if
	%>
	</ul>
</nav>
<%End Sub%>


<%
	iLoginID = Request.Cookies("UserID")
	iLoginID = decode(iLoginID,0)

	Call setLeftMenu(db, "dbopentypeA",  PAGENAME, iLoginID)
%>
<!-- left fulldown menu -->