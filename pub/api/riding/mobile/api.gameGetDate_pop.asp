<%
'#############################################
'경기일정 팝업
'#############################################
	'request

	Set db = new clsDBHelper

  If hasown(oJSONoutput, "tidx") = "ok" then
    tidx = fInject(oJSONoutput.tidx)
  End if

  If hasown(oJSONoutput, "poplink") = "ok" then
    poplink = fInject(oJSONoutput.poplink)
  End if

  If tidx = DEBUGTIDX Then '테스트
	viewstr = " "
  Else
	viewstr = " and ViewState = 'Y' "
  End if

  if tidx <> "" Then
    sql = "select "_
    &"  AA.GameTitleIDX, "_
    &"  AA.GameTitleName, "_
    &"  convert(varchar(10),AA.GameS,120) as GameS, "_
    &"  convert(varchar(10),AA.GameE,120) as GameE, "_
    &"  AA.GameArea, "_
    &"  BB.gameno, "_
    &"  BB.GbIDX, "_
    &"  CC.TeamGbNm, "_
    &"  BB.attsdate, "_
    &"  BB.attedate, "_
    &"  BB.GameDay, "_
    &"  AA.ViewYN, "_
    &"  (select count(idx) from sd_Tennis_Stadium_Sketch a where AA.GameTitleIDX = a.GameTitleIDX) as photo, "_
    &"  (select count(seq) from sd_RidingBoard b where AA.GameTitleIDX = b.titleIDX) as video, "_
		&"  AA.stateNo, "_
		&"  CC.ridingclass, "_
		&"  CC.ridingclasshelp, "_
		&"  hostname, "_
		&"  subjectnm, "_
		&"  afternm "_
	  &" from sd_TennisTitle AA "_
    &" inner join  "_
    &"  (select  "_
    &"    GameTitleIDX, "_
    &"    gameno, "_
    &"    GbIDX, "_
    &"    convert(varchar(10),attdateS,120) as attsdate, "_
    &"    convert(varchar(10),attdateE,120) as attedate, "_
    &"    GameDay  "_
    &"  from tblRGameLevel where DelYN = 'N' "_
    &"  group by GameTitleIDX,gameno,GbIDX,convert(varchar(10),attdateS,120),convert(varchar(10),attdateE,120),GameDay "_
    &"  ) BB "_
    &" on AA.GameTitleIDX = BB.GameTitleIDX "_
    &" left join tblTeamGbInfo CC on BB.GbIDX = CC.TeamGbIDX "_

	&" where AA.DelYN = 'N' "&viewstr&" "_
    
	&" and AA.GameTitleIDX = '"& tidx &"' order by BB.GameDay,CC.TeamGbNm "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		response.write SQL
'		response.end
    strjson = ""
		strjson2 = ""
		strjson3 = ""
		strjson4 = ""
		strjson5 = ""
		strjson6 = ""
		strjson7 = ""
    if not rs.eof Then

      dayName = "일월화수목금토"
      datas = split(rs("GameS"),"-")
      datae = split(rs("GameE"),"-")

      statusFlag = ""
      statusText = ""
      if rs("ViewYN") = "Y" Then
        if datediff("d",rs("attedate"),date()) > 0 Then
          statusFlag = "end"
        else
          statusFlag = "att"
        end if
      Else
        if datediff("d",rs("attsdate"),date()) < 0 Then
          statusFlag = "plan"
        elseif datediff("d",rs("attedate"),date()) > 0 Then
          statusFlag = "end"
        end if
      end if

      strjson = strjson & "{"
      strjson = strjson & """title"": """& rs("GameTitleName") &""","
      strjson = strjson & """title_day"": """& datas(0) &"년 "& datas(1) &"월 "& datas(2) &"일 ("& left(mid(dayName,datepart("w",rs("GameS"))),1) &")~"& datae(0) &"년 "& datae(1) &"월 "& datae(2) &"일 ("& left(mid(dayName,datepart("w",rs("GameE"))),1) &")"","
      strjson = strjson & """location"": """& rs("GameArea") &""","
			tempattsdate = rs("attsdate")
			tempattedate = rs("attedate")
			tempTeamGbNm = rs("TeamGbNm")
			check = 1
			check2 = 1
			gamedaychk = rs("GameDay")
			strjson2 = strjson2 & ",{""day"": """& replace(rs("GameDay"),"-",".") &"("& left(mid(dayName,datepart("w",rs("GameDay"))),1) &")"", ""names"":[{""name"": """& rs("TeamGbNm") &" "& rs("ridingclass") &" "& rs("ridingclasshelp") &"""} "
			do until rs.eof
				if isnull(rs("attsdate")) = false then
					if tempattsdate <> rs("attsdate") or tempattedate <> rs("attedate") or tempTeamGbNm <> rs("TeamGbNm") Then
						tempattsdate = rs("attsdate")
						tempattedate = rs("attedate")
						tempTeamGbNm = rs("TeamGbNm")
						check = 1
					end if
					if gamedaychk = rs("GameDay") then
						if check2 = 0 then
							strjson2 = strjson2 & ",{""name"": """& rs("TeamGbNm") &" "& rs("ridingclass") &" "& rs("ridingclasshelp") &"""} "
						end if
						if check2 = 1 then check2 = 0
					else
						strjson2 = strjson2 & "]},{""day"": """& replace(rs("GameDay"),"-",".") &"("& left(mid(dayName,datepart("w",rs("GameDay"))),1) &")"", ""names"":[{""name"": """& rs("TeamGbNm") &" "& rs("ridingclass") &" "& rs("ridingclasshelp") &"""} "
						gamedaychk = rs("GameDay")
						if check2 = 1 then check2 = 0
					end if
	'	      strjson2 = strjson2 & ",{""name"": """& rs("TeamGbNm") &" "& rs("ridingclass") &" "& rs("ridingclasshelp") &""",""day"": """& replace(rs("GameDay"),"-",".") &"("& left(mid(dayName,datepart("w",rs("GameDay"))),1) &")""}"
					if check = 1 then
		      	strjson3 = strjson3 & ",{""name"": """& rs("TeamGbNm") &""",""day"": """& replace(rs("attsdate"),"-",".") &"("& left(mid(dayName,datepart("w",rs("attsdate"))),1) &")-"& mid(replace(rs("attedate"),"-","."),6) &"("& left(mid(dayName,datepart("w",rs("attedate"))),1) &")""}"
						check = 0
					end if
				end if
				rs.movenext
			loop
			strjson2 = strjson2 & "]}"
			strjson2 = """gameday"": ["& mid(strjson2,2) &"],"
			strjson3 = """gameapply"": ["& mid(strjson3,2) &"],"
			rs.MoveFirst
			strjson5 = """host"": [{""name"": """& rs("hostname") &"""}],"
			strjson6 = """superviser"": [{""name"": """& rs("subjectnm") &"""}],"
			afternm_arr = split(rs("afternm"),"`")
			afternmJson = ""
			for i = Lbound(afternm_arr) to Ubound(afternm_arr)
				afternmJson = afternmJson & ",{""name"": """& afternm_arr(i) &"""}"
			next
			strjson7 = """sponsor"": ["& mid(afternmJson,2) &"],"

			strjson4 = strjson4 & """appli"": """& statusFlag &""","
		    strjson4 = strjson4 & """videolen"": """& rs("video") &""","
			strjson4 = strjson4 & """imglen"": """& rs("photo") &""","
			strjson4 = strjson4 & """tidx"": """& rs("GameTitleIDX") &""","

			If tidx = DEBUGTIDX Then 'test
			strjson4 = strjson4 & """playtime"": ""1"""
			else
			strjson4 = strjson4 & """playtime"": """& rs("stateNo") &""""
			End if
      strjson4 = strjson4 & "}"
      response.write "{""jlist"": ["& strjson & strjson2 & strjson3 & strjson5 & strjson6 & strjson7 & strjson4 &"]}"
    Else
      response.write "{""jlist"": ""nodata""}"
    end if
  Else
    response.write "{""jlist"": ""nodata""}"
  end if

  set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
