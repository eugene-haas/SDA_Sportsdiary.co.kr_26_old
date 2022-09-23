<!--#include file ="../Library/ajax_config.asp"-->
<%
	'지역(시/도) 조회
	dim attname : attname = fInject(Request("attname"))	
	dim code	: code    = fInject(Request("code"))	
	
	
	dim LSQL, LRs
	dim selData
	
	selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_AreaGbDt(this.value);'>"
	selData = selData & "<option value=''>시/도 선택</option>"				
		
	LSQL = "		SELECT Sido "
	LSQL = LSQL & " 	,SidoNm "
	LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSidoInfo]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"'"
	LSQL = LSQL & "		AND NOT(SidoIDX = 17) "
	LSQL = LSQL & " ORDER BY Sido ASC "
	
	SET LRs = DBCon3.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			IF code <> "" AND LRs("Sido") = code  Then	'수정시
				selData = selData&"<option value='"&LRs("Sido")&"' selected>"&LRs("SidoNm")&"</option>"	
			Else	
				selData = selData&"<option value='"&LRs("Sido")&"' >"&LRs("SidoNm")&"</option>"	
			End IF	

			LRs.MoveNext
		Loop 		
	End If 

	selData = selData&"</select>"
		
		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData

	DBClose3()

%>