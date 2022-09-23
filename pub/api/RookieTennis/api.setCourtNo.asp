<%
	'request
	resultidx = oJSONoutput.SCIDX 'resultIDX , courtno
	gidx = oJSONoutput.GIDX
	key3 = oJSONoutput.KEY3
	courtno = oJSONoutput.COURTNO '새로 선택된 코트
	courttxt = right(oJSONoutput.COURTTXT,2)
	confirmchk = oJSONoutput.CHK '1 확인


	Set db = new clsDBHelper
	rttable = " sd_TennisResult "
	bootable = " tblRGameLevel "


	'코트갯수
	SQL = "Select courtcnt from " & bootable & " where GameTitleIDX = " & gidx & " and Level = '"& key3 &"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	courtcnt = rs("courtcnt") '코트수

	'코트 업데이트 (사용중 입니다 진짜 사용할껀가용 ??)
	'타입 석어서 보내기
	If courttxt = "사용" then
		If confirmchk = "0"  then
			Call oJSONoutput.Set("result", "50" ) '결과로 처리하고 선택창 보여준 후 packet에 확인 패킷을 넣어서 다시 호출
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.end	
		Else
			
			'코트 내용이 변경되어서 작동 막음
			SQL = "Update " & rttable & " Set  courtno = "&courtno&" where resultIDX = " & resultidx
			'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

		End if
	else
		
		'코트 내용이 변경되어서 작동 막음
		SQL = "Update " & rttable & " Set  courtno = "&courtno&" where resultIDX = " & resultidx
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	End if

	'사용 중 (지정된 코트) 종료된경기 제외
	SQL = "Select courtno from " & rttable & " where GameTitleIDX = " & gidx & " and Level = '"& key3 &"' and preresult = 'ING' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End if



	'###########################

	%><select id="T-courtno" onchange="score.setCourtNo()"><%
	For i = 1 To courtcnt
		selectstr = ""
		usestr = ""
		usecolor = ""
		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			usecourt = arrRS(0, ar) 
			If i = CDbl(usecourt) then
				usestr = "사용"			'사용중
				usecolor = " style='color:orange'"
			End If
			If i = CDbl(courtno) Then
				selectstr = "selected"	'선택된
				usestr = "선택"			'선택중
				usecolor = " style='color:green'"
			End if
		Next
		End If
		%><option value="<%=i%>" <%=selectstr%> <%=usecolor%>><%=i%>번 코트 <%=usestr%></option><%

	Next
    %></select>	<%

db.Dispose
Set db = Nothing
%>