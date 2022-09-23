<%
'   ===============================================================================     
'	  출력 : 리그 대진표출력 
'   =============================================================================== 
	Sub drowLeage(arr, make)
		Dim gbidx,tidx, x, y , x_midx,y_midx,x_teamnm,y_teamnm, SQL ,x_team,y_team,x_sido,y_sido,orderno
		Dim x_hidx,y_hidx,x_hnm,y_hnm

		If IsArray(arr) Then 
		gbidx = arr(5,0)
		tidx = arr(6,0)
		'기존 리그 테이블 대진표 삭제
		SQL = "delete from sd_gameMember_vs where tidx = "&tidx&" and gbidx = '"&gbidx&"' "
		%>
		<div class="box-header" style="text-align:right;padding-right:20px;">
		<div class="box">
		<table class="table">
		<%
			orderno = 1
			For x = LBound(arr, 2) To UBound(arr, 2) + 1
				If x =0 then
					x_midx = arr(0,x)
					x_team = arr(1,x)
					x_teamnm =  arr(2,x) 
					x_sido = arr(7,x)
					x_hidx = arr(8,x) '말
					x_hnm = arr(9,x)
				Else
					x_midx = arr(0,x-1)
					x_team = arr(1,x-1)					
					x_teamnm =  arr(2,x-1) 
					x_sido = arr(7,x-1)
					x_hidx = arr(8,x-1) '말
					x_hnm = arr(9,x-1)
				End if

				Response.write "<tr>"
				For y = LBound(arr, 2) To UBound(arr, 2) + 1
					If y > 0 Then
						y_midx = arr(0,y-1)
						y_team = arr(1,y-1)
						y_teamnm =  arr(2,y-1) 
						y_sido = arr(7,y-1)
						y_hidx = arr(8,y-1) '말
						y_hnm = arr(9,y-1)
					End if

					If x = 0 And y = 0 Then
						%><td class="backslash" style="background:#eeeeee"></td><%			
					elseIf y = 0  then
						%><td><%=x_teamnm%></td><%
					ElseIf x = 0 Then
						%><td><%=y_teamnm%></td><%			
					Else
					If x = y Then
						%><td class="backslash" style="background:#eeeeee"></td><%
					else
						If x > y Then
							%><td style="color:#E9E8E8;" disabled><%=x_teamnm%> vs <%=y_teamnm%></td><%
						else
							'insert game(sd_gameMember_vs)  라운드번호 , 말정보
							SQL = SQL & " insert into  sd_gameMember_vs (tidx,gbidx,midxL,midxR,teamL,teamR,teamnmL,teamnmR,sidonmL,sidonmR,vsType ,orderno,hidxL,hidxR,hnmL,hnmR) values ("&tidx&","&gbidx&","&x_midx&","&y_midx&"    ,'"&x_team&"' ,'"&y_team&"','"&x_teamnm&"','"&y_teamnm&"','"&x_sido&"','"&y_sido&"','L' ,'"&orderno&"'    ,'"&x_hidx&"','"&y_hidx&"','"&x_hnm&"','"&y_hnm&"') "
							%><td><%=x_teamnm%> vs <%=y_teamnm%></td><%
							orderno = orderno + 1
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
		Case "20101","20201"
			odrType = "MM"
		Case "20102","20202"
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
		Case "20103","20203" '복합마술
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

		Case "20108","20208" '릴레이
			odrType = "릴레이"
		Case "20105","20205"
			odrType = "지구력"
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