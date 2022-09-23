<%
'#############################################
'수정(ajax api)
'#############################################
	'request
	e_idx = oJSONoutput.IDX


	Set db = new clsDBHelper
	tablename = " tblInsertData "
	SQL = "Select top 1 hostname from "&tablename&" where SportsGb = 'tennis' and DelYN = 'N'  and idx = "& e_idx
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

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
<!-- #include virtual = "/pub/html/riding/common/html.dataInsertForm.asp" --> 