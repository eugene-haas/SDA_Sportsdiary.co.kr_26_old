<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

	'- iType
	'1 : 선수분석 검색부분 > 대회명
	
	iType = "1"
	'iSportsGb = "judo"

  LSQL = "EXEC Analysis_View '" & iType & "','" & SDate & "','" & iSportsGb & "',''"
	Set LRs = Dbcon.Execute(LSQL)
	Dbclose()

  selData = "<select name=""iMatchTitle"" id=""iMatchTitle"">"

  If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
      selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg("&LRs("GameTitleIDX")&");'>"&LRs("GameTitleName")&"</option>"
	    LRs.MoveNext
		Loop 
	End If 
  
  selData = selData&"</select>"

  Response.Write selData

%>