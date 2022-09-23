<%
	'request
	uname = Replace(oJSONoutput.SVAL,Chr(34), "")
	titleIDX = oJSONoutput.TIDX
	lvlIDX =  oJSONoutput.LIDX
	Set db = new clsDBHelper
	'참가 신청하지 않은 유저 중에 검색작업할것

	IF LEN(uname) = 1 Then
		top = "top 22"
	ELSEIF LEN(uname) = 2 Then
		top = "top 22"
	END IF

'	If Len(uname) = 3 then
'		'참가신청자
'		strSql = "SELECT top 1 UserName,PlayerIDX,UserPhone,Birthday,Sex,TeamNm,Team2Nm  from tblPlayer where DelYN = 'N' and UserName like '" & uname & "%' " 
'		strSql =  strSql &" and PlayerIDX in (Select P1_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " And P1_PlayerIDX is not null " 
'		strSql = strSql &" UNION Select P2_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " and P2_PlayerIDX is not null) "
'		Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
'
'		If Not rs.eof Then
'		ReDim JSONarr(0)
'		Set rsarr = jsObject() 
'		
'			rsarr("data") ="" 
'			rsarr("uidx") = 0
'			rsarr("teamTitle") = "이미 참가 신청 중 입니다."
'			Set JSONarr(0) = rsarr
'			jsonstr = toJSON(JSONarr)
'			Response.Write CStr(jsonstr)
'			Response.end
'		End If
'	End if


	
'	strSql = "SELECT " & top & " UserName,PlayerIDX,UserPhone,Birthday,Sex,TeamNm,Team2Nm  from tblPlayer where DelYN = 'N' and UserName like '" & uname & "%' " 
'	strSql =  strSql &" and PlayerIDX not in (Select P1_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " And P1_PlayerIDX is not null " 
'	strSql = strSql &" UNION Select P2_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " and P2_PlayerIDX is not null) "

	strSql = "SELECT " & top & " UserName,PlayerIDX,UserPhone,Birthday,Sex,TeamNm,Team2Nm  from tblPlayer where DelYN = 'N' and UserName like '" & uname & "%' " 
	strSql = strSql & " order by len(username) asc"
'	strSql =  strSql &" and PlayerIDX not in (Select P1_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " And P1_PlayerIDX is not null " 
'	strSql = strSql &" UNION Select P2_PlayerIDX from tblGameRequest Where DelYN = 'N' and GameTitleIDX = " & titleIDX & " And Level = " & lvlIDX & " and P2_PlayerIDX is not null) "

	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	rscnt =  rs.RecordCount
	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
	Set rsarr = jsObject() 
		rsarr("data") = rs("UserName")
		rsarr("uidx") = rs("PlayerIDX")

		team1 = rs("TeamNm")
		team2 = rs("Team2Nm")

		IF Len(team1) > 0 Then
				teamTitle = "(" & team1
		END IF

		IF LEN(team2) > 0 Then
				IF Len(team1) = 0 Then
						teamTitle = "(" & team2
				Else
						teamTitle = teamTitle & "," & team2
				END IF
		END IF

		IF LEN(teamTitle) > 0 Then
				teamTitle = teamTitle & ")"
		END IF

		rsarr("teamTitle") = teamTitle
			
		'랭킹포인트를 가져온다.
'		SQL = "select top 1 rankpoint  from sd_TennisRPoint where PlayerIDX = "&rs("PlayerIDX")&" and teamGb = "&Left(lvlIDX,5)
'		Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
'		If rsr.eof Then
'			rsarr("urpoint") = 0
'		Else
'			rsarr("urpoint") = rsr("rankpoint")
'		End if

'		rsarr("utel") = rs("UserPhone")
'		rsarr("ubirth") = rs("Birthday")
'		rsarr("usex") = rs("Sex")
'		rsarr("uteam1") = rs("TeamNm")
'		rsarr("uteam2") = rs("Team2Nm")

		Set JSONarr(i) = rsarr

	i = i + 1
	rs.movenext
	Loop

	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)


	'Call oJSONoutput.Set("result", strSql )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write CStr(strjson)

	db.Dispose
	Set db = Nothing
%>