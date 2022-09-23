<%
'#############################################
'메인 뷰
'#############################################
	'request
  Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
    tidx = fInject(oJSONoutput.tidx)
  End if

  If hasown(oJSONoutput, "gno") = "ok" then
    gno = fInject(oJSONoutput.gno)
  Else
    gno = ""
  End if

  whereSql = ""
  if gno <> "" then
    whereSql = whereSql & " and gameno in ("& gno &") "
  end if

  If tidx = DEBUGTIDX Then '테스트
  selectCheck = "select stateno from sd_TennisTitle where GameTitleIDX = '"& tidx &"' "
  Else
  selectCheck = "select stateno from sd_TennisTitle where GameTitleIDX = '"& tidx &"' and stateno = 1"
  End if
  Set rsCheck = db.ExecSQLReturnRS(selectCheck , null, ConStr)
  if rsCheck.eof then
    response.write "{""jlist"": ""nodata""}"
    response.end
  end if
  set rsCheck = nothing

  sql = "select GameDay from tblRGameLevel where delyn = 'N' and GameTitleIDX  = '"& tidx &"' "& whereSql &" group by GameDay"
  SQL = SQL & " union "
  SQL = SQL & " select left(GameDay2,10) as gameday  from tblRGameLevel where delyn = 'N' and GameTitleIDX = '"& tidx &"' "& whereSql &" and gameday2 is not null   group by GameDay2 "


  
'  response.write sql
'  response.end
  strjson = ""
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  if not rs.eof Then
    do until rs.eof
      strjson = strjson & ",{""day"":"""& mid(replace(rs(0),"-","/"),6) &""",""gno"": """& gno &"""}"
      rs.movenext
    loop
    response.write "{""jlist"": ["& mid(strjson,2) &"]}"
  else
    response.write "{""jlist"": ""nodata""}"
  end if
%>
