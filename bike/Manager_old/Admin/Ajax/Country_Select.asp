<!--#include file="../dev/dist/config.asp"-->
<%
   	'국가정보 조회
	 
	dim attname		: attname = fInject(Request("attname"))	
	dim code		: code    = fInject(Request("code"))
	 
	dim CSQL, CRs
	dim RE_DATA
 
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class=""title_select in_4"">"
	RE_DATA = RE_DATA & "<option value=''>국가</option>"		
									   
	CSQL = "		SELECT ct_serial"
	CSQL = CSQL & "		,CountryEnNm + '(' + CountryNm + ')' CountryInfo"	
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblCountryInfo]"
	CSQL = CSQL & "	WHERE DelYN = 'N' "
	CSQL = CSQL & "	ORDER BY CountryEnNm, CountryNm"
	
'	response.write CSQL
												 
	SET CRs = DBCon.Execute(CSQL)
	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
   
			If code <> "" AND code = CStr(CRs("ct_serial")) Then    		
				RE_DATA = RE_DATA & "<option value='"&CRs("ct_serial")&"' selected>"&ReHtmlSpecialChars(CRs("CountryInfo"))&"</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&CRs("ct_serial")&"'>"&ReHtmlSpecialChars(CRs("CountryInfo"))&"</option>"	
			End If 

			CRs.MoveNext
		Loop 
	End If 
																	 
	RE_DATA = RE_DATA & "</select>"

	Response.Write RE_DATA
	
	DBClose()
%>