<!-- #include virtual="/bmlive/config.asp"-->
<!-- #include virtual="/bmlive/JSON_2.0.4.asp" -->
<!-- #include virtual="/bmlive/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/bmlive/json2.asp" -->
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
'REQ = "{""CMD"":4,""tGameTitleIDX"":""5BE7B297A6F7069EC9375F25E036E46B"",""tGameDay"":"""",""tStadiumIDX"":"""",""tStadiumNumber"":"""",""tSearchName"":"""",""tPlayLevelType"":"""",""tGroupGameGB"":""""}"
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
'response.write DEC_GameTitleIDX
If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(oJSONoutput.tGameDay)
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

If hasown(oJSONoutput, "tIngType") = "ok" then
    If ISNull(oJSONoutput.tIngType) Or oJSONoutput.tIngType = "" Then
      IngType = ""
      DEC_IngType = ""
    Else
      IngType = fInject(oJSONoutput.tIngType)
      DEC_IngType = fInject(oJSONoutput.tIngType)
    End If
End if

If hasown(oJSONoutput, "tSearchName") = "ok" then
    If ISNull(oJSONoutput.tSearchName) Or oJSONoutput.tSearchName = "" Then
      Searchkeyword = ""
      DEC_Searchkeyword = ""
    Else
      Searchkeyword = fInject(oJSONoutput.tSearchName)
      DEC_Searchkeyword = fInject(oJSONoutput.tSearchName)
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


If hasown(oJSONoutput, "tGameURLYN") = "ok" then
  If ISNull(oJSONoutput.tGameURLYN) Or oJSONoutput.tGameURLYN = "" Then
    GameURLYN = ""
    DEC_GameURLYN = ""
  Else
    GameURLYN = fInject(oJSONoutput.tGameURLYN)
    DEC_GameURLYN = fInject(oJSONoutput.tGameURLYN)
  End If
Else
  GameURLYN = ""
  DEC_GameURLYN = ""
End if




DEC_TempNum = ""
'DEC_Searchkeyword =""
'DEC_Searchkey = ""


LSQL = " SELECT EnterType "
LSQL = LSQL & " FROM tblGameTitle WITH(NOLOCK)"
LSQL = LSQL & " WHERE GameTitleIDX = '" & DEC_GameTitleIDX & "' "
LSQL = LSQL & " AND DelYN = 'N'"
Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
  EnterType = LRs("EnterType")
End If
LRs.Close

teamOrder_arr = null
if EnterType = "E" Then
  ORDERSQL = "SELECT "
  ORDERSQL = ORDERSQL & "a.GamelevelDtlIDX, "
  ORDERSQL = ORDERSQL & "MIN(ORDERBY) AS ORDERBY, Team, b.LevelJooNum_SubNM "
  ORDERSQL = ORDERSQL & "FROM tblTourneyTeam a "
  ORDERSQL = ORDERSQL & "inner join tblGameLevelDtl b on a.GameLevelDtlidx = b.GameLevelDtlidx and b.DelYN = 'N' "
  ORDERSQL = ORDERSQL & "inner join tblGameLevel c on b.GameLevelidx = c.GameLevelidx and c.DelYN = 'N' "
  ORDERSQL = ORDERSQL & "WHERE a.DelYN = 'N' "
  ORDERSQL = ORDERSQL & "AND c.GameTitleIDX = '"& DEC_GameTitleIDX &"' and GroupGameGb = 'B0030002' "
  ORDERSQL = ORDERSQL & "GROUP BY a.GamelevelDtlIDX, Team, TeamDtl, b.LevelJooNum_SubNM "
  ORDERSQL = ORDERSQL & "ORDER BY a.GameLevelDtlidx,ORDERBY"

  set ORDERRs = Dbcon.Execute(ORDERSQL)

  if not (ORDERRs.Eof Or ORDERRs.Bof) Then
    teamOrder_arr = ORDERRs.getrows()
  end if

  ORDERRs.Close

  ORDERSQL = "SELECT GameLevelDtlIDX, TeamGameNum, GameNum, TempNum"
	ORDERSQL = ORDERSQL & " FROM "
	ORDERSQL = ORDERSQL & " ("
	ORDERSQL = ORDERSQL & " 	SELECT ROW_NUMBER() OVER(PARTITION BY GameLevelDtlIDX ORDER BY CONVERT(INT,TeamGameNum), CONVERT(INT,GameNum) ASC) TempNum, GameLeveldtlIDX, TEamgameNum, GameNum, ByeYN"
	ORDERSQL = ORDERSQL & " 	FROM"
	ORDERSQL = ORDERSQL & " 	("
	ORDERSQL = ORDERSQL & " 	select GameLeveldtlIDX, TEamgameNum, GameNum, CASE WHEN L_ByeYN = 'Y' OR R_ByeYN = 'Y' THEN 'Y' ELSE 'N' END AS ByeYN"
	ORDERSQL = ORDERSQL & " 	from tblgameOperate WHERE GameTitleIDX = '" & DEC_GameTitleIDX & "' AND DelYN = 'N'"
	ORDERSQL = ORDERSQL & " 	AND ((GroupGameGB = 'B0030002' AND GameNum = '0') OR (GroupGameGB = 'B0030001' AND TeamGameNum = '0'))"
	ORDERSQL = ORDERSQL & " 	) AS A"
	ORDERSQL = ORDERSQL & " 	WHERE ByeYN = 'N'"
	ORDERSQL = ORDERSQL & " ) AS BB"

  set ORDERRs = Dbcon.Execute(ORDERSQL)

  if not (ORDERRs.Eof Or ORDERRs.Bof) Then
    ByeCnt_arr = ORDERRs.getrows()
  end if

  ORDERRs.Close
  set ORDERRs = nothing

end if

'--대회,일자별 총경기수
LSQL =" SELECT COUNT(*) AS TotalGameCnt"
LSQL = LSQL & " FROM tblGameOperate WITH(NOLOCK)"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND ((GroupGameGb = 'B0030001' AND TeamGameNum = '0') OR (GroupGameGb = 'B0030002' AND GameNum = '0'))"
LSQL = LSQL & " AND L_ByeYN = 'N' AND R_ByeYN = 'N'"
LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"

If DEC_GameDay <> "" Then
  LSQL = LSQL & " AND GameDay = '" & DEC_GameDay & "'"
ENd If

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

  TotalGameCnt = LRs("TotalGameCnt")
  Call oJSONoutput.Set("TotalGameCnt", FormatNumber(TotalGameCnt,0))
End If

LRs.Close

'--대회,일자별 잔여경기수
LSQL = " SELECT COUNT(*) AS RestGameCnt"
LSQL = LSQL & " FROM tblGameOperate WITH(NOLOCK)"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND ((GroupGameGb = 'B0030001' AND TeamGameNum = '0') OR (GroupGameGb = 'B0030002' AND GameNum = '0'))"
LSQL = LSQL & " AND L_ByeYN = 'N' AND R_ByeYN = 'N'"
LSQL = LSQL & " AND GameStatus <> 'GameEnd'"
LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "' "

If DEC_GameDay <> "" Then
  LSQL = LSQL & " AND GameDay = '" & DEC_GameDay & "'"
ENd If

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

  RestGameCnt = LRs("RestGameCnt")
  Call oJSONoutput.Set("RestGameCnt", FormatNumber(RestGameCnt,0))
End If

LRs.Close



strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


'LSQL = " EXEC tblGameTourney_Searched_STR '" & DEC_GameTitleIDX & "', '" & GameDay & "', '" & DEC_StadiumIDX &"' ,'"  & StadiumNumber &"','" & "GameEmpty" & "','" & PlayLevelType & "' ,'" & DEC_TempNum & "'  ,'" & DEC_Searchkey & "'  ,'"  & DEC_Searchkeyword & "','" & DEC_GroupGameGb & "'"


LSQL = " SELECT GameOperateIDX, GameTitleIDX, GameLevelidx, GameLevelDtlIDX, TeamGameNum, "
LSQL = LSQL & " GameNum, Round, RoundName, NowRoundName, L_TourneyGroupIDX, "
LSQL = LSQL & " R_TourneyGroupIDX, L_MemberIDXs, R_MemberIDXs, L_MemberNames, R_MemberNames, "
LSQL = LSQL & " L_Teams, R_Teams, L_TeamDtl, R_TeamDtl, L_TeamNames, "
LSQL = LSQL & " R_TeamNames, L_Sidos, R_Sidos, L_SidoNames, R_SidoNames, "
LSQL = LSQL & " L_ByeYN, R_ByeYN, L_SetJumsu, R_SetJumsu, L_MatchJumsu, "
LSQL = LSQL & " R_MatchJumsu, "
LSQL = LSQL & " L_Result, L_ResultDtl, dbo.FN_NameSch(L_Result, 'PubType') AS L_ResultType, dbo.FN_NameSch(L_Result, 'PubCode') AS L_ResultNM,"
LSQL = LSQL & " R_Result, R_ResultDtl, dbo.FN_NameSch(R_Result, 'PubType') AS R_ResultType, dbo.FN_NameSch(R_Result, 'PubCode') AS R_ResultNM,"
LSQL = LSQL & " GameStatus, "
LSQL = LSQL & " dbo.FN_NameSch(TeamGb,'TeamGb') AS TeamGbNM, TeamGb,"
LSQL = LSQL & " dbo.FN_NameSch(Level,'Level') AS LevelNM, Level,"
LSQL = LSQL & " dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeNM, "
LSQL = LSQL & " PlayType, "
LSQL = LSQL & " dbo.FN_NameSch(PlayLevelType,'PubCode') AS PlayLevelTypeNM, PlayLevelType, "
LSQL = LSQL & " dbo.FN_NameSch(Sex,'PubCode') AS Sex,"
LSQL = LSQL & " Sex AS SexCode,"
LSQL = LSQL & " dbo.FN_NameSch(LevelJooName,'Pubcode') AS LevelJooName,"
LSQL = LSQL & " LevelJooName AS LevelJooName_Code,"
LSQL = LSQL & " LevelJooNum, LevelDtlJooNum, GroupGameGb, FullGameYN,"
LSQL = LSQL & " StadiumIDX, StadiumNum, StadiumNum_Text, TurnNum, "
LSQL = LSQL & " TempNum, GameDay, GameTime, CheifIDX, CheifSubIDX, DelYN, GameType, PrintYN,"
LSQL = LSQL & " CASE WHEN GroupGameGb = 'B0030002' Then"
LSQL = LSQL & " 	("
LSQL = LSQL & " 	SELECT count(*) "
LSQL = LSQL & " 	From tblTourney FF WITH(NOLOCK)"
LSQL = LSQL & " 	Where FF.GameLevelDtlidx = A.GameLevelDtlidx AND FF.TeamGameNum = A.TeamGameNum AND FF.DelYN ='N' AND FF.GameTitleIDX = '" & DEC_GameTitleIDX & "'	"
LSQL = LSQL & " 	)"
LSQL = LSQL & " 	ELSE 0 END AS TourneyCnt, "
'진주시대회만 잠깐 빼놓음
'LSQL = LSQL & " CASE WHEN PlayLevelType = 'B0100002' AND (GroupGameGb ='B0030001' OR GroupGameGb ='B0030002') THEN dbo.FN_BeforeFinalCheck(GameLevelDtlIDX) ELSE '' END AS BeforeFinalStatus"
LSQL = LSQL & "  '' AS BeforeFinalStatus, "
LSQL = LSQL & " L_GugunNames, R_GugunNames, JooNum_SubNm, MovieURL, Board_StadiumNum, YoutubeURL"
LSQL = LSQL & " FROM tblGameOperate A WITH(NOLOCK)"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"

If GameDay <> "" Then
  LSQL = LSQL & " AND GameDay = '" & GameDay & "'"
End If

If DEC_StadiumIDX <> "" Then
  LSQL = LSQL & " AND StadiumIDX = '" & DEC_StadiumIDX & "'"
End If

If StadiumNumber <> "" Then
  LSQL = LSQL & " AND Board_StadiumNum = '" & StadiumNumber & "'"
End If

If DEC_GroupGameGb <> "" Then
  LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
End If

IF PlayLevelType <> "" Then
  LSQL = LSQL & " AND PlayLevelType = '" & PlayLevelType & "'"
End If

If DEC_IngType <> "" Then
  LSQL = LSQL & " AND GameStatus = '" & DEC_IngType & "'"
End If

If DEC_GameURLYN = "Y" Then
  LSQL = LSQL & " AND ISNULL(MovieURL,'') <> ''"
ElseIf DEC_GameURLYN = "N" Then
  LSQL = LSQL & " AND ISNULL(MovieURL,'') = ''"
End If


If DEC_Searchkeyword <> "" Then
  LSQL = LSQL & " AND ("
  LSQL = LSQL & "   L_MemberNames LIKE '%" & DEC_Searchkeyword & "%' OR"
  LSQL = LSQL & "   R_MemberNames LIKE '%" & DEC_Searchkeyword & "%' OR"
  LSQL = LSQL & "   L_TeamNames LIKE '%" & DEC_Searchkeyword & "%' OR"
  LSQL = LSQL & "   R_TeamNames LIKE '%" & DEC_Searchkeyword & "%'"
  LSQL = LSQL & "   )"
End If


LSQL = LSQL & " AND ((GroupGameGB = 'B0030002' AND GameNum = '0') OR (GroupGameGB = 'B0030001' AND TeamGameNum = '0'))"
'LSQL = LSQL & " AND GameStatus <> 'GameEnd'"
LSQL = LSQL & " AND L_BYEYN = 'N' AND R_BYEYN = 'N'"

LSQL = LSQL & " order by YoutubeURL asc, gamestatus asc ,CONVERT(BIGINT,ISNULL(TurnNum,0)), CONVERT(BIGINT,ISNULL(StadiumNum,0)), CONVERT(BIGINT,TeamGameNum), CONVERT(BIGINT,GameNum)"

'LSQL = LSQL & " ORDER BY CONVERT(BIGINT,ISNULL(TurnNum,0)), CONVERT(BIGINT,ISNULL(StadiumNum,0)), CONVERT(BIGINT,TeamGameNum), CONVERT(BIGINT,GameNum)"

Set LRs = Dbcon.Execute(LSQL)
GameTourneyCnt = 0
'response.write lsql
'response.end
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
    A_L_TeamDtl = LRs("L_TeamDtl")
    A_R_TeamDtl = LRs("R_TeamDtl")
    A_GroupGameGb = LRs("GroupGameGb")
    A_TempNum = LRs("TempNum")
    A_StadiumNum = LRs("StadiumNum")
    A_R_ResultType = LRs("R_ResultType")
    A_StadiumNum_Text = LRs("StadiumNum_Text")
    A_GameLeveldtlIDX = LRs("GameLeveldtlIDX")
    A_TeamGameNum = LRs("TeamGameNum")
    A_GameNum = LRs("GameNum")

    A_GameType= LRs("GameType")

    A_Round = LRs("Round")

    BeforeFinalStatus = LRs("BeforeFinalStatus")

    A_GameOperateIDX = LRs("GameOperateIDX")

    A_JooNum_SubNm = LRs("JooNum_SubNm")

    A_Board_StadiumNum = LRs("Board_StadiumNum")

    If LRs("PlayLevelType") = "B0100002" Then

      '대진성립되는경기는 붉은색 본선출력표시함.
      If (LRs("L_TeamNames") <> "" AND NOT ISNULL(LRs("L_TeamNames"))) AND (LRs("R_TeamNames") <> "" AND NOT ISNULL(LRs("R_TeamNames"))) Then
        BeforeFinalStatus = "GAMEEND"
      Else
      End If

      '풀리그본선경기는 파란색 본선출력표시 함.
      If A_GameType = "B0040001" AND LRs("FullGameYN") = "Y" Then
        BeforeFinalStatus = ""
      End If
    Else
    End If
%>
<% if  LRs("PlayLevelType")  <>  "B0100001" Then %>
<tr class="final">
  <!-- <tr style="box-shadow: inset 0px 0px 2px 2px #81bef7;">   -->

<% else %>
	<tr>
<% end if %>
        <td><input type="checkbox" name="chk_Operate" data-id="<%=i%>" value="<%=A_GameOperateIDX%>"></td>
        <td>
          <span>
          <%
            If A_StadiumNum_Text = "" Or IsNULL(A_StadiumNum_Text) Then
              If A_StadiumNum = "" Or IsNull(A_StadiumNum) Then
                Response.Write "-" & "코트"
              Else
                Response.Write A_StadiumNum & "코트"
              End If
            Else
              If A_StadiumNum = "" Or IsNull(A_StadiumNum) Then
                Response.Write "-" & "코트<br>" & "(" & A_StadiumNum_Text & ")"
              Else
                Response.Write A_StadiumNum & "코트<br>"  & "(" & A_StadiumNum_Text & ")"
              End If
            End If
          %>
          </span>
        </td>
        <td><font color="red"><%=A_Board_StadiumNum%>코트</font></td>
        <td>
          <span><%=LRs("TempNum")%></span>
        </td>
        <td>
        <%
          If LRs("GameTime") <> "" AND Not IsNull(LRs("GameTime")) Then
            Response.Write LRs("GameTime")
          Else
            Response.Write "--:--"
          End IF
        %>
        </td>

        <td>

          <%If GameEndGubun = "GameIng" Then%>
            <%If LRs("GroupGameGb") = "B0030002" Then%>
              <a href="#" onclick="OnGroupResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>')" class="red_btn" data-toggle="modal" data-target=".group_modal">경기중</a>
            <%End If%>
          <%Else%>
            <%If LRs("GroupGameGb") = "B0030002" Then%>
              <a href="#" onclick="OnGroupResultBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>')" class="<%=btncolor_win%>" data-toggle="modal" data-target=".group_modal">선택</a>
            <%End If%>
          <%End If%>
          <!--<%=LRs("GameLevelDtlIDX")%>,<%=LRs("TeamGameNum")%>,<%=LRs("GameNum")%>-->
        </td>

<!--  190102 SS  출력 단체전 오더등록 컬럼  승패결과 쪽으로 이동 요청 건 -->
        <%
          If LRs("PlayLevelType") = "B0100001" Then

            PrintBtnColor = "orange_btn"

          Else

            If BeforeFinalStatus = "GAMEEND" OR BeforeFinalStatus = "LOTTEND" Then
              PrintBtnColor = "red_btn"
            Else
              PrintBtnColor = "blue_btn"
            End If

          End If
        %>



        <td>
          <%



            ''본선 첫게임일때 예선전 끝났는지 체크
            'If LRs("PlayLevelType") = "B0100002" Then
            '  '
            '  'If (LRs("GroupGameGb") = "B0030001" AND (LRs("GameNum") = "1" OR LRs("GameNum") = "2")) OR (LRs("GroupGameGb") = "B0030002" AND (LRs("TeamGameNum") = "1" OR LRs("TeamGameNum") = "2") ) Then
''
            '  '    CSQL = "SELECT dbo.FN_BeforeFinalCheck('" & LRs("GameLevelDtlIDX") & "') AS BeforeFinalStatus"
''
            '  '    Set CRs = Dbcon.Execute(CSQL)
''
            '  '    If Not (CRs.Eof Or CRs.Bof) Then
            '  '      BeforeFinalStatus = CRs("BeforeFinalStatus")
            '  '    Else
            '  '      BeforeFinalStatus = ""
            '  '    End If
''
            '  '    CRs.close
''
            '  'End If
'
            '  If (LRs("GroupGameGb") = "B0030001" ) OR (LRs("GroupGameGb") = "B0030002"  ) Then
'
            '     CSQL = "SELECT dbo.FN_BeforeFinalCheck('" & LRs("GameLevelDtlIDX") & "') AS BeforeFinalStatus"
'
            '     Set CRs = Dbcon.Execute(CSQL)
'
            '     If Not (CRs.Eof Or CRs.Bof) Then
            '       BeforeFinalStatus = CRs("BeforeFinalStatus")
            '     Else
            '       BeforeFinalStatus = ""
            '     End If
'
            '     CRs.close
'
            '  End If
'
            'End If
          %>

          <%If BeforeFinalStatus = "LOTTEND" Then%>

              <span style="color:red; font-weight:bold;" onclick="javascript:popupListOpen('ranking_result_popup.asp','<%=GameTitleIDX%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>','<%=crypt.EncryptStringENC(LRs("TeamGb"))%>','<%=crypt.EncryptStringENC(LRs("SexCode"))%>|<%=crypt.EncryptStringENC(LRs("PlayType"))%>','<%=crypt.EncryptStringENC(LRs("Level"))%>|<%=crypt.EncryptStringENC(LRs("LevelJooName_Code"))%>|<%=LRs("LevelJooNum")%>');">
                <%=LRs("Sex") & LRs("PlayTypeNM") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooName") & LRs("LevelJooNum") %>
                <%
                  If A_JooNum_SubNm <> "" Then
                    Response.Write "(" & A_JooNum_SubNm & ")"
                  End If
                %>
              </span>


          <%Else%>

              <span onclick="javascript:popupTourneyOpen('operateNew.asp','<%=GameTitleIDX%>','<%=crypt.EncryptStringENC(LRs("GroupGameGb"))%>','<%=crypt.EncryptStringENC(LRs("TeamGb"))%>','<%=crypt.EncryptStringENC(LRs("SexCode"))%>|<%=crypt.EncryptStringENC(LRs("PlayType"))%>','<%=crypt.EncryptStringENC(LRs("Level"))%>|<%=crypt.EncryptStringENC(LRs("LevelJooName_Code"))%>|<%=LRs("LevelJooNum")%>','<%=crypt.EncryptStringENC(LRs("GameLevelIDX"))%>');">
                <%=LRs("Sex") & LRs("PlayTypeNM") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooName") & LRs("LevelJooNum") %>
                <%
                  If A_JooNum_SubNm <> "" Then
                    Response.Write "(" & A_JooNum_SubNm & ")"
                  End If
                %>
              </span>


          <%End If%>
        </td>
        <td>
          <span>
          <%
          if EnterType = "E" AND IsArray(teamOrder_arr) AND LRs("GameType") = "B0040001" then
            gamenumtitle = left(LRs("Sex"),1) & left(LRs("TeamGbNM"),1)
            count = 0
            for k = Lbound(teamOrder_arr,2) to Ubound(teamOrder_arr,2)
              if cint(LRs("GameLevelDtlIDX")) = cint(teamOrder_arr(0,k)) Then
                count = count + 1
              end if
              if cint(LRs("GameLevelDtlIDX")) = cint(teamOrder_arr(0,k)) and teamOrder_arr(2,k) = LRs("L_Teams") then
                if teamOrder_arr(3,k) <> "" then
                  gamenumtitle = gamenumtitle & teamOrder_arr(3,k) &"-"& count & ":"
                ELSE
                  gamenumtitle = gamenumtitle & LRs("LevelDtlJooNum") &"-"& count & ":"
                end if
              end if
              if cint(LRs("GameLevelDtlIDX")) = cint(teamOrder_arr(0,k)) and teamOrder_arr(2,k) = LRs("R_Teams") then
                gamenumtitle = gamenumtitle & count
              end if
            next
            response.write gamenumtitle
          elseif EnterType = "E" AND IsArray(teamOrder_arr) AND LRs("GameType") = "B0040002" Then
            Response.Write "<font style='font-size:12px;'>["
            If LRs("PlayLevelType") = "B0100001" Then
                Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
            ElseIf LRs("PlayLevelType") = "B0100002" Then

              If A_GameType = "B0040001" AND LRs("FullGameYN") = "Y" Then
                Response.Write "풀리그"
              Else
                Response.Write "본선"
              End If

              IF LRs("NowRoundName") = "2강" Then
                Response.Write "-" & "결승"
              ElseIf LRs("NowRoundName") = "4강" Then
                Response.Write "-" & "준결승"
              Else
                Response.Write "-" & LRs("NowRoundName")
              ENd iF
            Else
                Response.Write "-"
            End If

            If LRs("GroupGameGb") = "B0030001" Then
              Response.Write " " & LRs("GameNum") & "경기"
            Else
              Response.Write " " & LRs("TeamGameNum") & "경기"
            End If

            Response.Write "]</font>"


            Response.Write "<font color='red'>"

            If LRs("Sex") = "혼합" Then

              Response.Write " " & LEFT(LRs("TeamGbNM"),1) & LEFT(LRs("Sex"),1) & LEFT(LRs("PlayTypeNM"),1) & " "

            Else

              Response.Write " " & LEFT(LRs("Sex"),1) & LEFT(LRs("TeamGbNM"),1) & LEFT(LRs("PlayTypeNM"),1) & " "

            End If

            If IsArray(ByeCnt_arr) Then

              str_BYECnt = ""


              For k = 0 To UBound(ByeCnt_arr,2)
                If Cstr(ByeCnt_arr(0,k)) = Cstr(A_GameLeveldtlIDX) AND Cstr(ByeCnt_arr(1,k)) = Cstr(A_TeamGameNum) AND Cstr(ByeCnt_arr(2,k)) = Cstr(A_GameNum) then
                  If str_BYECnt = "" Then
                    str_BYECnt = ByeCnt_arr(3,k)
                  End If
                End If
              Next

              If str_BYECnt = "" Then
                str_BYECnt = 0
              End If

            End If

            Response.Write str_BYECnt

            Response.Write "</font>"

          else
            If LRs("PlayLevelType") = "B0100001" Then
                Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
            ElseIf LRs("PlayLevelType") = "B0100002" Then
              If A_GameType = "B0040001" AND LRs("FullGameYN") = "Y" Then
                Response.Write "풀리그"
              Else
                Response.Write "본선"
              End If

              IF LRs("NowRoundName") = "2강" Then
                Response.Write "-" & "결승"
              ElseIf LRs("NowRoundName") = "4강" Then
                Response.Write "-" & "준결승"
              Else
                Response.Write "-" & LRs("NowRoundName")
              ENd iF


            Else
                Response.Write "-"
            End If

            If LRs("GroupGameGb") = "B0030001" Then
              Response.Write " " & LRs("GameNum") & "경기"
            Else
              Response.Write " " & LRs("TeamGameNum") & "경기"
            End If
          end if
          %>
          </span>
        </td>
        <%
			 'LSQL="select  c.sidonm from tblteaminfo as a  left join [tblTeamInfoHistory] as b on a.TEAMnm=b.TEAMnm"
			 'LSQL= LSQL & " left join  tblsidoinfo AS C   on B.sido=C.sido where a.TEAMnm='"&LRs("LTeam1")&"'"
             'LSQL = LSQL & "  and a.delyn='N' and  b.delyn='N' and c.delyn='N'"
			 'Set LRss = Dbcon.Execute(LSQL)
			'If Not (LRss.Eof Or LRss.Bof) Then
			'sidonm = LRss("sidonm")
			'End If

		%>
          <td class="team" >
            <%
              str_LTeamNM = ""

              If LRs("L_TeamNames") <> "" AND NOT ISNULL(LRs("L_TeamNames")) Then
                str_LTeamNM = REPLACE(LRs("L_TeamNames"),"|","/")
              End If

              IF A_L_TeamDtl <> "0" Then
                str_LTeamNM = str_LTeamNM & "-" & A_L_TeamDtl
              End IF

              If EnterType = "A" AND str_LTeamNM <> "" Then


                If LRs("L_GugunNames") <> "" AND NOT ISNULL(LRs("L_GugunNames")) Then
                  str_LGugunNames = "<br>(" & REPLACE(LRs("L_GugunNames"),"|","/") & ")"
                End If

                str_LTeamNM = str_LTeamNM & str_LGugunNames

              End If
            %>

          <span class="cut-el" title="<%=str_LTeamNM%>">
            <%=str_LTeamNM%>
          </span>
        </td>
        <td>
          <span>
          <%
            If LRs("L_MemberNames") <> "" AND NOT ISNULL(LRs("L_MemberNames")) Then
              Response.Write REPLACE(LRs("L_MemberNames"),"|","/")
            End If
          %>
          </span>

          <%If LRs("L_ByeYN") = "Y" Then%>
            <font color="orange">BYE</font>
          <%End If%>
        </td>
        <td>
          <span  <% IF LRs("L_ResultType") = "WIN" Then Response.Write "style='color:blue;font-size:14px;font-weight: bold;'" End IF %>>
          <%=LRs("L_ResultType")%> </span>

        </td>
        <%
		    '190104 SEH 최승규과장님 프로시저작업후 재작업 예정
			' LSQL="select  c.sidonm from tblteaminfo as a  left join [tblTeamInfoHistory] as b on a.TEAMnm=b.TEAMnm"
			 'LSQL= LSQL & " left join  tblsidoinfo AS C   on B.sido=C.sido where a.TEAMnm='"&LRs("LTeam1")&"'"
             'LSQL = LSQL & "  and a.delyn='N' and  b.delyn='N' and c.delyn='N'"
			 'Set LRss = Dbcon.Execute(LSQL)
			'If Not (LRss.Eof Or LRss.Bof) Then
			'sidonm = LRss("sidonm")
			'End If
		%>
        <td class="team">
          <%
            str_RTeamNM = ""

            If LRs("R_TeamNames") <> "" AND NOT ISNULL(LRs("R_TeamNames")) Then
              str_RTeamNM = REPLACE(LRs("R_TeamNames"),"|","/")
            End If

            IF A_R_TeamDtl <> "0" Then
              str_RTeamNM = str_RTeamNM & "-" & A_R_TeamDtl
            End IF

            If EnterType = "A" AND str_RTeamNM <> "" Then


              If LRs("R_GugunNames") <> "" AND NOT ISNULL(LRs("R_GugunNames")) Then
                str_RGugunNames = "<br>(" & REPLACE(LRs("R_GugunNames"),"|","/") & ")"
              End If

              str_RTeamNM = str_RTeamNM & str_RGugunNames



            End If
          %>
          <span class="cut-el" title="<%=str_RTeamNM%>">
            <%=str_RTeamNM%>
          </span>
        </td>
        <td>
          <span>
          <%
            If LRs("R_MemberNames") <> "" AND NOT ISNULL(LRs("R_MemberNames")) Then
              Response.Write REPLACE(LRs("R_MemberNames"),"|","/")
            End If
          %>
          </span>


          <%If LRs("R_ByeYN") = "Y" Then%>
            <font color="orange">BYE</font>
          <%End If%>
        </td>
        <td>
          <span <% IF LRs("R_ResultType") = "WIN" Then Response.Write "style='color:blue;font-size:14px;font-weight: bold;'" End IF %>>
          <%=A_R_ResultType%> </span>
        </td>

        <%
          btncolor_win = ""
          btncolor_anowin = ""

           '경기결과가 있으면
          If LRs("L_Result") <> "" AND LRs("R_Result") <> "" Then
            '그외경기결과로 처리되었다면..
            If (LRs("L_ResultDtl") <> "" AND Not ISNULL(LRs("L_ResultDtl"))) OR (LRs("R_ResultDtl") <> "" AND Not ISNULL(LRs("R_ResultDtl"))) Then
              btncolor_win = "gray_btn"
            Else
              btncolor_win = "red_btn"
            End If
          Else
            btncolor_win = "gray_btn"
          End If

          '경기결과가 있으면
          If LRs("L_Result") <> "" AND LRs("R_Result") <> "" Then
            '그외경기결과로 처리되었다면..
            If (LRs("L_ResultDtl") <> "" AND Not ISNULL(LRs("L_ResultDtl"))) OR (LRs("R_ResultDtl") <> "" AND Not ISNULL(LRs("R_ResultDtl"))) Then
              btncolor_anowin = "blue_btn"
            Else
              btncolor_anowin = "gray_btn"
            End If
          Else
            btncolor_anowin = "gray_btn"
          End If

        %>

        <td>

          <%
            If btncolor_anowin = "blue_btn" Then
              If LRs("L_ResultType") = "Lose" Then
                REsponse.Write LRs("L_ResultNM")
              ElseIf LRs("R_ResultType") = "Lose" Then
                REsponse.Write LRs("R_ResultNM")
              Else
                REsponse.Write LRs("L_ResultNM")
              End If
            End If
          %>
        </td>
        <td>
          <%'유튜브만'%>
          <%'If LRs("GroupGameGb") = "B0030001" Then%>
          <!-- 카카오 : <input type="text" style="width:240px;" id="MovieURL_<%=i%>" value="<%=LRs("MovieURL")%>">
          <a href="javascript:onUrlInputBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%="MovieURL_" & i%>')" class="gray_btn">저장</a>           -->
          <%'End If%>

          <%'If LRs("GroupGameGb") = "B0030002" Then%>
          유튜브 : <input type="text" style="width:240px;" id="YoutubeURL_<%=i%>" value="<%=LRs("YoutubeURL")%>">
          <a href="javascript:onYoutubeUrlInputBtnClick('<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>','<%=crypt.EncryptStringENC(LRs("TeamGameNum"))%>','<%=crypt.EncryptStringENC(LRs("GameNum"))%>','<%="YoutubeURL_" & i%>')" class="gray_btn">저장</a>
          <%'End If%>          
        </td>

      </tr>

    <%
            i = i + 1

            LRs.MoveNext
        Loop
    %>


    <% End If
      IF CDBL(GameTourneyCnt) = 0 Then %>
    <tr>
      <td colspan="17">조회 결과가 존재 하지 않습니다.</td>
    </tr>
    <%
      End if
      Set LRs = Nothing
      DBClose()
      'Response.WRite "LSQL " & LSQL & "<bR/>"
    %>
