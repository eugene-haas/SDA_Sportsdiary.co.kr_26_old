<%
'#############################################
'메인 뷰
'#############################################
	'request

  Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
    tidx = fInject(oJSONoutput.tidx)
  End if

  If hasown(oJSONoutput, "getDate") = "ok" then
    getDate = Right(fInject(oJSONoutput.getDate),5)
  else
    getDate = ""
  End if

  If hasown(oJSONoutput, "gno") = "ok" then
    gameno = fInject(oJSONoutput.gno)
  else
    gameno = ""
  End if

  if gameno = "undefined" Then
    gameno = ""
  end If
  


  if tidx <> "" then
    
    
    If tidx = DEBUGTIDX Then '테스트    
	selectCheck = "select stateno,kgame from sd_TennisTitle where GameTitleIDX = '"& tidx &"' "
	Else
	selectCheck = "select stateno,kgame from sd_TennisTitle where GameTitleIDX = '"& tidx &"' and stateno = 1 "
	End if
    Set rsCheck = db.ExecSQLReturnRS(selectCheck , null, ConStr)



	
	if rsCheck.eof Then
      response.write "{""jlist"": ""nodata""}"
      response.end
	Else
		kgame = rsCheck(1)
	end if
    set rsCheck = nothing

    whereSQl = whereSQl &" and CC.GameTitleIDX = '"& tidx &"'"
    if getDate <> "" then
	  whereSQl = whereSQl &" and (right(AA.GameDay,5) = '"& getDate &"' or right(left(AA.GameDay2,10),5) = '"& getDate &"')  "
    else
      sqlgameno = ""
      if gameno <> "" Then
         sqlgameno = "and gameno in ("& gameno &")"
      end if
      whereSQl = whereSQl &" and AA.GameDay in (select top 1 GameDay from tblRGameLevel where delyn = 'N' and GameTitleIDX  = '"& tidx &"' "& sqlgameno &" group by GameDay order by GameDay)"
    end if

    whereSubSQl = ""
    if gameno <> "" Then
      whereSQl = whereSQl &" and AA.gameno in ("& gameno &")"
      whereSubSQl = whereSubSQl & " where sortno = 10000 or sortno is null "
    end if

    CountSql = "select rank() over (order by (select top 1 a.gametime from tblRGameLevel a where a.DelYN = 'N' and AA.gameno = a.gameno and AA.GameTitleIDX = a.GameTitleIDX order by a.RGameLevelidx)) as ranks, "_
              &" gameno, "_
              &" (select top 1 a.gametime from tblRGameLevel a where a.DelYN = 'N' and AA.gameno = a.gameno and AA.GameTitleIDX = a.GameTitleIDX order by a.RGameLevelidx) as sgametime "_
              &" from tblRGameLevel AA "_
              &" where DelYN = 'N' and GameTitleIDX = '"& tidx &"' group by GameTitleIDX,gameno"
    Set rs = db.ExecSQLReturnRS(CountSql , null, ConStr)


    CountRs = null
    if not rs.eof Then
      CountRs = rs.getrows()

	  'Call rsdrow(rs)
	  'Response.end
    end if
    set rs = nothing

    sql = "select "_
    &"	table1.* "_
    &"	from ( "_
    &"		select "_
    &"			CC.GameTitleIDX, "_
    &"			CC.GameTitleName, "_
    &"			AA.gameno, "_
    &"			AA.GbIDX, "_
    &"			AA.GameDay as GameDay, "_
    &"			isnull(AA.GameDay2,'') as GameDay2, "_
    &"			DD.TeamGbNm, "_
    &"			DD.levelNm, "_
    &"			DD.ridingclass, "_
    &"			DD.ridingclasshelp, "_
    &"			(select top 1 a.gametime from tblRGameLevel a where a.DelYN = 'N' and AA.gameno = a.gameno and CC.GameTitleIDX = a.GameTitleIDX order by a.RGameLevelidx) as sgametime, "_
    &"			(select top 1 b.gametimeend from tblRGameLevel b where b.DelYN = 'N' and AA.gameno = b.gameno and CC.GameTitleIDX = b.GameTitleIDX order by b.RGameLevelidx) as egametime, "_
    &"			(select top 1 c.RGameLevelidx from tblRGameLevel c where c.DelYN = 'N' and AA.gameno = c.gameno and CC.GameTitleIDX = c.GameTitleIDX order by c.RGameLevelidx) as RGameLevelidx ,"_
    &"			table2.sdatetime, "_
    &"			table2.edatetime, "_
    &"			table2.noticetitle, "_
    &"			isnull(sortno,'10000') as sortno, "_
    &"			gamenostr , left(AA.levelno,3) as levelno , left(AA.levelno,5) as gb "_
    &"		from "_
    &"			sd_TennisTitle CC "_
    &"			inner join tblRGameLevel AA on CC.GameTitleIDX = AA.GameTitleIDX "_
    &"			left join tblTeamGbInfo DD on AA.GbIDX = DD.TeamGbIDX "_
    &"			left join tblgamenotice table2 on AA.RGameLevelidx = table2.RgameLevelIDX "_
    &"		where CC.DelYN = 'N' and AA.DelYN = 'N' "& whereSQl &" "_
    &"		group by CC.GameTitleIDX,CC.GameTitleName,AA.gameno,AA.GbIDX,AA.GameDay,AA.GameDay2  ,AA.levelno,  DD.TeamGbNm,DD.levelNm,DD.ridingclass,DD.ridingclasshelp,table2.sdatetime, table2.edatetime, table2.noticetitle,table2.sortno,AA.gamenostr "_
    &"	) table1 "& whereSubSQl &" "_
	&"	order by GameDay,gameno,sgametime,sortno"

'Response.write sql
'Response.end


If USER_IP = "118.33.86.240" then
'    sql2 =  replace(sql, "GameDay" ,"GameDay2")
'	sql2 = Replace(sql2 , "AA.GameDay2 as GameDay2","AA.GameDay2 as GameDay")
'	sql = sql & " union " & sql2
'
'Response.write sql
'    response.End
End if    

    strjson = ""
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    
	if not rs.eof Then
      countNum = 0
      gamenochk = ""
      do until rs.eof
		
		levelno = rs("levelno") '단체전확인을 위해 추가
		gb = rs("gb") ' teagb 20101....

		If levelno = "202" Then
			groupstr = " (단체)"
		Else
			groupstr = ""		
		End if

        if isnull(rs("sgametime")) = false then
          if isnull(rs("sortno")) or rs("sortno") = "10000" then
            if gamenochk <> rs("gameno") then
              gamenochk = rs("gameno")
              gameno = rs("gamenostr")
			  gameday2 = rs("gameday2")
              if isnull(gameno) or gameno = "" then  gameno = rs("gameno")

			  rclasshelp = rs("ridingclasshelp")
			  If kgame = "Y" and rclasshelp = "FEI 238.2.2" Then
				rclasshelp = "전국체전"
			  End if
				
			  If getDate = Left(gameday2,10) Then
              strjson = strjson & ",{""title"": ""제"& gameno &"경기-2"&groupstr&""",""time"": """& Mid(gameday2,11) &"~ "",""cmt"": """& rs("TeamGbNm") &" "& rs("levelNm") &" "& rs("ridingclass") &" Class "& rclasshelp &""","
			  else
              strjson = strjson & ",{""title"": ""제"& gameno &"경기"&groupstr&""",""time"": """& rs("sgametime") &" - "& rs("egametime") &""",""cmt"": """& rs("TeamGbNm") &" "& rs("levelNm") &" "& rs("ridingclass") &" Class "& rclasshelp &""","
			  End if

              strjson = strjson & " ""playerlist"":"""& rs("gameno") &""",""gidx"": """& rs("GbIDX") &""",""gb"": """& gb &"""}"
            end if
          else
            if Cint(rs("sortno")) > 10000 or Cint(rs("sortno")) < 10000 then
'              response.write rs("sortno")&"//"
              sHour = ""
              eHour = ""
              sMinute = ""
              eMinute = ""
              if len(Hour(rs("sdatetime"))) < 2 then sHour = "0"& Hour(rs("sdatetime")) else sHour = Hour(rs("sdatetime"))
              if len(Hour(rs("edatetime"))) < 2 then eHour = "0"& Hour(rs("edatetime")) else eHour = Hour(rs("edatetime"))
              if len(Minute(rs("sdatetime"))) < 2 then sMinute = "0"& Minute(rs("sdatetime")) else sMinute = Minute(rs("sdatetime"))
              if len(Minute(rs("edatetime"))) < 2 then eMinute = "0"& Minute(rs("edatetime")) else eMinute = Minute(rs("edatetime"))
			  strjson = strjson & ",{""title"": """& rs("noticetitle") &""",""time"":"""& sHour &":"& sMinute &" - "& eHour &":"& eMinute &"""}"
			  
            end if
          end if
        end if
        rs.movenext
      loop
      response.write "{""jlist"": ["& mid(strjson,2) &"]}"
    else
      response.write "{""jlist"": ""nodata""}"

    end if
  else
    response.write "{""jlist"": ""nodata""}"
  end if


%>
