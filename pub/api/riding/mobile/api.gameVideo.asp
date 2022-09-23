<%
'#############################################
'경기 영상 리스트
'#############################################
	'request

	Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = fInject(oJSONoutput.tidx)
	End if

  If hasown(oJSONoutput, "levelno") = "ok" then
		levelno = fInject(oJSONoutput.levelno)
	Else
		levelno = ""
	End if

  If hasown(oJSONoutput, "vidx") = "ok" then
		idx = fInject(oJSONoutput.vidx)
	Else
		idx = ""
	End if

	If hasown(oJSONoutput, "vidxsearch") = "ok" then
		vidxsearch = fInject(oJSONoutput.vidxsearch)
	Else
		vidxsearch = ""
	End if

  whereSQL = ""
  if tidx <> "" then
    whereSQL = whereSQL & " and AA.GameTitleIDX = '"& tidx &"' "
  end if

  if levelno <> "" then
    whereSQL = whereSQL & " and EE.levelno like '"& levelno &"%' "
  end if

	if vidxsearch <> "" then
		whereSQL = whereSQL & " and DD.idx in ("& vidxsearch &") "
	else
	  if idx <> "" Then
	    whereSQL = whereSQL & " and DD.idx in ("& idx &") "
	  end if
	end if

  sql = "select "_
        &" AA.GameTitleIDX, "_
        &" BB.gameno, "_
        &" DD.idx, "_
        &" AA.GameTitleName, "_
        &" DD.title, "_
        &" AA.GameYear, "_
        &" DD.filename, "_
        &" DD.Thumbnail, "_
        &" DD.readnum, "_
        &" EE.TeamGbNm, "_
        &" EE.PTeamGbNm, "_
        &" EE.levelNm "_
        &"  from sd_TennisTitle AA "_
        &" inner join  "_
        &" 	( "_
        &" 	select  "_
        &" 		GameTitleIDX "_
        &" 		,gameno "_
        &" 		,gbidx  "_
        &" 	from tblRGameLevel where DelYN = 'N' "_
        &" 	group by GameTitleIDX,gameno,gbidx "_
        &" 	) BB on AA.GameTitleIDX = BB.GameTitleIDX "_
        &" inner join sd_RidingBoard CC on AA.GameTitleIDX = CC.titleIDX and BB.gameno = CC.levelNo "_
        &" left join sd_RidingBoard_c DD on CC.seq = DD.seq "_
        &" left join tblTeamGbInfo EE on BB.GbIDX = EE.TeamGbIDX "_
        &" where AA.DelYN = 'N' "_
        &" "& whereSQL &" "_
        &" order by GameTitleIDX desc,idx desc"
'				response.write sql
'				response.end
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  strjson = ""
  If Not rs.eof Then
    do until rs.eof
			if vidxsearch <> "" then
				if isnull(rs("Thumbnail")) = false then
					strjson = strjson & ",{""url"":"""& rs("idx") &""",""movieimg"":"""& rs("Thumbnail") &""",""title"":"""& rs("title") &""",""sno"":"""& rs("readnum") &"""}"
				end if
			Else
				if idx <> "" then
	        sqlupdate = "update sd_RidingBoard_c set readnum = readnum+1 where idx = '"& rs("idx") &"' "
	        Call db.execSQLRs(sqlupdate , null, ConStr)
	        strjson = strjson & ",{""movieurl"":""https://www.youtube.com/watch?v="& rs("filename") &""",""title"":"""& rs("GameTitleName") &""",""txt"":"""& rs("title") &""",""sno"":"""& rs("readnum") &"""}"
				Else
					if isnull(rs("Thumbnail")) = false then
						strjson = strjson & ",{""url"":"""& rs("idx") &""",""movieimg"":"""& rs("Thumbnail") &""",""title"":"""& rs("title") &""",""sno"":"""& rs("readnum") &"""}"
					end if
	      end if
			end if
      rs.movenext
    loop
		if strjson <> "" then
    	Response.Write "{""jlist"":["& mid(strjson,2) &"]}"
		else
			Response.Write "{""jlist"":""nodata""}"
		end if
  Else
    Response.Write "{""jlist"":""nodata""}"
  End if



%>
