<%
	'If iLoginID = "" Then '관리자 로그인이 안된경우
	'	Response.end
	'End if

    If hasown(oJSONoutput, "TIDX") = "ok" then
        r_tidx= oJSONoutput.TIDX
	End If
    If hasown(oJSONoutput, "FNM") = "ok" then
        fnm= oJSONoutput.FNM
	End If
    If hasown(oJSONoutput, "UPTYPE") = "ok" then
        uptype= oJSONoutput.UPTYPE
	End If


	'저장위치 찾기
	filepath = "E:\www\upload\sportsdiary\"& fnm

	'파일의 존재유무를 체크하여 존재하면 삭제하는 함수 
	Function DeleteExistFile(filePath) 
	  Dim fso, result 
	  Set fso = CreateObject("Scripting.FileSystemObject") 
	  If fso.FileExists(filePath) Then 
		fso.DeleteFile(filePath) '파일이 존재하면 삭제합니다. 
		result = 1 
	  Else 
		result = 0 
	  End If 
	  DeleteExistFile = result 
	  Set Fso = Nothing
	End Function 

	If DeleteExistFile(filePath) Then 
		'파일이 삭제 되었습니다." 
	Else 
		'파일이 존재하지 않습니다." 
	End If


	Set db = new clsDBHelper

	'디비 업데이트 
	Select Case uptype
	Case "img" : fieldnm = "summaryimg"
	Case "file" : fieldnm = "filenames"
	End Select	
	

	SQL = "Select "&fieldnm&" from sd_tennisTitle where gametitleidx = " & r_tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	files = isNullDefault(rs(0),"")
	If files = "" Then
		updatefn = ""
	Else
		updatefn = Replace(Replace(files , fnm&";", ""), fnm,"")
	End if


	SQL = "Update sd_tennisTitle set "&fieldnm&" = '"& updatefn &"' where gametitleidx = " & r_tidx
	Call db.execSQLRs(SQL , null, ConStr)

	arr = split(updatefn, ";")

	For i = 0 To ubound(arr)
		r_filenmstr = arr(i)
			If r_filenmstr <> "" then
			%><!-- #include virtual = "/pub/up/html.include.filelist.asp" --><%
			End if
	next

	db.Dispose
	Set db = Nothing
%>