<%
'DB 연결자
ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=splog_dbJ0ehU9fpD0tmO1fld;Password=slogp_gGu6+32!k0h04(BqP~4P7;Initial Catalog=SportsDiary;Data Source=49.247.9.88\SQLExpress,1433;"
'수정내용

SMSStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sms_Ek27fh4gk;Password=sms_VW&e@)&Py$5a^458bP*#e;Initial Catalog=SD_Tennis;Data Source=49.247.9.88\SQLExpress,1433;"

Dim DB, SMSDB
Sub DBOpen()   '#### DB Open
  Err.Clear
  Set DB = Server.CreateObject("ADODB.Connection")
  DB.CommandTimeout = 1000
  DB.Open ConStr
End Sub

Sub SMSDBOpen()   '#### sms DB Open
  Err.Clear
  Set SMSDB = Server.CreateObject("ADODB.Connection")
  SMSDB.CommandTimeout = 1000
  SMSDB.Open SMSStr
End Sub

Sub DBClose()   '#### DB Close
  If DB.State = adStateOpen Then
    DB.Close
  End If
  Set DB = Nothing
End Sub

Sub SMSDBClose()   '#### sms DB Close
  If SMSDB.State = adStateOpen Then
    SMSDB.Close
  End If
  Set SMSDB = Nothing
End Sub

Function InjectionChk(str)    '#### injection 확인
	arrSQL = Array("'","#","exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp ","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")
	If isEmpty(str) Or isNull(str) Then Exit Function
	str = Trim(str)
	For forNum = 0 To Ubound(arrSQL)
		str = Replace(str, arrSQL(forNum), "")
	Next
	InjectionChk = str
End Function

Function InjectionPWChk(str)    '#### injection 확인
	arrSQL = Array("exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp ","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")
	If isEmpty(str) Or isNull(str) Then Exit Function
	str = Trim(str)
	For forNum = 0 To Ubound(arrSQL)
		str = Replace(str, arrSQL(forNum), "")
	Next
	InjectionPWChk = str
End Function

Function StringSql(SQLSting, params)   '#### query 조합
	dim sqlText : sqlText = SQLSting
	For forNum = 0 To Ubound(params)
		If isNull(params(forNum)) Then params(forNum) = ""
    If inStr(sqlText, "#") < 1 Then Exit for
    If params(forNum) = "" Then
      sqlText = Left(sqlText, inStr(sqlText, "#")-1) &"''"& Mid(sqlText, inStr(sqlText, "#")+1)
		ElseIf isNumeric(params(forNum)) Then
			sqlText = Left(sqlText, inStr(sqlText, "#")-1) & Cstr(params(forNum)) & Mid(sqlText, inStr(sqlText, "#")+1)
		Else
			sqlText = Left(sqlText, inStr(sqlText, "#")-1) &"'"& InjectionChk(params(forNum)) &"'"& Mid(sqlText, inStr(sqlText, "#")+1)
		End If
	Next
  StringSql = sqlText
End Function

Function ParamExecuteReturn(sqlText, params, DBConn)   '#### param 이 있고 return 이 있는 execute
  If isArray(params) = false Then
    ParamExecuteReturn = null
    Exit Function
  End If
	set rs = DBConn.Execute(StringSql(sqlText, params))
	resultSetList = Null
	If Not rs.Eof Then
		resultSetList = rs.getRows()
	End If
	rs.Close
	Set rs = Nothing
	ParamExecuteReturn = resultSetList
End Function

Function ExecuteReturn(sqlText, DBConn)   '#### param 이 없고 return 이 있는 execute
	set rs = DBConn.Execute(sqlText)
	resultSetList = Null
	If Not rs.Eof Then
		resultSetList = rs.getRows()
	End If
	rs.Close
	Set rs = Nothing
	ExecuteReturn = resultSetList
End Function

Function ParamsExecuteUpdate(sqlText, params, DBConn)   '#### param 이 있고 return 이 없는 execute
  If isArray(params) = false Then Exit Function
  DBConn.Execute(StringSql(sqlText, params))
End Function

Function ExecuteUpdate(sqlText, DBConn)   '#### return 이 없는 execute
  DBConn.Execute(sqlText)
End Function

Function ResponseQueryString(sqlText, params)   '#### 쿼리 찍기
  If isArray(params) = false Then Exit Function
  Response.Clear
  Response.Write "SQL : "& StringSql(sqlText, params) &"<BR>"
  Response.End
End Function

%>
