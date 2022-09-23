<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'증명서 발급 cert_req.asp
   	'	발급종류 | 발급용도 select box 생성
	'====================================================================================		
	dim valType : valType = fInject(Request("valType"))
    dim valCode : valCode = fInject(Request("valCode"))
   
	dim RE_Data
	dim fndType
   	dim CSQL, CRs
   
   	IF valType = "" Then
   		response.end
   	ELSE
   	
  ' 	response.write "valCode="&valCode
   
   		RE_Data = RE_Data & "<select name='fnd_"&valType&"' id='fnd_"&valType&"' class=""title_select"">"
   
   		SELECT CASE valType
			CASE "TypeCertificate" 	: fndType = "CER01" : RE_Data = RE_Data & "<option value=''>:: 종류선택 ::</option>"
			CASE "TypeUse" 			: fndType = "CER02" : RE_Data = RE_Data & "<option value=''>:: 용도선택 ::</option>"
		END SELECT
   
   		CSQL = "		SELECT PubCode"
		CSQL = CSQL & "		,PubName"
		CSQL = CSQL & "	FROM [koreabadminton].[dbo].[tblPubcode] "
		CSQL = CSQL & "	WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND PPubCode = '"&fndType&"' "
		CSQL = CSQL & "	ORDER BY OrderBy "	
   		
   		SET CRs = DBCon.Execute(CSQL)
   		IF Not(CRs.Eof Or CRs.Bof) Then 
   			Do Until CRs.Eof
   			
   				IF valCode = CRs("PubCode") Then 
					RE_Data = RE_Data & "<option value="""&CRs("PubCode")&""" selected>"&CRs("PubName")&"</option>"
   				Else
   					RE_Data = RE_Data & "<option value="""&CRs("PubCode")&""">"&CRs("PubName")&"</option>"
   				End IF
   
   				CRs.movenext
  			Loop
   		END IF
   			CRs.Close
   		SET CRs = Nothing
   		
   		response.write RE_Data
   
   		DBClose()
	END IF
  
%>