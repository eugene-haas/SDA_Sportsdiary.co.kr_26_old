<%
'#############################################
'수정(ajax api)
'#############################################
	'request
	idx = oJSONoutput.IDX


	Set db = new clsDBHelper
	tablename = " tblGameHost "
	SQL = "Select top 1 hostname from "&tablename&" where SportsGb = 'tennis' and DelYN = 'N'  and idx = "& idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		hostname = rs("hostname")
	End if

	db.Dispose
	Set db = Nothing


Call oJSONoutput.Set("result", "0" ) 
Call oJSONoutput.Set("HNM", hostname ) 
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
%>
<!-- #include virtual = "/pub/html/swimAdmin/inc.gamehostform.asp" --> 