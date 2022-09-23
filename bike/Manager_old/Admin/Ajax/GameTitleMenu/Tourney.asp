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
'개인전 대진표

Dim LSQL ,SSQL
Dim LRs ,SRs
Dim strjson
Dim strjson_sum

Dim i

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameLevelDtlidx 
Dim strRound
Dim GroupGameGb

Dim NextstrRound

Dim strjson_dtl

REQ = Request("Req")
'REQ = "{""CMD"":5,""GameLevelDtlIDX"":1310,""strRound"":""1""}"

Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.GameLevelDtlIDX) Or oJSONoutput.GameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)
      'DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameLevelDtlIDX))    
      DEC_GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)    
    End If
  Else  
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
End if	

If hasown(oJSONoutput, "strRound") = "ok" then
    strRound = fInject(oJSONoutput.strRound)
    DEC_strRound = fInject(oJSONoutput.strRound)    
  Else  
    strRound = ""
    DEC_strRound = ""
End if	

If strRound = "" OR IsNumeric(strRound) = false Then
    Response.Write ""
    Response.End
End If


strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


NextstrRound = Cint(strRound) + 1

'대회정보
DEC_GameLevelDtlIDX = fInject(GameLevelDtlIDX)


'INSERT 시, 이용 할 대회 정보 SELECT
LSQL = "SELECT A.GameTitleIDX, A.TeamGb, A.Sex, B.Level, B.LevelDtlName, A.GroupGameGb,"
LSQL = LSQL & " B.TotRound, B.GameType,"
LSQL = LSQL & "  CASE WHEN TotRound = '512' THEN '9' "
LSQL = LSQL & "  WHEN TotRound = '256' THEN '8' "
LSQL = LSQL & "  WHEN TotRound = '128' THEN '7' "
LSQL = LSQL & "  WHEN TotRound = '64' THEN '6' "
LSQL = LSQL & "  WHEN TotRound = '32' THEN '5' "
LSQL = LSQL & "  WHEN TotRound = '16' THEN '4' "
LSQL = LSQL & "  WHEN TotRound = '8' THEN '3' "
LSQL = LSQL & "  WHEN TotRound = '4' THEN '2' "
LSQL = LSQL & "  WHEN TotRound = '2' THEN '1' "
LSQL = LSQL & "  Else '0' END AS GangCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevel A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelidx = B.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    GroupGameGb = LRs("GroupGameGb")
    TotRound = LRs("TotRound")
    GangCnt = LRs("GangCnt")
    GameType = crypt.EncryptStringENC(LRs("GameType"))
	
End If

LRs.Close

%>
<table class="tourney_admin table-fix-head 64" id="tourney_admin">
  <thead>
    <tr id="DP_GangBtn">
		<%
		int_Round = TotRound

		For k = 1 To Cint(GangCnt)
		
			If int_Round = 4 Then
				TotRoundNM = "준결승"
			ElseIf int_Round = 2 then
				TotRoundNM = "결승"
			Else
				TotRoundNM = Cstr(int_Round) & "강"
			End If		
		%>
		<th>
        <a href="#" class="btn_a btn_func" data-collap="" id="DP_Gang<%=k%>"><%=TotRoundNM%></a>
		</th>
		<%
				int_Round = int_Round / 2
			Next
		%>
    </tr>
  </thead>
</table>
<div class="scroll_box">
  <table class="table-fix-body tourn-table">
    <tbody>
      <tr id="DP_Tr">
<%		

intarr = TotRound

For k = 1 To Cint(GangCnt)


	ReDim BeforeResult_Arr(GangCnt,intarr)
	

'클릭한 라운드의 대진표 불러오기(왼쪽대진표)

LSQL = " SELECT AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
LSQL = LSQL & " AA.TempNum, AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
LSQL = LSQL & " AA.Result, AA.ResultType, AA.ResultNM, AA.Jumsu,"

LSQL = LSQL & " AA.GameStatus, AA.[ROUND], AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu, AA.LDtlJumsu, AA.RDtlJumsu,"
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
LSQL = LSQL & " CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2, AA.ORDERBY, LByeYN, RByeYN"
LSQL = LSQL & " FROM"
LSQL = LSQL & " ("
LSQL = LSQL & " SELECT A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, ISNULL(A.TourneyGroupIDX,'') AS LTourneyGroupIDX, ISNULL(B.TourneyGroupIDX,'') AS RTourneyGroupIDX, "
LSQL = LSQL & " ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(A.TurnNum,'0')), ISNULL(A.TeamGameNum,'0'), CONVERT(Bigint,ISNULL(A.GameNum,'0')) ASC) AS TempNum,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
LSQL = LSQL & " E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, KoreaBadminton.dbo.FN_WinGroupIDX(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS TourneyGroupIDX,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, A.TourneyGroupIDX) AS LGroupJumsu, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, B.TourneyGroupIDX) AS RGroupJumsu, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS LDtlJumsu, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, B.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS RDtlJumsu, "
LSQL = LSQL & " A.ByeYN AS LByeYN, B.ByeYN AS RByeYN"

LSQL = LSQL & " "
LSQL = LSQL & " ,STUFF(("
LSQL = LSQL & "		    SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + UserName "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 		AND DelYN = 'N'"
LSQL = LSQL & " 		),1,1,'') AS LPlayers"
LSQL = LSQL & " ,STUFF(("
LSQL = LSQL & "		    SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + UserName "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " 		AND DelYN = 'N'"
LSQL = LSQL & " 		),1,1,'') AS RPlayers"

LSQL = LSQL & " ,STUFF((		"
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 		AND DelYN = 'N'"
LSQL = LSQL & " 		),1,1,'') AS LTeams"
LSQL = LSQL & " ,STUFF((		"
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "
LSQL = LSQL & " 			AND GameLevelDtlidx = AAA.GameLevelDtlidx"
LSQL = LSQL & " 			AND DelYN = 'N'"
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & " 		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
LSQL = LSQL & " 		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " 		AND DelYN = 'N'"
LSQL = LSQL & " 		),1,1,'') AS RTeams"
			

LSQL = LSQL & " FROM tblTourney A"
LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & "     LEFT JOIN ("
LSQL = LSQL & " 	    SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & " 	    FROM KoreaBadminton.dbo.tblGameResult"
LSQL = LSQL & " 	    WHERE DelYN = 'N'"
LSQL = LSQL & "         GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
LSQL = LSQL & " 	    ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND C.DelYN = 'N'"
LSQL = LSQL & " AND D.DelYN = 'N'"
LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND A.ROUND = '" & k & "'"
LSQL = LSQL & " ) AS AA"
LSQL = LSQL & " WHERE GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & " ORDER BY CONVERT(INT,ORDERBY) "




Set LRs = Dbcon.Execute(LSQL)

%>



        <td id="DP_Td_<%=k%>">
				<%
				If Not (LRs.Eof Or LRs.Bof) Then

						i = 0 
						resultarr = 0
						resultarr_dsp = 0

						Do Until LRs.Eof 

								If LRs("Result") <> "" AND Not ISNULL(LRs("Result")) AND (Cstr(LRs("Win_TourneyGroupIDX")) = Cstr(LRs("LTourneyGroupIDX"))) Then
									BeforeResult_Arr(k-1,resultarr) = "WIN"
								End If
								resultarr = resultarr + 1

								If LRs("Result") <> "" AND Not ISNULL(LRs("Result")) AND (Cstr(LRs("Win_TourneyGroupIDX")) = Cstr(LRs("RTourneyGroupIDX"))) Then
									BeforeResult_Arr(k-1,resultarr) = "WIN"
								End If		
								resultarr = resultarr + 1

								

				%>

    			<div class='player'>
					<div class='pre-num'><%=LRs("GameNum")%></div>
					<%
						If LRs("Result") <> "" AND Not ISNULL(LRs("Result")) AND (Cstr(LRs("Win_TourneyGroupIDX")) = Cstr(LRs("LTourneyGroupIDX"))) Then
					%>
						<div class='tourney_ctr_btn redy'>
					<%
						Else
					%>
						<div class='tourney_ctr_btn' style='background:#fff;'>
					<%
						End If
					%>

						<ul class='team clearfix'>
							<li>
							<input type='hidden' name='Hidden_Data' id='Hidden_Data_<%=i%>'>
							<span class='player' name='DP_UserName' id='DP_UserName_<%=i%>'>
							
							<%
								If LRs("Result") <> "" AND Not ISNULL(LRs("Result")) AND  (Cstr(LRs("Win_TourneyGroupIDX")) = Cstr(LRs("LTourneyGroupIDX"))) Then
							%>
								<span class='stair winner'>
							<%
								Else
							%>
								<span class='stair'>
							<%
								End If
							%>
								
								<%
									If LRs("LPlayer1") <> "" AND Not ISNULL(LRs("LPlayer1")) Then
								%>
									<span class='LPlayer1'><%=LRs("LPlayer1")%>(<%=LRs("LTeam1")%>)</span>
								<%
									End If
								%>

								<%
									If LRs("LPlayer2") <> "" AND Not ISNULL(LRs("LPlayer2")) Then
								%>
									<span class='LPlayer2'><%=LRs("LPlayer2")%>(<%=LRs("LTeam2")%>)</span>
								<%
									End If
								%>
								<%If LRs("LByeYN") = "Y" Then%>
									<span class='LPlayer1'><font color='blue'>BYE</font></span>
								<%Else%>
									<input type='text' id='LGroupJumsu_<%=LRs("GameNum")%>' class='ipt-point' value='<%=LRs("LDtlJumsu")%>' readonly>
								<%End If%>								
					
								
								
          		</span>

          </span>
          <span class='player' style='font-size:15px;'>
          </span>
					<!--<div class="btn-box">
						<a href="#" class="detail-result">상세결과</a>
						<a href="#" class="win-btn">승</a>
					</div>
					-->
          </li>
					
					<%
						'대진표 선으로 승표시
						If k > 1 Then
					%>
						<div class="game-line">
							<div class="line-box">
								<!--<span class="line"></span>-->
								<span class="line none-line"></span>
							</div>
							<%If BeforeResult_Arr(k-1,resultarr_dsp) = "WIN" Then%>
							<!--<div class="top-win-box">위:<%=BeforeResult_Arr(k-1,resultarr_dsp)%>,<%=resultarr_dsp%></div>-->
	
							<%
									resultarr_dsp = resultarr_dsp + 1
								End If
							%>

							<%If BeforeResult_Arr(k-1,resultarr_dsp) = "WIN" Then%>
							<!--<div class="bottom-win-box">위:<%=BeforeResult_Arr(k-1,resultarr_dsp)%>no,<%=resultarr_dsp%></div>-->

							<%
									resultarr_dsp = resultarr_dsp + 1
								End If
							%>
						</div>
					<%
							
						
						End If
					%>

          </ul>
          <div class='chk_win_lose'>
          </div>
          </div>
          </div>

          <div class='player'>
          <div class='pre-num'><%=LRs("GameNum")%></div>

					<%
						If LRs("Result") <> "" AND Not ISNULL(LRs("Result")) AND (Cstr(LRs("Win_TourneyGroupIDX")) = Cstr(LRs("RTourneyGroupIDX"))) Then
					%>
              <div class='tourney_ctr_btn'>
          <%
						Else
					%>
							<div class='tourney_ctr_btn' style='background:#fff;'>
					<%
						End If
					%>


          <ul class='team clearfix'>
          	<li>
          		<input type='hidden' name='Hidden_Data' id='Hidden_Data_<%=i%>'>
          		<span class='player' name='DP_UserName' id='DP_UserName_<%=i%>'>


							<%
								If LRs("Result") <> "" AND Not ISNULL(LRs("Result")) AND (Cstr(LRs("Win_TourneyGroupIDX")) = Cstr(LRs("RTourneyGroupIDX"))) Then
							%>
								<span class='stair winner'>
							<%
								Else
							%>
								<span class='stair'>
							<%
								End If
							%>

							<%
								If LRs("RPlayer1") <> "" AND Not ISNULL(LRs("RPlayer1")) Then
							%>
								<span class='RPlayer1'><%=LRs("RPlayer1")%>(<%=LRs("RTeam1")%>)</span>
							<%
								End If
							%>

							<%
								If LRs("RPlayer2") <> "" AND Not ISNULL(LRs("RPlayer2")) Then
							%>		
								<span class='RPlayer2'><%=LRs("RPlayer2")%>(<%=LRs("RTeam2")%>)</span>					
							<%
								End If
							%>

							<%If LRs("RByeYN") = "Y" Then%>
								<span class='LPlayer1'><font color='blue'>BYE</font></span>
							<%Else%>
								<input type='text' id='RGroupJumsu_<%=LRs("GameNum")%>' class='ipt-point' value='<%=LRs("RDtlJumsu")%>' readonly>
							<%End If%>													

								
							</span>
							
          	<span class='player'></span>
          </li>

					<%
						'대진표 선으로 승표시
						If k > 1 Then
					%>
						<div class="game-line">
							<div class="line-box">
								<!--<span class="line"></span>-->
								<span class="line none-line"></span>
								
							</div>
							<!--<div class="bottom-win-box"></div>-->
							<%If BeforeResult_Arr(k-1,resultarr_dsp) = "WIN" Then%>
							<!--<div class="top-win-box">위:<%=BeforeResult_Arr(k-1,resultarr_dsp)%>,<%=resultarr_dsp%></div>-->

							<%
									resultarr_dsp = resultarr_dsp + 1
								End If
							%>

							<%If BeforeResult_Arr(k-1,resultarr_dsp) = "WIN" Then%>
							<!--<div class="bottom-win-box">위:<%=BeforeResult_Arr(k-1,resultarr_dsp)%>no,<%=resultarr_dsp%></div>-->

							<%
									resultarr_dsp = resultarr_dsp + 1
								End If
							%>				
						</div>
					<%
							
									
						End If
					%>

          </ul>
          <div class='chk_win_lose'>
          </div>
          </div>
          </div>

			<%    
							i = i + 1

							

							LRs.MoveNext
					Loop

			End If

			LRs.Close

			intarr = intarr / 2
Next
			%>
				</td>			
  		</tr>
    </tbody>
  </table>
</div>
<%
Set LRs = Nothing
DBClose()
  
%>

<script>
	var $windowHeight = $(window).height(); /* 윈도창 높이 */
	var $rightTable = $(".operate .tourney-container .scroll_box");
	var $Gameoperation =$(".Game_operation").outerHeight(true);
	var $tableHead = $(".content-wrap.operate .table-head").outerHeight(true);
	var $operateMatch = $(".operate .match_sel").outerHeight(true);
	$rightTable.css("height",$windowHeight - $Gameoperation - $tableHead - $operateMatch -30);

</script>