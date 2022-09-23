<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<%@ codepage="65001" language="VBScript" %>
<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"



''######################################
%>
<!-- #include virtual = "/pub/cfg/cfg.swimmingAdmin.asp" -->
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn_swimming.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->

<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<%

	'저장위치 찾기
	global_filepath_temp = "E:\www\upload\sportsdiary\test\" 


	'해당 폴더가 없으면 생성
'	Set Fso = Server.CreateObject("Scripting.FileSystemObject")
'	if not Fso.FolderExists(global_filepath_temp) Then
'	  global_filepath_temp = Fso.CreateFolder(global_filepath_temp)
'	end If
'	if not Fso.FolderExists(global_filepath) Then
'	  global_filepath = Fso.CreateFolder(global_filepath)
'	end if	
'	Set Fso = nothing


	'업로드를 처리할 오브젝트를 생성합니다.
	Set Upload = Server.CreateObject("TABSUpload4.Upload")

	'업로드 파일 최대 크기를 제한합니다.
	Upload.MaxBytesToAbort = 10 * 1024 * 1024	
	

	'업로드를 시작합니다.
	Upload.Start global_filepath_temp
	Upload.Save global_filepath_temp , False


	Set File = Upload.Form("iFile") '여러개 파일폼중에 선택할수 있는 방법으로 만들어서
	


	Set Upload = Nothing
%>