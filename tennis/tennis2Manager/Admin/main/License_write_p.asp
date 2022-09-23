<!--#include file="../dev/dist/config.asp"-->

<%
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
%>


<%
  On Error Resume Next
  Dim constVisit : constVisit ="visit"
  Dim constPost : constPost ="post"
  Dim constFax : constFax = "fax"

    '단증 정보
  Dim constLittleLevel : constLittleLevel ="littleLevel"
  Dim constBigLevel : constBigLevel ="bigLevel"
  Dim constMixLevel : constMixLevel ="mixLevel"

  Dim IsLoginType, UserId
  iMSeq = fInject(Request("iMSeq"))
  MSeq = decode(iMSeq,0)
  iType = fInject(Request("iType"))

  IF iType = 0 THEN iType = 1
  iDivision = 2

  iStatus = fInject(Request("selectStatusOption"))          ' 상태
  iUserName = fInject(Request("iName"))                     ' 이름
  iPhone = fInject(Request("iPhone"))                       ' 연락처
  iBirthday = fInject(Request("selectBirthDay"))            ' 생년월일
  iPublishingType = fInject(Request("selPublishingType"))   ' 발급용도
  iLevelType = fInject(Request("iLevelType"))               ' 재발급 단증
  iSubmittingOrg = fInject(Request("selSubmittingOrg"))     ' 제출처
  iReceiveType = fInject(Request("iReceiveType"))           ' 수령방법
  iPayment = fInject(Request("span_Price"))                 ' 발급 수수료
  iPostCode = fInject(Request("postcode"))                  ' 우편번호
  iAddress = fInject(Request("UserAddr"))                   ' 도로명 주소
  iAddressDetail = fInject(Request("UserAddrDtl"))          ' 세부주소
  iLink = fInject(Request("iLink"))                         ' 이미지
  iFileName  = fInject(Request("hidFileName"))              ' 파일 이름
  iFileCnt = fInject(Request("hidFileCnt"))                 ' 파일 카운트
  iCertificateName = "단증조회 및 재발급"                     ' 증명서 종류
  
  if(Len(iStatus) = 0 ) Then
   iStatus = "OS00001"  '진행상태
  End If

  if (iReceiveType = constPost) Then
    iReceiveType = "우편"
  ELSEIF (iReceiveType = constVisit) Then
    iReceiveType = "방문"
    iReceipt_VisitDate = fInject(Request("selectVisitDate")) ' 방문일자
  ELSEIF (iReceiveType = constFax) Then
    iReceiveType = "팩스"
    iFax= fInject(Request("iFaxNumber"))   ' 방문일자 
  ELSE 
    response.Write "<script type='text/javascript'>alert('구독신청 시 오류가 발생했습니다.');history.back();</script>"
    response.End
  END IF

   if (iLevelType = constLittleLevel) Then
    iLevelType = "소단증"
  ELSEIF (iLevelType = constBigLevel) Then
    iLevelType = "대단증"
  ELSEIF (iLevelType = constMixLevel) Then
    iLevelType = "소단증/대단증"
  ELSE 
    response.Write "<script type='text/javascript'>alert('구독신청 시 오류가 발생했습니다.');history.back();</script>"
    response.End
  END IF

  
  'JudoWriteLine "Cookie 값"
  'JudoTitleWriteLine "iType", iType
  'JudoTitleWriteLine "MSeq", MSeq
  'JudoTitleWriteLine "iStatus", iStatus
  'JudoTitleWriteLine "iUserName", iUserName 
  'JudoTitleWriteLine "iPhone", iPhone
  'JudoTitleWriteLine "iBirthday ", iBirthday 
  'JudoTitleWriteLine "iPublishingType", iPublishingType
  'JudoTitleWriteLine "iLevelType", iLevelType
  'JudoTitleWriteLine "iSubmittingOrg", iSubmittingOrg
  'JudoTitleWriteLine "iReceiveType", iReceiveType
  'JudoTitleWriteLine "iFax", iFax
  'JudoTitleWriteLine "iReceipt_VisitDate", iReceipt_VisitDate
  'JudoTitleWriteLine "iPayment", iPayment
  'JudoTitleWriteLine "iPostCode", iPostCode
  'JudoTitleWriteLine "iAddress", iAddress
  'JudoTitleWriteLine "iAddressDetail", iAddressDetail
  'JudoTitleWriteLine "iCertificateName", iCertificateName
  'JudoTitleWriteLine "NowPage", NowPage
  
  IF Len(iFileName) = 0 Then
    iFileName  = iLink
  END IF

  'JudoTitleWriteLine "iFileNameLength equals 0", Len(iFileName) = 0
  'JudoTitleWriteLine "iFileName", iFileName
  'JudoTitleWriteLine "iLink", iLink
  'response.End  
  iLink = iFileName
  JudoTitleWriteLine "iLink", iLink
  LCnt = 0
  LSQL = "EXEC Admin_OnlineService_Board_Mod_STR '" & MSeq & "','" & iType & "','" & iDivision & "','" & iPayment & "','" & iUserName & "','" & iPhone & "','" & iPostCode & "','" & iAddress & "','" & iAddressDetail & "','" & iPublishingType & "','" & iLevelType& "','" & iReceiveType & "','" & iReceipt_VisitDate & "','" & iCertificateName & "','" & iFax & "','" & iLink & "','" & iBirthDay & "','" & iSubmittingOrg & "','" & iStatus & "','" & iLoginID & "'"  
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = DBCon4.Execute(LSQL)
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
            LCnt = LCnt + 1
            iMSeq = LRs("MSeq")
          LRs.MoveNext
      Loop
      LRs.close
    End If

    LSQL = "EXEC OnlineService_Board_Preview_Pds_Mod_STR '2 ','" & iMSeq & "','" & iFileName & "','" & iLoginID & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
            LCnt1 = LCnt1 + 1
          LRs.MoveNext
      Loop
      LRs.close
    End If

    IF iType = 1 THEN
      response.Write "<script type='text/javascript'>alert('신청완료됐습니다.');location.href='./License_List.asp';</script>" 
      JudoKorea_DBClose()
      response.End
    END IF

    IF iType = 2 THEN
      response.Write "<script type='text/javascript'>alert('수정완료됐습니다.');location.href='./License_List.asp';</script>" 
      JudoKorea_DBClose()
      response.End
    END IF

%>

