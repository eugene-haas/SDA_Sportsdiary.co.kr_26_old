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
'REQ = "{""CMD"":6,""GameLevelDtlIDX"":1045,""strRound"":""1""}"


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
'Response.write "<br>"  & "LSQL : " & LSQL & "<br>" 
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

		<th style="padding:2px">
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


For k = 1 To Cint(GangCnt)

'클릭한 라운드의 대진표 불러오기(왼쪽대진표)

LSQL = " SELECT AA.GameLevelDtlIDX, AA.TeamGameNum, AA.TeamGb, AA.Level, AA.LTeam, AA.LTeamDtl, AA.RTeam, AA.RTeamDtl,"
LSQL = LSQL & "  AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
LSQL = LSQL & "  AA.GameStatus, AA.[ROUND],"
LSQL = LSQL & "  dbo.FN_NameSch(AA.LTeam,'Team') AS LTeamNM,"
LSQL = LSQL & "  CASE WHEN AA.LTeamDtl IS NULL OR AA.LTeamDtl = '' OR AA.LTeamDtl = '0' THEN '' Else AA.LTeamDtl END AS LTeamDtlNM,"
LSQL = LSQL & "  dbo.FN_NameSch(AA.RTeam,'Team') AS RTeamNM,"
LSQL = LSQL & "  CASE WHEN AA.RTeamDtl IS NULL OR AA.RTeamDtl = '' OR AA.RTeamDtl = '0' THEN '' Else AA.RTeamDtl END AS RTeamDtlNM,"
LSQL = LSQL & "  AA.WinTeam,"
LSQL = LSQL & "  AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu,"
LSQL = LSQL & "  AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu, AA.ORDERBY,"
LSQL = LSQL & "  AA.LByeYN, AA.RByeYN"
LSQL = LSQL & "  FROM"
LSQL = LSQL & "  ("
LSQL = LSQL & "  SELECT A.GameLevelDtlIDX, A.TeamGameNum, A.TeamGb, A.Level, A.Team AS LTeam, A.TeamDtl AS LTeamDtl, "
LSQL = LSQL & "  B.Team AS RTeam, B.TeamDtl AS RTeamDtl, "
LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM,"
LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
LSQL = LSQL & "  KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
LSQL = LSQL & "  KoreaBadminton.dbo.FN_GroupGameStatus(A.GameLevelDtlidx, A.TeamGameNum) AS GameStatus, A.[Round], E.Team + E.TeamDtl AS WinTeam,"
LSQL = LSQL & "  E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu,"
LSQL = LSQL & "  F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu, A.ORDERBY,"
LSQL = LSQL & "  A.ByeYN AS LByeYN, B.ByeYN AS RByeYN"
LSQL = LSQL & " "
LSQL = LSQL & "  FROM tblTourneyTeam A"
LSQL = LSQL & "  INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
LSQL = LSQL & "  INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "  INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
LSQL = LSQL & "      LEFT JOIN ("
LSQL = LSQL & "  	    SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
LSQL = LSQL & "  	    FROM KoreaBadminton.dbo.tblGroupGameResult"
LSQL = LSQL & "  	    WHERE DelYN = 'N'"
LSQL = LSQL & "          GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
LSQL = LSQL & "  	    ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum  AND E.Team + E.TeamDtl = A.Team + A.TeamDtl    "
LSQL = LSQL & "      LEFT JOIN ("
LSQL = LSQL & "  	    SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
LSQL = LSQL & "  	    FROM KoreaBadminton.dbo.tblGroupGameResult"
LSQL = LSQL & "  	    WHERE DelYN = 'N'"
LSQL = LSQL & "          GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
LSQL = LSQL & "  	    ) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum  AND F.Team + F.TeamDtl = B.Team + B.TeamDtl    "
LSQL = LSQL & "  WHERE A.DelYN = 'N'"
LSQL = LSQL & "  AND B.DelYN = 'N'"
LSQL = LSQL & "  AND C.DelYN = 'N'"
LSQL = LSQL & "  AND D.DelYN = 'N'"
LSQL = LSQL & "  AND A.ORDERBY < B.ORDERBY"
LSQL = LSQL & "  AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & "  AND A.ROUND = '" & k & "'"
LSQL = LSQL & "  ) AS AA"
LSQL = LSQL & "  WHERE GameLevelDtlIDX IS NOT NULL"
LSQL = LSQL & "  ORDER BY CONVERT(INT,ORDERBY) "



Set LRs = Dbcon.Execute(LSQL)

%>

        <td id="DP_Td_<%=k%>">
				<%
				If Not (LRs.Eof Or LRs.Bof) Then
						i = 0 
						Do Until LRs.Eof 
				%>
    			<div class='player'>
						<div class='pre-num'><%=LRs("TeamGameNum")%></div>
					<% If LRs("LResultType") = "WIN" Then %>
						<div class='tourney_ctr_btn redy'>
					<% Else %>
						<div class='tourney_ctr_btn'  style='background:#E5E5E5;'>
					<% End If %>
						<ul class='team clearfix'>
							<li>
								<input type='hidden' name='Hidden_Data' id='Hidden_Data_<%=i%>'>
								<span class='player' name='DP_UserName' id='DP_UserName_<%=i%>'>
								<% If LRs("LResultType") = "WIN" Then %>
									<span class='stair winner'>
								<% Else %>
									<span class='stair'>
								<% End If %>
								<% If LRs("LTeamNM") <> "" AND Not ISNULL(LRs("LTeamNM")) Then %>
									<span class='LPlayer1'><%=LRs("LTeamNM") & LRs("LTeamDtlNM")%></span>
								<% End If %>
								
								<%If LRs("LByeYN") = "Y" Then%>
									<font color='blue'>BYE</font>
								<%Else%>
									<input type='text' id='LGroupJumsu_<%=LRs("TeamGameNum")%>' class='ipt-point' value='<%=LRs("LJumsu")%>' readonly>
								<%End If%>

								</span>
								<% If LRs("RResultType") = "WIN" Then %>
									<!--<span class='stair winner'><a class='btn chk-win'>승</a>--><!--onclick="cli_TourneyResult('<%=LRs("GameLevelDtlIDX")%>','<%=k%>','<%=LRs("TeamGameNum")%>','WIN','<%=LRs("LTeam")%>','<%=LRs("LTeamDtl")%>','L')"-->
								<% Else %>
									<!--<span class='stair'><a class='btn chk-win'>승</a>-->
								<% End If %>
								</span>
								<span class='player' style='font-size:15px;'>
								</span>
							</li>
          	</ul>
          	<div class='chk_win_lose'> </div>
          </div>
          </div>
          <div class='player'>
						<div class='pre-num'><%=LRs("TeamGameNum")%></div>
							<% If LRs("RResultType") = "WIN" Then %>
								<div class='tourney_ctr_btn' >
							<% Else %>
								<div class='tourney_ctr_btn' style='background:#E5E5E5;'>
							<% End If %>

							<ul class='team clearfix'>
								<li>
									<input type='hidden' name='Hidden_Data' id='Hidden_Data_<%=i%>'>
									<span class='player' name='DP_UserName' id='DP_UserName_<%=i%>'>
									<% If LRs("RResultType") = "WIN" Then %>
										<span class='stair winner'>
									<% Else %>
										<span class='stair'>
									<% End If %>

									<% If LRs("RTeamNM") <> "" AND Not ISNULL(LRs("RTeamNM")) Then %>
										<span class='RPlayer1'><%=LRs("RTeamNM") & LRs("RTeamDtlNM")%></span>
									<% End If %>							
										

									<%If LRs("RByeYN") = "Y" Then%>
										<font color='blue'>BYE</font>
									<%Else%>											
										<input type='text' id='RGroupJumsu_<%=LRs("TeamGameNum")%>' class='ipt-point' value='<%=LRs("RJumsu")%>'></span>
									<%End If%>


									<% If LRs("RResultType") = "WIN" Then %>
										<!--<span class='stair winner'><a class='btn chk-win'>승</a>--><!--onclick="cli_TourneyResult('<%=LRs("GameLevelDtlIDX")%>','<%=k%>','<%=LRs("TeamGameNum")%>','WIN','<%=LRs("RTeam")%>','<%=LRs("RTeamDtl")%>','R')"--></span>
									<% Else %>
										<!--<span class='stair'><a class='btn chk-win'>승</a></span>-->
									<% End If %>
									<span class='player'></span>
								</li>
							</ul>
							<div class='chk_win_lose'> </div>
						</div>
          </div>
				<%    i = i + 1
						LRs.MoveNext
					Loop
				End If	
				LRs.Close
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