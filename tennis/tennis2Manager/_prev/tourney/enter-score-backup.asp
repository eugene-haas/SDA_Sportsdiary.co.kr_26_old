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
             " 	SELECT GameNum,GroupGameNum,Sum(Case AA.LJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Left01, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Left02, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Left03, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Left04, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Left05, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Left06, " & _
             " 	Sum(Case AA.LJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Left07, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023001' Then AA.Jumsu Else 0 End) as Right01, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Right02, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023003' Then AA.Jumsu Else 0 End) as Right03, " & _
             " 	Sum(Case AA.RJumsuGb When 'sd023004' Then AA.Jumsu Else 0 End) as Right04," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023005' Then AA.Jumsu Else 0 End) as Right05," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023006' Then AA.Jumsu Else 0 End) as Right06," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023007' Then AA.Jumsu Else 0 End) as Right07," & _
             " 	0 as Plus_Left01," & _
             " 	Sum(Case AA.LJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Left02," & _
             " 	0 as Plus_Right01," & _
             " 	Sum(Case AA.RJumsuGb When 'sd023002' Then AA.Jumsu Else 0 End) as Plus_Right02 "  & _
             " 	FROM " & _
             " 	( " & _
             " 		SELECT GameNum,GroupGameNum,COUNT(*) AS Jumsu, LJumsuGb , RJumsuGb " & _
             " 		FROM tblRGameResultDtl B " & _
             " 		WHERE B.RGameLevelidx='" & RGameLevelidx & "' " & _
 
             " 		AND B.DELYN='N'" & _
             " 		AND (LJumsuGb <> '' OR RJumsuGb <> '')" & _
             " 		GROUP BY GameNum,GroupGameNum,LJumsuGb, RJumsuGb" & _
             " 	) AA group by GameNum,GroupGameNum" & _
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
        <div class="display-board">
            <ul class="player-display clearfix">
                <li class="player-1">배혁<span>(계명대학교)</span></li>
                <li class="player-2">성준영<span>(세한대학교)</span></li>
                <li class="v-s">VS</li>
             </ul>
             <div class="score-board">
                    <!-- S: point-display -->
                  <div class="point-display clearfix">
                    <ul class="point-title clearfix">
                      <li>한판</li>
                      <li>절반</li>
                      <li>지도</li>
                      <li class="no-yuhyo">반칙/실격/<br>부전/기권 승</li>
                      <li class="no-yuhyo-end">양선수</li>
                    </ul>
                    <ul class="player-1-point player-point clearfix">
                      <li class="tgClass">
                       <a class=""   name="a_jumsugb"><span class="score" id="LJumsuGb1">1</span></a>
                      </li>
                      <li class="tgClass">
                        <a class=""   name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                      </li>
                      <li class="tgClass">
                        <a class=""   name="a_jumsugb"><span class="score" id="LJumsuGb4">0</span></a>
                      </li>
                      <li class="select-box-li no-yuhyo">
                        <select class="select-win select-box" id="L_gameresult" >
                            <option value="" selected="">선택</option>
                            <option value="sd023005">실격승</option><option value="sd023006">반칙승</option>
                            <option value="sd023007">부전승</option><option value="sd023008">기권승</option>
                        </select>
                      </li>
                      <li>
                          <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose"> <span>부전패</span></label>
                      </li>
                    </ul>


                    <ul class="point-title clearfix">
                      <li>한판</li>
                      <li>절반</li>
                      <li>지도</li>
                      <li class="no-yuhyo">반칙/실격/<br>부전/기권 승</li>
                      <li class="no-yuhyo-end">양선수</li>
                    </ul>
                    <ul class="player-2-point player-point clearfix">
                      <li class="tgClass">
                        <a class=""   name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                      </li>
                      <li class="tgClass">
                        <a class=""  name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
                      </li>
                      <li class="tgClass">
                        <a class=""   name="a_jumsugb"><span class="score" id="RJumsuGb4">1</span></a>
                      </li>
                      <li class="select-box-li no-yuhyo">
                        <select class="select-win select-box" id="R_gameresult">
                        <option value="" selected="">선택</option><option value="sd023005">실격승</option>
                        <option value="sd023006">반칙승</option><option value="sd023007">부전승</option>
                        <option value="sd023008">기권승</option></select>
                      </li>
                      <li>
                        <label for="player-match-option-02" class="tgClass no-attend" id="LRResult_Draw"><span id="DP_DualResult_Text">불참</span></label>
                      </li>
                    </ul>
                  </div>
                  <!-- E: point-display -->

                  <!-- S: match-result -->
                  <div class="match-result">
                    <!-- S: result-list 경기결과 리스트 -->
                    <ul class="result-list" id="DP_result-list">
                        <li class="opponent">
                            <p>[<span class="score-time">01:10</span>]<span class="player-name">성준영</span>: <span class="">지도</span> </p>
                        </li>
                    </ul>
                  <!-- E: result-list 경기결과 리스트 -->
                  </div>
              <!-- E: match-result -->
              </div>


            <ul class="sign-list clearfix">
                <li class="chief">
                <span class="judge">주심</span>
                <span class="sign-mark" id="chiefSign_copy"><img src="" /></span>
                </li>
                <li class="assistant">
                <span class="judge">부심</span>
                <span class="sign-mark" id="asschiefSign1_copy"><img src="" /></span>
                </li>
                <li class="assistant">
                <span class="judge">부심</span>
                <span class="sign-mark second" id="asschiefSign2_copy"><img src="" /></span>
                </li>
            </ul>
        </div>
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



 