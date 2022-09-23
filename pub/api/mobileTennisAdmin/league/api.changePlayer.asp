<%
'#############################################


'#############################################
	'request

	orgp1idx = oJSONoutput.orgp1idx
	orgp2idx = oJSONoutput.orgp2idx
	p1idx = oJSONoutput.p1idx
	p2idx = oJSONoutput.p2idx
	tidx = oJSONoutput.tidx
	levelno = oJSONoutput.levelno

	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	End If


	'대기자 인자로 받을때
	If hasown(oJSONoutput, "wait") = "ok" then
		waitmember = oJSONoutput.wait
	End If

	Set db = new clsDBHelper

	'신규 두명의 선수가 모두 존재하는지확인 (올드선수존재여부)
	SQL = "SELECT count(PlayerIDX) from tblPlayer where DelYN = 'N'  and (PlayerIDX = '"&p1idx&"' or PlayerIDX = '"&p2idx&"')"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	If isnull(rs(0)) = False Then
		If Cdbl(rs(0)) < 2 Then
			Call oJSONoutput.Set("result", 9091 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End if

	If orgp1idx = p1idx And orgp2idx = p2idx Then '바뀐내용없음
		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if


	'대기자라면########################################
		If waitmember = "waitmember" Then

		'기존 선수 정보 가져오기 ( 변경내용 저장용 , 수정 인덱스 가져오기)
			If ridx = "" Or ridx = "0" then
				subSql = " and (P1_PlayerIDX = '"&orgp1idx&"' )" '중복신청인경우 문제발생할수 있다.
				SQL = "SELECT top 1 RequestIDX from tblGameRequest where DelYN = 'N' and Level =" & levelno & " and GameTitleIDX = "&tidx & subSql
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof then
				reqidx = rs("RequestIDX") '참가신청 인덱스
				Else
					SQL = "SELECT username from tblPlayer where DelYN = 'N'  and (PlayerIDX = '"&orgp1idx&"' )"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					
					subSql = " and (P1_userName = '"&rs(0)&"' )" '중복신청인경우 문제발생할수 있다.
					SQL = "SELECT top 1 RequestIDX from tblGameRequest where DelYN = 'N' and Level =" & levelno & " and GameTitleIDX = "&tidx & subSql
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

					reqidx = rs("RequestIDX") '참가신청 인덱스
				End If
			Else
					reqidx = ridx				
			End if
		
		
		'바뀔 선수 정보 가져오기
			SQL = "SELECT PlayerIDX,UserName,UserPhone,Team,TeamNm,Team2,Team2Nm,Birthday,Sex from tblPlayer where DelYN = 'N'  and (PlayerIDX = '"&p1idx&"' or PlayerIDX = '"&p2idx&"')"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			Do Until rs.eof
				pidx = rs("PlayerIDX")
				If Cstr(pidx) = CStr(p1idx) Then
					p1name = rs("UserName")
					p1team1 = rs("TeamNm")
					p1team2 = rs("Team2Nm")
					p1phone = rs("UserPhone")
					p1_birth = rs("Birthday")
					p1sex = rs("Sex")

					p1tm1code = rs("Team")
					p1tm2code = rs("Team2")
				Else
					p2name = rs("UserName")
					p2team1 = rs("TeamNm")
					p2team2 = rs("Team2Nm")
					p2phone = rs("UserPhone")
					p2_birth = rs("Birthday")
					p2sex = rs("Sex")

					p2tm1code = rs("Team")
					p2tm2code = rs("Team2")		
				End if
			rs.movenext
			loop


			updatevalue = " P1_PlayerIDX = "&p1idx&",P1_UserName='"&p1name&"' ,P1_team='"&p1tm1code&"',p1_team2='"&p1tm2code&"',  P1_TeamNm='"&p1team1&"',P1_TeamNm2='"&p1team2&"',P1_UserPhone='"&p1phone&"',P1_Birthday='"&p1_birth&"',P1_SEX='"&p1sex&"' "
			updatevalue = updatevalue & " ,P2_PlayerIDX = "&p2idx&",P2_UserName='"&p2name&"',P2_team='"&p2tm1code&"',p2_team2='"&p2tm2code&"', P2_TeamNm='"&p2team1&"',P2_TeamNm2='"&p2team2&"',P2_UserPhone='"&p2phone&"',P2_Birthday='"&p2_birth&"',P2_SEX='"&p2sex&"' "
			SQL = " Update  tblGameRequest Set  " & updatevalue & " where RequestIDX = " & reqidx
			Call db.execSQLRs(SQL , null, ConStr)

			Set rs = Nothing
			db.Dispose
			Set db = Nothing

			Call oJSONoutput.Set("result", 0 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	'대기자라면########################################

	
	
	'1. 기존 선수 정보 가져오기 ( 변경내용 저장용 , 수정 인덱스 가져오기)
		If ridx = "" Or ridx = "0" then
			subSql = " and (P1_PlayerIDX = '"&orgp1idx&"' or P2_PlayerIDX = '"&orgp2idx&"')" '중복신청인경우 문제발생할수 있다.
			SQL = "SELECT top 1 RequestIDX from tblGameRequest where DelYN = 'N' and Level =" & levelno & " and GameTitleIDX = "&tidx & subSql
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof then
			reqidx = rs("RequestIDX") '참가신청 인덱스
			Else
				SQL = "SELECT username from tblPlayer where DelYN = 'N'  and (PlayerIDX = '"&orgp1idx&"' )"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				
				subSql = " and (P1_userName = '"&rs(0)&"' )" '중복신청인경우 문제발생할수 있다.
				SQL = "SELECT top 1 RequestIDX from tblGameRequest where DelYN = 'N' and Level =" & levelno & " and GameTitleIDX = "&tidx & subSql
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				reqidx = rs("RequestIDX") '참가신청 인덱스
			End If
		Else
			reqidx = ridx				
		End if
			

	'2. 바뀔 선수 정보 가져오기
		SQL = "SELECT PlayerIDX,UserName,UserPhone,Team,TeamNm,Team2,Team2Nm,Birthday,Sex from tblPlayer where DelYN = 'N'  and (PlayerIDX = '"&p1idx&"' or PlayerIDX = '"&p2idx&"')"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		Do Until rs.eof
			pidx = rs("PlayerIDX")
			If Cstr(pidx) = CStr(p1idx) Then
				p1name = rs("UserName")
				p1team1 = rs("TeamNm")
				p1team2 = rs("Team2Nm")
				p1phone = rs("UserPhone")
				p1_birth = rs("Birthday")
				p1sex = rs("Sex")

				p1tm1code = rs("Team")
				p1tm2code = rs("Team2")
			Else
				p2name = rs("UserName")
				p2team1 = rs("TeamNm")
				p2team2 = rs("Team2Nm")
				p2phone = rs("UserPhone")
				p2_birth = rs("Birthday")
				p2sex = rs("Sex")

				p2tm1code = rs("Team")
				p2tm2code = rs("Team2")		
			End if
		rs.movenext
		loop

	'3. 랭킹포인트 구하기
		SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where PlayerIDX = "&p1idx&" and teamGb = "&Left(levelno,5)&" order by getpoint desc )"
		Set rs1 = db.ExecSQLReturnRS(SQL , null, ConStr)

		If isNull(rs1(0)) = true Then
			p1point = 0
		Else
			p1point = rs1(0)
		End if

		SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where PlayerIDX = "&p2idx&" and teamGb = "&Left(levelno,5)&" order by getpoint desc )"
		Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)
		If isNull(rs2(0)) = true Then
			p2point = 0
		Else
			p2point = rs2(0)
		End if


	'4. 참가신청 선수 정보 변경
		updatevalue = " P1_PlayerIDX = "&p1idx&",P1_UserName='"&p1name&"' ,P1_team='"&p1tm1code&"',p1_team2='"&p1tm2code&"',  P1_TeamNm='"&p1team1&"',P1_TeamNm2='"&p1team2&"',P1_UserPhone='"&p1phone&"',P1_Birthday='"&p1_birth&"',P1_SEX='"&p1sex&"' "
		updatevalue = updatevalue & " ,P2_PlayerIDX = "&p2idx&",P2_UserName='"&p2name&"',P2_team='"&p2tm1code&"',p2_team2='"&p2tm2code&"', P2_TeamNm='"&p2team1&"',P2_TeamNm2='"&p2team2&"',P2_UserPhone='"&p2phone&"',P2_Birthday='"&p2_birth&"',P2_SEX='"&p2sex&"' "
		SQL = " Update  tblGameRequest Set  " & updatevalue & " where RequestIDX = " & reqidx
		Call db.execSQLRs(SQL , null, ConStr)

	'5. 대진표 선수 변경 (대진표내 모든 정보 찾아서 변경) 
		SQL = "SELECT gameMemberIDX from sd_TennisMember where DelYN = 'N' and gamekey3 =" & levelno & " and GameTitleIDX = "& tidx & " and PlayerIDX = " & orgp1idx  '한팀정보변경이니까 앞에꺼만
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		Do Until rs.eof 

			midx = rs("gameMemberIDX")
			setfield = " PlayerIDX = "&p1idx&" , userName = '"&p1name&"', TeamANa = '"&p1team1&"' , TeamBNa = '"&p1team2&"',rankpoint = "&p1point&" "
			SQL = "update sd_TennisMember Set  "& setfield &" where gameMemberIDX = " & midx
			Call db.execSQLRs(SQL , null, ConStr)

			setfield = " PlayerIDX = "&p2idx&" , userName = '"&p2name&"', TeamANa = '"&p2team1&"' , TeamBNa = '"&p2team2&"',rankpoint = "&p2point&" "
			SQL = "update sd_TennisMember_partner Set  "& setfield &" where gameMemberIDX = " & midx			
			Call db.execSQLRs(SQL , null, ConStr)

		rs.movenext
		loop


	Set rs = Nothing
	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>