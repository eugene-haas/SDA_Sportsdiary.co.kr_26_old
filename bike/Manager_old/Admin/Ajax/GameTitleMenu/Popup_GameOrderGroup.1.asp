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
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS RTeamNM"
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
  LSQL = LSQL & " AND A.TeamGameNum = '" & TeamGameNum & "'"


  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    LTeam = LRs("LTeam")
    LTeamDtl = LRs("LTeamDtl")
    LTeamNM = LRs("LTeamNM")
    RTeam = LRs("RTeam")
    RTeamDtl = LRs("RTeamDtl")
    RTeamNM = LRs("RTeamNM")
  End If

  LRs.Close

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
  <!-- S: modal-body -->
  <div class="modal-body">
    <!-- S: order-header -->
    <div class="order-header clearfix">
      <!-- S: team team-a -->
      <div class="team team-a">
        <!-- S: table -->
        <table class="table">
          <thead>
            <tr>
              <th class="belong">소속</th>
              <th>이름</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <span><%=LTeamNM%></span>
                <!--
                /
                <span>강원</span>
                -->
              </td>
              <td>
                <!--
                <span>최보라</span> /
                <span>이준희</span>
                -->
              </td>
            </tr>
          </tbody>
        </table>
        <!-- E: table -->
      </div>
      <!-- E: team team-a --> 
      <!-- S: vs -->
      <div class="vs">
        <img src="../../images/modal/vs_img.png" alt="vs">
      </div>
      <!-- E: vs -->  
      <!-- S: team team-b -->
      <div class="team team-b">
        <!-- S: table -->
        <table class="table">
          <thead>
            <tr>
              <th>이름</th>
              <th class="belong">소속</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <!--
                <span>홍원표</span> /
                <span>김정연</span>
                -->
              </td>
              <td>
                <span><%=RTeamNM%></span>
                <!--
                /
                <span>강원</span>
                -->
              </td>
            </tr>
          </tbody>
        </table>
        <!-- E: table -->
      </div>
      <!-- E: team team-b -->
    </div>
    <!-- E: order-header -->  
    <!-- S: order-body -->
    <div class="order-body clearfix">
      <!-- S: group group-a -->
      <div class="group group-a">
        <!-- S: table table-fix-header -->
        <table class="table table-fix-header">
          <tbody>
            <tr>
              <th>선수명</th>
              <th class="sel">선택</th>
            </tr>
          </tbody>
        </table>
        <!-- E: table table-fix-header -->  
        <!-- S: scroll-box -->
        <div class="scroll-box">
          <!-- S: table table-body -->
          <table class="table table-body">
            <tbody>
              <%
                '좌측 단체전 인원 SELECT
                LSQL = " SELECT C.GameRequestPlayerIDX ,C.MemberName, C.MemberIDX, B.GameLevelDtlIDX"
                LSQL = LSQL & " FROM tblGameRequestTeam A"
                LSQL = LSQL & " INNER JOIN tblGameRequestTouney B ON B.RequestIDX = A.GameRequestTeamIDX"
                LSQL = LSQL & " INNER JOIN tblGameRequestPlayer C ON C.GameRequestTeamIDX = A.GameRequestTeamIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N'"
                LSQL = LSQL & " AND B.DelYN = 'N'"
                LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
                LSQL = LSQL & " AND A.Team + A.TeamDtl = '" & LTeam & LTeamDtl & "'"
                LSQL = LSQL & " AND B.GroupGameGb = 'B0030002'"      
                Set LRs = Dbcon.Execute(LSQL)

                If Not (LRs.Eof Or LRs.Bof) Then

                  i = 0

                  Do Until LRs.Eof                   
              %>
                <tr>
                  <td><%=LRs("MemberName")%></td>
                  <td>
                    <!--btn btn-red-->
                    <!--btn btn-gray-->
                    <a href="#" class="btn btn-red" id="Btn_Player<%=i%>" onclick="OnWaitPlayerClick('<%=crypt.EncryptStringENC(LRs("GameRequestPlayerIDX"))%>');">선택</a>
                  </td>
                </tr>                
              <%
                        i = i + 1
                        LRs.MoveNext            
                    Loop
                End If

                LRs.Close
              %>
            </tbody>
          </table>
          <!-- E: table table-body -->
        </div>
        <!-- E: scroll-box -->
      </div>
      <!-- E: group group-a --> 
      <!-- S: order-paper -->
      <div class="order-paper">
        <!-- S: arr-table -->
        <div class="arr-table">
          <!-- S: table-fix-header -->
          <table class="table-fix-header">
            <tbody>
              <input type="text" id="SelectReqPlayerIDX" value="">
              <tr>
                <th>No</th>
                <th colspan="2">선수명</th>
                <th colspan="2">결과</th>
                <th class="game-event">종목</th>
                <th colspan="2">결과</th>
                <th colspan="2">선수명</th>
              </tr>
            </tbody>
          </table>
          <!-- E: table-fix-header -->
        </div>
        <!-- E: arr-table --> 
        <!-- S: scroll-box -->
        <div class="scroll-box">
          <!-- S: table -->
          <table class="table">
            <tbody>
              <%
                '단체전 등록된 경기 순서 나열
                For i = 1 To 5 
              %>
              <tr>
                <td>
                <%=i+1%>
                <input type="text" id="STR_LPlayerA_<%=i%>" name="LPlayerA">
                <input type="text" id="STR_LPlayerB_<%=i%>" name="LPlayerB">
                <input type="text" id="STR_RPlayerA_<%=i%>" name="RPlayerA">
                <input type="text" id="STR_RPlayerB_<%=i%>" name="RPlayerB">
                </td>
                <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>',<%=i%>,'1')" id="DP_LPlayerA_<%=i%>">
                </td>
                <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>',<%=i%>,'2')" id="DP_LPlayerB_<%=i%>">
                
                </td>
                <td>-</td>
                <td>-</td>
                <td class="game-event">남자복식</td>
                <td>-</td>
                <td>-</td>
                <td onclick="OnEmptyAreaClick('PlayerA_<%=i%>','R')" id="DP_RPlayerA_<%=i%>">
                
                </td>
                <td onclick="OnEmptyAreaClick('PlayerB_<%=i%>','R')" id="DP_RPlayerB_<%=i%>">
                
                </td>
              </tr>
              <%
                Next
              %>
              <!--
              <tr>
                <td>4</td>
                <td>
                  <img src="../../images/modal/ic_check.png" alt>
                </td>
                <td>
                  <img src="../../images/modal/ic_check.png" alt>
                </td>
                <td>-</td>
                <td>-</td>
                <td class="game-event">남자복식</td>
                <td>-</td>
                <td>-</td>
                <td>강서영</td>
                <td>김정연</td>
              </tr>
              -->

            </tbody>
          </table>
          <!-- E: table -->
        </div>
        <!-- E: scroll-box -->  
        <!-- S: arr-table -->
        <div class="arr-table arr-footer">
          <!-- S: table-fix-footer -->
          <table class="table-fix-footer">
            <tbody>
              <tr class="total">
                <td>
                  <span class="ic-deco">
                    <i class="fas fa-angle-double-right"></i>
                  </span>
                </td>
                <td colspan="3">-</td>
                <td>-</td>
                <td class="text-bold">합계</td>
                <td>-</td>
                <td colspan="3">-</td>
              </tr>
            </tbody>
          </table>
          <!-- E: table-fix-footer -->
        </div>
        <!-- E: arr-table -->
      </div>
      <!-- E: order-paper --> 
      <!-- S: group group-b -->
      <div class="group group-b">
        <!-- S: table table-fix-header -->
        <table class="table table-fix-header">
          <tbody>
            <tr>
              <th>선수명</th>
              <th class="sel">선택</th>
            </tr>
          </tbody>
        </table>
        <!-- E: table table-fix-header -->  
        <!-- S: scroll-box -->
        <div class="scroll-box">
          <!-- S: table table-body -->
          <table class="table table-body">
            <tbody>
              <%
                '좌측 단체전 인원 SELECT
                LSQL = " SELECT C.GameRequestPlayerIDX ,C.MemberName, C.MemberIDX"
                LSQL = LSQL & " FROM tblGameRequestTeam A"
                LSQL = LSQL & " INNER JOIN tblGameRequestTouney B ON B.RequestIDX = A.GameRequestTeamIDX"
                LSQL = LSQL & " INNER JOIN tblGameRequestPlayer C ON C.GameRequestTeamIDX = A.GameRequestTeamIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N'"
                LSQL = LSQL & " AND B.DelYN = 'N'"
                LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
                LSQL = LSQL & " AND A.Team + A.TeamDtl = '" & RTeam & RTeamDtl & "'"
                LSQL = LSQL & " AND B.GroupGameGb = 'B0030002'"      


                Set LRs = Dbcon.Execute(LSQL)

                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof                   
              %>
                <tr>
                  <td><%=LRs("MemberName")%></td>
                  <td>
                    <a href="#" class="btn btn-red" onclick="OnWaitPlayerClick('<%=crypt.EncryptStringENC(LRs("GameRequestPlayerIDX"))%>');">선택</a>
                  </td>
                </tr>                
              <%
                        LRs.MoveNext            
                    Loop
                End If
                LRs.Close
              %>            
            </tbody>
          </table>
          <!-- E: table table-body -->
        </div>
        <!-- E: scroll-box -->
      </div>
      <!-- E: group group-b -->
    </div>
    <!-- E: order-body -->  
    <!-- S: order-footer -->
    <div class="order-footer">
      <ul class="btn-list clearfix">
        <li><a href="#" class="btn btn-default" data-dismiss="modal">닫기</a></li>
        <li><a href="#" class="btn btn-red">등록완료</a></li>
      </ul>
    </div>
    <!-- E: order-footer -->
  </div>
  <!-- E: modal-body -->
<%

Set LRs = Nothing
DBClose()
  
%>