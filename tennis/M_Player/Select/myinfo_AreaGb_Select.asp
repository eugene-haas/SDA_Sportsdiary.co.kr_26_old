<!--#include file="../Library/ajax_config.asp"-->
<%
	'지역(시/도) 조회
	dim element : element = fInject(Request("element"))
	dim attname : attname = fInject(Request("attname"))	
	dim code	: code    = fInject(Request("code"))	
	
	dim LSQL, LRs
	dim selData
	
	LSQL = "		SELECT Sido "
	LSQL = LSQL & " 	,SidoNm "
	LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblSidoInfo]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"'"
	LSQL = LSQL & " 	AND NOT(Sido = 18)"
	LSQL = LSQL & " ORDER BY Sido ASC "
	
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		
		selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_teamcode_CE();'>"
		selData = selData&"<option value=''>지역선택(시/도)</option>"				

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