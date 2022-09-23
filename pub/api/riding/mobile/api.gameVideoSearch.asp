<%
'#############################################
'현장 스케치 검색키
'#############################################
	'request

	Set db = new clsDBHelper


  If hasown(oJSONoutput, "YS") = "ok" then
		YS = fInject(oJSONoutput.YS)
  else
    YS = ""
	End if
  whereSQL = ""

  If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = fInject(oJSONoutput.tidx)
  else
    tidx = ""
	End if

  whereSQL = ""
  if YS <> "" then
    whereSQL = " and GameYear = '"& YS &"' "
  end if

	'연도
  sqlYS = "select GameYear from sd_TennisTitle where DelYN = 'N' group by GameYear"
  set rsYS = db.ExecSQLReturnRS(sqlYS , null, ConStr)
  yearJsons = ""
  if not rsYS.eof Then
    do until rsYS.eof
      yearJsons = yearJsons & ",{""year"":"""& rsYS("GameYear") &"""}"
      rsYS.movenext
    loop
  else
    yearJsons = yearJsons & ",{""year"":""2019년""},{""year"":""2018년""},{""year"":""2017년""}"
  end if

	'대회
  sql = "select top 20 GameTitleIDX,GameTitleName ,GameYear from sd_TennisTitle where DelYN = 'N' "& whereSQL &" order by GameYear desc,GameTitleIDX desc "
  Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
  gametitlesJsons = ",{""name"":""전체 대회"",""tidx"":""""}"
  if not rs.eof Then
    do until rs.eof
      gametitlesJsons = gametitlesJsons & ",{""name"":"""& rs("GameTitleName") &""",""tidx"":"""& rs("GameTitleIDX") &"""}"
      rs.movenext
    loop
  Else
    gametitlesJsons = gametitlesJsons & ",{""name"":"""",""tidx"":""""}"
  end if

  whereSQL = ""
  if tidx <> "" then
    whereSQL = " and TeamGbIDX in (select GbIDX from tblRGameLevel where DelYN = 'N' and GameTitleIDX = '"& tidx &"' group by GbIDX)"
  end if

	'종목
  sqlGB = "select TeamGb,PTeamGbNm,TeamGbNm from tblTeamGbInfo where DelYN = 'N' "& whereSQL &" group by TeamGb,PTeamGbNm,TeamGbNm"
  set rsGB = db.ExecSQLReturnRS(sqlGB , null, ConStr)
  GbJsons = ",{""name"":""전체 종목"",""levelno"":""""}"
  if not rsGB.eof Then
    do until rsGB.eof
      GbJsons = GbJsons & ",{""name"":"""& rsGB("PTeamGbNm") &" - "& rsGB("TeamGbNm") &""",""levelno"":"""& rsGB("TeamGb") &"""}"
      rsGB.movenext
    loop
  Else
    GbJsons = GbJsons & ",{""name"":"""",""tidx"":""""}"
  end if

  Response.Write "{""jlist"":[{""age"":["& mid(yearJsons,2) &"],""gamename"":["& mid(gametitlesJsons,2) &"],""events"":["& mid(GbJsons,2) &"]}]}"



	db.Dispose
	Set db = Nothing
%>
