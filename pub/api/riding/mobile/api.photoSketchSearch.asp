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

  if YS <> "" then
    whereSQL = " and GameYear = '"& YS &"' "
  end if

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

  sql = "select top 20 GameTitleIDX,GameTitleName ,GameYear from sd_TennisTitle where DelYN = 'N' "& whereSQL &" order by GameYear desc,GameTitleIDX desc "
  Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
  gamstitlesJsons = ",{""name"":""전체"",""tidx"":""""}"
  if not rs.eof Then
    do until rs.eof
      gamstitlesJsons = gamstitlesJsons & ",{""name"":"""& rs("GameTitleName") &""",""tidx"":"""& rs("GameTitleIDX") &"""}"
      rs.movenext
    loop
  end if
  Response.Write "{""jlist"":[{""age"":["& mid(yearJsons,2) &"],""gamename"":["& mid(gamstitlesJsons,2) &"]}]}"



	db.Dispose
	Set db = Nothing
%>
