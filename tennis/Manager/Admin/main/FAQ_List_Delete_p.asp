﻿<!--#include file="../dev/dist/config.asp"-->


<%
 '로그인 체크 
  Check_UserLogin()

  'Cookie 값 가져오기 
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  iName = fInject(Request.Cookies("UserName"))
%>

<%
  ' 뷰에 해당하는 첨부파일 관련
  Dim  LCnt
  LCnt = 0

	' 게시판 고유 번호 
  iMSeq = fInject(Request("i1"))
  MSeq = decode(iMSeq,0)

  
	' 이 현재 페이지에 대해서 알아봐야한다.
  NowPage = fInject(Request("i2"))


	'JudoTitleWriteLine "NowPage", NowPage
	'JudoTitleWriteLine "iLoginID", iLoginID
	'JudoTitleWriteLine "MSeq", MSeq

  ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
  LSQL = "EXEC Community_Board_Read_STR '" & NowPage & "','" & MSeq & "','" & iLoginID & "'"
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
    response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
    response.End

  Else

    ' 첨부파일 삭제
    Dim  LCnt1, iType
    LCnt1 = 0
    iType = 1 ' 1:Delete
    LSQL = "EXEC Community_Board_Del_STR '" & iType & "','" & MSeq & "'"
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

    response.Write "<script type='text/javascript'>location.href='./FAQ_List.asp';</script>"

    response.End
  End If
%>