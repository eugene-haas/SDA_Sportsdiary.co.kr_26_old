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
'득점자 배점,감점

Dim LSQL ,SSQL
Dim LRs ,SRs
Dim strjson
Dim strjson_sum

Dim i

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameLevelDtlidx 

Dim DPNum_cols : DPNum_cols = 0
Dim DPNum_rows : DPNum_rows = 0


Dim strjson_dtl

REQ = Request("Req")

'REQ = "{""CMD"":8,""GameLevelDtlIDX"":1139,""strRound"":""1""}"

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

'If strRound = "" OR IsNumeric(strRound) = false Then
'    Response.Write ""
'    Response.End
'End If

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"




'INSERT 시, 이용 할 대회 정보 SELECT
LSQL = "SELECT A.GameTitleIDX, A.TeamGb, A.Sex, B.Level, B.LevelDtlName, A.GroupGameGb"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevel A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelidx = B.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'Response.WRITE  "<BR/><BR/><BR/> LSQL :" & LSQL & "<BR/><BR/><BR/>"
Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    GroupGameGb = LRs("GroupGameGb")
End If

LRs.Close

'클릭한 라운드의 대진표 불러오기(왼쪽대진표)

LSQL = "SELECT GamelevelDtlIDX, Team, dbo.FN_NameSch(Team,'Team') AS TeamNM, TeamDtl,"
LSQL = LSQL & " CASE WHEN TeamDtl IS NULL OR TeamDtl = '' OR TeamDtl = '0' THEN '' Else TeamDtl END AS TeamDtlNM,"
LSQL = LSQL & " MIN(ORDERBY) AS ORDERBY"
LSQL = LSQL & " FROM tblTourneyTeam"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " GROUP BY GamelevelDtlIDX, Team, TeamDtl"
LSQL = LSQL & " ORDER BY ORDERBY"

'Response.WRITE  "<BR/><BR/><BR/> LSQL :" & LSQL & "<BR/><BR/><BR/>"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    LRs_Data = LRs.GetRows()

End If

LRs.Close

LSQL = " SELECT COUNT(*) AS Cnt"
LSQL = LSQL & " FROM dbo.tblGameRequestTeam A"
LSQL = LSQL & " INNER JOIN dbo.tblGameRequestTouney B ON B.RequestIDX = A.GameRequestTeamIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND B.GroupGameGb = 'B0030002'"
LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    TeamCnt = LRs("Cnt")
Else
    TeamCnt = "0"
End If
LRs.Close

LSQL = " SELECT  LeagueGameNumIDX, GameNum, LeagueGameNum, MemberCnt, DelYN, WriteDate"
LSQL = LSQL & " FROM  TblLeagueGameNum "
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND MemberCnt = '" & TeamCnt & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    Array_DBLeagueGameNum = LRs.getrows()
End If
LRs.Close


If IsArray(LRs_Data) Then
%>
 <td id='DP_Td_1' class='league_table_box'>
 <table>
  <tr>
    <td></td>
    <%

      colsnum = 0
      rowsnum = 0
      leagueGameNum = 0

      For i = 0 To UBOUND(LRs_Data,2)
        colsnum = i + 1
    %>   
      <td width='100px;'>
        <span class="num"><%=colsnum%></span>
        <span class='player'><%=LRs_Data(2,i) & LRs_Data(4,i)%></span>
      </td>
    <%
      Next
    %>

  <td class="score" width='100px;'><span class='player'>승패(점수)</span></td>
  <td class="rank" width='60px;'><span class='player'>순위</span></td>
  </tr>

    <%
      For i = 0 To UBOUND(LRs_Data,2)
        rowsnum = i + 1
      
    %>
      <tr>
      <td width='100px;'>
      <p class='player-name'><span class="num"><%=rowsnum%></span> <%=LRs_Data(2,i) & LRs_Data(4,i)%></p>
      
      <p class='player-school'></p>
      </td>
    <%
      For j = 0 To UBOUND(LRs_Data,2)
        If i < j Then
            leagueGameNum = leagueGameNum + 1

            leagueGameNum_str = Array_DBLeagueGameNum(2,leagueGameNum - 1)
        End If
            
    %>
	  <%If i < j Then%>
      <td class='write group_box'>
	  	
        <!-- S: player-btn -->
        <div class='player-btn'>
		 
          
			<%
				
				If (Cstr(LRs_Data(5,i)) <> Cstr(LRs_Data(5,j))) AND i < j  Then

				CSQL = " SELECT A.Team AS LTeam, A.TeamDtl AS LTeamDtl, B.Team AS RTeam, B.TeamDtl AS RTeamDtl,"
				CSQL = CSQL & " E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu,"
				CSQL = CSQL & " F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu"
				CSQL = CSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A "
				CSQL = CSQL & " INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
				CSQL = CSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
				CSQL = CSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"				
				CSQL = CSQL & " LEFT JOIN "
				CSQL = CSQL & "     ("
				CSQL = CSQL & "     SELECT GameLevelDtlidx, Team, TeamDtl, TeamGameNum, GameNum, Result, Jumsu"
				CSQL = CSQL & "     FROM KoreaBadminton.dbo.tblGroupGameResult"
				CSQL = CSQL & "     WHERE DelYN = 'N'"
				CSQL = CSQL & "     ) E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.Team + E.TeamDtl = A.Team + A.TeamDtl AND E.TeamGameNum = A.TeamGameNum"
				CSQL = CSQL & " LEFT JOIN "
				CSQL = CSQL & "     ("
				CSQL = CSQL & "     SELECT GameLevelDtlidx, Team, TeamDtl, TeamGameNum, GameNum, Result, Jumsu"
				CSQL = CSQL & "     FROM KoreaBadminton.dbo.tblGroupGameResult"
				CSQL = CSQL & "     WHERE DelYN = 'N'"
				CSQL = CSQL & "     ) F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.Team + F.TeamDtl = B.Team + B.TeamDtl AND F.TeamGameNum = B.TeamGameNum"				
				CSQL = CSQL & " WHERE A.DelYN = 'N'"
				CSQL = CSQL & " AND B.DelYN = 'N'"
				CSQL = CSQL & " AND C.DelYN = 'N'"
				CSQL = CSQL & " AND D.DelYN = 'N'"
				'LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
        CSQL = CSQL & " AND A.ORDERBY < B.ORDERBY"
				CSQL = CSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
				CSQL = CSQL & " AND A.TeamGameNum = '" & leagueGameNum_str & "'"
				CSQL = CSQL & " ORDER BY A.ORDERBY"     

				Set CRs = Dbcon.Execute(CSQL)

				If Not (CRs.Eof Or CRs.Bof) Then

					k = 0

					Do Until CRs.Eof

						C_L_strWinType = Cstr(CRs("LResultNM"))
						C_L_Team = Cstr(CRs("LTeam"))
						C_L_TeamDtl = Cstr(CRs("LTeamDtl"))
						C_L_WinType = Cstr(CRs("LResultType"))
						C_L_ResultNM = Cstr(CRs("LResultNM"))
						C_L_Jumsu = CRs("LJumsu")	
						C_R_strWinType = Cstr(CRs("RResultNM"))
						C_R_Team = Cstr(CRs("RTeam"))
						C_R_TeamDtl = Cstr(CRs("RTeamDtl"))
						C_R_WinType = Cstr(CRs("RResultType"))
						C_R_ResultNM = Cstr(CRs("RResultNM"))
						C_R_Jumsu = CRs("RJumsu")
				
					k = k + 1

					CRs.MoveNext

					Loop
				
				Else
						C_R_strWinType = ""
						C_R_TourneyGroupIDX = ""
						C_R_WinType = ""
						C_R_ResultNM = ""
						C_R_Jumsu = ""
						C_R_DtlJumsu = ""
						C_R_strWinType = ""
						C_R_TourneyGroupIDX = ""
						C_R_WinType = ""
						C_R_ResultNM = ""
						C_R_Jumsu = ""
						C_R_DtlJumsu = ""                       
				End If


			%>
          <span class='p_name'>
          <%=LRs_Data(2,i) & LRs_Data(4,i)%>
          </span>
          <ul class="ctr-player">
            <li>
              <a href="#" <%If C_L_WinType = "WIN" Then%>class='btn ctr-btn win'<%Else%>class='btn ctr-btn'<%End If%>>승</a><!--cli_TourneyResult('<%=DEC_GameLevelDtlIDX%>','1','0','<%=leagueGameNum_str%>','WIN','<%=LRs_Data(0,i)%>','L')-->
            </li>
          </ul>
          
          </div>
          <!-- E: player-btn -->
          <input type='text' id='LGroupJumsu_<%=leagueGameNum_str%>' class='ipt-point' value='<%=C_L_Jumsu%>' readonly>
          <!-- <span class='vs'>vs</span> -->
          
          <!-- S: player-btn -->

          <div class="player-btn">
            <!-- S: p_name -->
            <span class="p_name">
            <%=LRs_Data(2,j) & LRs_Data(4,j)%>
          </span>
          <!-- E: p_name -->
          <ul class="ctr-player">
            <li>
              <a href="#" <%If C_R_WinType = "WIN" Then%>class='btn ctr-btn win'<%Else%>class='btn ctr-btn'<%End If%>>승</a><!--cli_TourneyResult('<%=DEC_GameLevelDtlIDX%>','1','0','<%=leagueGameNum_str%>','WIN','<%=LRs_Data(0,j)%>','R')-->
            </li>
          </ul>
            

          
        <%
        End If
        %>
        </div>
        <!-- E: player-btn -->

        <input type='text' id='RGroupJumsu_<%=leagueGameNum_str%>' class='ipt-point' value='<%=C_R_Jumsu%>' readonly></div>
		
      </td>
	  <%Else%>
	  <td class='match-self'></td>
	  <%End If%>
    <%

    Next
    

    LSQL = " SELECT dbo.FN_NameSch(Team,'Team'),Team, TeamDtl, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff, TRanking"
    LSQL = LSQL & " FROM"
    LSQL = LSQL & "   ("
    LSQL = LSQL & "   SELECT Team, TeamDtl, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff,"
    LSQL = LSQL & "   ROW_NUMBER() OVER ( ORDER BY WinCnt DESC, WinPerc DESC, PointDiff DESC, WinPoint DESC) AS TRanking"
    LSQL = LSQL & "   FROM"
    LSQL = LSQL & "     ("
    LSQL = LSQL & "     SELECT Team, TeamDtl , CONVERT(FLOAT,WinCnt) AS WinCnt, CONVERT(FLOAT,GameCnt) AS GameCnt, "
    LSQL = LSQL & "     CONVERT(FLOAT,(CONVERT(FLOAT,WinCnt) / CONVERT(FLOAT,GameCnt)) * 100) AS WinPerc,"
    LSQL = LSQL & "     LoseCnt, WinPoint, LosePoint, CONVERT(FLOAT,WinPoint) - CONVERT(FLOAT,LosePoint) AS PointDiff"
    LSQL = LSQL & "     FROM"
    LSQL = LSQL & "       ("
    LSQL = LSQL & "       SELECT AA.GamelevelDtlIDX, AA.Team, AA.TeamDtl, SUM(AA.WinCnt) AS WinCnt, SUM(AA.LoseCnt) AS LoseCnt, SUM(AA.GameCnt) AS GameCnt,"
    LSQL = LSQL & "       dbo.FN_WinGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS WinPoint,"
    LSQL = LSQL & "       dbo.FN_LoseGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS LosePoint"
    LSQL = LSQL & "       FROM"
    LSQL = LSQL & "         ("
    LSQL = LSQL & "         SELECT A.GamelevelDtlIDX, A.Team, A.TeamDtl, "
    LSQL = LSQL & "         CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'WIN' THEN 1 ELSE 0 END AS WinCnt,"
    LSQL = LSQL & "         CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt,"
    LSQL = LSQL & "         1 AS GameCnt"
    LSQL = LSQL & "         FROM"
    LSQL = LSQL & "         ("
    LSQL = LSQL & "         SELECT GamelevelDtlIDX, Team, TeamDtl"
    LSQL = LSQL & "         FROM tblTourneyTeam"
    LSQL = LSQL & "         WHERE DelYN = 'N'"
    LSQL = LSQL & "         AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
    LSQL = LSQL & "         GROUP BY GamelevelDtlIDX, Team, TeamDtl"
    LSQL = LSQL & "         ) AS A"
    LSQL = LSQL & "       LEFT JOIN tblGroupGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.Team + A.TeamDtl = B.Team + B.TeamDtl "
    LSQL = LSQL & "       AND B.DelYN = 'N'"
    LSQL = LSQL & "       WHERE ISNULL(A.Team,'') <> ''"
    LSQL = LSQL & "       ) AS AA"
    LSQL = LSQL & "     GROUP BY GamelevelDtlIDX, Team, TeamDtl"
    LSQL = LSQL & "     ) AS AAA"
    LSQL = LSQL & "   ) AS AAAA"
    LSQL = LSQL & " ) AS AAAAA"
    LSQL = LSQL & " WHERE Team + TeamDtl  = '" & LRs_Data(1,i) & LRs_Data(3,i) & "'"	

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

      WinCnt = LRs("WinCnt")
      LostCnt = LRs("LoseCnt")
      Ranking = LRs("TRanking")

    Else

    End If

    LRs.Close

    %>
    <td class="text-bold"><%=WinCnt%>승 <%=LostCnt%>패</td>
    <td class="text-bold"><%=Ranking%></td>
    </tr>
<%
Next

%>
</table>
</td>
<%
End If

Set LRs = Nothing
DBClose()
  
  
%>