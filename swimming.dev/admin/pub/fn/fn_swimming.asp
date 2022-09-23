<%






'   ===============================================================================
'      수구 리그 화면 출력 함수  (참여팀, 생성여부(ok))
'	  출력 : 리그 대진표출력
'   ===============================================================================
	Sub drowLeageRT(arr, arrs, drtype)
		Dim gbidx,tidx,lno, x, y , x_midx,y_midx,x_teamnm,y_teamnm, SQL ,x_team,y_team,x_sido,y_sido
		Dim r_idx, t,L_team,R_team,L_score,R_score, winmidx,endstr,x_orderno,left_midx

		If IsArray(arr) Then
		gbidx = arr(6,0)
		tidx = arr(7,0)
		lno = arr(8,0)

		'기존 리그 테이블 대진표 삭제
		'SQL = "delete from sd_gameMember_vs where tidx = "&tidx&" and levelno = '"&lno&"' "
		%>
		<div class="box-header" style="text-align:right;padding-right:20px;">

		<div class="box">
		<table class="table">
		<%
			For x = LBound(arr, 2) To UBound(arr, 2) + 1 '세로 Y
				If x =0 then
					x_midx = arr(0,x)
					x_team = arr(1,x)
					x_teamnm =  arr(2,x)
					x_sido = arr(10,x)

					x_orderno = arr(11, x) '순위
				Else
					x_midx = arr(0,x-1)
					x_team = arr(1,x-1)
					x_teamnm =  arr(2,x-1)
					x_sido = arr(10,x-1)
					x_orderno = arr(11, x-1) '순위
				End if

				Response.write "<tr>"
				For y = LBound(arr, 2) To UBound(arr, 2) + 2 '가로 X
					If y > 0 And y < UBound(arr, 2) + 2  Then
						y_midx = arr(0,y-1)
						y_team = arr(1,y-1)
						y_teamnm =  arr(2,y-1)
						y_sido = arr(10,y-1)
					ElseIf y = UBound(arr, 2) + 2 Then '순위
						y_midx = ""
						y_team = ""
						y_teamnm =  "순위"
						y_sido = ""
					End if

					If x = 0 And y = 0 Then
						%><td class="backslash"></td><%
					elseIf y = 0  then
						%><td><%=x_teamnm%></td><%
					ElseIf x = 0 Then '순위
						%><td><%=y_teamnm%></td><%
					Else
					If x = y Then
						%><td class="backslash"></td><%
					else
						If x > y Then
							%><td style="color:#E9E8E8;" disabled><%=x_teamnm%> vs <%=y_teamnm%></td><%
						else
							If y = UBound(arr, 2) + 2 Then '##
								left_midx = arr(0, x-1)
							%><td><input type="text" class="form-control" id="<%=y&x%>" value="<%=x_orderno%>" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" onblur="mx.setLegOrder(this, '<%=left_midx%>')" maxlength="1"><%'=left_teamcode%><!-- 순위 --></td><%
							else

								If IsArray(arrs) Then
								r_idx = ""
								endstr = ""
								For t = LBound(arrs, 2) To UBound(arrs, 2)
									idx = arrs(0,t)
									L_team = arrs(3, t)
									R_team = arrs(4, t)
									L_score = arrs(5, t)
									R_score = arrs(6, t)
									winmidx = arrs(7, t)
									If L_team = x_team And R_team= y_team Then
										r_idx = idx
										If isnull(winmidx ) = False Then
											endstr = L_score & " : " & R_score
										End if
									End if
								Next
								End if

							%>
							<td>
							<%=x_teamnm%> vs <%=y_teamnm%><br>
							<button type="button" class="btn btn-block btn-default" onclick="mx.soogooWindow(<%=r_idx%>)"><%If endstr = "" then%>결과입력<%else%><%=endstr%><%End if%></button>
							</td><%
							End if
						End if
					End if
					End if
				next
				Response.write "</tr>"
			Next

		%>
		</table>
		</div>
		</div>
		<%
		End if

	End sub



'   ===============================================================================
'      수구 리그 화면 출력 함수  (참여팀, 생성여부(ok))
'	  출력 : 리그 대진표출력
'   ===============================================================================
	Sub drowLeage(arr, make)
		Dim gbidx,tidx,lno, x, y , x_midx,y_midx,x_teamnm,y_teamnm, SQL ,x_team,y_team,x_sido,y_sido

		If IsArray(arr) Then
		gbidx = arr(6,0)
		tidx = arr(7,0)
		lno = arr(8,0)

		'기존 리그 테이블 대진표 삭제
		SQL = "delete from sd_gameMember_vs where tidx = "&tidx&" and levelno = '"&lno&"' "
		%>
		<div class="box-header" style="text-align:right;padding-right:20px;">
		<div class="box">
		<table class="table">
		<%
			For x = LBound(arr, 2) To UBound(arr, 2) + 1
				If x =0 then
					x_midx = arr(0,x)
					x_team = arr(1,x)
					x_teamnm =  arr(2,x)
					x_sido = arr(10,x)
				Else
					x_midx = arr(0,x-1)
					x_team = arr(1,x-1)
					x_teamnm =  arr(2,x-1)
					x_sido = arr(10,x-1)
				End if

				Response.write "<tr>"
				For y = LBound(arr, 2) To UBound(arr, 2) + 1
					If y > 0 Then
						y_midx = arr(0,y-1)
						y_team = arr(1,y-1)
						y_teamnm =  arr(2,y-1)
						y_sido = arr(10,y-1)
					End if

					If x = 0 And y = 0 Then
						%><td class="backslash"></td><%
					elseIf y = 0  then
						%><td><%=x_teamnm%></td><%
					ElseIf x = 0 Then
						%><td><%=y_teamnm%></td><%
					Else
					If x = y Then
						%><td class="backslash"></td><%
					else
						If x > y Then
							%><td style="color:#E9E8E8;" disabled><%=x_teamnm%> vs <%=y_teamnm%></td><%
						else
							'insert game(sd_gameMember_vs)
							SQL = SQL & " insert into  sd_gameMember_vs (tidx,gbidx,levelno,midxL,midxR,teamL,teamR,teamnmL,teamnmR,sidonmL,sidonmR,vsType ) values ("&tidx&","&gbidx&",'"&lno&"',"&x_midx&","&y_midx&"    ,'"&x_team&"' ,'"&y_team&"','"&x_teamnm&"','"&y_teamnm&"','"&x_sido&"','"&y_sido&"','L'  ) "
							%><td><%=x_teamnm%> vs <%=y_teamnm%></td><%
						End if
					End if
					End if
				next
				Response.write "</tr>"
			Next

			If make = "ok" then
				Call db.execSQLRs(SQL , null, ConStr)
			End if

		%>
		</table>
		</div>
		</div>
		<%
		End if

	End sub


	'R01	대회유년
	'R02	대회초등
	'R03	대회중등
	'R04	대회고등
	'R05	대회대학
	'R06	대회일반
	'R07	한국기록
	'R08	일반-참가기록
	Function setRCStr(rccode)
		Select Case rccode
		Case "R01" : setRCstr = "대회유년"
		Case "R02" : setRCstr = "대회초등"
		Case "R03" : setRCstr = "대회중등"
		Case "R04" : setRCstr = "대회고등"
		Case "R05" : setRCstr = "대회대학"
		Case "R06" : setRCstr = "대회일반"
		Case "R07" : setRCstr = "한국신"
		Case "R08" : setRCstr = "참가기록"
		End Select
	End Function



	Function shortNm(scstr)
		Dim nm
		nm = Replace(scstr,"초등학교","초")
		nm = Replace(nm,"중학교","중")
		nm = Replace(nm,"고등학교","고")
		nm = Replace(nm,"대학교","대")
		nm = Replace(nm,"남자","남")
		nm = Replace(nm,"여자","여")
		nm = Replace(nm,"혼성","혼")
		'nm = Replace(nm,"수영연맹","수맹")
	shortNm = nm
	End Function

	Function shortBoo(scstr)
		Dim nm
		nm = Replace(scstr,"유년부","유")
		nm = Replace(nm,"대학부","대")
		nm = Replace(nm,"고등부","고")
		nm = Replace(nm,"중학부","중")
		nm = Replace(nm,"초등부","초")
		nm = Replace(nm,"남자","남")
		nm = Replace(nm,"여자","여")
		nm = Replace(nm,"혼성","혼")
	shortBoo = nm
	End Function


	Sub SetRC(rcdata)
		If isnull(rcdata) = True Or rcdata = "" Then
		Response.write ""
		ELSE
			If isnumeric(rcdata) = True Then
				If CDbl(rcdata) = 0 Then
				Response.write "-"
				Else
				Response.write Left(rcdata,2) & ":" & Mid(rcdata,3,2) & "." & Right(rcdata,2)
				End if
			else
			Select Case rcdata
			Case "D221" : Response.write "(점수안줌)기권"
			Case "D222" : Response.write "(점수안줌)몰수"
			Case "D223" : Response.write "(점수안줌)불출장"
			Case "D224" : Response.write "(점수안줌)실격"
			Case "D225" : Response.write "(점수안줌)실격(출발)"
			Case "D226" : Response.write "(점수안줌)불참"
			Case "D290" : Response.write "박탈"
			Case "E221" : Response.write "(점수안줌)기권"
			Case "E222" : Response.write "(점수안줌)몰수"
			Case "E223" : Response.write "(점수안줌)불출장"
			Case "E224" : Response.write "(점수안줌)실격"
			Case "E225" : Response.write "(점수안줌)실격(출발)"
			Case "E226" : Response.write "(점수안줌)불참"
			Case "E290" : Response.write "(점수안줌)박탈"
			Case "E227" : Response.write "(점수안줌)박탈"
			Case "D291" : Response.write "번외"
			Case "F221" : Response.write "(점수안줌)기권"
			Case "F222" : Response.write "(점수안줌)몰수"
			Case "F223" : Response.write "(점수안줌)불출장"
			Case "F224" : Response.write "(점수안줌)실격"
			Case "F225" : Response.write "(점수안줌)실격(출발)"
			Case "F226" : Response.write "(점수안줌)불참"
			Case "F290" : Response.write "박탈"
			Case "F227" : Response.write "(점수안줌)박탈"
			Case "F291" : Response.write "번외"
			Case "D299" : Response.write "사유없이대회불참"
			Case "E299" : Response.write "사유없이대회불참"
			Case Else : Response.write Left(rcdata,2) & ":" & Mid(rcdata,3,2) & "." & Right(rcdata,2)
			End Select
			End if
		End if
	End sub


'   ===============================================================================
'      Excel File Find SheetName
'   ===============================================================================
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
	End Function

'   ===============================================================================
'      Load Excel File
'   ===============================================================================
	Function LoadExcelFile(strPath)
        Dim aryData, SQL ,sheetname,xlsConnString ,rs

        Set excelConnection = Server.createobject("ADODB.Connection")
		xlsConnString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & ";Extended Properties=""Excel 12.0 Xml;HDR=YES;IMEX=1"";"
		sheetname = getSheetName(xlsConnString)
		excelConnection.Open xlsConnString

		SQL = "SELECT  * FROM ["&sheetname(0)&"] "
		Set rs = Server.CreateObject("ADODB.Recordset")
        rs.Open SQL, excelConnection

		'Call rsdrow(rs)
		'Response.end

        If Not (rs.Eof Or rs.Bof) Then
            aryData = rs.GetRows()
        End If

		LoadExcelFile = aryData

        rs.Close
        excelConnection.Close

        Set rs = Nothing
        Set excelConnection = Nothing
    End Function



	'관리자별로 다음/열림 상태 저장
	Function getPageState(pagecode,title, memberidx, ByRef db)
		Dim SQL, rs
		SQL = "select openYN from tblFormState where filecode = '"&pagecode&"' and midx = '"&memberidx&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then
			SQL = "insert into tblFormState (filecode,title,midx,openYN) values ('"&pagecode&"','"&title&"',"&memberidx&",'N') "
			Call db.execSQLRs(SQL , null, ConStr)
			getPageState = "N"
		Else
			getPageState = rs(0)
		End if
	End function


	'소수점 이하버림
	Function Ceil(ByVal intParam, ByVal jumno)
		Dim sousooarr
		If InStr(intParam, ".") > 0 then
		sousooarr = Split(intParam,".")
		Ceil = sousooarr(0) & "." & Left(sousooarr(1),jumno)
		Else
		Ceil = intParam & ".0"
		End if
	End Function


	'사유소팅번호 구하기
	 Function getSayooSortno(sayou)
		Select Case UCase(sayou)
		Case "E" : getSayooSortno = "200"
		Case "R" : getSayooSortno = "300"
		Case "W" : getSayooSortno = "400"
		Case "D" : getSayooSortno = "500"
		End Select
	 End function


	'마장마술 class별 시간간격
	Function getGameTime(classstr) '19년 7월 4일 룰변경 (추후 관리 페이지 필요할지도)
		Select Case Left(LCase(classstr),1)
		Case "s" :	getGameTime = 8 '8분
		Case "a" :	getGameTime = 8 '7분
		Case "b" :	getGameTime = 7 '6분
		Case "c" :	getGameTime = 7 '6분
		Case "d" :	getGameTime = 7 '7분
		Case "f" :	getGameTime = 6 '6분
		Case Else :	getGameTime = 7 '6분 (오류안나게)  - 현재 young horse 로 등록된 클레스 사용
		End Select
	End Function

	' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
    Function GetOrderType(ByVal classHelp, ByVal teamgb, ByVal classstr )
        Dim odrType
		'팀코드  릴레이 20208 복합마술 20103
		Select Case CStr(teamgb)
		Case "20101"
			odrType = "MM"
		Case "20102"
			Select Case  CStr(classHelp)
				Case CONST_TYPEA1, CONST_TYPEA2
						odrType = "A"
				Case CONST_TYPEA_1
						odrType = "A_1"
				Case CONST_TYPEB
						odrType = "B"
				Case CONST_TYPEC
						odrType = "C"
				Case Else
					odrType = classHelp
			End Select
		Case "20103" '복합마술
			If InStr(classstr,"마장마술") > 0 Then
				odrType = "MM"
			Else
				Select Case  CStr(classHelp)
					Case CONST_TYPEA1, CONST_TYPEA2
							odrType = "A"
					Case CONST_TYPEA_1
							odrType = "A_1"
					Case CONST_TYPEB
							odrType = "B"
					Case CONST_TYPEC
							odrType = "C"
					Case Else
						odrType = classHelp
				End Select
			End if

		Case "20108" '릴레이

		End Select

        GetOrderType = odrType
    End Function



	'푸시발송
	Sub sendPush( ByVal title, ByVal contents, ByVal useridarr )
		Dim appkey, appsecret, SQL , invalue,i
		appkey = "ZDMQQISOP4X1VON2KCI2H45ODC2JQFPU"
		appsecret = "6KAsLgV1SVCfaaltZuI5X7aJJXVhUkJg"

		If IsArray(useridarr) Then
		For i = 0 To ubound(useridarr)
			If useridarr(i) <> "" then
			SQL = " INSERT INTO FingerPush.dbo.TBL_FINGERPUSH_QUEUE(appkey,appsecret,msgtitle,msgcontents,identify,mode,senddate,wdate,udate)  "
			SQL =SQL & " values ('" & appkey & "','" & appsecret & "','" & title & "','"&contents&"','" & useridarr(i) & "', 'STOS',getdate(),getdate(),getdate()) "
			Call db.execSQLRs(SQL , null, ConStr)
			End if
		Next
		End if
	End Sub








%>
