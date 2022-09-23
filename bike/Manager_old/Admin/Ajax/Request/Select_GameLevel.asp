<!--#include file="../../dev/dist/config.asp"-->
<%
   	'==============================================================================
	'경기종목 조회
   	'/Request/fr_state.asp
	'/Request/elite_state.asp 
   	'==============================================================================
	dim attname 		: attname 			= fInject(Request("attname"))	
	dim code			: code    			= fInject(Request("code"))	
    dim fnd_EnterType  	: fnd_EnterType    	= fInject(Request("fnd_EnterType")) 
	
   	IF len(code) > 1 Then
		dim array_code 	: array_code 		= Split(code, ",")
		dim valCIDX		: valCIDX 			= array_code(0)		
		dim valType 	: valType 			= array_code(1)
	 	dim valGroup 	: valGroup 			= array_code(2)
	 	dim valLevel 	: valLevel 			= array_code(3)
	End IF
	
	dim LSQL, LRs
	dim RE_DATA
	
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class='title_select'>"														  
	RE_DATA = RE_DATA & "<option value=''>종목</option>"														  														  
	
	LSQL = "		SELECT A.TeamGb"
	LSQL = LSQL & "		,A.PlayType"
	LSQL = LSQL & "		,A.Sex"
	LSQL = LSQL & "		,CASE A.SEX"
	LSQL = LSQL & "			WHEN 'Man' THEN '남자'"
	LSQL = LSQL & "			WHEN 'WoMan' THEN '여자'"
	LSQL = LSQL & "		ELSE '혼합'"
	LSQL = LSQL & "		END + C.PubName GameGroupNm"
	LSQL = LSQL & "		,A.Sex + '|' + A.PlayType GameGroup"	
	LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblGameLevel] A"
	LSQL = LSQL & "		inner join [KoreaBadminton].[dbo].[tblTeamGbInfo] B on A.TeamGb = B.TeamGb"
	LSQL = LSQL & "			AND B.DelYN = 'N'"
	LSQL = LSQL & "			AND B.EnterType = '"&fnd_EnterType&"'"		
	LSQL = LSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] C on A.PlayType = C.PubCode"
	LSQL = LSQL & "			AND C.DelYN = 'N'"
	LSQL = LSQL & "	WHERE A.GameTitleIDX = '"&valCIDX&"'"
	LSQL = LSQL & "		AND A.DelYN = 'N'"
	LSQL = LSQL & "		AND A.ViewYN = 'Y'"										 
	LSQL = LSQL & "		AND A.EnterType = '"&fnd_EnterType&"'"
	LSQL = LSQL & "		AND A.GroupGameGb = '"&valType&"'"
	LSQL = LSQL & "		AND A.TeamGb = '"&valGroup&"'"
	
'	response.write LSQL
													 
	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			IF valLevel <> "" AND valLevel = LRs("GameGroup") Then 
				RE_DATA = RE_DATA & "<option value='"&LRs("GameGroup")&"' selected >"&LRs("GameGroupNm")&"</option>"								 
			Else
				RE_DATA = RE_DATA & "<option value='"&LRs("GameGroup")&"' >"&LRs("GameGroupNm")&"</option>"	
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