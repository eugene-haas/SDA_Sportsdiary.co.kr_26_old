<%
	'request 처리##############
	tid = 100
	title = "선수정보수정요청"
    pid=""
	idx = 0
	tidx = 0
	levelno = 0
	If hasown(oJSONoutput, "idx") = "ok" then
		idx = oJSONoutput.idx
	End If

	If hasown(oJSONoutput, "pid") = "ok" then
		pid = oJSONoutput.pid
	End If
	
	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	End If
	
	If hasown(oJSONoutput, "levelno") = "ok" then
		levelno = oJSONoutput.levelno
	End if

	contents = oJSONoutput.CONTENTS
	contents = chkStrRpl(contents, "") 
	contents = textareaDecode(contents)

	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	If CDbl(idx) > 0 Then  
       ' SQL = "select top 1 * from sd_TennisBoard "
       ' SQL = SQL & " where seq =" & idx 
       ' SQL = SQL & " and GameTitleIDX =" & tidx 
       ' SQL = SQL & " order by writeday desc "
       ' Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		SQL = "SET NOCOUNT ON  insert into sd_TennisBoard (GameTitleIDX,tid,title,contents) values ("&tidx&","&tid&",'"&title&"','"&contents&"') SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		bbsidx = rs(0)
		Call oJSONoutput.Set("result", "70" )


			if aaaa = 1 then
					If Not rs.eof Then
						SQL = "update sd_TennisBoard set contents = '"&contents&"' "        
						SQL = SQL & " where seq =" & idx 
						SQL = SQL & " and GameTitleIDX =" & tidx 
						Call db.execSQLRs(SQL , null, ConStr)
						bbsidx = idx
						Call oJSONoutput.Set("result", "71" )
					else
						SQL = "SET NOCOUNT ON  insert into sd_TennisBoard (GameTitleIDX,tid,title,contents) values ("&tidx&","&tid&",'"&title&"','"&contents&"') SELECT @@IDENTITY"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						bbsidx = rs(0)
						Call oJSONoutput.Set("result", "70" )
					End if
			end if  
				
	
	else
		SQL = "SET NOCOUNT ON  insert into sd_TennisBoard (GameTitleIDX,tid,title,contents) values ("&tidx&","&tid&",'"&title&"','"&contents&"') SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		bbsidx = rs(0)
	    Call oJSONoutput.Set("result", "70" )
	End if

	Call oJSONoutput.Set("idx", bbsidx )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>