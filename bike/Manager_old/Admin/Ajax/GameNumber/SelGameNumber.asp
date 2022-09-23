
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
  'REQ = "{""CMD"":1,""tIDX"":""A1FFE726015065EF66D53858E3FC304F"",""tStadiumIdx"":"""",""tGameDate"":""""}"
  Set oJSONoutput = JSON.Parse(REQ)
  ReqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  crypt_ReqGameTitleIdx = crypt.EncryptStringENC(ReqGameTitleIdx)

  If hasown(oJSONoutput, "tStadiumIdx") = "ok" then
    If ISNull(oJSONoutput.tStadiumIdx) Or oJSONoutput.tStadiumIdx = "" Then
      ReqStadiumIdx = "0"
      DEC_StadiumIdx  = "0"
    Else
      ReqStadiumIdx = fInject(oJSONoutput.tStadiumIdx)    
      DEC_StadiumIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIdx))
    End If
  Else  
    ReqStadiumIdx = "0"
    DEC_StadiumIdx = "0"
End if  

If hasown(oJSONoutput, "tGameDate") = "ok" then
    If ISNull(oJSONoutput.tGameDate) Or oJSONoutput.tGameDate = "" Then
      ReqGameDate = ""
      DEC_GameDate = ""
    Else
      ReqGameDate = fInject(oJSONoutput.tGameDate)
      'DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameLevelDtlIDX))    
      DEC_GameDate = fInject(oJSONoutput.tGameDate)    
    End If
  Else  
    ReqGameDate = ""
    DEC_GameDate = ""
End if  



%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.Write "ReqGameDate :" & ReqGameDate & "<BR/>"  
  'Response.Write "DEC_StadiumIdx :" & DEC_StadiumIdx & "<BR/>"
%>       

<!-- S: top-ctr -->
<div class="top-ctr">
  <!-- S: stair -->
  <div class="stair clearfix">
      <select id="selGameTitle" name="selGameTitle" class="sel-ctr" >
        <%
            LSQL = "SELECT GameTitleIDX ,GameTitleName"
            LSQL = LSQL & " FROM  tblGameTitle"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL
            Set LRs = DBCon.Execute(LSQL)
            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                tGameTitleIDX2 = LRs("GameTitleIDX")
                crypt_tGameTitleIDX2 =crypt.EncryptStringENC(tGameTitleIDX2)
                tGameTitleName2 = LRs("GameTitleName")
                IF cdbl(ReqGameTitleIdx) = cdbl(tGameTitleIDX2) Then %>
                <option value="<%=crypt_tGameTitleIDX2%>" selected><%=tGameTitleName2%>-<%=tGameTitleIDX2%></option>
                <%ELSE%>
                <option value="<%=crypt_tGameTitleIDX2%>"><%=tGameTitleName2%>-<%=tGameTitleIDX2%></option>
                <% End IF
                LRs.MoveNext
              Loop
            End If
            LRs.close
        %>
      </select>
      <a href="javascript:SelGameNumber();"  class="btn btn-confirm">검색</a>
  </div>
  <%   'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL%>
  <!-- E: stair -->


  <!-- S: stair -->
  <div class="search_top ">
    <div class="search_box">
      <span> [장소 리스트]</span>
      <select name="selStadium" id="selStadium" class="title_select">
        <option value="" <% if DEC_StadiumIdx = "" Then %> selected <% END IF%>> ==지정된 코트가 없는 종별== </option>
        <%
          LSQL = " Select b.StadiumIDX,a.GameTitleIDX ,b.StadiumName ,b.StadiumCourt   "
          LSQL = LSQL & " FROM  tblGameLevel a "
          LSQL = LSQL & " inner Join tblStadium b on a.StadiumNum = b.StadiumIDX and b.DelYN='N' "
          LSQL = LSQL & " WHERE A.DelYN = 'N' AND b.StadiumIDX is not null AND a.GameTitleIDX = '"& ReqGameTitleIdx &"'"
          LSQL = LSQL & " Group by b.StadiumIDX, a.GameTitleIDX ,b.StadiumName ,b.StadiumCourt "
      
          'Response.Write "LSQL " & LSQL 
          Set LRs = DBCon.Execute(LSQL)
            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                StadiumCnt = StadiumCnt + 1
                tStadiumIDX2 = LRs("StadiumIDX")
                tStadiumCourt = LRs("StadiumCourt")
                tStadiumName = LRs("StadiumName")
                crypt_tStadiumIDX2 =crypt.EncryptStringENC(tStadiumIDX2)
             
             
                IF CDBL(tStadiumIDX2) = CDBL(DEC_StadiumIdx) Then
                %>
                <option value="<%=crypt_tStadiumIDX2%>" selected> <%=tStadiumName%>-코트 수 : <%=tStadiumCourt%> , idx : <%=tStadiumIdx2%> </option>
                <%Else%>
                <option value="<%=crypt_tStadiumIDX2%>" > <%=tStadiumName%>-코트 수 :  <%=tStadiumCourt%> , <%=tStadiumIdx2%></option>
                <%End If%>
                <%                    
              LRs.MoveNext
            Loop
          End If
          LRs.close
        %>
        </select>
    
     <select name="selGameDate" id="selGameDate" class="title_select">
						<option value="" <% if ReqGameDate = "" Then %> selected <% END IF%>> ==날짜== </option>
						<%
              LSQL = " Select a.GameDay   "
							LSQL = LSQL & " FROM  tblGameLevel a "
              LSQL = LSQL & " inner Join tblStadium b on a.StadiumNum = b.StadiumIDX and b.DelYN='N' "
              LSQL = LSQL & " WHERE A.DelYN = 'N' AND b.StadiumIDX is not null AND a.GameTitleIDX = '"& ReqGameTitleIdx &"'"
              if DEC_StadiumIdx <> "0" Then
              LSQL = LSQL & " AND b.StadiumIDX = '"& DEC_StadiumIdx &"'"
              ENd if 
							LSQL = LSQL & " Group by  a.GameDay  "
							
							Set LRs = DBCon.Execute(LSQL)
								If Not (LRs.Eof Or LRs.Bof) Then
									Do Until LRs.Eof
										GameDateCnt = GameDateCnt + 1
										tGameDate = LRs("GameDay")
										
										IF ReqGameDate = tGameDate Then
										%>
										<option value="<%=tGameDate%>" selected> <%=tGameDate%> </option>
										<%Else%>
										<option value="<%=tGameDate%>" > <%=tGameDate%> </option>
										<%End If%>
										<%                    
									LRs.MoveNext
								Loop
							End If
							LRs.close
						%>
					</select>

  		<!--
      <input type="text" id="GameS" name="GameS" class="date_ipt"></input>
      -->
      <a href="javascript:SelGameNumber();"  class="btn btn-confirm">검색</a>
      <a href="javascript:autoSetGameNumber();"  class="btn btn-confirm">자동 진행순서 적용</a>
      <a href="javascript:applyGameNumber();"  class="btn btn-confirm">전체 수동 변경 적용</a>
      <a href="javascript:href_viewGameNumber();"  class="btn btn-red">진행순서 결과</a>
    </div>
  </div>
  <!-- E: stair -->
</div>
<!-- E: top-ctr -->

<!-- S: content-wrap -->
<div class="content-wrap divn-hori" id="drowbody">
  <!-- S: divGameLevelList remote-arr -->
  <div id="divGameLevelList" class="remote-arr">
    <table class="table table-arr table-fix-body" id="tableGameLevelList">
      <thead>
        <tr>
          <th>순서 그룹</th>
          <th>경기 날짜</th>
          <th>경기장</th>
          <th>종별 목록</th>
          <th>팀 수</th>
          <th>인원 수</th>
          <th>-</th>
        </tr>
      </thead>
      <tbody>
      <%
        Dim gameNumberLevelCnt : gameNumberLevelCnt = 0
        Dim selGameNumberLevelIdx : selGameNumberLevelIdx  = 0
        Dim tGameLevelidxs : tGameLevelidxs =""
        If(cdbl(ReqGameTitleIdx) > 0) Then

          IF DEC_StadiumIdx = "0" Then
            DEC_StadiumIdx = ""
          End IF

          tGameLevelCnt = 1

          iType = "2"                      ' 1:조회, 2:총갯수
          LSQL = "EXEC tblGameNumberLevel_Searched_STR '" & iType & "','" & iTemp & "','" & ReqGameTitleIdx & "','" & DEC_StadiumIdx & "','" & ReqGameDate & "'"
          'Response.Write "LSQL : " & LSQL & "<BR/>"
          Set LRs = DBCon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                tGameLevelCnt= LRs("TOTALCNT")
              LRs.MoveNext
            Loop
          End If
          LRs.close

          LSQL = " SELECT IsNull(max( GameOrder ), 1) as GameOrderMax "
          LSQL = LSQL & " FROM tblGameLevel "
          LSQL = LSQL & " WHERE StadiumNum='" &  DEC_StadiumIdx & "' and GameTitleIDX = '" & tGameTitleIDX & "'"

          Set LRs = DBCon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                GameOrderMax= LRs("GameOrderMax")
              LRs.MoveNext
            Loop
          End If
          LRs.close

          IF(cdbl(tGameLevelCnt) < cdbl(GameOrderMax)) Then
            LSQL = " UPDATE tblGameLevel "
            LSQL = LSQL & " SET GameOrder = '" & tGameLevelCnt & "'"
            LSQL = LSQL & " WHERE StadiumNum='" &  DEC_StadiumIdx & "' and GameTitleIDX = '" & tGameTitleIDX & "'"
            'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
            Set LRs = DBCon.Execute(LSQL)
          End if
          
          iType = "1"                      ' 1:조회, 2:총갯수
          LSQL = "EXEC tblGameNumberLevel_Searched_STR '" & iType & "','" & iTemp & "','" & ReqGameTitleIdx & "','" & DEC_StadiumIdx & "','" & ReqGameDate & "'"
          'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
          
          Set LRs = DBCon.Execute(LSQL)
            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                gameNumberLevelCnt = gameNumberLevelCnt + 1
                tGameNumber = LRs("GameNumber")
                tGameOrder = LRs("GameOrder")
                tGameTitleIdx = LRs("GameTitleIdx")
                tGameLevelidx = LRs("GameLevelidx")
                crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelidx)
                tGameLevelidxs = tGameLevelidxs & tGameLevelidx & "_"
                tTeamGbNM= LRs("TeamGbNM")
                tLevelNM= LRs("LevelNM")
                tSex= LRs("Sex")
                tSexNM = LRs("SexNM") 
                tTeamGroupCnt = LRs("TeamGroupCnt")
                tParticipateCnt= LRs("ParticipateCnt") 
                tEnterType= LRs("EnterType")
                tTeamGb = LRs("TeamGb")
                tGroupGameGb = LRs("GroupGameGb")
                tGroupGameGbNm = LRs("GroupGameGbNm")
                tPlayType = LRs("PlayType")
                tPlayTypeNm = LRs("PlayTypeNm")
                tLevelJooNameNM= LRs("LevelJooNameNM")
                tLevelJooNum= LRs("LevelJooNum")
                tLevelJooName = LRs("LevelJooName")
                tLevel = LRs("Level")
                tLevelNm = LRs("LevelNm")
                tLevelGameDay= LRs("GameDay")
                tStadiumName = LRs("StadiumName")

                if(cdbl(gameNumberLevelCnt) = 1) Then
                  selGameNumberLevelIdx = tGameLevelidx
                End if
                %>    
                  <tr>
                 
                    <td style="cursor:pointer" > 
                      <input type="hidden"  value="<%=tGameLevelidx%>">
                      <select onchange="OnGameOrderChagned('<%=crypt_tGameLevelidx%>',this.value);">
                        <%For i = 1 To tGameLevelCnt
                        if cdbl(tGameOrder) = cdbl(i)  Then
                        %>
                        <option value="<%=i%>" selected> <%=i%> 순서</option>
                        <%Else%>
                      <option value="<%=i%>" > <%=i%> 순서</option>
                      <%
                        End IF
                        Next
                      %>
                      </select>
                    </td>
                    <td style="cursor:pointer" >
                      <%=tLevelGameDay%>
                    </td>
                    <td style="cursor:pointer" >
                      <%=tStadiumName%>
                    </td>
                    <td style="cursor:pointer" >
                      <%=tTeamGbNm%>&nbsp;<%=tGroupGameGbNm%>&nbsp;- <%=tGameLevelidx%>
                    </td>
                    <td style="cursor:pointer" >
                      <% IF tEnterType = "E" Then %>
                      <%=tSexNM%><%=tTeamGbNM%><% if tGroupGameGb <> "B0030002" Then %>&nbsp;<%=tPlayTypenm%><% end if%>
                            <% IF tGroupGameGb <> "B0030002" Then %>
                              (<%=tLevelNm%>)
                              <%Else%>
                              <%IF tTeamGb = tLevel Then%>
                                (<%=tGroupGameGbNm%>)
                              <%Else%>&nbsp;<%=tLevelNM%> (<%=tGroupGameGbNm%>)
                              <% End if %>
                            <% End IF %>
                      <% End IF  %>
                      <% IF tEnterType = "A" Then %>
                        <%=LEFT(tSexNm, 1) %> <%=LEFT(tPlayTypeNm, 1)%>-<%=tLevelNm%>
                        <% if tLevelJooName <> "B0110007" and tLevelJooName <> "" Then %>-<%=tLevelJooNameNM%>
                        <% End IF  %>
                        <%IF(tLevelJooNum <> "") Then%>-<%=tLevelJooNum %>
                        <%End If%>
                      <% End IF  %>
                    </td>
                    <td style="cursor:pointer" >
                      <%=tTeamGroupCnt%>
                    </td>
                    <td style="cursor:pointer" >
                      <%=tParticipateCnt%>
                    </td>
                    
                    <td style="cursor:pointer" >
                      <button class="btn btn-basic up">Up </button>
                      <button class="btn btn-gray down">Down </button>
                    </td> 
                  </tr>
                <%
              LRs.MoveNext
            Loop
          End If
          LRs.close
        End IF
        if cdbl(gameNumberLevelCnt) = 0 Then
        %>
        <tr>
          <td colspan="6">
            등록된 종별이 없습니다.
          </td>
        </tr>
        <%
        End if
        %>
      </tbody>
    </table>
  </div> 
  
  <!-- E: divGameLevelList remote-arr -->

  <!-- S: show-arr -->
    <div class="show-arr">
  
    <!-- S: table-arr -->
    <table class="table table-arr table-fix-body">
      <thead>
        <tr>
         <th>경기 번호</th>
          <th>경기 종별</th>
          <th>경기</th>
          <th>대전</th>
          <th>경기진행순서</th>
          <th>코트</th>
          <th>코트 그룹</th>
          <th>경기 날짜</th>
          <th>종목 날짜</th>
        </tr>
      </thead>
      <tbody>
       <%
       Dim WhereLevelIDX : WhereLevelIDX =""
        IF Len(tGameLevelidxs) > 0 Then
            WhereLevelIDX = "("
            RESULT = Split(tGameLevelidxs,"_")
            RESULTCNT = UBound(RESULT)
            for I = 0 to RESULTCNT
              IF RESULT(I) <> "" Then
                WhereLevelIDX = WhereLevelIDX & " A.GameLevelIdx = " & RESULT(I)  & " or "
              End if
            next
          'Response.Write "WhereLevelIDX" & WhereLevelIDX & "<br>"
          'Response.Write "WhereLevelIDX" & Len(WhereLevelIDX) & "<br>"
          'Response.Write "LEFT \WhereLevelIDX" &  LEFT(WhereLevelIDX, (Len(WhereLevelIDX) - 3))  & "<br>"
          WhereLevelIDX = LEFT(WhereLevelIDX, (Len(WhereLevelIDX) - 3)) 
          WhereLevelIDX = WhereLevelIDX  & ")"
        End IF


        Dim gameNumberTourneyCnt : gameNumberTourneyCnt = 0
        If(cdbl(ReqGameTitleIdx) > 0) Then

          IF tStadiumIdx = "" Then
            tStadiumIdx = 0
          End IF
          LSQL = "EXEC tblGameNumberTourney_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & ReqGameTitleIdx & "','" & WhereLevelIDX  &"','" & DEC_StadiumIdx & "','" & ReqGameDate & "','" & iLoginID & "'"        
          'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
          'Response.End
          Set LRs = DBCon.Execute(LSQL)
            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
              gameNumberTourneyCnt = gameNumberTourneyCnt + 1
               tTourneyIDX = LRS("TourneyIDX")
              crypt_tTourneyIDX = crypt.EncryptStringENC(tTourneyIDX)
              tGameTitleIdx = LRs("GameTitleIdx")
              tGameLevelIdx = LRs("GameLevelIdx")
              tGameLevelDtlIDX= LRs("GameLevelDtlIDX")
              crypt_tGameLevelDtlIDX = crypt.EncryptStringENC(tGameLevelDtlIDX)
              tTeamGameNum= LRs("TeamGameNum")
              tGameNum= LRs("GameNum")
              tGameDay= LRs("GameDay")
              tLevelGameDay = LRs("LevelGameDay")
              tLPlayer1= LRs("LPlayer1")
              tLPlayer2= LRs("LPlayer2")
              tLTeam1= LRs("LTeam1")
              tLTeam2= LRs("LTeam2")
              tRplayer1= LRs("Rplayer1")
              tRplayer2= LRs("Rplayer2")
              tRTeam1= LRs("RTeam1")
              tRTeam2= LRs("RTeam2")
              
              tTurnNum= LRs("TurnNum")
              tTeamGb= LRs("TeamGb")
              tTeamGbNm= LRs("TeamGbNm")
              tGroupGameGBNM= LRs("GroupGameGBNM")
              tGroupGameGb = LRs("GroupGameGb")
              crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
              tPlayTypeNM = LRs("PlayTypeNM")
              tPlayType = LRs("PlayType")
              tLevel= LRs("Level")
              tLevelNM= LRs("LevelNM")
              tEnterType= LRs("EnterType")
              tSexNM = LRs("Sex")
             
              tLevelJooNameNM= LRs("LevelJooNameNM")
              tLevelJooNum= LRs("LevelJooNum")
              tLevelJooName = LRs("LevelJooName")
              tStadiumNum = LRs("StadiumNum")
              tStadiumOrder = LRs("StadiumOrder")
              tStadiumIdx = LRs("StadiumIdx")
              tLevelJooNum= LRs("LevelJooNum")
              tPlayLevelType = LRs("PlayLevelType")
              tPlayLevelTypeNm = LRs("PlayLevelTypeNm")
              tLevelDtlJooNum= LRs("LevelDtlJooNum")
              tUpdateGameOrderDate= LRs("UpdateGameOrderDate")

              tMaxRound= LRs("MaxRound")
              tGameType= LRs("GameType")
              tGameTypeNM= LRs("GameTypeNM")
              tRound= LRs("Round")

              tResultGangSu = GetGangSu(tGameType, tMaxRound,tRound)

              %>
              <tr>
                <td style="cursor:pointer" >
                 <% IF tGroupGameGb = "B0030002" Then%>
                    <%=tTeamGameNum%> - <%=tGameLevelIdx%>
                  <%ELSE%>
                    <%=tGameNum%> - <%=tGameLevelIdx%>
                  <%END IF%>
                </td>

                <td style="cursor:pointer" >
                   <%=tTeamGbNm%>&nbsp;<%=tGroupGameGbNm%>&nbsp;
                   <% IF tEnterType = "E" Then %>
                    <%=tSexNM%>
                    <% if tGroupGameGb <> "B0030002" Then %>&nbsp;<%=tPlayTypeNM%><% end if%>

                     <% IF tGroupGameGb <> "B0030002" Then %>
                              (<%=tLevelNm%>)
                              <%Else%>
                              <%IF tTeamGb = tLevel Then%>
                                (<%=tGroupGameGbNm%>)
                              <%Else%>&nbsp;<%=tLevelNM%> (<%=tGroupGameGbNm%>)
                              <% End if %>
                        <% End IF %>
                  <% End IF  %>
                  <% IF tEnterType = "A" Then %>
                    <%=LEFT(tSexNm, 1) %> <%=LEFT(tPlayTypeNM, 1)%>-<%=tLevelNm%>
                    <% if tLevelJooName <> "B0110007" and tLevelJooName <> "" Then %>-<%=tLevelJooNameNM%>
                    <% End IF  %>
                    <%IF(tLevelJooNum <> "") Then%>-<%=tLevelJooNum %>
                    <%End If%>
                  <% End IF  %>
                </td>
                <td style="cursor:pointer" >
                  <%=tPlayLevelTypeNm%>
                  <% IF tPlayLevelType ="B0100002" Then%>
                  -<%=tResultGangSu%>
                  <%End IF%>
                </td> 
                <td style="cursor:pointer" >
                  <%=tLPlayer1%>
                  <% if tLPlayer2 <> "" Then Response.Write "," & tLPlayer2 End IF %>(<%=tLTeam1%>
                  <% if tLTeam2 <> "" Then Response.Write "," & tLTeam2 End IF %>) vs <%=tRplayer1%>
                  <% if tRplayer2 <> "" Then Response.Write "," & tRplayer2 End IF %>
                  (<%=tRTeam1%><% if tRTeam2 <> "" Then Response.Write "," & tRTeam2 End IF %>) 
                </td>

                <td>
                  <input type="text" id="txtTurnNum<%=gameNumberTourneyCnt%>" name="txtTurnNum<%=gameNumberTourneyCnt%>" value="<%=tTurnNum%>"><br>
                </td>

                <td>
                  <input type="text" id="txtStadiumNum<%=gameNumberTourneyCnt%>" name="txtStadiumNum<%=gameNumberTourneyCnt%>" value="<%=tStadiumNum%>"><br>
                </td>
                <td style="cursor:pointer" >
                  <input type="text" id="txtGameOrder<%=gameNumberTourneyCnt%>" name="txtGameOrder<%=gameNumberTourneyCnt%>" value="<%=tStadiumOrder%>"><br>
                </td>

                <td style="cursor:pointer" >
                  <input type="text" id="txtGameDay<%=gameNumberTourneyCnt%>" name="txtGameDay<%=gameNumberTourneyCnt%>" value="<%=tGameDay%>" maxlength="10"><br>
                </td>

                <td style="cursor:pointer" >
                <% if tLevelGameDay <> "" OR IsNull(tLevelGameDay) = FALSE Then %>
                          <%=FormatDateTime(tLevelGameDay, 2)%>
                        <% End IF %>
                  <input id="GameNumTourney<%=gameNumberTourneyCnt%>" name="GameNumTourney<%=gameNumberTourneyCnt%>" type="hidden" value="<%=tGameNum%>">
                  <input id="GameNumTourneyDtlIDX<%=gameNumberTourneyCnt%>" name="GameNumTourneyDtlIDX<%=gameNumberTourneyCnt%>" type="hidden" value="<%=crypt_tGameLevelDtlIDX%>">
                  <input id="GameTourneyIDX<%=gameNumberTourneyCnt%>" name="GameTourneyIDX<%=gameNumberTourneyCnt%>" type="hidden" value="<%=crypt_tTourneyIDX%>">
                  <input id="GroupGameGb<%=gameNumberTourneyCnt%>" name="GroupGameGb<%=gameNumberTourneyCnt%>" type="hidden" value="<%=crypt_tGroupGameGb%>">
                </td>
              <tr>
              <%
              LRs.MoveNext
            Loop
          End If
          LRs.close
        End IF

        if cdbl(gameNumberTourneyCnt) = 0 Then
        %>
        <tr>
          <td colspan="6">
            등록된 종별이 없습니다.
          </td>
        </tr>
        <%
        End if
        %>
      
      </tbody>
    </table>
    <input id="totalGameNumberTourneyCnt" name="totalGameNumberTourneyCnt" type="hidden" value="<%=gameNumberTourneyCnt%>">
    <!-- E: table-arr -->
  </div>
  <!-- E: show-arr -->

</div>
<!-- E: content-wrap -->

<%
  DBClose()
%>