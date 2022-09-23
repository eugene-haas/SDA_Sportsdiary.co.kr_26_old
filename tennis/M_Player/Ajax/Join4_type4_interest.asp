<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================
	'회원가입시 일반회원[D] 관심분야 목록 페이지
	'==============================================================================
	dim IntArr	: IntArr = fInject(request("IntArr"))
	
	dim LSQL, LRs
	dim strArr, cntArr, i
	dim selData
	
	'intArr = "|INT01|INT05|INT09"
	
	IF IntArr<>"" Then
		strArr = split(IntArr, "|")
		cntArr = UBOUND(strArr)
	End IF
	
	LSQL = "		SELECT PubCode "
	LSQL = LSQL & " 	,PubName "
	LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSvcPubCode]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND PubCode like 'INT%'"
	LSQL = LSQL & " ORDER BY orderby, PubCodeIDX ASC"
	
'	selData = "<ul id='"&attname&"' class='clearfix'>"
	
	SET LRs = DBCon3.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then 
		
		Do Until LRs.Eof 
			selData = selData & "<li><a href='#' "
			
			
			IF IntArr <> "" Then
				For i = 0 to cntArr
					IF strArr(i) = LRs("PubCode") Then selData = selData & " class='on' "
				Next
			End IF		
			
			selData = selData & "><input name='Interest' id='Interest' type='checkbox' "
			
			IF IntArr <> "" Then	
				For i = 0 to cntArr	
					IF strArr(i) = LRs("PubCode") Then selData = selData & " checked "
				Next	
			End IF
			
			selData = selData & " value='"&LRs("PubCode")&"'><span>"&LRs("PubName")&"</span></a></li>"				
			
			
			LRs.MoveNext
		Loop 
	End If 
	
'	selData = selData & "</ul>"
	
		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData

	DBClose3()

%>