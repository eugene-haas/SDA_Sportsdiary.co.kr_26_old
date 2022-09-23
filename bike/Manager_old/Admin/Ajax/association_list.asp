<!--#include file="../dev/dist/config.asp"-->
<%
  '====================================================================================
  '협회목록 조회
  '====================================================================================
  Check_AdminLogin()    
  
  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 20  '페이지내 보여지는 목록카운트  
  dim cnt       : cnt         = 0   '카운트  
      
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))
    dim fnd_ViewYN    : fnd_ViewYN    = fInject(Request("fnd_ViewYN"))
    
    dim valType
  dim CSQL, CRs
  dim TotalCount, TotalPage
  dim CSearch, CSearch2
    dim FndData, CStrPG, CStrTP 
   
    IF Len(currPage) = 0 Then currPage = 1
    
    '키워드 검색 [협회명, 협회명 영문, 협회명줄임, 전화번호, 팩스, 주소]
  dim search(5)

  search(0) = "AssoNm"
  search(1) = "AssoNmShort"
  search(2) = "AssoEnNm" 
  search(3) = "Phone" 
  search(4) = "Fax" 
  search(5) = "Address" 
  
  IF fnd_KeyWord <> "" OR fnd_AssoCode <> "" OR fnd_Successive <> "" Then valType = "FND"
  
  IF fnd_KeyWord <> "" Then
    For i = 0 To 5
      CSearch = CSearch & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
    Next
  
    CSearch = " AND ("&mid(CSearch, 5)&")"
  End IF
                                      
  IF fnd_ViewYN <> "" Then
    CSearch2 = CSearch2 & " AND ViewYN = '"&fnd_ViewYN&"'"
  End IF
                                      
  CSQL = "    SELECT ISNULL(COUNT(*),0) Cnt "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblAssociationInfo]"
  CSQL = CSQL & " WHERE DelYN = 'N' "&CSearch&CSearch2
  
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
   
    CSQL = "SELECT TOP "&currPage * B_PSize 
  CSQL = CSQL & "   AssociationIDX"
  CSQL = CSQL & "   ,AssoCode"
  CSQL = CSQL & "   ,AssoNmShort"
  CSQL = CSQL & "   ,AssoNm"
  CSQL = CSQL & "   ,AssoEnNm"
  CSQL = CSQL & "   ,Phone"
  CSQL = CSQL & "   ,Fax"
  CSQL = CSQL & "   ,Address"
  CSQL = CSQL & "   ,AddressDtl"
  CSQL = CSQL & "   ,Orderby"
    CSQL = CSQL & "   ,ViewYN"   
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblAssociationInfo]"
  CSQL = CSQL & " WHERE DelYN = 'N' "&CSearch&CSearch2
  CSQL = CSQL & " ORDER BY Orderby, AssoNm"
        
' response.Write CSQL
        
  SET CRs = DBCon.Execute(CSQL)
  
  FndData = "      <table class='table-list'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>협회코드</th>"
  FndData = FndData & "     <th>협회명</th>"
  FndData = FndData & "     <th>협회명 줄임</th>"
  FndData = FndData & "     <th>협회 영문명</th>"
  FndData = FndData & "     <th>전화번호</th>"
  FndData = FndData & "     <th>팩스</th>"
  FndData = FndData & "     <th>주소</th>"
  FndData = FndData & "     <th>노출구분</th>"
    FndData = FndData & "     <th>정렬</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
  
  IF Not(CRs.Eof Or CRs.Bof) Then 

    CRs.Move (currPage - 1) * B_PSize
    
    Do Until CRs.eof

      cnt = cnt + 1
      
      FndData = FndData & "<tr onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("AssociationIDX"))&"');"">"
      FndData = FndData & " <td>"&cnt&"</td>"
      FndData = FndData & " <td>"&CRs("AssoCode")&"</td>" 
      FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("AssoNm"))&"</td>"
      FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("AssoNmShort"))&"</td>"
      FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("AssoEnNm"))&"</td>"
      FndData = FndData & " <td>"&CRs("Phone")&"</td>"
      FndData = FndData & " <td>"&CRs("Fax")&"</td>"
      FndData = FndData & " <td class='name'>"&ReHtmlSpecialChars(CRs("Address"))&" "&ReHtmlSpecialChars(CRs("AddressDtl"))&"</td>"
      FndData = FndData & " <td>"&CRs("ViewYN")&"</td>"
        FndData = FndData & " <td>"&CRs("Orderby")&"</td>"
      FndData = FndData & "</tr>"

      CRs.movenext
    Loop  
  ELSE
    FndData = FndData & "<tr class='no-data'><td colspan=10>등록된 정보가 없습니다.</td></tr>"
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
    CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp - BlockPage&"');"" class='prev'></a></li> "
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
    CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"" class='next'></a></li>"
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