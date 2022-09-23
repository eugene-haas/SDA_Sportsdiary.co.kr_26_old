<!--#include file="./config.asp"-->

<%

  iPSeq = fInject(Request("i4"))
	PSeq = decode(iPSeq,0)
  FileName = fInject(Request("i5"))
  iMSeq = fInject(Request("i6"))
  MSeq = decode(iMSeq,0)

	iGubun = fInject(Request("i7"))

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
	LSQL = "EXEC Community_tblColumnistG_Pds_D '" & iType & "','" & PSeq & "','" & MSeq & "'"
	'elseif iGubun = "2" then
	'LSQL = "EXEC News_Board_Pds_Del_STR '" & iType & "','" & PSeq & "','" & MSeq & "'"
	else
  LSQL = "EXEC Community_tblColumnistG_Pds_D '" & iType & "','" & PSeq & "','" & MSeq & "'"
	end if

	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon5.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        LCnt1 = LCnt1 + 1
      LRs.MoveNext
		Loop
  End If
  LRs.close
  Tennis_DBClose()

  filePath = global_filepath&"\"&FileName
  'filePath = "D:\WEB\judo.sports.or.kr\FileDown\" + FileName 'common_function 에 global_filepath 사용으로 사용안함
  'filePath = "../../FileDown/" + FileName '상대경로는 인식 못함, 사용안함
  'response.Write filePath

	response.Write DeleteExistFile(filePath)

%>