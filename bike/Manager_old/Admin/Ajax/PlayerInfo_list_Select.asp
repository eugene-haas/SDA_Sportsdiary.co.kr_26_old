<!--#include file="../dev/dist/config.asp"-->
<%
   	'등록팀 현황 년도 Select Option list 조회
	'/main_Hp/PlayerInfo_list.asp
	 
	dim code	: code 		= fInject(Request("code"))	
	dim attname	: attname 	= fInject(Request("attname"))	 
	
	dim CSQL, CRs
	dim RE_DATA

   	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class=""title_select"">"
	
	CSQL = "		SELECT RegYear"      
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblMemberHistory]"
	CSQL = CSQL & "	WHERE DelYN = 'N' AND (RegYear <> '' OR RegYear IS NOT NULL)"
	CSQL = CSQL & "	GROUP BY RegYear"
	CSQL = CSQL & " ORDER BY RegYear DESC"									 

	SET CRs = DBCon.Execute(CSQL)
	If Not (CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.Eof 
			IF code <> "" AND code = CRs("RegYear") Then    		
				RE_DATA = RE_DATA & "<option value='"&CRs("RegYear")&"' selected>"&CRs("RegYear")&"</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&CRs("RegYear")&"'>"&CRs("RegYear")&"</option>"	
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
	
	