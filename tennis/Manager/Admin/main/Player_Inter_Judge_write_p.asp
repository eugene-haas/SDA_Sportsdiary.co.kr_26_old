<!--#include file="../dev/dist/config.asp"-->

<%
  On Error Resume Next

  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  'JudoTitleWriteLine "iLoginID", iLoginID
%>

<%
  iTP_Type = "T00007"
  NowPage = fInject(Request("iNowPage")) 
  iMSeq = fInject(Request("iMSeq"))
  MSeq = decode(iMSeq,0)
  iType= fInject(Request("iType"))
  iName = fInject(Request("iName"))
  iselectLocal = fInject(Request("selectLocal"))
  iselectTypeOption = fInject(Request("selectTypeOption"))
  iLicenseNum = fInject(Request("iLicenseNum"))
  selectLicenseDate = fInject(Request("selectLicenseDate"))

  'JudoTitleWriteLine "iTP_Type",iTP_Type
  'JudoTitleWriteLine "iName",iName
  'JudoTitleWriteLine "MSeq",MSeq
  'JudoTitleWriteLine "iType",iType
  'JudoTitleWriteLine "iselectLocal",iselectLocal
  'JudoTitleWriteLine "iselectTypeOption",iselectTypeOption
  'JudoTitleWriteLine "iLicenseNum",iLicenseNum
  'JudoTitleWriteLine "iselectLicenseDate",iselectLicenseDate
  
  selectLicenseDate = split(selectLicenseDate, "-")

  if(Ubound(selectLicenseDate) = 2) Then
    iselectLicenseDate = selectLicenseDate(0) & "." & selectLicenseDate(1) & "." & selectLicenseDate(2)
  ELSE
    response.Write "<script type='text/javascript'>alert('오류가 발생했습니다.');history.back();</script>"
    response.End
  End If

  'JudoTitleWriteLine "iselectLicenseDate",iselectLicenseDate

  LSQL = "EXEC TeamPlayer_Board_Mod_STR '" & iType & "','" & iTP_Type & "','" & iTeamName & "','" & iSchool &  "','" & MSeq & "','" & iPhone & "','" & iUserAddr & "','" & iUserAddrDtl & "','" & iPostCode & "','" & iLeaderName & "','" & iCoachName & "','"  & iselectLocal & "','"  & iselectDivision & "','"  & IselectTypeOption  & "','" & iselectPositionOption & "','"  & iselectYear & "','"  & iName  & "','" & iselectOptionWeight & "','" & iLicenseNum & "','" & iselectLicenseDate  & "','" & iLoginID & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = DBCon4.Execute(LSQL)
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
     response.Write "<script type='text/javascript'>alert('등록이 완료되었습니다.');location.href='./Player_Inter_Judge.asp';</script>" 
     'response.Write("<script type='text/javascript'>")
     'response.Write("alert('구독신청이 완료되었습니다.');")
     ''response.Write("location.href='./list.asp?i4=" & iUserName & "&i5=" & iPhone & "&i6=" & iPassword & "';")
     'response.Write("location.href='./list.asp")
     'response.Write("</script>")
     'response.End
   END IF
   IF iType = 2 THEN
     response.Write "<script type='text/javascript'>alert('변경이 완료되었습니다.');location.href='./Player_Inter_Judge.asp';</script>" 
     response.End
   END IF
 End IF
 JudoKorea_DBClose()

%>