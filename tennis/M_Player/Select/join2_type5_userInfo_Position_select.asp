<!--#include file ="../Library/ajax_config.asp"-->
<%
	'생활체육(main/join4_type5.asp)
	'사용손, 백핸드타입, 복식리턴포지션 select
	
	dim attname : attname = fInject(Request("attname"))	
	dim code	: code    = fInject(Request("code"))	
	
	dim LSQL, LRs
	dim selData
	dim Csearch
	
	IF attname <> "" Then Csearch = " AND PPubCode = '"&attname&"'"	
	
	selData = "<select name='"&attname&"' id='"&attname&"' >"
	
	
	SELECT CASE attname
		CASE "HandUse" : selData = selData&"<option value=''>사용손 선택</option>"							
		CASE "HandType" : selData = selData&"<option value=''>백핸드타입 선택</option>"						
		CASE "PositionReturn" : selData = selData&"<option value=''>복식리턴포지션 선택</option>"						
	END SELECT
		
	LSQL = "		SELECT PubCode "
	LSQL = LSQL & " 	,PubName "
	LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblPubCode]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND SportsGb = 'tennis'" & Csearch
	LSQL = LSQL & " ORDER BY OrderBy"
	
	SET LRs = DBCon3.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			IF code <> "" AND code = LRs("PubCode") Then
				selData = selData&"<option value='"&LRs("PubCode")&"' selected >"&LRs("PubName")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("PubCode")&"' >"&LRs("PubName")&"</option>"	
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