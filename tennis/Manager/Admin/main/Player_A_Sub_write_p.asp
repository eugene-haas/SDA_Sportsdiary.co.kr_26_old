<!--#include file="../dev/dist/config.asp"-->

<%
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
%>


<%

 'iLink = "" ' 동영상링크등 링크주소
 ''iLink = fInject(Request("iLink"))  ' 동영상링크등 링크주소
 ''iType = fInject(Request("iType"))           ' 1:글쓰기, 2:수정
 ''iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
 ''MSeq = decode(iMSeq,0)
 ''NowPage = fInject(Request("iNowPage"))      ' 현재페이지
 ''Subject = fInject(Request("iSubject"))      ' 제목
 ''Contents = fInject(Request("iContents"))
 ''iContents = HtmlSpecialChars(Contents)
 ''Name = fInject(Request("iName"))            ' 로그인유저
 ''ID = fInject(Request("iID"))                ' 로그인ID
 iTP_Type = "T00004" ' 선수등록현황
 Set Upload = Server.CreateObject("TABSUpload4.Upload")
 Upload.CodePage = 65001
 Upload.Start global_filepath_temp
 iType = fInject(Upload.Form("iType"))           ' 1:글쓰기, 2:수정
 iMSeq = fInject(Upload.Form("iMSeq"))           ' 수정시 글번호
 MSeq = decode(iMSeq,0)
 NowPage = fInject(Upload.Form("iNowPage"))      ' 현재페이지
 iName = fInject(Upload.Form("iName"))           ' 이름
 iSchool = fInject(Upload.Form("iSchool"))           ' 학교
 iselectYear = fInject(Upload.Form("selectYear"))      ' 년도
 iselectTypeOption = fInject(Upload.Form("selectTypeOption"))         ' 팀소속
 iselectPositionOption = fInject(Upload.Form("selectPositionOption")) ' 직책
 iselectOptionWeight = fInject(Upload.Form("selectOptionWeight"))     ' 구분
 FileCnt = fInject(Upload.Form("iFilecnt"))      ' 열린첨부파일항목갯수
 rFileCnt = Upload.Form("iFile").Count           ' 실첨부파일 갯수
 Set iFile = Upload.Form("iFile")                ' 실첨부파일,배열

 'JudoTitleWriteLine "iName", iName
 'JudoTitleWriteLine "MSeq", MSeq
 'JudoTitleWriteLine "NowPage", NowPage
 'JudoTitleWriteLine "iType", iType
 'JudoTitleWriteLine "iselectYear", iselectYear
 'JudoTitleWriteLine "iSchool", iSchool
 'JudoTitleWriteLine "selectTypeOption", iSelectTypeOption
 'JudoTitleWriteLine "selectOptionWeight", iSelectOptionWeight
 'JudoTitleWriteLine "selectPositionOption", iselectPositionOption
 'JudoTitleWriteLine "rFileCnt", rFileCnt

 If Err.Number = 0 Then
   Upload.Save global_filepath, False
   Dim LCnt
   LCnt = 0
    LSQL = "EXEC TeamPlayer_Board_Mod_STR '" & iType & "','" & iTP_Type & "','" & iTeamName & "','" & iSchool &  "','" & MSeq & "','" & iPhone & "','" & iUserAddr & "','" & iUserAddrDtl & "','" & iPostCode & "','" & iLeaderName & "','" & iCoachName & "','"  & iselectLocal & "','"  & iselectDivision & "','"  & IselectTypeOption  & "','" & iselectPositionOption & "','"  & iselectYear & "','"  & iName  & "','" & iselectOptionWeight & "','" & iLicenseNum & "','" & iselectLicenseDate  & "','" & iLoginID & "'"
    'LSQL = "EXEC TeamPlayer_Board_Mod_STR '" & iType & "','" & iTP_Type & "','" & iTeamName & "','" & iSchool &  "','" & MSeq & "','" & iPhone & "','" & iUserAddr & "','" & iLeaderName & "','" & iCoachName & "','"  & iselectLocal & "','"  & iselectDivision & "','"  & iselectTypeOption & "','" & iselectPositionOption & "','"  & iselectYear & "','"  & iName  & "','" & iselectOptionWeight & "','"  & iLoginID & "'"
    'response.Write "LSQL="&LSQL&"<br>iFileType1="&iFileType1&"<BR>iFileType2="&iFileType2&"<BR>"
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
      For i = 1 To CInt(rFileCnt) step 1
        If Upload.Form("iFile")(i) <> "" Then
          Dim iFileName
          iFileName = iFile(i).ShortSaveName
          '파일 TBL 에 Insert
          Dim LCnt1
          LCnt1 = 0
          LSQL = "EXEC TeamPlayer_Board_Pds_Mod_STR '" & iType & "','" & iMSeq & "','" & iFileName & "','" & iLoginID & "'"
          'response.Write "LSQL="&LSQL&"<br>"
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
  response.Write "<script type='text/javascript'>alert('정상적으로 등록되었습니다.');location.href='./Player_A_Sub.asp';</script>"
  response.End
  ELSEIF  ( iType = 2 ) THEN
  response.Write "<script type='text/javascript'>alert('정상적으로 수정되었습니다.');location.href='./Player_A_Sub.asp';</script>"
  response.End
  ELSE
  response.Write "<script type='text/javascript'>alert('오류가 발생했습니다.');location.href='./Player_A_Sub.asp';</script>"
  response.End
  END IF
Else
  response.Write "<script type='text/javascript'>alert('오류가 발생했습니다.');location.href='./Player_A_Sub.asp';</script>"
  response.End
End If
JudoKorea_DBClose()
%>