<!--#include file="../Library/ajax_config.asp"-->
<%
  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  iMemberIDX = fInject(Request("iMemberIDX"))
  GameTitleIDX = ""

  iMemberIDX = decode(iMemberIDX,0)

  'iMemberIDX = "42"
  'SDate = "2016-01-01"
  'EDate = "2017-12-31"
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  Dim LRsCnt1
  LRsCnt1 = 0


  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','',''"

  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

      '차드셋팅=================================================
      retext = "{"
      retext = retext&"""chart"": {"
      retext = retext&"""captionFontSize"": ""14"","
      retext = retext&"""subcaptionFontSize"": ""14"","
      retext = retext&"""baseFontColor"":""#333333"","
      retext = retext&"""baseFont"": ""Helvetica Neue,Arial"","
      retext = retext&"""subcaptionFontBold"": ""0"","
      retext = retext&"""paletteColors"": ""#008ee4,#6baa01, #ff7e00"","
      retext = retext&"""bgColor"": ""#ffffff"","
      retext = retext&"""radarfillcolor"": ""#ffffff"","
      retext = retext&"""showBorder"": ""0"","
      retext = retext&"""showShadow"": ""0"","
      retext = retext&"""showCanvasBorder"": ""0"","
      retext = retext&"""legendBorderAlpha"": ""0"","
      retext = retext&"""legendShadow"": ""0"","
      retext = retext&"""divLineAlpha"": ""10"","
      retext = retext&"""usePlotGradientColor"": ""0"","
      retext = retext&"""numberPreffix"": ""$"","
      retext = retext&"""labelBorderPadding"": ""5"","
      retext = retext&"""animation"": ""1"","
      retext = retext&"""labelBgColor"": ""#e7eff5"","
      retext = retext&"""legendItemFontSize"": ""16"","
      retext = retext&"""labelBorderColor"": ""#adbfcd"","
      retext = retext&"""labelBorderRadius"": ""5"""
      retext = retext&"},"
      '차드셋팅=================================================


      retext = retext&"""categories"": [{"
      retext = retext&"""category"": ["
    
    Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        retext = retext&"{""link"":""JavaScript:chart_sub('"&LRs("StimFistCd")&"','"&LRs("StimFistNm")&"')"",""label"": """&LRs("StimFistNm")&"""},"

      LRs.MoveNext
    Loop

    if LRsCnt1 < 4 then
      for i = 3 to LRsCnt1 step -1
        retext = retext&"{""label"": """"},"
      next
    end if

    retext = Mid(retext, 1, len(retext) - 1)

    retext = retext&"]"
    retext = retext&"}],"

  else
    
  End If

  LRs.close

  

  Dim LRsCnt2
  LRsCnt2 = 0

  iType = "3"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','',''"
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"""dataset"": ["

    retext = retext&"{"
    retext = retext&"""seriesname"": ""동일체급 최대"","
    retext = retext&"""data"": ["
    
    Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        retext = retext&"{""value"": """&LRs("StimData")&"""},"

      LRs.MoveNext
    Loop

    if LRsCnt2 < 4 then
      for i = 3 to LRsCnt2 step -1
        retext = retext&"{""value"": ""0""},"
      next
    end if

    retext = Mid(retext, 1, len(retext) - 1)

    retext = retext&"]"
    retext = retext&"},"

  else
    
  End If

  LRs.close



  Dim LRsCnt3
  LRsCnt3 = 0

  iType = "2"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','',''"
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"{"
    retext = retext&"""seriesname"": ""동일체급 평균"","
    retext = retext&"""data"": ["
    
    Do Until LRs.Eof

        LRsCnt3 = LRsCnt3 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        retext = retext&"{""value"": """&LRs("StimData")&"""},"

      LRs.MoveNext
    Loop

    if LRsCnt3 < 4 then
      for i = 3 to LRsCnt3 step -1
        retext = retext&"{""value"": ""0""},"
      next
    end if

    retext = Mid(retext, 1, len(retext) - 1)

    retext = retext&"]"
    retext = retext&"},"

  else
    
  End If

  LRs.close



  Dim LRsCnt4
  LRsCnt4 = 0

  iType = "1"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','',''"
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"{"
    retext = retext&"""seriesname"": ""본인"","
    retext = retext&"""data"": ["
    
    Do Until LRs.Eof

        LRsCnt4 = LRsCnt4 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        retext = retext&"{""value"": """&LRs("StimData")&"""},"

      LRs.MoveNext
    Loop

    if LRsCnt4 < 4 then
      for i = 3 to LRsCnt4 step -1
        retext = retext&"{""value"": ""0""},"
      next
    end if

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
