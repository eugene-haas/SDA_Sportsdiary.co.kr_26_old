<!--#include virtual="/Manager/Common/common_header_tourney.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
GameYear = fInject(Request("GameYear"))
SportsGb = fInject(Request("SportsGb"))
GameTitleIDX = fInject(Request("GameTitleIDX"))
TeamGb = fInject(Request("TeamGb"))
Sex = fInject(Request("Sex"))
Level = fInject(Request("Level"))
GroupGameGb = fInject(Request("GroupGameGb"))
GameType = fInject(Request("GameType"))
RGameLevelidx = fInject(Request("RGameLevelidx"))
EnterType = fInject(Request("EnterType"))
EnterScoreType = fInject(Request("EnterScoreType"))


GameTitleName = fInject(Request("GameTitleName"))
TeamGbNm = fInject(Request("TeamGbNm"))
LevelNm = fInject(Request("LevelNm"))
GroupGameGbNm = fInject(Request("GroupGameGbNm"))
 
 
'Response.Write  "--GameYear : "&GameYear
'Response.Write  "--SportsGb : "&SportsGb
'Response.Write  "--GameTitleIDX : "&GameTitleIDX
'Response.Write  "--TeamGb : "&TeamGb
'Response.Write  "--Sex : "&Sex
'Response.Write  "--Level : "&Level
'Response.Write  "--GroupGameGb : "&GroupGameGb
'Response.Write  "--GameType : "&GameType
'Response.Write  "--RGameLevelidx : "&RGameLevelidx
'Response.Write  "--EnterType : "&EnterType
'Response.Write  "--EnterScoreType : "&EnterScoreType
'Response.Write  "--GameTitleName : "&GameTitleName
'Response.Write "<br />"
'Response.Write  "<br />"

GSQL = " select* " & _ 
       " from tblPlayerResult " & _ 
       " where SportsGb='"&SportsGb&"'" & _ 
       " and DelYN='N'" & _ 
       " and GameTitleIDX='"&GameTitleIDX&"'" & _ 
       " and RGameLevelidx='"&RGameLevelidx&"'" & _ 
       " and TeamGb='"&TeamGb&"'" & _ 
       " and Sex='"&Sex&"'" & _ 
       " and Level='"&Level&"'" & _ 
       " and GroupGameGb='"&GroupGameGb&"'" & _ 
       " and GameType='"&GameType&"'" & _ 
       " order by NowRound "


GSQL = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'"
       
'Response.Write  "<br />"
'Response.Write "--리스트"
'Response.Write "<br />"
'Response.Write GSQL
'Response.Write "<br />"




 '출력정보

              '리스트 
              
              ''선수정보

            

              ''로그

              ''사인데이터


''점수
ScoreSQL="SELECT GameNum,GroupGameNum,BB.Left01 + BB.Plus_Left01 AS Left01, BB.Plus_Left02 AS Left02, BB.Left03, BB.Left04, BB.Left05, BB.Left06, BB.Left07, " & _
             " BB.Right01 + BB.Plus_Right01 AS Right01, BB.Plus_Right02 AS Right02, BB.Right03, BB.Right04, BB.Right05, BB.Right06, BB.Right07" & _
             " FROM" & _
             " (" & _
             "  SELECT GameNum,GroupGameNum,Sum(Case AA.LJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Left01, " & _
             "  Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Left02, " & _
             "  Sum(Case AA.LJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Left03, " & _
             "  Sum(Case AA.LJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Left04, " & _
             "  Sum(Case AA.LJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Left05, " & _
             "  Sum(Case AA.LJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Left06, " & _
             "  Sum(Case AA.LJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Left07, " & _
             "  Sum(Case AA.RJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Right01, " & _
             "  Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Right02, " & _
             "  Sum(Case AA.RJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Right03, " & _
             "  Sum(Case AA.RJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Right04," & _
             "  Sum(Case AA.RJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Right05," & _
             "  Sum(Case AA.RJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Right06," & _
             "  Sum(Case AA.RJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Right07," & _
             "  0 as Plus_Left01," & _
             "  Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Left02," & _
             "  0 as Plus_Right01," & _
             "  Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Right02 "  & _
             "  FROM " & _
             "  ( " & _
             "    SELECT GameNum,GroupGameNum,COUNT(*) AS Jumsu, LJumsuGb , RJumsuGb " & _
             "    FROM tblRGameResultDtl B " & _
             "    WHERE B.RGameLevelidx='" & RGameLevelidx & "' " & _
 
             "    AND B.DELYN='N'" & _
             "    AND (LJumsuGb <> '' OR RJumsuGb <> '')" & _
             "    GROUP BY GameNum,GroupGameNum,LJumsuGb, RJumsuGb" & _
             "  ) AA group by GameNum,GroupGameNum" & _
             " ) AS BB"       
             
   ' Response.Write  "<br />"
   ' Response.Write "--점수"
   ' Response.Write  "<br />"
   ' Response.Write ScoreSQL
   ' Response.Write "<br />"


    scoreStr ="["
  Set scoreRs = Dbcon.Execute(ScoreSQL) 
    If Not(scoreRs.Eof Or scoreRs.Bof) Then 
    Do Until scoreRs.Eof 
        
       scoreStr = scoreStr & "{"
       scoreStr = scoreStr & "!GameNum@"& (scoreRs("GameNum"))  
       scoreStr = scoreStr & "!GroupGameNum@"& (scoreRs("GroupGameNum"))  
       
       scoreStr = scoreStr & "!Left01@"& (scoreRs("Left01")) 
       scoreStr = scoreStr & "!Left02@"& (scoreRs("Left02")) 
       scoreStr = scoreStr & "!Left03@"& (scoreRs("Left03")) 
       scoreStr = scoreStr & "!Left04@"& (scoreRs("Left04")) 
       scoreStr = scoreStr & "!Left05@"& (scoreRs("Left05")) 
       scoreStr = scoreStr & "!Left06@"& (scoreRs("Left06")) 
       scoreStr = scoreStr & "!Left07@"& (scoreRs("Left07")) 
       
       scoreStr = scoreStr & "!Right01@"& (scoreRs("Right01")) 
       scoreStr = scoreStr & "!Right02@"& (scoreRs("Right02")) 
       scoreStr = scoreStr & "!Right03@"& (scoreRs("Right03")) 
       scoreStr = scoreStr & "!Right04@"& (scoreRs("Right04")) 
       scoreStr = scoreStr & "!Right05@"& (scoreRs("Right05")) 
       scoreStr = scoreStr & "!Right06@"& (scoreRs("Right06")) 
       scoreStr = scoreStr & "!Right07@"& (scoreRs("Right07")) 
       scoreStr = scoreStr & "},"


    scoreRs.MoveNext
  Loop 
  End If 
    scoreStr = scoreStr & "]"

    Response.Write GSQL
  Set GRs = Dbcon.Execute(GSQL) 
    If Not(GRs.Eof Or GRs.Bof) Then 
    Do Until GRs.Eof 
  
            iPlayerResultIdx=(GRs("PlayerResultIdx"))
            iRound=(GRs("Round"))
            iNowRoundNM=(GRs("NowRoundNM"))
            iNowRound=(GRs("NowRound"))
            iTurnNum=(GRs("TurnNum"))

            iGroupGameNum=(GRs("GroupGameNum"))
            iGameNum=(GRs("GameNum"))
            
            iLPlayerIDX=(GRs("LPlayerIDX"))
            iLTeam=(GRs("LTeam"))
            iLTeamDtl=(GRs("LTeamDtl"))
            iLPlayerNum=(GRs("LPlayerNum"))
            iLResult=(GRs("LResult"))
            iLJumsu=(GRs("LJumsu"))

            iRPlayerIDX=(GRs("RPlayerIDX"))
            iRTeam=(GRs("RTeam"))
            iRTeamDtl=(GRs("RTeamDtl"))
            iRPlayerNum=(GRs("RPlayerNum"))
            iRResult=(GRs("RResult"))
            iRJumsu=(GRs("RJumsu"))

            iGameStatus=(GRs("GameStatus"))
            iStadiumNumber=(GRs("StadiumNumber"))
            iTmp_StadiumNumber=(GRs("Tmp_StadiumNumber"))
            iStartHour=(GRs("StartHour"))
            iStartMinute=(GRs("StartMinute"))
            iMediaLink=(GRs("MediaLink"))
            iGameDay=(GRs("GameDay"))
            iBigo=(GRs("Bigo"))
            iChiefSign=(GRs("ChiefSign"))
            iAssCheifSign1=(GRs("AssCheifSign1"))
            iAssCheifSign2=(GRs("AssCheifSign2"))
            iCheifMain=(GRs("CheifMain"))
            iCheifSub1=(GRs("CheifSub1"))
            iTmp_Round=(GRs("Tmp_Round"))
            iGroupChiefSign=(GRs("GroupChiefSign"))
            iGroupAssChiefSign1=(GRs("GroupAssChiefSign1"))
            iGroupAssChiefSign2=(GRs("GroupAssChiefSign2"))
            iChiefSign=(GRs("ChiefSign"))
            iAssCheifSign1=(GRs("AssCheifSign1"))
            iAssCheifSign2=(GRs("AssCheifSign2"))
            iCheifMain=(GRs("CheifMain"))
            iCheifSub1=(GRs("CheifSub1"))
            iCheifSub2=(GRs("CheifSub2"))
            iCheifWriter=(GRs("CheifWriter"))
%>

<!--  리스트 출력  -->
<!-- S: header -->
<div class="a4">
    <div class="header container-fluid">
      <div class="row">
        <div class="pull-left">
          <a onclick="clickBackbtn();" role="button" class="prev-btn">
          <!--  <span class="icon-prev">
              <i class="fa fa-angle-left" aria-hidden="true"></i>
            </span>-->
            <span class="prev-txt">경기스코어 입력</span>
          </a>
        </div>
        <div>
         <h1 class="logo">
          <img id="DP_UserLogo" src="images/tournerment/intro/logo_kja.png" alt="대한유도회" height="35">
          <!-- <img src="images/tournerment/intro/logo_sja.png" alt="서울특별시유도회" height="35">
          <img src="images/tournerment/intro/logo_kujf.png" alt="한국대학유도연맹" height="35">
          <img src="images/tournerment/intro/logo_kjhs.png" alt="한국 중고등학교 유도연맹" height="35"> -->
        </h1>
        </div>
        <div class="pull-right">
          <span class="sd-logo"><img src="images/tournerment/header/logo@3x.png" alt="스포츠 다이어리" width="100"></span>
<!--
          <a onclick="clickHomebtn()" role="button" class="home-link"><span class="icon-home"><i class="fa fa-home" aria-hidden="true"></i></span></a>

          <a href="javascript:logout();" id="DP_Logout" role="button" class="log-out">
            <span class="icon-logout"><i class="fa fa-power-off" aria-hidden="true"></i></span>
            <span class="logout-txt">로그아웃</span>
          </a>-->
        </div>
      </div>
    </div>
    <!-- E: header -->
    
    <!-- S: main -->
    <div class="main">
      <!-- S: score-enter -->
      <div class="score-enter row">
         
          <!-- S: dl 1경기 / 64강 -->
          <dl class="selected-list">
            <dt>
            <% for i=1 to 6 step 1 %>
             <p>
             <label for="gym1" id="LB_GYM<%=i %>" name="LB_GYM" data-id="<%=i %>">
                <input type="checkbox" id="gym<%=i %>" name="StadiumNumber" value="<%=i %>"  <% if Cint(iStadiumNumber) = i  then %>   checked <% end if %> disabled/> 
                <span><%=i %>경기장</span>
             </label>
             </p>
            <% next %>
            </dt>
            <dd><span id="DP_play-num"> <%=iGameNum %>경기</span> / <span id="DP_play-round"><%=iNowRoundNM %></span></dd>
            <dd class="play-division" id="DP_play-division"><%=GroupGameGbNm %></dd>
            <dd class="play-belong long-word" id="DP_play-belong"><%=TeamGbNm %> </dd>
            <dd class="play-type" id="DP_play-type"><%=LevelNm %></dd>
            <!-- <dd class="play-weight arrange" id="DP_play-weight">-66kg </dd> -->
            <dd class="play-title long-word" id="DP_play-title"><!--제9회 청풍기 전국유도대회<--><span><%=GameTitleName %></span></--></dd>
          </dl>


          <!-- E: dl 날짜/대회명/대회구분 -->
           <%if GroupGameGbNm="개인전" then%>
          <!-- S: score-enter-main -->
          <div class="score-enter-main clearfix">
            <!-- S: skill-btn -->
            <div class="skill-btn">
              <!-- S: direction -->
              <ul class="direction tab-list clearfix">
                <li>
                  <a onclick="skillleftright_info('sd030001');" role="button" class="btn left-skill" id="btn_leftskill"><span class="tab-img"><img src="images/tournerment/enter/radio-off.png" alt width="21" height="21" id="img_leftskill"></span>좌측기술</a>
                </li>
                <li>
                  <a onclick="skillleftright_info('sd030002');" role="butotn" class="btn right-skill" id="btn_rightskill"><span class="tab-img"><img src="images/tournerment/enter/radio-on.png" alt width="21" height="21" id="img_rightskill"></span>우측기술</a>
                </li>
              </ul>
              <!-- E: direction -->

              <!-- S: skill-group -->
              <div class="skill-group">
                <!-- S: hand skill -->
                <dl class="hand-skill clearfix" id="DP_hand-skill">
                  
                  <dt>손기술</dt>
                  <dd>
                    <label>
                      <input type="checkbox">업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">양소매 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">한소매 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">외깃 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">한팔 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">한팔 빗당겨치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">빗당겨치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">어깨로 매치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">기타 손기술</label>
                  </dd>
                </dl>
                
                <!-- E: hand skill -->
                <!-- S: foot skill -->
                <dl class="foot-skill clearfix" id="DP_foot-skill">
                  
                  <dt>발기술</dt>
                  <dd>
                    <label><input type="checkbox">밭다리</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">안다리</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">발뒤축 걸기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">안뒤축 걸기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">안뒤축 후리기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">발목 받치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">허벅다리 걸기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">기타 발기술</label>
                  </dd>
                  
                </dl>
                <!-- E: foot skill -->
                <!-- S: waist skill -->
                <dl class="waist-skill clearfix" id="DP_waist-skill">
                  
                  <dt>허리기술</dt>
                  <dd>
                    <label><input type="checkbox">허리띄기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">허리후리기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">허리채기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">뒤안아 매치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">기타 허리기술</label>
                  </dd>
                  
                </dl>
                <!-- E: waist skill -->

                <!-- S: lie skill -->
                <dl class="lie-skill clearfix" id="DP_lie-skill">
                  
                  <dt>누우며 메치기</dt>
                  <dd>
                    <label><input type="checkbox">배대뒤치기</label>
                  </dd>
                  <dd>
                     <label><input type="checkbox">안오금띄기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">기타누으며 메치기</label>
                  </dd>
                  
                </dl>
                <!-- E: lie skill -->

                <!-- S: counterattack-skill -->
                <!-- <dl class="counterattack-skill clearfix"  id="DP_counterattack-skill">
                  
                  <dt>되치기</dt>
                  <dd>
                    <label><input type="checkbox">손기술 되치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">허리 되치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">발기술 되치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">기타 되치기</label>
                  </dd>
                  
                </dl> -->
                <!-- E: counterattack-skill -->

                <!-- S: hod-skill -->
                <dl class="hold-skill clearfix" id="DP_hold-skill">
                  <dt>굳히기/기타</dt>
                  <dd>
                    <label><input type="checkbox">누르기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">조르기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">꺽기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox">되치기</label>
                  </dd>
                </dl>
                <!-- E: hod-skill -->
              </div>
              <!-- E: skill-group -->

              <!-- S: save-result -->
              <ul class="save-result">
                <li>
                 <a href="#" class="btn btn-save" id="scoresave" onclick="insert_gamedtl();">점수 입력</a>
                </li>
                <li>
                  <!--<a href="#" class="btn btn-save-finish" id="btn_gamestart" onclick="game_start();" style="display:block">경기 시작</a>-->
                  <a href="#" class="btn btn-save-finish" id="btn_gameend" onclick="result_save();" style="display:block">경기 종료</a>
                </li>
              </ul>
              <!-- E: save-result -->

            </div>
            <!-- E: skill-btn -->

            <!-- S: display-board -->
            <div class="display-board">
              <ul class="player-display clearfix">
                <li class="player-1" id="DP_player-name_Up">김재범<span>(비봉고등학교)</span></li>
                <li class="player-2" id="DP_player-name_Down">최보라<span>(중앙여자고등학교)</span></li>
                <li class="v-s">VS</li>
              </ul>
              
              <!-- S: score-board -->
              <div class="score-board">
                <!-- S: point-display -->
              <div class="point-display clearfix">
                <ul class="point-title clearfix">
                  <!-- <li>선수</li> -->
                  <li>한판</li>
                  <li>절반</li>
                  <!-- <li>유효</li> -->
                  <li>지도</li>
                  <li class="no-yuhyo">반칙/실격/<br />부전/기권 승</li>
                  <li class="no-yuhyo-end">양선수</li>
                </ul>
                <ul class="player-1-point player-point clearfix">
                  <!-- <li>
                    <a onclick="jumsu_info('L','sd021001')"><span class="score player-name" id="DP_ScorePname_Up">김영석</span></a>
                  </li> -->
                  <li class="tgClass">
                   <a class="" onclick="jumsu_info(this,'L','sd023001')" name="a_jumsugb"><span class="score" id="LJumsuGb1" >0</span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" onclick="jumsu_info(this,'L','sd023002')" name="a_jumsugb"><span class="score" id="LJumsuGb2" >0</span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" onclick="jumsu_info(this,'L','sd023004')" name="a_jumsugb"><span class="score" id="LJumsuGb4" >0</span></a>
                  </li>
                  <!-- <li class="tgClass">
                    <a class="" onclick="jumsu_info(this,'L','sd023003')" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb3" >0</span></a>
                  </li> -->
                  <li class="select-box-li no-yuhyo">
                    <select class="select-win select-box" id="L_gameresult" onchange="select_gameresult('L');">
                    </select>
                  </li>
                  <!--//
                  <li class="tgClass">
                    <a class="" id="DP_L_sd019013" onclick="jumsu_info(this,'L','sd023005')"><span class="score win-type" ></span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" id="DP_L_sd019005" onclick="jumsu_info(this,'L','sd023006')"><span class="score win-type" ></span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" id="DP_L_sd019006" onclick="jumsu_info(this,'L','sd023007')"><span class="score win-type" ></span></a>
                  </li>
                  -->
                </ul>
                <ul class="player-2-point player-point clearfix">
                  <!-- <li>
                    <a onclick="jumsu_info('R','sd021002')"><span class="score player-name" id="DP_ScorePname_Down">최보라</span></a>
                  </li> -->
                  <li class="tgClass">
                    <a class="" onclick="jumsu_info(this,'R','sd023001')" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" onclick="jumsu_info(this,'R','sd023002')" name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" onclick="jumsu_info(this,'R','sd023004')" name="a_jumsugb"><span class="score" id="RJumsuGb4">0</span></a>
                  </li>
                  <!-- <li class="tgClass">
                    <a class="" onclick="jumsu_info(this,'R','sd023003')" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb3">0</span></a>
                  </li> -->
                  <li class="select-box-li no-yuhyo">
                    <select class="select-win select-box" id="R_gameresult" onchange="select_gameresult('R');">
                    </select>
                  </li>
                  <!--//
                  <li class="tgClass">
                    <a class="" id="DP_R_sd019013" onclick="jumsu_info(this,'R','sd023005')"><span class="score win-type"></span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" id="DP_R_sd019005" onclick="jumsu_info(this,'R','sd023006')"><span class="score win-type"></span></a>
                  </li>
                  <li class="tgClass">
                    <a class="" id="DP_R_sd019006" onclick="jumsu_info(this,'R','sd023007')"><span class="score win-type"></span></a>
                  </li>
                  -->
                </ul>
                <div class="player-match-option player-point">
                  <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose"><input type="checkbox" /><span>부전패</span></label>

                  <label for="player-match-option-02" class="tgClass draw" id="LRResult_Draw"><input type="checkbox" /><span id="DP_DualResult_Text">무승부</span></label>

                  <!--<label for="player-match-option-03" class="tgClass no-attend" id="LRResult_Draw"><input type="checkbox" id="player-match-option-03" /><span>불참</span></label>-->

                </div>
              </div>
              <!-- E: point-display -->

              <!-- S: match-result -->
              <div class="match-result">
                <!-- <h2>득실기록</h2> -->
                <!-- S: result-list 경기결과 리스트 -->
                <ul class="result-list" id="DP_result-list">
                  <li class="match-title">득실기록</li>
                  
                  <li class="mine">
                    <p>
                    [<span class="score-time">3:00</span>]<span class="player-name">김영석</span>
                       : <span class="">누우며 메치기</span>(<span class="skill">기타누으며 메치기</span>) <button class="btn btn-del" type="button"><i class="fa fa-times" aria-hidden="true"></i><span class="sr-only">닫기</span></button>
                    </p>
                  </li>
                  <li class="opponent">
                    <p>
                    [<span class="score-time">3:00</span>]<span class="player-name">최보라</span>
                       : <span class="">누우며 메치기</span>(<span class="skill">기타누으며 메치기</span>) <button class="btn btn-del" type="button"><i class="fa fa-times" aria-hidden="true"></i><span class="sr-only">닫기</span></button>
                    </p>
                  </li>
                  
                </ul>
              <!-- E: result-list 경기결과 리스트 -->
              </div>
              <!-- E: match-result -->
              </div>
              <!-- E: score-board -->
              <!-- S: time-table -->
              <div class="time-table">
                <!-- S: 연장, time 아이콘 -->
                <ul class="clearfix">
                  <li class="time-mark">
                    <span><i class="fa fa-clock-o" aria-hidden="true"></i></span>
                    <span>TIME</span>
                  </li>
                  <li class="injury-mark">
                    <label id="DP_OverTime" class="on"><input id="OverTime" name="OverTime" type="checkbox" value="1"><span>연장</span></label>
                  </li>
                </ul>
                <!-- E: 연장, time 아이콘 -->
                <!-- S: set-time -->
                <ul class="set-time clearfix">
                  <li name="gameTime" data-id="3"></li>
                  <li class="divider">:</li>
                  <li name="gameTime" data-id="2"></li>
                  <li name="gameTime" data-id="1"></li>
                </ul>
                <!-- E: set-time -->
                <!-- S: time-btn -->
                <ul class="times clearfix">
                  <li><a onclick="display_inputTime('1')" class="btn time-btn">1</a></li>
                  <li><a onclick="display_inputTime('2')" class="btn time-btn">2</a></li>
                  <li><a onclick="display_inputTime('3')" class="btn time-btn">3</a></li>
                  <li><a onclick="display_inputTime('4')" class="btn time-btn">4</a></li>
                  <li><a onclick="display_inputTime('5')" class="btn time-btn">5</a></li>
                  <li><a onclick="display_inputTime('6')" class="btn time-btn">6</a></li>
                  <li><a onclick="display_inputTime('7')" class="btn time-btn">7</a></li>
                  <li><a onclick="display_inputTime('8')" class="btn time-btn">8</a></li>
                  <li><a onclick="display_inputTime('9')" class="btn time-btn">9</a></li>
                  <li><a onclick="display_inputTime('0')" class="btn time-btn">0</a></li>
                  <li><a onclick="display_inputTime('Delete')" class="btn time-btn del-time">< 시각삭제</a></li>
                </ul>
                <!-- E: time-btn -->
              </div>
              <!-- E: time-table -->

              <!-- S: time-table old -->
              <!-- <div class="time-table"> -->
                <!-- S: time-list -->
                <!-- <dl class="time-list">
                  <dt>경기시간</dt>
                  <dd class="on"><a onclick="insert_gamedtl('05:00');" class="btn time-btn">05:00 ~ 04:01</a></dd>
                  <dd><a onclick="insert_gamedtl('02:00');" class="btn time-btn">02:00 ~ 01:01</a></dd>
                  <dd><a onclick="insert_gamedtl('04:00');" class="btn time-btn">04:00 ~ 03:01</a></dd>
                  <dd><a onclick="insert_gamedtl('01:00');" class="btn time-btn">01:00 ~ 00:00</a></dd>
                  <dd><a onclick="insert_gamedtl('03:00');" class="btn time-btn">03:00 ~ 02:01</a></dd>
                  <dd><a onclick="insert_gamedtl('00:00');" class="btn time-btn">골든스코어</a></dd>
                </dl> -->
                <!-- E: time-list -->
              <!-- </div> -->
              <!-- E: time-table old -->
            </div>
            <!-- E: display-board -->

            <!-- S: time-table -->
            <!-- <div class="time-table"> -->
              <!-- S: result-select -->
              <!-- <ul class="result-select">
                <li>
                  <select id="WinPlayer"> -->
                    <!--
                    <option value="">김영석</option>
                    <option value="">최보라</option>
                    -->
                  <!-- </select>
                </li>
                <li>
                  <select id="gameresult">
                    
                  </select>
                </li>
              </ul> -->
              <!-- E: result-select -->
             <!--  <div class="save-result">
                <button class="btn btn-save" id="resultsave" onclick="result_save();">점수 입력</button>
                <button class="btn btn-save btn-save-finish" id="resultsave" onclick="result_save();">기록 완료</button>
              </div>
            </div>
            <!-- E: time-table -->

            <!-- S: sign-list -->
            <ul class="sign-list clearfix">
              <li class="chief">
                <span class="judge">주심</span>
                <span class="sign-mark" id="chiefSign_copy"></span>

                <button type="button" class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="chiefSign" id="btn_chiefSign" style="display:block">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>
                <span class="accept-end" id="result_chiefSign" style="display:none"><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span>
                <a data-toggle="modal" data-target="#sign-modal" data-whatever="chiefSign">승인완료</a></span>
              </li>
              <li class="assistant">
                <span class="judge">부심</span>
                <span class="sign-mark" id="asschiefSign1_copy"></span>
                
                <button type="button" class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign1" id="btn_asschiefSign1" style="display:block">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>
                <span class="accept-end" id="result_asschiefSign1" style="display:none"><span class="icon"><i class="fa fa-check" aria-hidden="true" ></i></span>
                <a data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign1">승인완료</a></span>
              </li>
              <li class="assistant">
                <span class="judge">부심</span>
                <span class="sign-mark second" id="asschiefSign2_copy"></span>
                
                <button type="button" class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign2" id="btn_asschiefSign2" style="display:block">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>                
                <span class="accept-end" id="result_asschiefSign2" style="display:none"><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span>
                <a data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign2">승인완료</a>
                </span>
              </li>
            </ul>
            <!-- E: sign-list -->
          </div>
          <!-- E: score-enter-main -->
           <%else%>
          <!-- S: group-enter-main -->
          <div class="group-enter-main">
            <p>단체전 입력표</p>
          </div>
          <!-- E: group-enter-main -->
           <%end if%>

      </div>
      <!-- E: score-enter -->
<!--  리스트 출력  -->
    </div>

</div>
 <%
        
  GRs.MoveNext
  Loop 
  End If 
    GRs.Close
  SET GRs = Nothing

    scoreRs.Close
  SET scoreRs = Nothing
%>



 