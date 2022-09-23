<!--#include file="../dev/dist/config.asp"-->
<%
   	'임원직책 정보 조회
	 
	dim attname		: attname = fInject(Request("attname"))	
	dim code		: code    = fInject(Request("code"))
	
	dim CSQL, CRs
	dim RE_DATA
	dim strCode, valCode(3)
 
	IF len(code) > 3 Then
	 	strCode = Split(code, ",")
	 	valCode(1) = strCode(0)
	 	valCode(2) = strCode(1)
	 	valCode(3) = strCode(2)
	End IF 
	 
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class=""title_select"">"
	RE_DATA = RE_DATA & "<option value=''>:: 임원직책 선택 ::</option>"				
										 
	CSQL = "		SELECT CateOfficersIDX"
	CSQL = CSQL & "		,OfficerNm "
	CSQL = CSQL & "		,OfficerEnNm "
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblCateOfficers] "
	CSQL = CSQL & "	WHERE DelYN = 'N' "
	CSQL = CSQL & "		AND ViewYN = 'Y' "
	CSQL = CSQL & "		AND AssoCode = '"&valCode(1)&"' "											
	CSQL = CSQL & "		AND CateSuccessiveIDX = '"&valCode(2)&"' "																								   
	CSQL = CSQL & "	ORDER BY Orderby, OfficerNm"
	
	SET CRs = DBCon.Execute(CSQL)
	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
													
			If valCode(3) = CStr(CRs("CateOfficersIDX")) Then    																		
				RE_DATA = RE_DATA & "<option value='"&CRs("CateOfficersIDX")&"' selected>"&ReHtmlSpecialChars(CRs("OfficerNm"))&"</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&CRs("CateOfficersIDX")&"'>"&ReHtmlSpecialChars(CRs("OfficerNm"))&"</option>"	
			End If 

			CRs.MoveNext
		Loop 
	End If 
																	 
	RE_DATA = RE_DATA & "</select>"

	Response.Write RE_DATA
	
	DBClose()
%>