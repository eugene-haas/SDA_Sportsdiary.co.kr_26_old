<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'지도자 리스트 조회
	'====================================================================================
	Check_AdminLogin()

	dim BlockPage     	: BlockPage     	= 10  '페이지
	dim B_PSize       	: B_PSize       	= 10  '페이지내 보여지는 목록카운트  
	dim cnt       		: cnt         		= 0   '카운트        
	dim currPage      	: currPage      	= fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord     	= fInject(Request("fnd_KeyWord"))
	dim fnd_LeaderType  : fnd_LeaderType  	= fInject(Request("fnd_LeaderType"))    
	dim fnd_Year    	: fnd_Year      	= fInject(Request("fnd_Year"))
	dim fnd_Sex     	: fnd_Sex       	= fInject(Request("fnd_Sex"))
	dim SDate     		: SDate       		= fInject(Request("SDate"))
	dim EDate     		: EDate       		= fInject(Request("EDate"))

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
	IF fnd_LeaderType <> "" Then CSearch3 = " AND A.LeaderType = '"&fnd_LeaderType&"'"

	'키워드 검색 [이름, 생년월일, 팀코드, 팀명, 전화번호, 이메일, 체육인번호]
	dim search(6)

	search(0) = "A.UserName"
	search(1) = "A.Birthday"
	search(2) = "A.Team"
	search(3) = "A.UserPhone"
	search(4) = "A.Email"
	search(5) = "A.AthleteNum"
	search(6) = "C.TeamNm"

	IF fnd_KeyWord <> "" Then
		For i = 0 To 6
			CSearch4 = CSearch4 & " or "&search(i)&" like N'%"&fnd_KeyWord&"%'"
		Next  
		CSearch4 = " AND ("&mid(CSearch4, 5)&")"
	End IF
  
	CSQL = "   		SELECT ISNULL(COUNT(*),0) Cnt"
	CSQL = CSQL & "   	,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory] A"
	CSQL = CSQL & "   	left join [KoreaBadminton].[dbo].[tblPubCode] B on A.LeaderTypeSub = B.PubCode AND B.DelYN = 'N' AND B.PPubCode = 'COACH'"
	CSQL = CSQL & "   	left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] C on A.Team = C.Team AND C.DelYN = 'N' AND C.RegYear = '"&fnd_Year&"'"
	CSQL = CSQL & " WHERE A.DelYN = 'N'"
	CSQL = CSQL & "   	AND A.RegistYear = '"&fnd_Year&"'"&CSearch&CSearch2&CSearch3&CSearch4
  
' 	response.Write CSQL
  
  	SET CRs = DBCon.Execute(CSQL) 
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
  
  
	'카운트/페이지
	CStrTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
  

	'회원리스트 조회 
	CSQL = "    	SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "   	A.LeaderHistoryIDX "
	CSQL = CSQL & "   	,A.LeaderIDX "
	CSQL = CSQL & "   	,A.UserName "
	CSQL = CSQL & "   	,A.UserEnName "
	CSQL = CSQL & "   	,A.UserPhone "
	CSQL = CSQL & "   	,CASE WHEN ISNULL(A.Birthday, '') <> '' THEN LEFT(A.Birthday, 4) +'-'+ SUBSTRING(A.Birthday, 5, 2) +'-'+ SUBSTRING(A.Birthday, 7, 2) ELSE '' END Birthday"
	CSQL = CSQL & "   	,A.Email "
	CSQL = CSQL & "   	,A.Sex "
	CSQL = CSQL & "   	,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
	CSQL = CSQL & "   	,A.WriteDate "
	CSQL = CSQL & "   	,A.AthleteNum "
	CSQL = CSQL & "   	,A.Team"
	CSQL = CSQL & "   	,C.TeamNm"
	CSQL = CSQL & "		,E.PubName KoreaTeamNm"
	CSQL = CSQL & "		,D.SubstituteYN"   
'	CSQL = CSQL & "   	,A.Address"
'	CSQL = CSQL & "   	,A.AddressDtl"
	CSQL = CSQL & "   	,A.LeaderType"
	CSQL = CSQL & "   	,A.LeaderTypeNm"
	CSQL = CSQL & "   	,A.Photo"
	CSQL = CSQL & "   	,A.NowRegYN"
	CSQL = CSQL & "   	,B.PubName LeaderTypeSubNm"
	CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory] A"
	CSQL = CSQL & "   	left join [KoreaBadminton].[dbo].[tblPubCode] B on A.LeaderTypeSub = B.PubCode AND B.DelYN = 'N' AND B.PPubCode = 'COACH'"
	CSQL = CSQL & "   	left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] C on A.Team = C.Team AND C.DelYN = 'N' AND RegYear = '"&fnd_Year&"'"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblMemberKorea] D on A.LeaderIDX = D.MemberIDX AND D.DelYN = 'N' AND D.RegYear = '"&fnd_Year&"' AND D.MemberType = 'L'"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] E on D.TeamGb = E.PubCode AND E.DelYN = 'N' AND E.PPubCode = 'KOREATEAM'"
	CSQL = CSQL & " WHERE A.DelYN = 'N'"
	CSQL = CSQL & "   	AND A.RegistYear = '"&fnd_Year&"'"&CSearch&CSearch2&CSearch3&CSearch4
	CSQL = CSQL & " ORDER BY A.UserName"
        
  	'response.Write CSQL
	'Response.End
        
  	SET CRs = DBCon.Execute(CSQL)
  
	FndData = "      <table class='table-list'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>이미지</th>"	
	FndData = FndData & "     <th>대표팀구분</th>"  	
	FndData = FndData & "     <th>지도자구분</th>"  		
	FndData = FndData & "     <th>이름</th>"
	FndData = FndData & "     <th>영문</th>"  
	FndData = FndData & "     <th>생년월일</th>"
	FndData = FndData & "     <th>성별</th>"    
	FndData = FndData & "     <th>팀코드</th>"
	FndData = FndData & "     <th>팀명</th>"
	FndData = FndData & "     <th>연락처</th>"
	FndData = FndData & "     <th>체육인번호</th>"
	'FndData = FndData & "     <th>주소</th>"
	'FndData = FndData & "     <th>상세주소</th>"  
	FndData = FndData & "     <th>체육회등록</th>"  		
	FndData = FndData & "     <th>등록일</th>"
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"
  
  	IF Not(CRs.Eof Or CRs.Bof) Then 

    	CRs.Move (currPage - 1) * B_PSize
    
    	Do Until CRs.eof

      		cnt = cnt + 1
      
			FndData = FndData & "<tr style='cursor:pointer' onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("LeaderHistoryIDX"))&"','"&currPage&"');"" >"
			FndData = FndData & " <td>" & totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>" 
			
			IF CRs("Photo")<>"" Then
				
				'실제경로에 이미지파일 있는지 체크
				IF FSO.FileExists(global_filepath&"Leader\"&CRs("Photo")) Then 
					FndData = FndData & "<td><img src='"&global_filepathUrl&"Leader/"&CRs("Photo")&"' width='50' alt=''></td>"
				Else
					FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
				End IF	
			Else
				FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
			End IF			
			
			FndData = FndData & "	<td>" & CRs("KoreaTeamNm")			
			IF CRs("SubstituteYN") = "Y" Then FndData = FndData &	" 후보팀"		
		
			FndData = FndData & " <td>" & CRs("LeaderTypeNm")
			IF CRs("LeaderTypeSubNm") <> "" Then FndData = FndData & "("&CRs("LeaderTypeSubNm")&")"
			FndData = FndData & " </td>"  
			FndData = FndData & " <td>" & CRs("UserName")&"</td>"
			FndData = FndData & " <td>" & ReHtmlSpecialChars(CRs("UserEnName"))&"</td>"
			FndData = FndData & " <td>" & CRs("Birthday")&"</td>"
			FndData = FndData & " <td>" & CRs("SexNm")&"</td>"
			FndData = FndData & " <td>" & CRs("Team")&"</td>"
			FndData = FndData & " <td>" & CRs("TeamNm")&"</td>"     
			FndData = FndData & " <td>" & CRs("UserPhone")&"</td>"
			FndData = FndData & " <td>" & CRs("AthleteNum")&"</td>"
'			FndData = FndData & " <td>" & ReHtmlSpecialChars(CRs("Address"))&"</td>"
'			FndData = FndData & " <td>" & ReHtmlSpecialChars(CRs("AddressDtl"))&"</td>"
			FndData = FndData & " <td>" & CRs("NowRegYN")&"</td>"
			FndData = FndData & " <td>" & CRs("WriteDate")&"</td>"
			FndData = FndData & "</tr>"
    
      		CRs.movenext
    	Loop  
  	ELSE
    	FndData = FndData & "<tr><td colspan=15>일치하는 정보가 없습니다.</td></tr>"
  	End IF  
  		CRs.Close
  	SET CRs = Nothing
		
	FndData = FndData & " </tbody>"
	FndData = FndData & "</table>"


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