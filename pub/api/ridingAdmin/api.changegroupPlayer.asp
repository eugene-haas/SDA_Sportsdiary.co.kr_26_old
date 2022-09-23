<%
'#############################################
'선수변경창
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then  'request_r seq (바꾸어서 넣을 아이 groupmember에 update)
		seq= oJSONoutput.MIDX
	End If

	
	If hasown(oJSONoutput, "PIDX") = "ok" Then  'groupmember idx (request startmember N 로 변경할 아이)
		idx= oJSONoutput.PIDX '바꿀맴버 번호
	End If
	



	SQL = "select playeridx,username,requestidx from  tblGameRequest_r where seq = " & seq
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		pidx = rs(0)
		pnm = rs(1)
		reqidx = rs(2)

	  	Call oJSONoutput.Set("REQIDX", reqidx )

		SQL = "select requestidx,pidx,pnm from  sd_groupMember where idx = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		ridx = rs(0)
		rpidx = rs(1)
		rpnm = rs(2)

		SQL = "update tblGameRequest_r set startMember = 'N' where requestidx = '"&ridx&"' and playeridx = '"&rpidx&"' and username = '"&rpnm&"' "
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "update sd_groupMember set pidx = '"&pidx&"',pnm ='"&pnm&"' where idx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "update tblGameRequest_r set startMember = 'Y' where seq = " & seq
		Call db.execSQLRs(SQL , null, ConStr)
	End if

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing

%>
