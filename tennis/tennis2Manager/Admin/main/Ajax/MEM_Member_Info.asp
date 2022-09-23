<!--#include file="../Library/config.asp"-->
<%
	'통합 회원리스트 조회
		
	dim BlockPage   : BlockPage 	= 10	'페이지
	dim B_PSize   	: B_PSize 		= 20	'페이지내 보여지는 목록카운트

	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3, CSearch4, CSearch5, CSearch6
	dim FndData, CStrPG, CStrTP
	
	dim currPage   		: currPage  		= fInject(Request("currPage"))
	dim fnd_SEX   		: fnd_SEX 			= fInject(Request("fnd_SEX"))	
	dim fnd_KeyWord		: fnd_KeyWord 		= fInject(Request("fnd_KeyWord"))
	dim SDate			: SDate				= fInject(Request("SDate"))
	dim EDate			: EDate				= fInject(Request("EDate"))
	
	dim cnt			: cnt = 0			'카운트			
	dim CSQL, CRs

	IF Len(currPage) = 0 Then currPage = 1
	IF fnd_SEX <> "" Then CSearch = " AND SEX = '"&fnd_SEX&"'"
	
	'키워드 검색 [이름, 이메일, 전화번호, 생년월일]
	dim search(3)

	search(0) = "UserName"
	search(1) = "Email"
	search(2) = "UserPhone"
	search(3) = "Birthday"
	
	IF fnd_KeyWord <> "" Then
		For i = 0 To 3
			CSearch2 = CSearch2 & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
		Next
	
		CSearch2 = " AND ("&mid(CSearch2, 5)&")"
	End IF

	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearc3 = " AND DateDiff(d, '"&SDate&"', CONVERT(DATE, CONVERT(CHAR(10), WriteDate, 121)))>=0 AND DateDiff(d, CONVERT(DATE, CONVERT(CHAR(10), WriteDate, 121)), '"&EDate&"')>=0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearc3 = " AND DateDiff(d, CONVERT(DATE, CONVERT(CHAR(10), WriteDate, 121)), '"&SDate&"')=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearc3 = " AND DateDiff(d, '"&EDate&"', CONVERT(DATE, CONVERT(CHAR(10), WriteDate, 121)))=0 "
	Else
	End IF

	
	
	CSQL = " 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember]"
	CSQL = CSQL & "	WHERE DelYN = 'N' "&CSearch&CSearch2&CSearch3 
'	response.Write CSQL
	SET CRs = DBCon3.Execute(CSQL)	
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
	
	CStrTP = "<div><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
	
	response.Write CStrTP
	
	CSQL = "		SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "		,UserID"
	CSQL = CSQL & "		,UserName "
	CSQL = CSQL & "		,UserEnName "
	CSQL = CSQL & "		,Sex "
	CSQL = CSQL & "		,CASE Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm "
	CSQL = CSQL & "		,UserPhone "
	CSQL = CSQL & "		,SmsYn "
	CSQL = CSQL & "		,SUBSTRING(Birthday, 0, 4)+'.'+SUBSTRING(Birthday, 5, 2)+'.'+SUBSTRING(Birthday, 7, 2) Birthday "
	CSQL = CSQL & "		,Email "
	CSQL = CSQL & "		,EmailYn "
	CSQL = CSQL & "		,PushYN"
	CSQL = CSQL & "		,PushYNDt"
	CSQL = CSQL & "		,Address "
	CSQL = CSQL & "		,AddressDtl "
	CSQL = CSQL & "		,WriteDate"
	CSQL = CSQL & "	FROM [SD_Member].[dbo].[tblMember] "
	CSQL = CSQL & "	WHERE DelYN = 'N' "&CSearch&CSearch2&CSearch3
	CSQL = CSQL & "	ORDER BY WriteDate DESC, UserName"
				
'	response.Write CSQL
				
	SET CRs = DBCon3.Execute(CSQL)
	
	FndData = "			 <table class='table-list member-info'>"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>번호</th>"
	FndData = FndData & "			<th>아이디</th>"
	FndData = FndData & "			<th>이름</th>"
	FndData = FndData & "			<th>생년월일</th>"
	FndData = FndData & "			<th>성별</th>"	
	FndData = FndData & "			<th>Phone</th>"
	FndData = FndData & "			<th>SMS수신</th>"
	FndData = FndData & "			<th>이메일</th>"
	FndData = FndData & "			<th>이메일수신</th>"
	FndData = FndData & "			<th>PUSH수신</th>"
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
			FndData = FndData & "	<td>"&CRs("UserID")&"</td>"
			FndData = FndData & "	<td>"&CRs("UserName")&"</td>"
			FndData = FndData & "	<td>"&CRs("Birthday")&"</td>"
			FndData = FndData & "	<td>"&CRs("SexNm")&"</td>"					
			FndData = FndData & "	<td>"&CRs("UserPhone")&"</td>"
			FndData = FndData & "	<td>"&CRs("SmsYn")&"</td>"
			FndData = FndData & "	<td>"&CRs("Email")&"</td>"
			FndData = FndData & "	<td>"&CRs("EmailYn")&"</td>"
			FndData = FndData & "	<td>"&CRs("PushYN")&"</td>"
			FndData = FndData & "	<td>"&CRs("Address") &" "&CRs("AddressDtl")&"</td>"
			FndData = FndData & "	<td>"&CRs("WriteDt")&"</td>"
			FndData = FndData & "</tr>"

			CRs.movenext
		Loop	
	ELSE
		FndData = FndData & "<tr>"
		FndData = FndData & "	<td colspan=12>등록된 정보가 없습니다.</td>"	
		FndData = FndData & "</tr>"
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
		CStrPG = CStrPG & "<li class='prev'> <a href=""javascript:chk_Submit('"&intTemp - BlockPage&"');"" class='prev fa fa-angle-left'></a></li> "
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
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('"&intTemp&"');"" class='next fa fa-angle-right'></a></li>"
	End IF	
  
    CStrPG = CStrPG & "</div>"
    CStrPG = CStrPG & "</div>"
	
	response.Write CStrPG

	
	DBClose3()

	
%>