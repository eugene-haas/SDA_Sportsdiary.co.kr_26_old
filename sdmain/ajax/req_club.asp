<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================
	'소속생성 요청 조회페이지
	'==============================================================================
	'Check_Login()
	
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(request("fnd_KeyWord")) 
	dim fnd_LastID  	: fnd_LastID  	= fInject(request("fnd_LastID"))	'출력된 마지막 row_number()
	dim cnt_board   	: cnt_board   	= fInject(request("cnt_board"))		'출력된 컨텐츠 수	
	
	dim old_idx			: old_idx 		= 0
	dim B_PSize   		: B_PSize 		= 2	'페이지내 보여지는 목록카운트
	
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

	dim search(3)
	
	search(0) = "AreaGb"	'시/도
	search(1) = "AreaGbDt"	'시/군/구
	search(2) = "TeamNm"	'소속명
	search(3) = "ReqName"	'요청자명
	
	IF fnd_KeyWord <> "" Then
		For i = 0 To 3
			IF i = 0 Then
				CSearch = CSearch & " OR SD_tennis.dbo.FN_SidoName(AreaGb,'tennis') like N'%"&fnd_KeyWord&"%'"
			Else
				CSearch = CSearch & " OR "&search(i)&" like N'%"&fnd_KeyWord&"%'"
			End IF	
		Next
	
		CSearch = " AND (" & mid(CSearch, 5) & ")"
	End IF
	
	'조회정보 전체 카운트(더보기 버튼 출력체크)
	LSQL = "        SELECT COUNT(*) "
	LSQL = LSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblClubRequest]"
	LSQL = LSQL & " WHERE DelYN = 'N' "
	LSQL = LSQL & "     AND SportsGb = 'tennis'" &CSearch

	SET LRs = DBCon3.Execute(LSQL) 
		TotalCount = LRs(0)
		TotalPage = LRs(1)
	
	'조회 테이블 체크필요
	LSQL = "        SELECT TOP "&B_PSize&" ClubReqIDX "
	LSQL = LSQL & "		,NUM "
	LSQL = LSQL & "   	,ISNULL(TeamIDX, '') TeamIDX" 
	LSQL = LSQL & "   	,AreaGb "
	LSQL = LSQL & "   	,SD_tennis.dbo.FN_SidoName(AreaGb,'tennis') AreaGbNm"
	LSQL = LSQL & "   	,AreaGbDt "
	LSQL = LSQL & "   	,TeamNm "
	LSQL = LSQL & "   	,ReqName "
	LSQL = LSQL & "   	,CONVERT(CHAR(10),WriteDate, 102) WriteDate"	
	LSQL = LSQL & " FROM ("
	LSQL = LSQL & "			SELECT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) AS NUM, * "
	LSQL = LSQL & "			FROM [SD_tennis].[dbo].[tblClubRequest]"
	LSQL = LSQL & "		) A "
	LSQL = LSQL & " WHERE DelYN = 'N' "
	LSQL = LSQL & "     AND SportsGb = 'tennis'" &CSearch
	
	IF fnd_LastID<>"" Then   LSQL = LSQL & "   AND NUM > '"&fnd_LastID&"' "
	
	LSQL = LSQL & " ORDER BY WriteDate DESC"
	
	SET LRs = DBCon3.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			cnt = cnt + 1
			
			IF cint(old_idx) < cint(LRs("NUM")) Then idx = LRs("NUM")
			
			
			FndData = FndData & "<li id='div_"&LRs("NUM")&"'>"
			FndData = FndData & "	<div class='top_line'>"
			FndData = FndData & "		<span class='ic_deco'>"
			FndData = FndData & "			<i class='fa fa-pencil-square'></i>"
			FndData = FndData & "		</span>"
			FndData = FndData & "		<span class='user_name'>"&ReplaceTagReText(LRs("ReqName"))&"</span>"
			FndData = FndData & "		<span class='write_date'>"&LRs("WriteDate")&"</span>"
			FndData = FndData & "	</div>"
			FndData = FndData & "	<div class='mid_line'>"
			FndData = FndData & "		<span>"&LRs("AreaGbNm")&"</span>"
			FndData = FndData & "		<span>"&LRs("AreaGbDt")&"</span>"
			FndData = FndData & "		<span>"&ReplaceTagReText(LRs("TeamNm"))&"</span>"
			FndData = FndData & "	</div>"
			
			IF LRs("TeamIDX") <> "" Then
				FndData = FndData & "	<div class='bot_line'>"
				FndData = FndData & "		<p class='maked'>'"&ReplaceTagReText(LRs("TeamNm"))&"' 소속이 생성되었습니다.</p>"
				FndData = FndData & "	</div>"
			End IF	
				
			FndData = FndData & "</li>"			
			
			old_idx = LRs("NUM")
			
			LRs.MoveNext
		Loop 
	End If 
	
		LRs.Close
	SET LRs = Nothing
	
	response.Write "<ul>"
	response.Write 	FndData	
	response.Write "<script>$('#cnt_board').val('"&cnt+cnt_board&"');</script>"	'출력된 컨텐츠 카운트 SET	
	
	IF TotalCount > cnt+cnt_board Then	
		response.Write "<li id='more"&idx&"'><a href=""#"" class=""more"" id="""&idx&""">더보기 ("&Ceil((cnt+cnt_board)/B_PSize)&"/"&TotalPage&")<span class='ic-deco'><i class='fa fa-plus' aria-hidden='true'></i></span></a></li>"
	Else
		response.Write "<li id='more"&idx&"'><a href=""#"" class=""more"" id="""&idx&""">마지막 페이지 ("&Ceil((cnt+cnt_board)/B_PSize)&"/"&TotalPage&")</a></li>"	
	End IF
	
	response.Write "</ul>"
	
	DBClose3()
  
%>