<!--#include file="../dev/dist/config.asp"-->
<%
  '====================================================================================
  '팝업리스트 조회
  '====================================================================================
  Check_AdminLogin()
    
  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 20  '페이지내 보여지는 목록카운트  
  dim cnt       : cnt         = 0   '카운트  
      
  dim currPage      : currPage      = fInject(Request("currPage"))
  dim sido      : sido        = fInject(Request("sido"))
  dim sidogugun   : sidogugun     = fInject(Request("sidogugun")) 
  dim TeamNm      : TeamNm      = fInject(Request("TeamNm"))
  dim SearchKey   : SearchKey     = fInject(Request("SearchKey"))
  dim Searchkeyword : Searchkeyword   = fInject(Request("Searchkeyword"))
  
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
    
  IF SearchKey <>"" Then
    
    If SearchKey = "TeamNm" Then 
      CSearch2 = CSearch2 & " and TeamNm like N'%"&Searchkeyword&"%'"
    End If 

    If SearchKey = "UserName" Then 
      CSearch2 = CSearch2 & " and a.UserName like N'%"&Searchkeyword&"%'"
    End If 

    If SearchKey = "AthleteCode" Then 
      CSearch2 = CSearch2 & " and a.AthleteCode like N'%"&Searchkeyword&"%'"
    End If 

    If SearchKey = "UserPhone" Then 
      CSearch2 = CSearch2 & " and a.UserPhone like N'%"&Searchkeyword&"%'"
    End If 
  End If
  
  IF sido <>"" Then
    
    CSearch2 = CSearch2 & " and B.sido =  N'"&sido&"'"

  End If

  IF sidogugun <>"" Then
    
    CSearch2 = CSearch2 & " and B.sidogugun =  N'"&sidogugun&"'"

  End If




  CSQL = "    SELECT ISNULL(COUNT(*),0) Cnt,            " 
  CSQL = CSQL & "      CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM tblPlayerMember a                "
  CSQL = CSQL & " inner join tblTeamInfo b              "
  CSQL = CSQL & " on a.Team = b.team                  "
  CSQL = CSQL & " INNER JOIN tblSidoInfo C              "
  CSQL = CSQL & " ON B.SIDO = C.SIDO                  "
  CSQL = CSQL & " INNER JOIN tblGugunInfo D             "
  CSQL = CSQL & " ON B.sidogugun = D.GuGun              "
  CSQL = CSQL & " WHERE A.DelYN = 'N'                 "
  CSQL = CSQL & " AND B.DelYN = 'N'                 "
  CSQL = CSQL & " AND C.DelYN = 'N'                 "
  CSQL = CSQL & " AND D.DelYN = 'N'                 " &CSearch2


  'response.Write CSQL
  'Response.End 
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
  CSQL = "    SELECT  TOP "&currPage * B_PSize    
  CSQL = CSQL & "      a.MemberIDX                            "
  CSQL = CSQL & "     ,b.PTeamIDX                             "
  CSQL = CSQL & "     ,SidoNm                             "
  CSQL = CSQL & "     ,GuGunNm                              "
  CSQL = CSQL & "     ,b.team                               "
  CSQL = CSQL & "     ,b.teamnm                               "
  CSQL = CSQL & "     ,a.UserName                             "
  CSQL = CSQL & "     ,a.UserPhone                              "
  CSQL = CSQL & "     ,a.Birthday                             "
  CSQL = CSQL & "     ,case when a.Sex = 'Man' then '남성' else '여성' end sex           "
  CSQL = CSQL & "     ,a.AthleteCode                            "
  CSQL = CSQL & "     ,a.Agrade                               "
  CSQL = CSQL & "     ,a.Bgrade                               "
  CSQL = CSQL & "     ,a.Cgrade                               "
  CSQL = CSQL & "     ,case when a.EnterType ='A' then '일반' else '엘리트출신' end EnterType "
  CSQL = CSQL & "     ,a.RegTp                                "
  CSQL = CSQL & "     ,a.Photo                                "
  CSQL = CSQL & "     ,a.RegGubun                             "
  CSQL = CSQL & "     ,a.RegDate                              "
  CSQL = CSQL & "     ,a.AuthType                             "
  CSQL = CSQL & "     ,a.EditDate                             "
  CSQL = CSQL & "     ,a.WriteDate                              "
  CSQL = CSQL & " FROM tblPlayerMember a                            "
  CSQL = CSQL & " inner join tblTeamInfo b                          "
  CSQL = CSQL & " on a.Team = b.team                              "
  CSQL = CSQL & " INNER JOIN tblSidoInfo C                          "
  CSQL = CSQL & " ON B.SIDO = C.SIDO                              "
  CSQL = CSQL & " INNER JOIN tblGugunInfo D                         "
  CSQL = CSQL & " ON B.sidogugun = D.GuGun                          "
  CSQL = CSQL & " WHERE A.DelYN = 'N'                             "
  CSQL = CSQL & " AND B.DelYN = 'N'                             "
  CSQL = CSQL & " AND C.DelYN = 'N'                             "
  CSQL = CSQL & " AND D.DelYN = 'N'                             "&CSearch2
  
  
  'response.Write CSQL
  'Response.End 

  SET CRs = DBCon.Execute(CSQL)
  
  FndData = "      <table class='table-list'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>시도/구군</th>"
  FndData = FndData & "     <th>클럽명/코드</th>"
  FndData = FndData & "     <th>동호인명/코드</th>"
  FndData = FndData & "     <th>연락처</th>"
  FndData = FndData & "     <th>생년월일</th>"
  FndData = FndData & "     <th>성별</th>"
  FndData = FndData & "     <th>등록일</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
  
  IF Not(CRs.Eof Or CRs.Bof) Then 

    CRs.Move (currPage - 1) * B_PSize
    
    Do Until CRs.eof

      cnt = cnt + 1
      
      FndData = FndData & "<tr>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)"" >"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)""  align='left'>"&CRs("SidoNm")&" / "&CRs("GuGunNm")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)"" align='left'>"&CRs("Teamnm")&" / "&CRs("Team")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)"" class=""name"">"&CRs("UserName")&" / "&CRs("AthleteCode")&"</td>"  
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)"" align='left'>"&CRs("UserPhone")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)"">"&CRs("Birthday")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)"">"&CRs("Sex")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("MemberIDX")&"',1)"">"&CRs("WriteDate")&"</td>"
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