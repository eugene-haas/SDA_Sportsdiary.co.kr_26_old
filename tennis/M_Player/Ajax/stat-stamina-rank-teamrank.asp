<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
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


  Dim LRsCnt1, iRank1
  LRsCnt1 = 0

  iType = "41"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        'LRsCnt1 = LRsCnt1 + 1
        'Response.Write LRs("TrainingAttandDay")
        iRank1 = LRs("iRank")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  

  Dim LRsCnt2, iRank2
  LRsCnt2 = 0

  iType = "42"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Guage_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','','" & iStimFistCd & "','" & iStimMidCd & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        'LRsCnt2 = LRsCnt2 + 1
        'Response.Write LRs("TrainingAttandDay")
        iRank2 = LRs("iRank")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  Dbclose()



  Dim ip
  
  if CInt(iRank2) = 0 then
  ip = 0
  else
  ip = (CInt(iRank1)/CInt(iRank2)) * 100
  ip = Round(ip,2)
  end if

  retext = "<dt>우리팀 랭킹</dt>"
  retext = retext& "<dd>상위<span class=""redy"">"&ip&"%</span><small>("&iRank1&"등/"&iRank2&"명)</small></dd>"

  Response.Write retext

%>