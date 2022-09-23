<%
	'request 처리##############
	tidx = oJSONoutput.TIDX
	title = oJSONoutput.TITLE
	contents = oJSONoutput.CONTENTS

	contents = chkStrRpl(contents, "") 


'If CDbl(InStr(contents, "table border")) >=0  Then
	'contents = Replace(contents, "tbody","tbody style='font-size:10px;' ")
'Else

	contents = Replace(contents,"width:5","width:100%;")

	'contents = Replace(Replace(contents,"<table " ,"<table border='1'  "),"528pt","100%")
	'contents = Replace(contents, "#f0f0f0","")
	'contents = Replace(contents, "tbody","tbody style='font-size:10px;' ")
	'contents = Replace(contents, "background-color:#d7e4bc; height:18pt; width:528pt","background-color:#d7e4bc; height:18pt; width:528pt;border:0")
'End if

'Response.write InStr(contents, "table border")
'Response.end

contents = htmlEncode(contents)




	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	SQL = "update sd_TennisTitle Set summary = '"&contents&"' where gameTitleIDX = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing
%>