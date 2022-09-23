<%
'#############################################
'월 경기일정
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

  If hasown(oJSONoutput, "MS") = "ok" then
    MS = fInject(oJSONoutput.MS)
  Else
    MS = ""
  End if

  if YS = "" then YS = year(date())
  if MS = "" then MS = month(date())

  Ycheck = false
  Mcheck = false

  if len(YS) = 4 then Ycheck = true
  if len(MS) > 0 and len(MS) < 3 then Mcheck = true


  if fn_TextCheck(YS,pattern_number) and fn_TextCheck(MS,pattern_number) and Ycheck and Mcheck Then

'ys = "2020"
'ms = "11"

	if len(MS) < 2 then MS = "0"& MS
    sql = "select "_
    &" AA.GameTitleIDX, "_
    &" AA.GameTitleName, "_
    &" convert(varchar(10),AA.GameS,120) as GameS, "_
    &" convert(varchar(10),AA.GameE,120) as GameE, "_
    &" AA.GameArea "_
    &" from sd_GameTitle AA "_
    &" where AA.DelYN = 'N' and ViewStateM = 'Y' "_
    &" and (convert(varchar(7), AA.GameS,120) = '"& YS &"-"& MS &"' or convert(varchar(7), AA.GameE,120) = '"& YS &"-"& MS &"') "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




    strjson = ""
    if not rs.eof Then
      do until rs.eof
        strjson = strjson & ",{""id"": """& rs("GameTitleIDX") &""",""title"": """& rs("GameTitleName") &""",""url"": """",""start"": """& rs("GameS") &""",""end"": """& dateadd("d",1,rs("GameE")) &""",""EnterType"": """",""poplink"":""""}"
        rs.movenext
      loop
      response.write "{""jlist"": ["& mid(strjson,2) &"]}"
    Else
      response.write "{""jlist"": [{""id"": """",""title"": """",""url"": """",""start"": """",""end"": """",""EnterType"": """",""poplink"":""""}]}"
    end if
  Else
    response.write "{""jlist"": [{""id"": """",""title"": """",""url"": """",""start"": """",""end"": """",""EnterType"": """",""poplink"":""""}]}"
  end if

  set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
