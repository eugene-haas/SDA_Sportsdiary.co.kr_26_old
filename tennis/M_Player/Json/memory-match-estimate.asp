<!--#include file="../Library/ajax_config.asp"-->
<%
	SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
	GameTitleIDX = ""
  iPlayerIDX = fInject(Request("iPlayerIDX"))
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  '
  'SDate = "2016-01-01"
  'EDate = "2017-12-31"
  'GameTitleIDX = ""
  'iPlayerIDX = "1403"

	'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
  'response.End

  iPlayerIDX = decode(iPlayerIDX,0)

  iType = "111"
  'iSportsGb = "judo"

  Dim LRsCnt1
  LRsCnt1 = 0

  LSQL = "EXEC Memory_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "',''"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

      '차드셋팅=================================================
      retext = "{"
      retext = retext&"""chart"": {"
      retext = retext&"""showValues"": ""1"","
      retext = retext&"""valueFontSize"": ""14"","
      retext = retext&"""valueBgColor"":""#e7eff5"","
      retext = retext&"""valueBorder"": ""1"","
      retext = retext&"""valueBorderColor"": ""#adbfcd"","
      retext = retext&"""valueBorderRadius"": ""4"","
      retext = retext&"""valueBorderPadding"": ""2"","
      retext = retext&"""baseFontSize"": ""12"","
      retext = retext&"""showBorder"": ""0"","
      retext = retext&"""showShadow"": ""0"","
      retext = retext&"""bgColor"": ""#ffffff"","
      retext = retext&"""paletteColors"": ""#a5dcff"","
      retext = retext&"""showCanvasBorder"": ""2"","
      retext = retext&"""showCanvasBorderColor"": ""#ff0000"","
      retext = retext&"""anchorBorderThickness"": ""3"","
      retext = retext&"""anchorRadius"": ""4"","
      retext = retext&"""showAxisLines"": ""0"","
      retext = retext&"""showAlternateHGridColor"": ""0"","
      retext = retext&"""divlineAlpha"": ""100"","
      retext = retext&"""divlineThickness"": ""1"","
      retext = retext&"""divLineIsDashed"": ""1"","
      retext = retext&"""divLineDashLen"": ""1"","
      retext = retext&"""divLineGapLen"": ""1"","
      retext = retext&"""lineThickness"": ""2"","
      retext = retext&"""flatScrollBars"": ""1"","
      retext = retext&"""scrollheight"": ""10"","
      retext = retext&"""numVisiblePlot"": ""5"","
      retext = retext&"""labelStep"": ""2"","
      retext = retext&"""showHoverEffect"": ""1"""
      retext = retext&"},"
      '차드셋팅=================================================


      retext = retext&"""categories"": [{"
      retext = retext&"""category"": ["
  
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        'retext = retext&"{""label"": """&LRs("ResultName")&"""},"
        retext = retext&"{""label"": """&LRs("GmRerdDate")&"""},"

      LRs.MoveNext
		Loop

  retext = Mid(retext, 1, len(retext) - 1)

  retext = retext&"]"
	retext = retext&"}],"

  else
    
	End If

  LRs.close


  iType = "112"
  'iSportsGb = "judo"

  Dim LRsCnt2, iGameRerdIDX
  LRsCnt2 = 0

  LSQL = "EXEC Memory_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "',''"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"""dataset"": ["


	  retext = retext&"{"
	  'retext = retext&"""seriesname"": ""좌측기술"","
	  retext = retext&"""data"": ["

		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1
        'retext = retext&"{""label"": """&LRs("ResultName")&"""},"
        iGameRerdIDX = encode(LRs("GameRerdIDX"),0)
        retext = retext&"{""link"":""JavaScript:chart_sub('"&LRs("GmRerdDate")&"','"&iGameRerdIDX&"')"",""value"": """&LRs("AsmtMarkPoint")&"""},"

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
