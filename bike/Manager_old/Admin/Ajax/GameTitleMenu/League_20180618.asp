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
'REQ = "{""CMD"":7,""GameLevelDtlIDX"":969,""strRound"":""1""}"


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

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    GroupGameGb = LRs("GroupGameGb")
End If

LRs.Close

'클릭한 라운드의 대진표 불러오기(왼쪽대진표)

LSQL = " SELECT CASE WHEN CHARINDEX('|',Players) > 0 THEN LEFT(Players,CHARINDEX('|',Players)-1) ELSE Players END  AS Player1,"
LSQL = LSQL & " CASE WHEN CHARINDEX('|',Players) > 0 THEN RIGHT(Players,CHARINDEX('|',REVERSE(Players))-1) ELSE '' END  AS Player2,"
LSQL = LSQL & " CASE WHEN CHARINDEX('|',Teams) > 0 THEN LEFT(Teams,CHARINDEX('|',Teams)-1) ELSE Teams END AS Team1,"
LSQL = LSQL & " CASE WHEN CHARINDEX('|',Teams) > 0 THEN RIGHT(Teams,CHARINDEX('|',REVERSE(Teams))-1) ELSE '' END AS Team2,"
LSQL = LSQL & " AAA.ORDERBY, AAA.TourneyGroupIDX, AAA.GamelevelDtlIDX"
LSQL = LSQL & " FROM "
LSQL = LSQL & " ("
LSQL = LSQL & " SELECT "
LSQL = LSQL & " STUFF(("
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + UserName "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX  = A.TourneyGroupIDX  "
LSQL = LSQL & " 						AND GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " 						AND DelYN = 'N'"
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblTourneyPlayer AA  "
LSQL = LSQL & "         WHERE AA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 				AND DelYN = 'N'"
LSQL = LSQL & "         ),1,1,'') AS Players, "
LSQL = LSQL & " STUFF(("
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'  + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
LSQL = LSQL & "             WHERE   TourneyGroupIDX  = A.TourneyGroupIDX  "
LSQL = LSQL & " 						AND GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & " 						AND DelYN = 'N'"
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblTourneyPlayer AA  "
LSQL = LSQL & "         WHERE AA.GameLevelDtlidx = A.GameLevelDtlidx"
LSQL = LSQL & "         AND AA.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " 				AND DelYN = 'N'"
LSQL = LSQL & "         ),1,1,'') AS Teams,"
LSQL = LSQL & " A.ORDERBY, A.TourneyGroupIDX, A.GamelevelDtlIDX "
LSQL = LSQL & " FROM "
LSQL = LSQL & " ("
LSQL = LSQL & "     SELECT GamelevelDtlIDX, TourneyGroupIDX, MIN(ORDERBY) AS ORDERBY"
LSQL = LSQL & "     FROM tblTourney"
LSQL = LSQL & "     WHERE DelYN = 'N'"
LSQL = LSQL & "     AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & "     GROUP BY GamelevelDtlIDX, TourneyGroupIDX"
LSQL = LSQL & " ) AS A"
LSQL = LSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " WHERE B.DelYN = 'N'"
LSQL = LSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " ) AS AAA"
LSQL = LSQL & " ORDER BY ORDERBY"



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    LRs_Data = LRs.GetRows()

End If

LRs.Close

If IsArray(LRs_Data) = false Then
  Response.END
End If
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
      <td>
        <span class="num"><%=colsnum%></span>
      <span class='player'>
      <%=LRs_Data(0,i)%>(<%=LRs_Data(2,i)%>)
      <br/>,
      <%=LRs_Data(1,i)%>(<%=LRs_Data(3,i)%>)</span>
      </td>
    <%
      Next
    %>

  <td class='score'><span class='player'>승패(점수)</span></td>
  <td class='rank'><span class='player'>순위</span></td>
  </tr>

    <%
      For i = 0 To UBOUND(LRs_Data,2)
        rowsnum = i + 1
      
    %>
      <tr>
      <td>
      <p class='player-name'><span class='num'><%=rowsnum%></span><%=LRs_Data(0,i)%>(<%=LRs_Data(2,i)%>)</p>
      
      <p class='player-school'><%=LRs_Data(1,i)%>(<%=LRs_Data(3,i)%>)</p>
      </td>
    <%
      For j = 0 To UBOUND(LRs_Data,2)
        If i < j Then
            leagueGameNum = leagueGameNum + 1
        End If
            
    %>
      <%
        If (Cstr(LRs_Data(4,i)) <> Cstr(LRs_Data(4,j))) AND i < j  Then

          CSQL = " SELECT A.TourneyGroupIDX, dbo.FN_NameSch(Result, 'PubType') AS WinType, dbo.FN_NameSch(Result, 'PubCode') AS ResultNM, ISNULL(Jumsu,'0') AS Jumsu,"
          CSQL = CSQL & " KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS DtlJumsu"
          CSQL = CSQL & " FROM KoreaBadminton.dbo.tblTourney A "
          CSQL = CSQL & " LEFT JOIN "
          CSQL = CSQL & "         ("
          CSQL = CSQL & "         SELECT GameLevelDtlidx, TourneyGroupIDX, TeamGameNum, GameNum, Result, Jumsu"
          CSQL = CSQL & "         FROM KoreaBadminton.dbo.tblGameResult"
          CSQL = CSQL & "         WHERE DelYN = 'N'"
          CSQL = CSQL & "         ) B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.TourneyGroupIDX = B.TourneyGroupIDX AND A.TeamGameNum = B.TeamGameNum AND A.GameNum = B.GameNum"
          CSQL = CSQL & " WHERE A.DelYN = 'N'"
          CSQL = CSQL & " AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
          CSQL = CSQL & " AND A.TeamGameNum = '0'"
          CSQL = CSQL & " AND A.GameNum = '" & leagueGameNum & "'"
          CSQL = CSQL & " ORDER BY A.ORDERBY "


          Set CRs = Dbcon.Execute(CSQL)

          If Not (CRs.Eof Or CRs.Bof) Then

            k = 0

            Do Until CRs.Eof

            If k = 0 Then
                C_L_strWinType = Cstr(CRs("ResultNM"))
                C_L_TourneyGroupIDX = Cstr(CRs("TourneyGroupIDX"))
                C_L_WinType = Cstr(CRs("WinType"))
                C_L_ResultNM = Cstr(CRs("ResultNM"))
                C_L_Jumsu = Cstr(CRs("Jumsu"))
                C_L_DtlJumsu = Cstr(CRs("DtlJumsu"))
            Else
                C_R_strWinType = Cstr(CRs("ResultNM"))
                C_R_TourneyGroupIDX = Cstr(CRs("TourneyGroupIDX"))
                C_R_WinType = Cstr(CRs("WinType"))
                C_R_ResultNM = Cstr(CRs("ResultNM"))
                C_R_Jumsu = Cstr(CRs("Jumsu"))
                C_R_DtlJumsu = Cstr(CRs("DtlJumsu"))
            End If


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
      <td class='write'>
        <p>
          <%
          If Cstr(LRs_Data(5,i)) = C_L_TourneyGroupIDX AND C_L_WinType = "WIN"  Then
          %>
            <div class='stair'>
              <!-- S: player-btn -->
              <div class="player-btn">
                <span class='p_name'><%=LRs_Data(0,i)%></span>
                <span class='p_name'><%=LRs_Data(1,i)%></span>

                <ul class="ctr-player">
                  <li>
                    <a href="#" class="btn ctr-btn">승</a>
                  </li>
                  <li>
                    <a href="#" class="btn ctr-btn">기권</a>
                  </li>
                </ul>
              </div>
              <!-- E: player-btn -->
          <%
          ElseIf Cstr(LRs_Data(5,i)) = C_L_TourneyGroupIDX AND C_L_WinType = "LOSE" Then
          %>
            <div class='stair'>
              <!-- S: player-btn -->
              <div class="player-btn">
                <span class='p_name'><%=LRs_Data(0,i)%></span>
                <span><%=LRs_Data(1,i)%></span>

                <!-- S: ctr-player -->
                <ul class="ctr-player">
                  <li>
                    <a href="#" class="btn ctr-btn">승</a>
                  </li>
                  <li>
                    <a href="#" class="btn ctr-btn">기권</a>
                  </li>
                </ul>
                <!-- E: ctr-player -->
              </div>
              <!-- E: player-btn -->
          <%
          Else
          %>
            <!-- S: player-btn -->
            <div class="player-btn">
              <span class="p_name"><%=LRs_Data(0,i)%></span>
              <span class="p_name"><%=LRs_Data(1,i)%></span>

              <!-- S: ctr-player -->
                <ul class="ctr-player">
                  <li>
                    <a href="#" class="btn ctr-btn">승</a>
                  </li>
                  <li>
                    <a href="#" class="btn ctr-btn">기권</a>
                  </li>
                </ul>
                <!-- E: ctr-player -->
            </div>
            <!-- E: player-btn -->
          <%
          End If
          %>
            <input type='text' id='LGroupJumsu_<%=leagueGameNum%>' class='ipt-point' value='<%=C_L_DtlJumsu%>'>

          </div>
          <!-- E: stair -->
         <!--  <span class='chk-win'><a onclick="cli_TourneyResult(' <%=DEC_GameLevelDtlIDX%>','1','0','<%=leagueGameNum%>','WIN','<%=LRs_Data(5,i)%>','L')" class='btn btn-chk-win btn-left'>[좌]승</a></span> -->
          
          <!-- <span class='vs'>vs</span> -->
          
          <%
          If Cstr(LRs_Data(5,j)) = C_R_TourneyGroupIDX AND C_R_WinType = "WIN"  Then
          %>
            <div class='stair'>
              <!-- S: player-btn -->
              <div class="player-btn">
                <span class="p_name"><%=LRs_Data(0,j)%></span>
                <span class="p_name"><%=LRs_Data(1,j)%></span>

                <!-- S: ctr-player -->
                <ul class="ctr-player">
                  <li>
                    <a href="#" class="btn ctr-btn">승</a>
                  </li>
                  <li>
                    <a href="#" class="btn ctr-btn">기권</a>
                  </li>
                </ul>
                <!-- E: ctr-player -->
              </div>
              <!-- E: player-btn -->
          <%
          ElseIf Cstr(LRs_Data(5,j)) = C_R_TourneyGroupIDX AND C_R_WinType = "LOSE" Then
          %>
            <div class='stair'>
              <!-- S: player-btn -->
              <div class="player-btn">
                <span class="p_name"><%=LRs_Data(0,j)%></span>
                <span class="p_name"><%=LRs_Data(1,j)%></span>

                <!-- S: ctr-player -->
                <ul class="ctr-player">
                  <li>
                    <a href="#" class="btn ctr-btn win">승</a>
                  </li>
                  <li>
                    <a href="#" class="btn ctr-btn draw">기권</a>
                  </li>
                </ul>
                <!-- E: ctr-player -->
              </div>
              <!-- E: player-btn -->
          <%
          Else
          %>
            <!-- S: player-btn -->
            <div class="player-btn">
              <span class="p_name"><%=LRs_Data(0,j)%></span>
              <span class="p_name"><%=LRs_Data(1,j)%></span>

              <!-- S: ctr-player -->
                <ul class="ctr-player">
                  <li>
                    <a href="#" class="btn ctr-btn">승</a>
                  </li>
                  <li>
                    <a href="#" class="btn ctr-btn">기권</a>
                  </li>
                </ul>
                <!-- E: ctr-player -->
            </div>
            <!-- E: player-btn -->
          <%
          End If
          
          %>
          
          <input type='text' id='RGroupJumsu_<%=leagueGameNum%>' class='ipt-point' value='<%=C_R_DtlJumsu%>'>
        </div>
        <!-- E: stair -->
          <!-- <span class='chk-win'><a onclick="cli_TourneyResult('<%=DEC_GameLevelDtlIDX%>','1','0','<%=leagueGameNum%>','WIN','<%=LRs_Data(5,j)%>','R')" class='btn btn-chk-win btn-right'>[우]승</a></span>
          
          <span class='btn chk-draw'><a onclick="cli_TourneyResult('<%=DEC_GameLevelDtlIDX%>','1','0','<%=leagueGameNum%>','LRLOSE','<%=LRs_Data(5,j)%>')">기권</a></span> -->
        </p>
      </td>          
      <%
      Else
      %>
        <td class="match-self"></td>
      <%
      End If
      %>

    <%

    Next
      

    LSQL = " SELECT TourneyGroupIDX, Ranking, WinCnt, LoseCnt"
    LSQL = LSQL & " FROM "
    LSQL = LSQL & "   ("
    LSQL = LSQL & "   SELECT TourneyGroupIDX, ROW_NUMBER() OVER(ORDER BY SUM(WinCnt) DESC, SUM(LoseCnt) ASC) AS Ranking, "
    LSQL = LSQL & "   SUM(WinCnt) AS WinCnt, SUM(LoseCnt) AS LoseCnt"
    LSQL = LSQL & "   FROM ("
    LSQL = LSQL & "     SELECT A.TourneyGroupIDX,"
    LSQL = LSQL & "     CASE WHEN PubType = 'WIN' THEN 1 ELSE 0 END AS WinCnt,"
    LSQL = LSQL & "     CASE WHEN PubType = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt"
    LSQL = LSQL & "     FROM ("
    LSQL = LSQL & "       SELECT GamelevelDtlIDX, TourneyGroupIDX, MIN(ORDERBY) AS ORDERBY"
    LSQL = LSQL & "       FROM tblTourney"
    LSQL = LSQL & "       WHERE DelYN = 'N'"
    LSQL = LSQL & "       AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
    LSQL = LSQL & "       GROUP BY GamelevelDtlIDX, TourneyGroupIDX"
    LSQL = LSQL & "       ) AS A"
    LSQL = LSQL & "     LEFT JOIN tblGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.TourneyGroupIDX = B.TourneyGroupIDX"
    LSQL = LSQL & "     INNER JOIN tblPubcode C ON C.PubCode = B.Result"
    LSQL = LSQL & "     AND B.DelYN = 'N'"
    LSQL = LSQL & "     ) AS AA"
    LSQL = LSQL & "   GROUP BY TourneyGroupIDX"
    LSQL = LSQL & "   ) AS AAA"
    LSQL = LSQL & " WHERE TourneyGroupIDX = '" & LRs_Data(5,i) & "'"

    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

      WinCnt = LRs("WinCnt")
      LostCnt = LRs("LoseCnt")
      Ranking = LRs("Ranking")
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
<script>
	var $windowHeight = $(window).height(); /* 윈도창 높이 */
	var $Gameoperation =$(".Game_operation").outerHeight(true);
	var $operateMatch = $(".operate .match_sel").outerHeight(true);
	var $rightTable = $(".tourney-container .league_table_box");

	
	$rightTable.css("height",$windowHeight - $Gameoperation  - $operateMatch -30);
</script>
<%


Set LRs = Nothing
DBClose()
  
  
%>