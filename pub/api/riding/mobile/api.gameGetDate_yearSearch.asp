<%
'#############################################
'경기일정 년도 검색어
'#############################################
	'request

	Set db = new clsDBHelper


  sqlYS = "select GameYear from sd_TennisTitle where DelYN = 'N' group by GameYear"
  set rsYS = db.ExecSQLReturnRS(sqlYS , null, ConStr)
  yearJsons = ""
  if not rsYS.eof Then
    do until rsYS.eof
      yearJsons = yearJsons & ",{""year"":"""& rsYS("GameYear") &"""}"
      rsYS.movenext
    loop
  else
    yearJsons = yearJsons & ",{""year"":""2019""},{""year"":""2018""},{""year"":""2017""}"
  end if

  Response.Write "{""jlist"":["& mid(yearJsons,2) &"]}"

%>
