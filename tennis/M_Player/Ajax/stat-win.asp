<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	
	iPlayerIDX = decode(iPlayerIDX,0)
    
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  '
  'SDate = "2016-01-01"
  'EDate = "2016-12-31"
  'GameTitleIDX = "00"
  'iPlayerIDX = "1403"

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
  'response.End

	'retext = retext&"		["



  'retext = retext&"^[""Element"", ""Density"", { role: ""style"" }]"
  'retext = retext&"^[""금메달"", 3, ""#ffc21e""]"
  'retext = retext&"^[""은메달"", 1, ""#bababa""]"
  'retext = retext&"^[""동메달"", 1, ""#caae90""]"



  'retext = retext&"		]"

   'response.Write retext


  Dim LRsCnt1 , Rname1 , Rname2 , Rname3
  LRsCnt1 = 0
  Rname1 = ""
  Rname2 = ""
  Rname3 = ""
  
  iType = "11"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Win_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

      LRsCnt1 = LRsCnt1 + 1
      Rname1 = Rname1&"^"&LRs("TitleResultName")&""
      Rname2 = Rname2&"^"&LRs("TitleCnt")&""
      Rname3 = Rname3&"^"&LRs("TitleResultColor")&""

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  Dbclose()

  Dim Rname1a , Rname2a , Rname3a
  Rname1a = ""
  Rname2a = ""
  Rname3a = ""

  if LRsCnt1 > 0 then
    
    Rname1a = Split(Rname1, "^")
    Rname2a = Split(Rname2, "^")
    Rname3a = Split(Rname3, "^")

    retext = retext&"^"&LRsCnt1&""

    for i = 1 to LRsCnt1
  
      retext = retext&"^"&Rname1a(i)&"^"&Rname2a(i)&"^"&Rname3a(i)&""

    next

  end if


  response.Write retext
	
%>

