<!--#include file="../../dev/dist/config.asp"-->
<%
   	'==============================================================================
	'지역(시/도) Select box Option list 조회
	'/main/GameTitleMenu/request_state_A.asp 
    '/main_HP/State_RegTeam_Area.asp
   	'==============================================================================
	dim attname 	: attname 	= fInject(Request("attname"))	
	dim code		: code    	= fInject(Request("code"))	
	 
	dim LSQL, LRs
	dim RE_DATA
	
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class='title_select'>"							 						 
	RE_DATA = RE_DATA & "<option value=''>시/도</option>"				
											 
	LSQL = "		SELECT Sido "
	LSQL = LSQL & " 	,SidoNm "
	LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblSidoInfo]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND Sido NOT IN('18')"
	LSQL = LSQL & " ORDER BY OrderbyNum, SidoNm"
	
	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			IF code <> "" AND code = LRs("Sido") Then 
				RE_DATA = RE_DATA & "<option value='"&LRs("Sido")&"' selected >"&LRs("SidoNm")&"</option>"								 
			Else
				RE_DATA = RE_DATA & "<option value='"&LRs("Sido")&"' >"&LRs("SidoNm")&"</option>"	
			End IF
																
			LRs.MoveNext
		Loop 
	End IF 
		LRs.Close
	SET LRs = Nothing
	
	RE_DATA = RE_DATA & "</select>"
																	
	Response.Write RE_DATA

	DBClose()
%>