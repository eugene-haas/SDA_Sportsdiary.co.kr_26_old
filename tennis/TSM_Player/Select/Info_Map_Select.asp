<!--#include file="../Library/ajax_config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))
	
	dim SctGbNm	'기관(협회)/팀/사설도장 명
	
	LSQL =  " SELECT SctGb " &_
			" FROM Sportsdiary.dbo.tblSvcSctInfo " &_
			" WHERE DelYN='N' " &_
			" GROUP BY SctGb " &_
			" ORDER BY SctGb ASC "
			
	Set LRs = Dbcon.Execute(LSQL)
	If Not(LRs.Eof Or LRs.Bof) Then 
		
		selData = "<select name='"&attname&"' id='"&attname&"'>"
		selData = selData&"<option value=''>기관선택</option>"
				
		Do Until LRs.Eof 
			
			SELECT CASE LRs("SctGb")
				CASE "A" : SctGbNm = "기관(협회)"
				CASE "T" : SctGbNm = "팀"
				CASE "G" : SctGbNm = "사설도장"
			END SELECT	

			selData = selData &"<option value='"&LRs("SctGb")&"'>"&SctGbNm&"</option>"	

			LRs.MoveNext
		Loop 

		selData = selData&"</select>"	

	End If 
	
		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData	

	DBClose()

%>