<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'저장
'#############################################

	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR
	End if
	
	'{""CMD"":30001,""SENDPRE"":""kor_"",""PARR"":[""2020"",""강택"",""6638"",""KANG TEAK"",""ATE0003139"",""강원도승마협회"",""200312004851"",""M"",""19871006"",""마장마술""]}
	Set db = new clsDBHelper 
		tablename = "tblPlayer_korea"
		strFieldName = " regyear,UserName,playeridx,engName,team,teamnm,ksportsno,Sex,birthday,teamgbnm  "

		For i = 0 To oJSONoutput.PARR.length-1 '받은거 기준 (입력값 준비)
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO "&tablename&" ( "&strFieldName&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>