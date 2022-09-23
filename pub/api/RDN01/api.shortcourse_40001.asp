<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%

'#############################################
'에디터창
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if
	If hasown(oJSONoutput, "CONTENTS") = "ok" then
		contents = oJSONoutput.CONTENTS
	End if


	Set db = new clsDBHelper

	contents = chkStrRpl(contents, "") 
	contents = htmlEncode(contents) 'Replace(contents,"'","''")		'

	Set db = new clsDBHelper

	SQL = "update tblTotalBoard Set contents = '"&contents&"'where seq = " & reqidx
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing
%>


