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

	SQL = "SET NOCOUNT ON  insert into sd_TennisBoard (GameTitleIDX,tid,title,contents) values ("&tidx&","&tid&",'"&title&"','"&contents&"') SELECT @@IDENTITY"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	bbsidx = rs(0)
	Call oJSONoutput.Set("result", "70" )

	Call oJSONoutput.Set("idx", bbsidx )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>