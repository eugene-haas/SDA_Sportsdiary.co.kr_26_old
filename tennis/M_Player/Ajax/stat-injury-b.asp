<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iMemberIDX = fInject(Request("iMemberIDX"))
	GameTitleIDX = ""
	
	iMemberIDX = decode(iMemberIDX,0)
  
  'SDate = "2017-01-01"
  'EDate = "2017-12-31"
  'iMemberIDX = "42"

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "iMemberIDX="&iMemberIDX&"<br>"
  'response.End
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 


  Dim LRsCnt1 , iJRPubCode1 , iPubName1 , iICnt1
  LRsCnt1 = 0
  
  iType = "3"
  'iSportsGb = "judo"

  LSQL = "EXEC stat_injury_Search '" & iType & "','" & iSportsGb & "','" & iMemberIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

      LRsCnt1 = LRsCnt1 + 1
      iJRPubCode1 = iJRPubCode1&"^"&LRs("JRPubCode")&""
      iPubName1 = iPubName1&"^"&LRs("PubName")&""
      iICnt1 = iICnt1&"^"&LRs("ICnt")&""

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  Dbclose()

	
%>

<input type="hidden" id="LRsCnt1" value="<%=LRsCnt1 %>" />
<input type="hidden" id="iJRPubCode1" value="<%=iJRPubCode1 %>" />
<input type="hidden" id="iPubName1" value="<%=iPubName1 %>" />
<input type="hidden" id="iICnt1" value="<%=iICnt1 %>" />

