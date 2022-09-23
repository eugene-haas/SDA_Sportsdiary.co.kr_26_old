<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'컬럼리스트 조회페이지
	'===========================================================================================
'	Check_Login()
	

	dim fnd_LastID  	: fnd_LastID  	= fInject(request("fnd_LastID"))	'출력된 마지막 row_number()
	dim cnt_board   	: cnt_board   	= fInject(request("cnt_board"))		'출력된 컨텐츠 수	
	dim old_idx			: old_idx 		= 0
	dim B_PSize   		: B_PSize 		= 10	'페이지내 보여지는 목록카운트
	

	dim CSearch, i
	dim FndData
	dim LRs, LSQL
	dim TotalCount, TotalPage, cnt
	dim idx
	
	IF cnt_board = "" Then cnt_board = 0 	
	
	'소수점 무조건 올림 함수
	Function Ceil(valParam)
		Ceil = -(Int(-(valParam)))
	End Function
	
	
	
	 '조회정보 전체 카운트(더보기 버튼 출력체크)
	LSQL = "        SELECT COUNT(*) "
	LSQL = LSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblColumnist] "
	LSQL = LSQL & " WHERE DelYN = 'N' " 
	LSQL = LSQL & " 	AND ViewYN = 'Y' " 
    
	SET LRs = DBCon3.Execute(LSQL) 
		TotalCount = LRs(0)
		TotalPage = LRs(1)
	
	
	LSQL = "    	SELECT TOP "&B_PSize&" ColumnistIDX"
	LSQL = LSQL & "		,Subject" 
	LSQL = LSQL & "		,UserName" 
	LSQL = LSQL & "		,ISNULL(ImageURL,'') ImageURL" 
	LSQL = LSQL & "		,NUM "
	LSQL = LSQL & " FROM ("
	LSQL = LSQL & "			SELECT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) AS NUM, * "
	LSQL = LSQL & "			FROM [SD_tennis].[dbo].[tblColumnist]"
	LSQL = LSQL & "		) A "
	LSQL = LSQL & " WHERE DelYN = 'N' " 
	LSQL = LSQL & " 	AND ViewYN = 'Y' " 
	
	IF fnd_LastID <> "" Then   LSQL = LSQL & "   AND NUM > '"&fnd_LastID&"' "
	
	LSQL = LSQL & " ORDER BY WriteDate DESC" 

'	response.Write LSQL
	
	SET LRs = DBCon3.Execute(LSQL)
	IF	Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			cnt = cnt + 1
			
			IF cint(old_idx) < cint(LRs("NUM")) Then idx = LRs("NUM")
			
			FndData = FndData & "<li>"
			FndData = FndData & "	<a href=""javascript:view_Columnist_Dtl('"&encode(LRs("ColumnistIDX"), 0)&"');"">"
			
			
			FndData = FndData & "		<div class='img'>"
			FndData = FndData & "			<img src='"
			
			IF LRs("ImageURL") <> "" Then
				FndData = FndData & "../upload/column/"&LRs("ImageURL")
			Else
				FndData = FndData & ImgDefault			'기본이미지 
			End IF
			
			FndData = FndData & "' alt='' />"
			FndData = FndData & "		</div>"			
			FndData = FndData & "		<div class='r_con'>"
			FndData = FndData & "			<div class='txt'>"
			FndData = FndData & "				<p class='name'>"&LRs("UserName")&"</p>"
			FndData = FndData & "				<p class='title'>"&ReplaceTagReText(LRs("Subject"))&"</p>"
			FndData = FndData & "			</div>"
			FndData = FndData & "			<i class='fa fa-angle-right' aria-hidden='true'></i>"
			FndData = FndData & "		</div>"
			FndData = FndData & "	</a>"
			FndData = FndData & "</li>"
			
			old_idx = LRs("NUM")
			
			LRs.MoveNext
		Loop 	
	End If 
		LRs.Close
	SET LRs = Nothing 	
	
	
	
	IF TotalCount > cnt+cnt_board Then
	'	FndDataBtn = "<li id='more"&idx&"'><a href=""#"" class=""more"" id="""&idx&"""><span class='txt'>더보기 ("&Ceil((cnt+cnt_board)/B_PSize)&"/"&TotalPage&")</span><span class='icon_more'><i class='fa fa-angle-down' aria-hidden='true'></i></span></a></li>"
		FndDataBtn = "<li id='more"&idx&"'><a href=""#"" class=""more"" id="""&idx&"""><span class='txt'>더보기</span> <span class='icon_more'><i class='fa fa-angle-down' aria-hidden='true'></i></span></a></li>"
	Else
'		FndDataBtn = "<li id='more"&idx&"'><a href=""#"" class=""more"" id="""&idx&"""><span class='txt'>마지막 ("&Ceil((cnt+cnt_board)/B_PSize)&"/"&TotalPage&")</span></a></li>"	
		FndDataBtn = "<li id='more"&idx&"'><a href=""#"" class=""more"" id="""&idx&"""><span class='txt'>마지막</span> <span class='icon_more'><i class='fa fa-angle-down' aria-hidden='true'></i></span></a></li>"	
	End IF
	
	response.Write FndData&"|"&FndDataBtn&"|"&cnt+cnt_board
	
	DBClose3()
%>