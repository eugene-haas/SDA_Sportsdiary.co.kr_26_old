<!--#include file="../Library/ajax_config.asp"-->
<%
	'====================================================================================
	'생활체육 회원구분별 데이터 공유 정보 조회페이지
	'====================================================================================
	Check_Login()
	
	dim PlayerIDX   	: PlayerIDX 	= fInject(Request("PlayerIDX"))
	dim Team    		: Team    		= fInject(Request("Team"))
	dim PlayerReln   	: PlayerReln 	= fInject(Request("PlayerReln"))
	
	dim SrtDate			: SrtDate		= request.Cookies("SrtDate")
	
	dim PlayerRelnNm  	'보호자명 변환
	dim txtParents  	'보호자 HTML정보
	dim txtManage 		'팀매니저 HTML정보
	dim txtPlayer		'선수 HTML정보
	dim cntParents 		: cntParents 	= 0 '선수데이터 열람동의 카운트:부모, 기타
	dim cntManage 		: cntManage 	= 0 '선수데이터 열람동의 카운트:팀매니저 
	dim cntPlayer		: cntPlayer 	= 0 '선수데이터 열람동의 카운트:선수/비등록선수
	dim LeaderTypeNm  '지도자 구분[ 2:감독, 3:코치]
	
	If PlayerIDX = "" OR PlayerReln = "" Then 
		
		response.Write "<li><p style='center'>공유대상이 없습니다.</p></li>"
		Response.End
	
	Else

		CSQL =  " 		SELECT CASE WHEN A.PlayerReln IS NULL OR A.PlayerReln = '' THEN 'R' ELSE A.PlayerReln END PlayerReln "
		CSQL = CSQL & " 	,A.PlayerRelnMemo "  
		CSQL = CSQL & " 	,A.UserName"
		CSQL = CSQL & " 	,A.UserPhone "  
		CSQL = CSQL & " 	,CONVERT(CHAR(10), CONVERT(DATE, A.SrtDate), 102) SrtDate "
		CSQL = CSQL & " 	,CONVERT(CHAR(10), CONVERT(DATE, A.SrtSvcDate), 102) SrtSvcDate  " 
		CSQL = CSQL & " 	,A.Team " 
		CSQL = CSQL & " 	,SportsDiary.dbo.FN_PubName('sd03900'+A.LeaderType) LeaderTypeNm "
		CSQL = CSQL & " FROM (  "
		CSQL = CSQL & " 	SELECT [PlayerReln] " 
		CSQL = CSQL & " 		,[PlayerRelnMemo] " 
		CSQL = CSQL & " 		,[UserName] "
		CSQL = CSQL & " 		,[UserPhone] " 
		CSQL = CSQL & " 		,[SrtDate] "
		CSQL = CSQL & " 		,[SrtSvcDate] "
		CSQL = CSQL & " 		,[Team] "
		CSQL = CSQL & " 		,[LeaderType] "
		CSQL = CSQL & " 	FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " 	WHERE DelYN='N' "
		CSQL = CSQL & " 		AND SportsType = '"&SportsGb&"' "
		CSQL = CSQL & " 		AND PlayerIDX = '"&PlayerIDX&"' "
		
		SELECT CASE PlayerReln
			CASE "R", ""	: CSQL = CSQL & "AND (PlayerReln = 'A' OR PlayerReln = 'B' OR PlayerReln = 'Z') "	'선수의 경우 부모정보 조회
			CASE "A", "B", "Z"	: CSQL = CSQL & "AND (PlayerReln = '' OR PlayerReln IS NULL OR PlayerReln = 'R') "	'부모의 경우 선수/관원 조회
		END SELECT		
				
		CSQL = CSQL & " 		AND EdSvcReqTp = 'A' "
		CSQL = CSQL & " 	UNION ALL "
		CSQL = CSQL & " 	SELECT [PlayerReln] "
		CSQL = CSQL & " 		,[PlayerRelnMemo] "  
		CSQL = CSQL & " 		,[UserName] "
		CSQL = CSQL & " 		,[UserPhone] " 
		CSQL = CSQL & " 		,[SrtDate] "
		CSQL = CSQL & " 		,[SrtSvcDate] "
		CSQL = CSQL & " 		,[Team] "
		CSQL = CSQL & " 		,[LeaderType] "
		CSQL = CSQL & " 	FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " 	WHERE DelYN = 'N' "
		CSQL = CSQL & " 		AND SportsType =  '"&SportsGb&"' "
		CSQL = CSQL & " 		AND Team = '"&Team&"' "
		CSQL = CSQL & " 		AND PlayerReln = 'T' "
		CSQL = CSQL & " 		AND EdSvcReqTp = 'A' "
		CSQL = CSQL & " ) A "
		CSQL = CSQL & " ORDER BY A.PlayerReln, A.SrtDate DESC, A.LeaderType "
		
'		response.Write CSQL

		SET CRs = Dbcon.Execute(CSQL)
		IF Not(CRs.Eof Or CRs.Bof) Then 
			Do Until CRs.eof
	
				SELECT CASE CRs("PlayerReln")
					CASE "A" : PlayerRelnNm = "부"
					CASE "B" : PlayerRelnNm = "모"
					CASE "Z" : PlayerRelnNm = ReplaceTagReText(CRs("PlayerRelnMemo"))
					CASE "T" 
						PlayerRelnNm = "지도자"
						LeaderTypeNm = CRs("LeaderTypeNm")
					CASE ELSE 						
				END SELECT
			
				SELECT CASE CRs("PlayerReln")
					'팀매니저							
					CASE "T"  
						txtManage = txtManage &"<li>"
						txtManage = txtManage &"  <p>"&ReplaceTagReText(CRs("UserName"))&" "&LeaderTypeNm&"("&CRs("UserPhone")&")</p>"
						txtManage = txtManage &"  <p>관리 시작일 : "&CRs("SrtSvcDate")&"</p>"
						txtManage = txtManage &"</li>"
						
						cntManage = cntManage + 1
					
					'부모, 기타     
					CASE "A", "B", "Z"  
						txtParents = txtParents &"<li>"
						txtParents = txtParents &"  <p>("&PlayerRelnNm&")"&ReplaceTagReText(CRs("UserName"))&"님("&CRs("UserPhone")&")</p>"
						txtParents = txtParents &"  <p>공유 시작일 : "&CRs("SrtDate")&"</p>"
						txtParents = txtParents &"</li>"
						
						cntParents = cntParents + 1
					
					'선수/비등록선수	
					CASE "", "K"  		
						txtPlayer = txtPlayer &"<li>"
						txtPlayer = txtPlayer &"  <p>"&ReplaceTagReText(CRs("UserName"))&"("&CRs("UserPhone")&")</p>"
						txtPlayer = txtPlayer &"  <p>공유 시작일 : "&SrtDate&"</p>"
						txtPlayer = txtPlayer &"</li>"
						
						cntPlayer = cntPlayer + 1
						
					CASE ELSE		
				END SELECT
			
			CRs.movenext
		Loop  
		  
			'보호자 정보 출력
			IF cntParents > 0 Then
				response.Write "<h3>보호자 정보</h3>"
				response.Write txtParents
			End IF
			
			'선수/비등록선수 정보 출력
			IF cntPlayer > 0 Then
				response.Write "<h3>선수 정보</h3>"
				response.Write txtPlayer
			End IF
			
			'팀매니저 정보 출력
			IF cntManage > 0 Then
				response.Write "<h3>팀매니저 정보</h3>"
				response.Write txtManage
			End IF
			  
			SELECT CASE PlayerReln
				'선수/관원 선수의 경우 
				CASE "R"
					response.Write "<p class='graybox'> 위의 보호자 및 지도자는 본인의 일부 데이터를 함께 공유하도록 되어 있습니다. "
					response.Write "본인의 실제 보호자와 지도자의 정보가 일치하지 않을 경우 스포츠다이어리로 연락바랍니다.</p>"
					
'					IF cntParents > 0 Then
'						response.Write "<p class='data-cut'>보호자 : 공유차단 되는 데이터</p>"
'						response.Write "<ul class='cut'>"
'						response.Write "  <li>- <span class='point'>훈련일지</span>의 모든 메모리 내용</li>"
'						response.Write "  <li>- <span class='point'>대회일지</span>의 모든 메모리 내용</li>"
'						response.Write "</ul>"
'					End IF
					
'					IF cntManage > 0 Then
'						response.Write "<p class='data-cut'>지도자 : 공유차단 되는 데이터</p>"
'						response.Write "<ul class='cut'>"
'						response.Write "  <li>- <span class='point'>훈련일지</span>의 나의 일기 내용</li>"
'						response.Write "  <li>- <span class='point'>대회일지</span>의 나의 일기 내용</li>"
'						response.Write "</ul>"
'					End IF
									
				'부모의 경우	
				CASE "A", "B", "Z"
					response.Write "<p class='graybox'> 선수 및 해당 소속 팀매니저와의 데이터공유가 시작되었습니다. "
					response.Write "본인의 실제 선수와 지도자의 정보가 일치하지 않을 경우 스포츠다이어리로 연락바랍니다.</p>"
					
			END SELECT
		
		ELSE      
		
		  response.Write "<li><p style='center'>공유대상이 없습니다.</p></li>"
		  Response.End
		
		End If 

			CRs.Close
		SET CRs = Nothing
			
		DBClose()

  	End If 
%>