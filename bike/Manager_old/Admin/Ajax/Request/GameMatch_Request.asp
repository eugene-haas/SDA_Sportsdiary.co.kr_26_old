<!--#include file="../../dev/dist/config.asp"-->
<%
    '==============================================================================
  '참가신청 현황 목록 조회
  '==============================================================================

  dim BlockPage       : BlockPage       = 10  '페이지
  dim B_PSize         : B_PSize         = 20  '페이지내 보여지는 목록카운트  
  dim cnt           : cnt             = 0   '카운트        

  dim CIDX          : CIDX            = crypt.DecryptStringENC(fInject(Request("CIDX")))  
  dim fnd_currPage    : fnd_currPage      = fInject(Request("fnd_currPage"))    
  dim fnd_GameType    : fnd_GameType      = fInject(Request("fnd_GameType"))   
  dim fnd_GameGroup   : fnd_GameGroup     = fInject(Request("fnd_GameGroup"))  
  dim fnd_GameLevel   : fnd_GameLevel     = fInject(Request("fnd_GameLevel"))  
  dim fnd_AreaGb      : fnd_AreaGb      = fInject(Request("fnd_AreaGb"))   
  dim fnd_AreaGbDt    : fnd_AreaGbDt      = fInject(Request("fnd_AreaGbDt"))   
  dim fnd_RKeyWord    : fnd_RKeyWord      = fInject(Request("fnd_RKeyWord"))
  dim valType       : valType         = fInject(Request("valType")) 

  dim fnd_EnterType   : fnd_EnterType     = fInject(Request("fnd_EnterType")) 

  dim LSQL, LRs
  dim RE_DATA, RE_PAGE, RE_COUNTP
  dim TotCount, TotPage
  dim CSearch, CSearch2, CSearch3, CSearch4, CSearch5, CSearch6, CSearch7
  
    IF Len(fnd_currPage) = 0 Then fnd_currPage = 1
   
    dim strGameLevel
   
  IF fnd_GameType <> "" Then CSearch = " AND A.GroupGameGb = '"&fnd_GameType&"'"
  IF fnd_GameGroup <> "" Then CSearch2 = " AND A.TeamGb = '"&fnd_GameGroup&"'"
  IF fnd_GameLevel <> "" Then 
    strGameLevel = Split(fnd_GameLevel, "|")
    CSearch3 = " AND A.Sex = '"&strGameLevel(0)&"'"
    CSearch4 = " AND A.PlayType = '"&strGameLevel(1)&"'"                            
    End IF
                             
  IF fnd_AreaGb <> "" Then CSearch5 = " AND H.sido = '"&fnd_AreaGb&"'"
  IF fnd_AreaGbDt <> "" Then CSearch6 = " AND H.sidogugun = '"&fnd_AreaGbDt&"'"
  
  
  '키워드 검색 [선수명, 팀명]
  dim search(1)

  search(0) = "A.UserName"    'UserName
  search(1) = "A.UserTeamNm"    'UserTeamName                  

  IF fnd_RKeyWord <> "" Then
    For i = 0 To 1
      CSearch7 = CSearch7 & " OR "&search(i)&" like N'%"&fnd_RKeyWord&"%'"
    Next
  
      CSearch7 = " AND ("&mid(CSearch7, 5)&")"
    End IF

    IF CIDX <> "" Then
    
    '전체보기 시 검색조건 초기화
    IF valType = "ALL" Then CSearch2="" : CSearch3="" : CSearch4="" : CSearch5="" : CSearch6="" : CSearch7=""
    
    '전체카운트, 페이지
    LSQL = "      SELECT ISNULL(COUNT(*),0) Cnt"
    LSQL = LSQL & "     ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") "      
    LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameEnter] A"
    LSQL = LSQL & "     inner join [KoreaBadminton].[dbo].[tblMember] B on A.ReceptionistIDX = B.MemberIDX AND B.DelYN = 'N' AND B.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     inner join [KoreaBadminton].[dbo].[tblLevelInfo] G on A.Level = G.Level AND G.DelYN = 'N' AND G.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblTeamInfo] H on A.UserTeam = H.Team AND H.DelYN = 'N' AND H.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblTeamGbInfo] C on A.TeamGb = C.TeamGb AND C.DelYN = 'N'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubCode] D on A.GroupGameGb = D.PubCode AND D.DelYN = 'N'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubCode] E on A.PlayType = E.PubCode AND E.DelYN = 'N'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubCode] F on A.LevelJooName = F.PubCode AND F.DelYN = 'N' "
    LSQL = LSQL & " WHERE A.DelYN = 'N'"  
    LSQL = LSQL & "     AND A.TeamDefaultYN = 'Y'"
    LSQL = LSQL & "     AND A.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     AND A.GameTitleIDX = '"&CIDX&"'"&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6&CSearch7
  LSQL = LSQL & "     AND A.Status = 'ST_2'"  '신청완료

  ' response.Write CSQL

    SET LRs = DBCon.Execute(LSQL) 
    TotalCount = formatnumber(LRs(0),0)
    TotalPage = LRs(1)

    
    '카운트/페이지    
    RE_COUNTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
    RE_COUNTP = RE_COUNTP & "<span>"&fnd_currPage &" page / " & TotalPage & " pages"
    RE_COUNTP = RE_COUNTP & "</span></div>"


    LSQL = "      SELECT TOP "&fnd_currPage * B_PSize 
    LSQL = LSQL & "     A.GameEnterIDX"
    LSQL = LSQL & "     ,[KoreaBadminton].[dbo].[FN_SidoName](H.Sido) SidoNm"
    LSQL = LSQL & "     ,[KoreaBadminton].[dbo].[FN_SidoGuGunName](H.Sido, H.SidoGuGun) SidoGuGunNm"
    LSQL = LSQL & "     ,D.PubName GameType"
    LSQL = LSQL & "     ,C.TeamGbNm TeamGbNm"
    LSQL = LSQL & "     ,CASE A.Sex WHEN 'Man' THEN '남자' WHEN 'WoMan' THEN '여자' ELSE '혼합' END SEX"
    LSQL = LSQL & "     ,E.PubName PlayTypeNm"
    LSQL = LSQL & "     ,G.LevelNm LevelNm"
    LSQL = LSQL & "     ,CASE A.GroupGameGb WHEN 'B0030001' THEN CASE WHEN F.PubName <> '' THEN F.PubName END ELSE CASE WHEN A.GroupGubun <> '' THEN A.GroupGubun + '조' END END GameGroupNm"
    LSQL = LSQL & "     ,B.UserName ReqUserName"
    LSQL = LSQL & "     ,A.UserName + '(' + A.UserTeamNm + ')' UserInfo"
    LSQL = LSQL & "     ,CASE WHEN A.PartnerName <> '' THEN A.PartnerName + '(' + A.PartnerTeamNm + ')' END PartnerInfo"   
    LSQL = LSQL & "     ,CONVERT(CHAR(10), A.InsDate, 102) InsDate" 
  LSQL = LSQL & "   ,I.PubName StatusNm"
  LSQL = LSQL & "   ,A.Status"
    LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameEnter] A"
    LSQL = LSQL & "     inner join [KoreaBadminton].[dbo].[tblMember] B on A.ReceptionistIDX = B.MemberIDX AND B.DelYN = 'N' AND B.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     inner join [KoreaBadminton].[dbo].[tblLevelInfo] G on A.Level = G.Level AND G.DelYN = 'N' AND G.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblTeamInfo] H on A.UserTeam = H.Team AND H.DelYN = 'N' AND H.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblTeamGbInfo] C on A.TeamGb = C.TeamGb AND C.DelYN = 'N'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubCode] D on A.GroupGameGb = D.PubCode AND D.DelYN = 'N'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubCode] E on A.PlayType = E.PubCode AND E.DelYN = 'N'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubCode] F on A.LevelJooName = F.PubCode AND F.DelYN = 'N' "
  LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubCode] I on A.Status = I.PubCode AND I.DelYN = 'N' "
    LSQL = LSQL & " WHERE A.DelYN = 'N'"  
    LSQL = LSQL & "     AND A.TeamDefaultYN = 'Y'"
    LSQL = LSQL & "     AND A.EnterType = '"&fnd_EnterType&"'"
    LSQL = LSQL & "     AND A.GameTitleIDX = '"&CIDX&"'"&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6&CSearch7
  LSQL = LSQL & "     AND A.Status = 'ST_2'"  '신청완료
    LSQL = LSQL & " ORDER BY H.Sido, H.SidoGuGun, D.OrderBy, A.TeamGb, A.Sex, E.OrderBy, G.Orderby, A.LevelJooName, A.GroupGubun, A.UserName, A.InsDate"

  ' response.write LSQL

    SET LRs = DBCon.Execute(LSQL) 
    IF Not(LRs.Eof Or LRs.Bof) Then 

        LRs.Move (fnd_currPage - 1) * B_PSize

        Do Until LRs.eof

          cnt = cnt + 1
        
            RE_DATA = RE_DATA & "<tr>"
                RE_DATA = RE_DATA & "  <td>"&LRs("SidoNm")&"</td>"
                RE_DATA = RE_DATA & "  <td>"&LRs("SidoGuGunNm")&"</td>"
        RE_DATA = RE_DATA & "  <td>"&LRs("GameType")&"</td>"
        RE_DATA = RE_DATA & "  <td>"&LRs("TeamGbNm")&"</td>"
                RE_DATA = RE_DATA & "  <td class='game_type'><span>"&LRs("SEX")&LRs("PlayTypeNm")&" / "&LRs("LevelNm")&" / "&LRs("GameGroupNm")&"</span></td>"
                RE_DATA = RE_DATA & "  <td class='player_name'><span>"&LRs("ReqUserName")&"</span></td>"
                RE_DATA = RE_DATA & "  <td class='player_name'><span>"&LRs("UserInfo")&"</span></td>"
                RE_DATA = RE_DATA & "  <td class='player_name'><span>"&LRs("PartnerInfo")&"</span></td>"
                RE_DATA = RE_DATA & "  <td>"&LRs("InsDate")&"</td>"
        RE_DATA = RE_DATA & "  <td>"&LRs("StatusNm")&"</td>"
          
        
'       SELECT CASE LRs("Status") 
'         CASE "ST_1" : RE_DATA = RE_DATA & "  <td><img src='../imgs/component/icon_wait.png' alt='신청대기'></td>"   '신청대기(미입금)
'         CASE "ST_2" : RE_DATA = RE_DATA & "  <td><img src='../imgs/component/icon_complete.png' alt='신청완료'></td>" '신청완료(결제완료)
'       END SELECT
          
                RE_DATA = RE_DATA & "</tr>"
        
          LRs.Movenext
        Loop
  Else
        RE_DATA = RE_DATA & "<tr class='no-data'><td colspan=10>등록된 참가신청 정보가 없습니다.</td></tr>"
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