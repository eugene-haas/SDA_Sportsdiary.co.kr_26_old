
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

Function FN_GetOldAndNewTeam(teamCode)

  NewTeamCode = FN_NewTeamCode("BA", teamCode)


  Dim rs, SQL ,insertfield ,insertvalue ,teamcode
	SQL = "Select Team from tblTeamInfo where SportsGb = 'tennis' and TeamNm = '"&Replace(Trim(teamNm)," ","")&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		'등록 후 정보
	    SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) teamLast,len(Team)TeamLen from  tblTeamInfo where SportsGb = 'tennis'  ORDER BY Team desc"
	    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		teamcode = "ATE000" & rs(0)

		insertfield = " SportsGb,Team,TeamNm,EnterType,TeamLoginPwd,NowRegYN "
		insertvalue = "'tennis','"&teamcode&"','"&Replace(Trim(teamNm)," ","")&"','A','"&teamcode&"','Y' "

		SQL = "INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES ( "&insertvalue&" ) "
		Call db.execSQLRs(SQL , null, ConStr)
		FN_GetOldAndNewTeam = teamcode
	Else
		FN_GetOldAndNewTeam = rs(0)
	End If
End Function
 

%>

<%
  'REQ = Request("REQ")
  REQ = "{""CMD"":2,""tIdx"":""6966027AD5AE152FF96577A83E546045"",""ROWKEY"":0,""tGameTitleName"":""입력테스트 대회"",""fileName"":""제37회 대한배드민턴 협회장기대회 생활체육 전국배드민턴대회 신청현황.xlsx"",""tTotalCnt"":""1019""}"
  Set oJSONoutput = JSON.Parse(REQ)
  tTeamGb = "16001"
	CMD = fInject(oJSONoutput.CMD)
  tIDX =  fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  tGameTitleName =  fInject(oJSONoutput.tGameTitleName)
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
  remove1_Trim = TRIM(player1_team)
  isTeam1 = (remove1_Trim="")
  if( isTeam1 = False) Then
    player1_team = player1_team 
  ELSE
    player1_team = player1_sido
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
    player2_team = player2_sido
  END IF
  
  '1.클럽 확인 후 입력 
  Dim tTeamCnt : tTeamCnt = 0
  Dim tTeamCode : tTeamCode= 0

  LSQL = " SELECT TOP 1 Team, TeamNm  "
  LSQL = LSQL & " FROM tblTeamInfo "
  LSQL = LSQL & " where DelYN='N' and TeamNm ='" & player1_team & "'"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeamCnt = tTeamCnt + 1
      Team = LRS("Team")
      TeamNm = LRS("TeamNm")
      LRs.MoveNext
    Loop
  End IF

  '2. 클럽의 제일 마지막 코드 가져옴.
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

  Response.Write "TopTeamCode : " & TopTeamCode

  

  Response.Write "NewTeamCode : " & FN_GetOldAndNewTeam(TopTeamCode)

 
  
  '3. 클럽 코드 생성 
  IF cdbl(tTeamCnt) = 0 Then
    'LSQL = " SET NOCOUNT ON insert into tblTeamInfo " 
    'LSQL = LSQL & " ( Team, TeamNm ) "
    'LSQL = LSQL & " values ('"&tTeamIdx & "','" &  player1_team & "')" 
    'LSQL = LSQL & " SELECT @@IDENTITY as IDX "

    'Response.Write "LSQL :" & LSQL & "<BR>"
    'Set LRs = DBCon.Execute(LSQL)
    'IF NOT (LRs.Eof Or LRs.Bof) Then
    '    Do Until LRs.Eof
    '    tTeamIdx = LRs("IDX")
    '  LRs.MoveNext
    '  Loop
    'End If  
  End IF


  

  


  '2.선수 확인 후 입력




  Dim tPlayTypeCnt : tPlayTypeCnt = 0
  Dim tSexCnt : tSexCnt = 0
  Dim tLevelJooCnt : tLevelJooCnt = 0 
  Dim LevelCnt : LevelCnt = 0 
  
  '단식,복식의 Player 타입과 남자,여자,혼성의 Sex
  IF levelPlayTypeSex <> "" Then
    IF cdbl(Len(levelPlayTypeSex)) = 2 Then

      tLevelSex = Left(levelPlayTypeSex, 1)
      tLevelPlayType = Right(levelPlayTypeSex, 1)

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
  
  IF levelAge <> "" Then
     LSQL = " SELECT Top 1 Level,LevelNm  "
      LSQL = LSQL & " FROM tblLevelInfo "
      LSQL = LSQL & " 	where TeamGb = '16001' And DelYN='N' AND  LevelNm like '%" &  levelAge  & "%' "

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

  IF levelJoo <> "" Then
    LSQL = " SELECT TOP 1 PubCode, PubName  "
    LSQL = LSQL & " FROM tblPubcode "
    LSQL = LSQL & " where PPubCode = 'B011' And DelYN='N' and PubName like '%" & levelJoo& "%'"

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

  
  Response.Write "tPlayType : " & tPlayType  & "<br>"
  Response.Write "tSex : " & tSex  & "<br>"
  Response.Write "tLevel : " & tLevel  & "<br>"
  Response.Write "tLevelJoo: " & tLevelJoo  & "<br>"
  

  Response.Write "number : " & number  & ":"
  Response.Write "gameNumber : " & gameNumber  &  ":"
  Response.Write "levelPlayTypeSex : " & levelPlayTypeSex  & ":"
  Response.Write "levelAge : " & levelAge  &  ":"
  Response.Write "levelJoo : " & levelJoo  &  ":"
  Response.Write "<br/>"
  Response.Write "player1_sido : " & player1_sido  & ":"
  Response.Write "player1_gugun : " & player1_gugun  &  ":"
  Response.Write "player1_team : " & player1_team  & ":"
  Response.Write "player1_name : " & player1_name  &  ":"
  Response.Write "palyer1_birthday : " & palyer1_birthday  &  ":"
  Response.Write "palyer1_sex : " & palyer1_sex  & ":"
  Response.Write "palyer1_phone : " & palyer1_phone  & ":"
  Response.Write "palyer1_Other : " & palyer1_Other  & ":"
  Response.Write "<br/>"
  Response.Write "player2_sido : " & player2_sido  & ":"
  Response.Write "player2_gugun : " & player2_gugun  &  ":"
  Response.Write "player2_team : " & player2_team  & ":"
  Response.Write "player2_name : " & player2_name  &  ":"
  Response.Write "palyer2_birthday : " & palyer2_birthday  &  ":"
  Response.Write "palyer2_sex : " & palyer2_sex  & ":"
  Response.Write "palyer2_phone : " & palyer2_phone  & ":"
  Response.Write "palyer2_Other : " & palyer2_Other  & ":"
  Response.Write "<br/><br/><br/><br/>"



  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
  <div></div>
<%
  DBClose()
%>