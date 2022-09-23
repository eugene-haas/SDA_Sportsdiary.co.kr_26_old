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
'REQ = "{""CMD"":5,""TotRound"":""8"",""GameType"":""B0040002"",""GroupGameGb"":""B0030001"",""GameLevelDtlIDX"":1321}"


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


If hasown(oJSONoutput, "TotRound") = "ok" then
    If ISNull(oJSONoutput.TotRound) Or oJSONoutput.TotRound = "" Then
      TotRound = ""
      DEC_TotRound = ""
    Else
      TotRound = fInject(oJSONoutput.TotRound) 
      DEC_TotRound = fInject(oJSONoutput.TotRound)    
    End If
  Else  
    TotRound = ""
    DEC_TotRound = ""
End if	

If hasown(oJSONoutput, "GameType") = "ok" then
    If ISNull(oJSONoutput.GameType) Or oJSONoutput.GameType = "" Then
      GameType = ""
      DEC_GameType = ""
    Else
      GameType = fInject(oJSONoutput.GameType) 
      DEC_GameType = fInject(oJSONoutput.GameType)    
    End If
  Else  
    GameType = ""
    DEC_GameType = ""
End if	

If hasown(oJSONoutput, "GroupGameGb") = "ok" then
    If ISNull(oJSONoutput.GroupGameGb) Or oJSONoutput.GroupGameGb = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""
    Else
      GroupGameGb = fInject(oJSONoutput.GroupGameGb) 
      DEC_GroupGameGb = fInject(oJSONoutput.GroupGameGb)    
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
End if	

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
    GameType = LRs("GameType")
    crypt_GameType = crypt.EncryptStringENC(GameType)
End If
LRs.Close

A_ResultGangSu = GetGangSu(GameType, TotRound, 3)


int_Round = TotRound
For k = 1 To Cint(GangCnt)
If int_Round = 4 Then
  TotRoundNM = "준결승"
ElseIf int_Round = 2 then
  TotRoundNM = "결승"
Else
  TotRoundNM = Cstr(int_Round) & "강"
End If
Next
	

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
'Response.Write "GroupGameGb : " & GroupGameGb & "<br/>"
'Response.Write "TotRound : " & TotRound & "<br/>"
'Response.Write "GangCnt : " & GangCnt & "<br/>"
'Response.Write "GameType : " & GameType & "<br/>"
'Response.Write "TotRoundNM : " & TotRoundNM & "<br/>"


  FristRound = "1"
  TeamGameNum = ""
  GameNum = ""
  LSQL = " EXEC tblTeamTourneyGame_Searched_STR '" & DEC_GameLevelDtlIDX &  " ', '" & FristRound & "', '" & GameNum & "', '" & TeamGameNum & "','" & GroupGameGb & "'"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayTourneyGames = LRs.getrows()
  End If
    
 
%>
<table class="tourney_admin table-fix-head 64" id="tourney_admin">
  <thead>
    <tr id="DP_GangBtn">
		<th>
        <a href="" class="btn_a btn_func" data-collap="" id="DP_Gang<%=k%>"><%=TotRoundNM%></a>
		</th>
    </tr>
  </thead>
</table>
<div class="scroll_box">
  <table class="table-fix-body tourn-table">
    <tbody>
      <tr id="DP_Tr">
				<td id="DP_Td_1">
          <% For i = 1 To Cint(TotRound) %>
            <% 
              If IsArray(arrayTourneyGames) Then
                For ar = LBound(arrayTourneyGames, 2) To UBound(arrayTourneyGames, 2) 
                  j = j + 1
                  'TourneyIDX or TourneyTeamIDX
                  TourneyIDX    = arrayTourneyGames(0, ar) 
                  crypt_TourneyIDX = crypt.EncryptStringENC(TourneyIDX)

                  Tourney_RequestIdx = arrayTourneyGames(1, ar) 
                  Tourney_OrderBy = arrayTourneyGames(2, ar) 

                  if GroupGameGb = "B0030002"  Then
                    TourneyPlayer1 = arrayTourneyGames(3, ar) 
                    TourneyPlayer2 = arrayTourneyGames(4, ar) 
                    Tourney_TeamNM1 = arrayTourneyGames(5, ar) 
                    Tourney_TeamNM2 = arrayTourneyGames(6, ar) 
                    TourneyTeam_TeamDtl = arrayTourneyGames(7, ar) 
                  Else
                    TourneyPlayer1 = arrayTourneyGames(3, ar) 
                    TourneyPlayer2 = arrayTourneyGames(4, ar) 
                    Tourney_TeamNM1 = arrayTourneyGames(5, ar) 
                    Tourney_TeamNM2 = arrayTourneyGames(6, ar) 
                    TourneyTeam_TeamDtl = arrayTourneyGames(7, ar) 
                  End if
                
                  if cdbl(i) = cdbl(Tourney_OrderBy) Then
                    'Response.Write "TourneyIDX" & TourneyIDX & "<br/>"
                    'Response.Write "Tourney_OrderBy" & Tourney_OrderBy & "<br/>"
                    Exit for
                  END IF 
                Next
              End If      
            %>
            <div class='player'>
            <div class='pre-num'><%=i%></div>
            <div class='tourney_ctr_btn redy' onclick=cli_tourneyinsert('1','<%=i%>','<%=GameType%>',this)>
            <ul class='team clearfix'>
            <li>
            <input type='hidden' name='Hidden_Data' id='Hidden_Data_1_<%=i%>' value="<%=Tourney_RequestIdx%>">
            <input type='hidden' name='Hidden_Idx' id='Hidden_Idx_1_<%=i%>' value="<%=TourneyIDX%>">
            <span class='player' name='DP_UserName' id='DP_UserName_1_<%=i%>'>
            <%
              IF GroupGameGb = "B0030002"  Then
                  Response.Write Tourney_TeamNM1
                IF TourneyTeam_TeamDtl <> "" AND TourneyTeam_TeamDtl <> "0" Then
                  Response.Write "-" & TourneyTeam_TeamDtl
                END IF
              Else
                Response.Write TourneyPlayer1 & "(" & Tourney_TeamNM1  &")"
                IF TourneyPlayer2<> "" THEN
                Response.Write "," & TourneyPlayer2 & "(" & Tourney_TeamNM2  &")"
                END IF
              END IF
            %>
            </span>
            <span class='player' style='font-size:15px;'>
            </span>
            </li>
            </ul>
            <div class='chk_win_lose'>
            </div>
            </div>
            </div>
          <% Next %>
				</td>
      </tr>				
    </tbody>			
  </table>		
</div>
<script>
	var $windowHeight = $(window).height(); /* 윈도창 높이 */
	var $rightTable = $(".operate .tourney-container .scroll_box");
	var $Gameoperation =$(".Game_operation").outerHeight(true);
	var $tableHead = $(".content-wrap.operate .table-head").outerHeight(true);
	var $operateMatch = $(".operate .match_sel").outerHeight(true);
	$rightTable.css("height",$windowHeight - $Gameoperation - $tableHead - $operateMatch -70);
  console.log($rightTable)
</script>