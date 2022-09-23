<!--#include file="../../dev/dist/config.asp"-->
<%

	iType = fInject(Request("iType"))
  CType = fInject(Request("CType"))
	CType = "Subscription_Section"
	CSubType = fInject(Request("CSubType"))
	
	CPosition = fInject(Request("CPosition"))

	'response.Write "iType="&iType&"<br>"
	'response.Write "CType="&CType&"<br>"
	'response.Write "CSubType="&CSubType&"<br>"
	'response.Write "CPosition="&CPosition&"<br>"
  'response.End

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iType & "','" & CType & "','" & CSubType & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = DBCon4.Execute(LSQL)
	
	if CPosition = "S" then
	
		selData = "<select name='selss' id='selss' class='title_select'>"
		'selData = selData&"<option value=''>시작호</option>"
	
		If Not (LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof
		    'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg("&LRs("GameTitleIDX")&");'>"&LRs("GameTitleName")&"</option>"
		    'selData = selData&"<option value='"&LRs("GameTitleIDX")&"'>"&LRs("GameTitleName")&"</option>"
		      'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg();'>"&LRs("GameTitleName")&"</option>"
		      selData = selData&"<option value='"&LRs("Code")&"'>"&LRs("Name")&"</option>"
		    LRs.MoveNext
			Loop 
		End If
	
	else
	
		selData = "<select name='seles' id='seles' class='title_select'>"
		'selData = selData&"<option value=''>종료호</option>"
	
		If Not (LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof
		    'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg("&LRs("GameTitleIDX")&");'>"&LRs("GameTitleName")&"</option>"
		    'selData = selData&"<option value='"&LRs("GameTitleIDX")&"'>"&LRs("GameTitleName")&"</option>"
		      'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg();'>"&LRs("GameTitleName")&"</option>"
		      selData = selData&"<option value='"&LRs("Code")&"'>"&LRs("Name")&"</option>"
		    LRs.MoveNext
			Loop 
		End If
	
	end if
  
  selData = selData&"</select>"
	
	LRs.close
	
  Response.Write selData

%>