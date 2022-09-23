<%
'######################
'부서찾기
'######################
	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = chkInt(oJSONoutput.SEQ,0)
	End if	

	If hasown(oJSONoutput, "IMGARR") = "ok" then
		IMGARR = chkStrRpl(oJSONoutput.IMGARR,"")
	End if	

	Set db = new clsDBHelper

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
	End Function 


	'실경로 이미지 명 조회
	SQL = "Select filename,Thumbnail  from sd_bikeBoard_c where idx in ("&IMGARR&")"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	global_filepath_temp  = server.MapPath("\") 
	global_filepath_temp  = Replace(global_filepath_temp,"\Manager","")&"\M_Player\upload\Sketch\"
	thumb_path = global_filepath_temp & "Thumbnail\"

	Do Until rs.eof 
	'실제 경로 이미지 삭제
		fileName = global_filepath_temp & rs("filename")
		thumbnail = thumb_path & rs("Thumbnail")
	
		f1 = DeleteExistFile(fileName)
		f2 = DeleteExistFile(thumbnail)

		'If DeleteExistFile(filePath) Then 
			' 파일이 삭제 되었습니다.
		'Else 
			' 파일이 존재하지 않습니다. 
		'End If

	rs.movenext
	loop

'	테이블 이미지 일괄 삭제
	SQL = "Delete from sd_bikeBoard_c where idx in ("&IMGARR&")"
	Call db.execSQLRs(SQL , null, ConStr)

	'테이블 tailcnt 업데이트
	SQL = "Update sd_bikeBoard Set tailcnt = (select count(*) from sd_bikeBoard_c where seq = "&seq&") where seq = " & seq
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing


	'수정 모드로 커맨드 변경한 그대로 보낸다.
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.write strjson
%>

