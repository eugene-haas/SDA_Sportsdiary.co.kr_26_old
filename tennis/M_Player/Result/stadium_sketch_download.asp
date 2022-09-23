<% @ Language=VBScript EnableSessionState="False" %>

<% 
sfile = Request.QueryString("FileName")

Set Download = Server.CreateObject("TABSUpload4.Download")

FilePath =  server.MapPath("\")&"\tennis\m_player\upload\sketch\"&sfile

Download.FilePath = FilePath

'무조건 다운로드를 실행시킴

Download.TransferFile True

Set Download = Nothing
%>