<%
'#############################################
'참가 신청자 정보 요청
'#############################################
	'request
	pidx = oJSONoutput.pidx
	tidx = oJSONoutput.tidx
	levelno = oJSONoutput.levelno

	Set db = new clsDBHelper

	
	'참가신청 중복 리턴값을 보내주자.
	'result 50 중복사용자
	SQL = "Select top 1 Player"
	strWhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno
	SQL = "Select a.gameMemberIDX From sd_TennisMember As a Left Join sd_TennisMember_partner As b On a.gameMemberIDX = b.gameMemberIDX Where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	If Not rs.eof Then
		Call oJSONoutput.Set("result", "50" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if
	
	
	
	strSql = "SELECT top 1 UserName,PlayerIDX,UserPhone,TeamNm,Team2Nm,userLevel  from tblPlayer where DelYN = 'N' and PlayerIDX = " & pidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)

	i = 0
	Do Until rs.eof
		pidx = rs("PlayerIDX")
		pname = rs("UserName")
		pphone = ""&left(rs("UserPhone"),3)&"-****-" & Right(rs("UserPhone"),4)
		pphone1 = ""&Replace(rs("UserPhone"),"-","")
		pteam1 = rs("TeamNm")
		pteam2 = rs("Team2Nm")
		pgrade = rs("userLevel")
	i = i + 1
	rs.movenext
	Loop

	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("idx", pidx )
	Call oJSONoutput.Set("name", pname )
	Call oJSONoutput.Set("phone", pphone )
	Call oJSONoutput.Set("tm1", pteam1 )
	Call oJSONoutput.Set("tm2", pteam2 )
	Call oJSONoutput.Set("grade", pgrade )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
