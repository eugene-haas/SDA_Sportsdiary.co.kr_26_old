<!--#include virtual="/Manager/Common/common_header_tourney.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
PlayerResultIdx = fInject(Request("input_PlayerResultIdx"))
RGameLevelidx = fInject(Request("input_RGameLevelidx"))
SportsGb = fInject(Request("input_SportsGb"))
GameTitleIDX = fInject(Request("input_GameTitleIDX"))
TeamGb = fInject(Request("input_TeamGb"))
Sex = fInject(Request("input_Sex"))
Level = fInject(Request("input_Level"))
GroupGameGb = fInject(Request("input_GroupGameGb"))
GameType = fInject(Request("input_GameType"))  
GroupGameNum = fInject(Request("input_GroupGameNum"))  
GameNum = fInject(Request("input_GameNum"))  
EnterType = fInject(Request("input_EnterType"))  
input_printIdx = fInject(Request("input_printIdx"))  

GroupGameGbNm = fInject(Request("input_GroupGameGbNm"))  
TeamGbNm = fInject(Request("input_TeamGbNme"))  
LevelNm = fInject(Request("input_LevelNm"))  
GameTitleName = fInject(Request("input_GameTitleName"))  

  
GSQL = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'" & _
    ",'playerList_one','"& GroupGameNum &"','"& GameNum &"'" 

'Response.Write GSQL
'Response.End

Set GRs = Dbcon.Execute(GSQL) 
If Not(GRs.Eof Or GRs.Bof) Then 
Do Until GRs.Eof 
            

    iPlayerResultIdx=(GRs("PlayerResultIdx"))
    iRound=(GRs("Round"))
    iTurnNum=(GRs("TurnNum"))
    Sex=GRs("Sex")
    HostNm =GRs("HostNm")
    HostCode =GRs("HostCode")

    if GroupGameGb="sd040001" then
        iLPlayerIDX=(GRs("LPlayerIDX"))
        iLTeam=(GRs("LTeam"))
        iNowRoundNM=(GRs("NowRoundNM"))
        iNowRound=(GRs("NowRound"))

        iRPlayerIDX=(GRs("RPlayerIDX"))
        iRTeam=(GRs("RTeam"))

        s_StadiumNumber=GRs("StadiumNumber")
        s_GameNum=GRs("GameNum") 

        
        if s_StadiumNumber="" then 
            s_StadiumNumber=GRs("Tmp_StadiumNumber")
        end  if
        
        if s_StadiumNumber="" then 
            s_StadiumNumber=0
        end if
    else
        iLTeam=(GRs("LTeam"))  
        iRTeam=(GRs("RTeam"))
        s_StadiumNumber=GRs("Tmp_StadiumNumber")
        s_GameNum=GRs("GroupGameNum")

        s_LTeam	=GRs("LTeam")
        s_LSchoolName	=GRs("LSchoolName")
        
        s_RTeam	=GRs("RTeam")
        s_RSchoolName=GRs("RSchoolName")

        s_GroupChiefSign=GRs("GroupChiefSign")
        s_GroupAssChiefSign1=GRs("GroupAssChiefSign1")
        s_GroupAssChiefSign2=GRs("GroupAssChiefSign2")    
          
        roundSQL = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'" & _
            ",'tblRGameLevel','"& GRs("GroupGameNum") &"','"& GRs("GameNum") &"','"& GRs("Round") &"'" 

             
        Set roundRs = Dbcon.Execute(roundSQL) 
        If Not(roundRs.Eof Or roundRs.Bof) Then 
        Do Until roundRs.Eof 

        TotRound =roundRs("TotRound")

        if TotRound = "2" then 
            TotRoundNm ="결승"
        elseif  TotRound = "4" then 
            TotRoundNm ="준결승"
        else
            TotRoundNm =TotRound &"강"
        end if 
    
        roundRs.MoveNext
        Loop 
        End If 
        roundRs.Close
         
    end if

     
            
    divId="" & GRs("RGameLevelidx") &"_"& GRs("GroupGameNum")&"_"& GRs("GameNum") 
%>

<head>
    <title>상세기록조회</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="-1">
     <style>
    /* following three (cascaded) are equivalent to above three meta viewport statements */
    /* see http://www.quirksmode.org/blog/archives/2014/05/html5_dev_conf.html */
    /* see http://dev.w3.org/csswg/css-device-adapt/ */
        @-ms-viewport { width: 100vw ; min-zoom: 100% ; zoom: 100% ; }          @viewport { width: 100vw ; min-zoom: 100% zoom: 100% ; }
        @-ms-viewport { user-zoom: fixed ; min-zoom: 100% ; }                   @viewport { user-zoom: fixed ; min-zoom: 100% ; }
        /*@-ms-viewport { user-zoom: zoom ; min-zoom: 100% ; max-zoom: 200% ; }   @viewport { user-zoom: zoom ; min-zoom: 100% ; max-zoom: 200% ; }*/
    </style>

    <link href="css/bootstrap-theme.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.css" rel="stylesheet" type="text/css" />
      <!-- bootstrap popover -->
    <link href="css/tourney.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../Css/_enter-score.css">

    <script src="../../webtournament/www/js/global.js"></script>
    <script src="../js/jquery-1.12.2.min.js"></script> 
    <script src="js/bootstrap.js"></script>
    <script src="js/html2canvas.js"></script>
    <script src="js/tourneyData.js"></script>
    <script src="js/tourney_print.js" type="text/javascript"></script>
     <script type="text/javascript">
         
         parent.loading();

         var C_GameTitleName = "<%=GameTitleName %>";
         var C_GroupGameGbNm = "<%=GroupGameGbNm %>";
         var C_TeamGbNm = "<%=TeamGbNm %>";
         var C_LevelNm = "<%=LevelNm %>";
         var s_StadiumNumber = "<%=s_StadiumNumber %>";
         var s_GameNum = "<%=s_GameNum %>";
         var s_input_printIdx = "<%=input_printIdx %>";

         var onLoad = function () {
             var WcanvasPrint = $.when(canvasPrint());
             setTimeout(function () {
                 window.close();
             }, 400);
         }

         function canvasPrint() {
             var $a4 = $(".a4");
             var Enter_Score_Print_data = "";
             var Enter_Score_Print_data_str = "";
             for (var i = 0; i < $a4.length; i++) {
                 html2canvas($a4[i], {
                     onrendered: function (canvas) {
                         Enter_Score_Print_data = "<div class='a4' id='CanvasImg_" + s_input_printIdx + "'><img src=" + canvas.toDataURL("image/png") + " > </div>";
                         $("#Enter_Score_Print").append(Enter_Score_Print_data);
                         Enter_Score_Print_data_str += Enter_Score_Print_data;
                         $('#Enter_Score_Print', parent.document).append(Enter_Score_Print_data_str);
                        
                         parent.loadingHide();
                     }
                 });
             }
         }
    </script>
</head>
<!--  리스트 출력  -->
<!-- S: header -->
<body  onload="onLoad()" id="AppBody">

<div class="tourney-img" style="display: block;"  ><a href="javascript:;printC()" class="btn btn-save" id="print">인쇄</a></div>
<div class="sub sub-main tourney container-fluid">

<div class="tourney-img" style="display: block;" id="DP_tourney">
<div class="a4 <%=divId %>" id="Score_<%=divId %>">
    <div class="header container-fluid">
      <div class="row">
        <div class="pull-left">
          <a  role="button" class="prev-btn">
          <!--  <span class="icon-prev">
              <i class="fa fa-angle-left" aria-hidden="true"></i>
            </span>-->
            <span class="prev-txt">경기스코어 입력</span>
          </a>
        </div>
        <div>
         <% if HostCode ="sd053001" then 
            %><h1 class="logo"><img id="DP_UserLogo" src="images/tournerment/intro/logo_kja.png" alt="대한유도회" height="35"></h1><%
            elseif HostCode ="sd053002" then 
            %><h1 class="logo"><img src="images/tournerment/intro/logo_kjhs.png" alt="한국 중고등학교 유도연맹" height="35"></h1><%
            elseif HostCode ="sd053003" then 
            %><h1 class="logo"><img src="images/tournerment/intro/logo_kujf.png" alt="한국대학유도연맹" height="35"></h1><%
            elseif HostCode ="sd053004" then 
              %><span class="hostName"><%=HostNm %></span><% 
            elseif HostCode ="sd053005" then 
              %><span class="hostName"><%=HostNm %></span><% 
            elseif HostCode ="sd053006" then 
            %><h1 class="logo"><img src="images/tournerment/intro/logo_sja.png" alt="서울특별시유도회" height="35"></h1><%
            elseif HostCode ="sd053007" then 
              %><span class="hostName"><%=HostNm %></span><% 
            else
              %><span class="hostName"><%=HostNm %></span><% 
            end if 
          %>
        </div>
        <div class="pull-right">
          <span class="sd-logo"><img src="images/tournerment/header/logo@3x.png" alt="스포츠 다이어리" width="100"></span>
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
                <input type="checkbox" id="gym<%=i %>" name="StadiumNumber" value="<%=i %>"  <% if  Cint(s_StadiumNumber) = i  then %>   checked <% end if %> disabled /> 
                <span><%=i %>경기장</span>
             </label>
             </p> 
            <% next %>
            </dt>
            <dd><span id="DP_play-num"> <%=s_GameNum %>경기</span> / <span id="DP_play-round"><%if iNowRoundNM="" then %><%=TotRoundNm %><%else%><%=iNowRoundNM %> <%end if%> </span></dd>
            <dd class="play-division" id="DP_play-division"><%=GroupGameGbNm %></dd>
            <dd class="play-belong long-word" id="DP_play-belong"><span><%=TeamGbNm %> </span></dd>
            <dd class="play-type" id="DP_play-type"><%if GroupGameGb="sd040001" then%> <%=LevelNm %>  <%else%>  <% if Sex = "Man" then %> 남자 <%else %> 여자 <%end if %>  <%end if%> </dd>
            <!-- <dd class="play-weight arrange" id="DP_play-weight">-66kg </dd> -->
            <dd class="play-title long-word" id="DP_play-title"><span><%=GameTitleName %></span></dd>
          </dl>
          <!-- E: dl 날짜/대회명/대회구분 -->
          <%if GroupGameGb="sd040001" then%>
          <!-- S: score-enter-main -->
          <div class="score-enter-main clearfix">
            <!-- S: skill-btn -->
            <div class="skill-btn">
              <!-- S: direction -->
              <ul class="direction tab-list clearfix">
                <li>
                  <a  role="button" class="btn left-skill" id="btn_leftskill"><span class="tab-img"><img src="images/tournerment/enter/radio-off.png" alt width="21" height="21" id="img_leftskill"></span>좌측기술</a>
                </li>
                <li>
                  <a role="butotn" class="btn right-skill" id="btn_rightskill"><span class="tab-img"><img src="images/tournerment/enter/radio-off.png" alt width="21" height="21" id="img_rightskill"></span>우측기술</a>
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
                      <input type="checkbox" disabled>업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>양소매 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>한소매 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>외깃 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>한팔 업어치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>한팔 빗당겨치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>빗당겨치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>어깨로 매치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>기타 손기술</label>
                  </dd>
                </dl>
                
                <!-- E: hand skill -->
                <!-- S: foot skill -->
                <dl class="foot-skill clearfix" id="DP_foot-skill">
                  
                  <dt>발기술</dt>
                  <dd>
                    <label><input type="checkbox" disabled>밭다리</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>안다리</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>발뒤축 걸기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>안뒤축 걸기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>안뒤축 후리기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>발목 받치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>허벅다리 걸기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>기타 발기술</label>
                  </dd>
                  
                </dl>
                <!-- E: foot skill -->
                <!-- S: waist skill -->
                <dl class="waist-skill clearfix" id="DP_waist-skill">
                  
                  <dt>허리기술</dt>
                  <dd>
                    <label><input type="checkbox" disabled>허리띄기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>허리후리기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>허리채기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>뒤안아 매치기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>기타 허리기술</label>
                  </dd>
                  
                </dl>
                <!-- E: waist skill -->

                <!-- S: lie skill -->
                <dl class="lie-skill clearfix" id="DP_lie-skill">
                  
                  <dt>누우며 메치기</dt>
                  <dd>
                    <label><input type="checkbox" disabled>배대뒤치기</label>
                  </dd>
                  <dd>
                     <label><input type="checkbox" disabled>안오금띄기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>기타누으며 메치기</label>
                  </dd>
                  
                </dl>
                <!-- E: lie skill -->


                <!-- S: hod-skill -->
                <dl class="hold-skill clearfix" id="DP_hold-skill">
                  <dt>굳히기/기타</dt>
                  <dd>
                    <label><input type="checkbox" disabled>누르기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>조르기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>꺽기</label>
                  </dd>
                  <dd>
                    <label><input type="checkbox" disabled>되치기</label>
                  </dd>
                </dl>
                <!-- E: hod-skill -->
              </div>
              <!-- E: skill-group -->

              <!-- S: save-result -->
              <ul class="save-result">
                <li>
                 <a  class="btn btn-save" id="scoresave" >점수 입력</a>
                </li>
                <li>
                  <!--<a  class="btn btn-save-finish" id="btn_gamestart"   style="display:block">경기 시작</a>-->
                  <a  class="btn btn-save-finish" id="btn_gameend"  style="display:block">경기 종료</a>
                </li>
              </ul>
              <!-- E: save-result -->

            </div>
            <!-- E: skill-btn -->

            <!-- S: display-board -->
            <%
                PlayerSql = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'" & _ 
                            ",'player','"& GRs("GroupGameNum") &"','"& GRs("GameNum") &"'" 
                        
                'Response.Write "<li><p>"&PlayerSql&"</p></li>"
                'Response.End
                Set  PlayerRs = Dbcon.Execute(PlayerSql) 
                If Not(PlayerRs.Eof Or PlayerRs.Bof) Then 
                Do Until PlayerRs.Eof 

                    LPlayerName	    =PlayerRs("LPlayerName")
                    LResult		    =PlayerRs("LResult")
                    LPlayerResult	=PlayerRs("LPlayerResult")
                    LSchoolName		=PlayerRs("LSchoolName")
                    LSkillResult	=PlayerRs("LSkillResult")
                    LTeamSidoNm	    =PlayerRs("LTeamSidoNm")
	
                    RPlayerName	    =PlayerRs("RPlayerName")
                    RResult		    =PlayerRs("RResult")
                    RPlayerResult	=PlayerRs("RPlayerResult")
                    RSchoolName		=PlayerRs("RSchoolName")	
                    RSkillResult	=PlayerRs("RSkillResult")	
                    RTeamSidoNm	    =PlayerRs("RTeamSidoNm")

                    MediaLink       =PlayerRs("MediaLink")	

                PlayerRs.MoveNext
                Loop 
                End If 
                PlayerRs.Close



                sCoreSql = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'" & _ 
                            ",'playerScore','"& GRs("GroupGameNum") &"','"& GRs("GameNum") &"'" 
                        
                'Response.Write "<li><p>"&PlayerSql&"</p></li>"
                'Response.End
                
                Set  sCoreRs = Dbcon.Execute(sCoreSql) 
                If Not(sCoreRs.Eof Or sCoreRs.Bof) Then 
                Do Until sCoreRs.Eof 
                    Left01	        =sCoreRs("Left01")
                    Left02		    =sCoreRs("Left02")
                    Left03	        =sCoreRs("Left03")
                    Left04		    =sCoreRs("Left04")
                    Left05	        =sCoreRs("Left05")
                    Left06	        =sCoreRs("Left06")
                    Left07	        =sCoreRs("Left07")
	
                    Right01	        =sCoreRs("Right01")
                    Right02		    =sCoreRs("Right02")
                    Right03	        =sCoreRs("Right03")
                    Right04		    =sCoreRs("Right04")
                    Right05	        =sCoreRs("Right05")
                    Right06	        =sCoreRs("Right06")
                    Right07	        =sCoreRs("Right07")
                     
                sCoreRs.MoveNext
                Loop 
                End If 
                sCoreRs.Close
            %> 

            <div class="display-board">
              <ul class="player-display clearfix">
                <li class="player-1" id="DP_player-name_Up"><%=LPlayerName %><span>(<%=LSchoolName %>)</span></li>
                <li class="player-2" id="DP_player-name_Down"><%=RPlayerName %><span>(<%=RSchoolName %>)</span></li>
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
                    <a  ><span class="score player-name" id="DP_ScorePname_Up">김영석</span></a>
                  </li> -->
                  <li class="tgClass">
                   <a class=""  name="a_jumsugb"><span class="score" id="LJumsuGb1" ><%=Left01 %></span></a>
                  </li>
                  <li class="tgClass">
                    <a class=""  name="a_jumsugb"><span class="score" id="LJumsuGb2" ><%=Left02 %></span></a>
                  </li>
                  <li class="tgClass">
                    <a class=""  name="a_jumsugb"><span class="score" id="LJumsuGb4" ><%=Left04 %></span></a>
                  </li>
                  <!-- <li class="tgClass">
                    <a class=""   name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb3" ><%=Left03 %></span></a>
                  </li> -->
                  <li class="select-box-li no-yuhyo">
                    <select class="select-win select-box" id="L_gameresult" >
                    <%
                    if LSkillResult="sd023005" then
                       %> <option value="sd023005" selected>실격승</option><%
                    elseif LSkillResult="sd023006" then
                       %><option value="sd023006" selected>반칙승</option><%
                    elseif  LSkillResult="sd023007" then
                       %><option value="sd023007" selected>부전승</option><%
                    elseif  LSkillResult="sd023008" then
                        %><option value="sd023008" selected>기권승</option><%
                    
                    end if
                     %>
                    </select>
                  </li>
                
                </ul>
                <ul class="player-2-point player-point clearfix">
                  <!-- <li>
                    <a  ><span class="score player-name" id="DP_ScorePname_Down">최보라</span></a>
                  </li> -->
                  <li class="tgClass">
                    <a class=""   name="a_jumsugb"><span class="score" id="RJumsuGb1"><%=Right01 %></span></a>
                  </li>
                  <li class="tgClass">
                    <a class=""  name="a_jumsugb"><span class="score" id="RJumsuGb2"><%=Right02 %></span></a>
                  </li>
                  <li class="tgClass">
                    <a class=""   name="a_jumsugb"><span class="score" id="RJumsuGb4"><%=Right04 %></span></a>
                  </li>
                  <!-- <li class="tgClass">
                    <a class=""   name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb3"><%=Right03 %></span></a>
                  </li> -->
                  <li class="select-box-li no-yuhyo">
                    <select class="select-win select-box" id="R_gameresult" >
                    <%
                     if RSkillResult="sd023005" then
                       %> <option value="sd023005" selected>실격승</option><%
                    elseif RSkillResult="sd023006" then
                       %><option value="sd023006" selected>반칙승</option><%
                    elseif  RSkillResult="sd023007" then
                       %><option value="sd023007" selected>부전승</option><%
                    elseif  RSkillResult="sd023008" then
                        %><option value="sd023008" selected>기권승</option><%
                    end if
                     %>
                    </select>
                  </li>
                
                </ul>
                <div class="player-match-option player-point">
                
                  <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose"><input type="checkbox"<%if LPlayerResult="sd019012" then%> checked <%end if %> disabled /><span>부전패</span></label>

                  <label for="player-match-option-02" class="tgClass draw" id="LRResult_Draw"><input type="checkbox"<%if LPlayerResult="sd019024" then%>checked <%end if %> disabled /><span id="DP_DualResult_Text">무승부</span></label>

                  <!--<label for="player-match-option-03" class="tgClass no-attend" id="LRResult_Draw"><input type="checkbox" disabled id="player-match-option-03" /><span>불참</span></label>-->

                </div>
              </div>
              <!-- E: point-display -->

              <!-- S: match-result -->
              <div class="match-result">
                <!-- <h2>득실기록</h2> -->
                <!-- S: result-list 경기결과 리스트 -->
                <ul class="result-list" id="DP_result-list">
                  <li class="match-title">득실기록</li>
                    <%
                        sBoardSql = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'" & _ 
                                  ",'ScoreBoard','"& GRs("GroupGameNum") &"','"& GRs("GameNum") &"'" 
                        
                        'Response.Write "<li><p>"&sBoardSql&"</p></li>"

                        Set  SBoardRs = Dbcon.Execute(sBoardSql) 
                        If Not(SBoardRs.Eof Or SBoardRs.Bof) Then 
                        Do Until SBoardRs.Eof 
                        
                        RGameResultDtlIDX	= SBoardRs("RGameResultDtlIDX")
                        LeftRight	= SBoardRs("LeftRight")	

                        JumsuGb		= SBoardRs("JumsuGb")
                        SpecialtyGb		= SBoardRs("SpecialtyGb")
                        SpecialtyDtl	= SBoardRs("SpecialtyDtl")	

                        CheckTime	= SBoardRs("CheckTime")	
                        PlayerPosition		= SBoardRs("PlayerPosition")
                        IDX	= SBoardRs("IDX")	
                        PlayerName		= SBoardRs("PlayerName")
                        OverTime	= SBoardRs("OverTime")
                        %>
                          <li class="<%if PlayerPosition="LPlayer" then %>mine <%else %> opponent <%end if %>">
                            <p>
                                <span class="score-time"> <%=CheckTime %> </span><%if OverTime<>0 then %> (연장) <%end if %>
                                <span class="player-name"><%=PlayerName %></span>: 
                                <span class=""><%=JumsuGb %></span>
                                <%if SpecialtyGb<>"" then %>
                                 (<span class="skill"><%=SpecialtyGb %> / <%=SpecialtyDtl %></span>)
                                 <%end if %>
                             </p>
                          </li>
                        <%
                        SBoardRs.MoveNext
                        Loop 
                        End If 
                        SBoardRs.Close
                     %> 
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
                    <label id="DP_OverTime" class="on"><input id="OverTime" name="OverTime" type="checkbox" disabled value="1"><span>연장</span></label>
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
                  <li><a  class="btn time-btn">1</a></li>
                  <li><a   class="btn time-btn">2</a></li>
                  <li><a   class="btn time-btn">3</a></li>
                  <li><a  class="btn time-btn">4</a></li>
                  <li><a  class="btn time-btn">5</a></li>
                  <li><a class="btn time-btn">6</a></li>
                  <li><a  class="btn time-btn">7</a></li>
                  <li><a  class="btn time-btn">8</a></li>
                  <li><a  class="btn time-btn">9</a></li>
                  <li><a  class="btn time-btn">0</a></li>
                  <li><a class="btn time-btn del-time">< 시각삭제</a></li>
                </ul>
                <!-- E: time-btn -->
              </div>
              <!-- E: time-table -->
 
            </div>
            <!-- E: display-board -->
            <%
                SignSql = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'" & _ 
                          ",'SignSelect','"& GRs("GroupGameNum") &"','"& GRs("GameNum") &"'" 
            
                Set  SignRs = Dbcon.Execute(SignSql) 
                If Not(SignRs.Eof Or SignRs.Bof) Then 
                Do Until SignRs.Eof 

                ChiefSign	=SignRs("ChiefSign")
                AssCheifSign1   =SignRs("AssCheifSign1")
                AssCheifSign2	=SignRs("AssCheifSign2")
 
                SignRs.MoveNext
                Loop 
                End If 
                SignRs.Close
             %>
            <!-- S: sign-list -->
            <ul class="sign-list clearfix">
              <li class="chief">
                <span class="judge">주심</span>
                <span class="sign-mark" id="chiefSign_copy"><%if ChiefSign<>"" then  %> <img src="<%=ChiefSign %>" width="188" height="69"> <%end if %> </span>

                <button type="button" class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="chiefSign" id="btn_chiefSign" style="display:none">승인하기 
                    <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span>
                </button>

                <%if ChiefSign<>"" then  %>  
                    <span class="accept-end" id="Span1" style="display:block"><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span><a data-toggle="modal" data-target="#sign-modal" data-whatever="chiefSign">승인완료</a></span>
                 <%end if %> 
               
              </li>
              <li class="assistant">
                <span class="judge">부심</span>
                <span class="sign-mark" id="asschiefSign1_copy"><%if AssCheifSign1<>"" then  %><img src="<%=AssCheifSign1 %>" width="188" height="69"><%end if %>  </span>
                
                <button type="button" class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign1" id="btn_asschiefSign1" style="display:none">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>
               <%if ChiefSign<>"" then  %>  
                <span class="accept-end" id="result_asschiefSign1" style="display:block"><span class="icon"><i class="fa fa-check" aria-hidden="true" ></i></span>
                <a data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign1">승인완료</a></span>
              <%end if %> 
              </li>
              <li class="assistant">
                <span class="judge">부심</span>
                <span class="sign-mark second" id="asschiefSign2_copy"><%if AssCheifSign2<>"" then  %><img src="<%=AssCheifSign2 %>" width="188" height="69"> <%end if %> </span>
                
                <button type="button" class="btn btn-accept" data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign2" id="btn_asschiefSign2" style="display:none">승인하기 <span class="icon"><i class="fa fa-angle-right" aria-hidden="true"></i></span></button>                
                 <%if ChiefSign<>"" then  %>  
                <span class="accept-end" id="result_asschiefSign2" style="display:block"><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span>
                <a data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign2">승인완료</a>
                </span>
                 <%end if %> 
              </li>
            </ul>
            <!-- E: sign-list -->
          </div>
          <!-- E: score-enter-main -->
           <%else %>
          <!-- S: group-enter-main -->
          <div class="group-enter-main">
            <!-- S : inner -->
          <div class="inner">
              <!-- S : top-navi-list -->
              <div class="top-navi-list">
                <ul class="top-navi-1">
                  <li id="DP_player-school_Up2"><%=s_LSchoolName %></li>
                  <li class="top-navi-btn">
                      <a  role="button" class="btn btn-enter-player on" data-whatever="splayerModal" id="btn_playerModal">출전선수 등록하기</a>
                      <a  role="button" class="btn btn-add-match" data-whatever="splayerModal" id="btn_addplayerModal">연장경기 추가하기</a>
                  </li>
                  <li id="DP_player-school_Down2"><%=s_RSchoolName %></li>
                </ul>
                <ul class="top-navi-2">
                  <li class="player-name">선수명</li>
                  <li>체급항목</li>
                  <li>승패</li>
                  <li class="score-num">점수</li>
                  <li class="btn-score-modify">기술명(득실점 내역)</li>
                  <li class="score-num">점수</li>
                  <li>승패</li>
                  <li>체급항목</li>
                  <li class="player-name">선수명</li>
                </ul>
              </div>
              <!-- E : top-navi-list -->

              <!-- S : 선수별 경기 내역 표시 
                <div class="list-score-wrap"> : 스크롤 없는 버전
                <div class="list-score-scroll"> : 스크롤 있는 버전
                타블렛에서 확인하면 스크롤이 깨지지 않고 보입니다.
                table 내용은 11줄이 기본으로 노출됩니다.
              -->
            
                <div class="list-score-wrap">
                  <div class="list-score" id="grouplist">
                   <%
                        '출전 선수 명단 조회 '' +대전 결과
               
                        PListSQL = "exec View_match_Score '"&SportsGb&"','"&GameTitleIDX&"','"&RGameLevelidx&"','"&TeamGb&"','"&Sex&"','"&Level&"','"&GroupGameGb&"','"&GameType&"'" & _
                        ",'player','"& GroupGameNum &"','"& GameNum &"'" 

                       ' Response.Write PListSQL
                       ' Response.End

                       plrsSeq=0
                       LJumsuQ=0
                       RJumsuQ=0

                       lteam=""
                       lteamdtl=""
                       Rteam=""
                       Rteamdtl=""

                        Set PLRs = Dbcon.Execute(PListSQL) 
                        If Not(PLRs.Eof Or PLRs.Bof) Then 
                        Do Until PLRs.Eof 
                        plrsSeq = plrsSeq+1

                        LUserName	 = PLRs("LUserName")
                        LLevelName		 = PLRs("LLevelName")
                        LPlayerResultNm	 = PLRs("LPlayerResultNm")

                        LJumsu		 = PLRs("LJumsu")
                        LFinalSkill		 = PLRs("LFinalSkill")
                        
                        RFinalSkill		 = PLRs("RFinalSkill")
                        RJumsu		 = PLRs("RJumsu")
                        RPlayerResultNm		 = PLRs("RPlayerResultNm")

                        RLevelName		 = PLRs("RLevelName")
                        RUserName		 = PLRs("RUserName")

                        if  LJumsu >0 then 
                             DP_Total_Lw =DP_Total_Lw+1
                        end if

                        if  RJumsu >0 then 
                            DP_Total_Rw =DP_Total_Rw+1
                        end if
                        
                       
                        LJumsuQ =LJumsuQ+LJumsu
                        RJumsuQ =RJumsuQ+RJumsu

                        %>
                        <ul>
                          <li> <%=LUserName %>  </li>
                          <li> <%=LLevelName %></li>
                          <li>
                            <span class="result"><%=LPlayerResultNm %></span> 
                          </li>
                          <li>
                            <span><%=LJumsu %></span>
                          </li>
                          <li>
                            <span><%=LFinalSkill %></span>
                          </li>
                          <li>
                            <a  role="button" class="btn btn btn-repair">스코어 수정 <i class="fa fa-angle-right" aria-hidden="true"></i></a>
                          </li>
                          <li>
                             <span><%=RFinalSkill %></span>
                          </li>
                          <li>
                            <span><%=RJumsu %></span>
                          </li>
                          <li>
                              <span class="result"><%=RPlayerResultNm %></span> 
                          </li>	
                          <li><%=RLevelName %></li>
                           <li> <%=RUserName %>  </li>
                        </ul>
                        <%
                        PLRs.MoveNext
                        Loop 
                        End If 
                        PLRs.Close
                        SET PLRs = Nothing

                        if plrsSeq <12 then

                            for Row=1 to 12-plrsSeq  
                              %>
                                <ul>
                                  <li></li>
                                  <li>                                  </li>
                                  <li>                                  </li>
                                  <li>                                    <span></span>                                  </li>
                                  <li>                                    <span></span>                                  </li>
                                  <li>    </li>
                                  <li>                                    <span></span>                                  </li>
                                  <li>                                    <span></span>                                  </li>
                                  <li>                                  </li>	
                                  <li>                                  </li>
                                   <li>  </li>
                                </ul>
                            <%
                            next
                        
                        end if

                   %>
                  </div>
                </div>
                <!-- E : 선수별 경기 내역 표시 -->

                <!-- S : 등록하기-->
                <div class="score-btm-save" id="div_groupresult" style="display:none">
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                  <span id="span_groupresultbtn" style="display:block">
                  <p>양측 소속이 모두 불참 하였을 시, 무승부 및 부전패 처리</p>

                  <a  class="btn btn-save-btm" id="btn_leftwin">좌측팀 부전승</a>
                  <a  class="btn btn-save-btm" id="btn_duallose">양측 부전패</a>
                  <a   class="btn btn-cancel-btm" id="btn_dualdraw">양측 무승부</a>
                  <a  class="btn btn-save-btm" id="btn_rightwin">우측팀 부전승</a>
                  </span>
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                </div>

                <div class="score-btm-save" id="div_playerorder" style="display:none">
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                  <span id="span_playerorder" style="display:none">
                  <p>출전선수의 명단 순서가 맞으면 등록완료 버튼을 눌러주시기 바랍니다.</p>
                  <a  class="btn btn-save-btm" data-toggle="modal" data-target="#save-modal" data-whatever="saveModal" id="btn_saveModal">등록완료</a>
                  <a  class="btn btn-cancel-btm" id="btn_resaveModal">다시 등록하기</a>
                  </span>
                  <!-- 출전선수 등록 이전 페이지에선 이 부분을 감춰주세요-->
                </div>
                <!-- E : 등록하기 -->

                <!-- S : 결과 저장하기 -->
                <%
                    DP_Total_LResult=""
                    DP_Total_RResult=""
                    
                    if DP_Total_Lw > DP_Total_Rw then
                            DP_Total_LResult="승"
                            DP_Total_RResult="패"
                    elseif DP_Total_Lw < DP_Total_Rw then
                            DP_Total_LResult="패"
                            DP_Total_RResult="승"
                    else
                        if LJumsuQ >RJumsuQ then
                            DP_Total_LResult="승"
                            DP_Total_RResult="패"
                        elseif LJumsuQ < RJumsuQ then
                            DP_Total_LResult="패"
                            DP_Total_RResult="승"
                        else
                            DP_Total_LResult="무"
                            DP_Total_RResult="무"
                        end if
                    end if 
                 %>

                <div class="score-result-save" id="div_resultsave" style="display:block">
                  <ul>
                    <li>
                      <span>결과</span>
                    </li>
                    <li id="DP_Total_LResult"><span><%=DP_Total_LResult  %></span> </li> 
                    <li>
                      <span class="point-sum" id="DP_Total_LJumsu"><%=LJumsuQ %></span>
                    </li>
                    <li>
                      <a  class="btn btn-save" data-toggle="modal" data-target="#result-save-modal" id="btn_groupcomplete">기록완료</a>
                    </li>
                    <li>
                      <span class="point-sum" id="DP_Total_RJumsu"><%=RJumsuQ %></span>
                    </li>
                    <li id="DP_Total_RResult"><span><%=DP_Total_RResult %></span> </li>
                    <li>
                      <span>결과</span>
                    </li>
                  </ul>
                </div>
                <!-- E : 결과 저장하기 -->

                <!-- S: sign-list -->
                <ul class="sign-list group-play clearfix" id="div_signature" style="display:block">
                  <li class="chief">
                    <span class="judge">주심</span>
                    <span class="sign-mark" id="chiefSign_copy"><%if s_GroupChiefSign<>"" then  %> <img src="<%=s_GroupChiefSign %>" width="188" height="69"> <%end if %></span>
                     <%if s_GroupChiefSign<>"" then  %>  
                    <span class="accept-end" id="result_chiefSign" ><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span>
                    <a data-toggle="modal" data-target="#sign-modal" data-whatever="chiefSign">승인완료</a></span>
                      <%end if %> 
                  </li>
                  <li class="assistant">
                    <span class="judge">부심</span>
                    <span class="sign-mark" id="asschiefSign1_copy"><%if s_GroupAssChiefSign1<>"" then  %> <img src="<%=s_GroupAssChiefSign1 %>" width="188" height="69"> <%end if %></span>
                  <%if s_GroupAssChiefSign1<>"" then  %>  
                    <span class="accept-end" id="result_asschiefSign1"><span class="icon"><i class="fa fa-check" aria-hidden="true" ></i></span>
                    <a data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign1">승인완료</a></span>
                     <%end if %> 
                  </li>
                  <li class="assistant">
                    <span class="judge">부심</span>
                    <span class="sign-mark" id="asschiefSign2_copy"><%if s_GroupAssChiefSign2<>"" then  %> <img src="<%=s_GroupAssChiefSign2 %>" width="188" height="69"> <%end if %></span>
                   <%if s_GroupAssChiefSign2<>"" then  %>  
                    <span class="accept-end" id="result_asschiefSign2" ><span class="icon"><i class="fa fa-check" aria-hidden="true"></i></span>
                    <a data-toggle="modal" data-target="#sign-modal" data-whatever="asschiefSign2">승인완료</a></span>
                    <%end if %> 
                  </li>
                </ul>
                <!-- E: sign-list -->
            </div>
            <!-- E: score-enter -->
              <!-- E : inner -->
          </div>
          <!-- E: group-enter-main -->
           <%
           end if
           %>
      </div>
    </div>
      <!-- E: score-enter -->
<!--  리스트 출력  -->
</div>
      
 <%
GRs.MoveNext
Loop 
else
Response.Write ""
End If 
GRs.Close
SET GRs = Nothing
   
%>
</div>
<div id="Enter_Score_Print"  style=" display:none"></div> 
</div>

</body>