<!-- #include virtual = "/pub/header.pub.asp" -->
<%
	If Cookies_aID = "" Then '관리자 로그인이 안된경우
		Response.end
	End if



	Set db = new clsDBHelper

	'저장위치 찾기
	global_filepath_temp = "E:\www\upload\sportsdiary\"&sitecode&"\TEMP\" '임시저장
	global_filepath = "E:\www\upload\sportsdiary\"&sitecode&"\"&year(date)&"\"
	global_filepath_DB = "/"& sitecode &"/"& year(date) &"/"

	'해당 폴더가 없으면 생성
	Set Fso = Server.CreateObject("Scripting.FileSystemObject")
	if not Fso.FolderExists(global_filepath_temp) Then
	  global_filepath_temp = Fso.CreateFolder(global_filepath_temp)
	end if

	
	
	Set Fso = nothing


	'업로드를 처리할 오브젝트를 생성합니다.
	Set Upload = Server.CreateObject("TABSUpload4.Upload")

	'업로드 파일 최대 크기를 제한합니다.
	Upload.MaxBytesToAbort = 20 * 1024 * 1024	
	
	'업로드를 시작합니다.
	Upload.Start global_filepath_temp

	'업로드된 파일을 디스크에 저장합니다.(true Overwrite)
	Upload.Save global_filepath , False

	r_tidx = Upload.Form("title_idx")	 '저장하고 아래서 받아야 되는군 ㅡㅡ.
	uptype = Upload.Form("uptype") '업로드 어떤건지구분
	filename = Upload.Form("noticefile").ShortSaveName	
	dbsavefilename = global_filepath_DB & filename

	Set Upload = Nothing
	

	'디비 업데이트 
	Select Case uptype
	Case "img" : fieldnm = "summaryimg"
	Case "file" : fieldnm = "filenames"
	End Select
	
	SQL = "Select "&fieldnm&" from sd_tennisTitle where gametitleidx = " & r_tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, R_ConStr)
	files = isNullDefault(rs(0),"")
	If files = "" Then
		updatefn = dbsavefilename
	Else
		updatefn = files & ";" & dbsavefilename
	End if


	SQL = "Update sd_tennisTitle set "&fieldnm&" = '"& updatefn &"' where gametitleidx = " & r_tidx
	Call db.execSQLRs(SQL , null, R_ConStr)

	arr = split(updatefn, ";")


'	'파일 목록을 배열로 보내자.
'	Set obj = JSON.Parse("{}")
'	Call obj.Set("tidx", tidx )
'	Call obj.Set("arr", arr )
'	strjson = JSON.stringify(obj)
'	'파일 목록을 배열로 보내자.
'	Response.write strjson

	'인클루드 해서 그리자...

	For i = 0 To ubound(arr)
		r_filenmstr = arr(i)
			If r_filenmstr <> "" then
			%><!-- #include virtual = "/pub/up/html.include.filelist.asp" --><%
			End if
	next


	db.Dispose
	Set db = Nothing
%>
