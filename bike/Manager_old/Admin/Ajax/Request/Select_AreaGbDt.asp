<!--#include file="../../dev/dist/config.asp"-->
<%
	'==============================================================================
	'지역(시/군/구) 조회
	'==============================================================================
	dim attname : attname = fInject(Request("attname"))	
	dim code	: code    = fInject(Request("code"))	 
	
	IF len(code) > 1 Then
		dim array_code 	: array_code 	= Split(code, ",")
		dim valArea		: valArea 		= array_code(0)		
		dim valGroup 	: valGroup 		= array_code(1)
	End IF
	 
	dim LSQL, LRs
	dim RE_DATA
	
	RE_DATA = "<select name='"&attname&"' id='"&attname&"' class='title_select'>"
	RE_DATA = RE_DATA & "<option value=''>시/군/구</option>"				
	
	LSQL = "		SELECT B.Sido "
	LSQL = LSQL & "		,B.SidoNm "
	LSQL = LSQL & "		,A.GuGun GuGun "
	LSQL = LSQL & "		,A.GuGunNm_A GuGunNm_A "										 
	LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblGugunInfo] A "
	LSQL = LSQL & "		INNER JOIN [KoreaBadminton].[dbo].[tblSidoInfo] B ON B.Sido = A.Sido "
	LSQL = LSQL & "			AND B.DelYN = 'N' "
	LSQL = LSQL & "			AND B.Sido = '"&valArea&"' "
	LSQL = LSQL & " 		AND B.Sido NOT IN(18)"			'시도없음 제외처리											 
	LSQL = LSQL & "	WHERE A.DelYN = 'N' "
	LSQL = LSQL & "	ORDER BY A.GuGunNm_A "
	
'  	response.write LSQL
   
	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
   			IF valGroup <> "" AND valGroup = LRs("GuGun") Then
				RE_DATA = RE_DATA & "<option value='"&LRs("GuGun")&"' selected >"&LRs("GuGunNm_A")&"</option>"	
			Else
				RE_DATA = RE_DATA & "<option value='"&LRs("GuGun")&"' >"&LRs("GuGunNm_A")&"</option>"	
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