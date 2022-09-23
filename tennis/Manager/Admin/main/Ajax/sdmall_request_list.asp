<!--#include file="../../dev/dist/config.asp"-->
<%
	'문의내용 목록페이지
	 
	dim BlockPage   	: BlockPage     	= 10  	'페이지
	dim B_PSize     	: B_PSize       	= 10   	'페이지내 보여지는 목록카운트  
	dim cnt       		: cnt         		= 0   	'카운트 
	
	dim currPage		: currPage 			= fInject(Request("currPage"))		'페이징
	dim SDate			: SDate	 			= fInject(Request("SDate"))		
  	dim EDate			: EDate	 			= fInject(Request("EDate"))		
	dim fnd_ResultGb	: fnd_ResultGb 		= fInject(Request("fnd_ResultGb"))
	dim fnd_KeyWord		: fnd_KeyWord 		= fInject(Request("fnd_KeyWord"))	

	

	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3
	dim FndData, CStrPG, CStrTP

	dim CSQL, CRs

	IF Len(currPage) = 0 Then currPage = 1
	IF fnd_ResultGb <> "" Then CSearch = " AND ResultGb = '"&fnd_ResultGb&"'"  

   	'등록일 검색
	IF SDate <> "" AND EDate <> "" Then
		CSearch2 = " AND DATEDIFF(d, InsDate, '"&SDate&"')>=0 AND DATEDIFF(d, '"&EDate&"', InsDate)>=0"
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch2 = " AND DateDiff(d, InsDate, '"&SDate&"')=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch2 = " AND DateDiff(d, '"&EDate&"', InsDate)=0 "
	Else
	End IF
												
	
	'키워드 검색 [회사명, 담당자명, 제목]
	dim search(2)

	search(0) = "UserName"	
	search(1) = "CompanyNm"
	search(2) = "Subject"
	
	IF fnd_KeyWord <> "" Then
		For i = 0 To 2
			CSearch3 = CSearch3 & " OR "&search(i)&" like N'%"&fnd_KeyWord&"%'"
		Next
	
		CSearch3 = " AND ("&mid(CSearch3, 5)&")"
	End IF

	FndData = " 		 <table class='table-list notice-list basic-table'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>제목</th>"		
	FndData = FndData & "     <th>회사명</th>"  
	FndData = FndData & "     <th>담당자명</th>"	
	FndData = FndData & "     <th>취급상품군</th>"
	FndData = FndData & "     <th>전화번호</th>"  
	FndData = FndData & "     <th>이메일</th>"
	FndData = FndData & "     <th>홈페이지</th>"		
	FndData = FndData & "     <th>등록일</th>"		
	FndData = FndData & "     <th>처리구분</th>"	
	FndData = FndData & "     <th>처리일</th>"		
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"

	CSQL = "    	SELECT ISNULL(COUNT(*),0) Cnt "
	CSQL = CSQL & "   	,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & "	FROM [SD_Member].[dbo].[tblAllianceInfo] "
	CSQL = CSQL & "	WHERE DelYN = 'N' "&CSearch&CSearch2&CSearch3

	'response.Write CSQL

	SET CRs = DBCon.Execute(CSQL) 
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
  
  
	'카운트/페이지
	CStrTP = "<div class=""total_count""><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"

	'리스트 조회 
		
	CSQL = "    	SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "		AllianceIDX	"
	CSQL = CSQL & "		,Subject"
	CSQL = CSQL & "		,CompanyNm"	
	CSQL = CSQL & "		,ProductGbNm"	
	CSQL = CSQL & "		,CompanyURL"
	CSQL = CSQL & "		,UserName"
	CSQL = CSQL & "		,UserPhone"
	CSQL = CSQL & "		,UserEmail"		
	CSQL = CSQL & "		,CASE ResultGb "
	CSQL = CSQL & "			WHEN 'stan' THEN '대기중'"
	CSQL = CSQL & "			WHEN 'take' THEN '처리중'"
	CSQL = CSQL & "			WHEN 'comp' THEN '처리완료'"
	CSQL = CSQL & "			WHEN 'canc' THEN '취소'"	
	CSQL = CSQL & "			ELSE ''"	
	CSQL = CSQL & "			END ResultGbNm "	
	CSQL = CSQL & "		,ResultDate"
	CSQL = CSQL & "		,InsDate"	
	CSQL = CSQL & "		,CASE "
	CSQL = CSQL & "			WHEN DateDiff(d, InsDate, GETDATE()) <= 3 THEN '<img src=""./images/icon_new.png"" alt="""" class=""icon-new"" />' "
	CSQL = CSQL & "			ELSE '' "
	CSQL = CSQL & "			END NewIcon "		
	CSQL = CSQL & "	FROM [SD_Member].[dbo].[tblAllianceInfo] "	
	CSQL = CSQL & "	WHERE DelYN = 'N'	"&CSearch&CSearch2&CSearch3
	CSQL = CSQL & "	ORDER BY InsDate, CompanyNm, UserName"

	'response.Write CSQL
        
  	SET CRs = DBCon.Execute(CSQL)
	IF Not(CRs.Eof Or CRs.Bof) Then 

    	CRs.Move (currPage - 1) * B_PSize
    
    	Do Until CRs.eof

      		cnt = cnt + 1
						
			FndData = FndData & "<tr onClick=""chk_Submit('VIEW','"&encode(CRs("AllianceIDX"),0)&"','"&currPage&"');"" style='cursor:pointer'>"
			FndData = FndData & " 	<td>"&totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"
			FndData = FndData & " 	<td style=""text-align:left;"">"&ReplaceTagReText(CRs("Subject"))&CRs("NewIcon")&"</td>"
			FndData = FndData & " 	<td style=""text-align:left;"">"&ReplaceTagReText(CRs("CompanyNm"))&"</td>"		
			FndData = FndData & " 	<td>"&ReplaceTagReText(CRs("UserName"))&"</td>"
			FndData = FndData & " 	<td style=""text-align:left;"">"&ReplaceTagReText(CRs("ProductGbNm"))&"</td>"
			FndData = FndData & " 	<td>"&ReplaceTagReText(CRs("UserPhone"))&"</td>"
			FndData = FndData & " 	<td style=""text-align:left;"">"&ReplaceTagReText(CRs("UserEmail"))&"</td>"
			FndData = FndData & " 	<td style=""text-align:left;"">"&ReplaceTagReText(CRs("CompanyURL"))&"</td>"
			FndData = FndData & " 	<td>"&CRs("InsDate")&"</td>"
			FndData = FndData & " 	<td>"&CRs("ResultGbNm")&"</td>"
			FndData = FndData & " 	<td>"&CRs("ResultDate")&"</td>"
			FndData = FndData & "</tr>"
      
     		CRs.movenext
    	Loop  
 	ELSE
    	FndData = FndData & "<tr><td colspan=11>등록된 정보가 없습니다.</td></tr>"
  	End IF  
  		CRs.Close
	SET CRs = Nothing
		
	FndData = FndData & " </tbody>"
	FndData = FndData & "</table>"

	'페이징
	dim intTemp : intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1			
	dim intLoop : intLoop = 1
				
	CStrPG = " <div class='bullet-wrap'>"
	CStrPG = CStrPG & " <div class='board-bullet pagination'>"	

	If intTemp = 1 Then
		CStrPG = CStrPG & "<li class='prev'><a href='javascript:;' class='prev fa fa-angle-left'></a></li>"
	Else 
		CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');"" class='prev fa fa-angle-left'></a></li> "
	End If 	

	Do Until intLoop > BlockPage Or intTemp > TotalPage

		If CInt(intTemp) = CInt(currPage) Then
			CStrPG = CStrPG & "<li><a href='javascript:;' class='on'>"&intTemp&"</a></li>" 
		Else
			CStrPG = CStrPG & "<li><a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"">"&intTemp&"</a></li>"
		End If

		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop

	IF intTemp > TotalPage Then
		CStrPG = CStrPG & "<li class='next'><a href='javascript:;' class='next fa fa-angle-right'></a></li>"
	Else
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" class='fnext fa fa-angle-right'></a></li>"
	End IF  

	CStrPG = CStrPG & "		</div>"
	CStrPG = CStrPG & " </div>"
  
  
  	'출력  
  	response.Write CStrTP 	'카운트/페이지
 	response.Write FndData  '목록 테이블
    
  	IF TotalCount > 0 Then response.Write CStrPG  '페이징
  
  
  	DBClose()
  
%>
