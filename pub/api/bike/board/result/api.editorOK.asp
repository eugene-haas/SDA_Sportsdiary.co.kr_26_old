<%
	'request 처리##############
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" then
		title = oJSONoutput.TITLE
	End if
	If hasown(oJSONoutput, "CONTENTS") = "ok" then
		contents = oJSONoutput.CONTENTS
	End if
	contents = chkStrRpl(contents, "") 
	contents = Replace(contents,"'","''")		'htmlEncode(contents)

	Set db = new clsDBHelper

	SQL = "update tblBikeTitle Set gameresult = '"&contents&"'where TitleIdx = " & tidx
	Call db.execSQLRs(SQL , null, B_ConStr)

	db.Dispose
	Set db = Nothing
%>