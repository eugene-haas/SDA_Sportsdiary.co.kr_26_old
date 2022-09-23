<!--#include file="../Library/ajax_config.asp"-->
<%

  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  Fnd_KeyWord = fInject(Request("Fnd_KeyWord"))
  Level = fInject(Request("Level"))

  Fnd_KeyWord = decode(Fnd_KeyWord,0)
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  'SDate = "2016-03-06"
  'EDate = "2017-03-31"
  'iPlayerIDX = "7902"

  Dim LRsCnt1
  LRsCnt1 = 0

  iType = "12"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','','','','" & Level & "','','" & Fnd_KeyWord & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    '차드셋팅=================================================
     retext = "{"
     retext = retext&"""chart"": {"
     'retext = retext&"""xAxisname"": ""점수"","
     'retext = retext&"""yAxisName"": ""시간대"","
     retext = retext&"""paletteColors"": ""#219af5, #ffb605"","
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
        retext = retext&"{""label"": """&LRs("ResultName")&"""},"

      LRs.MoveNext
    Loop

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"
    retext = retext&"}],"

  else
    
  End If

  LRs.close


  Dim LRsCnt2
  LRsCnt2 = 0

  iType = "13"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','','','','" & Level & "','','" & Fnd_KeyWord & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"""dataset"": ["
    retext = retext&"{"
    retext = retext&"""seriesname"": ""득점"","
    retext = retext&"""data"": ["

    Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1

        retext = retext&"{""value"": """&LRs("Jumsu")&"""},"

        LRs.MoveNext
    Loop

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"
    retext = retext&"},"

  else
      
  End If

  LRs.close

  


  Dim mLRsCnt2
  mLRsCnt2 = 0

  iType = "14"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','','','','" & Level & "','','" & Fnd_KeyWord & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"{"
    retext = retext&"""seriesname"": ""실점"","
    retext = retext&"""data"": ["
    
    Do Until LRs.Eof

        mLRsCnt2 = mLRsCnt2 + 1

        retext = retext&"{""value"": """&LRs("Jumsu")&"""},"

        LRs.MoveNext
    Loop

    retext = Mid(retext, 1, len(retext) - 1)
    retext = retext&"]"
    retext = retext&"}"
    retext = retext&"]"
    retext = retext&"}"

  else
      
  End If

  LRs.close


  Dbclose()

  Response.Write retext
%>