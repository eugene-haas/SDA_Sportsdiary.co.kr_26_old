<!--#include file="../dev/dist/config.asp"-->
<%
   	'세계남여단체전 tblPubCode 조회
	 
	dim code	: code 		= fInject(Request("code"))	
	dim attname	: attname 	= fInject(Request("attname"))	 
	
	dim CSQL, CRs
	dim RE_DATA
	dim strMajor, strMajorGame, strMajorCub
	 
	
	IF len(code) > 1  Then
	 	strMajor = Split(code, ",")	 
		strMajorGame = strMajor(0)									  
		strMajorCub = strMajor(1)									  						  
	End IF
	
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class=""title_select"">"
	RE_DATA = RE_DATA & "<option value=''>대회구분Ⅲ</option>"		 
	
	CSQL = "		SELECT PubCode"
	CSQL = CSQL & "		,PubName"
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblPubcode]"
	CSQL = CSQL & "	WHERE DelYN = 'N' "
	CSQL = CSQL & "		AND PPubCode = 'MAJORGROUP' "
	CSQL = CSQL & "		AND PubType = '"&strMajorGame&"' "													  
	CSQL = CSQL & "	ORDER BY OrderBy, PubCode"

	'response.write CSQL

	SET CRs = DBCon.Execute(CSQL)
	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
			If strMajorCub <> "" AND strMajorCub = CRs("PubCode") Then    		
				RE_DATA = RE_DATA & "<option value='"&CRs("PubCode")&"' selected>"&CRs("PubName")&"</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&CRs("PubCode")&"'>"&CRs("PubName")&"</option>"	
			End If 

			CRs.MoveNext
		Loop 
	End IF 
		CRs.Close
	SET CRs = Nothing
	
	RE_DATA = RE_DATA & "</select>"

	Response.Write RE_DATA
	
	DBClose()
%>
	
	