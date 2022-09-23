<!--#include file="../Library/ajax_config.asp"-->
<%

  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  MemberIDX = fInject(Request("MemberIDX"))
  GameTitleIDX = ""

  MemberIDX = decode(MemberIDX,0)

  'SDate = "2016-03-06"
  'EDate = "2017-03-31"
  'PlayerIDX = "1403"
	
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 


  'Dim LRsCnt1
  'LRsCnt1 = 0

  iType = "31"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Training_Search '" & iType & "','" & iSportsGb & "','" & MemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','',''"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    '차드셋팅=================================================
	    retext = "{"
	    retext = retext&"""chart"": {"
	    retext = retext&"""startingAngle"": ""80"","
	    '그래프에 라벨 노출
	    retext = retext&"""showLabels"": ""0"","
	    retext = retext&"""showLegend"":""1"","
	    retext = retext&"""enableMultiSlicing"": ""0"","
	    '원크기
 	    retext = retext&"""slicingDistance"": ""1"","
	    '퍼센트표시
	    retext = retext&"""showPercentValues"": ""1"","
	    retext = retext&"""showPercentInTooltip"": ""0"","
	    '해당그래프 클릭시 말풍선값
 	    'retext = retext&"""plotTooltext"": ""참석유형 : $label<br> $datavalue일"","
      retext = retext&"""plotTooltext"": ""사용시간 : $datavalue일"","
	    retext = retext&"""theme"": ""fint"""
	    retext = retext&"},"
	  '차드셋팅=================================================


	    retext = retext&"""data"": ["

    Do Until LRs.Eof

        'LRsCnt1 = LRsCnt1 + 1
        retext = retext&"{""label"": """&LRs("PceNm")&""",""value"": """&LRs("TTrailDay")&"""},"

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