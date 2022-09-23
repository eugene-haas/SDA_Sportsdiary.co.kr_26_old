
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%

'Sheet 데이터 가져오는 함수
Function FN_GetSheetName(conn)
	Dim i
	Set oADOX = CreateObject("ADOX.Catalog")
	oADOX.ActiveConnection = conn
	ReDim sheetarr(oADOX.Tables.count)
	i = 0
	For Each oTable in oADOX.Tables
		sheetarr(i) = oTable.Name
	i = i + 1
	Next 
	FN_GetSheetName = sheetarr
End function

'숫자만 뽑아오는 정규식 함수
Function FN_HtmlMinus( htmlDoc )
 set Com_rex    = new Regexp
  Com_rex.Pattern  = "[^-0-9 ]"  'Test(검색-문자열)
  Com_rex.IgnoreCase = true    'replace (검색-문자열, 대체-문자열)
  Com_rex.Global  = true    'Execute (검색-문자열)
  FN_HtmlMinus  = Com_rex.Replace(htmlDoc,"")
 set Com_rex = nothing
End function

'신규 팀코드 생성하는 함수
Function FN_NewTeamCode(varcode ,code )
  NewTeamCode = ""
  Number = INT(FN_HtmlMinus(code))
  Number = Number + 1
  NewTeamCode = varcode & right("00000" & cstr(Number), 5)
  FN_NewTeamCode = NewTeamCode
End function

'팀 가져오기 ( 신규팀 생성 및 ,기존팀 가져오기)
Function FN_GetTeamCode(ByVal Param_teamNm)
  LSQL = " SELECT TOP 1 Team, TeamNm  "
  LSQL = LSQL & " FROM tblTeamInfo "
  LSQL = LSQL & " where DelYN='N' and TeamNm ='" & Param_teamNm & "'"

  Set LRs = DBCon.Execute(LSQL)

  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrTeamInfos = LRs.getrows()
  End If

  If  IsArray(arrTeamInfos) Then
    For ar = LBound(arrTeamInfos, 2) To UBound(arrTeamInfos, 2) 
      Team		= arrTeamInfos(0, ar) 
      TeamNm	= arrTeamInfos(1, ar) 
    Next
    FN_GetTeamCode = Team
  ELSE
    LSQL = " SELECT TOP 1 Team "
    LSQL = LSQL & " FROM tblTeamInfo "
    LSQL = LSQL & " where Team like 'BA%' AND DelYN = 'N'"
    LSQL = LSQL & " order by Team desc"

    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        tTeamCodeCnt = tTeamCodeCnt + 1
        TopTeamCode = LRS("Team")
        LRs.MoveNext
      Loop
    End IF

    if CDBL(tTeamCodeCnt) = 0 Then
      TopTeamCode = "BA000000"
    End if

    NewTeamCode = FN_NewTeamCode("BA", TopTeamCode)
    
    LSQL = " SET NOCOUNT ON insert into tblTeamInfo " 
    LSQL = LSQL & " ( Team,TeamNm) "
    LSQL = LSQL & " VALUES ( '" & NewTeamCode & "','"  & Param_teamNm &"') "
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "

    Set LRs = DBCon.Execute(LSQL)
     IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        newTeamIdx = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  
    
    FN_GetTeamCode = NewTeamCode
  End IF
End Function

'팀 가져오기 ( 신규팀 생성 및 ,기존팀 가져오기)
Function FN_GetSidoCode(ByVal Param_teamNm)
  LSQL = " SELECT TOP 1 Team, TeamNm  "
  LSQL = LSQL & " FROM tblTeamInfo "
  LSQL = LSQL & " where DelYN='N' and TeamNm ='" & Param_teamNm & "'"

  Set LRs = DBCon.Execute(LSQL)

  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrTeamInfos = LRs.getrows()
  End If

  If  IsArray(arrTeamInfos) Then
    For ar = LBound(arrTeamInfos, 2) To UBound(arrTeamInfos, 2) 
      Team		= arrTeamInfos(0, ar) 
      TeamNm	= arrTeamInfos(1, ar) 
    Next
    FN_GetSidoCode = Team
  ELSE
    LSQL = " SELECT TOP 1 Team "
    LSQL = LSQL & " FROM tblTeamInfo "
    LSQL = LSQL & " where Team like 'BA%' AND DelYN = 'N'"
    LSQL = LSQL & " order by Team desc"

    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        tTeamCodeCnt = tTeamCodeCnt + 1
        TopTeamCode = LRS("Team")
        LRs.MoveNext
      Loop
    End IF

    if CDBL(tTeamCodeCnt) = 0 Then
      TopTeamCode = "BA000000"
    End if

    NewTeamCode = FN_NewTeamCode("BA", TopTeamCode)
    
    LSQL = " SET NOCOUNT ON insert into tblTeamInfo " 
    LSQL = LSQL & " ( Team,TeamNm) "
    LSQL = LSQL & " VALUES ( '" & NewTeamCode & "','"  & Param_teamNm &"') "
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "

    Set LRs = DBCon.Execute(LSQL)
     IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        newTeamIdx = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  
    
    FN_GetSidoCode = NewTeamCode
  End IF
End Function

'팀 가져오기 ( 신규유저 생성 ,기존유저 가져오기)
Function FN_GetPlayerIDX(ByVal Param_UserName, ByVal Param_TeamCode)

  'Param_UserName = "테스11111"
  'Param_TeamCode = "BA00001"
  'Response.write "Param_UserName : " & Param_UserName & "<br>"
  'Response.write "Param_TeamCode : " & Param_TeamCode & "<br>"

  LSQL = " SELECT Top 1 MemberIDX  "
  LSQL = LSQL & " FROM tblMember "
  LSQL = LSQL & "  where UserName = N'" & Param_UserName &"' and Team = '" & Param_TeamCode & "' and DelYN ='N'"
  
  'Response.write "LSQL : " & LSQL & "<br>"
  Set LRs = DBCon.Execute(LSQL)

  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrPlayers = LRs.getrows()
  End If

  IF  IsArray(arrPlayers) Then
    For ar = LBound(arrPlayers, 2) To UBound(arrPlayers, 2) 
      MemberIdx		= arrPlayers(0, ar) 
    Next
    FN_GetPlayerIDX = MemberIdx	
  ELSE
    LSQL = " SET NOCOUNT ON insert into tblMember " 
    LSQL = LSQL & " ( UserName, Team) "
    LSQL = LSQL & " VALUES ( N'" & Param_UserName & "','"  & Param_TeamCode &"') "
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "

    Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        MemberIdx = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  

    FN_GetPlayerIDX = MemberIdx
  END IF
End Function

Function FN_GetGameLevelIDX(ByVal Param_tIDX, ByVal Param_TeamGb, ByVal Param_level)

  'Response.Write "<BR/><BR/><BR/><BR/>"
  'Response.Write "Param_tIDX : " & Param_tIDX & "<BR/>"
  'Response.Write "Param_TeamGb : " & Param_TeamGb & "<BR/>"
  'Response.Write "Param_level : " & Param_level & "<BR/>"
 
  IF Param_TeamGb <> "" Then
      Param_TeamGb = TRIM(Param_TeamGb)
      LSQL = " SELECT Top 1 TeamGb, TeamGbNm  "
      LSQL = LSQL & " FROM tblTeamGbInfo "
      LSQL = LSQL & " 	where DelYN='N' AND  TeamGbNm like '%" &  Param_TeamGb  & "%' AND EnterType ='A' "

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          TeamGbCnt  = TeamGbCnt + 1
          tTeamGb = LRS("TeamGb")
          tTeamGbNm = LRS("TeamGbNm")
          LRs.MoveNext
        Loop
      End IF
  End IF
  
  IF Param_level <> "" Then
      Param_level = TRIM(Param_level)
      LSQL = " SELECT Top 1 Level,LevelNm  "
      LSQL = LSQL & " FROM tblLevelInfo "
      IF Param_level <> "" Then
      LSQL = LSQL & " 	where TeamGb = '" & tTeamGb &"' And DelYN='N' AND  LevelNm like '%" &  Param_level  & "%' "
      ELSE
      LSQL = LSQL & " 	where TeamGb = '" & tTeamGb &"' And DelYN='N'"
      END IF

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          LevelCnt  = LevelCnt + 1
          tLevel = LRS("Level")
          tLevelNm = LRS("LevelNm")
          LRs.MoveNext
        Loop
      End IF
  End IF

  IF tLevel = "" Then
    LSQL = " SELECT  GameLevelidx "
  ELSE
    LSQL = " SELECT TOP 1 GameLevelidx "
  END IF
  LSQL = LSQL & " FROM tblGameLevel "
  IF tLevel = "" Then
  LSQL = LSQL & " WHERE GameTitleIDX = '" & tIdx & "' and TeamGb = '" & tTeamGb &"' And DelYN ='N' AND GroupGameGb ='B0030002' "
  ELSE
  LSQL = LSQL & " WHERE GameTitleIDX = '" & tIdx & "' and TeamGb = '" & tTeamGb &"' And Level = '" & tLevel  & "' and DelYN ='N' AND GroupGameGb ='B0030002' "
  END IF

  'Response.Write "LSQL : " & LSQL &"<BR>"
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameLevelIdxCnt = tGameLevelIdxCnt + 1
      temp_GameLevelIdx =  temp_GameLevelIdx & LRS("GameLevelidx") & "_"
      LRs.MoveNext
    Loop
  End IF

  
  'Response.Write "GameLevelIdx : " & GameLevelIdx &"<BR>"
  'Response.Write "tIDX : " &Param_tIDX &"<BR>"
  'Response.Write "tPlayType : " &tPlayType &"<BR>"
  'Response.Write "tSex : " &tSex &"<BR>"
  'Response.Write "tLevel : " & tLevel &"<BR>"
  'Response.Write "tLevelJoo : " & tLevelJoo &"<BR>"
  
  
  FN_GetGameLevelIDX = temp_GameLevelIdx
End Function 
%>

<%
  
  REQ = Request("REQ")
  'REQ = "{""CMD"":2,""tIdx"":""A0B63180CC3215B403232E31C8E393B4"",""ROWKEY"":0,""tGameTitleName"":""2018 전국 여성배드민턴대회 및 전국시도대항리그전"",""GameType"":""B4E57B7A4F9D60AE9C71424182BA33FE"",""tTeamGb"":""2F9A5AB5A680D3EDDEE944350E247FCB"",""fileName"":""단체전_2018전국여성대회 참가현황 수정본 20180614-단체전.xlsx"",""tTotalCnt"":""128""}"
  
  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tIdx =  fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  tGameTitleName =  fInject(oJSONoutput.tGameTitleName)
  tTeamGb =  fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGb))
  fileName =  fInject(oJSONoutput.fileName)
  tTotalCnt =  fInject(oJSONoutput.tTotalCnt)
  ROWKEY =  fInject(oJSONoutput.ROWKEY)

  'Response.WRite "CMD : " & CMD  & "<br>"
  'Response.WRite "tIdx : " & tIdx  & "<br>"
  'Response.WRite "tGameTitleName : " & tGameTitleName  & "<br>"
  'Response.WRite "tTeamGb : " & tTeamGb  & "<br>"
  'Response.WRite "fileName : " & fileName  & "<br>"
  'Response.WRite "tTotalCnt : " & tTotalCnt  & "<br>"
  'Response.WRite "ROWKEY : " & ROWKEY  & "<br>"
 

  '1. Excel Connection 및 Get Data
  Dim strPath : strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\GroupGame\"  &fileName
  Set adbCon = Server.CreateObject("ADODB.connection")
  connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & "; Extended Properties=Excel 12.0;"
  'Response.Write "connString : " & connString & "<br>"
  sheetname = FN_GetSheetName(connString)
  'Response.Write "sheetname(0) : " & sheetname(sheetno) & "<br>"
  adbCon.Open connString  
  Sql = "Select  * From ["&sheetname(sheetno)&"] "
   Set Rs = adbCon.Execute(Sql)
   If NOT rs.EOF Then
    arrResultSet = rs.GetRows()
    arrRowCount = UBound(arrResultSet,2) + 1
  End If
  Rs.close
  adbCon.close
  Set Rs=Nothing
  Set adbCon=Nothing

  
  number = arrResultSet(0, ROWKEY)
  gameName = arrResultSet(1, ROWKEY)
  sido = arrResultSet(2, ROWKEY)
  leader = arrResultSet(3, ROWKEY) '필요 없는것 
  isPlayer = arrResultSet(4, ROWKEY) ' 필요함
  teamGb = arrResultSet(5, ROWKEY)
  level = arrResultSet(6, ROWKEY)
  isGroup = arrResultSet(7, ROWKEY)
 
  palyer1_sex= arrResultSet(8, ROWKEY)
  player1_name = arrResultSet(9, ROWKEY)
  palyer1_birthday = arrResultSet(10, ROWKEY)
  player1_team = sido

  'Response.Write " number : " & number &"<br/>"
  'Response.Write " gameName : " & gameName &"<br/>"
  'Response.Write " sido : " & sido &"<br/>"
  'Response.Write " leader  : " & leader  &"<br/>"
  'Response.Write " isPlayer  : " & isPlayer  & ", IsNull(isPlayer) "  &  IsNull(isPlayer) & "<br/>"
  'Response.Write " teamGb  : " & teamGb  &"<br/>"
  'Response.Write " level  : " & level  &"<br/>"
  'Response.Write " isGroup  : " & isGroup  &"<br/>"
  'Response.Write " palyer1_sex  : " & palyer1_sex &"<br/>"
  'Response.Write " player1_name  : " & player1_name  &"<br/>"
  'Response.Write " palyer1_birthday  : " & palyer1_birthday  &"<br/>"
  'Response.Write " player1_team   : " & player1_team   &"<br/>"
  
 
  'IF (IsNull(player1_team) and IsNull(player1_name)) or IsNull(isPlayer) or (IsNull(leader) = false) Then
  'IF (IsNull(player1_team) and IsNull(player1_name)) or IsNull(isPlayer) or isnull(leader) = true Then
  'IF (IsNull(player1_team) and IsNull(player1_name)) or IsNull(isPlayer) Then
  IF (IsNull(player1_team) and IsNull(player1_name)) Then
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
    Response.Write "<tr>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "</tr>"
    Response.END
  END IF




  '------------------------기본 데이터 정보------------------------

  IF ISNULL(player1_team) = False Then
    player1_teamCode = FN_GetTeamCode(player1_team)
  End IF

  'Response.WRite "player1_teamCode : " & player1_teamCode & "<BR/>" 


  
  IF (ISNULL(player1_team) = False) AND (ISNULL(player1_name) = False) Then
    player1_MemberIDX = FN_GetPlayerIDX(player1_name,player1_teamCode)
  End IF

  'Response.WRite "player1_MemberIDX : " & player1_MemberIDX & "<BR/>" 

   LSQL = " SELECT Top 1 GameTitleName"
  LSQL = LSQL & " FROM  tblGameTitle "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = " & tidx

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRS("GameTitleName")
      LRs.MoveNext
    Loop
  End IF


  
  IF (ISNULL(tIdx) = False) AND (ISNULL(teamGb) = False) Then
    'Response.Write "tIdx : " & tIdx & "<br/>"
    'Response.Write "teamGb : " & teamGb & "<br/>"
    'Response.Write "level : " & level & "<br/>"
    tGameLevelIdx = FN_GetGameLevelIDX(tIdx,teamGb,level)
    'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br/>"
  END IF
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br/>"
  'RESPONSE.End
  if CDBL(Len(tGameLevelIdx)) > 0  Then
    tGameLevelIdxs =Split(tGameLevelIdx,"_")
    for each theGameLevelIdx in tGameLevelIdxs
      IF theGameLevelIdx <> "" Then
        tGameRequestTeamIDXCnt = 0
        tGameRequestGroupIdxCnt = 0
        tGameRequestPlayerIDXCnt = 0
        
        LSQL = " SELECT Top 1 PlayType ,GroupGameGb, EnterType"
        LSQL = LSQL & " FROM tblGameLevel "
        LSQL = LSQL & "   WHERE GameLevelidx = '" & theGameLevelIdx &"' and DelYN ='N'"

        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            tPlayType = LRS("PlayType")
            tGroupGameGb = LRS("GroupGameGb")
            tEnterType = LRS("EnterType")
            LRs.MoveNext
          Loop
        End IF

        'Response.Write "tPlayType " & tPlayType & "<br/>"
        'Response.Write "tGroupGameGb :" & tGroupGameGb & "<br/>"
        'Response.Write "tEnterType : " & tEnterType & "<br/>"

        if cdbl(theGameLevelIdx) > 0 Then
          LSQL = " SELECT Top 1 GameRequestTeamIDX "
          LSQL = LSQL & "  FROM tblGameRequestTeam "
          LSQL = LSQL & "   WHERE GameLevelidx = '" & theGameLevelIdx &"' and DelYN ='N'"
          LSQL = LSQL & " and GameTitleIDX = '" & tidx & "'"
          LSQL = LSQL & " and Team ='"  & player1_teamCode & "'"
          LSQL = LSQL & " and DelYN ='N'"
          'Response.Write "LSQL  : " &  LSQL  & "<BR>"
          Set LRs = DBCon.Execute(LSQL)
          IF NOT (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
              tGameRequestTeamIDXCnt = tGameRequestTeamIDXCnt + 1
              tGameRequestTeamIDX = LRS("GameRequestTeamIDX")
              LRs.MoveNext
            Loop
          End IF
          
          IF cdbl(tGameRequestTeamIDXCnt) = 0 Then
            LSQL = " SET NOCOUNT ON insert into tblGameRequestTeam " 
            LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameTitleName, Team, TeamName) "
            LSQL = LSQL & " values ('"&tIdx & "','" &  theGameLevelIdx & "','" & tGameTitleName & "','"& player1_teamCode & "', '" & player1_team &"')" 
            LSQL = LSQL & " SELECT @@IDENTITY as IDX "
            'Response.Write "SQL :" & LSQL & "<BR>"
            'Response.end
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                tGameRequestTeamIDX = LRs("IDX")
              LRs.MoveNext
              Loop
            End If
          End if

          LSQL = " SELECT Top 1 GameRequestGroupIDX "
          LSQL = LSQL & "  FROM tblGameRequestGroup "
          LSQL = LSQL & " WHERE GameLevelidx = '" & theGameLevelIdx &"' and DelYN ='N'"
          LSQL = LSQL & " and GameTitleIDX = '" & tidx & "'"
          LSQL = LSQL & " and GameRequestTeamIDX ='"  & tGameRequestTeamIDX & "'"
          LSQL = LSQL & " and Team ='"  & player1_teamCode & "'"
          LSQL = LSQL & " and DelYN ='N'"
          'Response.Write "LSQL  : " &  LSQL  & "<BR>"
          Set LRs = DBCon.Execute(LSQL)
          IF NOT (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
              tGameRequestGroupIdxCnt = tGameRequestGroupIdxCnt  + 1
              tGroupRequestIdx = LRS("GameRequestGroupIDX")
              LRs.MoveNext
            Loop
          End IF

          IF cdbl(tGameRequestGroupIdxCnt) = 0 Then
            LSQL = " SET NOCOUNT ON insert into tblGameRequestGroup " 
            LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestTeamIDX, GameTitleName, EnterType, GroupGameGb, Team) "
            LSQL = LSQL & " values ('"&tIdx & "','" &  theGameLevelIdx & "','" & tGameRequestTeamIDX  & "','" & tGameTitleName & "','" & tEnterType & "','" & tGroupGameGb &"','"& player1_teamCode &"')" 
            LSQL = LSQL & " SELECT @@IDENTITY as IDX "
            'Response.Write "LSQL  : " &  LSQL  & "<BR>"
            'Response.Write "SQL :" & LSQL & "<BR>"
            'Response.end
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                tGroupRequestIdx = LRs("IDX")
              LRs.MoveNext
              Loop
            End If  
          End IF

          'Response.Write "tGroupRequestIdx : " &  tGroupRequestIdx & "<br/>"
            

          LSQL = " SELECT Top 1 GameRequestPlayerIDX "
          LSQL = LSQL & "  FROM tblGameRequestPlayer "
          LSQL = LSQL & " WHERE GameLevelidx = '" & theGameLevelIdx &"' and DelYN ='N'"
          LSQL = LSQL & " and GameTitleIDX = '" & tidx & "'"
          LSQL = LSQL & " and GameRequestTeamIDX ='"  & tGameRequestTeamIDX & "'"
          LSQL = LSQL & " and GameRequestGroupIDX ='"  & tGroupRequestIdx & "'"
          LSQL = LSQL & " and Team ='"  & player1_teamCode & "'"
          LSQL = LSQL & " and MemberIDX ='"  & player1_MemberIDX & "'"
          LSQL = LSQL & " and DelYN ='N'"
          'Response.Write "LSQL  : " &  LSQL  & "<BR>"
          Set LRs = DBCon.Execute(LSQL)
          IF NOT (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            tGameRequestPlayerIDXCnt = tGameRequestPlayerIDXCnt + 1
              tGameRequestPlayerIDX = LRS("GameRequestPlayerIDX")
              LRs.MoveNext
            Loop
          End IF
      

          if tGameRequestPlayerIDXCnt = 0 Then
            LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
            LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX,GameRequestTeamIDX, GameRequestGroupIDX ,MemberIDX, MemberName, Team, TeamName) "
            LSQL = LSQL & " values ('"&tIdx & "','" &  theGameLevelIdx & "' ,'" &  tGameRequestTeamIDX & "' ,'"  &  tGroupRequestIdx & "' ,'" & player1_MemberIDX & "',N'" & player1_name & "','" & player1_teamCode & "', '" & player1_team &"')" 
            LSQL = LSQL & " SELECT @@IDENTITY as IDX "

            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                tGameRequestPlayerIDX = LRs("IDX")
              LRs.MoveNext
              Loop
            End If  
          End IF
         
        End IF
      End IF
    Next
  End IF
  
  'Response.Write "tGameRequestPlayerIDX : " &  tGroupRequestIdx & "<br/>"
  'Response.Write "tGameRequestPlayerIDX : " &  tGameRequestPlayerIDX & "<br/>"
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
 <tr>
      <td>
        <%=ROWKEY + 1%>
      </td>
      <td>
        <%=gameName %>
      </td>
      <td>
        <%=tGameLevelIdx%>
      </td>
      <td>
        <%=leader%>
      </td>
      <td>
        <%=isPlayer%>
      </td>
      <td>
        <%=player1_team %>
      </td>
      <td>
          <%=level %>
      </td>
      <td>
         <%=isGroup %>
      </td>
      <td>
          <%=player1_sex%>
      </td>
      <td>
        <%=player1_name%>
      </td>
      <td>
        <%=player1_birthday%>
      </td>
    </tr>   
<%
  DBClose()
%>