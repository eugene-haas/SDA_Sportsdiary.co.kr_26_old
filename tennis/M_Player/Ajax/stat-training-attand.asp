<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	MemberIDX = fInject(Request("MemberIDX"))
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

  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Training_Search '" & iType & "','" & iSportsGb & "','" & MemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        'LRsCnt1 = LRsCnt1 + 1
        Response.Write LRs("TrainingAttandDay")

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  Dbclose()

%>