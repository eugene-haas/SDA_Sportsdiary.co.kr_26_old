<!--#include file="../Library/ajax_config_26.asp"-->
<%
	Check_Login()
	
	iSportsGb = fInject(Request("SportsGb"))
	SDate = fInject(Request("SDate"))
	EnterType = fInject(Request("EnterType"))

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  iType = "1"

  LSQL = "EXEC Analysis_Search '" & iType & "','" & SDate & "','" & iSportsGb & "','" & EnterType & "','','','','','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)
	Dbclose()

  'selData = "<select name=""iMatchTitle"" id=""iMatchTitle"" class=""search-date"" onchange='javascript:iMatch_chg();'>"
  selData = "<select name=""iMatchTitle"" id=""iMatchTitle"" class=""search-date"">"
  selData = selData&"   <option value='00'>전체</option>"
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