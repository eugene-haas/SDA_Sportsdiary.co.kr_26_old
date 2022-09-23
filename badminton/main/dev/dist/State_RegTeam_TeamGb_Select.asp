<!--#include file="../dev/dist/config.asp"-->
<%
   	'종별 Select Option list 조회
	'/main_Hp/State_RegTeam.asp
	 
	dim code	: code 		= fInject(Request("code"))	
	dim attname	: attname 	= fInject(Request("attname"))	 
	
	dim CSQL, CRs
	dim RE_DATA

   	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class=""title_select"">"
	
	CSQL = "		SELECT PTeamGbCode, PTeamGbName"      
	CSQL = CSQL & "	FROM [dbo].[tblTeamGbInfo]"
	CSQL = CSQL & "	WHERE DelYN = 'N' AND EnterType = 'E'"
	CSQL = CSQL & " ORDER BY Orderby"									 

	SET CRs = DBCon.Execute(CSQL)
	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
			IF code <> "" AND code = CRs("PTeamGbCode") Then    		
				RE_DATA = RE_DATA & "<option value='"&CRs("PTeamGbCode")&"' selected>"&CRs("PTeamGbName")&"</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&CRs("PTeamGbCode")&"'>"&CRs("PTeamGbName")&"</option>"	
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
	
	