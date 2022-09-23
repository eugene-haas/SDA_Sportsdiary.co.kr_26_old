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

'hostname 주최
'subjectnm	주관
'afternm 후원


		fld = " gametitlename, games, gamee,GameArea, hostname,subjectnm,afternm "
		fld = fld & ", (SELECT  STUFF(( select top 10 ','+ CDANM from tblRGameLevel where GameTitleIDX = a.gametitleidx group by CDANM for XML path('') ),1,1, '' ))  as cdanm " '대회 종목들
		fld = fld & ", viewYN, MatchYN " '참가신청, 대진표(경기순서노출)



'		fld = fld & ", (SELECT resultopenYN from tblRGameLevel where GameTitleIDX = a.gametitleidx group by CDANM for XML path('') ),1,1, '' ))  as cdanm " 결과노출완료

		
		SQL = "select top 4 "&fld&" from sd_gameTitle as a where gametitleIDX = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			response.write "{""jlist"": ""nodata""}"
		else
			title = rs(0)
			games = Split(Left(rs(1),10),"-")
			'weeks = weekday(Left(rs(1),10))
			gamee = Split(Left(rs(2),10),"-")
			'weeke = weekday(Left(rs(2),10))
			GameArea = rs(3)
			hostname = rs(4)
			subjectnm = rs(5)
			afternm = rs(6)
			cdanm = rs(7)
			viewYN = rs(8)
			MatchYN = rs(9)

			title_day = games(0)& "년 " & games(1)& "월 " & games(2)& "일 " & weeks & " ~ " &   gamee(0)& "년 " & gamee(1)& "월 " & gamee(2)& "일 " & weeke

			Call oJSONoutput.Set("title", title )	
			Call oJSONoutput.Set("title_day", title_day )	
			Call oJSONoutput.Set("location",  GameArea)	

			Call oJSONoutput.Set("host",  hostname)	 '주최
			Call oJSONoutput.Set("superviser",  subjectnm)	 '주관
			Call oJSONoutput.Set("sponsor",  afternm)	'후원
			Call oJSONoutput.Set("cdanm",  cdanm)	
			Call oJSONoutput.Set("tidx",  tidx)

			Call oJSONoutput.Set("appli",  "end") '참가신청같은데 여기서 안받는다.

			Call oJSONoutput.Set("videolen",  "0")
			Call oJSONoutput.Set("imglen",  "0")
			Call oJSONoutput.Set("playtime",  "1")

			Call oJSONoutput.Set("attyn", viewYN )
			Call oJSONoutput.Set("matchyn",  MatchYN)


			strjson = JSON.stringify(oJSONoutput)
			strjson = "{""jlist"":[" & strjson & "]}"
			Response.Write strjson
		End if

	Set rs = Nothing
	db.Dispose
	Set db = Nothing	


Response.end





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
    &" where AA.DelYN = 'N' and ViewState = 'Y' "_
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

'      strjson = strjson & """title_day"": """& datas(0) &"년 "& datas(1) &"월 "& datas(2) &"일 ~"& datae(0) &"년 "& datae(1) &"월 "& datae(2) &"일"" ,"

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
			strjson4 = strjson4 & """playtime"": """& rs("stateNo") &""""
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
