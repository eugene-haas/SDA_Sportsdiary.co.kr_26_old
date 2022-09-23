<!--#include file="../Library/ajax_config.asp"-->
<%

  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  iPlayerIDX = fInject(Request("iPlayerIDX"))
  GameTitleIDX = fInject(Request("GameTitleIDX"))

  iPlayerIDX = decode(iPlayerIDX,0)

  'SDate = "2016-03-06"
  'EDate = "2017-03-31"
  'iPlayerIDX = "7902"
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  Dim LRsCnt1
  LRsCnt1 = 0

  iType = "11"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    '차드셋팅=================================================
     retext = "{"
     retext = retext&"""chart"": {"
     retext = retext&"""xAxisname"": ""시간대"","
     retext = retext&"""yAxisName"": ""득실점"","
     retext = retext&"""paletteColors"": ""#219af5, #ffb605"","
     retext = retext&"""formatNumberScale"": ""0"","
     retext = retext&"""toolTipColor"": ""#ffffff"","
     retext = retext&"""toolTipBgColor"": ""#333333"","
     retext = retext&"""theme"": ""fire"""
     retext = retext&"},"
    '차드셋팅=================================================


     retext = retext&"""categories"": [{"
     retext = retext&"""category"": ["

    Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        'retext = retext&"{""link"":""JavaScript:chart_sub('"&LRs("SpecialtyGbName")&"')"",""label"": """&LRs("SpecialtyGbName")&"""},"
        retext = retext&"{""label"": """&Mid(LRs("CheckTime"),2)&"분대""},"

      LRs.MoveNext
    Loop

    retext = retext&"{""label"": ""연장""},"
    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"
    retext = retext&"}],"

  else
    
  End If

  LRs.close


  Dim LRsCnt2, Rname1, Rname2, Rname3
  LRsCnt2 = 0
  Rname1 = ""
  Rname2 = ""
  Rname3 = ""

  iType = "12"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"""dataset"": ["
    retext = retext&"{"
    retext = retext&"""seriesname"": ""득점"","
    retext = retext&"""data"": ["

    Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1

        Rname1 = Rname1&"^"&LRs("CheckTime")&""
        Rname2 = Rname2&"^"&LRs("OverTime")&""
        Rname3 = Rname3&"^"&LRs("Jumsu")&""

        LRs.MoveNext
    Loop
  else
      
  End If

  LRs.close

  Dim Rname1a, Rname2a, Rname3a

  if Rname1 <> "" then
    Rname1a = Split(Rname1, "^")
  end if

  if Rname2 <> "" then
    Rname2a = Split(Rname2, "^")
  end if

  if Rname3 <> "" then
    Rname3a = Split(Rname3, "^")
  end if
  
  if LRsCnt2 > 0 then

    Dim iPOTCnt
    iPOTCnt = 0

    For i = 1 To LRsCnt2

      If Rname2a(i) = 1 Then
        iPOTCnt = iPOTCnt + Rname3a(i)

      End If

    NEXT

    'response.Write "iPOTCnt="&iPOTCnt&"<br>"
    'response.End
    
    For i = 1 To LRsCnt1
      retext = retext&"{""value"": """&Rname3a(i)&"""},"
    NEXT
    retext = retext&"{""value"": """&iPOTCnt&"""}"

    retext = retext&"]"
    retext = retext&"},"

  end if


  Dim mLRsCnt2, mRname1, mRname2, mRname3
  mLRsCnt2 = 0
  mRname1 = ""
  mRname2 = ""
  mRname3 = ""

  iType = "13"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"{"
    retext = retext&"""seriesname"": ""실점"","
    retext = retext&"""data"": ["
    
    Do Until LRs.Eof

        mLRsCnt2 = mLRsCnt2 + 1

        mRname1 = mRname1&"^"&LRs("CheckTime")&""
        mRname2 = mRname2&"^"&LRs("OverTime")&""
        mRname3 = mRname3&"^"&LRs("Jumsu")&""

        LRs.MoveNext
    Loop
  else
      
  End If

  LRs.close

  Dim mRname1a, mRname2a, mRname3a

  if mRname1 <> "" then
    mRname1a = Split(mRname1, "^")
  end if

  if mRname2 <> "" then
    mRname2a = Split(mRname2, "^")
  end if

  if mRname3 <> "" then
    mRname3a = Split(mRname3, "^")
  end if
  

  Dim miPOTCnt
  miPOTCnt = 0

  if mLRsCnt2 > 0 then

    For i = 1 To mLRsCnt2

      If mRname2a(i) = 1 Then
        miPOTCnt = miPOTCnt + mRname3a(i)

      End If

    NEXT

    'response.Write "miPOTCnt="&miPOTCnt&"<br>"
    'response.End
    
    For i = 1 To LRsCnt1
      retext = retext&"{""value"": """&mRname3a(i)&"""},"
    NEXT
    retext = retext&"{""value"": """&miPOTCnt&"""}"

    retext = retext&"]"
  retext = retext&"}"
  
  retext = retext&"]"

  retext = retext&"}"

  end if



  Dbclose()

  Response.Write retext
%>