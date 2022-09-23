
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
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""A0B63180CC3215B403232E31C8E393B4"",""tTeamGb"":""16001"",""tLevelJooName"":""B0110007"",""tLevel"":"""",""tPlayLevelType"":""empty""}"
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
   
   

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  
%>       

<div>

    <div> 
        <span>구분</span>
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
            Do Until LRs.Eof
            tGroupGameGbNM =LRs("GroupGameGbNM")
            tGroupGameGb =LRs("GroupGameGb")

            IF tGroupGameGbNM ="" Then
              tGroupGameGbNM ="Null"
            End IF

            %>
              <input type="radio" id="radioGroupGameGb<%=tGroupGameGb%>" name="radioGroupGameGb" value="<%=tGroupGameGb%>"
              
             <%If tGroupGameGb = DEC_GroupGameGb Then%> Checked <%End IF%>/>
              <label for="radioGroupGameGb<%=tGroupGameGb%>"><%=tGroupGameGbNM%></label>
            <%
              LRs.MoveNext
            Loop
          End If
          LRs.Close
        %>
        </div>
      <br/>
      
    <span>종목</span>
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
          <input type="radio" id="radioTeamGB<%=tTeamGb%>" name="radioTeamGB" value="<%=tTeamGb%>" 
          <%If tTeamGb = DEC_TeamGb Then%> Checked <%End IF%>/>
          <label for="radioTeamGB<%=tTeamGb%>"><%=tTeamGbNm%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>
  <br/>
  <div>
    <span>급수</span>
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

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF

      IF DEC_PlayLevelType <> "empty" Then
        LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
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

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF

      IF DEC_PlayLevelType <> "empty" Then
        LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
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
        <input type="radio" id="radioLevelJooName<%=tLevelJooName%>" name="radioLevelJooName" value="<%=tLevelJooName%>"  
        <%If tLevelJooName = DEC_LevelJooName Then%> Checked <%End IF%>/>
          <label for="radioLevelJooName<%=tLevelJooName%>"><%=tLevelJooNameNM%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>
  <br/>
  <div>
    <span>종별</span>
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

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF

      IF DEC_PlayLevelType <> "empty" Then
        LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
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

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF

      IF DEC_PlayLevelType <> "empty" Then
        LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
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
          <input type="radio" id="radioLevel<%=tLevel%>" name="radioLevel" value="<%=tLevel%>"
          <%If tLevel = DEC_Level Then%> Checked <%End IF%>
          />
          <label for="radioLevel<%=tLevel%>"><%=tLevelNm%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>
  <br/>
  <div>
    <span>경기구분</span>
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

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF

      IF DEC_PlayLevelType <> "empty" Then
        LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
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

      IF DEC_LevelJooName <> "empty" Then
        LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
      End IF

      IF DEC_Level <> "empty" Then
        LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
      End IF

      IF DEC_PlayLevelType <> "empty" Then
        LSQL = LSQL & " AND C.PlayLevelType = '" & DEC_PlayLevelType & "'"
      End IF
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY  AA.PlayLevelType ,AA.PlayLevelTypeNM"
      'Response.Write "LSQL" & LSQL & "<BR/>"
      
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tPlayLevelTypeNM=LRs("PlayLevelTypeNM")
        tPlayLevelType=LRs("PlayLevelType")
        IF tPlayLevelTypeNM ="" Then
          tPlayLevelTypeNM = "미선택"
        End if
        %>
           <input type="radio" id="radioPlayLevelType<%=tPlayLevelType%>" name="radioPlayLevelType" value="<%=tPlayLevelType%>"
            <%If tPlayLevelType = DEC_PlayLevelType Then%> Checked <%End IF%>
           />
          <label for="radioPlayLevelType<%=tPlayLevelType%>"><%=tPlayLevelTypeNM%></label>
        <%
          LRs.MoveNext
        Loop
      End If
      LRs.Close
    %>
  </div>

<div id="divStadium" name="divStadium">
<span>장소 리스트</span>
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
      r_StadiumCourt = LRs("StadiumCourt")
      %>
      <button onClick="javascript:SetGameScheduleStadium('<%=crypt_StadiumIDX%>');"><%=r_StadiumName%></button>
      <%
        LRs.MoveNext
      Loop
    End If            

    LRs.Close    
  %>

</div>

<%
  DBClose()
%>
  
