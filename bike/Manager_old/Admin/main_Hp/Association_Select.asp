<!--#include file="../Library/ajax_config.asp"-->
<%
   	'협회정보 조회
	 
	dim element 	: element = fInject(Request("element"))
	dim attname		: attname = fInject(Request("attname"))	
	dim code		: code    = fInject(Request("code"))
	
	dim CSQL, CRs
	dim RE_DATA
	 
	CSQL = "		SELECT AssociationIDX"
	CSQL = CSQL & "		,AssoCode"
	CSQL = CSQL & "		,AssoNmShort"
	CSQL = CSQL & "		,AssoNm"
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblAssociationInfo]"
	CSQL = CSQL & "	WHERE DelYN = 'N' "
	CSQL = CSQL & "		AND ViewYN = 'Y' "
	CSQL = CSQL & "	ORDER BY Orderby, AssoNm"
	
	SET CRs = DBCon.Execute(CSQL)

	RE_DATA = "<select name='"&attname&"' id='"&attname&"'>"
	RE_DATA = RE_DATA&"<option value=''>:: 협회 선택 ::</option>"				

	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
			If code = CRs("AssoCode") Then 
				RE_DATA = RE_DATA&"<option value='"&CRs("AssoCode")&"' selected>"&ReHtmlSpecialChars(CRs("AssoNm"))&"</option>"	
			Else
				RE_DATA = RE_DATA&"<option value='"&CRs("AssoCode")&"' >"&ReHtmlSpecialChars(CRs("AssoNm"))&"</option>"	
			End If 

			CRs.MoveNext
		Loop 
	End If 
																	 
	RE_DATA = RE_DATA&"</select>"

	Response.Write RE_DATA
	
	DBClose()
%>