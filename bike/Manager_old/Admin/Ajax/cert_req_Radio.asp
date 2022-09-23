<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'증명서 발급 cert_req.asp
   	'	발급종류 | 발급용도 Radio Btn 생성
	'====================================================================================		
	dim valType : valType = fInject(Request("valType"))
    dim valCode : valCode = crypt.DecryptStringENC(fInject(Request("valCode")))
   
	dim RE_Data
	dim fndType
   	dim CSQL, CRs
   
   	IF valType = "" Then
   		response.end
   	ELSE
   		SELECT CASE valType
			CASE "TypeCertificate" 	: fndType = "CER01"
			CASE "TypeUse" 			: fndType = "CER02"
		END SELECT
   
   		CSQL = "		SELECT PubCode"
		CSQL = CSQL & "		,PubName"
		CSQL = CSQL & "	FROM [koreabadminton].[dbo].[tblPubcode] "
		CSQL = CSQL & "	WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND PPubCode = '"&fndType&"' "
		IF fndType = "CER01" THEN
			CSQL = CSQL & "		AND PubCode NOT IN ('CER01005', 'CER01006')"
		END IF 
		CSQL = CSQL & "	ORDER BY OrderBy "	
   		
   		SET CRs = DBCon.Execute(CSQL)
   		IF Not(CRs.Eof Or CRs.Bof) Then 
   			Do Until CRs.Eof
   
				RE_Data = RE_Data & "<label>"
   				RE_Data = RE_Data & "	<input type='radio' name='"&valType&"' id='"&valType&"' value='"&CRs("PubCode")&"' "
				
				IF valCode <> "" and valCode = CRs("PubCode") Then RE_Data = RE_Data & " checked"	
				
				RE_Data = RE_Data & " />"
				RE_Data = RE_Data & "	<span class='txt'>"&CRs("PubName")&"</span>"
				RE_Data = RE_Data & "</label>"
				
   				CRs.movenext
  			Loop
   		END IF
   			CRs.Close
   		SET CRs = Nothing
   		
   		response.write RE_Data
   
   		DBClose()
	END IF
  
%>