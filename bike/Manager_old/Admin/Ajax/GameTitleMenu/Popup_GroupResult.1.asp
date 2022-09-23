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
	Dim LSQL
	Dim LRs
	Dim strjson
	Dim strjson_sum

	Dim oJSONoutput_SUM
	Dim oJSONoutput

	Dim CMD  
	Dim GameTitleIDX 	

  REQ = Request("Req")
  'REQ = "{""CMD"":5,""tGameLevelDtlIDX"":""DE8C3123490E924FCD464A77DD0A30BE"",""tTeamGameNum"":""1"",""tGameNum"":""0""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameLevelDtlIDX") = "ok" then
    GameLevelDtlIDX = fInject(oJSONoutput.tGameLevelDtlIDX)
    DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
  End if	

	If hasown(oJSONoutput, "tTeamGameNum") = "ok" then
    If ISNull(oJSONoutput.tTeamGameNum) Or oJSONoutput.tTeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.tTeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGameNum))    
    End If
  Else  
    TeamGameNum = ""
    DEC_TeamGameNum = ""
	End if	

	If hasown(oJSONoutput, "tGameNum") = "ok" then
    If ISNull(oJSONoutput.tGameNum) Or oJSONoutput.tGameNum = "" Then
      tGameNum = ""
      DEC_tGameNum = ""
    Else
      tGameNum = fInject(oJSONoutput.tGameNum)
      DEC_tGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.tGameNum))    
    End If
  Else  
    tGameNum = ""
    DEC_tGameNum = ""
	End if	


  LSQL = " SELECT A.Team AS LTeam, A.TeamDtl AS LTeamDtl, B.Team AS RTeam, B.TeamDtl AS RTeamDtl,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS RTeamNM,"
  LSQL = LSQL & " D.GameLevelIDX, A.[ROUND] AS GameRound"
  
  LSQL = LSQL & " FROM tblTourneyTeam A"
  LSQL = LSQL & " INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
  LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
  LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
  LSQL = LSQL & " LEFT JOIN ("
  LSQL = LSQL & "   SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
  LSQL = LSQL & "   FROM KoreaBadminton.dbo.tblGroupGameResult"
  LSQL = LSQL & "   WHERE DelYN = 'N'"
  LSQL = LSQL & "   ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND B.DelYN = 'N'"
  LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
  LSQL = LSQL & " AND A.GameLevelDtlIDX  = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"


  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    LTeam = LRs("LTeam")
    LTeamDtl = LRs("LTeamDtl")
    LTeamNM = LRs("LTeamNM")
    RTeam = LRs("RTeam")
    RTeamDtl = LRs("RTeamDtl")
    RTeamNM = LRs("RTeamNM")
    GameLevelIDX = LRs("GameLevelIDX")
    GameRound = LRs("GameRound")
  End If

  LRs.Close

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"

%>
        <!-- S: modal-body -->
        <div class="modal-body">
         <!-- S: content-title -->
          <h3 class="content-title">
            NO.1 하나움체육관 
            <span class="redy">혼합복식 40D</span>
            <span class="redy">예선7조</span>
            <span class="redy">1번코트</span>
            <span class="redy">1경기</span>
          </h3>
          <!-- E: content-title -->

          <!-- S: 마크업 -->
          <!-- s: 경기 점수 -->
          <div class="input-info">
            <table cellspacing="0" cellpadding="0">
              <tr>
                <th>
                  <span><%=LTeamNM%></span>
                </th>
								<td class="rb_2">
									<span class="red_font">WIN</span>
								</td>
                <td>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                </td>
              </tr>
              <tr class="blue-bg">
                <th>
                  <span><%=RTeamNM%></span>
                </th>
								<td class="rb_2">
									<span></span>
								</td>
                <td>
                  <a href="#" class="on">
                    <span>5</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                  <a href="#">
                    <span>-</span>
                  </a>
                </td>
              </tr>
            </table>
          </div>
          <!-- e: 경기 점수 -->
          <!-- s: 게임 -->
          <div class="game ">
            <table cellspacing="0" cellpadding="0">
              <tr>
                <th>
                  <span>게임</span>
                </th>
                <td>
                  <a href="#">
                    <span>11</span>
                  </a>
                  <a href="#">
                    <span>17</span>
                  </a>
                  <a href="#">
                    <span>21</span>
                  </a>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>30</span>
                  </a>
                </td>
              </tr>
            </table>
          </div>
          <!-- e: 게임 -->
          <!-- s: 점수 -->
          <div class="score ">
            <table cellspacing="0" cellpadding="0">
              <tr>
                <th rowspan="6">
                  <span>게임</span>
                </th>
                <td>
                  <a href="#">
                    <span>11</span>
                  </a>
                  <a href="#">
                    <span>17</span>
                  </a>
                  <a href="#">
                    <span>21</span>
                  </a>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>30</span>
                  </a>
                </td>
              </tr>
              <tr>
                <td>
                  <a href="#">
                    <span>11</span>
                  </a>
                  <a href="#">
                    <span>17</span>
                  </a>
                  <a href="#">
                    <span>21</span>
                  </a>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>30</span>
                  </a>
                </td>
              </tr>
              <tr>
                <td>
                  <a href="#">
                    <span>11</span>
                  </a>
                  <a href="#">
                    <span>17</span>
                  </a>
                  <a href="#">
                    <span>21</span>
                  </a>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>30</span>
                  </a>
                </td>
              </tr>
              <tr>
                <td>
                  <a href="#">
                    <span>11</span>
                  </a>
                  <a href="#">
                    <span>17</span>
                  </a>
                  <a href="#">
                    <span>21</span>
                  </a>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>30</span>
                  </a>
                </td>
              </tr>
              <tr>
                <td>
                  <a href="#">
                    <span>11</span>
                  </a>
                  <a href="#">
                    <span>17</span>
                  </a>
                  <a href="#">
                    <span>21</span>
                  </a>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>30</span>
                  </a>
                </td>
              </tr>
              <tr>
                <td>
                  <a href="#" class="on">
                    <span>11</span>
                  </a>
                  <a href="#">
                    <span>17</span>
                  </a>
                  <a href="#">
                    <span>21</span>
                  </a>
                  <a href="#">
                    <span>25</span>
                  </a>
                  <a href="#">
                    <span>30</span>
                  </a>
                </td>
              </tr>
            </table>
          </div>
          <!-- e: 점수 -->
					<!-- s: sign-box -->
					<div class="sign-box">
						<a href="#">
							<img src="../../images/modal/sign_txt.jpg" alt="">
						</a>
						<a href="#" class="delete_btn">서명삭제<i class="fas fa-times"></i></a>
					</div>
					<!-- e: sign-box -->
          <!-- E: 마크업 -->
        </div>
        <!-- E: modal-body -->
        <!-- S: order-footer -->
        <div class="order-footer">
          <ul class="btn-list clearfix">
            <li><a href="#" class="btn btn-default" data-dismiss="modal">닫기</a></li>
            <li><a href="#" class="btn btn-red">수정</a></li>
          </ul>
        </div>
<%

Set LRs = Nothing
DBClose()
  
%>