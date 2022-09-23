<!--#include file="../Library/config.asp"-->
<%
	'회원리스트 조회
		
	dim BlockPage   : BlockPage 	= 10	'페이지
	dim B_PSize   	: B_PSize 		= 20	'페이지내 보여지는 목록카운트

	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3, CSearch4, CSearch5, CSearch6
	dim FndData, CStrPG, CStrTP
	
	dim currPage   		: currPage  		= fInject(Request("currPage"))
	dim fnd_EnterType  	: fnd_EnterType 	= fInject(Request("fnd_EnterType"))
	dim fnd_SEX   		: fnd_SEX 			= fInject(Request("fnd_SEX"))	
	dim fnd_User		: fnd_User 			= fInject(Request("fnd_User"))
	dim fnd_PlayerReln	: fnd_PlayerReln	= fInject(Request("fnd_PlayerReln"))
	dim fnd_Team		: fnd_Team			= fInject(Request("fnd_Team"))
	dim SDate			: SDate				= fInject(Request("SDate"))
	dim EDate			: EDate				= fInject(Request("EDate"))
	
	
	IF SDate <> "" Then SDate = replace(SDate, "/","")
	IF EDate <> "" Then EDate = replace(EDate, "/","")
	
'	response.Write currPage		
'	response.End()
	
	dim cnt			: cnt = 0			'카운트			
	dim CSQL, CRs

	IF Len(currPage) = 0 Then currPage = 1
	
	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearch5 = " AND DateDiff(d, '"&SDate&"', CONVERT(DATE, M.SrtDate))>=0 AND DateDiff(d, CONVERT(DATE, M.SrtDate), '"&EDate&"')>=0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch5 = " AND DateDiff(d, CONVERT(DATE, M.SrtDate), '"&SDate&"')=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch5 = " AND DateDiff(d, '"&EDate&"', CONVERT(DATE, M.SrtDate))=0 "
	Else
	End IF
	
	IF fnd_EnterType <> "" Then CSearch = " AND M.EnterType = '"&fnd_EnterType&"'"
	IF fnd_SEX <> "" Then CSearch2 = " AND M.SEX = '"&fnd_SEX&"'"
	IF fnd_User <> "" Then	CSearch3 = " AND M.UserName Like '%"&fnd_User&"%' "

	'회원구분 조회
	IF fnd_PlayerReln <> "" Then	
		SELECT CASE fnd_PlayerReln
			CASE "P"
				CSearch4 = " AND (M.PlayerReln = 'A' OR M.PlayerReln = 'B' OR M.PlayerReln = 'Z')"
			CASE "R"
				CSearch4 = " AND (M.PlayerReln = 'R' OR M.PlayerReln = 'K' OR M.PlayerReln = 'S')"	
			CASE ELSE
				CSearch4 = " AND M.PlayerReln = '"&fnd_PlayerReln&"'"	
		END SELECT		
	End IF	

	'팀소속조회 시 SQL
	IF fnd_Team <> "" Then 
		CSearch6 = "		inner join [Sportsdiary].[dbo].[tblTeamInfo] T on M.Team = T.Team "
		CSearch6 = CSearch6 & " AND T.DelYN = 'N' "
		CSearch6 = CSearch6 & " AND T.SportsGb = '"&Request.Cookies("SportsGb")&"' "
		CSearch6 = CSearch6 & " AND T.NowRegYN = 'Y' "
		CSearch6 = CSearch6 & " AND T.TeamNm like '%"&fnd_Team&"%'"
	Else
		CSearch6 = CSearch6 & " left join [Sportsdiary].[dbo].[tblTeamInfo] T on M.Team = T.Team "
		CSearch6 = CSearch6 & " 	AND T.DelYN = 'N' "
		CSearch6 = CSearch6 & " 	AND T.SportsGb = '"&Request.Cookies("SportsGb")&"' "
		CSearch6 = CSearch6 & " 	AND T.NowRegYN = 'Y' "
	End IF	
	
	
	CSQL = " 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblMember] M " &CSearch6	
	CSQL = CSQL & "	WHERE M.DelYN = 'N' " 
	CSQL = CSQL & "		AND M.SportsType = '"&Request.Cookies("SportsGb")&"' " &CSearch&CSearch2&CSearch3&CSearch4&CSearch5
'	response.Write CSQL
	SET CRs = Dbcon.Execute(CSQL)	
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
	
	CStrTP = "<div><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
	
	response.Write CStrTP
	
	CSQL = "		SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "		T.TeamNm "
	CSQL = CSQL & "		,T.Team Team "
	CSQL = CSQL & "		,T.sido "
	CSQL = CSQL & "		,ISNULL([SportsDiary].[dbo].[FN_SidoName] (T.sido, '"&Request.Cookies("SportsGb")&"'),LEFT(M.Address, 2)) SidoNm "
	CSQL = CSQL & "		,M.UserName "
	CSQL = CSQL & "		,M.UserEnName "
	CSQL = CSQL & "		,M.UserPhone "
	CSQL = CSQL & "		,M.SmsYn "
'	CSQL = CSQL & "		,CONVERT(CHAR(10), CONVERT(DATE, M.Birthday), 102) Birthday "
	CSQL = CSQL & "		,M.Birthday "
	CSQL = CSQL & "		,CASE M.Sex WHEN 'Man' THEN '남' WHEN 'WoMan' THEN '여' END Sex "
	CSQL = CSQL & "		,M.UserID "
	CSQL = CSQL & "		,M.Email "
	CSQL = CSQL & "		,M.EmailYn "
	CSQL = CSQL & "		,M.EnterType "
	CSQL = CSQL & "		,CASE M.PlayerReln "
	CSQL = CSQL & "			WHEN 'T' THEN SportsDiary.dbo.FN_PubName('sd03900' + M.LeaderType) "
	CSQL = CSQL & "			WHEN 'A' THEN '부' "
	CSQL = CSQL & "			WHEN 'B' THEN '모' "
	CSQL = CSQL & "			WHEN 'Z' THEN M.PlayerRelnMemo +'('+[SportsDiary].[dbo].[FN_PlayerName] (M.PlayerIDX) +')' "
	CSQL = CSQL & "			WHEN 'D' THEN '일반' "
	CSQL = CSQL & "		 ELSE '선수(관원)' "
	CSQL = CSQL & "		 END TypeNm " 
	CSQL = CSQL & "		,M.Address "
	CSQL = CSQL & "		,M.AddressDtl "
	CSQL = CSQL & "		,CONVERT(CHAR(10), CONVERT(DATE, M.SrtDate), 102) WriteDt"
	CSQL = CSQL & "	FROM [Sportsdiary].[dbo].[tblMember] M "&CSearch6
	CSQL = CSQL & "	WHERE M.DelYN = 'N' "
	CSQL = CSQL & "		AND M.SportsType = '"&Request.Cookies("SportsGb")&"' "&CSearch&CSearch2&CSearch3&CSearch4&CSearch5
	CSQL = CSQL & "	ORDER BY M.SrtDate DESC, UserName	 "
				
'	response.Write CSQL
				
	SET CRs = Dbcon.Execute(CSQL)
	
	FndData = "			 <table class='table-list member-info'>"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>번호</th>"
	FndData = FndData & "			<th>구분</th>"
	FndData = FndData & "			<th>이름</th>"
'	FndData = FndData & "			<th>영문</th>"
	FndData = FndData & "			<th>생년월일</th>"
	FndData = FndData & "			<th>성별</th>"	
	FndData = FndData & "			<th>회원구분</th>"	
	FndData = FndData & "			<th>지역</th>"
	FndData = FndData & "			<th>소속</th>"	
	FndData = FndData & "			<th>팀코드</th>"	
	FndData = FndData & "			<th>Phone</th>"
	FndData = FndData & "			<th>SMS수신</th>"
	FndData = FndData & "			<th>이메일</th>"
	FndData = FndData & "			<th>이메일수신</th>"
	FndData = FndData & "			<th>주소</th>"
	FndData = FndData & "			<th>가입일</th>"
	FndData = FndData & "		</tr>"
	FndData = FndData & "	</thead>"
	FndData = FndData & "	<tbody>"
	
	If Not(CRs.Eof Or CRs.Bof) Then 

		CRs.Move (currPage - 1) * B_PSize
		
		Do Until CRs.eof

			cnt = cnt + 1
			
			FndData = FndData & "<tr>"
			FndData = FndData & "	<td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
			FndData = FndData & "	<td>"&CRs("EnterType")&"</td>"
			FndData = FndData & "	<td>"&CRs("UserName")&"</td>"
'			FndData = FndData & "	<td>"&CRs("UserEnName")&"</td>"
			FndData = FndData & "	<td>"&CRs("Birthday")&"</td>"
			FndData = FndData & "	<td>"&CRs("Sex")&"</td>"					
			FndData = FndData & "	<td>"&CRs("TypeNm")&"</td>"
			FndData = FndData & "	<td>"&CRs("SidoNm")&"</td>"			
			FndData = FndData & "	<td>"&CRs("TeamNm")&"</td>"			
			FndData = FndData & "	<td>"&CRs("Team")&"</td>"
			FndData = FndData & "	<td>"&CRs("UserPhone")&"</td>"
			FndData = FndData & "	<td>"&CRs("SmsYn")&"</td>"
			FndData = FndData & "	<td>"&CRs("Email")&"</td>"
			FndData = FndData & "	<td>"&CRs("EmailYn")&"</td>"
			FndData = FndData & "	<td>"&CRs("Address") &" "&CRs("AddressDtl")&"</td>"
			FndData = FndData & "	<td>"&CRs("WriteDt")&"</td>"
			FndData = FndData & "</tr>"

			CRs.movenext
		Loop	

	End IF	
	
	FndData = FndData & "	</tbody>"
	FndData = FndData & "</table>"
	
		CRs.Close
	SET CRs = Nothing
		
	response.Write FndData
	
	
	dim intTemp

	CStrPG = CStrPG & " <div class='bullet-wrap'>"
	CStrPG = CStrPG & " <div class='board-bullet pagination'>"
	
	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	
	If intTemp = 1 Then
		
	Else 
		CStrPG = CStrPG & "<li class='prev'> <a href=""javascript:chk_Submit('"&intTemp - BlockPage&"');"" class='prev'><img src='../images/board/board-l-arrow@3x.png' alt='이전페이지'></a></li> "
	End If	
	
	dim intLoop : intLoop = 1
	
	Do Until intLoop > BlockPage Or intTemp > TotalPage
	
		If CInt(intTemp) = CInt(currPage) Then
			CStrPG = CStrPG & "<li> <a href='#' class=""on"">"&intTemp&"</a> </li>" 
		Else
			CStrPG = CStrPG & "<li> <a href=""javascript:chk_Submit('"&intTemp&"');"">"&intTemp&"</a> </li>"
		End If
		
		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop
	
	IF intTemp > TotalPage Then

	Else
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&intTemp&"');"" class='next'><img src='../images/board/board-r-arrow@3x.png' alt='다음페이지'></a></li>"
	End IF	
  
    CStrPG = CStrPG & "</div>"
    CStrPG = CStrPG & "</div>"
	
	response.Write CStrPG

	
	DBClose()

	
%>