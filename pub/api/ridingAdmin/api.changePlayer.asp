<%
'#############################################
'선수변경창
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx= oJSONoutput.MIDX
	End If

	
	If hasown(oJSONoutput, "PIDX") = "ok" Then 
		pidx= oJSONoutput.PIDX '바꿀맴버 번호
	End If
	
	SQL = "select requestidx,teamgb,gametitleidx,playeridx from sd_tennismember where gamememberidx = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof then
	reqidx = rs(0)
	teamgb = rs(1) '복합마술 20103 (복합마술은 단체전이 없다 하나만 체크하면 된다)
	tidx = rs(2)
	reqpidx = rs(3) '바꾸기전 선수
	Else
		Call oJSONoutput.Set("result", "1" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	
	End if

	SQL = "Select top 1 playeridx,nowyear,usertype,username,userphone,birthday,hpassport,ksportsno,team,teamnm,sex from tblPlayer where playeridx = " & pidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arr = rs.GetRows()
		pidx = arr(0,0)
		nyear = arr(1,0)
		utype = arr(2,0)
		unm = arr(3,0)
		uphone = arr(4,0)
		ubirth = arr(5,0)
		hpassport = arr(6,0)
		kno = arr(7,0)
		team = arr(8,0)
		teamnm = arr(9,0)
		sex = arr(10,0)
	End If
	rs.close



	'update 
	'tblGameRequest
	SQL = "Update tblGameRequest Set P1_PlayerIDX = '"&pidx&"',P1_UserName = '"&unm&"',P1_Team = '"&team&"',P1_TeamNm = '"&teamnm&"',P1_UserPhone = '"&uphone&"',P1_Birthday = '"&ubirth&"',P1_SEX = '"&sex&"' where requestIDX = " & reqidx
	Call db.execSQLRs(SQL , null, ConStr)



	'sd_tennismember
	SQL = "Update sd_TennisMember Set playeridx = '"&pidx&"',username = '"&unm&"',teamANa = '"&teamnm&"'    where gamememberidx = " & midx
	Call db.execSQLRs(SQL , null, ConStr)



	'종목확인하고 복합마술이라면 찾아서 하나더 바꾸자....
	If teamgb = "20103" Then

		SQL = "select top 1 gamememberidx,requestidx from sd_tennismember where gametitleidx = "& tidx &" and teamgb = '20103'  and  playeridx = "&reqpidx&" and requestidx <> " & reqidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		midx2 = rs(0)
		reqidx2 = rs(1)

		SQL = "Update tblGameRequest Set P1_PlayerIDX = '"&pidx&"',P1_UserName = '"&unm&"',P1_Team = '"&team&"',P1_TeamNm = '"&teamnm&"',P1_UserPhone = '"&uphone&"',P1_Birthday = '"&ubirth&"',P1_SEX = '"&sex&"' where requestIDX = " & reqidx2
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Update sd_TennisMember Set playeridx = '"&pidx&"',username = '"&unm&"',teamANa = '"&teamnm&"'    where gamememberidx = " & midx2
		Call db.execSQLRs(SQL , null, ConStr)

	End if


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing

%>
