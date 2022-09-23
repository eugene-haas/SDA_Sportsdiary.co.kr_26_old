<!--#include file="../../dev/dist/config.asp"-->
<%
   	'==============================================================================
	'경기구분 조회
   	'/Request/fr_state.asp
   	'==============================================================================
	dim attname 		: attname 			= fInject(Request("attname"))	
	dim code			: code    			= fInject(Request("code"))	
    dim fnd_EnterType  	: fnd_EnterType    	= fInject(Request("fnd_EnterType")) 
	
   	IF len(code) > 1 Then
		dim array_code 	: array_code 		= Split(code, ",")
		dim valCIDX		: valCIDX 			= array_code(0)		
		dim valType 	: valType 			= array_code(1)
	End IF
	
	dim LSQL, LRs
	dim RE_DATA
	
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class='title_select'>"							 						 
											 
	LSQL = "		SELECT A.GroupGameGb"
	LSQL = LSQL & "		,B.PubName"
	LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblGameLevel] A"
	LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubcode] B on A.GroupGameGb = B.PubCode"
	LSQL = LSQL & "			AND B.DelYN = 'N'"	
	LSQL = LSQL & "	WHERE A.GameTitleIDX = '"&valCIDX&"'"
	LSQL = LSQL & "		AND A.DelYN = 'N'"
	LSQL = LSQL & "		AND A.EnterType = '"&fnd_EnterType&"'"
	LSQL = LSQL & "	GROUP BY A.GroupGameGb, B.PubName"
	
	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			IF valType <> "" AND valType = LRs("GroupGameGb") Then 
				RE_DATA = RE_DATA & "<option value='"&LRs("GroupGameGb")&"' selected >"&LRs("PubName")&"</option>"								 
			Else
				RE_DATA = RE_DATA & "<option value='"&LRs("GroupGameGb")&"' >"&LRs("PubName")&"</option>"	
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