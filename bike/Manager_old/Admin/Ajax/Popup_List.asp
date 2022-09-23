<!--#include file="../dev/dist/config.asp"-->
<%
  '====================================================================================
  '팝업리스트 조회
  '====================================================================================
  Check_AdminLogin()
    
  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 10  '페이지내 보여지는 목록카운트  
  dim cnt       : cnt         = 0   '카운트  
      
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))
  dim fnd_PUseYN    : fnd_PUseYN    = fInject(Request("fnd_PUseYN"))
  dim fnd_PViewYN   : fnd_PViewYN     = fInject(Request("fnd_PViewYN")) 
  
' dim SDate     : SDate       = fInject(Request("SDate"))
' dim EDate     : EDate       = fInject(Request("EDate"))
  
  dim valType
  dim TotCount, TotPage
  dim CSearch, CSearch2, CSearch3, CSearch4
  dim FndData, CStrPG, CStrTP
  
  
  dim CSQL, CRs

  IF Len(currPage) = 0 Then currPage = 1
  
' '기간선택
' IF SDate <> "" AND EDate <> "" Then
'   CSearch = " AND DateDiff(d, '"&EDate&"', EDate)>=0 AND DateDiff(d, SDate, '"&SDate&"')>=0 "
' ElseIF SDate <> "" AND EDate = "" Then
''    CSearch = " AND DateDiff(d, SDate, '"&SDate&"')=0 "
'   CSearch = " AND DateDiff(d, '"&SDate&"', EDate)>=0 AND DateDiff(d, SDate, '"&SDate&"')>=0 "   
' ElseIF SDate = "" AND EDate <> "" Then
''    CSearch = " AND DateDiff(d, '"&EDate&"', EDate)=0 "
'   CSearch = " AND DateDiff(d, SDate,'"&EDate&"')>=0 AND DateDiff(d, EDate, '"&EDate&"')>=0 "    
' Else
' End IF
  
  '키워드 검색 [제목, 내용]
  dim search(1)

  search(0) = "Subject"
  search(1) = "PContents"
  
' IF SDate <> "" OR EDate <> "" OR fnd_KeyWord <> "" OR fnd_PUseYN <> "" Then valType = "FND"
  IF fnd_PViewYN <> "" OR fnd_KeyWord <> "" OR fnd_PUseYN <> "" Then valType = "FND"
  
  IF fnd_KeyWord<>"" Then
    For i = 0 To 1
      CSearch2 = CSearch2 & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
    Next
  
    CSearch2 = " AND ("&mid(CSearch2, 5)&")"
  End IF
  
  IF fnd_PUseYN <> "" Then CSearch3 = " AND PUseYN = '"&fnd_PUseYN&"'"
  IF fnd_PViewYN <> "" Then 
    CSearch4 = "      AND (CASE PUseYN WHEN 'Y' THEN "
    CSearch4 = CSearch4 & "     CASE WHEN DateDiff(d, SDate, '"&date()&"')>=0 AND DateDiff(d, '"&date()&"', EDate)>=0 THEN 'Y' "
    CSearch4 = CSearch4 & "     ELSE 'N' "
    CSearch4 = CSearch4 & "     END "
    CSearch4 = CSearch4 & "   ELSE 'N' "
    CSearch4 = CSearch4 & "   END) = '"&fnd_PViewYN&"'"
    
  End IF
  
  CSQL = "    SELECT ISNULL(COUNT(*),0) Cnt "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblPopupManage]" 
  CSQL = CSQL & " WHERE DelYN = 'N' " &CSearch&CSearch2&CSearch3&CSearch4
  
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
  CSQL = CSQL & "   PopIDX"
  CSQL = CSQL & "   ,Subject"
  CSQL = CSQL & "   ,PWidth"
  CSQL = CSQL & "   ,PHeight"
  CSQL = CSQL & "   ,PLeft"
  CSQL = CSQL & "   ,PTop"
  CSQL = CSQL & "   ,PZindex"
  CSQL = CSQL & "   ,PUseYN"
  CSQL = CSQL & "   ,PDailyUseYN"
  CSQL = CSQL & "   ,SDate"
  CSQL = CSQL & "   ,EDate"
  CSQL = CSQL & "   ,InsDate"
  CSQL = CSQL & "   ,ModDate"
  CSQL = CSQL & "   ,CASE PUseYN WHEN 'Y' THEN "
  CSQL = CSQL & "     CASE WHEN DateDiff(d, SDate, '"&date()&"')>=0 AND DateDiff(d, '"&date()&"', EDate)>=0 THEN 'ON' "
  CSQL = CSQL & "     ELSE 'Off' "
  CSQL = CSQL & "     END "
  CSQL = CSQL & "   ELSE 'Off' "
  CSQL = CSQL & "   END CHK_AirON"
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblPopupManage]"
  CSQL = CSQL & " WHERE DelYN = 'N' "&CSearch&CSearch2&CSearch3&CSearch4
  CSQL = CSQL & " ORDER BY InsDate DESC"
        
' response.Write CSQL
        
  SET CRs = DBCon.Execute(CSQL)
  
  FndData = "      <table class='table-list popup-table'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>출력구분</th>"
  FndData = FndData & "     <th>제목</th>"
  FndData = FndData & "     <th>사이즈</th>"
  FndData = FndData & "     <th>위치</th>"
  FndData = FndData & "     <th>정렬(z-index)</th>"
  FndData = FndData & "     <th>사용구분</th>"
  FndData = FndData & "     <th>노출기간</th>"
  FndData = FndData & "     <th>미리보기</th>"
  FndData = FndData & "     <th>등록일</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
  
  IF Not(CRs.Eof Or CRs.Bof) Then 

    CRs.Move (currPage - 1) * B_PSize
    
    Do Until CRs.eof

      cnt = cnt + 1
      
      FndData = FndData & "<tr>"
      FndData = FndData & " <td class='short'>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
      FndData = FndData & " <td>"&CRs("CHK_AirON")&"</td>"  
      FndData = FndData & " <td class=""name"" onClick=""chk_Submit('VIEW','"&CRs("PopIDX")&"','"&currPage&"');"">"&CRs("Subject")&"</td>"
      FndData = FndData & " <td>"&CRs("PWidth")&"(W), "&CRs("PHeight")&"(H)</td>"
      FndData = FndData & " <td>"&CRs("PLeft")&"(L), "&CRs("PTop")&"(T)</td>"
      FndData = FndData & " <td class='short'>"&CRs("PZindex")&"</td>"
      FndData = FndData & " <td class='short'>"&CRs("PUseYN")&"</td>"
      FndData = FndData & " <td>"&CRs("SDate")&" ~ "&CRs("EDate")&"</td>"
      FndData = FndData & " <td class='short'><a href=""./Popup_Preview.asp?CIDX="&CRs("PopIDX")&""" target=""_blank"">보기</a></td>"
      FndData = FndData & " <td>"&CRs("InsDate")&"</td>"
      FndData = FndData & "</tr>"
      
      RoleNm = ""

      CRs.movenext
    Loop  
  ELSE
    FndData = FndData & "<tr><td colspan=10>일치하는 정보가 없습니다.</td></tr>"
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
  response.Write FndData  '목록 테이블
    
  IF TotalCount > 0 Then response.Write CStrPG  '페이징
  '==================================================================================================================================
  
  
  DBClose()
  
%>