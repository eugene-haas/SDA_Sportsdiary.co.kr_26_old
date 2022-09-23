<!--#include file="../dev/dist/config.asp"-->
<%
	'지역(시/도) 조회
	dim fnd_RefereeGb	: fnd_RefereeGb    = fInject(Request("code"))
	
	dim LSQL, LRs
	dim selData
	
	selData = "<option value=''>구분</option>"	
	
	LSQL = "		SELECT PubCode "
	LSQL = LSQL & " 	,PubName "
	LSQL = LSQL & " FROM [koreabadminton].[dbo].[tblPubCode]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND PPubCode = 'LICENSE'"
	LSQL = LSQL & " ORDER BY OrderBy"
	
	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			selData = selData & "<option value='"&LRs("PubCode")&"' "
			
			IF fnd_RefereeGb <> "" AND fnd_RefereeGb = LRs("PubCode") Then selData = selData & " selected "
			
			selData = selData & ">"&LRs("PubName")&"</option>"	

			LRs.MoveNext
		Loop 
	End If 

		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData

	DBClose()

%>