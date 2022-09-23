<!--#include file="../Library/ajax_config.asp"-->
<%
	SDate = Request("SDate")
	EDate = Request("EDate")
	iStimFistCd = Request("iStimFistCd")
  iStimMidCd = Request("iStimMidCd")
  iMemberIDX = fInject(Request("iMemberIDX"))
  GameTitleIDX = ""

  iMemberIDX = decode(iMemberIDX,0)

  'iStimFistCd = "1"
  'iStimMidCd = "1"
  'SDate = "2016-01-01"
  'EDate = "2017-12-31"
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

	
  Dim LRsCnt1, iMyData1
  LRsCnt1 = 0


  iType = "11"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"

  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        iMyData1 = LRs("StimData")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  Dim LRsCnt2, iAVGData2
  LRsCnt2 = 0


  iType = "12"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"

  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        iAVGData2 = LRs("StimData")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close



  Dim LRsCnt3, iMaxData3
  LRsCnt3 = 0


  iType = "13"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"

  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt3 = LRsCnt3 + 1
        'retext = retext&"{""value"": """&LRs("Jumsu")&"""},"
        iMaxData3 = LRs("StimData")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  Dbclose()

  if LRsCnt1 > 0 then

    '차드셋팅=================================================

    retext = "{"
    retext = retext& """chart"": {"
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
    retext = retext&"""labelFontSize"": ""12"""
    retext = retext&"},"
    '차드셋팅=================================================


    retext = retext&"""data"": ["

    retext = retext&"{""label"": ""동일체급 최대"",""value"": """&iMaxData3&"""},"
    retext = retext&"{""label"": ""동일체급 평균"",""value"": """&iAVGData2&"""},"
    retext = retext&"{""label"": ""본인"",""value"": """&iMyData1&"""}"

    retext = retext&"]"

    retext = retext&"}"

  end if

	Response.Write retext
%>