
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

'팀 가져오기 ( 신규유저 생성 ,기존유저 가져오기)
Function FN_GetPlayerIDX(ByVal Param_UserName, ByVal Param_TeamCode)

  'Param_UserName = "테스11111"
  'Param_TeamCode = "BA00001"
  'Response.write "Param_UserName : " & Param_UserName & "<br>"
  'Response.write "Param_TeamCode : " & Param_TeamCode & "<br>"

  LSQL = " SELECT Top 1 MemberIDX  "
  LSQL = LSQL & " FROM tblMember "
  LSQL = LSQL & "  where UserName ='" & Param_UserName &"' and Team = '" & Param_TeamCode & "' and DelYN ='N'"
  
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
    LSQL = LSQL & " VALUES ( '" & Param_UserName & "','"  & Param_TeamCode &"') "
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

Function FN_GetGameLevelIDX(ByVal Param_tIDX, ByVal Param_levelPlayTypeSex, ByVal Param_levelAge, ByVal Param_levelJoo,ByVal Param_TeamGb)

  Dim tPlayTypeCnt : tPlayTypeCnt = 0
  Dim tSexCnt : tSexCnt = 0
  Dim tLevelJooCnt : tLevelJooCnt = 0 
  Dim LevelCnt : LevelCnt = 0 
  Dim GameLevelIdx : GameLevelIdx = 0

  tTeamGb = Param_TeamGb
  '단식,복식의 Player 타입과 남자,여자,혼성의 Sex
  IF Param_levelPlayTypeSex <> "" Then
    Param_levelPlayTypeSex = TRIM(Param_levelPlayTypeSex)
    IF cdbl(Len(Param_levelPlayTypeSex)) = 2 Then

      tLevelSex = Left(Param_levelPlayTypeSex, 1)
      tLevelPlayType = Right(Param_levelPlayTypeSex, 1)

      LSQL = " SELECT TOP 1 PubCode, PubName  "
      LSQL = LSQL & " FROM tblPubcode "
      LSQL = LSQL & " where PPubCode = 'B002' And DelYN='N' and PubName like '%" & tLevelPlayType& "%'"

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          tPlayTypeCnt = tPlayTypeCnt + 1
          tPlayType = LRS("PubCode")
          tPlayTypeName = LRS("PubName")
          LRs.MoveNext
        Loop
      End IF

      'Response.Write "tPlayType : " & tPlayType  & "<br>"
      'Response.Write "tPlayTypeName : " & tPlayTypeName  & "<br>"
      
      LSQL = " SELECT TOP 1 PubCode, PubName  "
      LSQL = LSQL & " FROM tblPubcode "
      LSQL = LSQL & " where PPubCode = 'Sex' And DelYN='N' and PubName like '%" & tLevelSex & "%'"

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          tSexCnt  = tSexCnt + 1
          tSex = LRS("PubCode")
          tSexName = LRS("PubName")
          LRs.MoveNext
        Loop
      End IF

      'Response.Write "tSex : " & tSex  & "<br>"
      'Response.Write "tSexName : " & tSexName  & "<br>"
    End IF
  End IF
  
  IF Param_levelAge <> "" Then
      Param_levelAge = TRIM(Param_levelAge)
      LSQL = " SELECT Top 1 Level,LevelNm  "
      LSQL = LSQL & " FROM tblLevelInfo "
      LSQL = LSQL & " 	where TeamGb = '" & tTeamGb &"' And DelYN='N' AND  LevelNm like '%" &  Param_levelAge  & "%' "

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

  IF Param_levelJoo <> "" Then
    Param_levelJoo = TRIM(Param_levelJoo)
    LSQL = " SELECT TOP 1 PubCode, PubName  "
    LSQL = LSQL & " FROM tblPubcode "
    LSQL = LSQL & " where PPubCode = 'B011' And DelYN='N' and PubName like '%" & Param_levelJoo& "%'"

    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        tLevelJooCnt = tLevelJooCnt + 1
        tLevelJoo = LRS("PubCode")
        tLevelJooName = LRS("PubName")
        LRs.MoveNext
      Loop
    End IF
  End IF

  LSQL = " SELECT TOP 1 GameLevelidx "
  LSQL = LSQL & " FROM tblGameLevel "
  LSQL = LSQL & " WHERE GameTitleIDX = '" & tIdx & "' and PlayType ='" & tPlayType & "' and Sex = '"  & tSex & "' and Level = '" & tLevel  & "' and LevelJooName = '" & tLevelJoo &"' and DelYN ='N' "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameLevelIdxCnt = tGameLevelIdxCnt + 1
      GameLevelIdx = LRS("GameLevelidx")
      LRs.MoveNext
    Loop
  End IF
  'Response.Write "GameLevelIdx : " & GameLevelIdx &"<BR>"
  'Response.Write "tIDX : " &Param_tIDX &"<BR>"
  'Response.Write "tPlayType : " &tPlayType &"<BR>"
  'Response.Write "tSex : " &tSex &"<BR>"
  'Response.Write "tLevel : " & tLevel &"<BR>"
  'Response.Write "tLevelJoo : " & tLevelJoo &"<BR>"
  
  
  FN_GetGameLevelIDX = GameLevelIdx
End Function 


Function Empty_Tr()
  Dim html_Tr 
  html_Tr = "<tr><td></td> <td> </td> <td> </td> <td> </td> <td></td> <td></td> <td></td> <td> </td> <td> </td><td> </td><td> </td> <td> </td> <td></td> <td></td> <td> </td> <td> </td><td> </td><td> </td> <td> </td></tr>"
  Empty_Tr = html_Tr
End Function
%>



<%
  
  'REQ = Request("REQ")
  REQ = "{""CMD"":2,""tIdx"":""9EAD4DA5F105200CBFF44F8CEA1315AE"",""ROWKEY"":1,""tGameTitleName"":""제2 댕댕테스트4ㅎㅎ"",""tTeamGb"":""BF593DD3E782EC864107F23897C0095E"",""fileName"":""참가자 명단 (종합 시도별)_최종_18.3.29_정해진종별_2.xlsx"",""tTotalCnt"":""6""}"
  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tIdx =  fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  tGameTitleName =  fInject(oJSONoutput.tGameTitleName)
  tTeamGb =  fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGb))
  fileName =  fInject(oJSONoutput.fileName)
  tTotalCnt =  fInject(oJSONoutput.tTotalCnt)
  ROWKEY =  fInject(oJSONoutput.ROWKEY)
  'Response.WRite "fileName : " & fileName  & "<br>"
  'Response.WRite "strPath : " & strPath  & "<br>"

  '1. Excel Connection 및 Get Data
  Dim strPath : strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\"  &fileName
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

  '1. 팀정보  
  number = arrResultSet(0, ROWKEY)
  gameNumber = arrResultSet(1, ROWKEY)
  levelPlayTypeSex = arrResultSet(2, ROWKEY)
  levelAge = arrResultSet(3, ROWKEY)
  levelJoo = arrResultSet(4, ROWKEY)

  '2. 플레이어1 정보
  player1_sido = arrResultSet(5, ROWKEY)
  player1_gugun = arrResultSet(6, ROWKEY)
  player1_team = arrResultSet(7, ROWKEY)
  player1_name = arrResultSet(8, ROWKEY)
  palyer1_birthday = arrResultSet(9, ROWKEY)
  palyer1_sex= arrResultSet(10, ROWKEY)
  palyer1_phone= arrResultSet(11, ROWKEY)
  palyer1_Other= arrResultSet(12, ROWKEY)

  IF IsNull(player1_team) and IsNull(player1_name) Then
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
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "<td></td>"
    Response.Write "</tr>"
    Response.END
  END IF


  remove1_Trim = TRIM(player1_team)
  isTeam1 = (remove1_Trim="")
  if( isTeam1 = False) Then
    player1_team = player1_team 
  ELSE
    remove1_SidoTrim = TRIM(player1_sido)
    isSidoTeam1 = (remove1_SidoTrim="")
    if( isSidoTeam1 = False) Then
      player1_team = player1_sido
    ELSE
      player1_team = player1_gugun
    END IF
  END IF
 


  '3. 플레이어2 정보
  player2_sido = arrResultSet(13, ROWKEY)
  player2_gugun = arrResultSet(14, ROWKEY)
  player2_team = arrResultSet(15, ROWKEY)
  player2_name = arrResultSet(16, ROWKEY)
  palyer2_birthday = arrResultSet(17, ROWKEY)
  palyer2_sex= arrResultSet(18, ROWKEY)
  palyer2_phone= arrResultSet(19, ROWKEY)
  palyer2_Other= arrResultSet(20, ROWKEY)

  remove2_Trim = TRIM(player2_team)
  isTeam2 = (remove2_Trim="")
  if( isTeam2 = False) Then
    player2_team = player2_team 
  ELSE
    remove2_SidoTrim = TRIM(player2_sido)
    isSidoTeam2 = (remove2_SidoTrim = "")
    if( isSidoTeam2 = False) Then
      player2_team = player2_sido
    ELSE
      player2_team = player2_gugun
    END IF
  END IF
  
  '------------------------기본 데이터 정보------------------------
  IF ISNULL(player1_team) = False Then
    player1_teamCode = FN_GetTeamCode(player1_team)
  End IF
  IF ISNULL(player2_team) = False Then
    player2_teamCode = FN_GetTeamCode(player2_team)
  End IF

  IF (ISNULL(player1_team) = False) AND (ISNULL(player1_name) = False) Then
    player1_MemberIDX = FN_GetPlayerIDX(player1_name,player1_teamCode)
  End IF

  IF (ISNULL(player1_team) = False) AND (ISNULL(player1_name) = False) Then
    player2_MemberIDX = FN_GetPlayerIDX(player2_name,player2_teamCode)
  END IF
  
  IF (ISNULL(tIdx) = False) AND (ISNULL(levelPlayTypeSex) = False) AND (ISNULL(levelAge) = False) AND (ISNULL(levelJoo) = False)  AND (ISNULL(tTeamGb) = False) Then
    tGameLevelIdx = FN_GetGameLevelIDX(tIdx,levelPlayTypeSex,levelAge, levelJoo,tTeamGb)
  END IF

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


  LSQL = " SELECT Top 1 PlayType ,GroupGameGb, EnterType"
  LSQL = LSQL & " FROM tblGameLevel "
  LSQL = LSQL & "   WHERE GameLevelidx = '" & tGameLevelIdx &"' and DelYN ='N'"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tPlayType = LRS("PlayType")
      tGroupGameGb = LRS("GroupGameGb")
      tEnterType = LRS("EnterType")
      LRs.MoveNext
    Loop
  End IF
  '------------------------기본 데이터 정보------------------------

  'Response.WRite "player1_team : " & player1_teamCode & "<br>"
  'Response.WRite "player1_teamNm : " & player1_team & "<br>"
  'Response.WRite "player2_team : " & player2_teamCode & "<br>"
  'Response.WRite "player2_teamNm : " & player2_team & "<br>"
  'Response.WRite "player1_idx : " & player1_MemberIDX & "<br>"
  'Response.WRite "player1_UserName : " & player1_name & "<br>"
  'Response.WRite "player2_idx : " & player2_MemberIDX & "<br>"
  'Response.WRite "player2_UserName : " & player2_name & "<br>"
  'Response.Write "tIdx  : " &  tIdx  & "<BR>"
  'Response.Write "tGameLevelIdx  : " &  tGameLevelIdx  & "<BR>"
  'Response.Write "tGroupGameGb  : " &  tGroupGameGb  & "<BR>"
  'Response.Write "tPlayType  : " &  tPlayType  & "<BR>"
  if cdbl(tGameLevelIdx) > 0 Then
    '개인전 그룹
    LSQL = " SET NOCOUNT ON insert into tblGameRequestGroup " 
    LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameTitleName, EnterType, GroupGameGb, Team) "
    LSQL = LSQL & " values ('"&tIdx & "','" &  tGameLevelIdx & "','" & tGameTitleName & "','" & tEnterType & "','" & tGroupGameGb &"','"& player1_teamCode &"')" 
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "
    'Response.Write "SQL :" & LSQL & "<BR>"
    'Response.end
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        GroupRequestIdx = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  

    '선수가 이미 등록되있는지 체크
    LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
    LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX ,MemberIDX, MemberName, Team, TeamName) "
    LSQL = LSQL & " values ('"&tIdx & "','" &  tGameLevelIdx & "' ,'"  &  GroupRequestIdx & "' ,'" & player1_MemberIDX & "','" & player1_name & "','" & player1_teamCode & "', '" & player1_team &"')" 
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "

    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        PlayerIdx_1 = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  

    'Response.Write "SQL :" & LSQL & "<BR>"
    IF tPlayType = "B0020002" Then
      LSQL = " SET NOCOUNT ON insert into tblGameRequestPlayer " 
      LSQL = LSQL & " ( GameTitleIDX, GameLevelIDX, GameRequestGroupIDX,MemberIDX, MemberName, Team, TeamName) "
      LSQL = LSQL & " values ('"&tIdx & "','" &  tGameLevelIdx & "' ,'" & GroupRequestIdx & "' ,'" & player2_MemberIDX & "','" & player2_name & "','" & player2_teamCode & "', '" & player2_team &"')" 
      LSQL = LSQL & " SELECT @@IDENTITY as IDX "

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          PlayerIdx_2 = LRs("IDX")
        LRs.MoveNext
        Loop
      End IF
    End IF
  End IF

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
 <tr>
      <td>
        <%=ROWKEY + 1%>
      </td>
      <td>
      </td>
      <td>
        <%=tGameLevelIdx%>
      </td>
      <td>
        <%=player1_name %>
      </td>
      <td>
   
      </td>
      <td>
     
      </td>
      <td>
        <%=player1_name%>
      </td>
      <td>
        <%=player1_team %>
      </td>
      <td>
     
      </td>
      <td>
  
      </td>
      <td>
     
      </td>
      <td>
        <%=player2_name%>
      </td>
      <td>
        
      </td>
      <td>
     
      </td>
      <td>
       <%=player2_team %>
      </td>
      <td>
      
      </td>
      <td>
       
      </td>
      <td>
     
      </td>
      <td>
       
      </td>
    </tr>   
<%
  DBClose()
%>