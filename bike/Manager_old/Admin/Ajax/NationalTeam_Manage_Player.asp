<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'리스트 조회 : 선수
	'====================================================================================
	Check_AdminLogin()

	dim BlockPage     	: BlockPage     	= 10  '페이지
	dim B_PSize       	: B_PSize       	= 10  '페이지내 보여지는 목록카운트  
	dim cnt         	: cnt           	= 0   '카운트  

	dim currPage      	: currPage     	 	= fInject(Request("currPage"))
	dim fnd_Year	   	: fnd_Year   		= fInject(Request("fnd_Year"))
	dim fnd_TeamGb 		: fnd_TeamGb 		= fInject(Request("fnd_TeamGb"))
	dim fnd_Sex 		: fnd_Sex 			= fInject(Request("fnd_Sex"))
	dim fnd_KeyWord   	: fnd_KeyWord   	= fInject(Request("fnd_KeyWord"))
	
	dim TotCount, TotPage
	dim CSearch, CSearch2
	dim FndData, CStrPG, CStrTP
    dim LSQL, LRs   
   	dim FSO
   	
   	SET FSO = CreateObject("Scripting.FileSystemObject") 
   
    IF Len(currPage) = 0 Then currPage = 1  
   	IF fnd_Year = "" Then fnd_Year = Year(Date())
   
   	IF fnd_TeamGb <> "" Then CSearch = " AND A.TeamGb = '"&fnd_TeamGb&"'"
	IF fnd_Sex <> "" Then CSearch2 = " AND A.Sex = '"&fnd_Sex&"'"
	IF fnd_KeyWord <> "" Then CSearch3 = " AND B.UserName like '%"&fnd_KeyWord&"%'"
  
  
    LSQL = "      	SELECT ISNULL(COUNT(*),0) Cnt"
	LSQL = LSQL & "     ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&")" 
	LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblMemberKorea] A"
	LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblMemberHistory] B on A.MemberIDX = B.MemberIDX AND B.DelYN = 'N' AND B.RegYear = '"&fnd_Year&"'"
	LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] C on B.Team = C.Team AND C.DelYN = 'N' AND C.RegYear = '"&fnd_Year&"'"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & " 	AND A.MemberType = 'P'"
	LSQL = LSQL & " 	AND A.RegYear = '"&fnd_Year&"'"&CSearch&CSearch2&CSearch3

  	SET LRs = DBCon.Execute(LSQL) 
    	TotalCount = formatnumber(LRs(0), 0)
    	TotalPage = LRs(1)   
  
  
    '카운트/페이지  
	CStrTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"

  
    '목록조회
    LSQL = "      	SELECT TOP "&currPage * B_PSize 
	LSQL = LSQL & "   	A.MemberKoreaIDX"
	LSQL = LSQL & "   	,A.MemberIDX"
	LSQL = LSQL & "   	,D.PubName TeamGbNm"
	LSQL = LSQL & "   	,CASE A.Sex WHEN 'Man' THEN '남자' ELSE '여자' END SEXNm "
	LSQL = LSQL & "   	,CASE A.SubstituteYN WHEN 'Y' THEN '후보팀' ELSE '' END SubstituteYNNm"
	LSQL = LSQL & "   	,A.PeriodDateS"	
   	LSQL = LSQL & "   	,A.PeriodDateE"	
	LSQL = LSQL & "   	,B.UserName"
	LSQL = LSQL & "   	,B.UserEnName"
	LSQL = LSQL & "   	,CASE WHEN B.Birthday<>'' THEN SUBSTRING(B.Birthday, 1, 4)+'.'+SUBSTRING(B.Birthday, 5, 2)+'.'+SUBSTRING(B.Birthday, 7, 2) END UserBirth"	
	LSQL = LSQL & "   	,B.PersonCode"	
	LSQL = LSQL & "   	,B.UserPhone"
	LSQL = LSQL & "   	,B.Email"
	LSQL = LSQL & "   	,B.Team"	
	LSQL = LSQL & "   	,B.Photo"	
	LSQL = LSQL & "   	,B.EnterType"	    
	LSQL = LSQL & "   	,C.TeamNm"	
	LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblMemberKorea] A"
	LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblMemberHistory] B on A.MemberIDX = B.MemberIDX AND B.DelYN = 'N' AND B.RegYear = '"&fnd_Year&"'"
	LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblTeamInfoHistory] C on B.Team = C.Team AND C.DelYN = 'N' AND C.RegYear = '"&fnd_Year&"'"
	LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblPubcode] D on A.TeamGb = D.PubCode AND D.DelYN = 'N' AND D.PPubCode = 'KOREATEAM'"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & " 	AND A.MemberType = 'P'"
	LSQL = LSQL & " 	AND A.RegYear = '"&fnd_Year&"' "&CSearch&CSearch2&CSearch3
	LSQL = LSQL & " ORDER BY B.UserName"
        
  '	response.Write LSQL
        
    SET LRs = DBCon.Execute(LSQL)
  
	FndData = "       <table class='table-list popup-table'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>이미지</th>"	
	FndData = FndData & "     <th>대표팀구분</th>"
	FndData = FndData & "     <th>성별</th>"	
	FndData = FndData & "     <th>후보구분</th>"	
	FndData = FndData & "     <th>이름</th>"
	FndData = FndData & "     <th>영문이름</th>"
	FndData = FndData & "     <th>생년월일</th>"	
	FndData = FndData & "     <th>체육인번호</th>"	
	FndData = FndData & "     <th>현소속팀</th>"
	FndData = FndData & "     <th>전화</th>"
	'FndData = FndData & "     <th>이메일</th>"
	FndData = FndData & "     <th>기간</th>"	
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"

  	IF Not(LRs.Eof Or LRs.Bof) Then 

    	LRs.Move (currPage - 1) * B_PSize

    	Do Until LRs.eof

      		cnt = cnt + 1
      
			FndData = FndData & "<tr onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(LRs("MemberKoreaIDX"))&"','"&currPage&"');"">"
			FndData = FndData & " <td>"&formatnumber((totalcount - (currPage - 1) * B_Psize - cnt+1), 0)&"</td>"
			
			IF LRs("Photo")<>"" Then
				'실제경로에 이미지파일 있는지 체크
				IF FSO.FileExists(global_filepath&"Player\"&LRs("EnterType")&"\"&LRs("Photo")) Then 
					FndData = FndData & "<td><img src='"&global_filepathUrl&"Player/"&LRs("EnterType")&"/"&LRs("Photo")&"' width='50' alt=''></td>"
				Else
					FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
				End IF	
			Else
				FndData = FndData & "<td><img src='../images/profile@3x.png' width='50' alt=''></td>"
			End IF
		
			FndData = FndData & " <td>"&LRs("TeamGbNm")&"</td>"
			FndData = FndData & " <td>"&LRs("SEXNm")&"</td>"
			FndData = FndData & " <td>"&LRs("SubstituteYNNm")&"</td>"
			FndData = FndData & " <td>"&LRs("UserName")&"</td>"
			FndData = FndData & " <td>"&LRs("UserEnName")&"</td>"
			FndData = FndData & " <td>"&LRs("UserBirth")&"</td>"			
			FndData = FndData & " <td>"&LRs("PersonCode")&"</td>"			
			FndData = FndData & " <td>"&LRs("TeamNm")&"</td>"
			FndData = FndData & " <td>"&LRs("UserPhone")&"</td>"
			'FndData = FndData & " <td>"&LRs("Email")&"</td>"
			FndData = FndData & " <td>"&LRs("PeriodDateS")&"~"&LRs("PeriodDateE")&"</td>"
			FndData = FndData & "</tr>"

      		LRs.movenext
   	 	Loop  
    ELSE
      	FndData = FndData & "<tr><td colspan=12>일치하는 정보가 없습니다.</td></tr>"
    End IF  
      	LRs.Close
    SET LRs = Nothing
    
	FndData = FndData & " </tbody>"
	FndData = FndData & "</table>"
  
  

	'페이징  
	dim intTemp

	CStrPG = CStrPG & "<div class='page_index'>"
	CStrPG = CStrPG & " <ul class='pagination'>"

	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1

	If intTemp = 1 Then
		CStrPG = CStrPG & "<li class='prev'><a href=""javascript:;"" class='fa fa-angle-left'></a></li>"
	Else 
		CStrPG = CStrPG & "<li class='prev'><a href=""javascript:chk_Submit('FND','','"&intTemp - BlockPage&"');"" class='fa fa-angle-left'></a></li> "
	End If  

	dim intLoop : intLoop = 1

	Do Until intLoop > BlockPage Or intTemp > TotalPage

		If CInt(intTemp) = CInt(currPage) Then
			CStrPG = CStrPG & "<li class='active'><a href='#' >"&intTemp&"</a> </li>" 
		Else
			CStrPG = CStrPG & "<li><a href=""javascript:chk_Submit('FND','','"&intTemp&"');"">"&intTemp&"</a> </li>"
		End If

		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop

	IF intTemp > TotalPage Then
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:;"" class='fa fa-angle-right'></a></li>"
	Else
		CStrPG = CStrPG & "<li class='next'><a href=""javascript:chk_Submit('FND','','"&intTemp&"');"" class='fa fa-angle-right'></a></li>"
	End IF  

	CStrPG = CStrPG & "	</ul>"
	CStrPG = CStrPG & "</div>"
  
  
    '출력  
    response.Write CStrTP 	'카운트/페이지
    response.Write FndData  '목록 테이블
    
    IF TotalCount > 0 Then response.Write CStrPG  '페이징
  
  
    DBClose()
  
%>