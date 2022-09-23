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
  'REQ = "{""CMD"":7,""tGameLevelDtlIDX"":""5F7699C3E5E0C7C729A2B602969785B6"",""tTeamGameNum"":""1""}"
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
  

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"

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
  
  LSQL = " SELECT GameRequestPlayerIDX, TeamGameNum,GameNum, MemberName, MemberIDX, ORDERBY"
  LSQL = LSQL & " FROM tblTorneyTeamTemp"
  LSQL = LSQL & " WHERE DelYN = 'N'"
  LSQL = LSQL & " AND GameLevelDtlIDx = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND Team + TeamDtl = '" & LTeam & LTeamDtl & "'"
  LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"



  Set LRs = Dbcon.Execute(LSQL)  

  If Not (LRs.Eof Or LRs.Bof) Then
    Arr_TeamTemp_L = LRs.getrows()
  End If
  LRs.Close

  LSQL = " SELECT GameRequestPlayerIDX, TeamGameNum,GameNum, MemberName, MemberIDX, ORDERBY"
  LSQL = LSQL & " FROM tblTorneyTeamTemp"
  LSQL = LSQL & " WHERE DelYN = 'N'"
  LSQL = LSQL & " AND GameLevelDtlIDx = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND Team + TeamDtl = '" & RTeam & RTeamDtl & "'"
  LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"

  Set LRs = Dbcon.Execute(LSQL)  

  If Not (LRs.Eof Or LRs.Bof) Then
    Arr_TeamTemp_R = LRs.getrows()
  End If
  LRs.Close  


%>
  <table class="table">
    <tbody>
      <%
        '단체전 등록된 경기 순서 나열
        For i = 1 To 5 
      %>
      <tr>
        <td>
        <%=i%>
        </td>
        <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'1')" id="DP_LPlayerA_<%=i%>">
          <%
            If ISArray(Arr_TeamTemp_L) Then
              For j = 0 TO UBOUND(Arr_TeamTemp_L,2)
                If Arr_TeamTemp_L(2,j) = i AND Arr_TeamTemp_L(5,j) = "1" Then
                  Response.Write Arr_TeamTemp_L(3,j)
                End If
              NEXT
            End If
          %>
        </td>
        <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'2')" id="DP_LPlayerB_<%=i%>">
          <%
            If ISArray(Arr_TeamTemp_L) Then
              For j = 0 TO UBOUND(Arr_TeamTemp_L,2)
                If Arr_TeamTemp_L(2,j) = i AND Arr_TeamTemp_L(5,j) = "2" Then
                  Response.Write Arr_TeamTemp_L(3,j)
                End If
              NEXT
            End If
          %>        
        </td>
        <td>-</td>
        <td>-</td>
        <td class="game-event">남자복식</td>
        <td>-</td>
        <td>-</td>
        <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'1')" id="DP_RPlayerA_<%=i%>">
          <%
            If ISArray(Arr_TeamTemp_R) Then
              For j = 0 TO UBOUND(Arr_TeamTemp_R,2)
                If Arr_TeamTemp_R(2,j) = i AND Arr_TeamTemp_R(5,j) = "1" Then
                  Response.Write Arr_TeamTemp_R(3,j)
                End If
              NEXT
            End If
          %>          
        </td>
        <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'2')" id="DP_RPlayerB_<%=i%>">
          <%
            If ISArray(Arr_TeamTemp_R) Then
              For j = 0 TO UBOUND(Arr_TeamTemp_R,2)
                If Arr_TeamTemp_R(2,j) = i AND Arr_TeamTemp_R(5,j) = "2" Then
                  Response.Write Arr_TeamTemp_R(3,j)
                End If
              NEXT
            End If
          %>          
        </td>
      </tr>
      <%
        Next
      %>

    </tbody>
  </table>
<%

Set LRs = Nothing
DBClose()
  
%>