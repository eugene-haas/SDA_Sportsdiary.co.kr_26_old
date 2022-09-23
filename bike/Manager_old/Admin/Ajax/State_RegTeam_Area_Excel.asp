<!--#include file="../dev/dist/config.asp"-->
<%
	Check_AdminLogin()

	'====================================================================================
	'등록현황(팀) - 시도별
	'====================================================================================
	Check_AdminLogin()
	
	dim fnd_Year      : fnd_Year      = fInject(Request("fnd_Year"))
	dim fnd_AreaGb    : fnd_AreaGb    = fInject(Request("fnd_AreaGb")) 

	dim CSQL, CRs, LRs
	dim txtData, i, numcols, numrows
	dim txtDataGb, j, numcolsGb, numrowsGb
	dim CSearch
	 
	IF fnd_Year = "" Then fnd_Year = Year(Date())
	IF fnd_AreaGb <> "" Then CSearch = " AND A.Sido = '"&fnd_AreaGb&"'"
	 
																															  
   	'엑셀파일 다운로드
	FileName = "등록팀현황_시도별_"&fnd_Year&".xls"

	Response.ContentType = "application/vnd.ms-excel" 
	Response.AddHeader "Content-Disposition","attachment;filename=" & Server.URLPathEncode(FileName)	 
    
	
	CSQL = "		SELECT A.sido"
	CSQL = CSQL & "		,COUNT(A.sido) Cnt"
	CSQL = CSQL & "		,CASE A.Sex WHEN 'Man' THEN '남자' ELSE '여자' END SexNm" 
	CSQL = CSQL & "		,A.Sex"
	CSQL = CSQL & "		,[KoreaBadminton].dbo.FN_SidoName(A.sido) SidoNm"	
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblTeamInfoHistory] A"	
	CSQL = CSQL & "	WHERE A.DelYN = 'N'"
	CSQL = CSQL & "		AND A.EnterType = 'E'"	
	CSQL = CSQL & "		AND A.EnterTypeSub NOT IN('K')"
	CSQL = CSQL & "		AND A.RegYear = '"&fnd_Year&"'"&CSearch	
	CSQL = CSQL & "	GROUP BY A.sido, A.Sex"
	CSQL = CSQL & "	ORDER BY A.sido"							  

	'response.Write CSQL

	SET CRs = DBCon.Execute(CSQL)
   	IF Not(CRs.Eof Or CRs.Bof) Then 
   	
   		txtDataGb = CRs.getRows 
	 
   		numcolsGb = ubound(txtDataGb, 1)	'행
		numrowsGb = ubound(txtDataGb, 2)	'열
   			
   		FOR j = 0 to numrowsGb		
   			'response.write "<div><h3>"&fnd_Year&" "&CRs("SexNm")&" "&CRs("SexNm")&" - ["&CRs("Cnt")&"팀]</h3></div>"
			response.write "<div><h3>"&fnd_Year&" "&txtDataGb(2, j)&" "&txtDataGb(4, j)&" - ["&txtDataGb(1, j)&"팀]</h3></div>"    
			response.write "<table border=1 cellspacing=0 cellpadding=0>"
			response.write " <thead>"
			response.write "   <tr>"
			response.write "     <th>번호</th>"
   			response.write "     <th>팀명</th>"	
			response.write "     <th>지도자</th>"                          
			response.write "     <th>선수</th>"
			response.write "     <th>우편번호</th>"  
			response.write "     <th>주소</th>"
			response.write "     <th>감독</th>"
			response.write "     <th>코치</th>"  
			response.write "     <th>전화번호</th>"  
			response.write "     <th>팩스번호</th>"  
			response.write "   </tr>"
			response.write " </thead>"
			response.write " <tbody>"

	
			CSQL = "		SELECt A.TeamNm"
			CSQL = CSQL & "		,(SELECT COUNT(*) FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory] WHERE DelYN = 'N' AND RegistYear = '"&fnd_Year&"' AND Team = A.Team) LeaderCnt"
			CSQL = CSQL & "		,(SELECT COUNT(*) FROM [KoreaBadminton].[dbo].[tblMemberHistory] WHERE DelYN = 'N' AND RegYear = '"&fnd_Year&"' AND Team = A.Team) PlayerCnt"
			CSQL = CSQL & "		,A.ZipCode"
			CSQL = CSQL & "		,A.Address"
			CSQL = CSQL & "		,A.AddrDtl"
   			CSQL = CSQL & "	   	,STUFF((" 	'감독목록
			CSQL = CSQL & "		 	SELECT ', ' + UserName"
			CSQL = CSQL & "		 	FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory]" 
			CSQL = CSQL & "		 	WHERE DelYN = 'N'"
			CSQL = CSQL & "				AND RegistYear = '"&fnd_Year&"'"	
			CSQL = CSQL & "				AND Team = A.Team"
			CSQL = CSQL & "				AND LeaderType = '2'"		
			CSQL = CSQL & "		 	ORDER BY UserName"  
			CSQL = CSQL & "		 	FOR XML PATH('')), 1, 1, '') LeaderInfo"  
			CSQL = CSQL & "	   	,STUFF((" 	'코치목록
			CSQL = CSQL & "		 	SELECT ', ' + UserName"
			CSQL = CSQL & "		 	FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory]" 
			CSQL = CSQL & "		 	WHERE DelYN = 'N'"
			CSQL = CSQL & "				AND RegistYear = '"&fnd_Year&"'"	
			CSQL = CSQL & "				AND Team = A.Team"
			CSQL = CSQL & "				AND LeaderType = '3'"		
			CSQL = CSQL & "		 	ORDER BY UserName"  
			CSQL = CSQL & "		 	FOR XML PATH('')), 1, 1, '') LeaderInfo"  
			CSQL = CSQL & "		,A.TeamTel"
			CSQL = CSQL & "		,A.TeamFax"
			CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblTeamInfoHistory] A"
			CSQL = CSQL & "	WHERE A.DelYN = 'N'"
			CSQL = CSQL & "		AND A.EnterType = 'E'"
			CSQL = CSQL & "		AND A.EnterTypeSub NOT IN('K')"	
			CSQL = CSQL & "		AND A.RegYear = '"&fnd_Year&"'"	
   			CSQL = CSQL & "		AND A.PTeamGb = '"&txtDataGb(0, j)&"'"
   			CSQL = CSQL & "		AND A.SEX = '"&txtDataGb(3, j)&"'"
			CSQL = CSQL & "	ORDER BY A.PteamGb, A.TeamNm"
	
			SET LRs = DBCon.Execute(CSQL)
			IF Not(LRs.Eof Or LRs.Bof) Then 
   				txtData = LRs.getRows   				
   				
  				numcols = ubound(txtData, 1)	'행
				numrows = ubound(txtData, 2)	'열
   
   				FOR i = 0 to numrows	
					response.write "<tr>"
					response.write " <td style='text-align:center'>"&i+1&"</td>"
					response.write " <td>"&txtData(0, i)&"</td>"       														'TeamNm
					response.write " <td style='text-align:center'>"&txtData(1, i)&"</td>"									'LeaderCnt
					response.write " <td style='text-align:center'>"&txtData(2, i)&"</td>"     								'PlayerCnt
					response.write " <td style=""mso-number-format:'\@'"">"&txtData(3, i)&"</td>"							'ZipCode
					response.write " <td>"&txtData(4, i)&" "&txtData(5, i)&"</td>"											'Address
					response.write " <td>"&txtData(6, i)&"</td>"															'LeaderInfo			
					response.write " <td>"&txtData(7, i)&"</td>"															'LeaderInfo2		
					response.write " <td style=""text-align:center; mso-number-format:'\@'"">"&txtData(8, i)&"</td>"		'TeamTel
					response.write " <td style=""text-align:center; mso-number-format:'\@'"">"&txtData(9, i)&"</td>"		'TeamFax'
					response.write "</tr>"   
   				NEXT
   
   			End IF
   				LRs.Close
   			SET LRs = Nothing
			
   			response.write " </tbody>"
			response.write "</table>"
   			
   			cnt = 0
   		
   		NEXT
   
	Else
		response.write "<div>등록된 정보가 없습니다.</div>"
	End IF  
		CRs.Close
	SET CRs = Nothing	


	DBClose()
  
%>