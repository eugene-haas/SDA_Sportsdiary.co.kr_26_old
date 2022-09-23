<%
'#############################################
'선수변경창
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx= oJSONoutput.MIDX
	End If

	If hasown(oJSONoutput, "NM") = "ok" Then 
		nm= oJSONoutput.NM
	End If
	If hasown(oJSONoutput, "KNO") = "ok" Then 
		kno= oJSONoutput.KNO
	End If


	SQL = "select requestidx,teamgb,gametitleidx,playeridx from sd_tennismember where gamememberidx = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof then
		reqidx = rs(0)
		teamgb = rs(1) '복합마술 20103 (복합마술은 단체전이 없다 하나만 체크하면 된다)
		tidx = rs(2)
		reqpidx = rs(3) '바꾸기전 선수 인덱스
	Else
		Call oJSONoutput.Set("result", "1" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if


	SQL = "Select top 1 playeridx,nowyear,usertype,username,userphone,birthday,hpassport,ksportsno,team,teamnm,sex from tblPlayer where username = '"&nm&"' and hpassport =  '"&kno&"'  and usertype='H'  and delyn='N'"
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
	Else
		SQL = "SET NOCOUNT ON  Insert into tblPlayer (username,nowyear,hpassport,usertype) values ('"&nm&"','"&year(date)&"','"&kno&"','H')   SELECT @@IDENTITY"	
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		pidx = rs(0)

		nyear = year(date)
		utype = "P"
		unm = nm
		uphone = ""
		ubirth = birth
		hpassport = ""
		kno = kno
		team = ""
		teamnm = ""
		sex = ""
		
	End If
	rs.close
	

	'update 
	'tblGameRequest
	SQL = "Update tblGameRequest Set P2_PlayerIDX = '"&pidx&"',P2_UserName = '"&unm&"',P2_SEX = '' where requestIDX = " & reqidx
	Call db.execSQLRs(SQL , null, ConStr)


	'sd_tennismember
	SQL = "Update sd_TennisMember_partner Set playeridx = '"&pidx&"',username = '"&unm&"'    where gamememberidx = " & midx
	Call db.execSQLRs(SQL , null, ConStr)



	'종목확인하고 복합마술이라면 찾아서 하나더 바꾸자....
	If teamgb = "20103" Then

		SQL = "select top 1 gamememberidx,requestidx from sd_tennismember where gametitleidx = "& tidx &" and teamgb = '20103'  and  playeridx = "&reqpidx&" and requestidx <> " & reqidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		midx2 = rs(0)
		reqidx2 = rs(1)

		SQL = "Update tblGameRequest Set P2_PlayerIDX = '"&pidx&"',P2_UserName = '"&unm&"',P2_SEX = '' where requestIDX = " & reqidx2
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Update sd_TennisMember_partner Set playeridx = '"&pidx&"',username = '"&unm&"'    where gamememberidx = " & midx2
		Call db.execSQLRs(SQL , null, ConStr)

	End if



  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing

%>
