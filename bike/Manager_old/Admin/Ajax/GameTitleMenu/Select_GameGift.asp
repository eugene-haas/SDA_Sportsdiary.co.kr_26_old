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
  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tGameTitleIDX"":""C4F45D4766A741AF49900107ACE44658"",""tGameDay"":"""",""tStadiumIDX"":"""",""tSearchName"":"""",""tPlayLevelType"":"""",""tGroupGameGB"":"""",""tTotalClass"":""Mix|B0020001|22005||B0110001|""}"
  Set oJSONoutput = JSON.Parse(REQ)


  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
    DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  Else  
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
  End if	

	If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(crypt.DecryptStringENC(oJSONoutput.tGameDay))    
    End If
  Else  
    GameDay = ""
    DEC_GameDay = ""
	End if	

	If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))    
    End If
  Else  
    StadiumIDX = ""
    DEC_StadiumIDX = ""
	End if	

	If hasown(oJSONoutput, "tStadiumNumber") = "ok" then
    If ISNull(oJSONoutput.tStadiumNumber) Or oJSONoutput.tStadiumNumber = "" Then
      StadiumNumber = ""
      DEC_StadiumNumber = ""        
    Else
      StadiumNumber = fInject(oJSONoutput.tStadiumNumber)
      DEC_StadiumNumber = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumNumber))
    End If
  Else  
    StadiumNumber = ""
    DEC_StadiumNumber = ""
	End if	

  
  If hasown(oJSONoutput, "tPlayLevelType") = "ok" then
    If ISNull(oJSONoutput.tPlayLevelType) Or oJSONoutput.tPlayLevelType = "" Then
      PlayLevelType = ""
      DEC_PlayLevelType = ""        
    Else
      PlayLevelType = fInject(oJSONoutput.tPlayLevelType)
      DEC_PlayLevelType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayLevelType))
    End If
  Else  
    PlayLevelType = ""
    DEC_PlayLevelType = ""
	End if	

  
  
  If hasown(oJSONoutput, "tGroupGameGB") = "ok" then
    If ISNull(oJSONoutput.tGroupGameGB) Or oJSONoutput.tGroupGameGB = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""        
    Else
      GroupGameGb = fInject(oJSONoutput.tGroupGameGB)
      DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGB))
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
	End if	

    
  If hasown(oJSONoutput, "tTotalClass") = "ok" then
    If ISNull(oJSONoutput.tTotalClass) Or oJSONoutput.tTotalClass = "" Then
      TotalClass = ""
      DEC_TotalClass = ""        
    Else
      TotalClass = fInject(oJSONoutput.tTotalClass)
      DEC_TotalClass = fInject(crypt.DecryptStringENC(oJSONoutput.tTotalClass))
    End If
  Else  
    TotalClass = ""
    DEC_TotalClass = ""
	End if	


  If InStr(TotalClass,"|") > 1 Then
    arr_TotalClass = Split(TotalClass,"|")
    reqSex = fInject(arr_TotalClass(0))
    reqPlayType = fInject(arr_TotalClass(1))
    reqTeamGb = fInject(arr_TotalClass(2))
    reqLevel = fInject(arr_TotalClass(3))
    reqLevelName = fInject(arr_TotalClass(4))
    reqLevelJooNum = fInject(arr_TotalClass(5))
  End if




  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"

  'Response.Write "reqSex : " & reqSex & "<br/>"
  'Response.Write "reqPlayType : " & reqPlayType & "<br/>"
  'Response.Write "reqTeamGb : " & reqTeamGb & "<br/>"
  'Response.Write "reqLevel : " & reqLevel & "<br/>"
  'Response.Write "reqLevelJooNum : " & reqLevelJooNum & "<br/>"
%>
  <select id="selGameDay" name="selGameDay" onchange="OnSearchChanged();">
  <option value="" <%If GameDay = "" Then%>selected<%End If%>>::경기일자 선택::</option>
  <%

    LSQL = " SELECT GameDay"
    LSQL = LSQL & " FROM "
    LSQL = LSQL & " ("
    LSQL = LSQL & " SELECT A.GameDay"
    LSQL = LSQL & " FROM tblGameLevel A"
    LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
    LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelidx = C.GameLevelidx AND C.DelYN ='N' "
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    LSQL = LSQL & " AND A.GameDay IS NOT NULL"
    LSQL = LSQL & " ) AS AA"
    LSQL = LSQL & " WHERE AA.GameDay <> ''"
    LSQL = LSQL & " GROUP BY AA.GameDay"
    Set LRs = Dbcon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
    %>
        <option value="<%=LRs("GameDay") %>" <%If GameDay = LRs("GameDay") Then%>selected<%End If%>><%=LRs("GameDay") %></option>
    <%
        LRs.MoveNext
      Loop
    End If
    LRs.Close
  %>
  </select>
  <%'Response.Write "LSQL" & LSQL & "<BR/>"%>
           
              
  <select id="selStadiumIDX" name="selStadiumIDX" onchange="OnSearchChanged();">
    <option value="">::경기장소 선택::</option>
    <%
      LSQL = " SELECT AA.StadiumIDX, AA.StadiumName"
      LSQL = LSQL & " FROM"
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT A.StadiumNum as StadiumIdx, B.StadiumName "
      LSQL = LSQL & " FROM tblGameLevel A"
      LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumNum "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND B.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF GameDay <> "" Then
        LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
      END IF
      LSQL = LSQL & " AND ISNULL(A.StadiumNum,'') <> ''"
      LSQL = LSQL & " GROUP BY A.StadiumNum, B.StadiumName"
      LSQL = LSQL & " ) AA"
      LSQL = LSQL & " GROUP BY AA.StadiumIDX, AA.StadiumName"
      'Response.Write "LSQL:" & LSQL & "<BR/><BR/><BR/>"
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        r_StadiumIDX = LRs("StadiumIDX")
        crypt_StadiumIDX = crypt.EncryptStringENC(r_StadiumIDX)
        r_StadiumName = LRs("StadiumName")
        if DEC_StadiumIDX <> "" Then
      %>
      <option value="<%=crypt_StadiumIDX%>" <%If cdbl(DEC_StadiumIDX) = cdbl(r_StadiumIDX) Then%> selected <%End If%> ><%=r_StadiumName%></option>
      <% Else %>
      <option value="<%=crypt_StadiumIDX%>" ><%=r_StadiumName%></option>
      <% End IF %>
      <%
          LRs.MoveNext
        Loop
      End If            

      LRs.Close    
    %>
  </select>
  <%'Response.Write "LSQL:" & LSQL & "<BR/><BR/><BR/>" %>
  

  <select id="selGroupGameGb" onChange='OnSearchChanged()'>
    <option value="">경기유형 선택</option>
      <%
      LSQL = "  SELECT GroupGameGb,GroupGameGbNM  "
      LSQL = LSQL & " FROM"
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT C.GroupGameGb, dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N' "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF GameDay <> "" Then
        LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
      END IF
      IF DEC_StadiumIDX <> "" Then
        LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
      End IF
      IF StadiumNumber <> "" Then
      LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
      End IF
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT C.GroupGameGb, dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM "
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A  "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF GameDay <> "" Then
        LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
      END IF
      IF DEC_StadiumIDX <> "" Then
        LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
      End IF
      IF StadiumNumber <> "" Then
      LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
      End IF
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY AA.GroupGameGb,AA.GroupGameGbNM"
      

      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
      %>
          <option value="<%=crypt.EncryptStringENC(LRs("GroupGameGb")) %>" 
          <%
          If DEC_GroupGameGb = LRs("GroupGameGb") Then
          %>
          selected
          <%End If%>>
          <%=LRs("GroupGameGbNM") %>
          </option>
      <%
          LRs.MoveNext
        Loop
      Else
      End If      
      LRs.Close        
      %>
  </select>
  
    <select id="selTotalClass" name="selTotalClass" onChange='OnSearchChanged()'>
      <option value="">종별 선택</option>
        <%
        LSQL = " SELECT Sex, SexNm, PlayType, PlayTypeNM, GameType, TeamGb, TeamGbNm,Level ,LevelNm,LevelJooName,LevelJooNameNm, LevelJooNum "
        LSQL = LSQL & " FROM"
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT SexNm = (case E.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  ), "
        LSQL = LSQL & " E.Sex, E.PlayType, E.GameType, E.TeamGb,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.PlayType,'PubCode') AS PlayTypeNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.TeamGb,'TeamGb') AS TeamGbNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.Level,'Level') AS LevelNm, "
        LSQL = LSQL & " E.Level,"
        LSQL = LSQL & " E.LevelJooName,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.LevelJooName,'PubCode') AS LevelJooNameNM,"
        LSQL = LSQL & " E.LevelJooNum "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N'"
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

        IF GameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
        END IF

        IF DEC_StadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
        End IF

        IF DEC_GroupGameGb <> "" Then
          LSQL = LSQL & " AND E.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF

        IF StadiumNumber <> "" Then
        LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
        End IF

        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT SexNm = (case E.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  ), "
        LSQL = LSQL & " E.Sex, E.PlayType, E.GameType, E.TeamGb,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.PlayType,'PubCode') AS PlayTypeNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.TeamGb,'TeamGb') AS TeamGbNm,  "
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.Level,'Level') AS LevelNm, "
        LSQL = LSQL & " E.Level,"
        LSQL = LSQL & " E.LevelJooName,"
        LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(E.LevelJooName,'PubCode') AS LevelJooNameNM,"
        LSQL = LSQL & " E.LevelJooNum "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A  "
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"

        IF GameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
        END IF

        IF DEC_StadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
        End IF

        IF DEC_GroupGameGb <> "" Then
          LSQL = LSQL & " AND E.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF

        IF StadiumNumber <> "" Then
          LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
        End IF

        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " GROUP BY AA.Sex, AA.SexNm,AA.PlayType, AA.PlayTypeNM,AA.GameType, AA.TeamGb, AA.TeamGbNm, AA.LevelNm, AA.Level, AA.LevelJooNum,AA.LevelJooName,AA.LevelJooNameNm"
        

        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            o_SexNm = LRS("SexNm")
            o_Sex = LRS("Sex")
            o_PlayType = LRS("PlayType")
            o_PlayTypeNM= LRS("PlayTypeNM")
            o_GameType = LRS("GameType")
            o_TeamGb = LRS("TeamGb")
            o_TeamGbNm = LRS("TeamGbNm")
            o_LevelNm = LRS("LevelNm")
            o_Level = LRS("Level")
            o_LevelJooName = LRS("LevelJooName")
            o_LevelJooNameNM = LRS("LevelJooNameNM")
            o_LevelJooNum = LRS("LevelJooNum")
            o_ParamValue = reqSex & "|" & reqPlayType & "|" & reqTeamGb & "|" & reqLevel & "|" & reqLevelName & "|" & reqLevelJooNum
            o_Value = o_Sex & "|" & o_PlayType & "|" & o_TeamGb & "|" & o_Level & "|" & o_LevelJooName  & "|" & o_LevelJooNum 
        %>
            <option value="<%=o_Value%>" 
            <%
            If o_Value  = o_ParamValue Then
            %>
            selected
            <%End If%>>
            <%Response.Write o_SexNm & o_PlayTypeNM & o_TeamGbNm & " " & o_LevelNm  & " " & o_LevelJooNameNM & " " & o_LevelJooNum %>
            </option>
        <%
            LRs.MoveNext
          Loop
        Else
        End If      
        LRs.Close        
        %>

    </select>
    
    <%'Response.Write "LSQL" & LSQL & "<BR/>"%>
  <select>
    <option>::실적구분 선택::</option>
  </select>
  <input type="text" id="txtSearchName" name="txtSearchName" placeholder="이름을 검색하세요">
  <a href="javascript:OnSearchClick();" class="gray_btn">검색</a>
<%

Set LRs = Nothing
DBClose()
  
%>