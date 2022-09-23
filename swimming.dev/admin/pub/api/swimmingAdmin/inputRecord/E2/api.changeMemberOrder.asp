<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	listlidx = oJSONoutput.Get("LIDX") '실지편성된곳
	lidx = oJSONoutput.Get("CHOICELIDX") '통합본 리스트 호출용
	midx = oJSONoutput.Get("MIDX")
	cngval = oJSONoutput.Get("CNGVAL")
	CDA = "E2"


	If isnumeric(cngval) = False Then
		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
		Call oJSONoutput.Set("servermsg", "숫자로 입력해 주세요." ) '서버에서 메시지 생성 전달
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If


	Set db = new clsDBHelper


	  fld = " tryoutgroupno,tryoutsortNo, 	gametitleidx,gbidx" 
	  SQL = "select "&fld&" from SD_gameMember where gameMemberIDX  = '"&midx&"' "
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	  If Not rs.EOF Then
			gno = rs(0) '조번호(넣을곳)
			orderno = rs(1) '레인번호(넣을곳)
			tidx = rs(2)
			gbidx = rs(3)
			Call oJSONoutput.Set("TIDX", tidx )

			SQL = "select max(tryoutsortNo) from SD_gameMember where delyn = 'N' and gametitleidx = "&tidx&" and gbidx = "&gbidx&" and tryoutgroupno = '"&gno&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			
			If CDbl(cngval) < 1 Then
				Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
				Call oJSONoutput.Set("servermsg", "순서는 1보다 작을수 없습니다." ) '서버에서 메시지 생성 전달
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if
			If CDbl(cngval) > CDbl(rs(0)) then
				Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
				Call oJSONoutput.Set("servermsg", "입력값이 순서를 벗어났습니다." ) '서버에서 메시지 생성 전달
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if

			SQL = " update  SD_gameMember set tryoutsortNo = "&orderno&"  where delyn = 'N' and gametitleidx = "&tidx&" and gbidx = "&gbidx&" and tryoutgroupno = '"&gno&"' and tryoutsortNo = "&cngval&" "
			SQL = SQL & " update  SD_gameMember set tryoutsortNo = "&cngval&"  where gameMemberidx = " & midx 
			Call db.execSQLRs(SQL , null, ConStr)
	  
	  End If


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>