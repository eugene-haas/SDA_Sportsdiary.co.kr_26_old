
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
  if (obj.hasOwnProperty(prop) == true){
    return "ok";
  }
  else{
    return "notok";
  }
}
</script>
<%
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  Const const_Empty = "empty"
  REQ = Request("Req")
  'REQ = "{""CMD"":2,""tGameTitleIDX"":"""",""tGroupGameGb"":""B0030001"",""tTeamGb"":""empty"",""tSex"":""empty"",""tPlayType"":""empty"",""tLevelJooName"":""empty"",""tLevel"":""empty"",""tPlayLevelType"":""empty"",""tStadiumIDX"":"""",""tStartCourt"":"""",""tEndCourt"":""""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = const_Empty
      DEC_GameTitleIDX = const_Empty
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if 

  If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = 0
      DEC_StadiumIDX = 0
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))    
    End If
  End if 

   If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    If ISNull(oJSONoutput.tGroupGameGb) Or oJSONoutput.tGroupGameGb = "" Then
      GroupGameGb = const_Empty
      DEC_GroupGameGb = const_Empty
    Else
      GroupGameGb = fInject(oJSONoutput.tGroupGameGb)
      DEC_GroupGameGb =  fInject(oJSONoutput.tGroupGameGb)
    End If
  Else
    GroupGameGb = const_Empty
    DEC_GroupGameGb = const_Empty
  End if 

  If hasown(oJSONoutput, "tTeamGb") = "ok" then
    If ISNull(oJSONoutput.tTeamGb) Or oJSONoutput.tTeamGb = "" Then
      TeamGb = const_Empty
      DEC_TeamGb = const_Empty
    Else
      TeamGb = fInject(oJSONoutput.tTeamGb)
      DEC_TeamGb =  fInject(oJSONoutput.tTeamGb)
    End If
  Else
    TeamGb = const_Empty
    DEC_TeamGb = const_Empty
  End if 
  
  
  If hasown(oJSONoutput, "tLevelJooName") = "ok" then
    If ISNull(oJSONoutput.tLevelJooName) Or oJSONoutput.tLevelJooName = "" Then
      LevelJooName = const_Empty
      DEC_LevelJooName = const_Empty
    Else
      LevelJooName = fInject(oJSONoutput.tLevelJooName)
      DEC_LevelJooName =  fInject(oJSONoutput.tLevelJooName)   
    End If
    Else
      LevelJooName = const_Empty
      DEC_LevelJooName = const_Empty
  End if

  If hasown(oJSONoutput, "tLevel") = "ok" then
    If ISNull(oJSONoutput.tLevel)  Then
      Level = const_Empty
      DEC_Level = const_Empty
    Else
      Level = fInject(oJSONoutput.tLevel)
      DEC_Level =  fInject(oJSONoutput.tLevel)   
    End If
  Else
    Level = const_Empty
    DEC_Level = const_Empty
  End if
   

   If hasown(oJSONoutput, "tPlayLevelType") = "ok" then
    If ISNull(oJSONoutput.tPlayLevelType) Or oJSONoutput.tPlayLevelType = "" Then
      PlayLevelType = const_Empty
      DEC_PlayLevelType =const_Empty
    Else
      PlayLevelType = fInject(oJSONoutput.tPlayLevelType)
      DEC_PlayLevelType =  fInject(oJSONoutput.tPlayLevelType)   
    End If
  Else
    PlayLevelType = const_Empty
    DEC_PlayLevelType =const_Empty
  End if

  If hasown(oJSONoutput, "tStartCourt") = "ok" then
    If ISNull(oJSONoutput.tStartCourt) Or oJSONoutput.tStartCourt = "" Then
      StartCourt = ""
      DEC_StartCourt =""
    Else
      StartCourt = fInject(oJSONoutput.tStartCourt)
      DEC_StartCourt =  fInject(oJSONoutput.tStartCourt)   
    End If
  Else
    StartCourt = ""
    DEC_StartCourt =""
  End if

  If hasown(oJSONoutput, "tEndCourt") = "ok" then
    If ISNull(oJSONoutput.tEndCourt) Or oJSONoutput.tEndCourt = "" Then
      EndCourt = ""
      DEC_EndCourt =""
    Else
      EndCourt = fInject(oJSONoutput.tEndCourt)
      DEC_EndCourt =  fInject(oJSONoutput.tEndCourt)   
    End If
  Else
    EndCourt = ""
    DEC_EndCourt =""
  End if

  If hasown(oJSONoutput, "tSex") = "ok" then
    If ISNull(oJSONoutput.tSex) Or oJSONoutput.tSex = "" Then
      Sex = const_Empty
      DEC_Sex =const_Empty
    Else
      Sex = fInject(oJSONoutput.tSex)
      DEC_Sex =  fInject(oJSONoutput.tSex)   
    End If
  Else
    Sex = const_Empty
    DEC_Sex  const_Empty
  End if

  If hasown(oJSONoutput, "tPlayType") = "ok" then
    If ISNull(oJSONoutput.tPlayType) Or oJSONoutput.tPlayType = "" Then
      PlayType = const_Empty
      DEC_PlayType = const_Empty
    Else
      PlayType = fInject(oJSONoutput.tPlayType)
      DEC_PlayType =  fInject(oJSONoutput.tPlayType)   
    End If
  Else
    PlayType = const_Empty
    DEC_PlayType = const_Empty
  End if


  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  
%>       

 <ul>
    <li>
        <div class="l-name">경기구분</div>
        <div class="r-con">
        <%
          LSQL = " SELECT GroupGameGb, ISNULL(GroupGameGbNM,'') AS GroupGameGbNM  "
          LSQL = LSQL & " FROM "
          LSQL = LSQL & " ("
          LSQL = LSQL & " SELECT C.GroupGameGb,dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM"
          LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON C.GameLevelidx = B.GameLevelidx AND C.DelYN ='N'  "
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
          LSQL = LSQL & " "
          LSQL = LSQL & " UNION ALL"
          LSQL = LSQL & " "
          LSQL = LSQL & " SELECT C.GroupGameGb,dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM"
          LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON C.GameLevelidx = B.GameLevelidx AND C.DelYN ='N'  "
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
          LSQL = LSQL & " ) AS AA"
          LSQL = LSQL & " WHERE AA.GroupGameGb <> ''"
          LSQL = LSQL & " GROUP BY AA.GroupGameGb,AA.GroupGameGbNM"
          'Response.Write "LSQL" & LSQL & "<BR/>"
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
          %>
           
          <%
            Do Until LRs.Eof
            tGroupGameGbNM =LRs("GroupGameGbNM")
            tGroupGameGb =LRs("GroupGameGb")

            IF tGroupGameGbNM ="" Then
              tGroupGameGbNM ="Null"
            End IF

            %>
            <a href="javascript:OnGroupGameGbChanged('<%=tGroupGameGb%>','<%=tGroupGameGbNM%>')"  <%If tGroupGameGb = DEC_GroupGameGb Then%> class="active" <%End IF%> ><%=tGroupGameGbNM%></a>
            <%
              LRs.MoveNext
            Loop
            %>
            <span class="code-box">
              <input type="text"  id="txtStartCourt" value="<%=DEC_StartCourt%>"onchange="javascript:OnStartCourtChanged(this.value);"/>
              <span class="txt">코트 ~</span>
              <input type="text" id="txtEndCourt" value="<%=DEC_EndCourt%>" onchange="javascript:OnEndCourtChanged(this.value);"/>
              <span class="txt" >코트</span>
					  </span>
        <%
          ELSE
        %>
          <span style="font-weight:bold;">등록된 경기구분이 없습니다.</span>
        <%
          End If
          LRs.Close
        %>
      </div>
    </li>
    <li>
      <div class="l-name">종목</div>
      <div class="r-con">
      <%
        LSQL = " SELECT TeamGb, ISNULL(TeamGbNm,'') AS TeamGbNm "
        LSQL = LSQL & " FROM "
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT A.TeamGb, D.TeamGbNm"
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " Left Join KoreaBadminton.dbo.tblTeamGbInfo D ON A.TeamGb = D.TeamGb AND D.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
        IF DEC_GroupGameGb <> "empty" Then
        LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF
        LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT A.TeamGb, D.TeamGbNm"
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " Left Join KoreaBadminton.dbo.tblTeamGbInfo D ON A.TeamGb = D.TeamGb AND D.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND B.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
        IF DEC_GroupGameGb <> "empty" Then
          LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF
        LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " WHERE AA.TeamGb <> ''"
        LSQL = LSQL & "    GROUP BY AA.TeamGb,AA.TeamGbNm"
        'Response.Write "LSQL" & LSQL & "<BR/>"
        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          tTeamGbNm =LRs("TeamGbNm")
          tTeamGb =LRs("TeamGb")

          IF tTeamGbNm ="" Then
            tTeamGbNm ="Null"
          End IF
          %>
          <a href="javascript:OnTeamGbChanged('<%=tTeamGb%>','<%=tTeamGbNm%>');" <%If tTeamGb = DEC_TeamGb Then%> class="active" <%End IF%>><%=tTeamGbNm%></a>
          <%
            LRs.MoveNext
          Loop
        ELSE
        %>
          <span style="font-weight:bold;">등록된 종목이 없습니다.</span>
        <%            
        End If
        LRs.Close
      %>
      </div>
    </li>

    <li>
      <div class="l-name">종목구분</div>
      <div class="r-con">
      <%
        LSQL = " SELECT Sex, dbo.FN_NameSch(Sex, 'PubCode') AS SexNM, PlayType, dbo.FN_NameSch(PlayType, 'PubCode') AS PlayTypeNM "
        LSQL = LSQL & " FROM "
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT B.Sex, B.PlayType "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
        IF DEC_GroupGameGb <> "empty" Then
        LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF

        IF DEC_TeamGb <> "empty" Then
          LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
        End IF
        
        LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT B.Sex, B.PlayType "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

        IF DEC_GroupGameGb <> "empty" Then
          LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF

        IF DEC_TeamGb <> "empty" Then
          LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
        End IF

        LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " WHERE AA.PlayType <> '' And AA.Sex <> ''"
        LSQL = LSQL & "  GROUP BY AA.Sex,AA.PlayType"
        'Response.Write "LSQL" & LSQL & "<BR/>"
        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          rSex =LRs("Sex")
          rSexNM =LRs("SexNM")
          rPlayType =LRs("PlayType")
          rPlayTypeNM =LRs("PlayTypeNM")
          %>
          <a href="javascript:OnSexPlayTypeChanged('<%=rSex%>','<%=rSexNM%>','<%=rPlayType%>','<%=rPlayTypeNM%>');" <%If rSex = DEC_Sex And rPlayType = DEC_PlayType Then%> class="active" <%End IF%>><%Response.Write Left(rSexNM,1) & Left(rPlayTypeNM,1) %></a>
          <%
            LRs.MoveNext
          Loop
        ELSE
        %>
          <span style="font-weight:bold;">등록된 종목이 없습니다.</span>
        <%            
        End If
        LRs.Close
      %>
      </div>
    </li>


    <li>
      <div class="l-name">급수</div>
      <div class="r-con">
        <%
          LSQL = "  SELECT LevelJooName, ISNULL(LevelJooNameNM,'') AS LevelJooNameNM, OrderBy"
          LSQL = LSQL & " FROM "
          LSQL = LSQL & " ("
          LSQL = LSQL & " SELECT B.LevelJooName,E.PubName AS LevelJooNameNM, E.OrderBy"
          LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
          LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
          LSQL = LSQL & " Left Join tblPubcode E ON B.LevelJooName = E.PubCode AND E.DelYN ='N'"
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

          IF DEC_GroupGameGb <> "empty" Then
            LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
          End IF

          IF DEC_TeamGb <> "empty" Then
            LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
          End IF
            
          IF DEC_Sex <> "empty" Then
            LSQL = LSQL & " AND B.Sex = '" & DEC_Sex & "'"
          End IF

          IF DEC_PlayType <> "empty" Then
            LSQL = LSQL & " AND B.PlayType = '" & DEC_PlayType & "'"
          End IF

          LSQL = LSQL & " "
          LSQL = LSQL & " UNION ALL"
          LSQL = LSQL & " "
          LSQL = LSQL & " SELECT B.LevelJooName,E.PubName AS LevelJooNameNM, E.OrderBy"
          LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
          LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
          LSQL = LSQL & " Left Join tblPubcode E ON B.LevelJooName = E.PubCode AND E.DelYN ='N'"
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

          IF DEC_GroupGameGb <> "empty" Then
            LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
          End IF

          IF DEC_TeamGb <> "empty" Then
            LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
          End IF

          IF DEC_Sex <> "empty" Then
            LSQL = LSQL & " AND B.Sex = '" & DEC_Sex & "'"
          End IF

          IF DEC_PlayType <> "empty" Then
            LSQL = LSQL & " AND B.PlayType = '" & DEC_PlayType & "'"
          End IF
          LSQL = LSQL & " ) AS AA"
          LSQL = LSQL & " GROUP BY AA.LevelJooName, AA.LevelJooNameNM, AA.OrderBy"
          LSQL = LSQL & " Order by OrderBy "
          
          'Response.Write "LSQL" & LSQL & "<BR/>"
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            tLevelJooNameNM=LRs("LevelJooNameNM")
            tLevelJooName=LRs("LevelJooName")

            IF tLevelJooNameNM ="" Then
              tLevelJooNameNM = "미선택"
            End if
            %>
            <a href="javascript:OnLevelJooNameChanged('<%=tLevelJooName%>','<%=tLevelJooNameNM%>');" <%If tLevelJooName = DEC_LevelJooName Then%> class="active" <%End IF%>><%=tLevelJooNameNM%></a>
            <%
              LRs.MoveNext
            Loop
          Else
          %>
            <span style="font-weight:bold;">등록된 급수가 없습니다.</span>
          <%            
          End If
          LRs.Close
        %>
      </div>
    </li>
    <li>  
      <div class="l-name">종별</div>
      <div class="r-con">
    <%
      LSQL = "   SELECT Level, ISNULL(LevelNm,'') AS LevelNm "
      LSQL = LSQL & " FROM "
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT  B.Level ,E.LevelNm "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
      LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
      LSQL = LSQL & " Left Join tblLevelInfo E ON B.Level = E.Level AND E.DelYN ='N'"
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF DEC_GroupGameGb <> "empty" Then
        LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
      End IF

      IF DEC_TeamGb <> "empty" Then
        LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
      End IF

      IF DEC_Sex <> "empty" Then
        LSQL = LSQL & " AND B.Sex = '" & DEC_Sex & "'"
      End IF

      IF DEC_PlayType <> "empty" Then
        LSQL = LSQL & " AND B.PlayType = '" & DEC_PlayType & "'"
      End IF

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT  B.Level ,E.LevelNm"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
      LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
      LSQL = LSQL & " Left Join tblLevelInfo E ON B.Level = E.Level AND E.DelYN ='N'"
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
       IF DEC_GroupGameGb <> "empty" Then
        LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
      End IF

      IF DEC_TeamGb <> "empty" Then
        LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
      End IF

      IF DEC_Sex <> "empty" Then
        LSQL = LSQL & " AND B.Sex = '" & DEC_Sex & "'"
      End IF

      IF DEC_PlayType <> "empty" Then
        LSQL = LSQL & " AND B.PlayType = '" & DEC_PlayType & "'"
      End IF

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY  AA.Level ,AA.LevelNm"
      'LSQL = LSQL & " Order BY  AA.Level ,AA.LevelNm"
      'Response.Write "LSQL" & LSQL & "<BR/>"
      'Response.End
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tLevelNm=LRs("LevelNm")
        tLevel=LRs("Level")
        IF tLevelNm ="" Then
          tLevelNm = "미선택"
        End if
        %>
         <a href="javascript:OnLevelChanged('<%=tLevel%>','<%=tLevelNm%>');" <%If tLevel = DEC_Level Then%> class="active" <%End IF%> ><%=tLevelNm%></a>
        <%
          LRs.MoveNext
        Loop
      Else
      %>
        <span style="font-weight:bold;">등록된 종별이 없습니다.</span>
      <%
      End If
      LRs.Close
    %>
      </div>
    </li>
  
    <li>
      <div class="l-name">경기유형</div>
      <div class="r-con">
    <%
      LSQL = " SELECT PlayLevelType, ISNULL(PlayLevelTypeNM,'') AS PlayLevelTypeNM "
      LSQL = LSQL & " FROM "
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT C.PlayLevelType, E.PubName AS PlayLevelTypeNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
      LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
      LSQL = LSQL & " Left Join tblPubcode E ON C.PlayLevelType = E.PubCode AND E.DelYN ='N' "
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF DEC_GroupGameGb <> "empty" Then
        LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
      End IF

      IF DEC_TeamGb <> "empty" Then
        LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
      End IF

      IF DEC_Sex <> "empty" Then
        LSQL = LSQL & " AND B.Sex = '" & DEC_Sex & "'"
      End IF

      IF DEC_PlayType <> "empty" Then
        LSQL = LSQL & " AND B.PlayType = '" & DEC_PlayType & "'"
      End IF

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT C.PlayLevelType, E.PubName AS PlayLevelTypeNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
      LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
      LSQL = LSQL & " Left Join tblPubcode E ON C.PlayLevelType = E.PubCode AND E.DelYN ='N'"
      LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF DEC_GroupGameGb <> "empty" Then
        LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
      End IF

      IF DEC_TeamGb <> "empty" Then
        LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
      End IF

      IF DEC_Sex <> "empty" Then
        LSQL = LSQL & " AND B.Sex = '" & DEC_Sex & "'"
      End IF

      IF DEC_PlayType <> "empty" Then
        LSQL = LSQL & " AND B.PlayType = '" & DEC_PlayType & "'"
      End IF

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY  AA.PlayLevelType ,AA.PlayLevelTypeNM"
      'Response.Write "LSQL" & LSQL & "<BR/>"
      'Dim FullGame : FullGame = "N"
      'Dim tPlayLevelType  : tPlayLevelType  = ""
      'Dim FullPlayLevelType : FullPlayLevelType = "B0100003"
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof

        'IF (tPlayLevelType = "B0100001") And (LRs("PlayLevelType") = "B0100002") Then '전값이 예선이면서 본선이 들어오면
        '  FullGame = "Y"
        'End IF

        tPlayLevelTypeNM = LRs("PlayLevelTypeNM")
        tPlayLevelType = LRs("PlayLevelType")

        IF tPlayLevelTypeNM ="" Then
          tPlayLevelTypeNM = "미선택"
        End if

        %>
        <a href="javascript:OnPlayLevelTypeChanged('<%=tPlayLevelType%>','<%=tPlayLevelTypeNM%>');"<%If tPlayLevelType = DEC_PlayLevelType Then%> class="active" <%End IF%>><%=tPlayLevelTypeNM%></a>
        <%
          LRs.MoveNext
        Loop
        Else
          %>
            <span style="font-weight:bold;">등록된 경기유형이 없습니다.</span>
          <%
      End If
      LRs.Close

      'IF FullGame = "Y" Then
      %>
        <!--<a href="javascript:OnPlayLevelTypeChanged('<%=FullPlayLevelType%>');"<%If FullPlayLevelType = DEC_PlayLevelType Then%> class="active" <%End IF%>><%Response.Write "예선 + 본선"%></a>-->
      <%
      'End IF
    %>
    </div>
    </li>
    <li>
    <div class="l-name">경기장</div>
    <div class="r-con">
      <%
          LSQL = " SELECT StadiumIDX ,GameTitleIDX ,StadiumName ,StadiumCourt ,StadiumTime ,StadiumAddr ,StadiumAddrDtl "
          LSQL = LSQL & " FROM tblStadium A "
          LSQL = LSQL & " Where A.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
          
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            r_StadiumIDX = LRs("StadiumIDX")
            crypt_StadiumIDX = crypt.EncryptStringENC(r_StadiumIDX)
            r_StadiumName = LRs("StadiumName")
            IF LEN(r_StadiumName) > 6 Then
              r_StadiumName = Left(r_StadiumName,4) & ".."
            End IF
            r_StadiumCourt = LRs("StadiumCourt")
            %>
            <a href="javascript:OnStadiumChanged('<%=crypt_StadiumIDX%>','<%=r_StadiumName%>');"<%If CDBL(r_StadiumIDX) = CDBL(DEC_StadiumIDX) Then%> class="active" <%End IF%>><%=r_StadiumName%></a>
            <%
              LRs.MoveNext
            Loop
          Else
          %>
            <span style="font-weight:bold;">등록된 경기장이 없습니다.</span>
          <%
          End If            
          LRs.Close    
        %>
      </div>
    </li>
  </ul>
<%
  DBClose()
%>
  
