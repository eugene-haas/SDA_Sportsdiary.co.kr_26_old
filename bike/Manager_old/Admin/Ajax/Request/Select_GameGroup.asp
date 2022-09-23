<!--#include file="../../dev/dist/config.asp"-->
<%
   	'==============================================================================
	'경기구분 조회
   	'==============================================================================
	dim attname 		: attname 			= fInject(Request("attname"))	
	dim code			: code    			= fInject(Request("code"))	
    dim fnd_EnterType  	: fnd_EnterType    	= fInject(Request("fnd_EnterType")) 
	
   
 ' 	response.write code
   
   
   	IF len(code) > 2 Then
		dim array_code 	: array_code 	= Split(code, ",")
		dim valCIDX		: valCIDX 		= array_code(0)		
		dim valType 	: valType 		= array_code(1)
		dim valGroup 	: valGroup 		= array_code(2)
	End IF
	
	dim LSQL, LRs
	dim RE_DATA
	
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class='title_select'>"							 						 
	RE_DATA = RE_DATA & "<option value=''>경기구분</option>"							 						 
											 
	LSQL = "		SELECT A.TeamGb, B.TeamGbNm"
	LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameLevel] A"
	LSQL = LSQL & "		inner join [KoreaBadminton].[dbo].[tblTeamGbInfo] B on A.TeamGb = B.TeamGb"
	LSQL = LSQL & "			AND B.DelYN = 'N'"
	LSQL = LSQL & "			AND B.EnterType = '"&fnd_EnterType&"'"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & "		AND A.EnterType = '"&fnd_EnterType&"'"
	LSQL = LSQL & "		AND A.GameTitleIDX = '"&valCIDX&"'"
	LSQL = LSQL & "		AND A.GroupGameGb = '"&valType&"'"
	LSQL = LSQL & " GROUP BY A.TeamGb, B.TeamGbNm"	
	LSQL = LSQL & " ORDER BY A.TeamGb, B.TeamGbNm"
	
	'response.write LSQL
	
	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			IF valGroup <> "" AND valGroup = LRs("TeamGb") Then 
				RE_DATA = RE_DATA & "<option value='"&LRs("TeamGb")&"' selected >"&LRs("TeamGbNm")&"</option>"								 
			Else
				RE_DATA = RE_DATA & "<option value='"&LRs("TeamGb")&"' >"&LRs("TeamGbNm")&"</option>"	
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