<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
<%
'파일이 저장되어 있는 경로
    filepath = "d:\sportsdiary.co.kr\Request\judo\Upload\"

    '다운로드할 파일 이름을 얻어온다.(d:\sportsdiary.co.kr\Request\judo\Upload\에 해당 파일이 있으면 다운로드 함)
    filename = fInject(request("filename"))

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
        Response.Write "해당 파일을 찾을 수 없습니다."
    End If
    
    Set fs = Nothing
%>



