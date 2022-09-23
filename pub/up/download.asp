<%
    '----------------------------------------------------------------------
    ' *************** ASP 파일 다운로드 소스 ******************
    '  파일 링크 다운로드가 아닌 파일을 직접 읽어 스트림으로 보내는 형식
    ' ****************************************************
    '
    ' [사용방법]
    '  1) download.asp?filename=test.jpg
    '  2) <a href="download/download.asp?filename=aaa.jpg">aaa.jpg 파일 다운로드</a>
    '----------------------------------------------------------------------
    '파일이 저장되어 있는 경로
	filepath  = server.MapPath("\") & "\M_Player\upload\Sketch\"  'D:\sportsdiary.co.kr

    '다운로드할 파일 이름을 얻어온다.(c:\temp\에 해당 파일이 있으면 다운로드 함)
    filename = "ZB4A8251.jpg" 'request("filename") 

    Response.Expires = 0
    Response.Buffer = True
    Response.Clear

    Set fs = Server.CreateObject("Scripting.FileSystemObject")

    If fs.FileExists(filepath & filename) Then
        '파일이 있을경우 파일을 스트림 형태로 열어 보낸다.
        Response.ContentType = "application/octet-stream"
        Response.CacheControl = "public"
        Response.AddHeader "Content-Disposition","attachment;filename=" & filename

        Set Stream=Server.CreateObject("ADODB.Stream")
        Stream.Open
        Stream.Type=1
        Stream.LoadFromFile filepath & filename
        Response.BinaryWrite Stream.Read
        Stream.close
        Set Stream = nothing
    Else 
        '파일이 없을 경우...
        'Response.Write "해당 파일을 찾을 수 없습니다."
    End If
    
    Set fs = Nothing
%>