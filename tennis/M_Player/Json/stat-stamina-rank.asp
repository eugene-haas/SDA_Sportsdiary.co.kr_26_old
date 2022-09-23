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
  'iMemberIDX = "42"
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  Dim LRsCnt1
  LRsCnt1 = 0

  iType = "21"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = "{"
	  retext = retext&"""chart"": {"
    retext = retext&"""showValues"": ""0"","
    'retext = retext&"""numberPrefix"": ""$"","
    retext = retext&"""showBorder"": ""0"","
    retext = retext&"""showShadow"": ""0"","
    retext = retext&"""bgColor"": ""#ffffff"","
    retext = retext&"""paletteColors"": ""#C94444,#FECA34,#0E63AA"","
    retext = retext&"""showCanvasBorder"": ""0"","
    retext = retext&"""showAxisLines"": ""0"","
    retext = retext&"""showAlternateHGridColor"": ""0"","
    retext = retext&"""divlineAlpha"": ""100"","
    retext = retext&"""divlineThickness"": ""1"","
    retext = retext&"""divLineIsDashed"": ""1"","
    retext = retext&"""divLineDashLen"": ""1"","
    retext = retext&"""divLineGapLen"": ""1"","
    retext = retext&"""lineThickness"": ""3"","
    retext = retext&"""flatScrollBars"": ""1"","
    retext = retext&"""scrollheight"": ""10"","
    retext = retext&"""numVisiblePlot"": ""5"","
    retext = retext&"""labelStep"": ""2"","
    retext = retext&"""showHoverEffect"": ""1"""
    retext = retext&"},"

    retext = retext&"""categories"": [{"
	  retext = retext&"""category"": ["
    
		Do Until LRs.Eof

        'LRsCnt1 = LRsCnt1 + 1
        retext = retext&"{""label"": """&LRs("TrRerdDate")&"""},"

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

  iType = "23"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = retext&"""dataset"": ["


	  retext = retext&"{"
	  retext = retext&"""seriesname"": ""동일체급 최대"","
	  retext = retext&"""data"": ["
    
		Do Until LRs.Eof

        'LRsCnt2 = LRsCnt2 + 1
        retext = retext&"{""value"": """&LRs("StimData")&"""},"

      LRs.MoveNext
		Loop
  
    retext = Mid(retext, 1, len(retext) - 1)

    retext = retext&"]"
	  retext = retext&"},"  

  else
    
	End If

  LRs.close



  Dim LRsCnt3
  LRsCnt3 = 0

  iType = "22"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

	  retext = retext&"{"
	  retext = retext&"""seriesname"": ""동일체급 평균"","
	  retext = retext&"""data"": ["
    
		Do Until LRs.Eof

        'LRsCnt3 = LRsCnt3 + 1
        retext = retext&"{""value"": """&LRs("StimData")&"""},"

      LRs.MoveNext
		Loop
  
    retext = Mid(retext, 1, len(retext) - 1)

    retext = retext&"]"
	  retext = retext&"},"  

  else
    
	End If

  LRs.close



  Dim LRsCnt4
  LRsCnt4 = 0

  iType = "21"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

	  retext = retext&"{"
	  retext = retext&"""seriesname"": ""본인"","
	  retext = retext&"""data"": ["
    
		Do Until LRs.Eof

        'LRsCnt4 = LRsCnt4 + 1
        retext = retext&"{""value"": """&LRs("StimData")&"""},"

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