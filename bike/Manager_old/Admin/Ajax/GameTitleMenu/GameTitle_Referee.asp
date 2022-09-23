<!--#include file="../../dev/dist/config.asp"-->
<%
	'====================================================================================
	'리스트 조회
	'====================================================================================
	Check_AdminLogin()
		
	dim tIDX			: tIDX 		= crypt.DecryptStringENC(fInject(request("tIDX")))
	 
   	
	dim CSQL, CRs
	
	'리스트 조회	
	CSQL = "		SELECT A.GameRefereeIDX "
	CSQL = CSQL & "		,A.GameTitleIDX "
	CSQL = CSQL & "		,A.UserName "
	CSQL = CSQL & "		,A.UserEnName "
	CSQL = CSQL & "		,A.RefereeGb "
   	CSQL = CSQL & "		,A.Sex "
	CSQL = CSQL & "		,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
	CSQL = CSQL & "		,B.CountryNm"
   	CSQL = CSQL & "		,C.PubName RefereeGbNm	"
	CSQL = CSQL & "	FROM [KoreaBadminton].[dbo].[tblGameTitleReferee] A"
   	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblCountryInfo] B on A.ct_serial = B.ct_serial AND B.DelYN = 'N'"
   	CSQL = CSQL & "		left join [KoreaBadminton].[dbo].[tblPubCode] C on A.RefereeGb = C.PubCode AND C.DelYN = 'N'"
	CSQL = CSQL & "	WHERE A.DelYN = 'N'"
	CSQL = CSQL & "		AND A.GameTitleIDX = '"&tIDX&"'"
	CSQL = CSQL & "	ORDER BY C.OrderBy, A.RefereeLvl, A.UserName, A.SEX"
				
	'response.Write CSQL
				
	SET CRs = DBCon.Execute(CSQL)
	
	FndData = "			 <table class='table-list'>"
	FndData = FndData & "	<thead>"
	FndData = FndData & "		<tr>"
	FndData = FndData & "			<th>번호</th>"
	FndData = FndData & "			<th>이름</th>"	
	FndData = FndData & "			<th>영문</th>"	
	FndData = FndData & "			<th>심판구분</th>"		
	FndData = FndData & "			<th>성별</th>"
	FndData = FndData & "			<th>국적</th>"	
	FndData = FndData & "		</tr>"
	FndData = FndData & "	</thead>"
	FndData = FndData & "	<tbody>"
	
	IF Not(CRs.Eof Or CRs.Bof) Then 
		Do Until CRs.eof

			cnt = cnt + 1
			
			FndData = FndData & "<tr style='cursor:pointer' onClick=""chk_Submit('VIEW','"&crypt.EncryptStringENC(CRs("GameRefereeIDX"))&"');"" >"
			FndData = FndData & "	<td>" & cnt &"</td>"	
			FndData = FndData & "	<td>" & ReHtmlSpecialChars(CRs("UserName"))&"</td>"
			FndData = FndData & "	<td>" & ReHtmlSpecialChars(CRs("UserEnName"))&"</td>"
			FndData = FndData & "	<td>" & CRs("RefereeGbNm")&"</td>"
			FndData = FndData & "	<td>" & CRs("SexNm")&"</td>"
			FndData = FndData & "	<td>" & CRs("CountryNm")&"</td>"			
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
	
	response.Write FndData	'목록 테이블
		
	
	DBClose()
	
%>