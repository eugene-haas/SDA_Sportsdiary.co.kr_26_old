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
  dim TeamNm      : TeamNm      = fInject(Request("TeamNm"))
  dim sido      : sido        = fInject(Request("sido"))
  dim sidogugun   : sidogugun     = fInject(Request("sidogugun")) 
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
    
  IF TeamNm<>"" Then
    
    CSearch2 = CSearch2 & " and TeamNm like N'%"&TeamNm&"%'"

  End If
  
  IF sido <>"" Then
    
    CSearch2 = CSearch2 & " and a.sido =  N'"&sido&"'"

  End If

  IF sidogugun <>"" Then
    
    CSearch2 = CSearch2 & " and a.sidogugun =  N'"&sidogugun&"'"

  End If
  
  CSQL = "    select                   "    
  CSQL = CSQL & "    ISNULL(COUNT(*),0) Cnt        "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/20) "
  CSQL = CSQL & " from tblteaminfo a         "
  CSQL = CSQL & " inner join tblSidoInfo b         "
  CSQL = CSQL & " on a.sido = b.sido             "
  CSQL = CSQL & " inner join tblGugunInfo c        "
  CSQL = CSQL & " on a.sidogugun = c.GuGun  where a.delyn = 'N'   "&CSearch2
  'CSQL = CSQL & "  --where TeamNm like '%"&TeamNm&"%'         "

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
  CSQL = "    SELECT TOP "&currPage * B_PSize   
  CSQL = CSQL & "  A.PTeamIDX           "
  CSQL = CSQL & " ,Team           "
  CSQL = CSQL & " ,Teamnm           "
  CSQL = CSQL & " ,SidoNm           "
  CSQL = CSQL & " ,GuGunNm          "
  CSQL = CSQL & " ,zipcode          "
  CSQL = CSQL & " ,address          "
  CSQL = CSQL & " ,addrdtl          "
  CSQL = CSQL & " ,AdminName          "
  CSQL = CSQL & " ,OwnerName          "
  CSQL = CSQL & " ,TeamRegDt          "
  CSQL = CSQL & "from tblteaminfo a   "
  CSQL = CSQL & "inner join tblSidoInfo b   "
  CSQL = CSQL & "on a.sido = b.sido     "
  CSQL = CSQL & "inner join tblGugunInfo c  "
  CSQL = CSQL & "on a.sidogugun = c.GuGun   where a.delyn = 'N'"&CSearch2
  CSQL = CSQL & "order by a.pteamidx desc "
  'response.Write CSQL
  'Response.End 

  SET CRs = DBCon.Execute(CSQL)
  
  FndData = "      <table class='table-list'>"
  FndData = FndData & " <thead>"
  FndData = FndData & "   <tr>"
  FndData = FndData & "     <th>번호</th>"
  FndData = FndData & "     <th>시도/구군</th>"
  FndData = FndData & "     <th>클럽명</th>"
  FndData = FndData & "     <th>클럽코드</th>"
  FndData = FndData & "     <th>주소</th>"
  FndData = FndData & "     <th>관리자명</th>"
  FndData = FndData & "     <th>클럽장명</th>"
  FndData = FndData & "     <th>등록일</th>"
  FndData = FndData & "   </tr>"
  FndData = FndData & " </thead>"
  FndData = FndData & " <tbody>"
  
  IF Not(CRs.Eof Or CRs.Bof) Then 

    CRs.Move (currPage - 1) * B_PSize
    
    Do Until CRs.eof

      cnt = cnt + 1
      
      FndData = FndData & "<tr>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"">"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"">"&CRs("SidoNm")&"/"&CRs("GuGunNm")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"">"&CRs("Teamnm")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"" class=""name"">"&CRs("Team")&"</td>"  
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"" align='left'>"&CRs("zipcode")&" "&CRs("address")&" "&CRs("addrdtl")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"">"&CRs("AdminName")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"">"&CRs("OwnerName")&"</td>"
      FndData = FndData & " <td onclick=""javascript:chk_Submit('VIEW','"&CRs("PTeamIDX")&"',1)"">"&CRs("TeamRegDt")&"</td>"
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