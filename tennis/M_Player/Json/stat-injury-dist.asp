<!--#include file="../Library/ajax_config.asp"-->
<%

  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  MemberIDX = fInject(Request("MemberIDX"))
  GameTitleIDX = ""

  MemberIDX = decode(MemberIDX,0)

  'SDate = "2016-01-01"
  'EDate = "2017-12-31"
  'MemberIDX = "42"

  'Dim LRsCnt1
  'LRsCnt1 = 0
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC stat_injury_Search '" & iType & "','" & iSportsGb & "','" & MemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    '차드셋팅=================================================
	   retext = "{"
	   retext = retext&"""chart"": {"
	   retext = retext&"""startingAngle"": ""120"","
	   '그래프에 라벨 노출
	   retext = retext&"""showLabels"": ""0"","
	   retext = retext&"""showLegend"":""1"","
	   retext = retext&"""enableMultiSlicing"": ""0"","
	   '원크기
	   retext = retext&"""slicingDistance"": ""15"","
	   '퍼센트표시
	   retext = retext&"""showPercentValues"": ""1"","
	   retext = retext&"""showPercentInTooltip"": ""0"","
	   '해당그래프 클릭시 말풍선값
	   'retext = retext&"""plotTooltext"": ""부상횟수 : $datavalue회"","
	   retext = retext&"""theme"": ""fint"""
	   retext = retext&"},"
	  '차드셋팅=================================================


	   retext = retext&"""data"": ["

    Do Until LRs.Eof

        'LRsCnt1 = LRsCnt1 + 1
        retext = retext&"{""label"": """&LRs("PubName")&""",""value"": """&LRs("ICnt")&"""},"

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