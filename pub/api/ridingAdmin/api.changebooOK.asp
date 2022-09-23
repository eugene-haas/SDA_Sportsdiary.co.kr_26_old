<%
'#############################################
'부서정보변경
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx= oJSONoutput.MIDX
	End If

	If hasown(oJSONoutput, "PIDX") = "ok" Then 
		pidx= oJSONoutput.PIDX 'tblPubCode.pubcodeidx (바꿀부번호 검색 인덱스)
	End If


	If hasown(oJSONoutput, "TYPENO") = "ok" Then 
		typeno = oJSONoutput.TYPENO
	End If

	SQL = "select requestIDX,pubcode,engcode,pubName,orgpubcode,orgengcode,orgpubname from sd_TennisMember where gameMemberIDX = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	reqidx = rs(0) '업데이트할인덱스
	
	SQL = "select pubcode,engcode,pubname from tblPubCode where PPubcode = 'RDN01_4' and pubcodeidx =  " & pidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	pubcode = rs("pubcode")
	engcode = rs("engcode")
	pubname = rs("pubname")

	
	'update 
	If typeno = "1" Then
	
		SQL = "Update tblGameRequest Set pubcode= '"&pubcode&"',engcode='"&engcode&"',pubName='"&pubname&"' where requestIDX = " & reqidx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Update sd_TennisMember Set pubcode= '"&pubcode&"',engcode='"&engcode&"',pubName='"&pubname&"' where gamememberidx = " & midx
		Call db.execSQLRs(SQL , null, ConStr)

	Else '2 원부서

		SQL = "Update tblGameRequest Set orgpubcode= '"&pubcode&"',orgengcode='"&engcode&"',orgpubName='"&pubname&"'  where requestIDX = " & reqidx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Update sd_TennisMember Set orgpubcode= '"&pubcode&"',orgengcode='"&engcode&"',orgpubName='"&pubname&"'   where gamememberidx = " & midx
		Call db.execSQLRs(SQL , null, ConStr)

	End if


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing

%>
