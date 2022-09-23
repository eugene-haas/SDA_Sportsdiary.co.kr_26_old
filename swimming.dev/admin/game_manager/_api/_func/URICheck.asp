<!--#include virtual="/api/_conn/DBCon.asp"-->
<!--#include virtual="/api/_Func/utx.asp"-->
<!--#include virtual="/api/_Func/utx_log.asp"-->

<%
Function ERRORLOG_FileWriteLine(params)   '#### 접근오류 저장
  Dim FileObject, Out
  today = replace(date(),"-","")
  FileName = "ErrorLog_"&today&".log"
  Set FileObject = Server.CreateObject("Scripting.FileSystemObject")
  If FileObject.Fileexists("C:\WEBLOGFILE\icheon\syslog\errorLog\"&FileName) Then
    Set Out = FileObject.OpenTextFile("C:\WEBLOGFILE\icheon\syslog\errorLog\"&FileName,8,TRUE)
  Else
    Set Out = FileObject.CreateTextFile("C:\WEBLOGFILE\icheon\syslog\errorLog\"&FileName,TRUE,FALSE)
  End If
  text = date() &" "& time() &" - "
  If IsArray(params) Then
    For i = 0 To Ubound(params)
      text = text & params(i) &", "
    Next
  Else
    text = text & params
  End If
  Out.WriteLine(text)
  Out.Close
  Set Out = Nothing
  Set FileObject = Nothing
End Function

Function AlertMsgLocation(msg, uriString)   '#### alert찍고 location 을 변경
  Response.Clear
  Response.Write "<!DOCTYPE html><html lang=""ko""><head><title>이천선수촌</title>"
  Response.Write "<script>"
  IF Trim(msg) <> "" AND isnull(msg) = false Then Response.Write "alert("""& msg &""");"
  IF Trim(uriString) <> "" AND isnull(uriString) = false Then Response.Write "location.href="""& uriString &""";"
  Response.Write "</script>"
  Response.Write "</head><body></body></html>"
  Response.End
End Function

DBOpen()
URIs = SPLIT(request.servervariables("HTTP_url"),"/")
CHKURI = SPLIT(URIs(Ubound(URIs)),"?")

'strLog = sprintf("URICheck.asp  URIs = {0}, CHKURI(0) = {1} ", Array(request.servervariables("HTTP_url"), CHKURI(0)))
'Call utxLog(DEV_LOG1, strLog)

' 접근할수 있는 URI 인지 검색'
SELECT_SQL = " SELECT COUNT(A.SEQ) FROM TB_MENU A "
SELECT_SQL = SELECT_SQL & " INNER JOIN TB_MENU_GROUP B ON B.DELKEY = 0 AND A.SEQ = B.MENU_SEQ "
SELECT_SQL = SELECT_SQL & " INNER JOIN TB_GROUP C ON C.DELKEY = 0 AND B.GROUP_SEQ = C.SEQ "
SELECT_SQL = SELECT_SQL & " WHERE C.CODE = '"& SESSION("groupcode") &"' AND dbo.FN_EXTRACT_FILENAME(A.URI) = '"& InjectionChk(CHKURI(0)) &"' "
CHK_COUNT = ExecuteReturn(SELECT_SQL, DB)

' 접근통제 되면 에러로그 남기고 메인으로.
' 접근통제 되면 에러로그 남기고 메인으로.
If CHK_COUNT(0,0) = 0 Then
'2021-03-11 개발서버에서 페이지 권한 체크 비활성화 by chansoo
'If 1 = 0 Then
  Dim errorParam
  Redim errorParam(6)
  errorParam(0) = "IP : "& Request.ServerVariables("REMOTE_ADDR")
  errorParam(1) = "AGENT : "& Request.ServerVariables("HTTP_USER_AGENT")
  errorParam(2) = "USERID : "& Session("userid")
  errorParam(3) = "ASSOCIATION_CODE : "& Session("association_code")
  errorParam(4) = "GROUPCODE : "& Session("groupcode")
  errorParam(5) = "ACCESS : "& Session("access")
  errorParam(6) = "ACTIVEURI : "& CHKURI(0)
  Call ERRORLOG_FileWriteLine(errorParam)

  Session.Contents.RemoveAll()
  Call AlertMsgLocation("접근하신 URL은 권한이 없습니다. 권한 없는 활동은 기록 됩니다. \n확인을 누르면 기본페이지로 이동합니다.","/index.asp")
End If

DBClose()
%>
