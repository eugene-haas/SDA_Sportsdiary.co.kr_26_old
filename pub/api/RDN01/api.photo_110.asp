<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'개별 파일삭제
'#############################################
	'request
 	 e_idx = oJSONoutput.Get("SEQ")

	 Set db = new clsDBHelper
	
	 tablename = "tblTotalBoard_file"
	 Sql = "delete from "&tablename&"  where seq = " & e_idx
	 Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
