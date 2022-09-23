<!--#include file="./config.asp"-->

<%

  PSeq = fInject(Request("i4"))
  FileName = fInject(Request("i5"))
  iMSeq = fInject(Request("i6"))
  'MSeq = decode(iMSeq,0)
	MSeq = crypt.DecryptStringENC(iMSeq)

	iGubun = fInject(Request("i7"))

	FileDivision = fInject(Request("i8"))

	fdpath = global_filepath

	'if FileDivision = "TB" then
	'
	'	fdpath = global_filepath_TB
	'
	'end if

	if FileDivision <> "" then

		fdpath = "global_filepath_"&FileDivision

	end if

	'JudoTitleWriteLine "PSeq", PSeq
	'JudoTitleWriteLine "FileName", FileName
	'JudoTitleWriteLine "iMSeq", iMSeq
	'JudoTitleWriteLine "MSeq", MSeq


  ' common_function.asp 로 옮김
  'Function DeleteExistFile(filePath) 
  '  Dim fso, result
  '  Set fso = CreateObject("Scripting.FileSystemObject") 
  '  If fso.FileExists(filePath) Then 
  '    fso.DeleteFile(filePath) '파일이 존재하면 삭제합니다. 
  '    result = 1
  '  Else
  '    result = 0
  '  End If
  '  DeleteExistFile = result
  'End Function


  Dim LCnt1
  LCnt1 = 0
  
  iType = 1 'File Delete
  
	if iGubun = "1" then
	LSQL = "EXEC Community_Board_Pds_D '" & iType & "','" & PSeq & "','" & MSeq & "'"
	elseif iGubun = "2" then
	LSQL = "EXEC Community_Board_Pds_D '" & iType & "','" & PSeq & "','" & MSeq & "'"
  elseif iGubun = "3" then
  LSQL = "EXEC Community_Board_Pds_D '" & iType & "','" & PSeq & "','" & MSeq & "'"
  elseif iGubun = "4" then
  LSQL = "EXEC Community_Board_Pds_D '" & iType & "','" & PSeq & "','" & MSeq & "'"
	else
  LSQL = "EXEC Community_Board_Pds_D '" & iType & "','" & PSeq & "','" & MSeq & "'"
	end if

	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        LCnt1 = LCnt1 + 1
				DeleteYN = LRs("DeleteYN")
      LRs.MoveNext
		Loop
  End If
  LRs.close
  DBClose()

  filePath = Eval(fdpath) + FileName
  'filePath = "D:\WEB\judo.sports.or.kr\FileDown\" + FileName 'common_function 에 global_filepath 사용으로 사용안함
  'filePath = "../../FileDown/" + FileName '상대경로는 인식 못함, 사용안함
  'response.Write filePath
  DeleteExistFile(filePath)

	response.Write DeleteYN

%>