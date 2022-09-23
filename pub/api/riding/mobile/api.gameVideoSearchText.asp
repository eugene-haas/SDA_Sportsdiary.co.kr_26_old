<%
'#############################################
'현장 스케치 검색키
'#############################################
	'request

	Set db = new clsDBHelper



  If hasown(oJSONoutput, "searchtxt") = "ok" then
		searchtxt = fInject(oJSONoutput.searchtxt)
  else
    searchtxt = ""
	End if

  sql = "select AA.titleIDX,BB.idx,BB.title from sd_RidingBoard AA "_
      &" inner join sd_RidingBoard_C BB on AA.seq = BB.seq "_
      &" where BB.title like '%"& searchtxt &"%'"
  Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
  json_sub = ""
  if not rs.eof Then
    do until rs.eof
      json_sub = json_sub & ",{""tidx"": """& rs("titleIDX") &""",""vidx"": """& rs("idx") &""",""title"":"""& rs("title") &"""}"
      rs.movenext
    loop
    jsondata = "{""jlist"":["& mid(json_sub,2) &"]}"
  else
    jsondata = "{""jlist"":""nodata""}"
  end if
  response.write jsondata
%>
