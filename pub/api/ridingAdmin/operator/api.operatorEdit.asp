<%
'#############################################
'수정(ajax api)
'#############################################
	'request
	idx = oJSONoutput.IDX


	Set db = new clsDBHelper
	tablename = " tblGameManager "
	SQL = "Select top 1 idx,SportsGb,HostCode,ManagerName,ManagerID,ManagerPwd,Gubun,WriteDate from "&tablename&" where idx = "& idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		idx = rs("idx")
		admin_title = rs("ManagerName")
		admin_id = rs("ManagerID")
		admin_pwd = rs("ManagerPwd") 
		writeday = Left(rs("writedate"),10)
	End if

	db.Dispose
	Set db = Nothing


Call oJSONoutput.Set("result", "0" ) 
Call oJSONoutput.Set("HNM", hostname ) 
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
%>
<!-- #include virtual = "/pub/html/riding/operator/inc.operatorform.asp" --> 
