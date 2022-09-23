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
 
 
Response.Write  "--GameYear : "&GameYear
Response.Write  "--SportsGb : "&SportsGb
Response.Write  "--GameTitleIDX : "&GameTitleIDX
Response.Write  "--TeamGb : "&TeamGb
Response.Write  "--Sex : "&Sex
Response.Write  "--Level : "&Level
Response.Write  "--GroupGameGb : "&GroupGameGb
Response.Write  "--GameType : "&GameType
Response.Write  "--RGameLevelidx : "&RGameLevelidx
Response.Write  "--EnterType : "&EnterType
Response.Write  "--EnterScoreType : "&EnterScoreType
Response.Write  "--GameTitleName : "&GameTitleName
Response.Write "<br />"
Response.Write  "<br />"

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
       
Response.Write  "<br />"
Response.Write "--리스트"
Response.Write "<br />"
Response.Write GSQL
Response.Write "<br />"




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
             
    Response.Write  "<br />"
    Response.Write "--점수"
    Response.Write  "<br />"
    Response.Write ScoreSQL
    Response.Write "<br />"

    Response.Write  "<br /> 점수"

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

            
            'Response.Write "[Left01 : " & (scoreRs("Left01")) &"]"
            'Response.Write "[Left02 : " & (scoreRs("Left02")) &"]"
            'Response.Write "[Left03 : " & (scoreRs("Left03")) &"]"
            'Response.Write "[Left04 : " & (scoreRs("Left04")) &"]"
            'Response.Write "[Left05 : " & (scoreRs("Left05")) &"]"
            'Response.Write "[Left06 : " & (scoreRs("Left06")) &"]"
            'Response.Write "[Left07 : " & (scoreRs("Left07")) &"]"
            'Response.Write "<br />"
            'Response.Write "[Right01 : " & (scoreRs("Left01")) &"]"
            'Response.Write "[Right02 : " & (scoreRs("Right02")) &"]"
            'Response.Write "[Right03 : " & (scoreRs("Right03")) &"]"
            'Response.Write "[Right04 : " & (scoreRs("Right04")) &"]"
            'Response.Write "[Right05 : " & (scoreRs("Right05")) &"]"
            'Response.Write "[Right06 : " & (scoreRs("Right06")) &"]"
            'Response.Write "[Right07 : " & (scoreRs("Right07")) &"]"



    scoreRs.MoveNext
  Loop 
  End If 
    scoreStr = scoreStr & "]"


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

            '  Response.Write  "<br />"
            '  Response.Write  "--PlayerResultIdx : "&iPlayerResultIdx
            '  Response.Write  "--Round : "&iRound
            '  Response.Write  "--NowRoundNM : "&iNowRoundNM
            '  Response.Write  "--NowRound : "&iNowRound
            '  Response.Write  "--TurnNum : "&iTurnNum
            '  Response.Write  "--GroupGameNum : "&iGroupGameNum
            '  Response.Write  "--GameNum : "&iGameNum  
            '   
            '  Response.Write  "--LPlayerIDX : "&iLPlayerIDX
            '  Response.Write  "--LTeam : "&iLTeam
            '  Response.Write  "--LTeamDtl : "&iLTeamDtl
            '  Response.Write  "--LPlayerNum : "&iLPlayerNum
            '  Response.Write  "--LResult : "&iLResult
            '  Response.Write  "--LJumsu : "&iLJumsu
'
'              Response.Write  "--RPlayerIDX : "&iRPlayerIDX
'              Response.Write  "--RTeam : "&iRTeam
'              Response.Write  "--RTeamDtl : "&iRTeamDtl
'              Response.Write  "--RPlayerNum : "&iRPlayerNum
'              Response.Write  "--RResult : "&iRResult
'              Response.Write  "--RJumsu : "&iRJumsu


              
              'Response.Write  "--GameStatus : "&iGameStatus
              'Response.Write  "--StadiumNumber : "&iStadiumNumber
              'Response.Write  "--Tmp_StadiumNumber : "&iTmp_StadiumNumber

              'Response.Write  "--StartHour : "&iStartHour
              'Response.Write  "--StartMinute : "&iStartMinute
              'Response.Write  "--MediaLink : "&iMediaLink
              'Response.Write  "--GameDay : "&iGameDay
              'Response.Write  "--Bigo : "&iBigo
 
 
              'Response.Write  "--ChiefSign : "&iChiefSign
              'Response.Write  "--AssCheifSign1 : "&iAssCheifSign1
              'Response.Write  "--AssCheifSign2 : "&iAssCheifSign2
              'Response.Write  "--CheifMain : "&iCheifMain
              'Response.Write  "--CheifSub1 : "&iCheifSub1
 
              'Response.Write  "--Tmp_Round : "&iTmp_Round

              'Response.Write  "--GroupChiefSign : "&iGroupChiefSign
              'Response.Write  "--GroupAssChiefSign1 : "&iGroupAssChiefSign1
              'Response.Write  "--GroupAssChiefSign2 : "&iGroupAssChiefSign2

              'Response.Write  "--ChiefSign : "&iChiefSign

              'Response.Write  "--AssCheifSign1 : "&iAssCheifSign1
              'Response.Write  "--AssCheifSign2 : "&iAssCheifSign2

'              Response.Write  "--CheifMain : "&iCheifMain
'              Response.Write  "--CheifSub1 : "&iCheifSub1
'              Response.Write  "--CheifSub2 : "&iCheifSub2
'              Response.Write  "--CheifWriter : "&iCheifWriter
              
    
    Response.Write "<br />"

%>
<div class="main container-fluid">
  <div class="score-enter row">
    <dl class="selected-list">
      <dt><span><%=GameTitleName %></span></dt>
      <dd><span><%=iStadiumNumber %>경기장</span> / <span><%=iGameNum %>경기</span>/ <span><%=iNowRoundNM %></span></dd>
      <dd class="play-division arrange" ><%=GroupGameGbNm %></dd>
      <dd class="play-belong arrange" ><%=TeamGbNm %></dd>
      <dd class="play-type arrange"><%=LevelNm %></dd>
    </dl>
  </div>
  <div class="score-enter-main clearfix">
    <div class="score-board">
      <!-- S: board -->
      <div class="modal-content">
        <!-- S: modal-header -->
        <div class="modal-header chk-score">
          <h4 class="modal-title" id="modal-title">SCORE</h4>
        </div>
        <!-- E: modal-header -->
        <div class="modal-body">
          <h2><span class="left-arrow"><img src="images/tournerment/tourney/yellow-larr.png" alt=""></span><span id="DP_Win_Title">승(한판)</span><span class="right-arrow"><img src="images/tournerment/tourney/yellow-rarr.png" alt=""></span></h2>
          <!-- S: board -->
          <div class="board">
            <!-- S: pop-point-display -->
            <div class="pop-point-display">
              <!-- S: display-board -->
              <div class="display-board clearfix">
                <!-- S: point-display -->
                <div class="point-display clearfix">
                  <!-- S : 2016-12-08 수정 -->
                  <ul class="point-title clearfix">
                    <li>선수</li> 
                    <li>한판</li>
                    <li>절반</li>
                    <!--<li>유효</li>-->
                    <li>지도</li>
                    <li class="no-yuhyo">반칙/실격/<br>부전/기권 승</li>
                    <li class="no-yuhyo-end">양선수</li>
                  </ul>
                  <ul class="player-1-point player-point clearfix">
                    <li>
                    <a onclick="#"><span class="player-name disp-win" id="DP_Edit_LPlayer">김민수</span><p class="player-school" id="DP_Edit_LSCName">당리중학교</p></a>
                    </li>
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1">1</span></a>
                    </li>
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                    </li>
                    <!--
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3" >0</span></a>
                    </li>
                    -->
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4">0</span></a>
                    </li>
                    <li class="select-box-li no-yuhyo">
                    <select class="select-win select-box" id="DP_L_GameResult">
                    <option value="">-</option></select>
                    </li>
                  </ul>
                  <p class="vs">vs</p>
                  <ul class="player-2-point player-point clearfix">
                    <li>
                    <a onclick="#"><span class="player-name" id="DP_Edit_RPlayer">이소정</span><p class="player-school" id="DP_Edit_RSCName">도개중학교</p></a>
                    </li>
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                    </li>
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2">1</span></a>
                    </li>
                    <!--
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                    </li>
                    -->
                    <li class="tgClass">
                    <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">1</span></a>
                    </li>
                    <li class="select-box-li no-yuhyo">
                    <select class="select-win select-box" id="DP_R_GameResult">
                    <option value="">-</option></select>
                    </li>
                  </ul>
                  <div class="player-match-option player-point game-list no-yuhyo">
                    <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose"><input type="checkbox" id="player-match-option-01"><span>부전패</span></label>
                    <label for="player-match-option-02" class="tgClass no-attend" id="LRResult_Draw"><input type="checkbox" id="player-match-option-02"><span id="DP_DualResult_Text">불참</span></label>
                  </div>
                  <!-- E: point-display -->
                <!-- E : 2016-12-08 수정 -->
                </div>
              <!-- E: point-display -->
              </div>
              <!-- E: display-board -->
            </div>
            <!-- E: pop-point-display -->
          </div>
          <!-- E: board -->
          <!-- S: record -->
          <div class="record" id="DP_Record">
            <h3>득실기록</h3>
            <ul id="DP_result-list"><li class="opponent">[<span class="record-time">00:12</span>]<span class="record-type">김민수</span>:: <span class="skill">한판 손기술</span>(<span class="skill">업어치기</span>)</li><li class="mine">[<span class="record-time">01:08</span>]<span class="record-type">이소정</span>:: <span class="skill">절반 손기술</span>(<span class="skill">양소매 업어치기</span>)</li><li class="mine">[<span class="record-time">01:29</span>]<span class="record-type">이소정</span>:: <span class="skill">지도</span></li></ul>
          </div>
          <div class="record" id="DP_GameVideo" style="display:none"></div>
          <!-- E: record -->
          <!-- S: modal footer -->
<script>
function checkPwd(btnobj){
if($(btnobj).attr("class") == "btn btn-repair btn-ins"){
if($("#RoundResPwd").val() == ""){
$("#DP_wrong-pass").html("비밀번호를 잘못 입력하셨습니다. 다시 확인해주세요.");
return;
}
var strReturn = "";
strReturn = CheckManagerPwd($("#RoundResPwd").val());

if(strReturn == "False_HostCode"){
$("#DP_wrong-pass").html("해당 경기 수정권한이 없습니다. 해당대회의 주최협회 아이디로 로그인 하시기 바랍니다.");
return;
}

if(strReturn == "False_EmptyInfo"){
$("#DP_wrong-pass").html("해당 수정 비밀번호가 일치하지 않습니다. 다시 확인하시고 입력해 주시기 바랍니다.");
return;
}

//몇라운드인지 담기
localStorage.setItem("PageMode","Score_Edit");

//단체전일때 단체전 구성페이지, 개인전일때 스코어 입력페이지
if(localStorage.getItem("GroupGameGb") == "sd040002") 
{
location.href="enter-group.html";
}
else{
location.href="enter-score.html";       
}

}
}
</script>

          <div class="modal-footer">
            <p class="wrong-pass" id="DP_wrong-pass"><!--비밀번호를 잘못 입력하셨습니다. 다시 확인해주세요.--></p>
            <span class="ins_group">
              <label for="ins_code">비밀번호</label>
              <input type="password" id="RoundResPwd" class="ins_code">
            </span>

<script>
function change_btn(){
//기록보기 눌렀을 시
if($("#btn_movie").css("display") == "none"){

$("#DP_GameVideo").html("");

$("#DP_GameVideo").css("display","none");
$("#DP_Record").css("display","");

$("#btn_movie").css("display","");
$("#btn_log").css("display","none");
}
else{

if(localStorage.getItem("MediaLink") == ""){
alert("등록된 영상이 없습니다.");
return;
}

/*
var strYoutubeLink = "<iframe width='568' height='318' src='https://www.youtube.com/embed/gzfCmCtSomQ?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=gzfCmCtSomQ' frameborder='0' allowfullscreen></iframe>"
*/


var strYoutubeLink = "<iframe width='568' height='318' src='" + localStorage.getItem("MediaLink") + "?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=" + localStorage.getItem("MediaLink").replace("https://www.youtube.com/embed/","") + "' frameborder='0' allowfullscreen></iframe>"


/*
var strYoutubeLink = "<iframe width='568' height='318' src=" + localStorage.getItem("MediaLink") + "?showinfo=0&autoplay=1&modestbranding=0&fs=1&vq=hd720&loop=1&playlist=" + localStorage.getItem("MediaLink") + "' frameborder='0' allowfullscreen></iframe>"
*/


$("#DP_GameVideo").html(strYoutubeLink);

$("#DP_GameVideo").css("display","");
$("#DP_Record").css("display","none");

$("#btn_movie").css("display","none");
$("#btn_log").css("display","");                
}
}
</script>

            <!--경기기록실 진입 시 보이는버튼-->
            <a onclick="change_btn();" id="btn_movie" role="button" class="btn btn-movielog btn-check">영상보기</a>
            <a onclick="change_btn();" id="btn_log" role="button" class="btn btn-movielog btn-check" style="display:none">경기기록보기</a>

            <a onclick="checkPwd(this);" id="btnEditcheck" role="button" class="btn btn-repair" data-toggle="modal" data-target="#repair-modal" style="display: none;">수정하기</a>
            <a href="#" role="button" class="btn btn-close" data-dismiss="modal">닫기</a>
          </div>
        <!--E: modal-footer -->
        </div>
        <!-- E: modal-body -->
      </div>
      <!--E: modal-footer -->   
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



 