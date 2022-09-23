<!--#include file="../dev/dist/config.asp"-->

<%
  On Error Resume Next

  iLoginID = fInject(decode(fInject(Request.Cookies("UserID")), 0))
  'JudoTitleWriteLine "iLoginID", iLoginID
%>

<%
  iTP_Type = "T00001"
  NowPage = fInject(Request("iNowPage")) 
  iTeamName = fInject(Request("iTeamName"))     
  iMSeq = fInject(Request("iMSeq"))           ' 수정시 글번호
  MSeq = decode(iMSeq,0)
  iPhone= fInject(Request("iPhone"))           ' 수정시 글번호
  iType= fInject(Request("iType"))           ' 수정시 글번호
  iUserAddr= fInject(Request("UserAddr"))           ' 수정시 글번호
  iUserAddrDtl= fInject(Request("UserAddrDtl"))           ' 수정시 글번호
  iPostCode= fInject(Request("PostCode"))           ' 수정시 글번호
  
  iLeaderName= fInject(Request("iLeaderName"))           ' 수정시 글번호
  iCoachName= fInject(Request("iCoachName"))           ' 수정시 글번호
  iselectLocal = fInject(Request("selectLocal"))           ' 수정시 글번호
  iselectDivision = fInject(Request("selectDivision"))           ' 수정시 글번호
  IselectTypeOption = fInject(Request("selectOptionSex"))           ' 수정시 글번호
  iselectYear = fInject(Request("selectYear"))           ' 수정시 글번호

  'JudoTitleWriteLine "iTP_Type",iTP_Type
  'JudoTitleWriteLine "iTeamName",iTeamName
  'JudoTitleWriteLine "MSeq",MSeq
  'JudoTitleWriteLine "iPhone1",iPhone1
  'JudoTitleWriteLine "iPhone2",iPhone2
  'JudoTitleWriteLine "iType",iType
  'JudoTitleWriteLine "iUserAddr",iUserAddr
  'JudoTitleWriteLine "iLeader",iLeader
  'JudoTitleWriteLine "iCoachName",iCoachName
  'JudoTitleWriteLine "iselectLocal",iselectLocal
  'JudoTitleWriteLine "iselectDivision",iselectDivision
  'JudoTitleWriteLine "IselectTypeOption",IselectTypeOption
  'JudoTitleWriteLine "iselectYear",iselectYear

  LSQL = "EXEC TeamPlayer_Board_Mod_STR '" & iType & "','" & iTP_Type & "','" & iTeamName & "','" & iSchool &  "','" & MSeq & "','" & iPhone & "','" & iUserAddr & "','" & iUserAddrDtl & "','" & iPostCode & "','" & iLeaderName & "','" & iCoachName & "','"  & iselectLocal & "','"  & iselectDivision & "','"  & IselectTypeOption  & "','" & iselectPositionOption & "','"  & iselectYear & "','"  & iName  & "','" & iselectOptionWeight & "','" & iLicenseNum & "','" & iselectLicenseDate  & "','" & iLoginID & "'"
  'LSQL = "EXEC TeamPlayer_Board_Mod_STR '" & iType & "','" & iTP_Type & "','" & iTeamName & "','" & iSchool & "','" & MSeq & "','" & iPhone & "','" & iUserAddr & "','" & iLeaderName & "','" & iCoachName & "','"  & iselectLocal & "','"  & iselectDivision & "','"  & IselectTypeOption & "','" & iselectPositionOption & "','"  & iselectYear & "','"  & iName  & "','" & iselectOptionWeight & "','"  & iLoginID & "'"
  
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
 Set LRs = DBCon4.Execute(LSQL)
 IF Err.Number <> 0 then
  response.Write "<script type='text/javascript'>alert('구독신청 시 오류가 발생했습니다.');history.back();</script>"
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
     response.Write "<script type='text/javascript'>alert('등록이 완료되었습니다.');location.href='./Player_team_info.asp';</script>" 
     'response.Write("<script type='text/javascript'>")
     'response.Write("alert('구독신청이 완료되었습니다.');")
     ''response.Write("location.href='./list.asp?i4=" & iUserName & "&i5=" & iPhone & "&i6=" & iPassword & "';")
     'response.Write("location.href='./list.asp")
     'response.Write("</script>")
     'response.End
   END IF
   IF iType = 2 THEN
     response.Write "<script type='text/javascript'>alert('변경이 완료되었습니다.');location.href='./Player_team_info.asp';</script>" 
     response.End
   END IF
 End IF
 JudoKorea_DBClose()

%>