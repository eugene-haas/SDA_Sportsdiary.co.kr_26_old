<!--#include file="../../dev/dist/config.asp"-->
<%
	'====================================================================================
	'리스트 조회
	'====================================================================================
	Check_AdminLogin()

	dim BlockPage     	: BlockPage     = 10  '페이지
	dim B_PSize       	: B_PSize       = 10   '페이지내 보여지는 목록카운트  
	dim valDate     	: valDate     	= Date() 
												
	dim currPage      	: currPage      = fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
	dim fnd_Year	   	: fnd_Year   	= fInject(Request("fnd_Year"))												
	dim fnd_Country   	: fnd_Country  	= fInject(Request("fnd_Country"))																								
	
	dim valType
	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3
	dim FndData, CStrPG, CStrTP
	dim cnt, i

	dim CSQL, CRs

	IF Len(currPage) = 0 Then currPage = 1
	
	IF fnd_KeyWord <> "" OR fnd_Year <> "" OR fnd_Country <> "" Then valType = "FND"
	

	'키워드 검색 [대회명, 대회명영문, 도시, 대회장소]
	dim search(3)

	search(0) = "GameTitleName"
	search(1) = "GameTitleEnName"
	search(2) = "City"	
	search(3) = "GamePlace"
	
	IF fnd_KeyWord <> "" Then
		For i = 0 To 3
			CSearch = CSearch & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
		Next
	
		CSearch = " AND ("&mid(CSearch, 5)&")"
	End IF
	
	IF fnd_Year <> "" Then CSearch2 = "	AND A.GameS like '"&fnd_Year&"%'"								
	IF fnd_Country <> "" Then CSearch3 = "	AND A.ct_serial = '"&fnd_Country&"'"		

	CSQL = "    SELECT ISNULL(COUNT(*),0) Cnt "
	CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitleIntl] A" 
	CSQL = CSQL & " WHERE DelYN = 'N'"&CSearch&CSearch2&CSearch3

	' response.Write CSQL

	SET CRs = DBCon.Execute(CSQL) 

	TotalCount = formatnumber(CRs(0),0)
	TotalPage = CRs(1)
	
	'카운트/페이지
	CStrTP = "<div class=""total_count""><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
	

	'리스트 조회
	CSQL = "    SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "		A.GameTitleIDX"
	CSQL = CSQL & "		,GameTitleName"
	CSQL = CSQL & "		,GameTitleEnName"
	CSQL = CSQL & "		,GameS"	
	CSQL = CSQL & "		,GameE"
	CSQL = CSQL & "		,ViewYN"
	CSQL = CSQL & "		,B.CountryNm"
	CSQL = CSQL & "		,City" 
	CSQL = CSQL & "		,GamePlace"
	CSQL = CSQL & "		,URLMatch"
	CSQL = CSQL & "		,URLSchedule"
	CSQL = CSQL & "		,CASE "
	CSQL = CSQL & "			WHEN PlayerListFile <> '' OR GameSceduleFile <> '' OR GameResultFile <> '' THEN '<img src=""/DocImg/Doc/doc_other.png"" alt=>' "
'	CSQL = CSQL & "			ELSE 'N' "
	CSQL = CSQL & "			END AttachFile"
	CSQL = CSQL & "		,CASE"
	CSQL = CSQL & "			WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 THEN" 
	CSQL = CSQL & "				CASE" 
	CSQL = CSQL & "					WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 AND DATEDIFF(d, '"&valDate&"', CONVERT(DATE, GameE))>=0 THEN '0'"
	CSQL = CSQL & "					ELSE '2'"
	CSQL = CSQL & "					END"
	CSQL = CSQL & "			ELSE '1'"			
	CSQL = CSQL & "			END StateGameType" 
	CSQL = CSQL & "		,CASE"
	CSQL = CSQL & "			WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 THEN" 
	CSQL = CSQL & "				CASE"
	CSQL = CSQL & "					WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"')>=0 AND DATEDIFF(d, '"&valDate&"', CONVERT(DATE, GameE))>=0 THEN '진행중'"
	CSQL = CSQL & "					ELSE '종료'"
	CSQL = CSQL & "					END" 	
	CSQL = CSQL & "			ELSE 'D' + CONVERT(CHAR(10), DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"'))"
	CSQL = CSQL & "			END StateGameTypeNm"
	CSQL = CSQL & "		,DATEDIFF(d, CONVERT(DATE, GameS), '"&valDate&"') StartOnGameDate"	
	CSQL = CSQL & "		,A.ViewYN"
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblGameTitleIntl] A"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblCountryInfo] B on A.ct_serial = B.ct_serial AND B.DelYN = 'N'"			
	CSQL = CSQL & "	WHERE A.DelYN = 'N'"
	CSQL = CSQL & "		AND A.ViewYN = 'Y'"&CSearch&CSearch2&CSearch3
	'CSQL = CSQL & "	ORDER BY StateGameType, GameS"
	CSQL = CSQL & "	ORDER BY A.InsDate DESC, StateGameType, GameS"

	'response.Write CSQL

	SET CRs = DBCon.Execute(CSQL)

	FndData = "      <table class='table-list'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>구분</th>"
	FndData = FndData & "     <th>대회기간</th>"  	
	FndData = FndData & "     <th>대회명</th>"
	FndData = FndData & "     <th>국가</th>"
	FndData = FndData & "     <th>도시</th>"
	FndData = FndData & "     <th>대회장소</th>"
	FndData = FndData & "     <th>대진표(토너먼트소프트)</th>"
	FndData = FndData & "     <th>경기일정(토너먼트소프트)</th>"
	FndData = FndData & "     <th>첨부파일</th>"	
	FndData = FndData & "     <th>노출구분</th>"	
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"

	IF Not(CRs.Eof Or CRs.Bof) Then 

		CRs.Move (currPage - 1) * B_PSize

		Do Until CRs.eof

			cnt = cnt + 1

			FndData = FndData & "<tr>"
			FndData = FndData & " <td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
			FndData = FndData & " <td>"&CRs("StateGameTypeNm")&"</td>"
			FndData = FndData & " <td>"&CRs("GameS")&" ~ "&CRs("GameE")&"</td>"			
			FndData = FndData & " <td class='name' onClick=""chk_Submit('VIEW','"&CRs("GameTitleIDX")&"','"&currPage&"');"">"&CRs("GameTitleName")&"</td>"
			FndData = FndData & " <td>"&CRs("CountryNm")&"</td>"
			FndData = FndData & " <td>"&CRs("City")&"</td>"
			FndData = FndData & " <td>"&CRs("GamePlace")&"</td>"
			FndData = FndData & " <td>"
			IF CRs("URLMatch") <> "" Then FndData = FndData & "<a href='"&CRs("URLMatch")&"' target='_blank'>바로가기</a>"
			FndData = FndData &	" </td>"
			FndData = FndData & " <td>"
			IF CRs("URLSchedule") <> "" Then FndData = FndData & "<a href='"&CRs("URLSchedule")&"' target='_blank'>바로가기</a>"
			FndData = FndData &	" </td>"
			FndData = FndData & " <td>"&CRs("AttachFile")&"</td>"	
			FndData = FndData & " <td>"&CRs("ViewYN")&"</td>"
			FndData = FndData & "</tr>"

			RoleNm = ""

			CRs.movenext
		Loop  
	ELSE
		FndData = FndData & "<tr class='no-data'><td colspan=9>등록된 정보가 없습니다.</td></tr>"
	End IF  

	FndData = FndData & " </tbody>"
	FndData = FndData & "</table>"

		CRs.Close
	SET CRs = Nothing


	
	'페이징	
	dim intTemp

	CStrPG = CStrPG & " <div class='page_index'>"
	CStrPG = CStrPG & " <ul class='pagination'>"

	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1

	If intTemp = 1 Then
		CStrPG = CStrPG & "<li class='prev'><a href='javascript:;' class='fa fa-angle-left'></a></li>"
	Else 
		CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp - BlockPage&"');"" class='fa fa-angle-left'></a></li> "
	End If  

	dim intLoop : intLoop = 1

	Do Until intLoop > BlockPage Or intTemp > TotalPage

		If CInt(intTemp) = CInt(currPage) Then
			CStrPG = CStrPG & "<li class='active'><a href='#' >"&intTemp&"</a> </li>" 
		Else
			CStrPG = CStrPG & "<li><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"">"&intTemp&"</a> </li>"
		End If

		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop

	IF intTemp > TotalPage Then
		CStrPG = CStrPG & "<li class='next'><a href='javascript:;' class='fa fa-angle-right'></a></li>"
	Else
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"" class='fa fa-angle-right'></a></li>"
	End IF  

	CStrPG = CStrPG & "</ul>"
	CStrPG = CStrPG & "</div>"
	


	
	'출력	
	response.Write CStrTP '카운트/페이지
	response.Write FndData  '목록 테이블

	IF TotalCount > 0 Then response.Write CStrPG  '페이징
	

	DBClose()

%>