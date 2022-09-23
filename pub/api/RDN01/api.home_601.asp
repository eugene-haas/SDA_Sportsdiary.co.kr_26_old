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
	ortype = oJSONoutput.get("ORTYPE")
	idx = oJSONoutput.get("IDX")
	nm = oJSONoutput.get("NM")
	u1 = oJSONoutput.get("U1")
	u2 = oJSONoutput.get("U2")

	Set db = new clsDBHelper 

	If login = False Then
		Call oJSONoutput.Set("result", 9 ) '로그인안됨
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if

	If ortype = "H" Then
		OrderPrice = 5000
	Else
		OrderPrice = 10000
	end if

			SQL = " insert Into tblOrderTable	"
			SQL = SQL & "	(			"
			SQL = SQL & "		  OR_type	"
			SQL = SQL & "		 ,orderid	"
			SQL = SQL & "		 ,targetidx	" '대상인덱스
			SQL = SQL & "		 ,targetnm  "
			SQL = SQL & "		 ,targetmsg1  "
			SQL = SQL & "		 ,targetmsg2  "
			SQL = SQL & "		 ,OrderPrice  "
			SQL = SQL & "	) values  "
			SQL = SQL & "	(			"
			SQL = SQL & "		  '"&ortype&"'	"
			SQL = SQL & "		 ,'"&session_uid&"'	"
			SQL = SQL & "		 ,'"&idx&"'			"
			SQL = SQL & "		 ,'"&nm&"'		"
			SQL = SQL & "		 ,'"&u1&"'		"
			SQL = SQL & "		 ,'"&u2&"'	"
			SQL = SQL & "		 ,'"&OrderPrice&"'	"
			SQL = SQL & "	)			"
			Call db.execSQLRs(SQL , null, ConStr)			




	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson





  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>