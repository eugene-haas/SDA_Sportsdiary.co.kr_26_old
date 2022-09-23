<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	PlayerResultIDX = fInject(Request("PlayerResultIDX"))

	LSQL = "SELECT Top 1"
	LSQL = LSQL&" SubString(GameDay,6,5) AS GameDay "
	LSQL = LSQL&" ,SportsDiary.dbo.FN_LevelNm(SportsGb,TeamGb,Level) AS LevelNm"
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_Teamgbnm(Sportsgb,Teamgb) AS GameType "
	LSQL = LSQL&" ,SEX" 
	LSQL = LSQL&" ,GameNum"
	LSQL = LSQL&" ,StadiumNumber"
	LSQL = LSQL&" ,SportsDiary.dbo.FN_PlayerName(LPlayerIDX) AS LPlayerNm"
	LSQL = LSQL&" ,SportsDiary.dbo.FN_PlayerName(RPlayerIDX) AS RPlayerNm"
	LSQL = LSQL&" ,SportsDiary.dbo.FN_TeamNm2(SportsGb,LTeam) AS LTeamNm"
	LSQL = LSQL&" ,SportsDiary.dbo.FN_TeamNm2(SportsGb,RTeam) AS RTeamNm"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblPlayerResult"
	LSQL = LSQL&" WHERE DelYN='N' AND PlayerResultIDX='"&PlayerResultIDX&"'"

	Set LRs = Dbcon.Execute(LSQL)

	If (LRs.Eof Or LRs.Bof) Then
		Response.End
	End If 
	
	GameDay = LRs("GameDay")
	
	LevelNm = LRs("LevelNm")

	GameNum = LRs("GameNum")
	Array_GameType = Split(LRs("GameType"),"_")
	TeamGbNm = Array_GameType(0)

	If LRs("SEX") = "Man" Then
		GameType = Right(LRs("GameType"),1)		
		
	ElseIf LRs("SEX") = "WoMan" Then
		GameType = Right(LRs("GameType"),2)
	End If 
	StadiumNumber = LRs("StadiumNumber")

	LPlayerNm = LRs("LPlayerNm")
	RPlayerNm = LRs("RPlayerNm")
	LTeamNm   = LRs("LTeamNm")
	RTeamNm   = LRs("RTeamNm")
	
%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8" />
	<title>SCORESHEET</title>
	<link rel="stylesheet" href="../Css/judgepaper.css" />
</head>
<body>
	<!-- S: match number -->
	<table class="match_number">
		<colgroup>
			<col width="50%" />
			<col width="50%" />
		</colgroup>
		<tbody>
			<tr>
				<td></td>
				<th>Match<br />Number</th>
			</tr>
		</tbody>
	</table>
	<!-- E: match number -->
<hr />
	<h1>SCORESHEET</h1>
	<div class="box">
		<h2><img src="../images/judgepaper/logo_wrestling.png" alt="대한레슬링협회" /></h2>
		<!-- S: 심사위원 명수 -->
		<table class="judge_number">
			<colgroup>
				<col width="70%" />
				<col width="30%" />
			</colgroup>
			<tbody>
				<tr>
					<th>Referee</th>
					<td></td>
				</tr>
				<tr>
					<th>Judge</th>
					<td></td>
				</tr>
				<tr>
					<th>Mat Chairman</th>
					<td></td>
				</tr>
			</tbody>
		</table>
		<!-- E: 심사위원 명수 -->
	</div>
<hr />
	<!-- S: 경기 정보 -->
	<table class="match_info">
		<colgroup>
			<col width="8%" />
			<col width="13%" />
			<col width="17%" />
			<col width="8%" />
			<col width="15%" />
			<col width="24%" />
			<col width="15%" />
		</colgroup>
		<thead>
			<tr>
				<th>DATE</th>
				<th>N˚DE MATCH</th>
				<th>POIDS - WEIGHT</th>
				<th>STYLE</th>
				<th>TOUR - ROUND</th>
				<th>FINALE - PLACE</th>
				<th>N˚TAPIS - MAT</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><%=GameDay%></td>
				<td></td>
				<td><%=LevelNm%></td>
				<td><%=GameType%></td>
				<td><%=GameNum%></td>
				<td><%=TeamGbNm%></td>
				<td><%=StadiumNumber%></td>
			</tr>
		</tbody>
	</table>
	<!-- E: 경기 정보 -->
<hr />
	<!-- S: player -->
	<table class="player">
		<colgroup>
			<col width="25%" />
			<col width="14%" />
			<col width="8%" />
			<col width="6%" />
			<col width="25%" />
			<col width="14%" />
			<col width="8%" />
		</colgroup>
		<thead>
			<tr>
				<th class="red" colspan="3">
					<p class="bg"><img src="../images/judgepaper/bg_red.png" /></p>
					<p class="tit"><img src="../images/judgepaper/tit_red.png" /></p>
				</th>
				<th class="none">&nbsp;</th>
				<th class="blue" colspan="3">
					<p class="bg"><img src="../images/judgepaper/bg_blue.png" /></p>
					<p class="tit"><img src="../images/judgepaper/tit_blue.png" /></p>
				</th>
			</tr>
			<tr>
				<!-- S: 01 red -->
				<td>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">NAME</p>
				</td>
				<td>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">COUNTRY</p>
				</td>
				<td>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">NO</p>
				</td>
				<!-- E: 01 red --->
				<td class="none">&nbsp;</td>
				<!-- S: 02 blue -->
				<td class="border_left">
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">NAME</p>
				</td>
				<td>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">COUNTRY</p>
				</td>
				<td>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">NO</p>
				</td>
				<!-- E: 02 blue -->
			</tr>
		</thead>
		<tbody>
			<tr>
				<!-- S: 01 red -->
				<td><%=LPlayerNm%></td>
				<td><%=LTeamNm%></td>
				<td></td>
				<!-- E: 01 red --->
				<td class="none">&nbsp;</td>
				<!-- S: 02 blue -->
				<td class="border_left"><%=RPlayerNm%></td>
				<td><%=RTeamNm%></td>
				<td></td>
				<!-- E: 02 blue -->
			</tr>
		</tbody>
	</table>
	<!-- E: player -->
<hr />
	<!-- S: match -->
	<table class="match">
		<colgroup>
			<col width="14%" />
			<col width="25%" />
			<col width="8%" />
			<col width="6%" />
			<col width="14%" />
			<col width="25%" />
			<col width="8%" />
		</colgroup>
		<thead>
			<tr>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">PERIOD</p>
				</th>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">TECHNICAL POINTS</p>
				</th>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">TOTAL</p>
				</th>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
				</th>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">PERIOD</p>
				</th>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">TECHNICAL POINTS</p>
				</th>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">TOTAL</p>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="period">1st</td>
				<td></td>
				<td></td>
				<td>&nbsp;</td>
				<td class="period">1st</td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td colspan="7" class="break">
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">BREAK</p>
				</td>
			</tr>
			<tr>
				<td class="period">2nd</td>
				<td></td>
				<td></td>
				<td>&nbsp;</td>
				<td class="period">2nd</td>
				<td></td>
				<td></td>
			</tr>
		</tbody>
	</table>
	<!-- E: match -->
<hr />
	<!-- S: TECHNICAL POINTS TOTAL -->
	<div class="red_tech">
		<p class="score_box"></p>
		<p class="txt">
			TECHNICAL POINTS TOTAL<br />
			<strong>RED</strong>
		</p>
	</div>
	<div class="blue_tech">
		<p class="score_box"></p>
		<p class="txt">
			TECHNICAL POINTS TOTAL<br />
			<strong>BLUE</strong>
		</p>
	</div>
	<!-- E: TECHNICAL POINTS TOTAL -->
<hr />
	<!-- S: CLASSIFICATION POINTS -->
	<div class="classification_point">
		<h3>CLASSIFICATION POINTS</h3>
		<div>
			<div class="red_box"></div>
			<div class="blue_box"></div>
		</div>
	</div>
	<!-- E: CLASSIFICATION POINTS -->
<hr />
	<!-- S: WINNER -->
	<table class="winner">
		<colgroup>
			<col width="60%" />
			<col width="40%" />
		</colgroup>
		<thead>
			<tr>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit win">WINNER</p>
				</th>
				<th>
					<p class="bg"><img src="../images/judgepaper/bg_gray.png" /></p>
					<p class="tit">EXACT TIME WHEN THE MATCH<br /> IS FINISHED (Hour, minute)</p>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td></td>
				<td></td>
			</tr>
		</tbody>
	</table>
	<!-- E: WINNER -->
<hr />
	<!-- S: 하단 설명-->
	<table class="info">
		<tr>
			<th>VT 5:0</th>
			<td>VICTORY BY FALL</td>
		</tr>
		<tr>
			<th>VA 5:0</th>
			<td>VICTORY BY WITHDRAWAL</td>
		</tr>
		<tr>
			<th>VB 5:0</th>
			<td>VICTORY BY INJURY</td>
		</tr>
		<tr>
			<th>VF 5:0</th>
			<td>VICTORY BY FORFEIT</td>
		</tr>
		<tr>
			<th>EV 5:0</th>
			<td>DISQUALIFICATION FROM THE WHOLE COMPETITION DUE TO INFRIGEMENT OF THE RULES</td>
		</tr>
		<tr>
			<th>EX 5:0</th>
			<td>3 CAUTIONS "0" DUE TO ERROR AGAINST THE RULES (FOR THE ENTIRE BOUT)</td>
		</tr>
		<tr>
			<th>ST 4:0</th>
			<td>GREAT SUPERIORITY - THE LOSER WITHOUT ANY POINTS</td>
		</tr>
		<tr>
			<th>SP 4:1</th>
			<td>VICTORY BY TECHNICAL SUPERIORITY WITH THE LOSER SCORING TECHNICAL POINTS</td>
		</tr>
		<tr>
			<th>PP 3:1</th>
			<td>DECISION BY POINTS - THE LOSER WITH TECHNICAL POINTS</td>
		</tr>
		<tr>
			<th>PO 3:0</th>
			<td>DECISION BY POINTS - THE LOSER WITHOUT TECHNICAL POINTS</td>
		</tr>
		<tr>
			<th>E2 0:0</th>
			<td>IN BOTH WRESTLERS HAVE BEEN DISQUAL. DUE TO INFRINGEMENT OF THE RULES</td>
		</tr>
	</table>
	<!-- E: 하단 설명 -->
<hr />
	<!-- S: 사인 -->
	<div class="signwrap">
		<div class="sign">
			<p>SIGNATURE</p>
		</div>
	</div>
	<!-- E: 사인 -->
</body>
</html>