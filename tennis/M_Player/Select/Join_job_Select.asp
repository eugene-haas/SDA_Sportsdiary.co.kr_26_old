<!--#include file="../Library/ajax_config.asp"-->
<%
	dim attname : attname = fInject(Request("attname"))	
	dim strJob : strJob = fInject(Request("strJob"))	
	
	
	dim LSQL, LRs
	
	LSQL = "		SELECT PubCode "
	LSQL = LSQL&" 		,PubName "
	LSQL = LSQL&" 	FROM [SD_Tennis].[dbo].[tblPubCode]"
	LSQL = LSQL&" 	WHERE DelYN = 'N'"
	LSQL = LSQL&" 		AND PubCode like 'JOB%'"
	LSQL = LSQL&" 	Order By Orderby, PubCodeIDX"
	
	
	SET LRs = DBCon3.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then 
		
		selData = "<select name='"&attname&"' id='"&attname&"'>"
		selData = selData & "<option value=''>현재 직업군 선택</option>"				

		Do Until LRs.Eof 
			IF strJob <> "" AND strJob = LRs("PubCode") Then 
				selData = selData & "<option value='"&LRs("PubCode")&"' selected>"&LRs("PubName")&"</option>"	
			Else
				selData = selData & "<option value='"&LRs("PubCode")&"'>"&LRs("PubName")&"</option>"	
			End IF
			
			LRs.MoveNext
		Loop 
		
		selData = selData&"</select>"
		
	End If 

		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData

	DBClose3()

%>