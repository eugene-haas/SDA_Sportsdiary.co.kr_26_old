<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'저장 (결제정보 임시저장)
'#############################################

	'request
	seq = oJSONoutput.get("SEQ")

	Set db = new clsDBHelper

'	If login = False Then
'		Call oJSONoutput.Set("result", 9 ) '로그인안됨
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson
'		Response.end
'	End if



	SQL = " update tblOrderTable	set printcnt = 1 where OrderIDX = '"&seq&"' "
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
