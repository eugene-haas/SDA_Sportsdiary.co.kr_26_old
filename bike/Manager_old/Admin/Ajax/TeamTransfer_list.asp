<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'소속팀 이적관리 리스트 조회
   	'/Main_HP/TeamTransfer_list.asp
	'====================================================================================
	Check_AdminLogin()

	dim BlockPage     	: BlockPage     	= 10  '페이지
	dim B_PSize       	: B_PSize       	= 10  '페이지내 보여지는 목록카운트  
	dim cnt       		: cnt         		= 0   '카운트        
	dim currPage      	: currPage      	= fInject(Request("currPage"))
	dim fnd_KeyWord   	: fnd_KeyWord     	= fInject(Request("fnd_KeyWord"))
	dim fnd_MemberType  : fnd_MemberType  	= fInject(Request("fnd_MemberType"))    
	dim SDate     		: SDate       		= fInject(Request("SDate"))
	dim EDate     		: EDate       		= fInject(Request("EDate"))
	dim fnd_Year	   	: fnd_Year     		= fInject(Request("fnd_Year"))

	dim TotCount, TotPage
	dim CSearch, CSearch2, CSearch3, CSearch4
	dim FndData, CStrPG, CStrTP 
	dim CSQL, CRs

	IF Len(currPage) = 0 Then currPage = 1
	IF fnd_Year = "" Then fnd_Year = Year(Date())												   

	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', A.TransDate)>=0 AND DateDiff(d, A.TransDate, '"&EDate&"')>=0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch = " AND DateDiff(d, A.TransDate, '"&SDate&"')=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&EDate&"', A.TransDate)=0 "
	Else
	End IF

	IF fnd_MemberType <> "" Then CSearch2 = " AND A.MemberType = '"&fnd_MemberType&"'"
	IF fnd_KeyWord <> "" Then CSearch3 = " AND A.UserName = '"&fnd_KeyWord&"'"

  
	CSQL = "   		SELECT ISNULL(COUNT(*),0) Cnt"
	CSQL = CSQL & "   	,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblTeamTransfer] A"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] B on A.ApprovalGb = B.PubCode AND B.DelYN = 'N' AND B.PPubCode = 'APPROVAL' "
	CSQL = CSQL & " WHERE A.DelYN = 'N'"&CSearch&CSearch2&CSearch3
  
' 	response.Write CSQL
  
  	SET CRs = DBCon.Execute(CSQL) 
		TotalCount = formatnumber(CRs(0),0)
		TotalPage = CRs(1)
  
  
	'카운트/페이지
	CStrTP = "<div class='total_count'><span>전체 : "&TotalCount&",</span>&nbsp;&nbsp;&nbsp;"
	CStrTP = CStrTP & "<span>"&currPage &" page / " & TotalPage & " pages"
	CStrTP = CStrTP & "</span></div>"
  

	'리스트 조회 
	CSQL = "    	SELECT TOP "&currPage * B_PSize 
	CSQL = CSQL & "		A.TeamTransferIDX"
	CSQL = CSQL & "		,A.MemberIDX"
	CSQL = CSQL & "		,A.UserName"
	CSQL = CSQL & "		,A.MemberType"
	CSQL = CSQL & "		,CASE A.MemberType WHEN 'L' THEN '지도자' ELSE '선수' END MemberTypeNm"
	CSQL = CSQL & "		,A.TeamBefore"
	CSQL = CSQL & "		,A.TeamAfter"
	CSQL = CSQL & "		,A.TransDate"
	CSQL = CSQL & "		,A.ApprovalGb"
	CSQL = CSQL & "		,B.PubName ApprovalGbNm"
	CSQL = CSQL & "		,CONVERT(CHAR(10), A.ApprDate, 102) ApprDate"
	CSQL = CSQL & "		,A.txtMemo"
	CSQL = CSQL & "		,[KoreaBadminton].[dbo].[FN_TeamName] (A.TeamBefore, '"&fnd_Year&"') TeamBeforeNm "
	CSQL = CSQL & "		,[KoreaBadminton].[dbo].[FN_TeamName] (A.TeamAfter, '"&fnd_Year&"') TeamAfterNm "
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblTeamTransfer] A"
	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] B on A.ApprovalGb = B.PubCode AND B.DelYN = 'N' AND B.PPubCode = 'APPROVAL' "
	CSQL = CSQL & " WHERE A.DelYN = 'N'"&CSearch&CSearch2&CSearch3
	CSQL = CSQL & " ORDER BY A.TransDate DESC"
        
  '	response.Write CSQL
        
  	SET CRs = DBCon.Execute(CSQL)
  
	FndData = "      <table class='table-list'>"
	FndData = FndData & " <thead>"
	FndData = FndData & "   <tr>"
	FndData = FndData & "     <th>번호</th>"
	FndData = FndData & "     <th>이적일</th>"	
	FndData = FndData & "     <th>이름</th>"  	
	FndData = FndData & "     <th>구분</th>"  		
	FndData = FndData & "     <th>현 소속팀</th>"
	FndData = FndData & "     <th>이적 소속팀</th>"  
	FndData = FndData & "     <th>동의서여부</th>"
	FndData = FndData & "   </tr>"
	FndData = FndData & " </thead>"
	FndData = FndData & " <tbody>"
  
  	IF Not(CRs.Eof Or CRs.Bof) Then 

    	CRs.Move (currPage - 1) * B_PSize
    
    	Do Until CRs.eof

      		cnt = cnt + 1
      
			FndData = FndData & "<tr style='cursor:pointer' onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("TeamTransferIDX"))&"','"&currPage&"');"" >"
			FndData = FndData & " <td>" & totalcount - (currPage - 1) * B_Psize - cnt+1&"</td>" 			
			FndData = FndData & " <td>" & CRs("TransDate")&"</td>"
			FndData = FndData & " <td>" & CRs("UserName")&"</td>"
			FndData = FndData & " <td>" & CRs("MemberTypeNm")&"</td>"
			FndData = FndData & " <td>" & CRs("TeamBeforeNm")&"("&CRs("TeamBefore")&")</td>"
			FndData = FndData & " <td>" & CRs("TeamAfterNm")&"("&CRs("TeamAfter")&")</td>"
			FndData = FndData & " <td>" & CRs("ApprovalGbNm")&"("&CRs("ApprDate")&")</td>"     			
			FndData = FndData & "</tr>"
    
      		CRs.movenext
    	Loop  
  	ELSE
    	FndData = FndData & "<tr><td colspan=7>일치하는 정보가 없습니다.</td></tr>"
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