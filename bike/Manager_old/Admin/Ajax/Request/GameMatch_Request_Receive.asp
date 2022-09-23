<!--#include file="../../dev/dist/config.asp"-->
<%
    '==============================================================================
  '참가신청 접수 목록 조회
  '==============================================================================

  dim BlockPage       : BlockPage       = 10  '페이지
  dim B_PSize         : B_PSize         = 20  '페이지내 보여지는 목록카운트     

  dim CIDX          : CIDX            = crypt.DecryptStringENC(fInject(Request("CIDX")))  
  dim fnd_currPage    : fnd_currPage      = fInject(Request("fnd_currPage"))    
  dim fnd_RKeyWord    : fnd_RKeyWord      = fInject(Request("fnd_RKeyWord"))
  dim fnd_EnterType   : fnd_EnterType     = fInject(Request("fnd_EnterType")) 
    dim valType       : valType         = fInject(Request("valType")) 

  dim LSQL, LRs
  dim RE_DATA, RE_PAGE, RE_COUNTP
  dim TotCount, TotPage
  dim CSearch, CSearch2, CSearch3, CSearch4, CSearch5, CSearch6
  
    IF Len(fnd_currPage) = 0 Then fnd_currPage = 1
   
    dim strGameLevel
   
  '키워드 검색 [선수명, 팀명]
  dim search(1)

  search(0) = "C.UserName"    '참가신청자
  search(1) = "E.TeamNm"      '참가신청자 소속팀
  
   
  IF fnd_RKeyWord <> "" Then
    For i = 0 To 1
      CSearch = CSearch & " OR "&search(i)&" like N'%"&fnd_RKeyWord&"%'"
    Next
  
      CSearch = " AND ("&mid(CSearch, 5)&")"
    End IF

    IF CIDX <> "" Then
    
    '전체보기 시 검색조건 초기화
    IF valType = "ALL" Then CSearch = "" 
    
    '전체카운트, 페이지
    LSQL = "      SELECT ISNULL(COUNT(*),0) Cnt"
    LSQL = LSQL & "     ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") "      
  LSQL = LSQL & " FROM("
  LSQL = LSQL & "     SELECT A.GameTitleIDX"
  LSQL = LSQL & "   ,A.ReceptionistIDX"
  LSQL = LSQL & "   ,C.UserName+'('+C.AthleteCode+')' UserInfo"
  LSQL = LSQL & "   ,E.TeamNm TeamNm"
  LSQL = LSQL & "   ,A.Status"
  LSQL = LSQL & "   ,D.PubName StatusNm"
  LSQL = LSQL & "   ,A.PayGroupNum"
  LSQL = LSQL & "   ,CASE A.Status WHEN 'ST_2' THEN ("
  LSQL = LSQL & "     SELECT PayAmount "
  LSQL = LSQL & "     FROM [KoreaBadminton].[dbo].[tblGameEnterPayInfo] B"
  LSQL = LSQL & "     WHERE B.DelYN = 'N'"  
  'LSQL = LSQL & "      AND B.EnterType = '"&fnd_EnterType&"'"
  LSQL = LSQL & "       AND B.GameTitleIDX = '"&CIDX&"'"
  LSQL = LSQL & "       and B.ReceptionistIDX = A.ReceptionistIDX"
  LSQL = LSQL & "       AND B.PayGroupNum =("
  LSQL = LSQL & "         SELECT MAX(PayGroupNum)"
  LSQL = LSQL & "         FROM [KoreaBadminton].[dbo].[tblGameEnter]" 
  LSQL = LSQL & "         WHERE DelYN = 'N'" 
  'LSQL = LSQL & "          AND EnterType = '"&fnd_EnterType&"'" 
  LSQL = LSQL & "           AND GameTitleIDX = '"&CIDX&"'" 
  LSQL = LSQL & "           AND ReceptionistIDX = A.ReceptionistIDX"
  LSQL = LSQL & "         )"
  LSQL = LSQL & "     GROUP BY B.PayAmount"
  LSQL = LSQL & "   ) ELSE 0 END PayAmount"
  LSQL = LSQL & "   ,A.PayOrderNum"
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameEnter] A"
  LSQL = LSQL & "   inner join [KoreaBadminton].[dbo].[tblMember] C on A.ReceptionistIDX = C.MemberIDX AND C.DelYN = 'N' AND C.NowRegYN = 'Y'"
  LSQL = LSQL & "   inner join [KoreaBadminton].[dbo].[tblTeamInfo] E on C.Team = E.Team AND E.DelYN = 'N'"&CSearch 
  LSQL = LSQL & "   left join [KoreaBadminton].[dbo].[tblPubcode] D on A.Status = D.PubCode AND D.DelYN = 'N'"    
  LSQL = LSQL & " WHERE A.DelYN = 'N'"  
  'LSQL = LSQL & "  AND A.EnterType = '"&fnd_EnterType&"'"
  LSQL = LSQL & "   AND A.GameTitleIDX = '"&CIDX&"'"
  LSQL = LSQL & " GROUP BY A.GameTitleIDX, A.ReceptionistIDX, C.UserName, C.UserPhone, C.AthleteCode, E.TeamNm, A.Status, D.PubName, A.PayGroupNum, A.PayOrderNum"
  LSQL = LSQL & ") Z"
                             
  ' response.Write CSQL

    SET LRs = DBCon.Execute(LSQL) 
    TotalCount = formatnumber(LRs(0),0)
    TotalPage = LRs(1)

    
    '카운트/페이지    
    RE_COUNTP = "<div><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
    RE_COUNTP = RE_COUNTP & "<span>"&fnd_currPage &" page / " & TotalPage & " pages"
    RE_COUNTP = RE_COUNTP & "</span></div>"


    LSQL = "      SELECT A.GameTitleIDX"
  LSQL = LSQL & "   ,A.ReceptionistIDX"
  LSQL = LSQL & "   ,C.UserName"
  LSQL = LSQL & "   ,C.UserPhone"
  LSQL = LSQL & "   ,A.Status"
  LSQL = LSQL & "   ,C.UserName+'('+C.AthleteCode+')' UserInfo"
  LSQL = LSQL & "   ,E.TeamNm TeamNm"
  LSQL = LSQL & "   ,D.PubName StatusNm"
  LSQL = LSQL & "   ,A.PayGroupNum"
  LSQL = LSQL & "   ,CASE A.Status WHEN 'ST_2' THEN ("
  LSQL = LSQL & "     SELECT PayAmount "
  LSQL = LSQL & "     FROM [KoreaBadminton].[dbo].[tblGameEnterPayInfo] B"
  LSQL = LSQL & "     WHERE B.DelYN = 'N'"  
  'LSQL = LSQL & "      AND B.EnterType = '"&fnd_EnterType&"'"
  LSQL = LSQL & "       AND B.GameTitleIDX = '"&CIDX&"'"
  LSQL = LSQL & "       and B.ReceptionistIDX = A.ReceptionistIDX"
  LSQL = LSQL & "       AND B.PayGroupNum =("
  LSQL = LSQL & "         SELECT MAX(PayGroupNum)"
  LSQL = LSQL & "         FROM [KoreaBadminton].[dbo].[tblGameEnter]" 
  LSQL = LSQL & "         WHERE DelYN = 'N'" 
  'LSQL = LSQL & "          AND EnterType = '"&fnd_EnterType&"'" 
  LSQL = LSQL & "           AND GameTitleIDX = '"&CIDX&"'" 
  LSQL = LSQL & "           AND ReceptionistIDX = A.ReceptionistIDX"
  LSQL = LSQL & "         )"
  LSQL = LSQL & "     GROUP BY B.PayAmount"
  LSQL = LSQL & "   ) ELSE 0 END PayAmount"
  LSQL = LSQL & "   ,A.PayOrderNum"
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameEnter] A"
  LSQL = LSQL & "   inner join [KoreaBadminton].[dbo].[tblMember] C on A.ReceptionistIDX = C.MemberIDX AND C.DelYN = 'N' AND C.NowRegYN = 'Y'"
  LSQL = LSQL & "   inner join [KoreaBadminton].[dbo].[tblTeamInfo] E on C.Team = E.Team AND E.DelYN = 'N'"&CSearch
  LSQL = LSQL & "   left join [KoreaBadminton].[dbo].[tblPubcode] D on A.Status = D.PubCode AND D.DelYN = 'N'"  
  LSQL = LSQL & " WHERE A.DelYN = 'N'"  
  'LSQL = LSQL & "    AND A.EnterType = '"&fnd_EnterType&"'"
  LSQL = LSQL & "   AND A.GameTitleIDX = '"&CIDX&"'"
  LSQL = LSQL & " GROUP BY A.GameTitleIDX, A.ReceptionistIDX, C.UserName, C.UserPhone, C.AthleteCode, E.TeamNm, A.Status, D.PubName, A.PayGroupNum, A.PayOrderNum"
  LSQL = LSQL & " ORDER BY A.GameTitleIDX, A.Status"

  ' response.write LSQL

    SET LRs = DBCon.Execute(LSQL) 
    IF Not(LRs.Eof Or LRs.Bof) Then 

        LRs.Move (fnd_currPage - 1) * B_PSize

        Do Until LRs.eof

          cnt = cnt + 1
        
            RE_DATA = RE_DATA & "<tr>"
                RE_DATA = RE_DATA & "  <td>"&totalcount - (fnd_currPage - 1) * B_Psize - cnt+1&"</td>"
                RE_DATA = RE_DATA & "  <td>"&LRs("UserInfo")&"</td>"        
        RE_DATA = RE_DATA & "  <td>"&LRs("UserPhone")&"</td>"         
        RE_DATA = RE_DATA & "  <td>"&LRs("TeamNm")&"</td>"                  
        RE_DATA = RE_DATA & "  <td>"&formatnumber(LRs("PayAmount"), 0)&"</td>"
                RE_DATA = RE_DATA & "  <td>"&LRs("StatusNm")&"</td>"  
        RE_DATA = RE_DATA & "  <td><a href=""javascript:chk_Submit('VIEW', '"&crypt.EncryptStringENC(LRs("ReceptionistIDX"))&"', '"&fnd_currPage&"');"" class=""btn"">상세보기</a></td>"
                RE_DATA = RE_DATA & "</tr>"
        onClick=""""  
          LRs.Movenext
        Loop
  Else
        RE_DATA = RE_DATA & "<tr><td colspan=7>등록된 참가신청 정보가 없습니다.</td></tr>"
    End IF    

    
    '페이징
    dim intTemp
    dim intLoop : intLoop = 1

    intTemp = Int((fnd_currPage - 1) / BlockPage) * BlockPage + 1


    IF intTemp = 1 Then
        IF fnd_currPage = 1 Then
          RE_PAGE = RE_PAGE & "<li class='page-item'><a href='javascript:' class='page-link' title='이전 "&BlockPage&"페이지'><span class='ic-deco'><i class='fas fa-angle-double-left'></i></span></a></li>"
          RE_PAGE = RE_PAGE & "<li class='page-item'><a href='javascript:' class='page-link' title='이전페이지'><span class='ic-deco'><i class='fas fa-angle-left'></i></span></a></li>"
        Else
          RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','',1);"" class='page-link' title='이전 "&BlockPage&"페이지'><span class='ic-deco'><i class='fas fa-angle-double-left'></i></span></a></li>"
          RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','','"&fnd_currPage-1&"');"" class='page-link' title='이전페이지'><span class='ic-deco'><i class='fas fa-angle-left'></i></span></a></li>"
        End IF
    Else
        RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','',1);"" class='page-link' title='이전 "&BlockPage&"페이지'><span class='ic-deco'><i class='fas fa-angle-double-left'></i></span></a></li>"
      RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');"" class='page-link' title='이전페이지'><span class='ic-deco'><i class='fas fa-angle-left'></i></span></a></li>"
    End IF

    Do Until intLoop > BlockPage OR intTemp > TotalPage

        IF intTemp = CInt(fnd_currPage) Then
          RE_PAGE = RE_PAGE & "<li class=""page-item active""><a href=""javascript:"" class='page-link'>"&intTemp&"</a></li>"
        Else
          RE_PAGE = RE_PAGE & "<li class=""page-item""><a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" class='page-link'>"&intTemp&"</a></li>"
        End If

        intTemp = intTemp + 1
        intLoop = intLoop + 1 

    Loop  

    IF intTemp > TotalPage Then
        IF cint(fnd_currPage) < cint(TotalPage) Then
          RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&fnd_currPage+1&"');"" aria-label='Next' title='다음페이지'><span class='ic-deco'><i class='fas fa-angle-right'></i></span></a></li>"
          RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&TotalPage&"');"" aria-label='Next' title='다음 "&BlockPage&"페이지'><span class='ic-deco'><i class='fas fa-angle-double-right'></i></span></a></li>"
        Else
          RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href='javascript:' aria-label='Next' title='다음페이지'><span class='ic-deco'><i class='fas fa-angle-right'></i></span></a></li>"
          RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href='javascript:' aria-label='Next' title='다음 "&BlockPage&"페이지'><span class='ic-deco'><i class='fas fa-angle-double-right'></i></span></a></li>"
        End IF
    Else
        RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" aria-label='Next' title='다음페이지'><span class='ic-deco'><i class='fas fa-angle-right'></i></span></a></li>"
        RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" aria-label='Next' title='다음 "&BlockPage&"페이지'><span class='ic-deco'><i class='fas fa-angle-double-right'></i></span></a></li>"
    End IF 


    IF TotalCount > 0 Then 
        Response.Write "TRUE|"&RE_COUNTP&"|"&RE_DATA&"|"&RE_PAGE
    Else
        Response.Write "TRUE|"&RE_COUNTP&"|"&RE_DATA&"|"  
    End IF
        
    DBClose()

  Else
    
      Response.Write "FALSE|" '잘못된 접근입니다
    
  End IF
  
%>