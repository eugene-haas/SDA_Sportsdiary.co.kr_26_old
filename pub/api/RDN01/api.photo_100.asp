<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
'포토갤러 노출여부 
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
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
	Case "2" fldnm = "VIEWYN"
	End Select

	Set db = new clsDBHelper

	tablename = "tblTotalBoard"
	Sql = "update  "&tablename&" Set   "&fldnm&" = case when "&fldnm&" = 'N' then 'Y' else 'N' end where seq = " & e_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
