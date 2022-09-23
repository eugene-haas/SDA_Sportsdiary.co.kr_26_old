<%
'#############################################
'메인 뷰
'#############################################
	'request

  Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
    tidx = fInject(oJSONoutput.tidx)
  End if

  if tidx <> "" and tidx <> "undefined" then
    sql = "select top 1 GameTitleName,GameYear from sd_TennisTitle where delyn = 'N' and GameTitleIDX = '"& tidx &"'  "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    if not rs.eof Then
      response.write "{""yy"":"""&rs(1)&""",""jlist"": [{""title"": """& rs("GameTitleName") &"""}]}"
    else
      response.write "{""yy"":"""&year(date)&""",""jlist"": ""nodata""}"
    end if
  else
    response.write "{""yy"":"""&year(date)&""",""jlist"": ""nodata""}"
  end if
%>
