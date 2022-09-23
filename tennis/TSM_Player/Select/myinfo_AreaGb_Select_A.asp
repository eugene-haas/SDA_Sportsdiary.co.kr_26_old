<!--#include file ="../Library/ajax_config.asp"-->
<%
	'지역(시/도) 조회
	dim element : element = fInject(Request("element"))
	dim attname : attname = fInject(Request("attname"))	
	dim code	: code    = fInject(Request("code"))	
	
	dim LSQL, LRs
	dim selData
	
	selData = "<select name='"&attname&"' id='"&attname&"' onChange=""chk_AreaGbDt_CA(this.value); chk_teamcode_CA();"">"
	selData = selData&"<option value=''>:: 지역 선택(시/도) ::</option>"				
		
	LSQL = "		SELECT Sido "
	LSQL = LSQL & " 	,SidoNm "
	LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblSidoInfo]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"'"
	LSQL = LSQL & "		AND NOT(SidoIDX = 17) "
	LSQL = LSQL & " ORDER BY Sido ASC "
	
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			selData = selData&"<option value='"&LRs("Sido")&"' >"&LRs("SidoNm")&"</option>"	

			LRs.MoveNext
		Loop 
		
		selData = selData&"</select>"
		
	End If 

		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData

	Dbclose()

%>