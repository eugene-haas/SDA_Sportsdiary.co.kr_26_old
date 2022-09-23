<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'유튜브 URL 저장
'#############################################
	'request
 	 e_idx = oJSONoutput.Get("SEQ")
	 e_val = oJSONoutput.Get("VAL")

	 Set db = new clsDBHelper

	 tablename = "tblTotalBoard_file"
	 SQL = "if exists( select seq from tblTotalBoard_file where TotalBoard_SEQ = " & e_idx & " )"
	 Sql = SQL & " update "&tablename&" set FILENAME = '"&e_val&"'  where TotalBoard_SEQ = " & e_idx
	 Sql = SQL & " else "
	 Sql = SQL & " insert into "&tablename&" (TotalBoard_SEQ, FileName ) values ("&e_idx&",'"&e_val&"')"
	 Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
