<!--#include file="../dev/dist/config.asp"-->
<%
   	'국제대회 tblPubCode 조회
	 
	dim valType	: valType = fInject(Request("valType"))	
	
	dim CSQL, CRs
	dim RE_DATA
	
	IF valType = ""  Then
	 	response.Write "FALSE|200"
	 	response.End
	Else 
		CSQL = "		SELECT PubCode"
		CSQL = CSQL & "		,PubName"
		CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblPubcode]"
		CSQL = CSQL & "	WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND PPubCode = 'MAJORGAME' "
		CSQL = CSQL & "		AND PubType = '"&valType&"' "													  
		CSQL = CSQL & "	ORDER BY OrderBy, PubCode"

	'	response.write CSQL

		SET CRs = DBCon.Execute(CSQL)
		If Not (CRs.Eof Or CRs.Bof) Then 
			Do Until CRs.Eof 
				
				RE_DATA = RE_DATA & "<a href=""javascript:chk_SubBtn('"&CRs("PubCode")&"');"" class=""btn btn-blue-empty"" id=""SSubBtn_"&CRs("PubCode")&""">"&CRs("PubName")&"</a> "
   
				CRs.MoveNext
			Loop 
   
   			response.write "TRUE|"&RE_DATA
  		Else
   			response.Write "FALSE|99"
	 		response.End
		End IF 
			CRs.Close
		SET CRs = Nothing
	
   	End IF
	
	DBClose()
%>
	
	