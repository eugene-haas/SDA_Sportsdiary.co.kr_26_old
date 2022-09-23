<!--#include file="../dev/dist/config.asp"-->
<%
  '===========================================================================================
  '증명서 신청리스트 조회페이지
  '===========================================================================================
  Check_AdminLogin()
   
  dim currPage        : currPage        = fInject(Request("currPage"))
  dim fnd_KeyWord     : fnd_KeyWord       = fInject(Request("fnd_KeyWord"))
  dim fnd_TypeCertificate : fnd_TypeCertificate   = fInject(Request("fnd_TypeCertificate"))
  dim fnd_TypeUse     : fnd_TypeUse       = fInject(Request("fnd_TypeUse"))
  dim fnd_TypeRecive    : fnd_TypeRecive    = fInject(Request("fnd_TypeRecive"))
  dim fnd_TypeResult    : fnd_TypeResult    = fInject(Request("fnd_TypeResult"))                               
  dim SDate       : SDate         = fInject(Request("SDate"))
  dim EDate       : EDate         = fInject(Request("EDate"))
  
  dim BlockPage       : BlockPage       = global_BlockPage  '페이지
  dim B_PSize         : B_PSize         = global_PagePerData  '페이지내 보여지는 목록카운트    
                               
  dim TotCount, TotPage
  dim RE_Data, CStrPG, CStrTP
  dim CRs, CSQL   
  dim Csearch, Csearch2, Csearch3, Csearch4, Csearch5, Csearch6
  dim i
                               
  IF Len(currPage) = 0 Then currPage = 1
  
  '기간선택
  IF SDate <> "" AND EDate <> "" Then
    CSearch = " AND DateDiff(d, '"&SDate&"', InsDate)>=0 AND DateDiff(d, InsDate, '"&EDate&"')>=0 "
  ElseIF SDate <> "" AND EDate = "" Then
    CSearch = " AND DateDiff(d, InsDate, '"&SDate&"')=0 "
  ElseIF SDate = "" AND EDate <> "" Then
    CSearch = " AND DateDiff(d, '"&EDate&"', InsDate)=0 "
  Else
  End IF
  
  '키워드 검색 [신청자, 생년월일, 전화번호]
  dim search(2)

  search(0) = "UserName"
  search(1) = "UserBirth"
  search(2) = "UserPhone"
  
  IF SDate <> "" OR EDate <> "" OR fnd_KeyWord <> "" OR fnd_TypeResult <> "" OR fnd_TypeCertificate <> "" OR fnd_TypeUse <> "" OR fnd_TypeRecive <> "" Then valType = "FND"
  
  IF fnd_KeyWord <> "" Then
    For i = 0 To 2
      CSearch2 = CSearch2 & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
    Next
  
    CSearch2 = " AND ("&mid(CSearch2, 5)&")"
  End IF
  
  IF fnd_TypeCertificate <> "" Then CSearch3 = " AND TypeCertificate = '"&fnd_TypeCertificate&"'"
  IF fnd_TypeUse <> "" Then CSearch4 = " AND TypeUse = '"&fnd_TypeUse&"'"
  IF fnd_TypeRecive <> "" Then CSearch5 = " AND TypeRecive = '"&fnd_TypeRecive&"'"
  IF fnd_TypeResult <> "" Then CSearch6 = " AND TypeResult = '"&fnd_TypeResult&"'"

  '조회정보 전체 카운트
  CSQL = "        SELECT COUNT(*) "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblOnlineCertificate] TOC WITH(NOLOCK)"
  CSQL = CSQL & " LEFT OUTER JOIN [KoreaBadminton].[dbo].[tblOnlineCertificatePayLog] CPL WITH(NOLOCK) ON TOC.CertificateIDX = CPL.CertificateIDX AND TOC.CerPayNum = CPL.CerPayNum AND CPL.CertPayRespCode = '0000'"
  CSQL = CSQL & " WHERE DelYN = 'N' "&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6 
    
  SET CRs = DBCon.Execute(CSQL) 
    TotalCount = CRs(0)
    TotalPage = CRs(1)
  
    '==================================================================================================================================
  '카운트/페이지
  '==================================================================================================================================
  CStrTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
  CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
  CStrTP = CStrTP & "</span></div>"
  
  CSQL = "      SELECT TOP "&currPage * B_PSize&" TOC.CertificateIDX"
  CSQL = CSQL & "   ,UserName" 
  CSQL = CSQL & "   ,[KoreaBadminton].[dbo].[FN_PubName](TypeCertificate) TypeCertificateNm"
  CSQL = CSQL & "   ,[KoreaBadminton].[dbo].[FN_PubName](TypeUse) TypeUseNm "
  CSQL = CSQL & "     ,SubmitOrg"
  CSQL = CSQL & "     ,CONVERT(CHAR(10), InsDate, 102) InsDate"
  CSQL = CSQL & "     ,CASE TypeResult"               '처리상태 [S:신청대기 | P:처리중 |  R:발급완료 | C:취소] 
  CSQL = CSQL & "     WHEN 'P' THEN '처리중'"
  CSQL = CSQL & "     WHEN 'R' THEN '발급완료'"
  CSQL = CSQL & "     WHEN 'C' THEN '취소'"
  CSQL = CSQL & "   ELSE '신청대기'"
  CSQL = CSQL & "   END TypeResultNm "
  CSQL = CSQL & "     ,CASE TypeRecive "
  CSQL = CSQL & "       WHEN 'FAX' THEN '팩스수령'"
  CSQL = CSQL & "       WHEN 'VISIT' THEN '방문수령'"
  CSQL = CSQL & "       WHEN 'SPRINT' THEN '직접출력'"
  CSQL = CSQL & "     ELSE '우편수령'"
  CSQL = CSQL & "     END TypeReciveNm "
  CSQL = CSQL & "   ,CerPayYN "
  CSQL = CSQL & "   ,TOC.CerPayNum "
  CSQL = CSQL & "   ,ISNULL(CertPayPayType, '') AS CertPayPayType "
  CSQL = CSQL & "   ,CASE ISNULL(CertPayPayType, '') "
  CSQL = CSQL & "		WHEN 'SC0010' THEN '신용카드' "
  CSQL = CSQL & "		WHEN 'SC0030' THEN '계좌이체' "
  CSQL = CSQL & "		WHEN 'SC0040' THEN '무통장' "
  CSQL = CSQL & "		WHEN 'SC0060' THEN '휴대폰' "
  CSQL = CSQL & "		ELSE '미결제' "
  CSQL = CSQL & "	 END AS CertPayPayTypeNm "
  CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblOnlineCertificate] TOC WITH(NOLOCK)"
  CSQL = CSQL & " LEFT OUTER JOIN [KoreaBadminton].[dbo].[tblOnlineCertificatePayLog] CPL WITH(NOLOCK) ON TOC.CertificateIDX = CPL.CertificateIDX AND TOC.CerPayNum = CPL.CerPayNum AND CPL.CertPayRespCode = '0000'"
  CSQL = CSQL & " WHERE DelYN = 'N' "&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6 
  CSQL = CSQL & " ORDER BY InsDate DESC" 

  'response.Write CSQL
  
  SET CRs = DBCon.Execute(CSQL)
                   
  FndData = "      <table class='table-list'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>이름</th>"
  FndData = FndData & "     <th>종류</th>"
  FndData = FndData & "     <th>용도</th>"
  FndData = FndData & "     <th>제출처</th>"
  FndData = FndData & "     <th>신청일</th>"
  FndData = FndData & "     <th>수령방법</th>"
  FndData = FndData & "     <th>결제방법</th>"
  FndData = FndData & "     <th>처리상태</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
                          
  IF Not(CRs.Eof Or CRs.Bof) Then 
    
    CRs.Move (currPage - 1) * B_PSize

    Do Until CRs.Eof 
      
      cnt = cnt + 1

      FndData = FndData & "<tr onClick=""chk_Submit('VIEW','" & crypt.EncryptStringENC(CRs("CertificateIDX")) & "','"&currPage&"');"">"
      FndData = FndData & " <td>" & totalcount - (currPage - 1) * B_Psize - cnt+1 & "</td>"
      FndData = FndData & " <td>" & CRs("UserName") & "</td>"
      FndData = FndData & " <td>" & CRs("TypeCertificateNm") & "</td>"
      FndData = FndData & " <td>" & CRs("TypeUseNm") & "</td>"
      FndData = FndData & " <td>" & ReHtmlSpecialChars(CRs("SubmitOrg")) & "</td>"
      FndData = FndData & " <td>" & CRs("InsDate") & "</td>"
      FndData = FndData & " <td>" & CRs("TypeReciveNm") & "</td>"
	  FndData = FndData & " <td>" & CRs("CertPayPayTypeNm") & "</td>"
      FndData = FndData & " <td>" & CRs("TypeResultNm") & "</td>"
      FndData = FndData & "</tr>"

        CRs.MoveNext
    Loop
    Else
      FndData = FndData & "<tr>"
    FndData = FndData & " <td colspan='9'>신청내역이 없습니다.</td>"
    FndData = FndData & "</tr>"
  End IF
    CRs.Close
  SET CRs = Nothing   
  
  FndData = FndData & "</table>"                         
  
  
  '페이징

  IF TotalCount > 0 Then
  
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
                         
  End IF
  
  
  response.Write CStrTP '카운트/페이지
  response.Write FndData  
  IF TotalCount > 0 Then response.Write CStrPG  '페이징                   
                                    
  
  DBClose()
%>