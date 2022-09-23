<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX '기존인덱스
	levelno = oJSONoutput.LEVELNO '바뀌는정보
	boostr = Split(oJSONoutput.BOOSTR,"(") '바뀌는정보
	boonm = boostr(0)

	Set db = new clsDBHelper

	'1. 기존 정보
		SQL = "SELECT top 1 P1_PlayerIDX,P2_PlayerIDX,gameTitleIDX,level from tblGameRequest where RequestIDX = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			p1idx = rs(0)
			p2idx = rs(1)
			tidx = rs(2)
			oldlevelno = rs(3)
		End if

	'2. 본선 진출이 있다면 안되게
		SQL = "SELECT top 1 gamememberidx from sd_TennisMember where gameTitleIDX = "&tidx&" and gamekey3 = "&oldlevelno&" and  playerIDX =  " & p1idx & " and round > 0 "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
		If Not rs.eof Then
			Call oJSONoutput.Set("result", 502 ) '본선 결과가 있어서 안됨.
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

	'3. 참가신청 선수 정보 변경
		SQL = " Update  tblGameRequest Set  Level = '"&levelno&"' where RequestIDX = " & idx
		Call db.execSQLRs(SQL , null, ConStr)

	'4. 대진표 변경 (대진표내 모든 정보 찾아서 변경)  예선만 변경되어야한다. 다른 대회 이므로...큰일나....본선 진출 정보가 있다면 변경 되면 안됨 (일부로 한다면?)
		setfield = " gamekey3 = "&levelno&" , teamgb = '"&Left(levelno,5)&"',key3name = '"&boonm&"' , gamekey2 = "&Left(levelno,3)&"  "
		SQL = "update sd_TennisMember Set  "& setfield &" where gameTitleIDX = "&tidx&" and gamekey3 = "&oldlevelno&" and playerIDX =  " & p1idx & " and gubun in (0, 1) "
		Call db.execSQLRs(SQL , null, ConStr)


	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 501 ) '결과완료
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>