<!--#include file="../../dev/dist/config.asp"-->
<%
    '==============================================================================================
	'참가신청 목록 엑셀 다운로드 페이지
   	'==============================================================================================
    dim CIDX        	: CIDX      	= crypt.DecryptStringENC(fInject(request("CIDX")))	'대회IDX
	
  	'검색조건 항목 
  	dim fnd_AreaGb    	: fnd_AreaGb    = fInject(Request("fnd_AreaGb"))  
    dim fnd_AreaGbDt  	: fnd_AreaGbDt  = fInject(Request("fnd_AreaGbDt"))
	dim fnd_GameType  	: fnd_GameType  = fInject(Request("fnd_GameType"))	 
  	dim fnd_GameGroup 	: fnd_GameGroup = fInject(Request("fnd_GameGroup"))	 
	dim fnd_GameLevel 	: fnd_GameLevel = fInject(Request("fnd_GameLevel"))  
    dim fnd_RKeyWord   	: fnd_RKeyWord	= fInject(Request("fnd_RKeyWord"))  
	
	dim FileName	 	: FileName	 	= "참가자목록_"&replace(Date(),"-","")&".xls"

	dim LSQL, LRs
	dim CSearch, CSearch2, CSearch3, CSearch4, CSearch5, CSearch6, CSearch7
  	dim strGameLevel
    dim GameTitleName, GameStartYear   	
	
   	Server.ScriptTimeout = 90000 
	response.ContentType = "application/vnd.ms-excel" 
	response.AddHeader "Content-Disposition","attachment;filename=" & Server.URLPathEncode(FileName) & "" 
   	response.CacheControl = "public"	'버퍼링하지 않고 바로 다운로드 창
   
   
   
	IF fnd_GameType <> "" Then CSearch = " AND A.GroupGameGb = '"&fnd_GameType&"'"
	IF fnd_GameGroup <> "" Then CSearch2 = " AND A.TeamGb = '"&fnd_GameGroup&"'"
	IF fnd_GameLevel <> "" Then 
		strGameLevel = Split(fnd_GameLevel, "|")
		CSearch3 = " AND A.Sex = '"&strGameLevel(0)&"'"
		CSearch4 = " AND A.PlayType = '"&strGameLevel(1)&"'"                            
  	End IF
                             
	IF fnd_AreaGb <> "" Then CSearch5 = " AND H.sido = '"&fnd_AreaGb&"'"
	IF fnd_AreaGbDt <> "" Then CSearch6 = " AND H.sidogugun = '"&fnd_AreaGbDt&"'"
  
  
	'키워드 검색 [선수명, 팀명]
	dim search(1)

	search(0) = "A.UserName"    'UserName
	search(1) = "A.UserTeamNm"    'UserTeamName                  

	IF fnd_RKeyWord <> "" Then
		For i = 0 To 1
			CSearch7 = CSearch7 & " OR "&search(i)&" like N'%"&fnd_RKeyWord&"%'"
		Next
  
    	CSearch7 = " AND ("&mid(CSearch7, 5)&")"
  	End IF

  	IF CIDX = "" Then
		response.write "<script>alert('잘못된 접근입니다. 확인 후 이용하세요.'); history.back();</script>"
		response.end
	Else    
		

		LSQL = "    	SELECT GameTitleName"
		LSQL = LSQL & " 	,LEFT(GameS, 4) + '년' GameStartYear"
		LSQL = LSQL & "		,EnterType"											   
		LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitle]"
		LSQL = LSQL & " WHERE DelYN = 'N'"
		LSQL = LSQL & "   	AND ViewYN = 'Y'"                     
		LSQL = LSQL & "   	AND GameTitleIDX = '"&CIDX&"'"                                            

  '   	response.Write LSQL

		SET LRs = DBCon.Execute(LSQL)
		IF Not(LRs.Eof OR LRs.Bof) Then                         
			GameTitleName = LRs("GameTitleName")
			GameStartYear = LRs("GameStartYear")
		END IF
			LRs.Close
		SET LRs = Nothing

		LSQL = "    	SELECT A.GameEnterIDX"
		LSQL = LSQL & "   	,[KoreaBadminton].[dbo].[FN_SidoName](H.Sido) SidoNm"
		LSQL = LSQL & "   	,[KoreaBadminton].[dbo].[FN_SidoGuGunName](H.Sido, H.SidoGuGun) SidoGuGunNm"
		LSQL = LSQL & "   	,D.PubName GameType"
		LSQL = LSQL & "   	,C.TeamGbNm TeamGbNm"
		LSQL = LSQL & "   	,CASE A.Sex WHEN 'Man' THEN '남자' WHEN 'WoMan' THEN '여자' ELSE '혼합' END SEX"
		LSQL = LSQL & "   	,E.PubName PlayTypeNm"
		LSQL = LSQL & "   	,G.LevelNm LevelNm"
		LSQL = LSQL & "   	,CASE A.GroupGameGb WHEN 'B0030001' THEN CASE WHEN F.PubName <> '' THEN F.PubName END ELSE CASE WHEN A.GroupGubun <> '' THEN A.GroupGubun + '조' END END GameGroupNm"
		LSQL = LSQL & "   	,B.UserName ReqUserName"
		LSQL = LSQL & "   	,A.UserName "
		LSQL = LSQL & "   	,A.UserTeamNm"
		LSQL = LSQL & "   	,B.UserPhone"
		LSQL = LSQL & "   	,A.PartnerName"   
		LSQL = LSQL & "   	,A.PartnerTeamNm"   
		LSQL = LSQL & "   	,CONVERT(CHAR(10), A.InsDate, 102) InsDate" 
		LSQL = LSQL & " 	,I.PubName StatusNm"
		LSQL = LSQL & " 	,A.Status"
		LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameEnter] A"
		LSQL = LSQL & "   	inner join [KoreaBadminton].[dbo].[tblMember] B on A.MemberIDX = B.MemberIDX AND B.DelYN = 'N'"
		LSQL = LSQL & "   	inner join [KoreaBadminton].[dbo].[tblLevelInfo] G on A.Level = G.Level AND G.DelYN = 'N'"
		LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblTeamInfo] H on A.UserTeam = H.Team AND H.DelYN = 'N'"
		LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblTeamGbInfo] C on A.TeamGb = C.TeamGb AND C.DelYN = 'N'"
		LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblPubCode] D on A.GroupGameGb = D.PubCode AND D.DelYN = 'N'"
		LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblPubCode] E on A.PlayType = E.PubCode AND E.DelYN = 'N'"
		LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblPubCode] F on A.LevelJooName = F.PubCode AND F.DelYN = 'N' "
		LSQL = LSQL & "   	left join [KoreaBadminton].[dbo].[tblPubCode] I on A.Status = I.PubCode AND I.DelYN = 'N' "
		LSQL = LSQL & " WHERE A.DelYN = 'N'"  
		LSQL = LSQL & "   	AND A.GameTitleIDX = '"&CIDX&"'"&CSearch&CSearch2&CSearch3&CSearch4&CSearch5&CSearch6&CSearch7
		LSQL = LSQL & "   	AND A.Status = 'ST_2'"	'신청완료
		LSQL = LSQL & " ORDER BY H.Sido, H.SidoGuGun, D.OrderBy, A.TeamGb, A.Sex, E.OrderBy, G.Orderby, A.LevelJooName, A.GroupGubun, A.UserName, A.InsDate"

	  ' response.write LSQL
		SET LRs = DBCon.Execute(LSQL) 
		
		response.write "<h4>"&GameStartYear & " : " & GameTitleName&" 참가자 목록</h4>"
        response.write "<table cellpadding=0 cellspacing=0 border=1>"
		response.write "	<thead>"
		response.write "		<tr>"
		response.write "  			<th>No.</th>"	
		response.write "  			<th>시도</th>"
		response.write "  			<th>시군구</th>"
		response.write "  			<th>구분</th>"
		response.write "  			<th>종목</th>"	
		response.write "  			<th>타입</th>"	
		response.write "  			<th>연령</th>"	
		
		SELECT CASE fnd_GameType
			CASE "B0030001" : response.write "<th>등급</th>"
			CASE "B0030002" : response.write "<th>그룹</th>"						 
		END SELECT		 
		
		response.write "  			<th>참가자</th>"
		response.write "  			<th>참가자클럽</th>"	
		response.write "			<th>전화번호</th>"
		
		IF fnd_GameType = "B0030001" Then response.write "<th>파트너정보</th>"
			
		response.write "		</tr>"
		response.write "	</thead>"
		response.write "  	<tbody>"
		
		IF Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.eof

				cnt = cnt + 1

				response.write "<tr style='text-align: center;'>"
				response.write "  <td>"&cnt&"</td>"
				response.write "  <td>"&LRs("SidoNm")&"</td>"
				response.write "  <td>"&LRs("SidoGuGunNm")&"</td>"
				response.write "  <td>"&LRs("GameType")&"</td>"
				response.write "  <td>"&LRs("TeamGbNm")&"</td>"
				response.write "  <td>"&LRs("SEX")&LRs("PlayTypeNm")&"</td>"
				response.write "  <td>"&LRs("LevelNm")&"</td>"
				response.write "  <td>"&LRs("GameGroupNm")&"</td>"					
				response.write "  <td>"&LRs("UserName")&"</td>"
		   		response.write "  <td>"&LRs("UserTeamNm")&"</td>"
		   		response.write "  <td style='mso-number-format:\@'>"&LRs("UserPhone")&"</td>"
				
				IF fnd_GameType = "B0030001" Then response.write " <td>"&LRs("PartnerName")&"("&LRs("PartnerTeamNm")&")</td>"
			
				response.write "</tr>"
				
				LRs.Movenext
			Loop
		End IF    
		
		response.write " 	</tbody>"
        response.write " </table>"	
	End IF
  
	%>
         


