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

    <!-- S: sel-content -->
    <div class="sel-content">
      <!-- S: sel-list -->
      <div class="sel-list">
        <h4>1. 판정할 팀 선택 <sub>(중복 선택 가능)</sub></h4>
        <ul>
          <li>
            <a href="#" class="btn btn-judge" id="DP_Group1" onclick="cli_GroupResult('1','<%=LTeam%>','<%=LTeamDtl%>','<%=LTeamNM%>');">
              <span class="txt">
                <%
                  If LTeamNm = "" OR ISNull(LTeamNm) Then
                    Response.Write "-"
                  Else
                    Response.Write LTeamNm
                  End If
                %>              
              </span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
          <li>
            <a href="#" class="btn btn-judge" id="DP_Group2" onclick="cli_GroupResult('2','<%=RTeam%>','<%=RTeamDtl%>','<%=RTeamNM%>');">
              <span class="txt">
                <%
                  If RTeamNm = "" OR ISNull(RTeamNm) Then
                    Response.Write "-"
                  Else
                    Response.Write RTeamNm
                  End If
                %>              
              </span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
        </ul>
      </div>
      <!-- E: sel-list -->

      <!-- S: sel-list -->
      <div class="sel-list">
        <h4>2. 판정결과 선택 <sub>(단일 선택)</sub></h4>
        <ul>
          <li>
            <a href="#" class="btn btn-judge" id="DP_ResultType1" onclick="cli_GroupResultType(1,'<%=crypt.EncryptStringENC("B6010002")%>','경기전 기권 (Walkover)');">
              <span class="txt">경기전 기권 (Walkover)</span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
          <li>
            <a href="#" class="btn btn-judge" id="DP_ResultType2" onclick="cli_GroupResultType(2,'<%=crypt.EncryptStringENC("B6010003")%>','경기중 기권(Retired)');">
              <span class="txt">경기중 기권(Retired)</span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
          <li>
            <a href="#" class="btn btn-judge" id="DP_ResultType3" onclick="cli_GroupResultType(3,'<%=crypt.EncryptStringENC("B5010004")%>','불참 (No match)');">
              <span class="txt">불참 (No match)</span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
        </ul>
      </div>
      <!-- E: sel-list -->

      <!-- S: sel-list -->
      <div class="sel-list">
        <h4>3. 판정결과 선택 <sub>(단일 선택)</sub></h4>
        <ul>
          <li>
            <a href="#" class="btn btn-judge" id="DP_ResultTypeDtl1" onclick="cli_GroupResultTypeDtl('1','<%=crypt.EncryptStringENC("B8010001")%>','부상/질병 (감기, 몸살, 그외)');">
              <span class="txt">부상/질병 (감기, 몸살, 그외)</span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
          <li>
            <a href="#" class="btn btn-judge" id="DP_ResultTypeDtl2" onclick="cli_GroupResultTypeDtl('2','<%=crypt.EncryptStringENC("B8010002")%>','집안 사유');">
              <span class="txt">집안 사유</span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
          <li>
            <a href="#" class="btn btn-judge" id="DP_ResultTypeDtl3" onclick="cli_GroupResultTypeDtl('3','<%=crypt.EncryptStringENC("B8010003")%>','기타');">
              <span class="txt">기타</span>
              <span class="ic-deco">
                <img src="../../images/modal/ic-chk-judge.png" alt>
              </span>
            </a>
          </li>
        </ul>
      </div>
      <!-- E: sel-list -->
    </div>
    <!-- E: sel-content -->

    <!-- S: btn-list -->
    <div class="btn-list">
      <ul class="clearfix">
        <li>
          <a href="#" class="btn btn-default" data-dismiss="modal">닫기</a>
        </li>
        <li>
          <a href="#" onclick="cli_AnotherResultComplete('<%=GameLevelDtlIDX%>','<%=crypt.EncryptStringENC(GameRound)%>','<%=TeamGameNum%>','<%=GameNum%>');" class="btn btn-red">등록완료</a>
        </li>
      </ul>
    </div>
    <!-- E: btn-list -->
  </div>
  <!-- E: modal-body -->
<%

Set LRs = Nothing
DBClose()
  
%>