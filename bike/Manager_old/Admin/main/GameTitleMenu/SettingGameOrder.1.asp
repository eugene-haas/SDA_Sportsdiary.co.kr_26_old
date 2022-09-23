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
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
  'REQ = "{""CMD"":2,""NationType"":""B0010001"",""GameTitleName"":""테스트대회"",""GamePlace"":""테스트대회"",""GameStartDate"":""2017-12-07"",""GameEndDate"":""2017-12-31"",""GameTitleLocation"":""01"",""EnterType"":""A"",""ViewYN"":""Y""}"
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tIdx =crypt.EncryptStringENC(reqGameTitleIdx)
  if Request("tStadiumIdx") <> "" Then
  reqStadiumIdx =  fInject(crypt.DecryptStringENC(Request("tStadiumIdx")))
  crypt_reqStadiumIdx=crypt.EncryptStringENC(reqStadiumIdx)
  end if

  'tStadiumIdx = 69
  '----------------대회 정보 가져오기----------------
  IF(cdbl(Len(reqGameTitleIdx)) > 0)Then
    LSQL = "SELECT GameTitleIDX ,GameTitleName,GameS,GameE ,EnterType, PersonalPayment, GroupPayment"
    LSQL = LSQL & " FROM  tblGameTitle"
    LSQL = LSQL & " WHERE GameTitleIDX = " &  reqGameTitleIdx
  ELSE
    LSQL = "SELECT Top 1 GameTitleIDX ,GameTitleName,GameS,GameE ,EnterType, PersonalPayment, GroupPayment"
    LSQL = LSQL & " FROM  tblGameTitle"
    LSQL = LSQL & " Order by gametitleidx	desc "
  END IF
  'Response.Write "LSQL:" & LSQL & "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      selGameTitleIDX = LRs("GameTitleIDX")
      tGameTitleEnterType = LRs("EnterType")
      tGameTitleName = LRs("GameTitleName")
      tGameS = LRs("GameS")
      tGameE = LRs("GameE")
      tEnterType = LRS("EnterType") 
      tPersonalPayment= LRS("PersonalPayment")
      tGroupPayment= LRS("GroupPayment")
      LRs.MoveNext
    Loop
  End If
  LRs.close
  '----------------대회 정보 가져오기----------------
%>

<%
  'Response.Write "ReqGameTitleIdx:" & ReqGameTitleIdx & "<BR>"
%>

<html>
  <head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta charset="utf-8">
  <title>경기 진행순서</title>
  <link href="/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css">
  <script src="/js/jquery-1.12.2.min.js"></script>
  <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <link href="/css/lib/jquery-ui.min.css" rel="stylesheet" media="screen">
  <script src="/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <link rel="stylesheet" href="/css/admin/admin.d.style.css">
  <script src="../../js/CommonAjax.js"></script>
  <script src="../../js/GameNumber/SettingGameOrder.js"></script>
  <script src="../../dev/dist/Common_Js.js"></script>
  <script type="text/javascript" src="../../js/library/jquery-ui.min.js"></script>
 
</head>

<body>
  <!-- S: setup-header -->
  <div class="setup-header">
    <h3 id="myModalLabel"><span class="tit">경기 진행순서 설정</span> <span class="txt"></span></h3>
  </div>
  <!-- E: setup-header -->
  
  <!-- S: setup-body -->
  <div class="setup-body game-number" id="divGameNumberBody">
          
    <!-- S: top-ctr -->
    <div class="top-ctr">
      <!-- S: stair -->
      <div class="stair clearfix">
          <!--대회 리스트-->
          <select id="selGameTitle" name="selGameTitle" class="sel-ctr" style="margin-top:20px;" onchange="javascript:SelGameNumber();">
            <%
                LSQL = "SELECT GameTitleIDX ,GameTitleName"
                LSQL = LSQL & " FROM  tblGameTitle"
                LSQL = LSQL & " WHERE DelYN = 'N'"
             
                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                    tGameTitleIDX = LRs("GameTitleIDX")
                    crypt_tGameTitleIDX =crypt.EncryptStringENC(tGameTitleIDX)
                    tGameTitleName = LRs("GameTitleName")
                    IF cdbl(tGameTitleIDX) = cdbl(selGameTitleIDX) Then %>
                    <option value="<%=crypt_tGameTitleIDX%>" selected><%=tGameTitleName%>-<%=tGameTitleIDX%></option>
                    <%ELSE%>
                    <option value="<%=crypt_tGameTitleIDX%>"><%=tGameTitleName%>-<%=tGameTitleIDX%></option>
                    <% End IF
                    LRs.MoveNext
                  Loop
                End If
                LRs.close
            %>
          </select>
          <!--대회 리스트-->
      </div>
      <%   'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL%>
      <!-- E: stair -->

      <!-- S: stair -->
			<div class="search_top ">
				<div class="search_box">
					<span> [장소 리스트]</span>
					<select name="selStadium" id="selStadium" class="title_select">
						<option value="" <% if tStadiumIdx = "" Then %> selected <% END IF%>> ==지정된 코트가 없는 종별== </option>
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
										tStadiumIDX = LRs("StadiumIDX")
										tStadiumCourt = LRs("StadiumCourt")
										tStadiumName = LRs("StadiumName")
										crypt_tStadiumIDX =crypt.EncryptStringENC(tStadiumIDX)
										'IF tStadiumIdx = "" Then
										'  tStadiumIdx = 0
										'  IF CDBL(StadiumCnt) = CDBL(1) Then
										'    tStadiumIdx = tStadiumIDX2
										'  End IF
										'END IF
										IF CDBL(tStadiumIDX) = CDBL(reqStadiumIdx) Then
										%>
										<option value="<%=crypt_tStadiumIDX%>" selected> <%=tStadiumName%>-코트 수 : <%=tStadiumCourt%> , idx : <%=tStadiumIdx%> </option>
										<%Else%>
										<option value="<%=crypt_tStadiumIDX%>" > <%=tStadiumName%>-코트 수 :  <%=tStadiumCourt%> , <%=tStadiumIdx%></option>
										<%End If%>
										<%                    
									LRs.MoveNext
								Loop
							End If
							LRs.close
						%>
					</select>
         
          <select name="selGameDate" id="selGameDate" class="title_select">
						<option value="" <% if reqGameDate = "" Then %> selected <% END IF%>> ==날짜== </option>
						<%
              LSQL = " Select a.GameDay   "
							LSQL = LSQL & " FROM  tblGameLevel a "
              LSQL = LSQL & " inner Join tblStadium b on a.StadiumNum = b.StadiumIDX and b.DelYN='N' "
              LSQL = LSQL & " WHERE A.DelYN = 'N' AND b.StadiumIDX is not null AND a.GameTitleIDX = '"& ReqGameTitleIdx &"'"
							LSQL = LSQL & " Group by  a.GameDay  "
							
							Set LRs = DBCon.Execute(LSQL)
								If Not (LRs.Eof Or LRs.Bof) Then
									Do Until LRs.Eof
										GameDateCnt = GameDateCnt + 1
										tGameDay = LRs("GameDay")
										
										IF tGameDay = reqGameDate Then
										%>
										<option value="<%=tGameDay%>" selected> <%=tGameDay%> </option>
										<%Else%>
										<option value="<%=tGameDay%>" > <%=tGameDay%> </option>
										<%End If%>
										<%                    
									LRs.MoveNext
								Loop
							End If
							LRs.close
						%>
					</select>
           <% 'Response.Write "LSQL " & LSQL & "<br/>" %>
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
              <th>순서</th>
              <th>순서 그룹</th>
              <th>경기 날짜</th>
              <th>경기장</th>
              <th>경기 구분</th>
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
            
            If(cdbl(tGameTitleIDX) > 0) Then
              IF tStadiumIdx = "" Then
                tStadiumIdx = 0
              End IF

              tGameLevelCnt = 1

              iType = "2"                      ' 1:조회, 2:총갯수
              LSQL = "EXEC tblGameNumberLevel_Searched_STR '" & iType & "','" & iTemp & "','" & reqGameTitleIdx & "','" & reqStadiumIdx & "','" & reqGameDate & "'"
              
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
              LSQL = LSQL & " WHERE StadiumNum='" &  ReqStadiumIdx & "' and GameTitleIDX = '" & ReqGameTitleIdx & "'"

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
                LSQL = LSQL & " WHERE StadiumNum='" &  ReqStadiumIdx & "' and GameTitleIDX = '" & ReqGameTitleIdx & "'"
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                Set LRs = DBCon.Execute(LSQL)
              End if

              'Response.Write "tGameLevelCnt" & tGameLevelCnt & "<br/>"
              'Response.Write "GameOrderMax" & GameOrderMax & "<br/>"
              iType = "1"                      ' 1:조회, 2:총갯수
              LSQL = "EXEC tblGameNumberLevel_Searched_STR '" & iType & "','" & iTemp & "','" & reqGameTitleIdx & "','" & reqStadiumIdx & "','" & reqGameDate & "'"
              'response.Write "LSQ;L=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
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
                          <input type="hidden" value="<%=crypt_tGameLevelidx%>" >
                          <%=tGameNumber%>
                        </td>
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
                          
                          <%=tTeamGbNm%>&nbsp;<%=tGroupGameGbNm%>&nbsp;-<%=tGameLevelidx%>
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
                <!-- 하단의 table-fix-body > tbody 의 개수만큼 
                colspan 값을 넣어서 사용 -->
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
              If(cdbl(tGameTitleIDX) > 0) Then

                IF tStadiumIdx = "" Then
                  tStadiumIdx = 0
                End IF
                LSQL = "EXEC tblGameNumberTourney_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & tGameTitleIDX & "','" & WhereLevelIDX  &"','" & reqStadiumIdx & "','" & reqGameDate & "','" & iLoginID & "'"        
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
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
                    tLevelGameDay= LRs("LevelGameDay")
                    tLPlayer1= LRs("LPlayer1")
                    tLPlayer2= LRs("LPlayer2")
                    tLTeam1= LRs("LTeam1")
                    tLTeam2= LRs("LTeam2")
                    tRplayer1= LRs("Rplayer1")
                    tRplayer2= LRs("Rplayer2")
                    tRTeam1= LRs("RTeam1")
                    tRTeam2= LRs("RTeam2")
                    tRTeam2= LRs("RTeam2")
                    tTurnNum= LRs("TurnNum")
                    tTeamGb= LRs("TeamGb")
                    tTeamGbNm= LRs("TeamGbNm")
                    tGroupGameGBNM= LRs("GroupGameGBNM")
                    tGroupGameGb = LRs("GroupGameGb")
                    crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
                    tPlayTypeNM = LRs("GameTypeNM")
                    tPlayType = LRs("GameType")
                    tLevel= LRs("Level")
                    tLevelNM= LRs("LevelNM")
                    tEnterType= LRs("EnterType")
                    tSex = LRs("Sex")
                    tLevelJooNameNM= LRs("LevelJooNameNM")
                    tLevelJooName = LRs("LevelJooName")
                    tStadiumNum = LRs("StadiumNum")
                    tStadiumOrder = LRs("StadiumOrder")
                    tStadiumIdx = LRs("StadiumIdx")
                    tLevelJooNum= LRs("LevelJooNum")
                    tPlayLevelTypeNm = LRs("PlayLevelTypeNm")
                    tLevelDtlJooNum= LRs("LevelDtlJooNum")
                    tUpdateGameOrderDate = LRs("UpdateGameOrderDate")
                     
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
                        <%=LEFT(tSexNm, 1) %> <%=LEFT(tPlayTypeNm, 1)%>-<%=tLevelNm%>
                        <% if tLevelJooName <> "B0110007" and tLevelJooName <> "" Then %>-<%=tLevelJooNameNM%>
                        <% End IF  %>
                        <%IF(tLevelJooNum <> "") Then%>-<%=tLevelJooNum %>
                        <%End If%>
                      <% End IF  %>
                    </td>
                      <td style="cursor:pointer" >
                        <%=tPlayLevelTypeNm%>-<%=tLevelDtlJooNum%>
                        <% IF tPlayLevelType ="B0100002" Then%>
                        -<%=tTeamGameNum%>
                        <%End IF%>
                      </td>

                      <td style="cursor:pointer" >
                          <%=tLPlayer1%><% if tLPlayer2 <> "" Then Response.Write "," & tLPlayer2 End IF %>(<%=tLTeam1%><% if tLTeam2 <> "" Then Response.Write "," & tLTeam2 End IF %>) vs <%=tRplayer1%><% if tRplayer2 <> "" Then Response.Write "," & tRplayer2 End IF %>(<%=tRTeam1%><% if tLTeam2 <> "" Then Response.Write "," & tLTeam2 End IF %>) 
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

  </div>
  <!-- E: setup-body -->
</body>
</html>