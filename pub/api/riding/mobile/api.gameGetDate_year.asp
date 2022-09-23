<%
'#############################################
'년 경기일정
'#############################################
	'request
  function fn_TextCheck(str, pattern)
    Dim regEx, matches

    set regEx = new RegExp
    regEx.IgnoreCase = true
    regEx.Global = true
    regEx.Pattern = pattern
    set matches = regEx.execute(str)
    if 0 < matches.Count Then
      fn_TextCheck = false
    Else
      fn_TextCheck = true
    end if
  end function

	Set db = new clsDBHelper

  If hasown(oJSONoutput, "YS") = "ok" then
    YS = fInject(oJSONoutput.YS)
  Else
    YS = ""
  End if

  pattern_number = "[^-0-9]"

  if YS = "" then YS = year(date())

  Ycheck = false

  if len(YS) = 4 then Ycheck = true

  if fn_TextCheck(YS,pattern_number) and Ycheck Then

    sql = "select "_
    &"  AA.GameTitleIDX, "_
    &"  AA.GameTitleName, "_
    &"  AA.GameS, "_
    &"  AA.GameE, "_
    &"  AA.GameArea, "_
    &"  BB.gameno, "_
    &"  BB.GbIDX, "_
    &"  CC.TeamGbNm, "_
    &"  BB.attsdate, "_
    &"  BB.attedate, "_
    &"  BB.GameDay, "_
    &"  AA.ViewYN "_
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
    &" and GameYear = '"& YS &"' order by GameDay,gameno "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    strjson = ""
    if not rs.eof Then
      arr_list = rs.getrows()
      arr_m = split("1,2,3,4,5,6,7,8,9,10,11,12",",")
      for i = LBound(arr_m,1) to ubound(arr_m,1)
        strjson_sub = ""
        for j = LBound(arr_list,2) to ubound(arr_list,2)
          if len(arr_m(i)) < 2 then
            checkdate = YS &"-0"& arr_m(i)
          else
            checkdate = YS &"-"& arr_m(i)
          end if
          if left(arr_list(10,j),7) = checkdate then
            statusFlag = ""
            statusText = ""
            if arr_list(11,j) = "Y" Then
              if datediff("d",arr_list(8,j),date()) > 0 and datediff("d",arr_list(9,j),date()) <= 0 then
                statusFlag = "s_apply"
                statusText = "신청중"
              Else
                if datediff("d",arr_list(10,j),date()) < 0 Then
                  statusFlag = "s_dday"
                  statusText = "D-"& datediff("d",date(),arr_list(10,j))
                Elseif datediff("d",arr_list(10,j),date()) = 0 then
                  statusFlag = "s_ing"
                  statusText = "경기중"
                Else
                  statusFlag = "s_end"
                  statusText = "경기종료"
                end if
              end if
            Else
              if datediff("d",arr_list(10,j),date()) < 0 Then
                statusFlag = "s_dday"
                statusText = "D-"& datediff("d",date(),arr_list(10,j))
              Elseif datediff("d",arr_list(10,j),date()) = 0 then
                statusFlag = "s_ing"
                statusText = "경기중"
              Else
                statusFlag = "s_end"
                statusText = "경기종료"
              end if
            end if
            strjson_sub = strjson_sub & ",{""poplink"": """& arr_list(5,j) &""",""class"": """& statusFlag &""",""status"":"""& statusText &""",""title"": """& arr_list(1,j) & "("& arr_list(7,j) &")" &""",""dday"": """& replace(arr_list(10,j),"-",".") &""",""id"": """& arr_list(0,j) &"""}"
          end if
        Next
        strjson_sub = strjson_sub & ""
        if strjson_sub = "" Then
          strjson_sub = """nodata"""
        Else
          strjson_sub = "["& mid(strjson_sub,2) &"]"
        end if
        strjson = strjson & ",{""mm"": """& arr_m(i) &""",""mminfo"": "& strjson_sub &"}"
      Next
      response.write "{""jlist"": [{""month"":["& mid(strjson,2) &"]}]}"
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
