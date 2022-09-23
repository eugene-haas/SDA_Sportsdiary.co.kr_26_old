<!--#include file="../dev/dist/config.asp"-->

<%
  On Error Resume Next

  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  'JudoTitleWriteLine "iLoginID", iLoginID
%>

<%
  iTP_Tyep = "T00002"
  NowPage = fInject(Request("iNowPage")) 
  iTeamName = fInject(Request("iTeamName")) 
  iName = fInject(Request("iName"))     
  iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)
  iType= fInject(Request("iType"))           ' 수정시 글번호
  iselectOptionWeight= fInject(Request("selectOptionWeight"))           ' 수정시 글번호
  iselectLocal = fInject(Request("selectLocal"))           ' 수정시 글번호
  iselectDivision = fInject(Request("selectDivision"))           ' 수정시 글번호
  IselectTypeOption = fInject(Request("selectOptionSex"))           ' 수정시 글번호
  iselectYear = fInject(Request("selectYear"))           ' 수정시 글번호

  'JudoTitleWriteLine "iTP_Tyep",iTP_Tyep
  'JudoTitleWriteLine "iTeamName",iTeamName
  'JudoTitleWriteLine "iName",iName
  'JudoTitleWriteLine "MSeq",MSeq
  'JudoTitleWriteLine "iType",iType
  'JudoTitleWriteLine "iselectOptionWeight",iselectOptionWeight
  'JudoTitleWriteLine "iselectLocal",iselectLocal
  'JudoTitleWriteLine "iselectDivision",iselectDivision
  'JudoTitleWriteLine "IselectTypeOption",IselectTypeOption
  'JudoTitleWriteLine "iselectYear",iselectYear

  LSQL = "EXEC TeamPlayer_Board_Mod_STR '" & iType & "','" & iTP_Tyep & "','" & iTeamName & "','" & iSchool &  "','" & MSeq & "','" & iPhone & "','" & iUserAddr & "','" & iUserAddrDtl & "','" & iPostCode & "','" & iLeaderName & "','" & iCoachName & "','"  & iselectLocal & "','"  & iselectDivision & "','"  & IselectTypeOption  & "','" & iselectPositionOption & "','"  & iselectYear & "','"  & iName  & "','" & iselectOptionWeight & "','" & iLicenseNum & "','" & iselectLicenseDate  & "','" & iLoginID & "'"
  'LSQL = "EXEC TeamPlayer_Board_Mod_STR '" & iType & "','" & iTP_Tyep & "','" & iTeamName & "','" & iSchool &  "','" & MSeq & "','" & iPhone & "','" & iUserAddr & "','" & iLeaderName & "','" & iCoachName & "','"  & iselectLocal & "','"  & iselectDivision & "','"  & IselectTypeOption  & "','" & iselectPositionOption & "','"  & iselectYear & "','"  & iName  & "','" & iselectOptionWeight & "','"  & iLoginID & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  ''response.End
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
     response.Write "<script type='text/javascript'>alert('등록이 완료되었습니다.');location.href='./Player_PlayerRegist.asp';</script>" 
     'response.Write("<script type='text/javascript'>")
     'response.Write("alert('구독신청이 완료되었습니다.');")
     ''response.Write("location.href='./list.asp?i4=" & iUserName & "&i5=" & iPhone & "&i6=" & iPassword & "';")
     'response.Write("location.href='./list.asp")
     'response.Write("</script>")
     'response.End
   END IF
   IF iType = 2 THEN
     response.Write "<script type='text/javascript'>alert('변경이 완료되었습니다.');location.href='./Player_PlayerRegist.asp';</script>" 
     response.End
   END IF
 End IF
 JudoKorea_DBClose()

%>