<!--#include file="../Library/ajax_config.asp"-->
<%
  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  GameTitleIDX = fInject(Request("GameTitleIDX"))
  iPlayerIDX = fInject(Request("PlayerIDX"))

  iPlayerIDX = decode(iPlayerIDX,0)
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  '- iType
  '1 : 선수분석>대회득실점>점수별>전체 Y축 명 , 완료
  '2 : 선수분석>대회득실점>점수별>득점,실점 Y축 명 , 완료
  '11 : 선수분석>대회득실점>점수별>득점 , 완료
  '12 : 선수분석>대회득실점>점수별>실점 , 완료

  'retext = retext&"{""label"": ""한판""},"
  'retext = retext&"{""label"": ""절반""},"
  'retext = retext&"{""label"": ""지도""}"

  iType = "1"
  'iSportsGb = "judo"

  Dim LRsCnt1, Rname1, LRsCnt2, Rname2, LRsCnt3, Rname3
  LRsCnt1 = 0
  Rname1 = ""
  LRsCnt2 = 0
  Rname2 = ""
  LRsCnt3 = 0
  Rname3 = ""

  'SDate = "2016-01-01"
  'EDate = "2016-12-31"

  LSQL = "EXEC Analysis_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    '차드셋팅=================================================
   retext = "{"
   retext = retext&"""chart"": {"
   'retext = retext&"""yAxisname"": ""Sales (In USD)"","
   retext = retext&"""paletteColors"": ""#219af5,#ffb605"","
   retext = retext&"""bgColor"": ""#ffffff"","
   retext = retext&"""legendBorderAlpha"": ""0"","
   retext = retext&"""legendBgAlpha"": ""0"","
   retext = retext&"""legendShadow"": ""0"","
   retext = retext&"""legendItemFontSize"": ""16"","
   retext = retext&"""placevaluesInside"":""1"","
   retext = retext&"""valueFontColor"": ""#ffffff"","
   retext = retext&"""alignCaptionWithCanvas"": ""1"","
   retext = retext&"""showHoverEffect"": ""1"","
   retext = retext&"""canvasBgColor"": ""#ffffff"","
   retext = retext&"""captionFontSize"": ""14"","
   retext = retext&"""subcaptionFontSize"": ""14"","
   retext = retext&"""subcaptionFontBold"": ""0"","
   retext = retext&"""divlineColor"": ""#999999"","
   retext = retext&"""divLineIsDashed"": ""1"","
   retext = retext&"""divLineDashLen"": ""1"","
   retext = retext&"""divLineGapLen"": ""1"","
   retext = retext&"""showAlternateHGridColor"": ""0"","
   retext = retext&"""toolTipColor"": ""#ffffff"","
   retext = retext&"""toolTipBorderThickness"": ""0"","
   retext = retext&"""toolTipBgColor"": ""#000000"","
   retext = retext&"""toolTipBgAlpha"": ""80"","
   retext = retext&"""toolTipBorderRadius"": ""2"","
   retext = retext&"""toolTipPadding"": ""5"""
   retext = retext&"},"
  '차드셋팅=================================================


  retext = retext&"""categories"": [{"
  retext = retext&"""category"": ["

    Do Until LRs.Eof
        LRsCnt1 = LRsCnt1 + 1
        If (Rname1 <> LRs("ResultName")) Then
          retext = retext&"{""label"": """&LRs("ResultName")&"""},"
        End if
        Rname1 = LRs("ResultName")
      LRs.MoveNext
    Loop

  retext = Mid(retext, 1, len(retext) - 1)

  retext = retext&"]"
  retext = retext&"}],"

  else
    
  End If

  LRs.close




  iType = "11"

  LSQL = "EXEC Analysis_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  Set LRs = Dbcon.Execute(LSQL)

  'retext = retext&"{""value"": ""50""},"
  'retext = retext&"{""value"": ""20""},"
  'retext = retext&"{""value"": ""12""},"

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"""dataset"": ["

  retext = retext&"{"
  retext = retext&"""seriesname"": ""득점"","
  retext = retext&"""data"": ["

    Do Until LRs.Eof
        LRsCnt2 = LRsCnt2 + 1
        If (Rname2 <> LRs("ResultName")) Then
          'retext = retext&"{""label"": """&LRs("ResultName")&"""},"
          retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        End if
        Rname2 = LRs("ResultName")
      LRs.MoveNext
    Loop

    retext = Mid(retext, 1, len(retext) - 1)

  retext = retext&"]"
  retext = retext&"},"

  else
    
  End If

  LRs.close


  

  iType = "12"

  LSQL = "EXEC Analysis_Match_Point_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  Set LRs = Dbcon.Execute(LSQL)

  'retext = retext&"{""value"": ""50""},"
  'retext = retext&"{""value"": ""20""},"
  'retext = retext&"{""value"": ""12""},"

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"{"
  retext = retext&"""seriesname"": ""실점"","
  retext = retext&"""data"": ["

  'retext = retext&"{""value"": ""20""},"
  'retext = retext&"{""value"": ""10""},"
  'retext = retext&"{""value"": """&LRsCnt&"""}"

    Do Until LRs.Eof
        LRsCnt3 = LRsCnt3 + 1
        If (Rname3 <> LRs("ResultName")) Then
          'retext = retext&"{""label"": """&LRs("ResultName")&"""},"
          'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
          retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        End if
        Rname3 = LRs("ResultName")
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
