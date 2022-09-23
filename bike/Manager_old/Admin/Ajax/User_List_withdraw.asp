<!--#include file="../dev/dist/config.asp"-->
<%
  '====================================================================================
  '회원탈퇴신청 회원리스트 조회
  '====================================================================================
  Check_AdminLogin()
    
  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 20  '페이지내 보여지는 목록카운트  
  dim cnt       : cnt         = 0   '카운트      
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))
  dim SDate     : SDate       = fInject(Request("SDate"))
  dim EDate     : EDate       = fInject(Request("EDate"))
  

  dim TotCount, TotPage
  dim CSearch, CSearch2, CSearch3, CSearch4
  dim FndData, CStrPG, CStrTP
  
  
  dim CSQL, CRs, i
  dim strRole, RoleNm, fndStrRole '회원구분
  

  IF Len(currPage) = 0 Then currPage = 1
  
  '기간선택
  IF SDate <> "" AND EDate <> "" Then
    CSearch = " AND DateDiff(d, '"&SDate&"', WithdrawDt)>=0 AND DateDiff(d, WithdrawDt, '"&EDate&"')>=0 "
  ElseIF SDate <> "" AND EDate = "" Then
    CSearch = " AND DateDiff(d, WithdrawDt, '"&SDate&"')=0 "
  ElseIF SDate = "" AND EDate <> "" Then
    CSearch = " AND DateDiff(d, '"&EDate&"', WithdrawDt)=0 "
  Else
  End IF
  
  '키워드 검색 [소속팀명, 회원명, 생년월일, 체육인번호, 아이디, 전화번호, 이메일]
  dim search(4)

  search(0) = "UserName"
  search(1) = "Birthday"
  search(2) = "UserID"
  search(3) = "UserPhone"
  search(4) = "Email"
  
  IF fnd_KeyWord<>"" Then
    For i = 0 To 4
      CSearch2 = CSearch2 & " OR "&search(i)&" like N'%"&fnd_KeyWord&"%'"
    Next
  
    CSearch2 = " AND ("&mid(CSearch2, 5)&")"
  End IF
  
  CSQL = "    SELECT COUNT(*) "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM  [KoreaBadminton].[dbo].[tblMembershipOnline] " 
  CSQL = CSQL & " WHERE DelYN = 'N' AND WithdrawYN = 'Y' " &CSearch&CSearch2
  
' response.Write CSQL
  
  SET CRs = DBCon.Execute(CSQL) 
    TotalCount = formatnumber(CRs(0),0)
    TotalPage = CRs(1)
  
  '==================================================================================================================================
  '카운트/페이지
  '==================================================================================================================================
  CStrTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
  CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
  CStrTP = CStrTP & "</span></div>"
  '==================================================================================================================================
  '회원리스트 조회
  '==================================================================================================================================
  CSQL = "    SELECT TOP "&currPage * B_PSize 
  CSQL = CSQL & "   MembershipIDX "
  CSQL = CSQL & "   ,UserName "
  CSQL = CSQL & "   ,UserPhone "
  CSQL = CSQL & "   ,CONVERT(CHAR(10), CONVERT(DATE, UserBirth), 102) UserBirth"
  CSQL = CSQL & "   ,UserID "
  CSQL = CSQL & "   ,RegDate "
  CSQL = CSQL & "   ,WithdrawDt "
  CSQL = CSQL & "   ,CASE Role "
  CSQL = CSQL & "     WHEN 'EP' THEN '엘리트선수' "
  CSQL = CSQL & "     WHEN 'EL' THEN '엘리트지도자' "
  CSQL = CSQL & "     WHEN 'AP' THEN '생체선수' "
  CSQL = CSQL & "     WHEN 'AL' THEN '생체지도자' "
  CSQL = CSQL & "     WHEN 'J' THEN '심판' "
  CSQL = CSQL & "   ELSE '심판' "
  CSQL = CSQL & "   END RoleNm "
  CSQL = CSQL & " FROM  [KoreaBadminton].[dbo].[tblMembershipOnline] "
  CSQL = CSQL & " WHERE DelYN = 'N' "
  CSQL = CSQL & "   AND WithdrawYN = 'Y' "&CSearch&CSearch2
  CSQL = CSQL & " ORDER BY WithdrawDt DESC, UserName"
        
' response.Write CSQL
        
  SET CRs = DBCon.Execute(CSQL)
  
  FndData = "      <table class='table-list'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th><input type='checkbox' name='iallCheck' id='iallCheck' ></th>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>이름</th>"
  FndData = FndData & "     <th>아이디</th>"
  FndData = FndData & "     <th>회원구분</th>"    
  FndData = FndData & "     <th>생년월일</th>"
  FndData = FndData & "     <th>Phone</th>"
  FndData = FndData & "     <th>탈퇴신청일</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
  
  IF Not(CRs.Eof Or CRs.Bof) Then 

    CRs.Move (currPage - 1) * B_PSize
    
    Do Until CRs.eof

      cnt = cnt + 1

      FndData = FndData & "<tr>"
      FndData = FndData & " <td><input type='checkbox' name='list_CHK' id='list_CHK' value='"&CRs("UserID")&"' /></td>"
      FndData = FndData & " <td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
      FndData = FndData & " <td>"&CRs("UserName")&"</td>"
      FndData = FndData & " <td>"&CRs("UserID")&"</td>"
      FndData = FndData & " <td>"&CRs("RoleNm")&"</td>"
      FndData = FndData & " <td>"&CRs("UserBirth")&"</td>"
      FndData = FndData & " <td>"&CRs("UserPhone")&"</td>"
      FndData = FndData & " <td>"&CRs("WithdrawDt")&"</td>"
      FndData = FndData & "</tr>"
      
      RoleNm = ""

      CRs.movenext
    Loop  
  ELSE
    FndData = FndData & "<tr><td colspan=8>일치하는 정보가 없습니다.</td></tr>"
  End IF  
  
  FndData = FndData & " </tbody>"
  FndData = FndData & "</table>"
  
    CRs.Close
  SET CRs = Nothing
  
  
  '==================================================================================================================================
  '페이징
  '==================================================================================================================================
  dim intTemp

  CStrPG = CStrPG & " <div class='page_index'>"
  CStrPG = CStrPG & " <ul class='pagination'>"
  
  intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
  
  If intTemp = 1 Then
    CStrPG = CStrPG & "<li class='prev'><a href='javascript:;' class='fa fa-angle-left'></a></li>"
  Else 
    CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('"&intTemp - BlockPage&"');"" class='prev'></a></li> "
  End If  
  
  dim intLoop : intLoop = 1
  
  Do Until intLoop > BlockPage Or intTemp > TotalPage
  
    If CInt(intTemp) = CInt(currPage) Then
      CStrPG = CStrPG & "<li class='active'><a href='#' >"&intTemp&"</a> </li>" 
    Else
      CStrPG = CStrPG & "<li><a href=""javascript:chk_Submit('"&intTemp&"');"">"&intTemp&"</a> </li>"
    End If
    
    intTemp = intTemp + 1
    intLoop = intLoop + 1
  Loop
  
  IF intTemp > TotalPage Then
    CStrPG = CStrPG & "<li class='next'><a href='javascript:;' class='fa fa-angle-right'></a></li>"
  Else
    CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&intTemp&"');"" class='next'></a></li>"
  End IF  
  
    CStrPG = CStrPG & "</ul>"
    CStrPG = CStrPG & "</div>"
  '==================================================================================================================================
  
  
  '==================================================================================================================================
  '출력
  '==================================================================================================================================
  response.Write CStrTP '카운트/페이지
  response.Write FndData  '회원목록 테이블
    
  IF TotalCount > 0 Then response.Write CStrPG  '페이징
  '==================================================================================================================================
  
  
  DBClose()
  
%>