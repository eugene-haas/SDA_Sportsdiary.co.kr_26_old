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
    gameno = fInject(oJSONoutput.gno)
  End if

  '경기진행state
  function gamestatus(val)
    Select Case CDbl(val)
      case 1
        gamestatus = "경기예정"
      case 2
        gamestatus = "경기중"
      case 3
        gamestatus = "경기종료"
    end select
  end function

  '마장마술지점state
  function majangstatus(val)
    Select Case CDbl(val)
      case 1
        majangstatus = "B"
      case 2
        majangstatus = "E"
      case 3
        majangstatus = "M"
      case 4
        majangstatus = "C"
      case 5
        majangstatus = "H"
    end select
  end function

  '기권state
  function givupstatus(val)
    if val="e" then
        givupstatus = "E"
    elseif val="r" then
        givupstatus = "R"
    elseif val="w" then
        givupstatus = "W"
    elseif val="d" then
        givupstatus = "D"
    else
        givupstatus = null
    end if
  end function

  '체전 및 장애물 일부 네임테그 state
  function nameTagstatus(val,val2,val3)
    teamnametag = ""
    if val = "Y" then
      if val3 = CONST_TYPEA1 or val3 = CONST_TYPEA2 or val3 = CONST_TYPEA_1 then
        if val2 = "1" then
          teamnametag = "1라운드"
        elseif val2 = "2" then
          teamnametag = "2라운드"
        elseif val2 = "3" then
          teamnametag = "최종결과"
        else
          teamnametag = "재경기"& (cint(val2)-3)
        end if
      end if
    else
      if val3 = CONST_TYPEA1 or val3 = CONST_TYPEA2 then
        if val2 = "1" then
          teamnametag = ""
        else
          teamnametag = "재경기"
        end if
      end if
    end if
    nameTagstatus = teamnametag
  end function

  '문자열 앞에 붙이기
  function strLenCheck(val,val2,val3)
    tempTXT = ""
    if isnull(val) then val = ""
    if len(val) < Cint(val3) Then
      for i=1 to Cint(val3) - len(val)
        tempTXT = tempTXT & val2
      next
      tempTXT = tempTXT & val
    else
      tempTXT = val
    end if
    strLenCheck = tempTXT
  end function

If tidx <> "" then
  selectCheck = "select stateno from sd_TennisTitle where GameTitleIDX = '"& tidx &"' and stateno = 1 "
  Set rsCheck = db.ExecSQLReturnRS(selectCheck , null, ConStr)
  if rsCheck.eof then
    response.write "{""jlist"": ""nodata""}"
    response.end
  end if
  set rsCheck = nothing

  'title 가져오기
  sqltitle = "select "_
          	&" AA.gameno, "_
          	&" DD.TeamGbNm +' '+ DD.levelNm +' '+ DD.ridingclass +' '+ DD.ridingclasshelp as titlename, "_
          	&" (select top 1 a.gametime from tblRGameLevel a where a.DelYN = 'N' and AA.gameno = a.gameno and CC.GameTitleIDX = a.GameTitleIDX order by a.RGameLevelidx) as sgametime, "_
          	&" (select top 1 b.gametimeend from tblRGameLevel b where b.DelYN = 'N' and AA.gameno = b.gameno and CC.GameTitleIDX = b.GameTitleIDX order by b.RGameLevelidx) as egametime "_
          	&" from sd_TennisTitle CC "_
          	&" inner join  tblRGameLevel AA on CC.GameTitleIDX = AA.GameTitleIDX "_
          	&" left join tblTeamGbInfo DD on AA.GbIDX = DD.TeamGbIDX "_
          	&" where CC.DelYN = 'N' and AA.DelYN = 'N' and CC.GameTitleIDX = '"& tidx &"' and AA.gameno = '"& gameno &"' "_
          	&" and AA.GameDay in (select top 1 GameDay from tblRGameLevel where delyn = 'N' and GameTitleIDX  = '"& tidx &"' and gameno = '"& gameno &"' group by GameDay order by gameday) "_
          	&" group by CC.GameTitleIDX,AA.gameno,AA.GbIDX,AA.GameDay,DD.TeamGbNm,DD.levelNm,DD.ridingclass,DD.ridingclasshelp "
  set rstitle = db.ExecSQLReturnRS(sqltitle , null, ConStr)

  toptitle = null
  if not rstitle.eof Then
    toptitle = rstitle.getrows()
  end if
  set rstitle = nothing

  'title 제 i 경기 가져오기
  sqlCount = "select rank() over (order by (select top 1 a.gametime from tblRGameLevel a where a.DelYN = 'N' and AA.gameno = a.gameno and AA.GameTitleIDX = a.GameTitleIDX order by a.RGameLevelidx)) as ranks,gameno, "_
            &" (select top 1 a.gametime from tblRGameLevel a where a.DelYN = 'N' and AA.gameno = a.gameno and AA.GameTitleIDX = a.GameTitleIDX order by a.RGameLevelidx) as sgametime "_
            &" from tblRGameLevel AA "_
            &" where DelYN = 'N' and GameTitleIDX = '"& tidx &"' group by GameTitleIDX,gameno"
  set rscount = db.ExecSQLReturnRS(sqlCount , null, ConStr)

  titlecount = null
  if not rscount.eof Then
    titlecount = rscount.getrows()
  end if
  set rscount = nothing

  'player list 가져오기
  sql = "select "_
      &" AA.GameTitleIDX,AA.gameno,BB.PlayerIDX,BB.userName+' / '+CC.userName as userName,BB.noticetitle,BB.pubName+' '+BB.TeamANa as teaminfo,BB.gametime "_
      &" ,AA.judgecnt,AA.judgeshowYN,AA.GbIDX,DD.TeamGb,DD.TeamGbNm,DD.ridingclass,DD.ridingclasshelp "_
      &" ,BB.gamest,BB.[Round],BB.score_sgf,BB.score_1,BB.score_2,BB.score_3,BB.score_4,BB.score_5,BB.score_6,BB.score_total,BB.score_per,BB.boo_orderno,BB.total_order,BB.tryoutgroupno,BB.gubun "_
      &" ,(select kgame from sd_TennisTitle EE where AA.GameTitleIDX = EE.GameTitleIDX) as kgame "_
      &" ,AA.judgeB,AA.judgeE,AA.judgeM,AA.judgeC,judgeH,BB.per_1,BB.per_2,BB.per_3,BB.per_4,BB.per_5,tryoutresult "_
      &" from tblRGameLevel AA "_
      &" inner join sd_tennismember BB on AA.GbIDX = BB.gamekey3 and AA.GameTitleIDX = BB.GameTitleIDX "_
      &" LEFT JOIN sd_tennisMember_partner CC on BB.gameMemberIDX = CC.gameMemberIDX "_
      &" left join tblTeamGbInfo DD on AA.GbIDX = DD.TeamGbIDX "_
      &" where AA.DelYN = 'N' and BB.DelYN = 'N' and DD.DelYN = 'N' and AA.GameTitleIDX = '"& tidx &"' and AA.gameno = '"& gameno &"' "_
      &" group by AA.GameTitleIDX,AA.gameno,BB.PlayerIDX,BB.userName,CC.userName,BB.TeamANa,AA.judgecnt,AA.judgeshowYN,AA.GbIDX,DD.TeamGb,DD.TeamGbNm "_
      &" ,BB.gamest,BB.score_sgf,BB.score_1,BB.score_2,BB.score_3,BB.score_4,BB.score_5,BB.score_6,BB.score_total,BB.score_per,BB.boo_orderno,BB.total_order,BB.pubName,BB.gametime "_
      &" ,DD.ridingclass,DD.ridingclasshelp,BB.[Round],BB.tryoutsortNo,BB.tryoutgroupno,BB.gubun,BB.noticetitle "_
      &" ,AA.judgeB,AA.judgeE,AA.judgeM,AA.judgeC,judgeH,BB.per_1,BB.per_2,BB.per_3,BB.per_4,BB.per_5,tryoutresult "_
      &" order by BB.[Round],BB.tryoutsortNo,BB.tryoutgroupno"
  set rs = db.ExecSQLReturnRS(sql , null, ConStr)
  'response.write sql
  'response.end
  titlecounttxt = ""
  titletimetxt = toptitle(2,0) &" - "& toptitle(3,0)
  titletoptxt = toptitle(1,0)
  if not rs.eof Then
    titlecounttxt = "제"& rs("gameno") & "경기"
    strJson = ""
    Roundcheck = rs("Round")
    countno = "0"
    nochk = 0
    do until rs.eof
      if Roundcheck = rs("Round") then
        if rs("gubun") <> "100" then countno = countno + 1
      else
        if rs("gubun") <> "100" then countno = 1 else countno = 0 end if
        Roundcheck = rs("Round")
        nochk = nochk + 1
        strJson = strJson & ",{""gubun"": ""1"",""txt"": """& nameTagstatus(rs("kgame"),rs("Round"),rs("ridingclasshelp")) &""",""tableinfo"": """",""tabletype"": """"}"
      end if
      nameTag = nameTagstatus(rs("kgame"),rs("Round"),rs("ridingclasshelp"))
      if nameTag <> "" then nameTag = nameTag & "-"
      '기권이 아닐때.
      if isnull(givupstatus(rs("tryoutresult"))) then
        '경기종료가 아닐때
        if rs("gamest") = "1" or rs("gamest") = "2" or rs("gamest") = "4" Then
          sHour = strLenCheck(Hour(rs("gametime")),"0",2)
          sMinute = strLenCheck(Minute(rs("gametime")),"0",2)
          if rs("gubun") = "100" Then
            strJson = strJson & ",{""time"": """& sHour &":"& sMinute &""",""name"": ""공지사항"",""txt"": """& rs("noticetitle") &""",""tabletype"": """",""tableinfo"": """",""no"": """"}"
          else
            '마장마술일때
            if rs("TeamGb") = "20101" or rs("TeamGb") = "20201" Then
              strJson = strJson &",{""time"": """& sHour &":"& sMinute &""",""name"": """& rs("userName") &""",""status"": """& gamestatus(rs("gamest")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": """",""tableinfo"": """",""no"": """& countno &"""}"
            else
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& gamestatus(rs("gamest")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": """",""tableinfo"": """",""no"": """& countno &"""}"
            end if
          end if
        '경기 종료일때
        elseif rs("gamest") = "3" Then
          judgeJson = ""
          scoreJson = ""
          tabletype = ""
          sHour = strLenCheck(Hour(rs("gametime")),"0",2)
          sMinute = strLenCheck(Minute(rs("gametime")),"0",2)
          '마장마술일때
          if rs("TeamGb") = "20101" or rs("TeamGb") = "20201" Then
            '점수노출을원할때
            if rs("judgeshowYN") = "Y" then
              tabletype = "MA"
              for i=1 to 5
                if rs("judge"&majangstatus(i)) = "Y" then scoreJson = scoreJson & ",{""location"": """& majangstatus(i) &""",""grade"": """& rs("per_"&i) &"""}"
              next
              judgeJson = judgeJson & "{""judge"":["& mid(scoreJson,2) &"],""judgeall"": """& rs("score_per") &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
            else
              tabletype = "MB"
              judgeJson = judgeJson & "{""judgeall"": """& rs("score_per") &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
            end if
            strJson = strJson &",{""time"": """& sHour &":"& sMinute &""",""name"": """& rs("userName") &""",""status"": """& gamestatus(rs("gamest")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": """& tabletype &""",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
          '장애물일때
          elseif rs("TeamGb") = "20102" or rs("TeamGb") = "20202" Then
            '장애물 타입별 구분
            if rs("ridingclasshelp") = CONST_TYPEA1 or rs("ridingclasshelp") = CONST_TYPEA2 then
              judgeJson = judgeJson & "{""timeall"": """& rs("score_1") &""",""timeminus"": """& rs("score_2") &""",""disminus"": """& rs("score_3") &""",""minusall"": """& rs("score_total") &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& gamestatus(rs("gamest")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""A"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            elseif rs("ridingclasshelp") = CONST_TYPEB then
              judgeJson = judgeJson & "{""timeall1"": """& rs("score_1") &""",""timeminus1"": """& rs("score_2") &""",""disminus1"": """& rs("score_3") &""",""minusall1"": """& rs("score_total") &""","
              judgeJson = judgeJson & """timeall2"": """& rs("score_4") &""",""timeminus2"": """& rs("score_5") &""",""disminus2"": """& rs("score_6") &""",""minusall2"": """& rs("score_per") &""","
              judgeJson = judgeJson & """rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& gamestatus(rs("gamest")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""2P"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            elseif rs("ridingclasshelp") = CONST_TYPEC then
              judgeJson = judgeJson & "{""timeall"": """& rs("score_1") &""",""minustime"": """& rs("score_2") &""",""totaltime"": """& rs("score_total") &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& gamestatus(rs("gamest")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""C"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            elseif rs("ridingclasshelp") = CONST_TYPEA_1 then
              judgeJson = judgeJson & "{""timeall"": """& rs("score_1") &""",""timeminus"": """& rs("score_2") &""",""disminus"": """& rs("score_3") &""",""minusall"": """& rs("score_total") &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& gamestatus(rs("gamest")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""A"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            else
              '이외 장애물 경기 추가
            end if
          else
            '이외의 경기방식 추가 사항
            '경기가 추가되면 이곳에 정리.
          end if
        end if
      '기권일때
      else
        judgeJson = ""
        scoreJson = ""
        tabletype = ""
        sHour = strLenCheck(Hour(rs("gametime")),"0",2)
        sMinute = strLenCheck(Minute(rs("gametime")),"0",2)
        if rs("gubun") = "100" Then
          strJson = strJson & ",{""time"": """& sHour &":"& sMinute &""",""name"": ""공지사항"",""txt"": """& rs("noticetitle") &""",""tabletype"": """",""tableinfo"": """",""no"": """"}"
        else
          '마장마술일때
          if rs("TeamGb") = "20101" or rs("TeamGb") = "20201" Then
            if rs("judgeshowYN") = "Y" then
              tabletype = "MA"
              for i=1 to 5
                if rs("judge"&majangstatus(i)) = "Y" then scoreJson = scoreJson & ",{""location"": """& majangstatus(i) &""",""grade"": ""-""}"
              next
              judgeJson = judgeJson & "{""judge"":["& mid(scoreJson,2) &"],""judgeall"": """& givupstatus(rs("tryoutresult")) &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
            else
              tabletype = "MB"
              judgeJson = judgeJson & "{""judgeall"": """& givupstatus(rs("tryoutresult")) &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
            end if
            strJson = strJson &",{""time"": """& sHour &":"& sMinute &""",""name"": """& rs("userName") &""",""status"": """& givupstatus(rs("tryoutresult")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": """& tabletype &""",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
          '장애물
          elseif rs("TeamGb") = "20102" or rs("TeamGb") = "20202" Then
            if rs("ridingclasshelp") = CONST_TYPEA1 or rs("ridingclasshelp") = CONST_TYPEA2 then
              judgeJson = judgeJson & "{""timeall"": ""-"",""timeminus"": ""-"",""disminus"": ""-"",""minusall"": """& givupstatus(rs("tryoutresult")) &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& givupstatus(rs("tryoutresult")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""A"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            elseif rs("ridingclasshelp") = CONST_TYPEB then
              judgeJson = judgeJson & "{""timeall1"": ""-"",""timeminus1"": ""-"",""disminus1"": ""-"",""minusall1"": ""-"","
              judgeJson = judgeJson & """timeall2"": ""-"",""timeminus2"": ""-"",""disminus2"": ""-"",""minusall2"": """& givupstatus(rs("tryoutresult")) &""","
              judgeJson = judgeJson & """rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& givupstatus(rs("tryoutresult")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""2P"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            elseif rs("ridingclasshelp") = CONST_TYPEC then
              judgeJson = judgeJson & "{""timeall"": ""-"",""minustime"": ""-"",""totaltime"": """& givupstatus(rs("tryoutresult")) &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& givupstatus(rs("tryoutresult")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""C"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            elseif rs("ridingclasshelp") = CONST_TYPEA_1 then
              judgeJson = judgeJson & "{""timeall"": ""-"",""timeminus"": ""-"",""disminus"": ""-"",""minusall"": """& givupstatus(rs("tryoutresult")) &""",""rankingpart"": """& rs("boo_orderno") &""",""rankingall"": """& rs("total_order") &"""}"
              strJson = strJson &",{""time"": """& toptitle(2,0) &""",""name"": """& nameTag & rs("userName") &""",""status"": """& givupstatus(rs("tryoutresult")) &""",""event"": """& rs("TeamGbNm") &""",""div"": """& rs("teaminfo") &""",""tabletype"": ""A"",""tableinfo"": ["& judgeJson &"],""no"": """& countno &"""}"
            else
              '이외 장애물 경기 추가
            end if
          else
            '그외 경기
          end if
        end if
      end if
      rs.movenext
    loop
    response.write "{""jlist"": [{""no"": """& titlecounttxt &""",""time"": """& titletimetxt &""",""title"": """& titletoptxt &""",""list"": ["& mid(strJson,2) &"]}]}"
  Else
    response.write "{""jlist"": ""nodata""}"
  end if
Else
  response.write "{""jlist"": ""nodata""}"
end if



%>
