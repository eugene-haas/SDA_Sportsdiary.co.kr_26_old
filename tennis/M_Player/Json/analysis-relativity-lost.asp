<!--#include file="../Library/ajax_config.asp"-->
<%
	SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  iPlayerIDX = fInject(Request("PlayerIDX"))
  GameTitleIDX = fInject(Request("GameTitleIDX"))

  iPlayerIDX = decode(iPlayerIDX,0)

  'iPlayerIDX = "1403"
  'SDate = "2016-01-01"
  'EDate = "2016-12-31"
  
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

  LSQL = "EXEC Analysis_Relativity_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "',''"
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
    retext = retext&"""paletteColors"": ""#bf1f1e,#244e71,#272727"","
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
    retext = retext&"""legendItemFontSize"": ""14"","
    retext = retext&"""labelBgColor"": ""#e7eff5"","
    retext = retext&"""labelBorderColor"": ""#adbfcd"","
    retext = retext&"""labelBorderRadius"": ""4"","
    retext = retext&"""labelBorderPadding"": ""6"""
    retext = retext&"},"
    '차드셋팅=================================================


    retext = retext&"""categories"": [{"
    retext = retext&"""category"": ["
    
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        retext = retext&"{""link"":""JavaScript:chart_sub('"&LRs("SpecialtyGbName")&"')"",""label"": """&LRs("SpecialtyGbName")&"""},"

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

  iType = "13"

  LSQL = "EXEC Analysis_Relativity_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "',''"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"""dataset"": ["

	  retext = retext&"{"
	  retext = retext&"""seriesname"": ""우측기술"","
	  retext = retext&"""data"": ["
    
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        retext = retext&"{""value"": """&LRs("Jumsu")&"""},"

      LRs.MoveNext
		Loop

    if LRsCnt2 < 4 then
      for i = 3 to LRsCnt1 step -1
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

  iType = "12"

  LSQL = "EXEC Analysis_Relativity_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "',''"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"{"
	  retext = retext&"""seriesname"": ""좌측기술"","
	  retext = retext&"""data"": ["
    
		Do Until LRs.Eof

        LRsCnt3 = LRsCnt3 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        retext = retext&"{""value"": """&LRs("Jumsu")&"""},"

      LRs.MoveNext
		Loop

    if LRsCnt3 < 4 then
      for i = 3 to LRsCnt1 step -1
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
