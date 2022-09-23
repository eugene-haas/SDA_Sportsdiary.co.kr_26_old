<%
'#############################################
'현장 스케치 리스트 & 총페이지수
'#############################################
	'request

	Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = fInject(oJSONoutput.tidx)
	End if

  If hasown(oJSONoutput, "PN") = "ok" then
		PN = fInject(oJSONoutput.PN)
	Else
		PN = ""
	End if

	If hasown(oJSONoutput, "PT") = "ok" then
		PT = fInject(oJSONoutput.PT)
	Else
		PT = ""
	End if

  pagesizes = 10

  whereSQL = ""
  if tidx <> "" and tidx <> "0"  then
    whereSQL = " and a.GameTitleIDX = '"& tidx &"' "
  end if

	totalcounts = 0
  sqlcount = "select count(a.GameTitleIDX) from sd_Tennis_Stadium_Sketch a "_
						&" left join sd_Tennis_Stadium_Sketch_Photo b on a.Idx = b.Sketch_idx and b.delyn = 'N' "_
						&" left join sd_TennisTitle c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N' "_
						&" where a.delyn = 'N' and c.GameTitleIDX is not null and b.idx is not null "& whereSQL &" "
  Set rsCount = db.ExecSQLReturnRS(sqlcount , null, ConStr)
  totalcounts = totalcounts + rsCount(0)


	if PT = "Y" then
		TotalPages = 0
		if totalcounts > 0 Then
			TotalPages = int(totalcounts / pagesizes)
			if (totalcounts mod pagesizes) > 0 Then TotalPages = TotalPages + 1
		end if
		response.write "{""jlist"":[{""page"": """&TotalPages&"""}]}"
	Else
		if PN <> "" Then
			spage = totalcounts - (pagesizes * PN)
		  epage = spage + pagesizes
			whereSQLBetween = " ranks between "& spage+1 &" and "& epage &" "
		end if

	  sql = "select Photo,idx,TitleIDX,ssidx from( "_
	  &" select rank() OVER (ORDER BY b.idx) as ranks,a.GameTitleIDX,Photo,b.idx,c.GameTitleIDX as TitleIDX,a.idx as ssidx  "_
		&" from sd_Tennis_Stadium_Sketch a left join sd_Tennis_Stadium_Sketch_Photo b on a.Idx = b.Sketch_idx and b.delyn = 'N' "_
		&" left join sd_TennisTitle c on a.GameTitleIDX = c.GameTitleIDX and c.DelYN = 'N' "_
	  &" where a.delyn = 'N' and c.GameTitleIDX is not null and b.idx is not null "& whereSQL &") f where "& whereSQLBetween &" order by ranks desc"
	  'response.write SQL
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		if isnull(rs("TitleIDX")) = false then
			sql_update = "update sd_Tennis_Stadium_Sketch set Viewcnt=Viewcnt+1 where delyn = 'N' and GameTitleIDX = '"& rs("TitleIDX") &"' and idx = '"& rs("ssidx") &"' "
			Call db.execSQLRs(sql_update , null, ConStr)
		end if

		If Not rs.eof Then
			do until rs.eof
	      strjson = strjson & ",{""link"":""http://Upload.sportsdiary.co.kr/sportsdiary"& rs("Photo") &""",""photono"":"""& rs("idx") &""",""tidx"": """& rs("TitleIDX") &"""}"
	      rs.movenext
	    loop
	  Else
	    strjson = strjson & ",{""link"":""""}"
		End if

		Response.Write "{""jlist"":["& mid(strjson,2) &"]}"
	end if

	db.Dispose
	Set db = Nothing
%>
