<!--#include file="../dev/dist/config.asp"-->
<%
  '====================================================================================
  '리스트 조회
  '====================================================================================
  Check_AdminLogin()
    
  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 10  '페이지내 보여지는 목록카운트  
  dim cnt       : cnt         = 0   '카운트  
      
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))
  dim fnd_AssoCode  : fnd_AssoCode    = fInject(Request("fnd_AssoCode"))
  dim fnd_Successive  : fnd_Successive  = fInject(Request("fnd_Successive"))  
  dim fnd_ViewYN    : fnd_ViewYN    = fInject(Request("fnd_ViewYN"))
   
  dim valType
  dim TotCount, TotPage
  dim CSearch, CSearch2, CSearch3, CSearch4
  dim FndData, CStrPG, CStrTP 
  
  dim CSQL, CRs

  IF Len(currPage) = 0 Then currPage = 1
  
  
  '키워드 검색 [임원이름, 재직기업명, 직책]
  dim search(2)

  search(0) = "A.UserName"
  search(1) = "A.UserCompanyNm"
  search(2) = "A.UserCompanyLevel" 
  
  IF fnd_KeyWord <> "" OR fnd_AssoCode <> "" OR fnd_Successive <> "" Then valType = "FND"
  
  IF fnd_KeyWord<>"" Then
    For i = 0 To 1
      CSearch = CSearch & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
    Next
  
    CSearch = " AND ("&mid(CSearch, 5)&")"
  End IF
  
  IF fnd_AssoCode <> "" Then CSearch2 = " AND A.AssoCode = '"&fnd_AssoCode&"'"  '협회
  IF fnd_Successive <> "" Then CSearch3 = " AND A.CateSuccessiveIDX = '"&fnd_Successive&"'" '역대타이틀 
  IF fnd_ViewYN <> "" Then CSearch4 = " AND A.ViewYN = '"&fnd_ViewYN&"'"

  CSQL = "    SELECT ISNULL(COUNT(*),0) Cnt "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblAssoOfficers] A "
  CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblAssociationInfo] B on A.AssoCode = B.AssoCode AND B.DelYN = 'N' "
  CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblCateSuccessive] C on A.CateSuccessiveIDX = C.CateSuccessiveIDX AND C.DelYN = 'N' "
  CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblCateOfficers] D on A.CateOfficersIDX = D.CateOfficersIDX AND D.DelYN = 'N' "
  CSQL = CSQL & " WHERE A.DelYN = 'N' "&CSearch&CSearch2&CSearch3&CSearch4
  
' response.Write CSQL
  
  SET CRs = DBCon.Execute(CSQL) 
    TotalCount = formatnumber(CRs(0),0)
    TotalPage = CRs(1)
  
  '==================================================================================================================================
  '카운트/페이지
  '==================================================================================================================================
  CStrTP = "<div><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
  CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
  CStrTP = CStrTP & "</span></div>"
  '==================================================================================================================================
  '회원리스트 조회
  '==================================================================================================================================
  
  CSQL = "    SELECT TOP "&currPage * B_PSize 
  CSQL = CSQL & "   B.AssoNm "
  CSQL = CSQL & "   ,C.SuccessiveNm "
  CSQL = CSQL & "   ,C.DatePeriod "
  CSQL = CSQL & "   ,D.OfficerNm "
  CSQL = CSQL & "   ,A.* "
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblAssoOfficers] A "
  CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblAssociationInfo] B on A.AssoCode = B.AssoCode AND B.DelYN = 'N' "
  CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblCateSuccessive] C on A.CateSuccessiveIDX = C.CateSuccessiveIDX AND C.DelYN = 'N' "
  CSQL = CSQL & "   left join [KoreaBadminton].[dbo].[tblCateOfficers] D on A.CateOfficersIDX = D.CateOfficersIDX AND D.DelYN = 'N' "
  CSQL = CSQL & " WHERE A.DelYN = 'N' "&CSearch&CSearch2&CSearch3&CSearch4
  CSQL = CSQL & " ORDER BY A.AssoCode, B.Orderby, D.Orderby, A.UserBirth "

' response.Write CSQL
        
  SET CRs = DBCon.Execute(CSQL)
  
  FndData = "      <table class='table-list asso-member'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>이미지</th>"
  FndData = FndData & "     <th>협회</th>"
  FndData = FndData & "     <th>역대(기간)</th>"
  FndData = FndData & "     <th>임원직책</th>"
  FndData = FndData & "     <th>이름</th>"
  FndData = FndData & "     <th>생년월일</th>"		  
  FndData = FndData & "     <th>노출구분</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
  
  IF Not(CRs.Eof Or CRs.Bof) Then 

    CRs.Move (currPage - 1) * B_PSize
    
    Do Until CRs.eof

      cnt = cnt + 1
      
      FndData = FndData & "<tr onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("AssoOfficersIDX"))&"','"&currPage&"');"">"
    
      FndData = FndData & " <td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
      
      IF CRs("ImgProfile") <> "" Then
        FndData = FndData & " <td><img src='/FileTemp/"&CRs("ImgProfile")&"' width='90'></td>"
      Else
        FndData = FndData & " <td><img src='"&ImgDefault&"' width='90'></td>"
      End IF
    
      FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("AssoNm"))&"</td>"
      FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("SuccessiveNm"))&" ("&ReHtmlSpecialChars(CRs("DatePeriod"))&")</td>"
      FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("OfficerNm"))&"</td>"
      FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("UserName"))&" ("&ReHtmlSpecialChars(CRs("UserCompanyNm"))	  
      
      IF CRs("UserCompanyLevel") <> "" Then FndData = FndData & ", "&ReHtmlSpecialChars(CRs("UserCompanyLevel"))
      
      FndData = FndData & " )</td>"
	  FndData = FndData & " <td>"&CRs("UserBirth")&"</td>"
      FndData = FndData & " <td>"&CRs("ViewYN")&"</td>"
      FndData = FndData & "</tr>"
      
      RoleNm = ""

      CRs.movenext
    Loop  
  ELSE
    FndData = FndData & "<tr><td colspan=7>일치하는 정보가 없습니다.</td></tr>"
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