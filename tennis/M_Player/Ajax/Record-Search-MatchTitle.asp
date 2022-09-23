<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EnterType = fInject(Request("EnterType"))

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  iType = "1"
  iSportsGb = "judo"

  LSQL = "EXEC Analysis_Search '" & iType & "','" & SDate & "','" & iSportsGb & "','','" & EnterType & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)
	Dbclose()

  'selData = "<select name=""iMatchTitle"" id=""iMatchTitle"" class=""search-date"" onchange='javascript:iMatch_chg();'>"
  selData = "<select name=""iMatchTitle"" id=""iMatchTitle"" class=""search-date"">"
  selData = selData&"   <option value='00'>::대회명을 선택하세요::</option>"
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