<!--#include file="./config.asp"-->

<%

  Set Upload = Server.CreateObject("TABSUpload4.Upload")

  Upload.CodePage = 65001
  Upload.Start global_filepath_temp

  Set iFile = Upload.Form("iFile")                ' 실첨부파일,배열

  If Err.Number = 0 Then

    Upload.Save global_filepathImg, False

    'Dim LCnt
    'LCnt = 0
		'
    'LSQL = "EXEC Community_Board_M '" & iType & "','" & iDivision & "','" & Name & "','" & Subject & "','" & iContents & "','" & iLink & "','" & SubType & "','" & NoticeYN & "','','','" & ID & "','" & MSeq & "','','','','',''"
	  ''response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    ''response.End
  	'
    'Set LRs = DBCon4.Execute(LSQL)
		'
    'If Not (LRs.Eof Or LRs.Bof) Then
		'
		'  Do Until LRs.Eof
    '  
    '      LCnt = LCnt + 1
    '      iMSeq = LRs("MSeq")
		'
    '    LRs.MoveNext
		'  Loop
		'
	  'End If
		'
    'LRs.close
  	'
    'For i = 1 To CInt(rFileCnt) step 1
		'
    '  If Upload.Form("iFile")(i) <> "" Then
		'
    '    Dim iFileName
    '    iFileName = iFile(i).ShortSaveName
    '    '파일 TBL 에 Insert
		'
    '    Dim LCnt1
    '    LCnt1 = 0
		'
    '    LSQL = "EXEC Community_Board_Pds_M '" & iType & "','" & iMSeq & "','" & iFileName & "','" & ID & "','" & iDivision & "','','','',''"
	  '    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    '    'response.End
  	'
    '    Set LRs = DBCon4.Execute(LSQL)
		'
    '    If Not (LRs.Eof Or LRs.Bof) Then
		'
		'      Do Until LRs.Eof
    '  
    '          LCnt1 = LCnt1 + 1
		'
    '        LRs.MoveNext
		'      Loop
		'
	  '    End If
		'
    '    LRs.close
		'
    '  End If
		'
    'Next
		'
		'DBClose4()
		'JudoKorea_DBClose()

		iFileName = iFile(1).ShortSaveName
    
    response.Write iFileName
    response.End

  Else
  
		'DBClose4()
		'JudoKorea_DBClose()

    response.Write "<script type='text/javascript'>alert('글 등록에 오류가 있습니다.');location.href='/';</script>"
    response.End
  
  End If

%>