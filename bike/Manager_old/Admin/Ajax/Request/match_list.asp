<!--#include file="../../dev/dist/config.asp"-->
<%
  '===========================================================================================
  '참가신청 대회정보 리스트 조회페이지
  '===========================================================================================
  dim valDate       : valDate       = Date() 
  dim BlockPage     : BlockPage       = 10    '페이지
  dim B_PSize       : B_PSize       = 30    '페이지내 보여지는 목록카운트  
  dim currPage      : currPage        = fInject(Request("currPage"))
  dim fnd_Year      : fnd_Year        = fInject(Request("fnd_Year"))
  dim fnd_EnterType   : fnd_EnterType     = fInject(Request("fnd_EnterType"))
  dim fnd_KeyWord     : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))                      

                     
  dim RE_COUNTP, RE_DATA, RE_PAGE
    dim TotCount, TotPage, cnt
    dim CSearch, CSearch2, CSearch3
    
    IF Len(currPage) = 0 Then currPage = 1
    IF fnd_Year = "" Then fnd_Year = Year(Date())
  CSearch = " AND GameS like '"&fnd_Year&"%'" '개최년도 조회
   
    IF fnd_KeyWord <> "" Then CSearch2 = " AND GameTitleName like '%"&fnd_KeyWord&"%'"
  IF fnd_EnterType <> "" Then CSearch3 = " AND EnterType = '"&fnd_EnterType&"'"
    
  LSQL = "    SELECT ISNULL(COUNT(*),0) Cnt"
  LSQL = LSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&")" 
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitle]"
  LSQL = LSQL & " WHERE DelYN = 'N'"
  LSQL = LSQL & "   AND ViewYN = 'Y'"&CSearch&CSearch2&CSearch3
                    
' response.Write LSQL
  
  SET LRs = DBCon.Execute(LSQL) 
    TotalCount = formatnumber(LRs(0), 0)
    TotalPage = LRs(1)
   
  RE_COUNTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
  RE_COUNTP = RE_COUNTP & "<span>"&currPage &" page / " & TotalPage & " pages"
  RE_COUNTP = RE_COUNTP & "</span></div>"
   
  RE_DATA = "<table class='table-list'>"
  RE_DATA = RE_DATA & " <thead>"
  RE_DATA = RE_DATA & "   <tr>"
  RE_DATA = RE_DATA & "   <th>년도</th>"
  RE_DATA = RE_DATA & "   <th>대회기간</th>"
  RE_DATA = RE_DATA & "   <th>모집상태</th>"
  RE_DATA = RE_DATA & "   <th>구분</th>"  
  RE_DATA = RE_DATA & "   <th>대회구분</th>"      
  RE_DATA = RE_DATA & "   <th>대회명</th>"
  RE_DATA = RE_DATA & "   <th>개최장소</th>"
  RE_DATA = RE_DATA & "   <th>신청기간</th>"
  RE_DATA = RE_DATA & "   <th>신청현황</th>"
  RE_DATA = RE_DATA & "   </tr>"
  RE_DATA = RE_DATA & " </thead>"
  RE_DATA = RE_DATA & "<tbody>"


  LSQL = "    SELECT TOP "&currPage * B_PSize 
  LSQL = LSQL & "   GameTitleIDX"
  LSQL = LSQL & "   ,CASE GameGb WHEN 'B0010001' THEN '국내대회' ELSE '국제대회' END GameGbType"
  LSQL = LSQL & "   ,GameTitleName"
  LSQL = LSQL & "   ,EnterType" 
  LSQL = LSQL & "   ,LEFT(GameS, 4) + '년' GameStartYear"
  LSQL = LSQL & "   ,SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameS), 102),6, 5) GameS"
  LSQL = LSQL & "   ,SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameE), 102),6, 5) GameE"
  LSQL = LSQL & "   ,SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameS), 102),6, 5) + ' ~ ' + SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameE), 102),6, 5) GameDate"
  LSQL = LSQL & "   ,SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameRcvDateS), 102),6, 5) GameRcvDateS"
  LSQL = LSQL & "   ,SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameRcvDateE), 102),6, 5) GameRcvDateE"
  LSQL = LSQL & "   ,SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameRcvDateS), 102),6, 5) + ' ~ ' + SUBSTRING(CONVERT(CHAR(10), CONVERT(DATE, GameRcvDateE), 102),6, 5) GameRcvDate"
  LSQL = LSQL & "   ,GameRcvHourS"
  LSQL = LSQL & "   ,GameRcvHourE"
  LSQL = LSQL & "   ,GameRcvMinuteE"
  LSQL = LSQL & "   ,TeamType"
  LSQL = LSQL & "   ,ViewYN"
  LSQL = LSQL & "   ,HostCode"
  LSQL = LSQL & "   ,[KoreaBadminton].[dbo].[FN_SidoName](Sido) + '/' + GamePlace GamePlaceNm"
  LSQL = LSQL & "   ,CASE WHEN DATEDIFF(d, CONVERT(DATE, GameRcvDateS), '"&valDate&"')>=0 AND DATEDIFF(d, '"&valDate&"', CONVERT(DATE, GameRcvDateE))>=0 THEN 0 ELSE CASE WHEN DATEDIFF(d, CONVERT(DATE, GameRcvDateS), '"&valDate&"')<0 THEN 1 ELSE 2 END END StartOnRcvType"  '--참가신청 기간 0:신청중 1:대기 2:마감
  LSQL = LSQL & "   ,CASE "
  LSQL = LSQL & "     WHEN DATEDIFF(d, CONVERT(DATE, GameRcvDateS), '"&valDate&"')>=0 AND DATEDIFF(d, '"&valDate&"', CONVERT(DATE, GameRcvDateE))>=0 THEN '신청중'"
  LSQL = LSQL & "   ELSE "
  LSQL = LSQL & "     CASE "
  LSQL = LSQL & "       WHEN DATEDIFF(d, CONVERT(DATE, GameRcvDateS), '"&valDate&"')<0 THEN  '대기'"
  LSQL = LSQL & "     ELSE '마감'"
  LSQL = LSQL & "     END"
  LSQL = LSQL & "   END StartOnRcvTypeNm"   
  LSQL = LSQL & "   ,CASE WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 THEN"
  LSQL = LSQL & "     CASE WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 AND DATEDIFF(d, '"&valDate&"', CONVERT(DATE, GameE))>=0 THEN 0 ELSE 2 END ELSE 1 END StateGameType" '--경기진행상태 0:진행중 1:대기 2:경기종료
  LSQL = LSQL & "   ,CASE WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 THEN"
  LSQL = LSQL & "     CASE WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 AND DATEDIFF(d, '"&valDate&"', CONVERT(DATE, GameE))>=0 THEN '진행중' ELSE '종료' END"
  LSQL = LSQL & "   ELSE 'D' + CONVERT(CHAR(10), DATEDIFF(d, GameS, '"&valDate&"')) END StateGameTypeNm"  '--경기진행상태
  LSQL = LSQL & "   ,DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"') StartOnGameDate"    '--대회전 일수
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitle] A"
  LSQL = LSQL & " WHERE DelYN = 'N'"
  LSQL = LSQL & "   AND ViewYN = 'Y'"&CSearch&CSearch2&CSearch3                     '--대회노출                 
  LSQL = LSQL & " ORDER BY StartOnRcvType ASC, StateGameType ASC, GameRcvDateS ASC, GameS ASC"    
  
 '' response.Write LSQL
  
  SET LRs = DBCon.Execute(LSQL)
  IF Not(LRs.Eof OR LRs.Bof) Then
    
    LRs.Move (currPage - 1) * B_PSize
    
    Do Until LRs.Eof 
      cnt = cnt + 1

      RE_DATA = RE_DATA & "<tr>"
      RE_DATA = RE_DATA & " <td>"&LRs("GameStartYear")&"</td>"
      RE_DATA = RE_DATA & " <td>"&LRs("GameDate")&"</td>"
      RE_DATA = RE_DATA & " <td>"&LRs("StartOnRcvTypeNm")&"</td>"
      RE_DATA = RE_DATA & " <td>"&LRs("GameGbType")&"</td>"
      RE_DATA = RE_DATA & " <td>"&LRs("EnterType")&"</td>"
      RE_DATA = RE_DATA & " <td class='match_name'><span class='txt'>"&ReHtmlSpecialChars(LRs("GameTitleName"))&"</span></td>"
      RE_DATA = RE_DATA & " <td class='match_place'><span class='txt'>"&ReHtmlSpecialChars(LRs("GamePlaceNm"))&"</span></td>"
      RE_DATA = RE_DATA & " <td>"&LRs("GameRcvDate")&"</td>"
      RE_DATA = RE_DATA & " <td><a href=""javascript:chk_Submit('STATE', '"&crypt.EncryptStringENC(LRs("GameTitleIDX"))&"', '"&currPage&"');"" class='btn btn-confirm'>참가현황조회</a> <a href=""javascript:chk_Submit('RECEIVE', '"&crypt.EncryptStringENC(LRs("GameTitleIDX"))&"', '"&currPage&"');"" class='btn btn-search'>신청접수조회</a></td>"
      RE_DATA = RE_DATA & "</tr>"
      
          LRs.MoveNext
      Loop     
    Else
    RE_DATA = RE_DATA & "<tr class='no-data'><td colspan='9'>등록된 대회정보가 없습니다.</td></tr>"
    End IF 
      LRs.Close
    SET LRs = Nothing     
    
  RE_DATA = RE_DATA & " </tbody>"
    RE_DATA = RE_DATA & "</table>"    
  
  dim intTemp
  dim intLoop : intLoop = 1

  intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
    
  
  RE_PAGE = RE_PAGE & "<div class='page_index'>"
    RE_PAGE = RE_PAGE & " <ul class='pagination'>"

  IF intTemp = 1 Then
    IF currPage = 1 Then
      RE_PAGE = RE_PAGE & "<li class='page-item'><a href='javascript:' class='page-link' title='이전 "&BlockPage&"페이지'><span class='ic_deco'><i class='fas fa-angle-double-left'></i></span></a></li>"
      RE_PAGE = RE_PAGE & "<li class='page-item'><a href='javascript:' class='page-link' title='이전페이지'><span class='ic_deco'><i class='fas fa-angle-left'></i></span></span></a></li>"
    Else
      RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','',1);"" class='page-link' title='이전 "&BlockPage&"페이지'><span class='ic_deco'><i class='fas fa-angle-double-left'></i></span></a></li>"
      RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','','"&currPage-1&"');"" class='page-link' title='이전페이지'><span class='ic_deco'><i class='fas fa-angle-left'></i></span></a></li>"
    End IF
  Else
    RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','',1);"" class='page-link' title='이전 "&BlockPage&"페이지'><span class='ic_deco'><i class='fas fa-angle-double-left'></i></span></a></li>"
    RE_PAGE = RE_PAGE & "<li class='page-item'><a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');"" class='page-link' title='이전페이지'><span class='ic_deco'><i class='fas fa-angle-left'></i></span></a></li>"
  End IF

  Do Until intLoop > BlockPage OR intTemp > TotalPage

    IF intTemp = CInt(currPage) Then
      RE_PAGE = RE_PAGE & "<li class=""page-item active""><a href=""javascript:"" class='page-link'><span class='ic_deco'>"&intTemp&"</span></a></li>"
    Else
      RE_PAGE = RE_PAGE & "<li class=""page-item""><a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" class='page-link'><span class='ic_deco'>"&intTemp&"</span></a></li>"
    End If

    intTemp = intTemp + 1
    intLoop = intLoop + 1 

  Loop  

  IF intTemp > TotalPage Then
    IF cint(currPage) < cint(TotalPage) Then
      RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&currPage+1&"');"" aria-label='Next' title='다음페이지'><span class='ic_deco'><i class='fas fa-angle-right'></i></span></a></li>"
      RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&TotalPage&"');"" aria-label='Next' title='다음 "&BlockPage&"페이지'><span class='ic_deco'><i class='fas fa-angle-dobule-right'></i></span></a></li>"
    Else
      RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href='javascript:' aria-label='Next' title='다음페이지'><span class='ic_deco'><i class='fas fa-angle-right'></i></span></a></li>"
      RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href='javascript:' aria-label='Next' title='다음 "&BlockPage&"페이지'><span class='ic_deco'><i class='fas fa-angle-double-right'></i></span></a></li>"
    End IF
  Else
    RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" aria-label='Next' title='다음페이지'><span class='ic_deco'><i class='fas fa-angle-right'></i></span></a></li>"
    RE_PAGE = RE_PAGE & "<li class='page-item'><a class='page-link' href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" aria-label='Next' title='다음 "&BlockPage&"페이지'><span class='ic_deco'><i class='fas fa-angle-double-right'></i></span></a></li>"
  End IF 
    
  RE_PAGE = RE_PAGE & " </ul>"
    RE_PAGE = RE_PAGE & "</div>"
    
  response.Write RE_COUNTP  '카운트/페이지
  response.Write RE_DATA  '목록 테이블
    
  IF TotalCount > 0 Then response.Write RE_PAGE '페이징
    
    DBClose()
%>