<%
'#############################################
' 입력
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.idx
	End if

	Set db = new clsDBHelper

		SQL = "Select title,targettable,targetfield,fieldvalue from tblInsertData where idx = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


		p_1 = rs(0) & "- 저장완료"

		p_2 = rs(1)
		p_3 = rs(2)
		p_4 = rs(3)
		writeday = Date()

		If InStr(p_4, vbCrLf) > 0 Then
			dataarr = Split(p_4, vbCrLf)
		ElseIf  InStr(p_4, vbCr) > 0 Then
			dataarr = Split(p_4, vbCr)
		ElseIf  InStr(p_4, vbLf) > 0 Then
			dataarr = Split(p_4, vblf)
		End if


		'공백제거, - 제거 , . 제거 

'Response.write p_4
'Response.end


		'2. 팀명칭이 등록되어있는지 확인하고 없다면 생성
		SQL = "Select Team,teamnm from tblTeamInfo where  delyn='N' " '많아지면 방법을 가꾸어야함...현재 182개
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			arrRs = rs.GetRows()
		End If
		SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))) as teamLast from  tblTeamInfo where delyn='N'  ORDER BY Team desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		g_teamno = rs(0)	


		Function findteamgb(arrRS,tnm)
			If IsArray(arrRs) Then
			Dim tgb, tgbnm,SQL
			For ar = LBound(arrRs, 2) To UBound(arrRs, 2)
				tgb = arrRs(0,ar) 
				tgbnm = arrRs(1,ar)
				
				If tnm = tgbnm Then
					Exit for
				End if
			Next
			End If

			If tgb = "" Then
				g_teamno = CDbl(g_teamno) + 1
				SQL = "INSERT INTO tblTeamInfo ( Team,TeamNm,EnterType ) VALUES ( 'ATE000" & g_teamno & "','"& tnm &"','A' ) " & tgb
				Call db.execSQLRs(SQL , null, ConStr)
				findteamgb = "ATE000" & g_teamno
			Else
				findteamgb = tgb
			End if
		End Function 

'Response.end

		If InStr(dataarr(0) , "teamgb") > 0 Then
			'팀명칭이 있는 위치 번호 찾기
			chkteamnmNO = Split(dataarr(0),"^")
			For x = 0 To ubound(chkteamnmNO)
				If chkteamnmNO(x) = "teamgb" Then
					chkno = x + 1 
					Exit for
				End if
			next
		End If

'Response.write chkno
'Response.end
		'######################################################

		SQL = "insert into " & p_2 & " ("& Replace(p_3,"^",",") &") values " 

		For i = 0 To ubound(dataarr)
			
			'팀코드 변경@@@@@@@@@@@@@@@@@@@@@@
			If InStr(dataarr(i) , "teamgb") > 0 Then
				liners = Split(dataarr(i),"^")
				gbcode = findteamgb(arrRS, liners(chkno))
				'Response.write gbcode & "<br>"
				dataarr(i) = Replace(dataarr(i), "teamgb",gbcode)
			End If
			'팀코드 변경@@@@@@@@@@@@@@@@@@@@@@

			invalue = Replace(Replace(Trim(dataarr(i)),"?",""),"^","','")
			If i = 0 then
				invalues = "( '" & invalue & "') "
			else
				invalues =  invalues & ",( '" & invalue & "') "
			End if
			
			'invalue = addQuotationInWord(invalue)
			'Response.write invalue & "<br>"
		Next

		SQL = SQL & invalues
		Call db.execSQLRs(SQL , null, ConStr)
		'Response.write sql
		'Response.end


		'종료플레그 설정
		SQL = "update  tblInsertData set endflag = 'Y' where idx = " & idx
		Call db.execSQLRs(SQL , null, B_ConStr)
		p_6 = "Y"


  Set rs = Nothing
  db.Dispose
  Set db = Nothing

%>
<!-- #include virtual = "/pub/html/riding/common/html.dataInsertList.asp" --> 