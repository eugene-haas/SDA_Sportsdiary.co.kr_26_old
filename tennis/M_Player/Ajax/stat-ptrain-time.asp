<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
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

  Dim LRsCnt1, iTTrailHour
  LRsCnt1 = 0

  iType = "42"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Training_Search '" & iType & "','" & iSportsGb & "','" & MemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        iTTrailHour = LRs("TTrailHour")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  Dbclose()

  '로직변경으로 아래 로직 수정
  'Dim iTTrailHoura, iTTrailHourT
  '
  'if iTTrailHour <> "" then
  '  iTTrailHoura = Split(iTTrailHour, ".")
  'end if
  '
  ''response.Write Instr(iTTrailHour,",")
  ''response.End
  '
  'if Instr(iTTrailHour,",") = 0 then
  '  iTTrailHourT = iTTrailHoura(0)&"시간"
  'else
  '  iTTrailHourT = iTTrailHoura(0)&"시간 30분"
  'end if
  

  Dim iTTrailHourT, iTTrailHour1, iTTrailHour2
  iTTrailHourT = 0
  iTTrailHour1 = 0

  iTTrailHour1 = iTTrailHour \ 60
  iTTrailHour2 = iTTrailHour mod 60

  if iTTrailHour2 = 0 then
    iTTrailHourT = iTTrailHour1&"시간"
  else
    iTTrailHourT = iTTrailHour1&"시간 "&iTTrailHour2&"분"
  end if



	'해당 총 훈련시간 SQL
	Response.Write iTTrailHourT
%>