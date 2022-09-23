<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	iPlayerResultIdx = fInject(Request("iPlayerResultIdx"))
	iPlayerIDX = decode(fInject(Request("iPlayerIDX")),0)
	
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

	
	Dim LRsCnt1, iFavYN

	LRsCnt1 = 0
	
	iType = "1"
	'iSportsGb = "judo"
  
	LSQL = "EXEC Analysis_Fav_Mod '" & iType & "','" & iSportsGb & "','" & iPlayerResultIdx & "','" & iPlayerIDX & "',''"
	'response.Write "LSQL="&LSQL&"<br>"
	'response.End
	
	Set LRs = Dbcon.Execute(LSQL)
	
	If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
	
		LRsCnt1 = LRsCnt1 + 1
		iFavYN = LRs("FavYN")
	
	  LRs.MoveNext
		Loop
	Else
	
	End If
	
	LRs.close
	
	Dbclose()
	
	response.Write iFavYN

%>