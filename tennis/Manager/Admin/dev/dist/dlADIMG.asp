<!--#include file="./config.asp"-->

<%
	'파일 다운로드 페이지
	On Error Resume Next

	dim FileName	: FileName 	= fInject(request("FileName"))	
	dim FilePath	: FilePath 	= fInject(request("FilePath"))	
	
	dim objDownload	
	dim DefaultPath	


	IF FileName = "" Then
		response.Write "<script>alert('다운로드 파일정보가 없습니다.\n확인 후 이용하세요.'); history.back();</script>"
		response.End()
	Else
		
		
		'별도의 다운로드 폴더를 지정하는 경우
		'IF FilePath <> "" Then
		'	DefaultPath = server.MapPath("\")&"\"&FilePath&"\"&FileName
		'Else
			DefaultPath	= global_filepath_ADIMG&"\"&FileName
		'End IF
		
		'Response.AddHeader "Content-Disposition","attachment; filename=" & Server.URLPathEncode(FileName)
		'Response.Write DefaultPath
		'Response.End
		
		SET objDownload = Server.CreateObject("TABSUpload4.Download")
			objDownload.FilePath = DefaultPath
			
			'서버에 저장되어 있는 파일의 이름을 변경해서 전송하는 경우
			'objDownload.FileName = "10월 월간 보고서.xls"		
			
			'웹 브라우저 내에 실행되지 않고 파일로 저장하게끔 지정
			objDownload.TransferFile True, True 	
			
		SET objDownload = Nothing	
		
	End IF		
%>