<!--#include file="../dev/dist/config.asp"-->

<%
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
%>

<%
  Dim  LCnt : LCnt = 0
	'Cookie 값 가져오기 
  iMSeq = fInject(Request("i1"))
  NowPage = fInject(Request("i2"))
  MSeq = decode(iMSeq,0)

	'JudoTitleWriteLine "NowPage", NowPage
	'JudoTitleWriteLine "iLoginID", iLoginID
	'JudoTitleWriteLine "MSeq", MSeq
  '디버깅 모드로 수정 해서 강제로 접근할 경우 체크
  LSQL = "EXEC TeamPlayer_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        LCnt = LCnt + 1
        LoginIDYN = LRs("LoginIDYN")
      LRs.MoveNext
		Loop
  End If
  LRs.close

  ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
  If LoginIDYN = "N" Then
    JudoKorea_DBClose()
    response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='./Player_A_Youth.asp';</script>"
    'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
    response.End
  ELSE
    ' 첨부파일 삭제
    Dim  LCnt1, iType
    LCnt1 = 0
    iType = 1 ' 1:Delete
    LSQL = "EXEC TeamPlayer_Board_Del_STR '" & iType & "','" & MSeq & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          LCnt1 = LCnt1 + 1
          FileName = LRs("FileName")
          filePath = global_filepath + FileName
          DeleteExistFile(filePath)
        LRs.MoveNext
      Loop
    End If
    LRs.close
    JudoKorea_DBClose()
    response.Write "<script type='text/javascript'>location.href='./Player_A_Youth.asp';</script>"
    response.End
    'response.Write "<script type='text/javascript'>alert('삭제가 잘 됐습니다.');location.href='./cmList.asp?i2="&NowPage&"';</script>"
    'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
  End IF
%>
