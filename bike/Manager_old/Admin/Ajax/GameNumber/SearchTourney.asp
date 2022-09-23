
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
  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E"",""tGameLevelIdx"":""FE39F234F43FC13F93D893972DC8C171""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if  

  If hasown(oJSONoutput, "tGameLevelIdx") = "ok" then
    If ISNull(oJSONoutput.tGameLevelIdx) Or oJSONoutput.tGameLevelIdx = "" Then
      GameLevelIdx = ""
      DEC_GameLevelIdx = ""
    Else
      GameLevelIdx = fInject(oJSONoutput.tGameLevelIdx)
      DEC_GameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
    End If
  End if  


  If hasown(oJSONoutput, "tGameTourneyName") = "ok" then
    If ISNull(oJSONoutput.tGameTourneyName) Or oJSONoutput.tGameTourneyName = "" Then
      GameTourneyName = ""
      DEC_GameTourneyName = ""
    Else
      GameTourneyName = fInject(oJSONoutput.tGameTourneyName)
      DEC_GameTourneyName = fInject(oJSONoutput.tGameTourneyName)
    End If
  End if  




  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 30  ' 한화면에 출력할 갯수
  BlockPage = 5      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0
  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

   If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>       
<!-- S: top-search -->
<div class="top-search">
  <input type="text" id="txtGameTourenyName" name="txtGameTourenyName" placeholder="종별을 검색해주세요.">
  <a href="javascript:OnGameTourenySearch();" >조회</a>
</div>
<!-- E: top-search -->
<table cellspacing="0" cellpadding="0" id="tableToureny" name="tableToureny">
	<thead>
    <tr>
      <th>경기</th>
      <th>vs</th>
      <th>경기번호</th>
    </tr>
  </thead>
  <tbody>
    <%
        DEC_Type ="2"
        LSQL = "EXEC tblGameNumberTourney_Searched_STR '" & DEC_GameTitleIDX & "','" & DEC_GameLevelIdx & "','" & DEC_GameDay & "','" & DEC_StadiumIDX & "','" & DEC_StadiumNum & "','" & DEC_GameStatus & "','" & DEC_PlayLevelType & "','" & DEC_TempNum & "','" & DEC_SearchKey & "','" & DEC_SearchKeyWord & "','" & DEC_GroupGameGb & "','" & DEC_Type & "'"        
        'response.Write "LSQL='LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'Response.End
        Set LRs = DBCon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          LCnt = LCnt + 1
          
          tGameTitleIdx = LRs("GameTitleIdx")
          tGameLevelIdx = LRs("GameLevelIdx")
          crypt_tGameLevelIdx = crypt.EncryptStringENC(tGameLevelIdx)

          tGameLevelDtlIDX= LRs("GameLevelDtlIDX")
          crypt_tGameLevelDtlIDX = crypt.EncryptStringENC(tGameLevelDtlIDX)
          tTeamGameNum= LRs("TeamGameNum")
          tGameNum= LRs("GameNum")
          tTeamGb= LRs("TeamGb")
          tGameDay= LRs("GameDay")

          tLPlayer1= LRs("LPlayer1")
          tLPlayer2= LRs("LPlayer2")
          tLTeam1= LRs("LTeam1")
          tLTeam2= LRs("LTeam2")
          tLTeamDtl= LRs("LTeamDtl")

          tRplayer1= LRs("Rplayer1")
          tRplayer2= LRs("Rplayer2")
          tRTeam1= LRs("RTeam1")
          tRTeam2= LRs("RTeam2")
          tRTeamDtl= LRs("RTeamDtl")

          tTurnNum= LRs("TurnNum")
          tTeamGbNM= LRs("TeamGbNm")
          tGroupGameGBNM= LRs("GroupGameGBNM")
          tGroupGameGb = LRs("GroupGameGb")
        
          tPlayTypeNM = LRs("PlayTypeNM")
          tPlayType = LRs("PlayType")
          tLevel= LRs("Level")
          tLevelNM= LRs("LevelNM")
          tSexNM = LRs("Sex")
          tLevelJooNum= LRs("LevelJooNum")
          tLevelJooNameNM = LRs("LevelJooName")
          tStadiumNum = LRs("StadiumNum")
          tStadiumIdx = LRs("StadiumIdx")
          tPlayLevelType = LRs("PlayLevelType")
          tPlayLevelTypeNm = LRs("PlayLevelTypeNm")
          tLevelDtlJooNum= LRs("LevelDtlJooNum")
          tMaxRound= LRs("MaxRound")
          tGameType= LRs("GameType")
          tGameTypeNM= LRs("GameTypeNM")
          tRound= LRs("Round")
          tLByeYN= LRs("LByeYN")
          tRByeYN= LRs("RByeYN")
          
          tResultGangSu = GetGangSu(tGameType, tMaxRound,tRound)
          

    %>
    <tr>
      <!--
      <td>
        <% Response.Write tTeamGbNM & "-" & tSexNM & tPlayTypeNM  & " " & tLevelNM  & " " & tLevelJooNameNM & " " & tLevelJooNum %>
      </td>
      -->
      
      <td>
        <%
            If tPlayLevelType = "B0100001" Then
                Response.Write " 예선-" & tLevelDtlJooNum &"조"
            ElseIf  tPlayLevelType = "B0100002" Then
              IF tResultGangSu = "" Then
                Response.Write " 본선" 
              Else
                Response.Write " 본선" & "-" & tResultGangSu
              ENd iF
            Else
                Response.Write "-"
            End If          

            IF tGroupGameGb = GroupGame Then
              Response.Write " " & tTeamGameNum & "경기" 
            ELSE
              Response.Write " " & tGameNum & "경기"
            End IF
          %>          

          

          
      </td>
      
      <td>
        <span> <%=tLTeam1%>  </span>
        <% IF tGroupGameGb =PersonGame Then %>
        <span> (<%=tLPlayer1%> 
            <%If tLPlayer2 <> "" Then%>
               <%Response.Write "," & tLPlayer2%> 
            <%End IF%>)
        </span>
        <%End IF%>
        vs 
        
        <span><%=tRTeam1%></span>
        <% IF tGroupGameGb =PersonGame Then %>
        <span> (<%=tRPlayer1%> 
            <%If tRPlayer2 <> "" Then%>
               <%Response.Write "," & tRPlayer2%> 
            <%End IF%>)
        </span>
        <%End IF%>
      </td>
        
     
      <td>
      <!--
        <% IF tLTeamDtl <> "0" Then Response.Write "-" & tLTeamDtl End IF%>
        <span><%=tLPlayer1%></span>
        <%If tLPlayer2 <> "" Then%>
          /<span><%=tLPlayer2%></span>
        <%End If%>

        <%If tLByeYN = "Y" Then%>
          BYE
        <%End If%>
        vs
        <%=tRTeam1%>
        <% IF tRTeamDtl <> "0" Then Response.Write "-" & tRTeamDtl End IF%>
        
        <span><%=tRplayer1%></span>
      
        <%If tRplayer2 <> "" Then%>
          /<span><%=tRplayer2%></span>
        <%End If%>        
        <%If tRByeYN= "Y" Then%>
          BYE
        <%End If%>
        <span>
        -->
        <%
           IF tStadiumNum <> "" AND tTurnNum <> "" Then
              RESPONSE.Write tStadiumNum & "코트" & tTurnNum & "번 경기"
           End IF
        %>
        </span>
        <span>
          <!--(<%=tTeamGameNum%>,<%=tGameNum%>)-->
          <input type="hidden" id="hiddenGameLevelDtlIDX" name="hiddenGameLevelDtlIDX" value="<%=crypt_tGameLevelDtlIDX%>">
          <input type="hidden" id="hiddenTeamGameNum" name="hiddenTeamGameNum" value="<%=tTeamGameNum%>">
          <input type="hidden" id="hiddenGameNum" name="hiddenGameNum" value="<%=tGameNum%>">
          <input type="hidden" id="hiddenGroupGameGb" name="hiddenGroupGameGb" value="<%=tGroupGameGb%>">
        </span>
      </td>
    
    </tr>
    <%
       LRs.MoveNext
       Loop
     End If
     LRs.close

    %>
  </tbody>
</table>
<%
  DBClose()
%>