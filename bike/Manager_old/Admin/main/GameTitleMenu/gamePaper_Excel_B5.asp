<!-- #include file="../../dev/dist/config.asp"-->
<%

  Response.CharSet="utf-8"
  Session.codepage="65001"
  Response.codepage="65001"
  Response.ContentType="text/html;charset=utf-8"

  Dim GameTitleIDX	: GameTitleIDX 		= fInject(Request("GameTitleIDX"))
	Dim GameDay		    : GameDay 		    = fInject(Request("GameDay"))	
	Dim StadiumIDX		: StadiumIDX 		= fInject(Request("StadiumIDX"))
  Dim StadiumNum		: StadiumNumber 		= fInject(Request("StadiumNumber"))
	Dim SearchName	: SearchName		= fInject(Request("SearchName"))

  Dim DEC_GameTitleIDX	: DEC_GameTitleIDX 		= crypt.DecryptStringENC(GameTitleIDX)
	Dim DEC_GameDay		    : DEC_GameDay 		    = GameDay
	Dim DEC_StadiumIDX		: DEC_StadiumIDX 		= crypt.DecryptStringENC(StadiumIDX)
  Dim DEC_StadiumNumber	: DEC_StadiumNumber     = StadiumNumber
	Dim DEC_Searchkeyword	: DEC_Searchkeyword		= Searchkeyword
  Dim DEC_GroupGameGb : DEC_GroupGameGb = ""
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>배드민턴 경기기록지</title>
</head>
<body>

<%

  'CSQL = GetSQL(DEC_GameDay, DEC_GameTitleIDX, DEC_StadiumIDX,DEC_StadiumNumber, DEC_Searchkeyword,DEC_SearchKey)
  CSQL = " EXEC tblGameTourney_Searched_STR '" & DEC_GameTitleIDX & "', '" & DEC_GameDay & "', '" & DEC_StadiumIDX &"' ,'"  & DEC_StadiumNumber &"','" & "" & "','" & DEC_PlayType & "' ,'" & DEC_TempNum & "'  ,'" & DEC_Searchkey & "'  ,'"  & DEC_Searchkeyword & "','" & DEC_GroupGameGb & "'"
  'Response.Write "CSQL :" & CSQL & "<BR/>"
  const teamGroupGameGb = "B0030002"
  const personGroupGameGb = "B0030001"
  DIM continue : continue = true
  SET CRs = DBCon.Execute(CSQL)

  IF NOT (CRs.Eof Or CRs.Bof) Then
    arrayGamePaper = CRs.getrows()
    arrayGamePaperTempNum = arrayGamePaper
  End If
%>
  <table style="font-family: '맑은 고딕';">
    <colgroup>
      <col width="80px;">
      <col width="80px;">
      <col width="80px;">
      <col width="80px;">
      <col width="80px;">
    </colgroup>
    <tbody>

    <%
      If IsArray(arrayGamePaper) Then
        For ar = LBound(arrayGamePaper, 2) To UBound(arrayGamePaper, 2)
          GameTitleIDX = arrayGamePaper(0, ar) 
          GameLevelDtlIDX = arrayGamePaper(1, ar) 
          TeamGameNum = arrayGamePaper(2, ar) 
          GameNum = arrayGamePaper(3, ar) 
          TeamGb = arrayGamePaper(4, ar) 
          Level = arrayGamePaper(5, ar) 
          LTourneyGroupIDX = arrayGamePaper(6, ar) 
          RTourneyGroupIDX = arrayGamePaper(7, ar) 
          TeamGbNM = arrayGamePaper(8, ar) 
          LevelNM = arrayGamePaper(9, ar) 
          PlayTypeNM = arrayGamePaper(10, ar) 
          L_Result = arrayGamePaper(11, ar) 
          L_ResultType = arrayGamePaper(12, ar) 
          L_ResultNM = arrayGamePaper(13, ar) 
          L_Jumsu = arrayGamePaper(14, ar) 
          L_ResultDtl = arrayGamePaper(15, ar) 

          R_Result = arrayGamePaper(16, ar) 
          R_ResultType = arrayGamePaper(17, ar) 
          R_ResultNM = arrayGamePaper(18, ar) 
          R_Jumsu = arrayGamePaper(19, ar) 
          R_ResultDtl = arrayGamePaper(20, ar) 
          GameStatus = arrayGamePaper(21, ar) 
          ROUNDS = arrayGamePaper(22, ar) 
          Sex = arrayGamePaper(23, ar) 
          TempNum = arrayGamePaper(24, ar) 
          TurnNum = arrayGamePaper(25, ar) 
          GroupGameGb = arrayGamePaper(26, ar) 
          TourneyCnt = arrayGamePaper(27, ar) 
          LTeamDtl = arrayGamePaper(28, ar) 
          RTeamDtl = arrayGamePaper(29, ar) 
          LPlayer1 = arrayGamePaper(30, ar) 
          LPlayer2 = arrayGamePaper(31, ar) 
          Rplayer1 = arrayGamePaper(32, ar) 
          Rplayer2 = arrayGamePaper(33, ar) 

          LTeam1 = arrayGamePaper(34, ar) 
          LTeam2 = arrayGamePaper(35, ar) 
          RTeam1 = arrayGamePaper(36, ar) 
          RTeam2 = arrayGamePaper(37, ar) 

          StadiumNum = arrayGamePaper(38, ar) 
          StadiumIDX = arrayGamePaper(39, ar) 
          GameDay = arrayGamePaper(40, ar) 
          LevelJooNum = arrayGamePaper(41, ar) 
          LevelDtlJooNum = arrayGamePaper(42, ar) 
          LevelDtlName = arrayGamePaper(43, ar) 
          StadiumName = arrayGamePaper(44, ar) 
          PlayLevelType = arrayGamePaper(45, ar) 
          LevelJooName = arrayGamePaper(46, ar) 

          MaxRound = arrayGamePaper(47, ar) 
          GameType = arrayGamePaper(48, ar) 
          GameTypeNM = arrayGamePaper(49, ar)
          ResultGangSu = GetGangSu(GameType, MaxRound,ROUNDS) 

          FullGameYN = arrayGamePaper(56, ar)
    %>
      <tr style="height: 40pt;">
        <td colspan="3">
          <img style="width: 143px; height: 47px;" src="http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/logo/badminton.png" alt="대한배드민턴협회">
        </td>
        <td>
          <img style="width: 132px; height: 42px;" src="http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/logo/sd.png" alt="스포츠다이어리">
        </td>
      </tr>
      <tr style="height: 42pt;">
        <td style="font-size: 18pt; vertical-align: bottom;">No. <span style="font-weight: bold;font-size: 20pt;"><%=TempNum%></span></d>
        <td style="font-size: 14pt; vertical-align: bottom;">
          <span style="font-size: 14pt;font-weight: bold;"><%=StadiumNum%></span>코트
          <%
          IF GroupGameGb = teamGroupGameGb Then
              Response.Write TeamGameNum
          ELSE
              Response.Write GameNum
          End IF
          %>
          </span>경기
        
        </td>
        <td style="font-size: 14pt; vertical-align: bottom;" colspan="2">
        <%=Sex & PlayTypeNM & " " & TeamGbNM & " " & LevelNM & " " & LevelJooName & LevelJooNum & " "%>
        </td>
        <td style="font-size: 14pt; vertical-align: bottom;">

        <%
          If PlayLevelType = "B0100001" Then
            Response.Write "예선 " & LevelDtlJooNum & "조"
          ElseIf PlayLevelType = "B0100002" Then

            If GameType = "B0040001" AND FullGameYN = "Y" Then
              Response.Write "풀리그"
            Else
              Response.Write "본선"
            End If

            IF ResultGangSu <> "" AND Not ISNULL(ResultGangSu) Then
              Response.Write "-" & ResultGangSu
            End If            


          Else
            Response.Write "-"
          End If  
        %>      
        
        </td>
        <!--
        <td style="font-size: 14pt; vertical-align: bottom;">
       
        
        </td>
        -->
      </tr>
      <tr style="height: 45pt;">
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;">소 속</td>
        <% END IF%>
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;" colspan="2">이 름</td>
        <%ELSE%>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;" colspan="2">팀 명</td>
        <%End IF%>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;">점 수</td>
        <td style="vertical-align: middle;text-align: center;border-bottom: 1px solid #000;border-top: thin solid #000;border-left: thin solid #000;border-right: thin solid #000;font-size: 16pt;">서 명</td>
      </tr>
      <tr style="height: 65.099pt;">
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"><%=LTeam1%></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=LPlayer1%> / <%=LPlayer2%></td>
       <%ELSE%>

        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=LTeam1%>
        <%
        if LTeamDtl <> "0" and LTeamDtl <> "" Then
          Response.Write "-" & LTeamDtl
        End IF
        %>
        </td>

        <% END IF%>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"></td>
      </tr>
      <tr style="height: 65.099pt;">
        <% if GroupGameGb = personGroupGameGb Then %>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;"><%=RTeam1%></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=RPlayer1%> / <%=RPlayer2%></td>
        <%ELSE%>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000;" colspan="2"><%=RTeam1%>
        <%
        if RTeamDtl <> "0" and RTeamDtl <> "" Then
          Response.Write "-" & RTeamDtl
        End IF
        %>
        </td>
        <%END IF%>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000; width: 160px;"></td>
        <td style="vertical-align: middle;text-align: center; font-size: 20pt;border-bottom: thin solid #000;border-top: none;border-left: thin solid #000;border-right: thin solid #000; width: 160px"></td>
      </tr>
      <tr style="height: 44.1pt;">
        <td></td>
        <td colspan="3" style="font-weight: bold;font-size: 28pt;vertical-align: middle;text-align: center;"></td>
        <td></td>
      </tr>
      <%
        'arrayGamePaperTempNum = null

        'CSQLTempNum = GetSQLTempNum(DEC_GameDay, DEC_GameTitleIDX, DEC_StadiumIDX,DEC_StadiumNumber, DEC_Searchkeyword,DEC_SearchKey,TempNum)
        'CSQLTempNum = " EXEC tblGameTourney_Searched_STR '" & DEC_GameTitleIDX & "', '" & DEC_GameDay & "', '" & DEC_StadiumIDX &"' ,'"  & DEC_StadiumNumber &"','" & "" & "','" & DEC_PlayType & "' ,'" & TempNum & "'  ,'" & DEC_Searchkey & "'  ,'"  & DEC_Searchkeyword & "','" & DEC_GroupGameGb & "'"

        'SET CRsTempNum = DBCon.Execute(CSQLTempNum)
        'IF NOT (CRsTempNum.Eof and CRsTempNum.Bof) Then
        '  arrayGamePaperTempNum = CRsTempNum.getrows()
        'End If
        'CRsTempNum.close

        arrayTempNumCnt = 0

        If IsArray(arrayGamePaperTempNum) Then
          For ar_TempNum = LBound(arrayGamePaperTempNum, 2) To UBound(arrayGamePaperTempNum, 2) 
            continue = false
            'arrayTempNumCnt = arrayTempNumCnt + 1
            B_GameTitleIDX = arrayGamePaperTempNum(0, ar_TempNum) 
            B_GameLevelDtlIDX = arrayGamePaperTempNum(1, ar_TempNum) 
            B_TeamGameNum = arrayGamePaperTempNum(2, ar_TempNum) 
            B_GameNum = arrayGamePaperTempNum(3, ar_TempNum) 
            B_TeamGb = arrayGamePaperTempNum(4, ar_TempNum) 
            B_Level = arrayGamePaperTempNum(5, ar_TempNum) 
            B_LTourneyGroupIDX = arrayGamePaperTempNum(6, ar_TempNum) 
            B_RTourneyGroupIDX = arrayGamePaperTempNum(7, ar_TempNum) 
            B_TeamGbNM = arrayGamePaperTempNum(8, ar_TempNum) 
            B_LevelNM = arrayGamePaperTempNum(9, ar_TempNum) 
            B_GameTypeNM = arrayGamePaperTempNum(10, ar_TempNum) 
            B_LResult = arrayGamePaperTempNum(11, ar_TempNum) 
            B_LResultType = arrayGamePaperTempNum(12,ar_TempNum) 
            B_LResultNM = arrayGamePaperTempNum(13, ar_TempNum) 
            B_LJumsu = arrayGamePaperTempNum(14, ar_TempNum) 
            B_LResultDtl = arrayGamePaperTempNum(15, ar_TempNum) 

            B_RResult = arrayGamePaperTempNum(16, ar_TempNum) 
            B_RResultType = arrayGamePaperTempNum(17, ar_TempNum) 
            B_RResultNM = arrayGamePaperTempNum(18, ar_TempNum) 
            B_RJumsu = arrayGamePaperTempNum(19, ar_TempNum) 
            B_RResultDtl = arrayGamePaperTempNum(20, ar_TempNum) 
            B_GameStatus = arrayGamePaperTempNum(21, ar_TempNum) 
            B_ROUNDS = arrayGamePaperTempNum(22, ar_TempNum) 
            B_Sex = arrayGamePaperTempNum(23, ar_TempNum) 
            B_TempNum = arrayGamePaperTempNum(24, ar_TempNum) 
            B_TurnNum = arrayGamePaperTempNum(25, ar_TempNum) 
            B_GroupGameGb = arrayGamePaperTempNum(26, ar_TempNum) 
            B_TourneyCnt = arrayGamePaperTempNum(27, ar_TempNum) 
            B_LTeamDtl = arrayGamePaperTempNum(28, ar_TempNum) 
            B_RTeamDtl = arrayGamePaperTempNum(29, ar_TempNum) 
            B_LPlayer1 = arrayGamePaperTempNum(30, ar_TempNum) 
            B_LPlayer2 = arrayGamePaperTempNum(31, ar_TempNum) 
            B_Rplayer1 = arrayGamePaperTempNum(32, ar_TempNum) 
            B_Rplayer2 = arrayGamePaperTempNum(33, ar_TempNum) 

            B_LTeam1 = arrayGamePaperTempNum(34, ar_TempNum) 
            B_LTeam2 = arrayGamePaperTempNum(35, ar_TempNum) 
            B_RTeam1 = arrayGamePaperTempNum(36, ar_TempNum) 
            B_RTeam2 = arrayGamePaperTempNum(37, ar_TempNum) 

            B_StadiumNum = arrayGamePaperTempNum(38, ar_TempNum) 
            B_StadiumIDX = arrayGamePaperTempNum(39, ar_TempNum) 
            B_GameDay = arrayGamePaperTempNum(40, ar_TempNum) 
            B_LevelJooNum = arrayGamePaperTempNum(41, ar_TempNum) 
            B_LevelDtlJooNum = arrayGamePaperTempNum(42, ar_TempNum) 
            B_LevelDtlName = arrayGamePaperTempNum(43, ar_TempNum) 
            B_StadiumName = arrayGamePaperTempNum(44, ar_TempNum) 
            B_PlayLevelType = arrayGamePaperTempNum(45, ar_TempNum) 
            B_LevelJooName = arrayGamePaperTempNum(46, ar_TempNum)  

            B_MaxRound = arrayGamePaperTempNum(47, ar_TempNum) 
            B_GameType = arrayGamePaperTempNum(48, ar_TempNum) 
            B_GameTypeNM = arrayGamePaperTempNum(49, ar_TempNum) 
            B_ResultGangSu = GetGangSu(B_GameType, B_MaxRound,B_ROUNDS)

            IF B_LTeamDtl = "0" Then  
              B_LTeamDtl = ""
            End IF 

            IF B_RTeamDtl = "0" Then  
              B_RTeamDtl = ""
            End IF 

            TempNum1 = cdbl(TempNum) + 1
            TempNum2 = cdbl(TempNum1) + 1

            If CDBL(B_TempNum) < CDBL(TempNum1) Then 
              continue = false
            Else  
              arrayTempNumCnt = arrayTempNumCnt + 1
              continue = true
            End IF

            IF CDBL(TempNum2) < CDBL(B_TempNum) Then  
                'Response.Write "Exit For : "  & "<br/>"
              Exit For
            END IF

            IF (continue = true) Then  
              if cdbl(arrayTempNumCnt) = 1 Then
                Response.Write " <tr style='height: 30pt;'>"
                if B_GroupGameGb = teamGroupGameGb Then 
                  Response.Write "<td colspan='5' style='font-size: 14pt; vertical-align: middle; text-align: center;'>다음경기 "
                  If B_PlayLevelType = "B0100001" Then
                    Response.Write "예선 " & B_LevelDtlJooNum & "조"
                  ElseIf B_PlayLevelType = "B0100002" Then
                    IF B_ResultGangSu = "" Then
                      Response.Write " 본선" 
                    Else
                      Response.Write " 본선" & "-" & B_ResultGangSu
                    ENd IF
                  Else
                    Response.Write "-"
                  End If  
                  Response.Write "(" & B_LTeam1 & " " & B_LTeamDtl &  " / " & B_RTeam1 & " " & B_RTeamDtl &   ")  ▷ " & B_StadiumNum & "코트 " & B_TeamGameNum & " 경기 예정</td>"
                else
                  Response.Write "<td colspan='5' style='font-size: 14pt; vertical-align: middle; text-align: center;'>다음경기 "
                  If B_PlayLevelType = "B0100001" Then
                    Response.Write "예선 " & B_LevelDtlJooNum & "조"
                  ElseIf B_PlayLevelType = "B0100002" Then
                    IF B_ResultGangSu = "" Then
                      Response.Write " 본선" 
                    Else
                      Response.Write " 본선" & "-" & B_ResultGangSu
                    ENd IF
                  Else
                    Response.Write "-"
                  End If  
                  Response.Write  "(" & B_RPlayer1 & " / " & B_RPlayer2 & ")  ▷ " & B_StadiumNum & "코트 " & B_GameNum & " 경기 예정</td>"
                End IF
                Response.Write "</tr>"
              End IF

            
              if cdbl(arrayTempNumCnt) = 2 Then
                Response.Write " <tr style='height: 30pt;'>"
                if B_GroupGameGb = teamGroupGameGb Then 
                  Response.Write "<td colspan='5' style='font-size: 14pt; vertical-align: middle; text-align: center;'>다음경기 "
                  If B_PlayLevelType = "B0100001" Then
                    Response.Write "예선 " & B_LevelDtlJooNum & "조"
                  ElseIf B_PlayLevelType = "B0100002" Then
                    IF B_ResultGangSu = "" Then
                      Response.Write " 본선" 
                    Else
                      Response.Write " 본선" & "-" & B_ResultGangSu
                    ENd IF
                  Else
                    Response.Write "-"
                  End If  
                  Response.Write "(" & B_LTeam1 & " " & B_LTeamDtl &  " / " & B_RTeam1 & " " & B_RTeamDtl &   ")  ▷ " & B_StadiumNum & "코트 " & B_TeamGameNum & " 경기 예정</td>"
                else
                  Response.Write "<td colspan='5' style='font-size: 14pt; vertical-align: middle; text-align: center;'>다음경기 "
                  If B_PlayLevelType = "B0100001" Then
                    Response.Write "예선 " & B_LevelDtlJooNum & "조"
                  ElseIf B_PlayLevelType = "B0100002" Then
                  IF B_ResultGangSu = "" Then
                      Response.Write " 본선" 
                    Else
                      Response.Write " 본선" & "-" & B_ResultGangSu
                    ENd IF
                  Else
                    Response.Write "-"
                  End If  
                  Response.Write "(" & B_RPlayer1 & " / " & B_RPlayer2 & ")  ▷ " & B_StadiumNum & "코트 " & B_GameNum & " 경기 예정</td>"
                End IF
                Response.Write "</tr>"
              End IF
            End IF
          NEXT
        END IF

        if(cdbl(arrayTempNumCnt) < 2 ) Then
          For i = arrayTempNumCnt To 1
            Response.Write " <tr style='height: 30pt;'>"
            Response.Write "<td colspan='5' style='font-size: 18pt; vertical-align: middle; text-align: center;'></td>"
            Response.Write "</tr>"
          Next
        End if
      %>

      <!--
      <tr style="height: 30pt;">
        <td colspan="5" style="font-size: 18pt; vertical-align: middle; text-align: center;">다음경기 (이은수 / 이미경) -> 12:30 ▷ 17코트 3경기 예정 (53)</td>
      </tr>
      <tr style="height: 30pt;">
        <td colspan="5" style="font-size: 18pt; vertical-align: middle; text-align: center;">다음경기 (이동욱 / 김연옥) -> 12:30 ▷ 16코트 3경기 예정 (52)</td>
      </tr>

      -->

      <%
          Next
        End If          
      %>  
   
    </tbody>
  </table>
</body>
</html>


<%
  DBClose()
%>


<%


  Response.Buffer = True
  Response.ContentType = "application/vnd.ms-excel"
  Response.CacheControl = "public"
  Response.AddHeader "Content-disposition","attachment;filename=score.xls"
%>

