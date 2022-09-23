<!--#include file="../../dev/dist/config.asp"-->
<%

	iType = fInject(Request("iType"))
  CType = fInject(Request("CType"))
	CSubType = fInject(Request("CSubType"))

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iType & "','" & CType & "','" & CSubType & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = DBCon4.Execute(LSQL)

	if iType = "1" then
	selData = "<select name='iTermKey' id='iTermKey' onchange='javascript:iTermKey_chg();'>"
  selData = selData&"   <option value=''>::대분류를 선택하세요::</option>"
	else
	selData = "<select name='iTermMidKey' id='iTermMidKey'>"
	selData = selData&"   <option value=''>::중분류를 선택하세요::</option>"
	end if
	'selData = selData&"   <option value='K00001'>메치기</option>"
  If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof
      'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg("&LRs("GameTitleIDX")&");'>"&LRs("GameTitleName")&"</option>"
      'selData = selData&"<option value='"&LRs("GameTitleIDX")&"'>"&LRs("GameTitleName")&"</option>"
        'selData = selData&"<option value='"&LRs("GameTitleIDX")&"' onclick='javascript:iMatch_chg();'>"&LRs("GameTitleName")&"</option>"
        selData = selData&"<option value='"&LRs("Code")&"'>"&LRs("Name")&"</option>"
	    LRs.MoveNext
		Loop 
	End If 
  
  selData = selData&"</select>"

	LRs.close

	JudoKorea_DBClose()

  Response.Write selData

%>