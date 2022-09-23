<!--#include file ="../Library/ajax_config.asp"-->
<%
	'==============================================================================
	'생활체육 지역(시/군/구) 조회
	'==============================================================================
	dim attname : attname = fInject(Request("attname"))	
	dim code	: code    = fInject(Request("code"))
	dim array_code 	
	dim AreaGb 		 
	dim AreaGbDt 
	
	'사용처
	'sdmain/user_divn_coach.asp
	'tennis/M_Player/Mypage/myinfo.asp
	
	IF code <> "" Then
		
		IF Ubound(Split(code,",")) > 0 Then
			array_code 	= Split(code,",")
			AreaGb 		= array_code(0)		
			AreaGbDt 	= array_code(1)
		Else
			AreaGb 		= code
		End IF
			
	End IF
	
	dim LSQL, LRs
	dim selData
	
	selData = "<select name='"&attname&"' id='"&attname&"'>"
	selData = selData & "<option value=''>시/군/구 선택</option>"				
	
	LSQL = "		SELECT A.Sido "
	LSQL = LSQL & "		,A.SidoNm "
	LSQL = LSQL & "		,B.GuGunNm_A GuGunNm_A "
	LSQL = LSQL & "	FROM [SD_tennis].[dbo].[tblSidoInfo] A "
	LSQL = LSQL & "		INNER JOIN [SD_tennis].[dbo].[tblguguninfo] B ON B.Sido = A.Sido "
	LSQL = LSQL & "			AND B.DelYN = 'N' "
	LSQL = LSQL & "			AND B.SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "	WHERE A.DelYN = 'N' "
	LSQL = LSQL & "		AND A.SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "		AND A.Sido = '"&AreaGb&"' "
	LSQL = LSQL & "		AND NOT(A.SidoIDX = 17) "	'시도없음 제외처리
	LSQL = LSQL & "	ORDER BY B.GuGunNm_A "

	SET LRs = DBCon3.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			IF AreaGbDt <> "" AND LRs("GuGunNm_A") = AreaGbDt Then	'수정시
				selData = selData & "<option value='"&LRs("GuGunNm_A")&"' selected >"&LRs("GuGunNm_A")&"</option>"	
			Else	
				selData = selData & "<option value='"&LRs("GuGunNm_A")&"' >"&LRs("GuGunNm_A")&"</option>"	
			End IF
			
			LRs.MoveNext
		Loop 
	End If 
		LRs.Close
	SET LRs = Nothing
	
	selData = selData & "</select>"
	
	Response.Write selData
	
	DBClose3()
%>