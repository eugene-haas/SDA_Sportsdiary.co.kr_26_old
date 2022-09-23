<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'팀 리스트 조회
	'====================================================================================
	Check_AdminLogin()
		
	dim fnd_TeamNm		: fnd_TeamNm 	= fInject(Request("fnd_TeamNm"))
   	dim fnd_RegYear		: fnd_RegYear 	= fInject(Request("fnd_RegYear"))

	IF fnd_RegYear = "" Then fnd_RegYear = Year(Date())
	
	FndData = "			 <table class='table-list'>"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>지역</th>"
	FndData = FndData & "			<th>팀명</th>"	
	FndData = FndData & "			<th>팀코드</th>"	
	FndData = FndData & "			<th>구분</th>"													  
	FndData = FndData & "			<th>주소</th>"		
	FndData = FndData & "		</tr>"
	FndData = FndData & "	</thead>"
	FndData = FndData & "	<tbody>"
												  
												  
	'회원리스트 조회	
	CSQL = "		SELECT A.Team"
	CSQL = CSQL & "		,A.TeamNm"
   	CSQL = CSQL & "		,B.PTeamGbName TeamGbNm"
   	CSQL = CSQL & "		,[KoreaBadminton].[dbo].[FN_SidoName] (A.Sido) SidoNm"
   	CSQL = CSQL & "		,ISNULL([KoreaBadminton].[dbo].[FN_SidoGuGunName] (A.Sido, A.sidogugun), '') SidoGuGunNm"
	CSQL = CSQL & "		,A.Address"
	CSQL = CSQL & "		,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblTeamInfoHistory] A"
   	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblTeamGbInfo] B on A.PTeamGb = B.PTeamGbCode AND B.DelYN = 'N'" 
	CSQL = CSQL & "	WHERE A.DelYN = 'N'"
	CSQL = CSQL & "		AND A.RegYear = '"&fnd_RegYear&"'"
   	CSQL = CSQL & "		AND A.TeamNm like '%"&fnd_TeamNm&"%'"
	CSQL = CSQL & "	ORDER BY A.Sido, A.TeamNm"
				
	'response.Write CSQL
				
	SET CRs = DBCon.Execute(CSQL)
	IF Not(CRs.Eof Or CRs.Bof) Then 

		CRs.Move (currPage - 1) * B_PSize
		
		Do Until CRs.eof

			cnt = cnt + 1
			
			FndData = FndData & "<tr style='cursor:pointer' onClick=""Input_TeamInfo('"&CRs("Team")&"','"&CRs("TeamNm")&"');"" >"
			FndData = FndData & "	<td>" & CRs("SidoNm")
																														  
			IF CRs("SidoGuGunNm") <> "" Then FndData = FndData & " / " & CRs("SidoGuGunNm")	
		
			FndData = FndData &	"	</td>"
			FndData = FndData & "	<td>" & CRs("TeamNm")&"</td>"
			FndData = FndData & "	<td>" & CRs("Team")&"</td>"
			FndData = FndData & "	<td>" & CRs("SexNm")&"</td>"
			FndData = FndData & "	<td>" & CRs("Address")&"</td>"			
			FndData = FndData & "</tr>"
		
			CRs.movenext
		Loop	
	ELSE
		FndData = FndData & "<tr><td colspan=6>일치하는 정보가 없습니다.</td></tr>"
	End IF	
	
	FndData = FndData & "	</tbody>"
	FndData = FndData & "</table>"
	
		CRs.Close
	SET CRs = Nothing
	
	
	'출력
	response.Write FndData	'목록 테이블
		
	DBClose()
	
%>