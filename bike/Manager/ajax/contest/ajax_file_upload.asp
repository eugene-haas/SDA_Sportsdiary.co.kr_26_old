<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Dim fileType, titleIdx
sitecode = "BIKE01"

'저장위치
global_filepath = "E:\www\upload\sportsdiary\"&sitecode&"\"&year(date)&"\"
global_filepath_db = "http://upload.sportsdiary.co.kr/sportsdiary/BIKE01/2019/"

'해당 폴더가 없으면 생성
Set Fso = Server.CreateObject("Scripting.FileSystemObject")
if not Fso.FolderExists(global_filepath) Then
  global_filepath = Fso.CreateFolder(global_filepath)
end if
Set Fso = nothing

'업로드를 처리할 오브젝트를 생성합니다.
Set Upload = Server.CreateObject("TABSUpload4.Upload")
Upload.Start global_filepath
Set File = Upload.Form("uploadIMG") '등록파일

'	Set File = Upload.Form("uploadIMG") '등록파일

'	'업로드를 시작합니다.
'	Upload.Start global_filepath
'	Set File = Upload.Form("uploadIMG") '등록파일
	titleIdx = Upload.Form("titleIdx") ' 대회idx
	fileType = Upload.Form("fileType") ' 파일타입(요강, 대회규정, 종목정보)
	file_origin_name = fInject(File.FileName)
	save_file_name = Replace(date, "-", "") & "_" & titleIdx & "_" & fileType & "_" & file_origin_name
'
'	'업로드된 파일을 디스크에 저장합니다.(Overwrite)
	File.SaveAs global_filepath & save_file_name, false


Set db = new clsDBHelper

If InStr(save_file_name, "_undefined") > 0  Then
SQL = " UPDATE tblBikeTitle SET "& fileType &" = null WHERE TitleIdx = '"& titleIdx &"'"
Call db.execSQLRs(SQL, Null, B_ConStr)
Response.Write global_filepath_db 
else
SQL = " UPDATE tblBikeTitle SET "& fileType &" = '"& global_filepath_db & save_file_name &"' WHERE TitleIdx = '"& titleIdx &"'"
Call db.execSQLRs(SQL, Null, B_ConStr)
Response.Write global_filepath_db & save_file_name
End if


'Response.write File.FileName


'http://upload.sportsdiary.co.kr/sportsdiary/BIKE01/2019/20190813_14_tableimg_undefined
%>
