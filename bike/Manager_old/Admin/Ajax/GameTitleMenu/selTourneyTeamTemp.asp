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
  'REQ = "{""CMD"":7,""tGameLevelDtlIDX"":""D699A4D046D9389A5B28ACBEC4075BBD"",""tTeamGameNum"":""1""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameLevelDtlIDX") = "ok" then
    GameLevelDtlIDX = fInject(oJSONoutput.tGameLevelDtlIDX)
    DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLeveldtlIdX))
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
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS RTeamNM,"
  LSQL = LSQL & " D.GameLevelIDX"
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
  'Response.Write "<BR/>LSQL : " & LSQL & "<BR/>"

  If Not (LRs.Eof Or LRs.Bof) Then
    LTeam = LRs("LTeam")
    LTeamDtl = LRs("LTeamDtl")
    LTeamNM = LRs("LTeamNM")
    RTeam = LRs("RTeam")
    RTeamDtl = LRs("RTeamDtl")
    RTeamNM = LRs("RTeamNM")
    
    GameLevelIDX = LRs("GameLevelIDX")
  End If
  
  LSQL = " SELECT GameRequestPlayerIDX, TeamGameNum,GameNum, MemberName, MemberIDX, ORDERBY"
  LSQL = LSQL & " FROM tblTorneyTeamTemp"
  LSQL = LSQL & " WHERE DelYN = 'N'"
  LSQL = LSQL & " AND GameLevelDtlIDx = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND Team + TeamDtl = '" & LTeam & LTeamDtl & "'"
  LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"

  Set LRs = Dbcon.Execute(LSQL)  
  'Response.Write "<BR/> Arr_TeamTemp_L LSQL : " & LSQL & "<BR/>"

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
  'Response.Write "<BR/> Arr_TeamTemp_R LSQL : " & LSQL & "<BR/>"

  If Not (LRs.Eof Or LRs.Bof) Then
    Arr_TeamTemp_R = LRs.getrows()
  End If
  LRs.Close  


%>
  <table class="table">
    <tbody>
      <%
        '단체전 등록된 경기 순서 나열
        LSQL = " SELECT dbo.FN_NameSch(Sex,'pubcode') AS SexNM, dbo.FN_NameSch(GameType,'pubcode') AS GameTypeNM"
        LSQL = LSQL & " FROM tblGroupGameOrder"
        LSQL = LSQL & " WHERE DelYN = 'N'"
        LSQL = LSQL & " AND GameLevelIDX = '" & GameLevelIDX & "'"

         'Response.Write "<BR/>LSQL : " & LSQL & "<BR/>"

        Set LRs = Dbcon.Execute(LSQL)

        i = 1

        If Not (LRs.Eof Or LRs.Bof) Then

          Do Until LRs.Eof
      %>
      <tr>
        <td>
        <%=i%>
        </td>
          <%
            chkTeamtemp = ""
            'tourneyteamtemp에 왼팀 오른쪽선수 값이 있다면..

            If ISArray(Arr_TeamTemp_L) Then
            
              For j = 0 TO UBOUND(Arr_TeamTemp_L,2)
                If Arr_TeamTemp_L(2,j) = i AND Arr_TeamTemp_L(5,j) = "1" Then
            %>
              <td  id="DP_LPlayerA_<%=i%>" onclick="OnWaitDeleteClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=i%>','<%=crypt.EncryptStringENC(Arr_TeamTemp_L(0,j))%>')">
            <%
                  Response.Write Arr_TeamTemp_L(3,j)
                  Response.Write "<input type='hidden' id='LPlayerA_" & i & "' name='LPlayerA' value='" & crypt.EncryptStringENC(Arr_TeamTemp_L(0,j)) & "'>"
                  chkTeamtemp = "Y"

                End If
              NEXT
            End If

            If chkTeamtemp = "" Then
          %>
          <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'1')" id="DP_LPlayerA_<%=i%>">
          <%
              Response.Write "<input type='hidden' id='LPlayerA_" & i & "' name='LPlayerA' value=''>"
            End If
          %>
        </td>


        
          <%
            chkTeamtemp = ""

            'tourneyteamtemp에 왼팀 오른쪽선수 값이 있다면..
            If ISArray(Arr_TeamTemp_L) Then
              For j = 0 TO UBOUND(Arr_TeamTemp_L,2)
                If Arr_TeamTemp_L(2,j) = i AND Arr_TeamTemp_L(5,j) = "2" Then
                %>
                <td id="DP_LPlayerB_<%=i%>" onclick="OnWaitDeleteClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=i%>','<%=crypt.EncryptStringENC(Arr_TeamTemp_L(0,j))%>')">
                <%
                  Response.Write Arr_TeamTemp_L(3,j)
                  Response.Write "<input type='hidden' id='LPlayerB_" & i & "' name='LPlayerB' value='" & crypt.EncryptStringENC(Arr_TeamTemp_L(0,j)) & "'>"

                  chkTeamtemp = "Y"
                End If
              NEXT
            End If

            If chkTeamtemp = "" Then
            %>
            <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'2')" id="DP_LPlayerB_<%=i%>">
            <%
              Response.Write "<input type='hidden' id='LPlayerB_" & i & "' name='LPlayerB' value=''>"
            End If            
          %>        
        </td>

        <td>-</td>
        <td>-</td>
        <td class="game-event"><%=LRs("SexNM") & LRs("GameTypeNM")%></td>
        <td>-</td>
        <td>-</td>
        
          <%
            chkTeamtemp = ""
            'tourneyteamtemp에 오른팀 왼쪽선수 값이 있다면..
            If ISArray(Arr_TeamTemp_R) Then
              For j = 0 TO UBOUND(Arr_TeamTemp_R,2)
                If Arr_TeamTemp_R(2,j) = i AND Arr_TeamTemp_R(5,j) = "1" Then
                %>
                  <td id="DP_RPlayerA_<%=i%>" onclick="OnWaitDeleteClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=i%>','<%=crypt.EncryptStringENC(Arr_TeamTemp_R(0,j))%>')">
                <%
                  Response.Write Arr_TeamTemp_R(3,j)
                  Response.Write "<input type='hidden' id='RPlayerA_" & i & "' name='RPlayerA' value='" & crypt.EncryptStringENC(Arr_TeamTemp_R(0,j)) & "'>"

                  chkTeamtemp = "Y"
                End If
              NEXT
            End If

            If chkTeamtemp = "" Then
            %>
              <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'1')" id="DP_RPlayerA_<%=i%>">
            <%
              Response.Write "<input type='hidden' id='RPlayerA_" & i & "' name='RPlayerA' value=''>"
            End If              
          %>          
        </td>
      
          <%
            chkTeamtemp = ""
            'tourneyteamtemp에 오른팀 오른쪽선수 값이 있다면..
            If ISArray(Arr_TeamTemp_R) Then
              For j = 0 TO UBOUND(Arr_TeamTemp_R,2)
                If Arr_TeamTemp_R(2,j) = i AND Arr_TeamTemp_R(5,j) = "2" Then
                %>
                  <td id="DP_RPlayerB_<%=i%>"  onclick="OnWaitDeleteClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>','<%=i%>','<%=crypt.EncryptStringENC(Arr_TeamTemp_R(0,j))%>')">
                <%
                  Response.Write Arr_TeamTemp_R(3,j)
                  Response.Write "<input type='hidden' id='RPlayerB_" & i & "' name='RPlayerB' value='" & crypt.EncryptStringENC(Arr_TeamTemp_R(0,j)) & "'>"

                  chkTeamtemp = "Y"
                End If
              NEXT
            End If

            If chkTeamtemp = "" Then
            %>
              <td onclick="OnEmptyAreaClick('<%=GameLevelDtlIDX%>','<%=TeamGameNum%>',<%=i%>,'2')" id="DP_RPlayerB_<%=i%>">
            <%
              Response.Write "<input type='hidden' id='RPlayerB_" & i & "' name='RPlayerB' value=''>"
            End If               
          %>          
        </td>
      </tr>
      <%
            i = i + 1

            LRs.MoveNext            
          Loop                
        Else
      %>
        <tr>
          <td>해당종목 단체전 순서가 필요합니다. 등록 후, 이용가능합니다.</td>
        </tr>
      <%
        End If

        LRs.Close
      %>
    </tbody>
  </table>
<%

Set LRs = Nothing
DBClose()
  
%>

