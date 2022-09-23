<!--#include file="../dev/dist/config.asp"-->
<%
   	'역대타이틀 정보 조회
	 
	dim attname		: attname = fInject(Request("attname"))	
	dim code		: code    = fInject(Request("code"))
	dim CSQL, CRs
	dim RE_DATA
	dim strCode, valCode(2)
 
	IF len(code) > 2 Then
	 	strCode = Split(code, ",")
	 	valCode(1) = strCode(0)
	 	valCode(2) = strCode(1)
	End IF 
	
	 
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class=""title_select"">"
	RE_DATA = RE_DATA & "<option value=''>:: 역대타이틀 선택 ::</option>"		
									   
	CSQL = "		SELECT CateSuccessiveIDX"
	CSQL = CSQL & "		,SuccessiveNm"
	CSQL = CSQL & "		,DatePeriod"
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblCateSuccessive]"
	CSQL = CSQL & "	WHERE DelYN = 'N' "
	CSQL = CSQL & "		AND ViewYN = 'Y' "
	CSQL = CSQL & "		AND AssoCode = '"&valCode(1)&"' "										
	CSQL = CSQL & "	ORDER BY Orderby DESC, SuccessiveNm"
	
'	response.write CSQL
												 
	SET CRs = DBCon.Execute(CSQL)
	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
   
			If valCode(2) = CStr(CRs("CateSuccessiveIDX")) Then    		
				RE_DATA = RE_DATA & "<option value='"&CRs("CateSuccessiveIDX")&"' selected>"&ReHtmlSpecialChars(CRs("SuccessiveNm"))&" ("&ReHtmlSpecialChars(CRs("DatePeriod"))&")</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&CRs("CateSuccessiveIDX")&"' >"&ReHtmlSpecialChars(CRs("SuccessiveNm"))&" ("&ReHtmlSpecialChars(CRs("DatePeriod"))&")</option>"	
			End If 

			CRs.MoveNext
		Loop 
	End If 
																	 
	RE_DATA = RE_DATA & "</select>"

	Response.Write RE_DATA
	
	DBClose()
%>