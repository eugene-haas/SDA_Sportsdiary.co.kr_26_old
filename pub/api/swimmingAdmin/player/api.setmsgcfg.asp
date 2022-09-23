<%
'#############################################
'temp 데이터를 request 테이블에 밀어넣는다.
'#############################################

	'request
   If hasown(oJSONoutput, "SETTYPE") = "ok" Then
		settype = oJSONoutput.get("SETTYPE")
	End If
	If hasown(oJSONoutput, "SETVAL") = "ok" Then
		setvalue = oJSONoutput.get("SETVAL")
	End If

	Set db = new clsDBHelper

   select case settype
   case "sido"
      fld = "sido"
      setvalue = addZero(setvalue)
   case "boo"
      fld = "boonm"
   case "teamcode"
      fld = "teamcode"
   case "message"
      fld = "message"
      setvalue = replace(setvalue,"'","''")
   end select


	'공통 ###########################################
      SQL = "if exists (select * from tblMsgSend_cfg where adminid = '"&Cookies_aID&"' and delyn = 'N' and mtype = '1') "
      SQL = SQL & " update tblMsgSend_cfg set "&fld&" = '"&setvalue&"' where adminid = '"&Cookies_aID&"' and delyn='N' and mtype = '1' "
      SQL = SQL & "Else "
      SQL = SQL & " insert into tblMsgSend_cfg (mtype,adminid,"&fld&") values ('1','"&Cookies_aID&"','"&setvalue&"') "
      Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing


%>
