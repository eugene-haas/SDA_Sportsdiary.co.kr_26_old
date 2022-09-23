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

Response.ContentType = "text/html"
Response.AddHeader "Content-Type", "text/html;charset=utf-8"
Response.CodePage = "65001"
Response.CharSet = "utf-8"

'득점자 배점,감점

Dim LSQL ,SSQL
Dim LRs ,SRs
Dim strjson
Dim strjson_sum

Dim i

Dim oJSONoutput_SUM
Dim oJSONoutput

Dim CMD  
Dim GameDay 
Dim StadiumNumber
Dim PlayType
Dim IngType
Dim SchUserName

Dim SRs_Data
Dim DRs_Data

Dim GameEndGubun

Dim strjson_dtl

  REQ = Request("Req")
  'REQ = "{""CMD"":4,""tGameTitleIDX"":""7CF03B23B9A19495C66E7DCEE4683D5E"",""tGameDay"":"""",""tStadiumIDX"":"""",""tStadiumNumber"":"""",""tSearchName"":"""",""tPlayLevelType"":"""",""tGroupGameGB"":""B0030001""}"

  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
      If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
        GameTitleIDX = ""
        DEC_GameTitleIDX = ""
      Else
        GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
        DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
      End If
  End if  

  If hasown(oJSONoutput, "tGameDay") = "ok" then
      If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
        GameDay = ""
        DEC_GameDay = ""
      Else
        GameDay = fInject(oJSONoutput.tGameDay)
        DEC_GameDay = fInject(crypt.DecryptStringENC(oJSONoutput.tGameDay))    
      End If
  End if  

  If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
      If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
        StadiumIDX = ""
        DEC_StadiumIDX = ""
      Else
        StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
        DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))    
      End If
  End if  

  If hasown(oJSONoutput, "tStadiumNumber") = "ok" then
      If ISNull(oJSONoutput.tStadiumNumber) Or oJSONoutput.tStadiumNumber = "" Then
        StadiumNumber = ""
        DEC_StadiumNumber = ""
      Else
        StadiumNumber = fInject(oJSONoutput.tStadiumNumber)
        DEC_StadiumNumber = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumNumber))    
      End If
  End if  


  If hasown(oJSONoutput, "PlayType") = "ok" then
      If ISNull(oJSONoutput.PlayType) Or oJSONoutput.PlayType = "" Then
        PlayType = ""
        DEC_PlayType = ""
      Else
        PlayType = fInject(oJSONoutput.PlayType)
        DEC_PlayType = fInject(crypt.DecryptStringENC(oJSONoutput.PlayType))    
      End If
  End if  

  If hasown(oJSONoutput, "IngType") = "ok" then
      If ISNull(oJSONoutput.IngType) Or oJSONoutput.IngType = "" Then
        IngType = ""
        DEC_IngType = ""
      Else
        IngType = fInject(oJSONoutput.IngType)
        DEC_IngType = fInject(crypt.DecryptStringENC(oJSONoutput.IngType))    
      End If
  End if  

  If hasown(oJSONoutput, "tSearchName") = "ok" then
      If ISNull(oJSONoutput.tSearchName) Or oJSONoutput.tSearchName = "" Then
        SchUserName = ""
        DEC_SchUserName = ""
      Else
        SchUserName = fInject(oJSONoutput.tSearchName)
        DEC_SchUserName = fInject(crypt.DecryptStringENC(oJSONoutput.tSearchName))    
      End If
  End if  

  If hasown(oJSONoutput, "tPlayLevelType") = "ok" then
      If ISNull(oJSONoutput.tPlayLevelType) Or oJSONoutput.tPlayLevelType = "" Then
        PlayLevelType = ""
        DEC_PlayLevelType = ""
      Else
        PlayLevelType = fInject(oJSONoutput.tPlayLevelType)
        DEC_PlayLevelType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayLevelType))    
      End If
  End if  

  If hasown(oJSONoutput, "tGroupGameGB") = "ok" then
    If ISNull(oJSONoutput.tGroupGameGB) Or oJSONoutput.tGroupGameGB = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""        
    Else
      GroupGameGb = fInject(oJSONoutput.tGroupGameGB)
      DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGB))
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
  End if	



  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  DEC_TempNum = ""
  DEC_Searchkeyword =""
  DEC_Searchkey = ""
  
  LSQL = " EXEC tblGameTourney_Searched_STR '" & DEC_GameTitleIDX & "', '" & GameDay & "', '" & DEC_StadiumIDX &"' ,'"  & StadiumNumber &"','" & "GameEnd" & "','" & PlayLevelType & "' ,'" & DEC_TempNum & "'  ,'" & DEC_Searchkey & "'  ,'"  & DEC_Searchkeyword & "','" & GroupGameGb & "'"
  'Response.write "LSQL" & LSQL & "<BR/>"
  'Response.ENd
  Set LRs = Dbcon.Execute(LSQL)
%>

    <table class="match-order">
      <tr>
        <th>경기번호</th>
        <th>코트</th>
        <th>단체전 오더등록</th>
        <th>종목</th>
        <th>경기 타입</th>
        <th>대진표</th>
        <th colspan="2">팀1</th>
        <th>점수</th>        
        <th colspan="2">팀2</th>
        <th>점수</th>
        <th>승패결과</th>
        <th>그외판정</th>
      </tr>
<%
GameTourneyCnt = 0
If Not (LRs.Eof Or LRs.Bof) Then
    i = 0
    Do Until LRs.Eof

    GameTourneyCnt = GameTourneyCnt + 1 
    
    If LRs("GameStatus") <> "" AND ISNULL(LRs("GameStatus")) = false Then
        GameEndGubun = LRs("GameStatus")
    Else
        GameEndGubun = "GameEmpty"
    End If
    A_TourneyCnt = LRs("TourneyCnt")
    A_LTeamDtl = LRs("LTeamDtl")
    A_RTeamDtl = LRs("RTeamDtl")
    A_GroupGameGb = LRs("GroupGameGb") 
    A_TempNum = LRs("TempNum")
    A_StadiumNum = LRs("StadiumNum")
    A_RResultType = LRs("RResultType")

    A_GameType= LRs("GameType")
    A_MaxRound = LRs("MaxRound")
    A_Round = LRs("Round")
    A_ResultGangSu = GetGangSu(A_GameType, A_MaxRound,A_Round)

%>
      <tr>
        <td>
          <span><%=LRs("TempNum")%></span>
        </td>
        <td>
          <span><%=LRs("StadiumNum")%></span>
        </td>
        <td>
          <%If LRs("GroupGameGb") = "B0030002" Then%>
            <a href="#" class='order-btn blue_btn <% IF CDBL(A_TourneyCnt) > 0 Then Response.Write " on" End IF %>'
            data-toggle="modal" data-target=".group-order" onclick="popup_GameOrder_Group('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=LRs("TeamGameNum")%>','<%=LRs("GameNum")%>');">출전선수 오더</a>
          <%End If%>
        </td>
        <td>
          <span>
          <%=LRs("Sex") & LRs("PlayTypeNM") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooName") & LRs("LevelJooNum") %>
          </span>
        </td>
        <td>
          <span>
            <%=LRS("GameTypeNM")%>
          </span>
        </td>
        <td>
          <span>
          <%
            If LRs("PlayLevelType") = "B0100001" Then
                Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
            ElseIf LRs("PlayLevelType") = "B0100002" Then
              IF A_ResultGangSu = "" Then
                Response.Write " 본선" 
              Else
                Response.Write " 본선" & "-" & A_ResultGangSu
              ENd iF
                
            Else
                Response.Write "-"
            End If          
          %>          
          </span>
        </td>
        
        <%
          '해당선수가 있으면 선수표시
          If LRs("LTourneyGroupIDX") <>  "" AND LRs("LTourneyGroupIDX") <>  "0" Then
        %>      
        <td class="team">
          <span class="cut-el"><%=LRs("LTeam1")%>
          <% IF A_LTeamDtl <> "0" Then Response.Write "-" & A_LTeamDtl End IF%>
          </span>
        </td>
        <td>
          <span><%=LRs("LPlayer1")%></span> 

          <%If LRs("LPlayer2") <> "" Then%>
            /<span><%=LRs("LPlayer2")%></span>
          <%End If%>

        </td>
        <td>
          <span  <% IF LRs("LResultType") = "WIN" Then Response.Write "style='color:blue;font-size:14px;font-weight: bold;'" End IF %>>
          <%=LRs("LResultType")%> : </span>         
          <%=LRs("LJumsu")%>
        </td>
        <%Else%>
        <td>
          <span>-</span>
        </td>
        <td>
          <span>
            <%If LRs("Round") = "1" Then%>
              <!--BYE-->
            <%End If%>
          </span>
        </td>    
        <td><%=LRs("LJumsu")%></td>   
        <%End If%>


        <td class="team">
          <span class="cut-el"><%=LRs("RTeam1")%>
          <% IF A_RTeamDtl <> "0" Then Response.Write "-" & A_RTeamDtl End IF%>
          </span>
        </td>
        <td>
          <span><%=LRs("RPlayer1")%></span>
        
          <%If LRs("RPlayer2") <> "" Then%>
            /<span><%=LRs("RPlayer2")%></span>
          <%End If%>        
        </td>
        <td>
          <span 
          <% IF LRs("RResultType") = "WIN" Then Response.Write "style='color:blue;font-size:14px;font-weight: bold;'" End IF %>>
          <%=A_RResultType%> : 
          </span>         
          <%=LRs("RJumsu")%>
        </td>
        <%
          btncolor_win = ""
          btncolor_anowin = ""

          '경기결과가 있으면
          If LRs("LResult") <> "" AND LRs("RResult") <> "" Then
            '그외경기결과로 처리되었다면..
            If LRs("LResultDtl") <> "" OR LRs("RResultDtl") <> "" Then
              btncolor_win = "gray_btn"
            Else
              btncolor_win = "red_btn"
            End If
          Else
            btncolor_win = "gray_btn"
          End If

          '경기결과가 있으면
          If LRs("LResult") <> "" AND LRs("RResult") <> "" Then
            '그외경기결과로 처리되었다면..
            If LRs("LResultDtl") <> "" OR LRs("RResultDtl") <> "" Then
              btncolor_anowin = "blue_btn"
            Else
              btncolor_anowin = "gray_btn"
            End If
          Else
            btncolor_anowin = "gray_btn"
          End If          
          
        %>
        <td>
          <%If GameEndGubun = "GameIng" Then%>
            <%If LRs("GroupGameGb") = "B0030001" Then%>
              <a href="#" onclick="OnResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".play_detail_modal">경기중</a>
            <%Else%>
              <a href="#" onclick="OnGroupResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".winner-sign">경기중</a>
            <%End If%>
          <%Else%>
            <%If LRs("GroupGameGb") = "B0030001" Then%>
              <a href="#" onclick="OnResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".play_detail_modal">선택</a>
            <%Else%>
              <a href="#" onclick="OnGroupResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC("1")%>','')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".winner-sign">선택</a>
            <%End If%>
          <%End If%>
        </td>
        <td>
          <%If GameEndGubun = "GameIng" Then%>
            <a href="#" onclick="OnAnotherResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>')" class="<%=btncolor_anowin%>" data-toggle="modal" data-target=".etc-judge">경기중</a>
          <%Else%>
            <a href="#" onclick="OnAnotherResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>')" class="<%=btncolor_anowin%>" data-toggle="modal" data-target=".etc-judge">선택</a>
          <%End If%>
        </td>
        
      </tr>
      
<%

        
        LRs.MoveNext
    Loop
End If


IF CDBL(GameTourneyCnt) = 0 Then

%>
 <tr>
    <td colspan="14">조회 결과가 존재 하지 않습니다.</td>
  </tr>
<%
End if
%>
    </table>
<%
Set LRs = Nothing
DBClose()
'Response.Write  "LSQL" & LSQL & "<BR/>"  
%>