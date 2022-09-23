<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'선수 리스트 조회
	'====================================================================================
	Check_AdminLogin()
		
	dim BlockPage  	 		: BlockPage 		= 10	'페이지
	dim B_PSize   			: B_PSize 			= 10	'페이지내 보여지는 목록카운트	
	dim cnt					: cnt 				= 0		'카운트				
	dim currPage   			: currPage  		= fInject(Request("currPage"))
	dim fnd_KeyWord			: fnd_KeyWord 		= fInject(Request("fnd_KeyWord"))
   	dim fnd_EnterType		: fnd_EnterType 	= fInject(Request("fnd_EnterType"))
   	dim fnd_KoreaTeamType	: fnd_KoreaTeamType	= fInject(Request("fnd_KoreaTeamType"))   
   	dim fnd_PlayerType		: fnd_PlayerType 	= fInject(Request("fnd_PlayerType"))   
	dim fnd_Year			: fnd_Year 			= fInject(Request("fnd_Year"))
   	dim fnd_Sex				: fnd_Sex 			= fInject(Request("fnd_Sex"))
	dim SDate				: SDate				= fInject(Request("SDate"))
	dim EDate				: EDate				= fInject(Request("EDate"))
	
	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3, CSearch4
	dim FndData, CStrPG, CStrTP	
	dim CSQL, CRs
	dim FSO
   	
   	SET FSO = CreateObject("Scripting.FileSystemObject") 
   
	IF Len(currPage) = 0 Then currPage = 1
	IF fnd_Year = "" Then fnd_Year = Year(Date())    
	
	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', A.WriteDate)>=0 AND DateDiff(d, A.WriteDate, '"&EDate&"')>=0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch = " AND DateDiff(d, A.WriteDate, '"&SDate&"')=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&EDate&"', A.WriteDate)=0 "
	Else
	End IF
											   
	IF fnd_Sex <> "" Then CSearch2 = " AND A.SEX = '"&fnd_Sex&"'"
	IF fnd_EnterType <> "" Then CSearch3 = " AND A.EnterType = '"&fnd_EnterType&"'"
	IF fnd_KoreaTeamType <> "" Then CSearch4 = " AND C.TeamGb = '"&fnd_KoreaTeamType&"'"
	IF fnd_PlayerType <> "" Then CSearch5 = " AND A.PlayerType = '"&fnd_PlayerType&"'"
	
	'키워드 검색 [이름, 생년월일, 팀코드, 팀명, 전화번호, 이메일, 체육인번호]
	dim search(6)

	search(0) = "A.UserName"
	search(1) = "A.Birthday"
	search(2) = "A.Team"
	search(3) = "A.UserPhone"
	search(4) = "A.Email"
   	search(5) = "A.AthleteCode"
    search(6) = "B.TeamNm"
	
	IF fnd_KeyWord <> "" Then
		For i = 0 To 6
			CSearch6 = CSearch6 & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
		Next	
		CSearch6 = " AND ("&mid(CSearch6, 5)&")"
	End IF
	
	CSQL = " 		SELECT ISNULL(COUNT(*),0) Cnt"
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblMemberHistory] A"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] B on A.Team = B.Team AND B.DelYN = 'N' AND B.RegYear = '"&fnd_Year&"'"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblMemberKorea] C on A.MemberIDX = C.MemberIDX AND C.DelYN = 'N' AND C.RegYear = '"&fnd_Year&"'"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] D on C.TeamGb = D.PubCode AND D.DelYN = 'N' AND D.PPubCode = 'KOREATEAM'"	
	CSQL = CSQL & "	WHERE A.DelYN = 'N'"
	CSQL = CSQL & "		AND A.RegYear = '"&fnd_Year&"'"&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6
	
'	response.Write CSQL
	
	SET CRs = DBCon.Execute(CSQL)	
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
	
	
	'카운트/페이지
	CStrTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
	

	'회원리스트 조회	
	CSQL = "		SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "		A.MemberHistoryIDX "
	CSQL = CSQL & "		,A.MemberIDX "
	CSQL = CSQL & "		,A.EnterType "	
	CSQL = CSQL & "		,CASE A.EnterType WHEN 'E' THEN '엘리트' ELSE '체육동호인' END EnterTypeNm"
	CSQL = CSQL & "		,D.PubName KoreaTeamNm"
	CSQL = CSQL & "		,E.PubName PlayerTypeNm"
	CSQL = CSQL & "		,C.SubstituteYN"   
	CSQL = CSQL & "		,A.UserName "
	CSQL = CSQL & "		,A.UserEnName "
	CSQL = CSQL & "		,A.UserPhone "
	CSQL = CSQL & "		,CONVERT(CHAR(10), CONVERT(DATE, A.Birthday), 102) Birthday"
	CSQL = CSQL & "		,A.Email "
	CSQL = CSQL & "		,A.Sex "
	CSQL = CSQL & "		,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
	CSQL = CSQL & "		,CONVERT(CHAR(10), A.WriteDate, 102) RegDate "
	CSQL = CSQL & "		,A.AthleteCode "
	CSQL = CSQL & "		,A.BWFCode"
	CSQL = CSQL & "		,A.Team"
	CSQL = CSQL & "		,A.Photo"	
	CSQL = CSQL & "		,A.NowRegYN"	
	CSQL = CSQL & "		,B.TeamNm"	
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblMemberHistory] A"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] B on A.Team = B.Team AND B.DelYN = 'N' AND B.RegYear = '"&fnd_Year&"'"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblMemberKorea] C on A.MemberIDX = C.MemberIDX AND C.DelYN = 'N' AND C.RegYear = '"&fnd_Year&"' AND C.MemberType = 'P'"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] D on C.TeamGb = D.PubCode AND D.DelYN = 'N' AND D.PPubCode = 'KOREATEAM'"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] E on A.PlayerType = E.PubCode AND E.DelYN = 'N' AND E.PPubCode = 'B008'"
	CSQL = CSQL & "	WHERE A.DelYN = 'N'"
	CSQL = CSQL & "		AND A.RegYear = '"&fnd_Year&"'"&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6
	CSQL = CSQL & "	ORDER BY A.WriteDate DESC, A.UserName"
				
	'response.Write CSQL
				
	SET CRs = DBCon.Execute(CSQL)
	
	FndData = "			 <table class='table-list'>"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>번호</th>"
	FndData = FndData & "			<th>이미지</th>"	
	FndData = FndData & "			<th>구분</th>"	
	FndData = FndData & "			<th>선수구분</th>"		
	FndData = FndData & "			<th>대표팀구분</th>"		
	FndData = FndData & "			<th>이름</th>"
	FndData = FndData & "			<th>영문</th>"	
	FndData = FndData & "			<th>생년월일</th>"
	FndData = FndData & "			<th>성별</th>"		
	FndData = FndData & "			<th>팀명</th>"
	FndData = FndData & "			<th>팀코드</th>"		
	FndData = FndData & "			<th>연락처</th>"
	FndData = FndData & "			<th>체육인번호</th>"
	FndData = FndData & "			<th>BWF</th>"			
	FndData = FndData & "			<th>체육회등록</th>"				
	FndData = FndData & "			<th>등록일</th>"
	FndData = FndData & "		</tr>"
	FndData = FndData & "	</thead>"
	FndData = FndData & "	<tbody>"
	
	IF Not(CRs.Eof Or CRs.Bof) Then 

		CRs.Move (currPage - 1) * B_PSize
		
		Do Until CRs.eof

			cnt = cnt + 1
			
			FndData = FndData & "<tr style='cursor:pointer' onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("MemberHistoryIDX"))&"','"&currPage&"');"" >"
			FndData = FndData & "	<td>" & totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>"	
			
			IF CRs("Photo")<>"" Then
				'실제경로에 이미지파일 있는지 체크
				IF FSO.FileExists(global_filepath&"Player\"&CRs("EnterType")&"\"&CRs("Photo")) Then 
					FndData = FndData & "<td><img src='"&global_filepathUrl&"Player/"&CRs("EnterType")&"/"&CRs("Photo")&"' width='50' alt=''></td>"
				Else
					FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
				End IF	
			Else
				FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
			End IF
			
			FndData = FndData & "	<td>" & CRs("PlayerTypeNm")&"</td>"
			FndData = FndData & "	<td>" & CRs("EnterTypeNm")&"</td>"
			FndData = FndData & "	<td>" & CRs("KoreaTeamNm")
			
			IF CRs("SubstituteYN") = "Y" Then FndData = FndData &	" 후보팀"
		
			FndData = FndData &	"	</td>"
			FndData = FndData & "	<td>" & CRs("UserName")&"</td>"
			FndData = FndData & "	<td>" & ReHtmlSpecialChars(CRs("UserEnName"))&"</td>"
			FndData = FndData & "	<td>" & CRs("Birthday")&"</td>"
			FndData = FndData & "	<td>" & CRs("SexNm")&"</td>"
			FndData = FndData & "	<td>" & CRs("TeamNm")&"</td>"			
			FndData = FndData & "	<td>" & CRs("Team")&"</td>"
			FndData = FndData & "	<td>" & CRs("UserPhone")&"</td>"
			FndData = FndData & "	<td>" & CRs("AthleteCode")&"</td>"
			FndData = FndData & "	<td>" & CRs("BWFCode")&"</td>"			
			FndData = FndData & "	<td>" & CRs("NowRegYN")&"</td>"			
			FndData = FndData & "	<td>" & CRs("RegDate")&"</td>"
			FndData = FndData & "</tr>"
		
			CRs.movenext
		Loop	
	ELSE
		FndData = FndData & "<tr><td colspan=16>일치하는 정보가 없습니다.</td></tr>"
	End IF	
	
	FndData = FndData & "	</tbody>"
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
	response.Write CStrTP	'카운트/페이지
	response.Write FndData	'목록 테이블
		
	IF TotalCount > 0 Then response.Write CStrPG	'페이징
	
	
	DBClose()
	
%>