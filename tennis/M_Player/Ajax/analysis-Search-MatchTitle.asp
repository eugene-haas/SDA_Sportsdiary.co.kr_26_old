<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType = fInject(Request("EnterType"))

  iSportsGb = SportsGb
 '2017-06-26 추가 

	'- iType
	'1 : 선수분석 검색부분 > 대회명
	
	iType = "1"
	'iSportsGb = "judo"

  LSQL = "EXEC Analysis_Search '" & iType & "','" & SDate & "','" & iSportsGb & "','','" & EnterType & "'"
	Set LRs = Dbcon.Execute(LSQL)
	Dbclose()

  selData = "<select name=""iMatchTitle"" id=""iMatchTitle"" onchange='javascript:iMatch_chg();'>"
  selData = selData&"   <option value='00'>:: 전체 ::</option>"
  If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof
      'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg("&LRs("GameTitleIDX")&");'>"&LRs("GameTitleName")&"</option>"
      'selData = selData&"<option value='"&LRs("GameTitleIDX")&"'>"&LRs("GameTitleName")&"</option>"
        'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg();'>"&LRs("GameTitleName")&"</option>"
        selData = selData&"<option value='"&LRs("GameTitleIDX")&"'>"&LRs("GameTitleName")&"</option>"
	    LRs.MoveNext
		Loop 
	End If 
  
  selData = selData&"</select>"

  Response.Write selData

%>