<!--#include file="../Library/ajax_config.asp"-->
<%
	dim BlockPage   : BlockPage 	= 5	'페이지
	dim B_PSize   	: B_PSize 		= 10	'페이지내 보여지는 목록카운트

	dim TotCount, TotPage
	dim CSearch, CSearch2

	dim currPage   	: currPage  	= fInject(Request("currPage"))
	dim SDate   	: SDate 		= fInject(Request("SDate"))
	dim EDate   	: EDate 		= fInject(Request("EDate"))
	dim search_date : search_date 	= fInject(Request("search_date"))
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))

	dim UserID 		: UserID 		= decode(request.Cookies("UserID"),0)

	'선수 보호자 회원의 경우 MemberIDX 쿠키 교체되었기 때문에 선수보호자 MemberIDX로 교체
	SELECT CASE decode(request.Cookies("PlayerReln"), 0)
		CASE "A","B","Z" 	: MemberIDX = decode(request.Cookies("P_MemberIDX"),0)
		CASE ELSE			: MemberIDX = decode(request.Cookies("MemberIDX"),0)
	END SELECT

	dim fnd_DateNm
	dim ChkSQL
	dim chk_FAV
	'====================================================================================
	'즐겨찾기 설정
	'====================================================================================
	IF CIDX = "" Then
		response.End()
	Else

		ChkSQL =" SELECT * "&_
				" FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] " &_
				" WHERE DelYN = 'N' "&_
				"		AND MemberIDX = "&MemberIDX&_
				"		AND LedrAdvIDx = "&CIDX&_
				"		AND TypeLedrAdv = 'F'"
		SET CRs = Dbcon.Execute(ChkSQL)
		IF Not(CRs.eof or CRs.bof) Then
			'질문과 답변 즐겨찾기 설정/해제

				CSQL = 	" 		 UPDATE [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "
				CSQL = 	CSQL & " SET WorkDt = GetDate() "

				SELECT CASE CRs("DelYN")
					CASE "N" : 	CSQL = CSQL & ",DelYN = 'Y'" 	'해제
					CASE ELSE : CSQL = CSQL & ",DelYN = 'N'"	'설정
				END SELECT

				CSQL = 	CSQL & " WHERE LedrAdvIDx = "&CIDX
				CSQL = 	CSQL & " 	AND MemberIDX = "&MemberIDX
				CSQL = 	CSQL & " 	AND TypeLedrAdv='F'"

				Dbcon.Execute(CSQL)

		Else

			CSQL = 	" INSERT INTO [Sportsdiary].[dbo].[tblSvcLedrAdvSub] (" &_
					" 	 LedrAdvIDX " &_
					"	,MemberIDX " &_
					"	,UserID " &_
					"	,TypeLedrAdv " &_
					"	,WriteDate " &_
					"	,WorkDt " &_
					"	,DelYN " &_
					" ) VALUES ( "&_
					"	 "&CIDX &_
					"	,"&MemberIDX&_
					"	,'"&UserID&"' "&_
					"	,'F' "&_
					"	,GetDate() "&_
					"	,GetDate() "&_
					"	,'N') "

			Dbcon.Execute(CSQL)

		End IF
			CRs.Close
		SET CRs = Nothing
	End IF
	'====================================================================================

	IF search_date<>"" Then
		SELECT CASE search_date
			CASE "week" : fnd_DateNm = "최근 1주일"
			CASE "month" : fnd_DateNm = "최근 1개월"
			CASE "month3" : fnd_DateNm = "최근 3개월"
			CASE "month6" : fnd_DateNm = "최근 6개월"
			CASE "year" : fnd_DateNm = "최근 1년"
			CASE "year2" : fnd_DateNm = "최근 2년"
			CASE "year3" : fnd_DateNm = "최근 3년"
			CASE "year5" : fnd_DateNm = "최근 5년"
			CASE "year10" : fnd_DateNm = "최근 10년"
		END SELECT
	End IF

	IF Len(currPage) = 0 Then currPage = 1


	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', WriteDate)>=0 AND DateDiff(d, WriteDate, '"&EDate&"')>=0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch = " AND DateDiff(d, WriteDate, '"&EDate&"')=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', WriteDate)=0 "
	Else
	End IF

	ChkSQL = " 	SELECT COUNT(*) "&_
			"		, CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " &_
			"	FROM ( "&_
			"		  SELECT *"&_
			"		  FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "&_
			"		  WHERE DelYN = 'N' "&_
			"			  	AND SportsGb = '"&SportsGb&"' "&CSearch&_
			"				AND LedrAdvIDX in( "&_
			"					SELECT LedrAdvIDX "&_
			"					FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "&_
			"					WHERE DelYN = 'N' "&_
			"						AND	TypeLedrAdv = 'F'  "&_
			"						AND UserID = '"&UserID&"'  "&_
			"				) "&_
			"		  UNION ALL "&_
			"		  SELECT * "&_
			"		  FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "&_
			"	  	  WHERE DelYN = 'N' "&_
			"				AND SportsGb = '"&SportsGb&"' "&_
			"				AND (ReplyType='T' OR UserID='"&UserID&"') "&_
			"				AND ReLedrAdvIDX in( "&_
			"				    SELECT LedrAdvIDX "&_
			"		 			FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "&_
			"		  			WHERE DelYN = 'N' "&_
			"			  			AND SportsGb = '"&SportsGb&"' "&CSearch&_
			"						AND LedrAdvIDX in( "&_
			"							SELECT LedrAdvIDX "&_
			"							FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "&_
			"							WHERE DelYN = 'N' "&_
			"								AND UserID = '"&UserID&"'  "&_
			"								AND TypeLedrAdv = 'F' "&_
			"						) "&_
			"				) "&_
			"	) A1 "

	SET CRs = Dbcon.Execute(ChkSQL)
		TotalCount = CRs(0)
		TotalPage = CRs(1)

	ChkSQL = 	" 	SELECT TOP "&currPage * B_PSize&" A1.CIDX CIDX"&_
				"		  ,A1.IDX IDX "&_
				"		  ,A1.IDX2 IDX2 "&_
				"		  ,A1.Title Title "&_
				"		  ,A1.Contents Contents "&_
				"		  ,A1.UserName UserName "&_
      			"		  ,A1.WriteDate	WriteDate "&_
				"	FROM ( "&_
				"		  SELECT LedrAdvIDX CIDX "&_
				"				,LedrAdvIDX IDX "&_
				"				,ReLedrAdvIDX IDX2 "&_
				"				,Title Title "&_
				"				,Contents Contents  "&_
				"				,UserName UserName  "&_
   				"         		,WriteDate WriteDate "&_
				"		  FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "&_
				"		  WHERE DelYN = 'N' "&_
				"			  	AND SportsGb = '"&SportsGb&"' "&CSearch&_
				"				AND LedrAdvIDX in( "&_
				"					SELECT LedrAdvIDX "&_
				"					FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "&_
				"					WHERE DelYN = 'N' "&_
				"						AND UserID = '"&UserID&"'  "&_
				"						AND TypeLedrAdv = 'F' "&_
				"				) "&_
				"		  UNION ALL "&_
				"		  SELECT LedrAdvIDX CIDX  "&_
				"				,ReLedrAdvIDX IDX "&_
				"				,LedrAdvIDX IDX2  "&_
				"				,Title Title  "&_
				"				,Contents Contents "&_
				"				,UserName UserName "&_
				"				,WriteDate WriteDate "&_
				"		  FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "&_
				"	  	  WHERE DelYN = 'N' "&_
				"				AND SportsGb = '"&SportsGb&"' "&_
				"				AND (ReplyType = 'T' OR UserID='"&UserID&"')"&_
				"				AND ReLedrAdvIDX in( "&_
				"				    SELECT LedrAdvIDX "&_
				"		 			FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "&_
				"		  			WHERE DelYN = 'N' "&_
				"			  			AND SportsGb = '"&SportsGb&"' "&CSearch&_
				"						AND LedrAdvIDX in( "&_
				"							SELECT LedrAdvIDX "&_
				"							FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "&_
				"							WHERE DelYN = 'N'  "&_
				"								AND UserID = '"&UserID&"'  "&_
				"								AND [TypeLedrAdv]='F' "&_
				"						) "&_
				"				) "&_
				"	) A1 "&_
				"	ORDER BY A1.IDX DESC "&_
				"			 ,A1.IDX2 ASC "

	SET CRs = Dbcon.Execute(ChkSQL)

	FndData = FndData & "<div class='counsel-list'>"
	FndData = FndData & "	<ul>"

	If Not(CRs.Eof Or CRs.Bof) Then

		CRs.Move (currPage - 1) * B_PSize

		Do Until CRs.eof


			'질문의 경우 타이틀출력
			IF CINT(CRs("IDX2"))=0 Then
				FndData = FndData & "<li>"
				FndData = FndData & "	<div class='ic-tit'>"
				FndData = FndData & "		<span class='cut-off'>"
				FndData = FndData & "			<span id='FAV"&CRs("CIDX")&"' class='icon-favorite "

				SET LRs = Dbcon.Execute("SELECT DelYN FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] WHERE LedrAdvIDX="&CRs("CIDX")&" AND userid='"&UserID&"' And TypeLedrAdv='F'")

				IF Not(LRs.eof or LRs.bof) Then
					IF LRs("DelYN") = "N" Then FndData = FndData & "on"
				End IF
					LRs.close

				FndData = FndData & "			' onclick=""SET_Favorite('"&CRs("CIDX")&"', 'FAV');"">★</span>"
				FndData = FndData & "		</span>"
				FndData = FndData & "	</div>"
				FndData = FndData & "	<div class='counsel-tit-wrap'>"
				FndData = FndData & "		<div class='counsel-row'>"
				FndData = FndData & "			<div class='counsel-tit' onclick=""chk_Submit('VIEW','"&CRs("CIDX")&"','"&currPage&"');"">"&ReplaceTagReText(CRs("Title"))

				If DateDiff("H", CRs("WriteDate"), Now())<24 Then FndData = FndData & "<span class='icon-new'>N</span>"

				FndData = FndData & "			</div>"
				FndData = FndData & "		</div>"
				FndData = FndData & "		<p class='write-info clearfix'>"
				FndData = FndData & "			<span>"&CRs("UserName")&"</span>"
				FndData = FndData & "			<span>"&replace(left(CRs("WriteDate"), 10), "-", ".")&"</span>"
				FndData = FndData & "		</p>"
				FndData = FndData & "	</div>"
				FndData = FndData & "</li>"

			'답변의 경우 내용 일부 출력
			Else

				FndData = FndData & "<li class='reply'>"
				FndData = FndData & "	<div class='counsel-tit-wrap'>"
				FndData = FndData & "		<div class='counsel-row'>"
				FndData = FndData & "			<div class='counsel-tit' onclick=""chk_Submit('VIEW','"&CRs("CIDX")&"','"&currPage&"');"">"
				FndData = FndData & "				<span class='icon-gray'>답변</span> "&ReplaceTagReText(CRs("Title"))

				If DateDiff("H", CRs("WriteDate"), Now())<24 Then FndData = FndData & "<span class='icon-new'>N</span>"

				FndData = FndData & "			</div>"
				FndData = FndData & "		</div>"
				FndData = FndData & "		<p class='write-info clearfix'>"
				FndData = FndData & "			<span class='skyblue'>"&CRs("UserName")&"</span>"
				FndData = FndData & "			<span>"&replace(left(CRs("WriteDate"), 10), "-", ".")&"</span>"
				FndData = FndData & "		</p>"
				FndData = FndData & "	</div>"
				FndData = FndData & "</li>"

			End IF

			CRs.movenext
		Loop
	Else
		FndData = FndData & "<li>일치하는 정보가 없습니다.</li>"
	End IF

	FndData = FndData & "	</ul>"
	FndData = FndData & "</div>"

		CRs.Close
	SET CRs = Nothing

	response.Write FndData


	dim intTemp

	CStrPG = CStrPG & " <div id='boardPage' class='board-bullet'>"

	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	If intTemp = 1 Then

	Else
		CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');"" class='prev'><img src='http://img.sportsdiary.co.kr/sdapp/board/board-l-arrow@3x.png' alt='이전페이지'></a> "
	End If

	dim intLoop : intLoop = 1

	Do Until intLoop > BlockPage Or intTemp > TotalPage
		If intTemp = CInt(currPage) Then
			CStrPG = CStrPG & " <a href='#' class='on'>"&intTemp&"</a> "
		Else
			CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"">"&intTemp&"</a> "
		End If

		intTemp = intTemp + 1
		intLoop = intLoop + 1
	Loop

	IF intTemp > TotalPage Then

	Else
		CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" class='next'><img src='http://img.sportsdiary.co.kr/sdapp/board/board-r-arrow@3x.png' alt='다음페이지'></a> "
	End IF

    CStrPG = CStrPG & "</div>"

	response.Write CStrPG


	DBClose()
%>
