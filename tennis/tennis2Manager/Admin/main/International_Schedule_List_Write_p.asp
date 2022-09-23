<!--#include file="../dev/dist/config.asp"-->

<%
  Name = fInject(Request.Cookies("UserName"))
  iLoginID = decode(fInject(Request.cookies("UserID")),0)
%>
<%
  Set Upload = Server.CreateObject("TABSUpload4.Upload")
  Upload.CodePage = 65001
  Upload.Start global_filepath_temp
  iType = fInject(Upload.Form("iType"))              ' 1:글쓰기, 2:수정
  iMSeq = fInject(Upload.Form("iMSeq"))              ' 수정시 글번호
  MSeq = decode(iMSeq,0)
  NowPage = fInject(Upload.Form("iNowPage"))         ' 현재페이지
  iTitle = fInject(Upload.Form("iTitle"))            ' 제목
  iContents = fInject(Upload.Form("iContents"))      ' 내용
  iLocation = fInject(Upload.Form("iLocation"))      ' 유도장정보
  iStartDate = fInject(Upload.Form("iStartDate"))      ' 내용
  iEndDate  = fInject(Upload.Form("iEndDate"))      ' 내용
  iMatchFileCnt = Upload.Form("iMatchFile").Count           ' 실첨부파일 갯수
  iResultFileCnt = Upload.Form("iResultFile").Count           ' 실첨부파일 갯수
  iAttachFileCnt = Upload.Form("iAttachFile").Count           ' 실첨부파일 갯수

  Set iMatchFile = Upload.Form("iMatchFile")                ' 실첨부파일,배열
  Set iResultFile = Upload.Form("iResultFile")                ' 실첨부파일,배열
  Set iAttachFile = Upload.Form("iAttachFile")                ' 실첨부파일,배열

  'JudoTitleWriteLine "iType", iType
  'JudoTitleWriteLine "iTitle", iTitle
  'JudoTitleWriteLine "iContents", iContents
  'JudoTitleWriteLine "iLocation", iLocation
  'JudoTitleWriteLine "iStartDate", iStartDate
  'JudoTitleWriteLine "iEndDate", iEndDate
  'JudoTitleWriteLine "iMatchFileCnt", iMatchFileCnt
  'JudoTitleWriteLine "iResultFileCnt", iResultFileCnt
  'JudoTitleWriteLine "iAttachFileCnt", iAttachFileCnt

  
   Dim LCnt
   If Err.Number = 0 Then
     Upload.Save global_filepath, False
     LCnt = 0
     LSQL = "EXEC Conference_Board_Mod_STR '" & iType & "','" & Name & "','" & iTitle & "','" & iContents & "','" & iLink & "','" & iLocation & "','" & iStartDate & "','" & iEndDate & "','" & Temp  & "','" & iLoginID & "','" & MSeq & "'"
 	  response.Write "LSQL="&LSQL&"<BR>"
     'response.End
     Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
 	  Do Until LRs.Eof
          LCnt = LCnt + 1
          iMSeq = LRs("MSeq")
        LRs.MoveNext
 	  Loop
   End If
    LRs.close
     For i = 1 To CInt(iMatchFileCnt) step 1
      If Upload.Form("iMatchFile")(i) <> "" Then
        iFileName = iMatchFile(i).ShortSaveName
        iGroupName ="대진표"    
        LSQL = "EXEC Conference_Board_Pds_Mod_STR '" & iType & "','" & iMSeq & "','" & iFileName & "','" & iGroupName & "','" & iLoginID & "'"
       'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'response.End
        Set LRs = DBCon4.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
 	      Do Until LRs.Eof
              LCnt1 = LCnt1 + 1
            LRs.MoveNext
 	      Loop
       End If
        LRs.close
      End If
    Next

     For i = 1 To CInt(iResultFileCnt) step 1
      If Upload.Form("iResultFile")(i) <> "" Then
        iFileName = iResultFile(i).ShortSaveName
         iGroupName ="대회결과"    
        LSQL = "EXEC Conference_Board_Pds_Mod_STR '" & iType & "','" & iMSeq & "','" & iFileName & "','" & iGroupName & "','" & iLoginID & "'"
       'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'response.End
        Set LRs = DBCon4.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
 	      Do Until LRs.Eof
              LCnt1 = LCnt1 + 1
            LRs.MoveNext
 	      Loop
       End If
        LRs.close
      End If
    Next
  
    For i = 1 To CInt(iAttachFileCnt) step 1
      If Upload.Form("iAttachFile")(i) <> "" Then
        iFileName = iAttachFile(i).ShortSaveName
        iGroupName ="첨부파일"    
        LSQL = "EXEC Conference_Board_Pds_Mod_STR '" & iType & "','" & iMSeq & "','" & iFileName & "','" & iGroupName & "','" & iLoginID & "'"
       'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'response.End
        Set LRs = DBCon4.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
 	      Do Until LRs.Eof
              LCnt1 = LCnt1 + 1
            LRs.MoveNext
 	      Loop
       End If
        LRs.close
      End If
    Next
 	  
     IF ( iType = 1 ) THEN
    response.Write "<script type='text/javascript'>alert('정상적으로 등록되었습니다.');location.href='./International_Schedule_List.asp';</script>"
    response.End
    ELSEIF  ( iType = 2 ) THEN
    response.Write "<script type='text/javascript'>alert('정상적으로 수정되었습니다.');location.href='./International_Schedule_List.asp';</script>"
    response.End
    ELSE
    response.Write "<script type='text/javascript'>alert('글 등록에 오류가 발생했습니다.');location.href='./International_Schedule_List.asp';</script>"
    response.End
    END IF
  Else
      response.Write "<script type='text/javascript'>alert('글 등록에 오류가 있습니다.');location.href='./International_Schedule_List.asp';</script>"
      response.End
  End If

  JudoKorea_DBClose()

%>