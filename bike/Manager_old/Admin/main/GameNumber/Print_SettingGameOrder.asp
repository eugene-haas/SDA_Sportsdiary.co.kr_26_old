<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<% 
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"

  tGameTitleIDX = Request("GameTitleIDX")
  tStadiumIDX = Request("StadiumIdx")
  tGameDay= Request("GameDay")

  If ISNull(tGameTitleIDX) Or tGameTitleIDX = "" Then
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
  Else
    GameTitleIDX = fInject(tGameTitleIDX)
    DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(tGameTitleIDX))    
  End If

  If ISNull(tStadiumIDX) Or tStadiumIDX = "" Then
    StadiumIDX = ""
    DEC_StadiumIDX = ""
  Else
    StadiumIDX = fInject(tStadiumIDX)
    DEC_StadiumIDX = fInject(crypt.DecryptStringENC(tStadiumIDX))
  End If


  If ISNull(tGameDay) Or tGameDay = "" Then
    GameDay = ""
    DEC_GameDay = ""
  Else
    GameDay = fInject(tGameDay)
    DEC_GameDay = fInject(tGameDay)
  End If

  Dim StadiumCourt : StadiumCourt = 0
  LSQL = " SELECT StadiumCourt "
  LSQL = LSQL & " FROM tblStadium "
  LSQL = LSQL & "   where GameTitleIDX ='" & DEC_GameTitleIDX & "' and StadiumIDX ='" & DEC_StadiumIDX & "' and DelYN = 'N'"
  Set LRs = Dbcon.Execute(LSQL)

  IF Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof  
        StadiumCourt = LRs("StadiumCourt")
        LRs.MoveNext()
      Loop
  End If   
  LRs.Close         

  'Response.Write "StadiumCourt : " & StadiumCourt & "<BR/>"
  
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="ko">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <meta name="author" content="administrator1" />
      <meta name="company" content="Microsoft Corporation" />
    <title>스코어지</title>

     <style>
    table {
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid black;
    }

  </style>

  </head>
  <body>
    
<table cellspacing="0" cellpadding="0" id="tableGameSchedule" name="tableGameSchedule" >
  <thead>
    <tr>
      <th  class="backslash" style="width:60px"><div>코트</div>번호</th>
      <% For i = 1 To StadiumCourt %>
      <th><%=i%> 코트</th>
      <% Next %>
    </tr>
  </thead>
  <tbody>

  <%
    Dim MaxTurnNum : MaxTurnNum = 0
    DEC_GroupGameGb = ""
    DEC_SearchKeyWord = ""
    DEC_SearchKey = ""
    DEC_TempNum  =""
    DEC_PlayLevelType = ""
    DEC_GameStatus =""
    DEC_StadiumNum =""
    DEC_GameLevelIdx =""
    DEC_Type ="1"
    LSQL = "EXEC tblGameNumberTourney_Searched_STR_MaxTurnNum '" & DEC_GameTitleIDX & "','" & DEC_GameLevelIdx & "','" & DEC_GameDay & "','" & DEC_StadiumIDX & "','" & DEC_StadiumNum & "','" & DEC_GameStatus & "','" & DEC_PlayLevelType & "','" & DEC_TempNum & "','" & DEC_SearchKey & "','" & DEC_SearchKeyWord & "','" & DEC_GroupGameGb & "','" & DEC_Type & "'"        
    'Response.Write "LSQL" & LSQL & "<BR/>"
    'Response.end
    Set LRs = DBCon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          MaxTurnNum = LRs("MaxTurnNum")
          IF MaxTurnNum = "" Then
            MaxTurnNum = 0
          End IF
        LRs.MoveNext
      Loop
    End If
    LRs.close

    'Response.Write "MaxTurnNum" & MaxTurnNum & "<br/>"
    'Response.Write "StadiumCourt" & StadiumCourt & "<br/>"
    DEC_Type ="2"
    LSQL = "EXEC tblGameNumberTourney_Searched_STR '" & DEC_GameTitleIDX & "','" & DEC_GameLevelIdx & "','" & DEC_GameDay & "','" & DEC_StadiumIDX & "','" & DEC_StadiumNum & "','" & DEC_GameStatus & "','" & DEC_PlayLevelType & "','" & DEC_TempNum & "','" & DEC_SearchKey & "','" & DEC_SearchKeyWord & "','" & DEC_GroupGameGb & "','" & DEC_Type & "'"        
    'Response.Write "LSQL : " & LSQL & "<BR/>"
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      arryGameSchedule = LRs.getrows()
    End If
    LRs.close
    'Response.Write "UBound(arryGameSchedule, 2) " & UBound(arryGameSchedule, 2)  & "<br/>"

    DATACNT = 0

    For i = 1 To MaxTurnNum 'Row
  %>
    <tr>
      <td><%=i%></td>
    <%
      For j = 1 To StadiumCourt 'Column
        'Response.Write "i : " & i & " , j : " & j & "<br/>"
        DataCount = 0
        IsData = false  
        If IsArray(arryGameSchedule) Then
          For ar = LBound(arryGameSchedule, 2) To UBound(arryGameSchedule, 2) 
            DataCount = DataCount + 1
            r_TurnNum = arryGameSchedule(26, ar) 
            r_StadiumNum = arryGameSchedule(39, ar) 
            'Response.Write "DataCount" & DataCount & " r_TurnNum : "  & r_TurnNum & "r_StadiumNum : " & r_StadiumNum &  "<br/>"
               
            IF r_TurnNum <> "" And r_StadiumNum <> "" Then
              IF cdbl(i) = cdbl(r_TurnNum) and cdbl(j) = cdbl(r_StadiumNum) Then
                IsData = true
                  'Response.Write "DataCount" & DataCount & " r_TurnNum : "  & r_TurnNum & "r_StadiumNum : " & r_StadiumNum &  "<br/>"
                  r_TeamGameNum  = arryGameSchedule(3, ar) 
                  r_GameNum  = arryGameSchedule(4, ar)  
                  r_TeamGbNM = arryGameSchedule(9, ar) 
                  r_LevelNM = arryGameSchedule(10, ar) 
                  r_PlayTypeNM = arryGameSchedule(11, ar) 
                  r_ROUND = arryGameSchedule(23, ar) 
                  r_Sex = arryGameSchedule(24, ar) 
                  r_GroupGameGb = arryGameSchedule(27, ar) 

                  r_LPlayer1 = arryGameSchedule(31, ar) 
                  r_LPlayer2 = arryGameSchedule(32, ar) 
                  r_RPlayer1 = arryGameSchedule(33, ar) 
                  r_RPlayer2 = arryGameSchedule(34, ar) 

                  r_LTeam1 = arryGameSchedule(35, ar) 
                  r_LTeam2 = arryGameSchedule(36, ar) 
                  r_RTeam1 = arryGameSchedule(37, ar) 
                  r_RTeam2 = arryGameSchedule(38, ar) 


                  r_LevelJooNum = arryGameSchedule(42, ar) 
                  r_LevelDtlJooNum = arryGameSchedule(43, ar)
                  r_PlayLevelType = arryGameSchedule(46, ar) 
                  r_LevelJooName = arryGameSchedule(47, ar) 
                  r_MaxRound = arryGameSchedule(48, ar) 
                  r_GameType = arryGameSchedule(49, ar) 
                  r_GroupGameGbNM = arryGameSchedule(51, ar) 
                  'GameSchedule = "(" & r_TeamGameNum  & ")," & "(" & r_GameNum  & ")"
                  r_ResultGangSu = GetGangSu(r_GameType, r_MaxRound, r_ROUND) 
                Exit For
              End IF 
            End IF 
          Next
        End IF
    %>  
        <td>

        <% IF IsData = true Then %>
            <span style=" font-weight: bold;">   <%=r_TeamGbNM%>&nbsp;</span>
            <span class="span_GameLevel" style=" font-weight: bold;">
              <%
                IF LEN(r_PlayTypeNM) > 0  then
                  Response.Write Left(r_Sex,1) & Left(r_PlayTypeNM,1)
                Else
                  Response.Write r_Sex
                END IF
              %>
              <%=r_LevelNM%><%=r_LevelJooName%>
             </span>

            <span class="span_GameLevelDtl" style=" font-weight: bold;">
              <%
                If r_PlayLevelType = "B0100001" Then
                    Response.Write " 예선" & r_LevelDtlJooNum &"조"
                ElseIf  r_PlayLevelType = "B0100002" Then
                  IF r_ResultGangSu = "" Then
                    Response.Write " 본선" 
                  Else
                    Response.Write " 본선" & "-" & r_ResultGangSu
                  ENd iF
                Else
                    Response.Write "-"
                End If          
              %>
           </span>
      
          <% IF r_GroupGameGb = GroupGame Then%>  
            <span class="span_LeftTeam"> <%=r_LTeam1%> </span>
            <span class="span_Battle"> vs </span>
            <span class="span_RightTeam"> <%=r_RTeam1%> </span>
          <% ELse %>
            <span class="span_LeftPlayer"> <%=r_LPlayer1%>&nbsp;<%=r_LPlayer2%> </span>
            <span class="span_LeftTeam"> (<%=r_LTeam1%>) </span>
            <span class="span_Battle"> vs </span>
            <span class="span_RightPlayer"> <%=r_RPlayer1%>&nbsp;<%=r_RPlayer2%> </span>
            <span class="span_RightTeam"> <%=r_RTeam1%> </span>
          <%End IF%>

        <%Else%>
          <span>[<%=j%> 코트 <%=i%>번호] </span>  
        <%End IF%>
          <input type="hidden" id="hiddenGameCourt" name="hiddenGameCourt" value="<%=j%>">
          <input type="hidden" id="hiddenGameOrder" name="hiddenGameOrder" value="<%=i%>">
          <input type="hidden" id="hiddenStadiumIdx" name="hiddenStadiumIdx" value="<%=StadiumIDX%>">
          <input type="hidden" id="hiddenGameDay" name="hiddenGameDay" value="<%=DEC_GameDay%>">
        </td>
    <%  
        GameSchedule = ""
 
      Next 
    %>
   
    </tr>
  <%
    Next
  %>
  </tbody>
</table>
  </body>
</html>
<%
  'Response.END
  Response.Buffer = True
  Response.ContentType = "application/vnd.ms-excel"
  Response.CacheControl = "public"
  Response.AddHeader "Content-disposition","attachment;filename=score.xls"
%>

