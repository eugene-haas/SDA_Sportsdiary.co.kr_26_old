<!--#include file="../dev/dist/config.asp"-->
<%
  '====================================================================================
  '리스트 조회
  '====================================================================================
  Check_AdminLogin()
    
  dim BlockPage     : BlockPage     = global_BlockPage  '페이지
  dim B_PSize       : B_PSize       = global_PagePerData   '페이지내 보여지는 목록카운트  
  dim cnt       : cnt         = 0   '카운트  
      
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))
  dim fnd_UseYN   : fnd_UseYN     = fInject(Request("fnd_UseYN"))
    dim fnd_SponType  : fnd_SponType    = fInject(Request("fnd_SponType"))

  
  dim valType
  dim TotCount, TotPage
  dim CSearch, CSearch2, CSearch3
  dim FndData, CStrPG, CStrTP
  
  
  dim CSQL, CRs

  IF Len(currPage) = 0 Then currPage = 1
  IF fnd_KeyWord <> "" OR fnd_UseYN <> "" OR fnd_SponType <> "" Then valType = "FND"
  
  IF fnd_KeyWord<>"" Then
    CSearch = " AND Subject like '%"&fnd_KeyWord&"%'"
  End IF
  
  IF fnd_UseYN <> "" Then CSearch2 = " AND SponUseYN = '"&fnd_UseYN&"'"
  IF fnd_SponType <> "" Then CSearch3 = " AND SponType = '"&fnd_SponType&"'"
  
  
  CSQL = "    SELECT ISNULL(COUNT(*),0) Cnt "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblSponsorManage] " 
  CSQL = CSQL & " WHERE DelYN = 'N' " &CSearch&CSearch2&CSearch3
  
' response.Write CSQL
  
  SET CRs = DBCon.Execute(CSQL) 
  
  TotalCount = formatnumber(CRs(0),0)
  TotalPage = CRs(1)
  
  '==================================================================================================================================
  '카운트/페이지
  '==================================================================================================================================
  CStrTP = "<div class=""total_count""><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
  CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
  CStrTP = CStrTP & "</span></div>"
  '==================================================================================================================================
  '회원리스트 조회
  '==================================================================================================================================
  CSQL = "    SELECT TOP "&currPage * B_PSize 
  CSQL = CSQL & "   SponsorIDX"
  CSQL = CSQL & "   ,Subject"
  CSQL = CSQL & "   ,SponLink"
  CSQL = CSQL & "   ,SponUseYN"
  CSQL = CSQL & "   ,SponSort"
  CSQL = CSQL & "   ,SponImage"
  CSQL = CSQL & "   ,InsDate"
  CSQL = CSQL & "   ,ModDate"
  CSQL = CSQL & "   ,P.PubCode"
  CSQL = CSQL & "   ,P.PubName"
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblSponsorManage] A "
  CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblPubcode] P on A.SponType = P.PubCode"
  CSQL = CSQL & "     AND P.DelYN = 'N'"
  CSQL = CSQL & " WHERE A.DelYN = 'N' "&CSearch&CSearch2&CSearch3
  CSQL = CSQL & " ORDER BY A.SponSort DESC, A.InsDate DESC"
        
  'response.Write CSQL
        
  SET CRs = DBCon.Execute(CSQL)
  
  FndData = "      <table class='table-list'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>후원사 구분</th>"  
  FndData = FndData & "     <th>제목</th>"
  FndData = FndData & "     <th>이미지</th>"
  FndData = FndData & "     <th>정렬</th>"
  FndData = FndData & "     <th>노출여부</th>"
  FndData = FndData & "     <th>등록일</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
  
  IF Not(CRs.Eof Or CRs.Bof) Then 

    CRs.Move (currPage - 1) * B_PSize
    
    Do Until CRs.eof

      cnt = cnt + 1
      
      FndData = FndData & "<tr>"
      FndData = FndData & " <td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
      FndData = FndData & " <td onClick=""chk_Submit('VIEW','"&CRs("SponsorIDX")&"','"&currPage&"');"">"&CRs("PubName")&"</td>"
      FndData = FndData & " <td class=""name"" onClick=""chk_Submit('VIEW','"&CRs("SponsorIDX")&"','"&currPage&"');"">"&CRs("Subject")&"</td>"
      FndData = FndData & " <td><a href='"&CRs("SponLink")&"' target=""_blank""><img src=""/FileTemp/"&CRs("SponImage")&""" ></a></td>"
      FndData = FndData & " <td>"&CRs("SponSort")&"</td>"
      FndData = FndData & " <td>"&CRs("SponUseYN")&"</td>"
      FndData = FndData & " <td>"&CRs("InsDate")&"</td>"
      FndData = FndData & "</tr>"
      
      RoleNm = ""

      CRs.movenext
    Loop  
  ELSE
    FndData = FndData & "<tr class=""no-data""><td colspan=10>일치하는 정보가 없습니다.</td></tr>"
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
    CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp - BlockPage&"');"" class='fa fa-angle-left'></a></li> "
  End If  
  
  dim intLoop : intLoop = 1
  
  Do Until intLoop > BlockPage Or intTemp > TotalPage
  
    If CInt(intTemp) = CInt(currPage) Then
      CStrPG = CStrPG & "<li class='active'><a href='#' >"&intTemp&"</a> </li>" 
    Else
      CStrPG = CStrPG & "<li><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"">"&intTemp&"</a> </li>"
    End If
    
    intTemp = intTemp + 1
    intLoop = intLoop + 1
  Loop
  
  IF intTemp > TotalPage Then
    CStrPG = CStrPG & "<li class='next'><a href='javascript:;' class='fa fa-angle-right'></a></li>"
  Else
    CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"" class='fa fa-angle-right'></a></li>"
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