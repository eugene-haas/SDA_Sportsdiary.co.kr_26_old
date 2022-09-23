<!--#include file="../dev/dist/config.asp"-->
<%
  '====================================================================================
  '리스트 조회
  '====================================================================================
  Check_AdminLogin()

  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 10  '페이지내 보여지는 목록카운트  
  dim cnt         : cnt           = 0   '카운트  

  dim currPage      : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
  dim fnd_RefereeGb : fnd_RefereeGb = fInject(Request("fnd_RefereeGb"))

  dim valType
  dim TotCount, TotPage
  dim CSearch, CSearch2
  dim FndData, CStrPG, CStrTP
    dim LSQL, LRs   
   
    IF Len(currPage) = 0 Then currPage = 1  
    IF fnd_KeyWord <> "" OR fnd_RefereeGb <> "" Then valType = "FND"
  
  IF fnd_RefereeGb <> "" Then CSearch = " AND A.RefereeGb = '"&fnd_RefereeGb&"'"
  IF fnd_KeyWord <> "" Then CSearch2 = " AND A.UserName like '%"&fnd_KeyWord&"%'"
  
  
    LSQL = "      SELECT ISNULL(COUNT(*),0) Cnt"
  LSQL = LSQL & "     ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&")" 
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblLicenseInfo] A"
  LSQL = LSQL & "   left join [KoreaBadminton].[dbo].[tblPubcode] B on A.RefereeGb = B.PubCode"
  LSQL = LSQL & "     AND B.DelYN = 'N'"
  LSQL = LSQL & "     AND B.PPubCode = 'LICENSE'"
  LSQL = LSQL & " WHERE A.DelYN = 'N'"&CSearch&CSearch2

  SET LRs = DBCon.Execute(LSQL) 
    TotalCount = formatnumber(LRs(0), 0)
    TotalPage = LRs(1)   
  
  
    '카운트/페이지  
  CStrTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
  CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
  CStrTP = CStrTP & "</span></div>"

  
    '목록조회
    LSQL = "      SELECT TOP "&currPage * B_PSize 
  LSQL = LSQL & "   A.LicenseIDX"
  LSQL = LSQL & "   ,B.PubName RefereeNm"
  LSQL = LSQL & "   ,A.RefereeLevel RefereeLvl"
  LSQL = LSQL & "   ,A.LicenseNumber"
  LSQL = LSQL & "   ,CONVERT(CHAR(10), A.LicenseDt, 102) LicenseDt"
  LSQL = LSQL & "   ,A.UserName"
  LSQL = LSQL & "   ,CASE WHEN A.UserBirth<>'' THEN SUBSTRING(A.UserBirth, 1, 4)+'.'+SUBSTRING(A.UserBirth, 5, 2)+'.'+SUBSTRING(A.UserBirth, 7, 2) END UserBirth"
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblLicenseInfo] A"
  LSQL = LSQL & "   left join [KoreaBadminton].[dbo].[tblPubcode] B on A.RefereeGb = B.PubCode"
  LSQL = LSQL & "     AND B.DelYN = 'N'"
  LSQL = LSQL & "     AND B.PPubCode = 'LICENSE'"
  LSQL = LSQL & " WHERE A.DelYN = 'N'"&CSearch&CSearch2  
  LSQL = LSQL & " ORDER BY A.RefereeGb, A.UserName"
        
  'response.Write LSQL
        
    SET LRs = DBCon.Execute(LSQL)
  
  FndData = "       <table class='table-list popup-table'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>구분</th>"
  FndData = FndData & "     <th>급수</th>"
  FndData = FndData & "     <th>발급번호</th>"
  FndData = FndData & "     <th>자격취득일자</th>"
  FndData = FndData & "     <th>이름</th>"
  FndData = FndData & "     <th>생년월일</th>"
  FndData = FndData & "     <th>자격발급</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"

  IF Not(LRs.Eof Or LRs.Bof) Then 

    LRs.Move (currPage - 1) * B_PSize

    Do Until LRs.eof

      cnt = cnt + 1
      
      FndData = FndData & "<tr>"
      FndData = FndData & " <td>"&formatnumber((totalcount - (currPage - 1) * B_Psize - cnt+1), 0)&"</td>"
      FndData = FndData & " <td>"&LRs("RefereeNm")&"</td>"
      FndData = FndData & " <td>"&LRs("RefereeLvl")&"급</td>"
      FndData = FndData & " <td>"&ReHtmlSpecialChars(LRs("LicenseNumber"))&"</td>"
      FndData = FndData & " <td>"&LRs("LicenseDt")&"</td>"  
      FndData = FndData & " <td onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(LRs("LicenseIDX"))&"','"&currPage&"');"">"&LRs("UserName")&"</td>"
      FndData = FndData & " <td class='user-birth'>"&LRs("UserBirth")&"</td>"      
      FndData = FndData & " <td><input type='text' name='LC_Num"&crypt.EncryptStringENC(LRs("LicenseIDX"))&"' id='LC_Num"&crypt.EncryptStringENC(LRs("LicenseIDX"))&"' class='ipt-word'> <a href='javascript:;' class='btn btn-confirm' onClick=""INFO_PRINT('"&crypt.EncryptStringENC(LRs("LicenseIDX"))&"');"">인쇄하기</a></td>"
      FndData = FndData & "</tr>"
    
      LRs.movenext
    Loop  
    ELSE
      FndData = FndData & "<tr><td colspan=8>일치하는 정보가 없습니다.</td></tr>"
    End IF  
      LRs.Close
    SET LRs = Nothing
    
  FndData = FndData & " </tbody>"
  FndData = FndData & "</table>"
  
      
  
  
  
  '페이징  
  dim intTemp

  CStrPG = CStrPG & " <div class='page_index'>"
  CStrPG = CStrPG & " <ul class='pagination'>"

  intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1

  If intTemp = 1 Then
    CStrPG = CStrPG & "<li class='prev'><a href=""javascript:;"" class='fa fa-angle-left'></a></li>"
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
    CStrPG = CStrPG & "<li class='next'><a href=""javascript:;"" class='fa fa-angle-right'></a></li>"
  Else
    CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"" class='fa fa-angle-right'></a></li>"
  End IF  

  CStrPG = CStrPG & "</ul>"
  CStrPG = CStrPG & "</div>"
  
  
    '출력  
    response.Write CStrTP '카운트/페이지
    response.Write FndData  '목록 테이블
    
    IF TotalCount > 0 Then response.Write CStrPG  '페이징
  
  
    DBClose()
  
%>