<!--#include file="../Library/ajax_config.asp"-->
<%
	'선수보호자 상담 작성자(팀매니저) 목록 조회(SELECT BOX) 페이지
	
	dim element 	: element 	= fInject(Request("element"))
	dim attname 	: attname 	= fInject(Request("attname"))	
	
	'선수 보호자 회원의 경우 MemberIDX 쿠키 교체되었기 때문에 선수보호자 MemberIDX로 교체
	SELECT CASE decode(request.Cookies("PlayerReln"), 0)
		CASE "A","B","Z" 	: MemberIDX = decode(request.Cookies("P_MemberIDX"),0) 
		CASE ELSE			: MemberIDX = decode(request.Cookies("MemberIDX"),0) 
	END SELECT
	
	dim LSQL, LRs
	dim selData

	LSQL =  " SELECT UserName "&_
			" 	,UserID "&_
			"	,MemberIDX "&_
			"	,CASE LeaderType WHEN 2 THEN '(감독)' WHEN 3 THEN '(코치)' ELSE '' END LeaderTypeNm "&_
			" FROM [Sportsdiary].[dbo].[tblMember] "&_
			" WHERE DelYN = 'N' "&_
			"		AND SportsType = '"&SportsGb&"' "&_
			" 		AND PlayerReln = 'T' "&_
			" 		AND team in( "&_
			" 			SELECT Team "&_ 		
			" 			FROM [Sportsdiary].[dbo].[tblMember] "&_
			" 			WHERE DelYN = 'N' "&_
			" 				AND SportsType = '"&SportsGb&"' "&_
			" 				AND MemberIDX = "&MemberIDX &_
			" 		) "&_
			" ORDER BY LeaderType "&_
			"	,UserName " 	
	
	selData = "<select name='"&attname&"' id='"&attname&"' >"
	selData = selData & "<option value=''>작성자 선택</option>"		

	SET LRs = Dbcon.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			selData = selData & "<option value='"&LRs("UserName")&"'>"&LRs("UserName")&LRs("LeaderTypeNm")&"</option>"	
			LRs.MoveNext
		Loop 
	End If 
	
	selData = selData & "</select>"
	
		LRs.Close
	SET LRs = Nothing
	
	Dbclose()

	Response.Write selData
		
%>