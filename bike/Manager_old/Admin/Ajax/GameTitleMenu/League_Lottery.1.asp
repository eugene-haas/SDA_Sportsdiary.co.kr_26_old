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
'REQ = "{""CMD"":6,""PlayerCnt"":3,""GameType"":""B0040001"",""GroupGameGb"":""B0030001""}"

Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.GameLevelDtlIDX) Or oJSONoutput.GameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX) 
      DEC_GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)    
    End If
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
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

LSQL = " SELECT COUNT(*) AS Cnt"
LSQL = LSQL & " FROM"
LSQL = LSQL & " ("
LSQL = LSQL & " SELECT A.GameRequestGroupIDX,"
LSQL = LSQL & " STUFF(("
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + MemberName "
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblGameRequestPlayer  "
LSQL = LSQL & "             WHERE   DelYN = 'N' AND GameRequestGroupIDX    = AAA.GameRequestGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblGameRequestPlayer AAA  "
LSQL = LSQL & "         WHERE DelYN = 'N' AND AAA.GameRequestGroupIDX = A.GameRequestGroupIDX"
LSQL = LSQL & "         ),1,1,'') AS LPlayers"
LSQL = LSQL & " ,STUFF(("
LSQL = LSQL & "         SELECT  DISTINCT (  "
LSQL = LSQL & "             SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblGameRequestPlayer  "
LSQL = LSQL & "             WHERE   DelYN = 'N' AND GameRequestGroupIDX    = AAA.GameRequestGroupIDX  "
LSQL = LSQL & "             FOR XML PATH('')  "
LSQL = LSQL & "             )  "
LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblGameRequestPlayer AAA  "
LSQL = LSQL & "         WHERE DelYN = 'N' AND AAA.GameRequestGroupIDX = A.GameRequestGroupIDX "
LSQL = LSQL & "         ),1,1,'') AS LTeams"
LSQL = LSQL & " FROM dbo.tblGameRequestGroup A"
LSQL = LSQL & " INNER JOIN dbo.tblGameRequestTouney B ON B.RequestIDX = A.GameRequestGroupIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND B.GroupGameGb = 'B0030001'"
LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " ) AS AA"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
    PlayerCnt = LRs("Cnt")
Else
    PlayerCnt = "0"
End If

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
%>
<table class="tourney_admin table-fix-head 64" id="tourney_admin">
  <thead>
    <tr id="DP_GangBtn">
		<th style="padding:2px">
        <a href="" class="btn_a btn_func" data-collap="" id="DP_Gang<%=k%>">리그</a>
		</th>
    </tr>
  </thead>
</table>
<div class="scroll_box">
  <table class="table-fix-body tourn-table">
    <tbody>
      <tr id="DP_Tr">
				<td id="DP_Td_1">
          <table class='league-set-table'>
          <tr>
            <td>-</td>     
            <%
              For i = 1 To Cint(PlayerCnt)
            %>
                <td class='click-here' onclick=cli_tourneyinsert('1','<%=i%>','<%=GameType%>',this)>
                  <input type='text' name='Hidden_Data' id='Hidden_Data_1_<%=i%>'>
                  <span class='player' name='DP_UserName' id='DP_UserName_1_<%=i%>'></span>
                  <span class='placeholder'>선택 <i class='far fa-check-circle'></i></span>
                </td>
            <%
              Next
            %>
          </tr>
          <%
            Dim Array_GameNum()

            Redim Array_GameNum(Cint(PlayerCnt)-1)

            For i = 0 To Cint(PlayerCnt) - 1
              Array_GameNum(i) = ""
            Next

            i_num = 0
            j_num = 0            
            leagueGameNum = 1

            For i = 0 To Cint(PlayerCnt) - 1
              i_num = i + 1
          %>
            <tr>
            <td id='DP_R_UserName_1_<%=i_num%>' onclick=cli_tourneyinsert('1','<%=i_num%>','<%=GameType%>',this)>
            
          <%
              For j = 0 To  Cint(PlayerCnt) - 1

                j_num = j + 1

                If i < j AND i <> j Then
                  If Array_GameNum(i) = "" Then
                    Array_GameNum(i) = leagueGameNum
                  Else
                    Array_GameNum(i) = Array_GameNum(i) & "," & leagueGameNum
                  End If

                  If Array_GameNum(j) = "" Then
                    Array_GameNum(j) = leagueGameNum
                  Else
                    Array_GameNum(j) = Array_GameNum(j) & "," & leagueGameNum
                  End If     

                  leagueGameNum = leagueGameNum + 1             
                End If
          %>            
            </td>

            <td id='DP_VSUserName_1_<%=i_num%>'>
            </td>              
          <%
              Next
          %>
            </tr>
          <%
            Next
          %>

          <%
            strGameNum = ""

            
            For i = 0 To Cint(PlayerCnt) - 1

              If i = 0 Then
                strGameNum = Array_GameNum(i)
              Else
                strGameNum = strGameNum & "|" & Array_GameNum(i)
              End If
            Next


          %>
          <input type="text" name="LeagueGameNum" id="LeagueGameNum" value="<%=strGameNum%>">
          </table>
				</td>
      </tr>				
    </tbody>			
  </table>		
</div>



				
