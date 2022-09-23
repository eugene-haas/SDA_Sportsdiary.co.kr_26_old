<!--#include file="../dev/dist/config.asp"-->
<%
   	'등록팀 현황 년도 Select Option list 조회
	'/main_Hp/LeaderInfo_list.asp
	 
	dim code	: code 		= fInject(Request("code"))	
	dim attname	: attname 	= fInject(Request("attname"))	 
	
	dim CSQL, CRs
	dim RE_DATA

   	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class=""title_select"">"
	
	CSQL = "		SELECT RegistYear"      
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory]"
	CSQL = CSQL & "	WHERE DelYN = 'N' AND (RegistYear <> '' OR RegistYear IS NOT NULL)"
	CSQL = CSQL & "	GROUP BY RegistYear"
	CSQL = CSQL & " ORDER BY RegistYear DESC"									 

	SET CRs = DBCon.Execute(CSQL)
	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
			IF code <> "" AND code = CRs("RegistYear") Then    		
				RE_DATA = RE_DATA & "<option value='"&CRs("RegistYear")&"' selected>"&CRs("RegistYear")&"</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&CRs("RegistYear")&"'>"&CRs("RegistYear")&"</option>"	
			End IF 

			CRs.MoveNext
		Loop 
	End IF 
		CRs.Close
	SET CRs = Nothing
	
	RE_DATA = RE_DATA & "</select>"

	Response.Write RE_DATA
	
	DBClose()
%>
	
	