<!--#include file ="../Library/ajax_config.asp"-->
<%
	'==============================================================================
	'생활체육 지역(시/군/구) 조회
	'==============================================================================
'	dim element : element = fInject(Request("element"))
	dim attname : attname = fInject(Request("attname"))	
	dim code	: code    = fInject(Request("code"))
	
	dim LSQL, LRs
	dim selData
	
	selData = "<select name='"&attname&"' id='"&attname&"' onChange=""chk_teamcode_CA($('#AreaGb_CA').val(), this.value);"">"
	selData = selData & "<option value=''>:: 지역 선택(시/군/구) ::</option>"				
	
	LSQL = "		SELECT A.Sido "
	LSQL = LSQL & "		,A.SidoNm "
	LSQL = LSQL & "		,B.GuGunNm_A GuGunNm_A "
	LSQL = LSQL & "	FROM [Sportsdiary].[dbo].[tblSidoInfo] A "
	LSQL = LSQL & "		INNER JOIN [Sportsdiary].[dbo].[tblguguninfo] B ON B.Sido = A.Sido "
	LSQL = LSQL & "			AND B.DelYN = 'N' "
	LSQL = LSQL & "			AND B.SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "	WHERE A.DelYN = 'N' "
	LSQL = LSQL & "		AND A.SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "		AND A.Sido = '"&code&"' "
	LSQL = LSQL & "		AND NOT(A.SidoIDX = 17) "	'시도없음 제외처리
	LSQL = LSQL & "	ORDER BY B.GuGunNm_A "
	
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 

			selData = selData & "<option value='"&LRs("GuGunNm_A")&"' >"&LRs("GuGunNm_A")&"</option>"	

			LRs.MoveNext
		Loop 
	End If 
		LRs.Close
	SET LRs = Nothing
	
	selData = selData & "</select>"
	
	Response.Write selData
	
	Dbclose()
%>