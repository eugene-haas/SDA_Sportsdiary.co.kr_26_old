<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
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
	Case "3" fldnm = "printcnt"
	End Select 

	Set db = new clsDBHelper

	tablename = "tblOrderTable"
	Sql = "update  "&tablename&" Set   "&fldnm&" = case when "&fldnm&" = 0 then 1 else 0 end where OrderIDX = " & e_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


