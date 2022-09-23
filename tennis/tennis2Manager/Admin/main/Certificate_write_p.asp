<!--#include file="../dev/dist/config.asp"-->

<%
  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
%>


<%
  On Error Resume Next
  Dim constVisit : constVisit ="visit"
  Dim constPost : constPost ="post"

  Dim IsLoginType, UserId
  iMSeq = fInject(Request("iMSeq"))
  MSeq = decode(iMSeq,0)
  iType = fInject(Request("iType"))

  IF iType = 0 THEN iType = 1
  iDivision = 1

  iStatus = fInject(Request("selectStatusOption"))            ' 진행상태
  iPayment = fInject(Request("span_Price"))            ' 구독료
  iPhone = fInject(Request("iPhone"))                ' 연락처
  iUserName = fInject(Request("iName"))           ' 우편번호
  iPostCode = fInject(Request("postcode"))           ' 우편번호
  iAddress = fInject(Request("UserAddr"))            ' 도로명 주소
  iAddressDetail = fInject(Request("UserAddrDtl"))   ' 세부주소
  iPublishingType = fInject(Request("selPublishingType"))   ' 세부주소
  iReceiveType = fInject(Request("iReceiveType"))   ' 세부주소
  iReceipt_VisitDate = fInject(Request("datepicker1"))   ' 방문일자
  iCertificateName = "선수증재발급" 

  if (iReceiveType = constPost) Then
    iReceiveType = "우편"
  ELSEIF (iReceiveType = constVisit) Then
    iReceiveType = "방문"
  ELSE 
    'response.Write "<script type='text/javascript'>alert('구독신청 시 오류가 발생했습니다.');history.back();</script>"
    'response.End
  END IF
  
  'JudoWriteLine "Cookie 값"
  'JudoTitleWriteLine "iType", iType
  'JudoTitleWriteLine "MSeq", MSeq
  'JudoTitleWriteLine "iStatus", iStatus
  'JudoTitleWriteLine "iPayment", iPayment
  'JudoTitleWriteLine "iPhone", iPhone
  'JudoTitleWriteLine "iPostCode", iPostCode
  'JudoTitleWriteLine "iAddress", iAddress
  'JudoTitleWriteLine "iAddressDetail", iAddressDetail
  'JudoTitleWriteLine "iPublishingType", iPublishingType
  'JudoTitleWriteLine "iReceiveType", iReceiveType
  'JudoTitleWriteLine "iReceipt_VisitDate", iReceipt_VisitDate
  'JudoTitleWriteLine "iCertificateName", iCertificateName
  'JudoTitleWriteLine "NowPage", NowPage
  

  LCnt = 0
  LSQL = "EXEC Admin_OnlineService_Board_Mod_STR '" & MSeq & "','" & iType & "','" & iDivision & "','" & iPayment & "','" & iUserName & "','" & iPhone & "','" & iPostCode & "','" & iAddress & "','" & iAddressDetail & "','" & iPublishingType & "','" & iLevelType& "','" & iReceiveType & "','" & iReceipt_VisitDate & "','" & iCertificateName & "','" & iFax & "','" & iLink & "','" & iBirthDay & "','" & iSubmittingOrg & "','" & iStatus & "','" & iLoginID & "'"  
  Set LRs = DBCon4.Execute(LSQL)
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  IF Err.Number <> 0 then
   response.Write "<script type='text/javascript'>alert('오류가 발생했습니다.');history.back();</script>"
   response.End
  ELSE
    If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
          LCnt = LCnt + 1
          iMSeq = LRs("MSeq")
        LRs.MoveNext
    Loop
    End If

    IF iType = 1 THEN
      response.Write "<script type='text/javascript'>alert('신청완료됐습니다.');location.href='./Certificate_list.asp';</script>" 
      'response.Write("<script type='text/javascript'>")
      'response.Write("alert('구독신청이 완료되었습니다.');")
      ''response.Write("location.href='./list.asp?i4=" & iUserName & "&i5=" & iPhone & "&i6=" & iPassword & "';")
      'response.Write("location.href='./list.asp")
      'response.Write("</script>")
      'response.End
    END IF

    IF iType = 2 THEN
      response.Write "<script type='text/javascript'>alert('수정완료됐습니다.');location.href='./Certificate_list.asp';</script>" 
      response.End
    END IF

  End IF 
   
  JudoKorea_DBClose()
%>

