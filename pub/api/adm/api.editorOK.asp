<%
	'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" Then
		idx = oJSONoutput.IDX
	End if
	If hasown(oJSONoutput, "TID") = "ok" Then
		tid = oJSONoutput.TID
	Else
		tid = 1
	End If
	If hasown(oJSONoutput, "TITLE") = "ok" Then
		title = htmlEncode(oJSONoutput.TITLE)
		title = chkStrRpl(title, "") 
	End If
	If hasown(oJSONoutput, "CONTENTS") = "ok" Then
		contents = htmlEncode(oJSONoutput.CONTENTS)
		contents = chkStrRpl(contents, "") 
	End If

	Function setSQT(ddstr) '쌍타옴표 처리
		setSQT = "'"&ddstr&"'"
	End Function

	Set db = new clsDBHelper

	'num
	SQL = "select max(num)+1 from tblBoard where tid = " & tid
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	infld = " tid,uid,ip,title,contents,num "
	inval = tid & "," & setSQT(Cookies_aID)& "," & setSQT(user_ip) & "," & setSQT(title)& "," & setSQT(contents) & "," & rs(0)
	SQL = "insert into tblBoard ("&infld&") values ("&inval&") "
	Call db.execSQLRs(SQL , null, B_ConStr)
	
'	SQL = "update sd_TennisTitle Set summary = '"&contents&"',noticetype= '"&noticetype&"' where gameTitleIDX = " & tidx
'	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing
%>