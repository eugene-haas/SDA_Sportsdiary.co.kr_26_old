<!--#include file="../Library/ajax_config.asp"-->
<%
	SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  MemberIDX = fInject(Request("MemberIDX"))
  TraiFistCd = fInject(Request("TraiFistCd"))
  GameTitleIDX = ""

  MemberIDX = decode(MemberIDX,0)
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  'SDate = "2016-03-06"
  'EDate = "2017-03-31"
  'PlayerIDX = "1403"

	'Dim LRsCnt1
  'LRsCnt1 = 0

  iType = "152"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Training_Search '" & iType & "','" & iSportsGb & "','" & MemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','" & TraiFistCd & "',''"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

      '차드셋팅=================================================

      retext = "{"
      retext = retext& """chart"": {"
      retext = retext& """numberPrefix"": """","
      retext = retext& """paletteColors"": ""#0075c2"","
      retext = retext& """bgColor"": ""#ffffff"","
      retext = retext& """showBorder"": ""0"","
      retext = retext& """showCanvasBorder"": ""0"","
      retext = retext& """usePlotGradientColor"": ""0"","
      retext = retext& """plotBorderAlpha"": ""10"","
      retext = retext& """placeValuesInside"": ""1"","
      retext = retext& """valueFontColor"": ""#ffffff"","
      retext = retext& """showAxisLines"": ""1"","
      retext = retext& """axisLineAlpha"": ""25"","
      retext = retext& """divLineAlpha"": ""10"","
      retext = retext& """alignCaptionWithCanvas"": ""0"","
      retext = retext& """showAlternateVGridColor"": ""0"","
      retext = retext& """captionFontSize"": ""14"","
      retext = retext& """subcaptionFontSize"": ""14"","
      retext = retext& """subcaptionFontBold"": ""0"","
      retext = retext& """toolTipColor"": ""#ffffff"","
      retext = retext& """toolTipBorderThickness"": ""0"","
      retext = retext& """toolTipBgColor"": ""#000000"","
      retext = retext& """toolTipBgAlpha"": ""80"","
      retext = retext& """toolTipBorderRadius"": ""2"","
      retext = retext& """toolTipPadding"": ""5"" ,"
      retext = retext& """plotTooltext"" : ""훈련종류 :$label<br> $datavalue시간"","
      retext = retext&"""theme"": ""fint"""
      retext = retext&"},"
      '차드셋팅=================================================

      retext = retext&"""data"": ["

    Do Until LRs.Eof

        'LRsCnt1 = LRsCnt1 + 1
        retext = retext&"{""label"": """&LRs("TraiMIdNm")&""",""value"": """&LRs("TTrailHour")&"""},"
        'retext = retext&"{""link"":""JavaScript:chart_sub('"&LRs("TraiFistCd")&"','"&LRs("TraiFistNm")&"')"",""label"": """&LRs("TraiFistNm")&""",""value"": """&LRs("TTrailHour")&"""},"

      LRs.MoveNext
    Loop

    retext = Mid(retext, 1, len(retext) - 1)

    retext = retext&"]"
	  retext = retext&"}"

  else
    
  End If

  LRs.close

  Dbclose()

	Response.Write retext

%>