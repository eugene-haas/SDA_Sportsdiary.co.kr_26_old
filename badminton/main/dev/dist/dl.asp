<!--#include file="./config.asp"-->
<%
	'파일 다운로드 페이지
	On Error Resume Next

	dim FileName	: FileName 	= fInject(request("FileName"))	
	dim FilePath	: FilePath 	= fInject(request("FilePath"))
	
	dim FileDivision

	FileDivision = fInject(request("FileDivision"))
	
	dim objDownload	
	dim DefaultPath	

	dim fdpath

	IF FileName = "" Then
		response.Write "<script>alert('다운로드 파일정보가 없습니다.\n확인 후 이용하세요.'); history.back();</script>"
		response.End()
	Else
		
		
		'별도의 다운로드 폴더를 지정하는 경우
		IF FilePath <> "" Then
			DefaultPath = server.MapPath("\")&"\"&FilePath&"\"&FileName
		Else
			DefaultPath	= global_filepath&FileName
		End IF
		'if FileDivision = "TB" then
		'			
		'	fdpath = global_filepath_TB
		'
		'	DefaultPath = fdpath&FileName
		'
		'end if

		if FileDivision <> "" then
					
			fdpath = "global_filepath_"&FileDivision
		
			DefaultPath = Eval(fdpath)&FileName

			'DefaultPath = fdpath&FileName
		
		end if


		
		If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "Chrome") > 0 Then
		Else
			Response.AddHeader "Content-Disposition","attachment; filename=""" & Server.URLPathEncode(FileName) & """"
		End If

		'Response.AddHeader "Content-Disposition","attachment; filename=" & Server.URLPathEncode(FileName)
		
		
		SET objDownload = Server.CreateObject("TABSUpload4.Download")
			objDownload.FilePath = DefaultPath
			
			'서버에 저장되어 있는 파일의 이름을 변경해서 전송하는 경우
			'objDownload.FileName = "10월 월간 보고서.xls"		
			
			'웹 브라우저 내에 실행되지 않고 파일로 저장하게끔 지정
			objDownload.TransferFile True, True 	
			
		SET objDownload = Nothing	

'---------------------------------------------------------------------------------------------------------------------------		
'		SET objFile = objFSO.GetFile(DefaultPath)
'		
'		'-- first clear the response, and then set the appropriate headers
'		Response.Clear
'		
'		'-- the filename you give it will be the one that is shown
'		' to the users by default when they save
'		Response.AddHeader "Content-Disposition", "attachment; filename=" &	Server.URLPathEncode(FileName)
'		Response.AddHeader "Content-Length", objFile.Size
'		Response.ContentType = "application/octet-stream"
'
'		SET objStream = Server.CreateObject("ADODB.Stream")
'			objStream.Open
'
'		'-- set as binary
'		objStream.Type = 1
'		Response.CharSet = "UTF-8"
'
'		'-- load into the stream the file
'		objStream.LoadFromFile(DefaultPath)
'
'		'-- send the stream in the response
'		Response.BinaryWrite(objStream.Read)
'		Response.Flush
'		
'			objStream.Close
'		SET objStream = Nothing
'		SET objFile = Nothing
'---------------------------------------------------------------------------------------------------------------------------
		
	End IF		
%>