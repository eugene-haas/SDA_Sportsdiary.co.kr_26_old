<!-- #include file="../../../Library/header.bike.asp" -->
<%
Response.Expires = 0
Response.Buffer = True
Response.Clear

SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

hostIdx  = fInject(Request("hostIdx"))
fileName = fInject(Request("fileName"))
If hostIdx = "" Or fileName = "" Then
  Response.End
End If

SQL = " SELECT HostCode FROM tblBikeHostCode WHERE HostIdx = "& hostIdx
Set rs = db.Execute(SQL)
If Not rs.eof Then
  hostCode = rs(0)
End If


'파일이 저장되어 있는 경로
filepath = "E:\www\upload\sportsdiary\"& hostCode

'다운로드할 파일 이름을 얻어온다.(c:\temp\에 해당 파일이 있으면 다운로드 함)
fileName = request("fileName")
fullFilePath = filepath & fileName

Set fs = Server.CreateObject("Scripting.FileSystemObject")

If fs.FileExists(fullFilePath) Then
  '파일이 있을경우 파일을 스트림 형태로 열어 보낸다.
  Response.ContentType = "application/octet-stream"
  Response.CacheControl = "public"
  Response.AddHeader "Content-Disposition","attachment;filename=" & filename

 Set Stream = Server.CreateObject("ADODB.Stream")
  Stream.Open
  Stream.Type = 1
  Stream.LoadFromFile filepath & filename
  Response.BinaryWrite Stream.Read
  Stream.close
  Set Stream = nothing
Else
  '파일이 없을 경우...
  Response.Write "해당 파일을 찾을 수 없습니다."
End If

Set fs = Nothing

%>
