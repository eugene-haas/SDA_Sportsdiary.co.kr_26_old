<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":100,""SEQ"":3,""FLD"":1}"
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
	If hasown(oJSONoutput, "SEQ") = "ok" then
		e_idx = oJSONoutput.Get("SEQ")
	End If
	If hasown(oJSONoutput, "FLD") = "ok" then
		fld = oJSONoutput.Get("FLD")
	End If
	Select Case fld
	Case "1" fldnm = "showYN"
	End Select 

	Set db = new clsDBHelper

	tablename = "home_gameTitle"
	Sql = "update  "&tablename&" Set   "&fldnm&" = case when "&fldnm&" = 'N' then 'Y' else 'N' end where seq = " & e_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


