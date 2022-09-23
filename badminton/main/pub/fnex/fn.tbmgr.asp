<%
	Sub chkLogin(ByVal chkCookiesvalue, ByVal gotourl)
		If chkCookiesvalue = "" then
			'Response.redirect "http://sdmain.sportsdiary.co.kr/sdmain/login.asp"
			'Response.End
		End if
	End sub


'	'===============================================================================
'	' 암호화
'	'===============================================================================
'	Function encode(str, chipVal)
'		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
'
'		chipVal = CInt(chipVal)
'		str = StringToHex(str)
'
'		For i = 0 To Len(str) - 1
'			TempChar = Mid(str, i + 1, 1)
'			Conv = InStr(R_e_f, TempChar) - 1
'			Cipher = Conv Xor chipVal
'			Cipher = Mid(R_e_f, Cipher + 1, 1)
'			Temp = Temp + Cipher
'		Next
'
'		encode = Temp
'
'	End Function
'	'===============================================================================
'	' 복호화
'	'===============================================================================
'	Function decode(str, chipVal)
'		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""
'
'		chipVal = CInt(chipVal)
'
'		For i = 0 To Len(str) - 1
'		  TempChar = Mid(str, i + 1, 1)
'		  Conv = InStr(R_e_f, TempChar) - 1
'		  Cipher = Conv Xor chipVal
'		  Cipher = Mid(R_e_f, Cipher + 1, 1)
'		  Temp = Temp + Cipher
'		Next
'
'		Temp = HexToString(Temp)
'		decode = Temp
'	End Function
'	'===============================================================================
'	' 문자열 -> 16진수
'	'===============================================================================
'	Function StringToHex(pStr)
'		Dim i, one_hex, retVal
'
'		IF pStr<>"" Then
'			For i = 1 To Len(pStr)
'			  one_hex = Hex(Asc(Mid(pStr, i, 1)))
'			  retVal = retVal & one_hex
'			Next
'		End IF
'
'		StringToHex = retVal
'
'	End Function
'	'===============================================================================
'	' 16진수 -> 문자열
'	'===============================================================================
'	Function HexToString(pHex)
'		Dim one_hex, tmp_hex, i, retVal
'
'		For i = 1 To Len(pHex)
'		  one_hex = Mid(pHex, i, 1)
'
'		  If IsNumeric(one_hex) Then
'				  tmp_hex = Mid(pHex, i, 2)
'				  i = i + 1
'		  Else
'				  tmp_hex = Mid(pHex, i, 4)
'				  i = i + 3
'		  End If
'
'		  retVal = retVal & Chr("&H" & tmp_hex)
'
'		Next
'
'		HexToString = retVal
'
'	End Function

	'===============================================================================
	' 나이구하기 ex) birthday = 19950103
	'===============================================================================

	Function GetAge(birthday)
		Dim myage

		myage = Cint(year(date)) - CInt(Left(birthday,4))

		'if CDbl(mid(Replace(date,"-",""),5))  >  CDbl(Mid(birthday, 5)) Then
		'	myage = myage - 1
		'End if

		GetAge = myage

	End Function


'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@































	'공통 함수
	'게임키 레벨키 받아서 검색
	Function listBoo()
		Dim SQL, rs
		SQL = "select MAX(TeamGb) as temgb,teamgbnm from tblRGameLevel where delyn='N' group by teamgbnm"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.EOF Then
			listBoo = 0
		else
			listBoo = rs.GetRows()
		End if
	End function


	'부목록 생성
	Sub booinsert(ByVal pidx)
		Dim ar, insertvalue, teamgb,teamgbNm,SQL,bRS

		SQL = "select MAX(TeamGb) as temgb,teamgbnm from tblRGameLevel where delyn='N' group by teamgbnm"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.EOF Then
			bRS = 0
		else
			bRS = rs.GetRows()
		End if

		If IsArray(bRS) Then
			For ar = LBound(bRS, 2) To UBound(bRS, 2)
				teamgb = bRS(0, ar)
				teamgbNm = bRS(1, ar)
				If CDbl(ar) = 0 Then
					insertvalue = " ("&pidx&",'"&teamgb&"','"&teamgbNm&"') "
				Else
					insertvalue = insertvalue &" ,("&pidx&",'"&teamgb&"','"&teamgbNm&"') "
				End if
			Next
			SQL = "INSERT INTO sd_TennisRPoint (PlayerIDX,teamgb,teamGbNm) VALUES " & insertvalue
			Call db.execSQLRs(SQL , null, ConStr)
		End If

	End Sub





	'대회 등릅
	Function findGrade(ByVal gradeno)
		Dim titleGrade
		Select Case gradeno
		Case "2" : titleGrade = "GA"
		Case "1" : titleGrade = "SA"
		Case "3" : titleGrade = "A"
		Case "4" : titleGrade = "B"
		Case "5" : titleGrade = "C"
		Case "6" : titleGrade = "D" '단체
		Case "7" : titleGrade = "E" '이벤트 -- 랭킹포인트 반영안됨
		Case "8" : titleGrade = "비랭킹" '비랭킹 -- 랭킹포인트 반영안됨
		End Select
		findGrade = titleGrade
	End function


	'대회 그룹
    Function findcode(ByVal c_arrRs ,ByVal c_titleCode,ByVal c_titlegrade)
        dim R_titleCode
        If IsArray(arrRS) Then
            For arr = LBound(c_arrRs, 2) To UBound(c_arrRs, 2)
                if c_arrRs(0, arr)  =c_titleCode and  c_arrRs(1, arr)  = c_titlegrade then
                	R_titleCode = c_arrRs(2, arr)
                end if
            Next
        end if
        findcode = R_titleCode
    end Function


	'빈소팅 번호 찾기
	Function tempno(ByVal arrSt, ByVal i)
		Dim tempsortno,ar,sortno
		tempsortno = False

		If IsArray(arrSt) Then
			For ar = LBound(arrSt, 2) To UBound(arrSt, 2)
				sortno = arrSt(0, ar)
				If CDbl(sortno) = CDbl(i) Then
					tempsortno = true
					Exit for
				End if
			Next
		End If

		If tempsortno = True Then
			tempno = 0
		Else
			tempno = i
		End if
	End function


'쉬트목록가져오기
Function getSheetName(conn)
	Dim i
	Set oADOX = CreateObject("ADOX.Catalog")
	oADOX.ActiveConnection = conn
	ReDim sheetarr(oADOX.Tables.count)
	i = 0
	For Each oTable in oADOX.Tables
		sheetarr(i) = oTable.Name
	i = i + 1
	Next
	getSheetName = sheetarr
End function

Function fc_tryoutGroupSplit(groupcnt, jooDivision)
	joarrcnt = Fix(groupcnt/jooDivision)
	joarrcntMod = (groupcnt Mod jooDivision)

	if joarrcntMod > 0 Then
		joarrcnt = joarrcnt + 1
	End IF

  Dim no,jono,totalarr,cntno,reversetoggle,startno
	'Response.write "최대 행 : "  & jooDivision & "<br>"
	'Response.write "최대 열 : "  & joarrcnt & "<br>"
  ReDim totalarr(jooDivision, joarrcnt)
  ReDim cntno(jooDivision)

	'Response.write "(행, 열) : " & "(" & jooDivision & "," & joarrcnt  & ")"  & "<br>"
  For i = 1 To ubound(cntno)
		cntno(i) = 1
  Next

  reversetoggle = 0
	j = 1

  For i = 1 To groupcnt
		If i > 1 And (i Mod jooDivision) = 1  Then
			j = j + 1
			If reversetoggle  = 0 then
				reversetoggle  = 1
				startno = CDbl( i + jooDivision -1)
			Else
				reversetoggle  = 0
			End if
		End If

		If reversetoggle  = 0 Then
			jono = i
		Else
			'Response.write "j : " & j <> jooDivision  & "<br>"
			jono = startno
			'jono = startno
			startno = startno - 1
		End if

		If (i mod jooDivision) = 0 Then
			no = jooDivision
			'Response.write "no" & no & "<br>"
		Else
			no = i mod jooDivision
			'Response.write "no :" & no & "<br>"
		End if

		'Response.write "no" & no & "<br>"
		'Response.write "no" & i mod jooDivision & "<br>"

		ckarr = cntno(no)
		totalarr(no , ckarr) = jono
		'Response.write "(no,charr): " & "(" & no & "," & ckarr & ")"  & "<br>"
		cntno(no) = CDbl(cntno(no)) + 1
  Next

	fc_tryoutGroupSplit = totalarr
End Function

Function fc_tryoutGroupMerge(groupcnt, jooDivision, jooArea)

	Dim tryoutNum : tryoutNum = 1
	ReDim tryoutResult(groupcnt)
	joarrcnt = Fix(groupcnt/jooDivision)
	joarrcntMod = (groupcnt Mod jooDivision)

	if joarrcntMod > 0 Then
		joarrcnt = joarrcnt + 1
	End IF

	maxgroupCnt = jooDivision * joarrcnt


	'Response.Write "조 : " & groupcnt & "<br>"
	'Response.Write "나눈 조 : " & jooDivision & "<br>"
	'Response.Write "영역  : " & jooArea & "<br>" & "<br>"

	joarr = fc_tryoutGroupSplit(maxgroupCnt,jooDivision)

	'For i = 1 To ubound(joarr)
	'	For  n = 1 To joarrcnt
	'		Response.write joarr(i, n) & ","
	'	Next
	'		Response.write "<br>"
	'next

	'시작 위치
	StartPosition = 1
	RowIndex = ubound(joarr,1)
	ColumnIndex = ubound(joarr,2)
	TotalData =  RowIndex * ColumnIndex
	'Response.Write "<br>"
	'Response.Write "배열 행  : " &  RowIndex & "<br>"
	'Response.Write "배열 열  : " &  ColumnIndex & "<br>" & "<br>"



	For i = 1 To jooDivision
		if(i mod jooArea) = 0 then
			'Response.write "jooArea : " & i  & "<br>"
			EndPosition = i
			reversetoggle = 0
			'Response.write "StartPosition : " & StartPosition  & "<br>"
			'Response.write "EndPosition : " & EndPosition & "<br>"

			For columnI = 1 To ColumnIndex
						If Cdbl(columnI) > 1 Then
						IF(reversetoggle = 0) Then
							reversetoggle = 1
							startNo = EndPosition
						ElseIF(reversetoggle = 1) Then
							reversetoggle = 0
						End IF
					End If

				For j = StartPosition To EndPosition

					'Response.write "j : " &  j & "<br>"
					'Response.write "j의 EndPosition 나머지 구하기 : " & (j Mod EndPosition) & "<br>"
					if(reversetoggle = 1) Then
						'Response.write "startNo : " & startNo & "<br>"
						'Response.write "(j, columnI) : " & "(" & startNo & "," & columnI  & ")"  & "<br>"
						Data = joarr(startno,columnI)
						if( Data <> "" and Data <= groupcnt) Then
							'Response.write Data & "<bR>"
							tryoutResult(tryoutNum) = Data
							'Response.Write tryoutNum & "<br>"
							tryoutNum =tryoutNum  + 1
						ENd IF
						startNo	 = startNo - 1
					Else
						'Response.write "(j, columnI) : " & "(" & j & "," & columnI  & ")"  & "<br>"
						'Response.write joarr(j,columnI) & "<bR>"
						Data = joarr(j,columnI)
						if( Data <> "" and Data <= groupcnt) Then
							'Response.write Data & "<bR>"
							tryoutResult(tryoutNum) = Data
							'Response.Write tryoutNum & "<br>"
							tryoutNum =tryoutNum  + 1
						ENd IF
					End IF
					'Response.write "reversetoggle : " & reversetoggle & "<br>"
				Next
			Next

			StartPosition = EndPosition + 1
		End If
	Next

	'Response.Write "여기?" & ubound(tryoutResult)
	' 나뉘어 떨어지지 않은 나머지
	If (jooDivision mod jooArea) <> 0 Then

			StartPosition = EndPosition + 1
			EndPosition = jooDivision

			reversetoggle = 0
			For columnI = 1 To ColumnIndex


						If Cdbl(columnI) > 1 Then
						IF(reversetoggle = 0) Then
							reversetoggle = 1
							startNo = EndPosition
						ElseIF(reversetoggle = 1) Then
							reversetoggle = 0
						End IF
					End If

				For j = StartPosition To EndPosition

					if(reversetoggle = 1) Then
						'Response.write joarr(startno,columnI) & "<bR>"
						Data = joarr(startno,columnI)
						if( Data <> "" and Data <= groupcnt) Then
							tryoutResult(tryoutNum) = Data
							tryoutNum =tryoutNum  + 1
						END IF
						startNo	 = startNo - 1
					Else

						Data = joarr(j,columnI)

						if( Data <> "" and Data <= groupcnt) Then
							tryoutResult(tryoutNum) = Data
							tryoutNum =tryoutNum  + 1
						END IF
						'Response.write joarr(j,columnI) & "<bR>"
					End IF

				Next
			Next

	End if
	fc_tryoutGroupMerge = tryoutResult
End Function









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
Function setLeftMenu(ByRef db, ByVal dbopentype , ByVal pagename, ByVal loginID, ByVal logoutpage, ByVal req, ByVal chkrule)

	Dim mno,mno2, i,j, SQL, rs, ar, LFD1, LFD2, LFDCNT, ar2, newWindow, bodyTarget, leftlink, admidx1,adminidx2 ,collapsed, panelcollapse,returnpage
	Dim d1str, d2str, d3str, linkfilename
	Dim arrLF(3)

	'3댑스까지만 사용
	For i = 2 To 4


'		SQL = "EXEC AdminMember_Menu_S '" & i & "','','','" & loginID & "','','','','',''"
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		Call rsdrow(rs)

		
		
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
						  If pagename = linkfilename Then
							'열어야할 현재 메뉴 번호
							mno = i
							mno2 = j
							returnpage = leftlink

                          ElseIf pagename = "index2.asp" Then
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
			document.body.innerHTML = "<form method='post' name='sform'><input type='hidden' name='p'></form>";
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
		'If admidx1 = "1" OR "4" Then

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
		  <div class="panel panel-default">
				<div class="panel-heading" role="tab" id="heading-<%=ar+1%>">
				  <h4 class="panel-title">
					<a class="<%=collapsed%>" data-toggle="collapse" data-parent="#accordion" href="#collapse-<%=ar+1%>" aria-expanded="false" aria-controls="collapse-<%=ar+1%>">
					  <%=arrLF(1)(2, ar)%>
					</a>
				  </h4>
				</div>

				<div id="collapse-<%=ar+1%>" class="panel-collapse collapse<%=panelcollapse%>" role="tabpanel" aria-labelledby="heading-<%=ar+1%>">
				  <div class="panel-body">
						<ul>
						<%
						If IsArray(arrLF(2)) Then
							'두번째 댑스의 갯수 확인
							LFDCNT = 0
							For ar2 = LBound(arrLF(2), 2) To UBound(arrLF(2), 2)
								admidx2 = arrLF(2)(0, ar2)
								'If LFD1 = arrLF(2)(1, ar2) And admidx2 = "1" OR "4" Then
								If LFD1 = arrLF(2)(1, ar2) Then
									LFD2 = arrLF(2)(3, ar2)
									LFDCNT = LFDCNT + 1
								End if
							next
							'두번째 댑스의 갯수 확인



							If LFDCNT > 1 Then '2댑스가 1보다 많다면
								For ar2 = LBound(arrLF(2), 2) To UBound(arrLF(2), 2)
									admidx2 = arrLF(2)(0, ar2)
									LFD2 = arrLF(2)(3, ar2)
									'If LFD1 = arrLF(2)(1, ar2) And admidx2 = "1" OR "4" then
									If LFD1 = arrLF(2)(1, ar2) then
									%>
									  <li>
										<p class="depth-2<%If ar = CDbl(mno) And ar2 = CDbl(mno2) then%> on<%End if%>" id="depth-<%=ar2+100%>" onmousedown="if($(this).hasClass('on')){$(this).removeClass('on');$('#depth<%=ar2+100%>').removeClass('active');}else{$(this).addClass('on');$('#depth<%=ar2+100%>').addClass('active');}	"><%=arrLF(2)(4, ar2)%></p>
										<div class="depth-2-con<%If ar = CDbl(mno) And ar2 = CDbl(mno2) then%> active<%End if%>" id="depth<%=ar2+100%>">
										  <ul>
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
															  linkfilename = LCase(Mid(leftlink, InStrRev(leftlink, "/") + 1))
															  If pagename = linkfilename Then
																d3str = arrLF(3)(1, ar3)
															  End If

															  If InStr(leftlink, "./") > 0  Then
																leftlink = Replace(leftlink, "./","/Admin/main/AdminMenu/")
															  End If

															  Response.write "<li><a href="""&leftlink&""" "&bodyTarget&">"&arrLF(3)(1, ar3)&"</a></li>"
														End If
													Next
												End if
												%>
										  </ul>
										</div>
									  </li>
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
										  linkfilename = LCase(Mid(leftlink, InStrRev(leftlink, "/") + 1))
										  If pagename = linkfilename Then
											d3str = arrLF(3)(1, ar3)
										  End if
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
				  </div>
				</div>
		  </div>
		<%
		'End if
		Next
	End if

	setLeftMenu = d1str&"|"&d3str

End Function

'////////////////////////////////////////////////////////////////////
'content 상단 경로
'////////////////////////////////////////////////////////////////////
Sub topnav(ByVal p1 , ByVal p2)
%>
	<div class="navigation">
	  <i class="fas fa-home"></i>
	  <i class="fas fa-chevron-right"></i>
	  <%If p1 <> "" Then%>
	  <span><%=p1%></span>
	  <%End if%>
	  <%If p2 <> "" then%>
	  <i class="fas fa-chevron-right"></i>
	  <span><%=p2%></span>
	  <%End if%>
	</div>
<%
End Sub

%>
