<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'역대 타이틀정보 조회
	'====================================================================================
	Check_AdminLogin()
		
	dim BlockPage  	 	: BlockPage 		= 10	'페이지
	dim B_PSize   		: B_PSize 			= 20	'페이지내 보여지는 목록카운트	
	dim cnt				: cnt 				= 0		'카운트	
			
	dim currPage   		: currPage  		= fInject(Request("currPage"))
	dim fnd_AssoCode	: fnd_AssoCode 		= fInject(Request("fnd_AssoCode"))
    dim fnd_ViewYN		: fnd_ViewYN 		= fInject(Request("fnd_ViewYN"))
   
	dim CSQL, CRs
	dim TotCount, TotPage
	dim CSearch
	dim FndData, CStrPG, CStrTP
   
   	IF Len(currPage) = 0 Then currPage = 1
   	
   	IF fnd_AssoCode <> "" Then CSearch = " AND A.AssoCode = '"&fnd_AssoCode&"'"
	IF fnd_ViewYN <> "" Then CSearch2 = " AND A.ViewYN = '"&fnd_ViewYN&"'"

   	CSQL = " 		SELECT ISNULL(COUNT(*),0) Cnt "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblCateSuccessive] A" 
	CSQL = CSQL & "	 	left join [KoreaBadminton].[dbo].[tblAssociationInfo] B on A.AssoCode = B.AssoCode"
	CSQL = CSQL & "			AND B.DelYN = 'N' " 
	CSQL = CSQL & "	WHERE A.DelYN = 'N' " &CSearch&CSearch2
	
'	response.Write CSQL
	
	SET CRs = DBCon.Execute(CSQL)	
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
	
	'==================================================================================================================================
	'카운트/페이지
	'==================================================================================================================================
	CStrTP = "<div><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
   
	CSQL = "		SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "		A.CateSuccessiveIDX"
	CSQL = CSQL & "		,A.AssoCode"
	CSQL = CSQL & "		,B.AssoNm AssoNm"
	CSQL = CSQL & "		,A.SuccessiveNm"
	CSQL = CSQL & "		,A.DatePeriod"
	CSQL = CSQL & "		,A.DatePeriodStart"
	CSQL = CSQL & "		,A.Orderby"
    CSQL = CSQL & "		,A.ViewYN"	 
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblCateSuccessive] A"
	CSQL = CSQL & "	 	left join [KoreaBadminton].[dbo].[tblAssociationInfo] B on A.AssoCode = B.AssoCode"
	CSQL = CSQL & "			AND B.DelYN = 'N' " 
	CSQL = CSQL & "	WHERE A.DelYN = 'N' "&CSearch&CSearch2
	CSQL = CSQL & "	ORDER BY A.Orderby, A.SuccessiveNm"
				
'	response.Write CSQL
				
	SET CRs = DBCon.Execute(CSQL)
	
	FndData = "			 <table class='table-list'>"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>번호</th>"
	FndData = FndData & "			<th>제목</th>"
	FndData = FndData & "			<th>협회</th>"												  
	FndData = FndData & "			<th>재임기간</th>"
	FndData = FndData & "			<th>취임일자</th>"
   	FndData = FndData & "			<th>순서</th>"
	FndData = FndData & "			<th>노출구분</th>"
	FndData = FndData & "		</tr>"
	FndData = FndData & "	</thead>"
	FndData = FndData & "	<tbody>"
	
	IF Not(CRs.Eof Or CRs.Bof) Then 

		CRs.Move (currPage - 1) * B_PSize
		
		Do Until CRs.eof

			cnt = cnt + 1
			
			FndData = FndData & "<tr onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("CateSuccessiveIDX"))&"','"&currPage&"');"" >"
			FndData = FndData & "	<td>"&cnt&"</td>"
			FndData = FndData & "	<td>"&ReHtmlSpecialChars(CRs("SuccessiveNm"))&"</td>"
			FndData = FndData & "	<td>"&ReHtmlSpecialChars(CRs("AssoNm"))&"</td>"	
			FndData = FndData & "	<td>"&ReHtmlSpecialChars(CRs("DatePeriod"))&"</td>"
			FndData = FndData & "	<td>"&ReHtmlSpecialChars(CRs("DatePeriodStart"))&"</td>"
			FndData = FndData & "	<td>"&CRs("Orderby")&"</td>"
			FndData = FndData & "	<td>"&CRs("ViewYN")&"</td>"
   			FndData = FndData & "</tr>"

			CRs.movenext
		Loop	
	ELSE
		FndData = FndData & "<tr><td colspan=7>등록된 정보가 없습니다.</td></tr>"
	End IF	
	
	FndData = FndData & "	</tbody>"
	FndData = FndData & "</table>"
	
		CRs.Close
	SET CRs = Nothing
	
	'==================================================================================================================================
	'페이징
	'==================================================================================================================================
	dim intTemp

	CStrPG = CStrPG & " <ul class='pagination'>"
	
	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	
	If intTemp = 1 Then
		CStrPG = CStrPG & "<li class='prev'><a href='javascript:;' class='fa fa-angle-left'></a></li>"
	Else 
		CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp - BlockPage&"');"" class='prev'></a></li> "
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
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&valType&"','','"&intTemp&"');"" class='next'></a></li>"
	End IF	
  
    CStrPG = CStrPG & "</ul>"
	'==================================================================================================================================
	
	
	'출력	
	response.Write CStrTP	'카운트/페이지
	response.Write FndData	'목록 테이블
		
	IF TotalCount > 0 Then response.Write CStrPG	'페이징
	'==================================================================================================================================
	
		
	
	DBClose()
	
%>