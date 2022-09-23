<%
'#############################################
'현장 스케치 검색키
'#############################################
	'request

	Set db = new clsDBHelper

	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = fInject(oJSONoutput.tidx)
	End if

  If hasown(oJSONoutput, "searchtxt") = "ok" then
		searchtxt = fInject(oJSONoutput.searchtxt)
  else
    searchtxt = ""
	End if


  If tidx = DEBUGTIDX Then '테스트
	selectCheck = "select stateno from sd_TennisTitle where GameTitleIDX = '"& tidx &"' "
  Else
	selectCheck = "select stateno from sd_TennisTitle where GameTitleIDX = '"& tidx &"' and stateno = 1 "
  End if


	Set rsCheck = db.ExecSQLReturnRS(selectCheck , null, ConStr)
	if rsCheck.eof then
		response.write "{""jlist"": ""nodata""}"
		response.end
	end if
	set rsCheck = nothing

  sql = "select AA.GameTitleIDX,AA.gameno,BB.PlayerIDX,BB.userName+' : '+CC.userName as title from tblRGameLevel AA "_
      &" inner join sd_tennismember BB on AA.GbIDX = BB.gamekey3 and AA.GameTitleIDX = BB.GameTitleIDX "_
      &" inner join sd_tennisMember_partner CC on BB.gameMemberIDX = CC.gameMemberIDX "_
      &" where AA.DelYN = 'N' and BB.DelYN = 'N' and (BB.userName+' : '+CC.userName like '%"& searchtxt &"%'  ) and AA.GameTitleIDX = '"& tidx &"' "_
      &" group by AA.GameTitleIDX,AA.gameno,BB.PlayerIDX,BB.userName,CC.userName"
  Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
  json_sub = ""
  if not rs.eof Then
    do until rs.eof
      json_sub = json_sub & ",{""tidx"": """& rs("GameTitleIDX") &""",""gno"": """& rs("gameno") &""",""title"":"""& rs("title") &"""}"
      rs.movenext
    loop
    jsondata = "{""jlist"":["& mid(json_sub,2) &"]}"
  else
    jsondata = "{""jlist"":""nodata""}"
  end if
  response.write jsondata



%>
