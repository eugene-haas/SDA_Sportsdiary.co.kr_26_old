<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	dim PlayerIDX		: PlayerIDX 	= decode(request.Cookies("PlayerIDX"), 0)
	dim TraiFistCd	 	: TraiFistCd 	= fInject(request("TraiFistCd"))		'훈련종류 종목 대분류
	dim TraiMidIDX		: TraiMidIDX 	= fInject(request("TraiMidIDX"))		'수정할 중분류IDX	
	dim add_TrainNm		: add_TrainNm 	= ReplaceTagText(fInject(request("add_TrainNm")))		'추가할 중분류 명
	dim mod_TrainNm		: mod_TrainNm 	= ReplaceTagText(fInject(request("mod_TrainNm")))		'수정할 중분류 명
	dim Type_Action		: Type_Action 	= fInject(request("Type_Action"))		'처리 액션
	
'	response.Write "PlayerIDX="	&PlayerIDX&"<br>"
'	response.Write "TraiFistCd="	&TraiFistCd&"<br>"
'	response.Write "TraiMidIDX="	&TraiMidIDX&"<br>"
'	response.Write "add_TrainNm="	&add_TrainNm&"<br>"
'	response.Write "mod_TrainNm="	&mod_TrainNm&"<br>"
'	response.Write "Type_Action="	&Type_Action&"<br>"
	
	
	dim CSearch, CSearch2
	
	dim chk_NumType	: chk_NumType = FALSE	'중분류 코드 생성유효성
	dim Chk_Numer							'중분류 코드
	dim Chk_OrderBy 		'중분류 코드 정렬 순서
	
	
	'훈련종목 대분류
	IF TraiFistCd <> "" Then
		CSearch = " AND TraiFistCd='"&TraiFistCd&"' "
	End IF
	
	'사용자 훈련종목 조회
	IF PlayerIDX <> "" Then
		CSearch2 = " AND PlayerIDX='"&PlayerIDX&"' "
	End IF	
	

	IF PlayerIDX<>"" Then
	
		SELECT CASE Type_Action
	
			CASE "ADD"				
				'============================================================================		
				'중분류 코드 생성
				'============================================================================		
				SET LRs = Dbcon.Execute("SELECT MAX(TraiMidCd) FROM [SportsDiary].[dbo].[tblSvcTrailMidInfo]")
				IF Not(LRs.eof or LRs.bof) Then
					IF CInt(LRs(0)) <= 99999999 Then 	'8자리코드:varchar(20)
						Chk_Numer = CInt(LRs(0))+1
					 
						FOR i=1 to 8
							SELECT CASE Len(Chk_Numer)
								CASE 1 : Chk_Numer = "0000000"&Chk_Numer
								CASE 2 : Chk_Numer = "000000"&Chk_Numer
								CASE 3 : Chk_Numer = "00000"&Chk_Numer
								CASE 4 : Chk_Numer = "0000"&Chk_Numer
								CASE 5 : Chk_Numer = "000"&Chk_Numer
								CASE 6 : Chk_Numer = "00"&Chk_Numer
								CASE 7 : Chk_Numer = "0"&Chk_Numer
								CASE Else
							END SELECT
						NEXT
						
						chk_NumType = TRUE	
					End IF	
				Else
					'초기코드값
					Chk_Numer = "00000001"
					chk_NumType = TRUE
				End IF
				'============================================================================
				'중분류 ORDER BY
				'============================================================================
				LSQL = "SELECT ISNULL(MAX(OrderBy), 0) Orderby "
				LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblSvcTrailMidInfo] "
				LSQL = LSQL & " WHERE DelYN = 'N' "
				LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"' "
				LSQL = LSQL & " 	AND PlayerIDX = '"&PlayerIDX&"' "
				
				SET LRs = Dbcon.Execute(LSQL)
				IF Not(LRs.eof or LRs.bof) Then
					Chk_OrderBy = LRs(0) + 1
				Else
					'값이 없는 경우 초기 세팅
					Chk_OrderBy = 1				
				End IF
					LRs.Close
				SET LRs = Nothing	
				
				'============================================================================		
				'중분류 추가	
				'============================================================================		
				IF chk_NumType = TRUE Then 
					RSQL = "INSERT INTO Sportsdiary.dbo.tblSvcTrailMidInfo ( "&_
								" 	SportsGb "&_
								"	,TraiFistCd "&_
								"	,TraiMidCd "&_
								"	,TraiMIdNm "&_
								"	,WriteDate "&_
								"	,WorkDt "&_
								"	,DelYN "&_
								"	,PlayerIDX "&_
								"	,OrderBy "&_
								"	) "&_
								"	VALUES( "&_
								"	 	'"&SportsGb&"'"&_
								"		,'"&TraiFistCd&"' "&_
								"		,'"&Chk_Numer&"' "&_
								"		,'"&add_TrainNm&"' "&_
								"		,GetDate() "&_
								"		,GetDate() "&_
								"		,'N' "&_
								"		,'"&PlayerIDX&"' "&_
								"		, "&Chk_OrderBy&_
								"	) "	
				
					Dbcon.Execute(RSQL)		
				End IF
	
			CASE "SAVE"	
				
				IF TraiMidIDX <> "" Then 
					RSQL = "  UPDATE [Sportsdiary].[dbo].[tblSvcTrailMidInfo] "&_
							" SET TraiMIdNm = '"&mod_TrainNm&"' "&_
							"	,WorkDt = GetDate() "&_
							" WHERE PlayerIDX = '"&PlayerIDX&"' "&_
							"	AND TraiMidIDX = '"&TraiMidIDX&"' "					
					Dbcon.Execute(RSQL)		
				End IF			
			
			CASE "DEL"	
			
				IF TraiMidIDX <> "" Then 
					RSQL = "  UPDATE [Sportsdiary].[dbo].[tblSvcTrailMidInfo] "&_
							" SET WorkDt = GetDate() "&_
							"		,DelYN = 'Y' "&_
							" WHERE PlayerIDX = '"&PlayerIDX&"' "&_
							"		AND TraiMidIDX = '"&TraiMidIDX&"' "					
					Dbcon.Execute(RSQL)		
				End IF
		
		END SELECT
	
	End IF
		
	'조회 
	IF PlayerIDX = "" Then			
		LSQL = "		SELECT TraiMidIDX "
		LSQL = LSQL & "		,TraiMidCd "
		LSQL = LSQL & "		,TraiMIdNm "
		LSQL = LSQL & "		,OrderBy "
		LSQL = LSQL & "		,PlayerIDX "
		LSQL = LSQL & "	FROM [SportsDiary].[dbo].[tblSvcTrailMidInfo] "
		LSQL = LSQL & "	WHERE DelYN = 'N' "
		LSQL = LSQL & "		AND SportsGb = '"&SportsGb&"'  "
		LSQL = LSQL & "		AND TraiFistCd = '"&TraiFistCd&"' "
		LSQL = LSQL & "		AND (PlayerIDX='' or PlayerIDX is Null) "	
		LSQL = LSQL & "		AND (LeaderIDx='' or LeaderIDx is Null) "
		LSQL = LSQL & "	ORDER BY OrderBy ASC "
		LSQL = LSQL & "		,TraiMIdNm ASC "
	Else
		LSQL = "		SELECT A.TraiMidIDX "
		LSQL = LSQL & "  	,A.TraiMidCd  "
		LSQL = LSQL & "	 	,A.TraiMIdNm "
		LSQL = LSQL & "		,A.OrderBy "
		LSQL = LSQL & "	 	,A.PlayerIDX "
		LSQL = LSQL & "	FROM ( "
		LSQL = LSQL & "		SELECT TraiMidIDX "
		LSQL = LSQL & "			,TraiMidCd "
		LSQL = LSQL & "			,TraiMIdNm "
		LSQL = LSQL & "			,OrderBy "
		LSQL = LSQL & "			,PlayerIDX "
		LSQL = LSQL & "		FROM [SportsDiary].[dbo].[tblSvcTrailMidInfo] "
		LSQL = LSQL & "		WHERE DelYN='N' "
		LSQL = LSQL & "			AND SportsGb='"&SportsGb&"'  "
		LSQL = LSQL & "			AND TraiFistCd='"&TraiFistCd&"'  "
		LSQL = LSQL & "			AND PlayerIDX='"&PlayerIDX&"' "
		LSQL = LSQL & "		UNION ALL 			 "
		LSQL = LSQL & "		SELECT TraiMidIDX "
		LSQL = LSQL & "			,TraiMidCd "
		LSQL = LSQL & "			,TraiMIdNm "
		LSQL = LSQL & "			,OrderBy "
		LSQL = LSQL & "			,PlayerIDX "
		LSQL = LSQL & "		FROM [SportsDiary].[dbo].[tblSvcTrailMidInfo] "
		LSQL = LSQL & "		WHERE DelYN='N' "
		LSQL = LSQL & "			AND SportsGb='"&SportsGb&"'  "
		LSQL = LSQL & "			AND TraiFistCd='"&TraiFistCd&"' "
		LSQL = LSQL & "			AND (PlayerIDX='' or PlayerIDX is Null) "	 
		LSQL = LSQL & "			AND (LeaderIDx='' or LeaderIDx is Null) "
		LSQL = LSQL & "	) A "
		LSQL = LSQL & "	ORDER BY A.PlayerIDX DESC "
		LSQL = LSQL & "		,A.OrderBy ASC "
		LSQL = LSQL & "		,A.TraiMIdNm ASC "
	End IF		
	
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 				
		Do Until LRs.Eof 
		
			IF LRs("PlayerIDX") <> "" Then
			%>
			<ul class="training-add-list">
				<li id="viewTraiMid<%=LRs("TraiMidIDX")%>">
				  <p><%=ReplaceTagReText(LRs("TraiMIdNm"))%></p>
				  <a href="javascript:mod_TrainInfo('<%=LRs("TraiMidIDX")%>', 'MOD');" class="btn-gray-square">수정</a>
				  <a href="#" class="btn-red-square" data-target="#confirm-del" data-toggle="modal" data-title="<%=LRs("TraiMidIDX")%>">삭제</a>
				</li>
				
				<li id="modTraiMid<%=LRs("TraiMidIDX")%>" style="display:none;">
				  <p><input type="text" name="mod_TrainNm<%=LRs("TraiMidIDX")%>" id="mod_TrainNm<%=LRs("TraiMidIDX")%>" value="<%=ReplaceTagReText(LRs("TraiMIdNm"))%>" /></p>
				  <a href="javascript:mod_TrainInfo('<%=LRs("TraiMidIDX")%>', 'RESET');" class="btn-navyline-square">취소</a>
				  <a href="javascript:mod_TrainInfo_Proc('<%=LRs("TraiMidIDX")%>', 'SAVE');" class="btn-navy-square">완료</a>
				</li>
			</ul>		
			<%		
			Else
			%>
			<ul class="training-fix-list">
				<li><%=ReplaceTagReText(LRs("TraiMIdNm"))%></li>
			 </ul>
			<%
			End IF
				
			LRs.MoveNext
		Loop 
	End If 

		LRs.Close
	SET LRs = Nothing		
	
	
	DBClose()
	
%>