<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":30003,""PARR"":[""78787ㅎ"",""7878ㅎ"",""78787ㅎ"",""78787ㅎ"",""2019-11-11"",""2019-12-12"",""2""]}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	CMD = oJSONoutput.Get("CMD")

'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		e_idx = oJSONoutput.IDX
	End if

	Set db = new clsDBHelper

	tablename = "tblSimpleBoard"

	Sql = "update  "&tablename&" Set   DelYN = 'Y' where seq = " & e_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


