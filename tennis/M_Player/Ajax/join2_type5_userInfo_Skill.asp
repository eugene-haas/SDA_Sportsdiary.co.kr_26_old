<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================
	'회원가입시 선수 다득점 기술
	'==============================================================================
	dim IntArr	: IntArr = fInject(request("IntArr"))	'수정시
	
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
	LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblPubCode]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND PPubCode = 'specialty'"
	LSQL = LSQL & " ORDER BY OrderBy ASC"
	
'	selData = "<ul id='div_Skill' class='clearfix'>"
	
	Set LRs = DBCon3.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then 
		
		Do Until LRs.Eof 
			selData = selData & "<li><a href='#' "
			
			
			IF IntArr <> "" Then
				For i = 0 to cntArr
					IF strArr(i) = LRs("PubCode") Then selData = selData & " class='on' "
				Next
			End IF		
			
			selData = selData & "><input name='Skill' id='Skill' type='checkbox' "
			
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