<!--#include file="../../dev/dist/config.asp"-->
<%
	'====================================================================================
	'주요국제대회정보리스트 조회
	'====================================================================================
	Check_AdminLogin()

	dim BlockPage     	: BlockPage     = 10  '페이지
	dim B_PSize       	: B_PSize       = 10   '페이지내 보여지는 목록카운트  
	
												
	dim currPage      	: currPage      = fInject(Request("currPage"))
	dim fnd_Division   	: fnd_Division  = fInject(Request("fnd_Division"))
	dim fnd_MajorGame	: fnd_MajorGame	= fInject(Request("fnd_MajorGame"))																							
	
	dim valType
	dim TotCount, TotPage
	dim CSearch, CSearch2
	dim FndData, CStrPG, CStrTP
	dim cnt, i

	dim CSQL, CRs

	IF Len(currPage) = 0 Then currPage = 1
	
	IF fnd_Division <> "" OR fnd_Division <> "" OR fnd_MajorGame <> "" Then valType = "FND"

	
	IF fnd_Division <> "" Then CSearch = " AND Division = '"&fnd_Division&"'"								
	IF fnd_MajorGame <> "" Then CSearch2 = " AND GameType = '"&fnd_MajorGame&"'"		

	CSQL = "    SELECT ISNULL(COUNT(*),0) Cnt "
	CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblMajorGameInfo] A" 
	CSQL = CSQL & " WHERE DelYN = 'N'"&CSearch&CSearch2

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
	CSQL = CSQL & "		MajorGameIDX"
	CSQL = CSQL & "		,CASE Division WHEN 'GAME' THEN '국제종합경기' ELSE '주요국제대회' END DivisionNm"
	CSQL = CSQL & "		,Division"
   	CSQL = CSQL & "		,GameYear"	
	CSQL = CSQL & "		,GamePlace"
   	CSQL = CSQL & "		,Contents"
    CSQL = CSQL & "		,B.PubName GameTypeNm"	
	CSQL = CSQL & "		,GameTypeSub"
   	CSQL = CSQL & "		,C.PubName GameTypeSubNm"
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblMajorGameInfo] A"
   	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] B on A.GameType = B.PubCode AND B.DelYN = 'N' "
   	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] C on A.GameTypeSub = C.PubCode AND C.DelYN = 'N'"
	CSQL = CSQL & "	WHERE A.DelYN = 'N'"&CSearch&CSearch2
	CSQL = CSQL & "	ORDER BY Division, GameType, GameTypeSub, InsDate DESC"

	'response.Write CSQL

	SET CRs = DBCon.Execute(CSQL)

	FndData = "      <table class='table-list'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>대회구분Ⅰ</th>"
	FndData = FndData & "     <th>대회구분Ⅱ</th>"  	
	FndData = FndData & "     <th>대회구분Ⅲ</th>"
	FndData = FndData & "     <th>개최년도</th>"
	FndData = FndData & "     <th>개최장소</th>"
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"

	IF Not(CRs.Eof Or CRs.Bof) Then 

		CRs.Move (currPage - 1) * B_PSize

		Do Until CRs.eof

			cnt = cnt + 1

			FndData = FndData & "<tr onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("MajorGameIDX"))&"','"&currPage&"');"">"
			FndData = FndData & " <td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
			FndData = FndData & " <td>"&CRs("DivisionNm")&"</td>"
			FndData = FndData & " <td>"&CRs("GameTypeNm")&"</td>"			
			FndData = FndData & " <td>"&CRs("GameTypeSubNm")&"</td>"
			FndData = FndData & " <td>"&CRs("GameYear")&"</td>"
			FndData = FndData & " <td>"&ReHtmlSpecialChars(CRs("GamePlace"))&"</td>"
			FndData = FndData & "</tr>"

			RoleNm = ""

			CRs.movenext
		Loop  
	ELSE
		FndData = FndData & "<tr class='no-data'><td colspan=6>등록된 정보가 없습니다.</td></tr>"
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