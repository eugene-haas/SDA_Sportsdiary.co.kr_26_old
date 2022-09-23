<%
	'=====================================================================================
	'한자리수 숫자 0붙이기
	'=====================================================================================
	Function AddZero(Str)
		IF len(Str)=1 Then
			AddZero="0"&Str
		Else
			AddZero=Str
		End IF
	End Function
	'=====================================================================================
	'로그인체크
	'=====================================================================================
	Function Check_Login()
		IF Request.Cookies("SD")("UserID") = "" Then
			'Response.Write "<script>location.href='./login.asp';</script>"
			Response.Write "<script>alert('회원정보가 필요한 서비스입니다.\n로그인 후 이용하세요.');$(location).attr('href','./login.asp');</script>"
			Response.End
		End IF
	End Function
	'=====================================================================================
	Function Check_NoLogin()
		IF Request.Cookies("SD")("UserID") <> "" Then
			'response.Write "<script>location.href='./index.asp';</script>"
            response.Write "<script>$(location).attr('href','http://judo.sportsdiary.co.kr/M_Player/main/index.asp');</script>"
			response.End
		End IF
	End Function

	'========================================================================================================
	'동일한 사용자계정(이름,생년월일)이 있는지 체크하여 리턴(통합ID 설정 유무체크)
	'리턴값 : count(*)
   	'유도DB [Sportsdiary].[dbo].[tblMember]데이터를 통합회원DB에 복사하였기 때문에 이름,생년월일 동일 계정이 존재합니다.
	'통합회원DB에서 한개의 개정만 남긴 후 기타 계정은 삭제하기 위한 계정카운트조회 로직입니다.
   	'/sdmain/ajax/login_OK.asp
	'========================================================================================================
	FUNCTION CHK_JOINUS(valName, valBirth)
		dim TSQL, TRs, SQL, Rs

		TSQL = " 		SELECT ISNULL(COUNT(*), 0) cnt "
		TSQL = TSQL & " FROM [SD_Member].[dbo].[tblMember]"
		TSQL = TSQL & " WHERE DelYN = 'N'"
		TSQL = TSQL & "		AND UserName = '"&valName&"' "
		TSQL = TSQL & "		AND Birthday = '"&valBirth&"' "

		SET TRs = DBCon3.Execute(TSQL)

		CHK_JOINUS = TRs(0)

			TRs.Close
		SET TRs = Nothing

	END FUNCTION
	'========================================================================================================
	'쿠키설정(통합ID, SportsGb, 자동로그인구분자Y|N)
	'========================================================================================================
	FUNCTION SET_INFO_COOKIE(valID, valType, valSaveIDYN)
		dim TSQL, TRs, SQL, Rs
		dim PhotoPath
		dim ReValue

		response.Cookies(valType).Domain 	= ".sportsdiary.co.kr"
		response.Cookies(valType).path 		= "/"

		'자동로그인 기능
		IF valSaveIDYN = "Y" Then
			response.cookies(valType).expires 	= Date() + 365
		Else
			response.cookies(valType).expires 	= Date() + 1
		End IF

		SELECT CASE valType
   			'------------------------------------------------------------------------------------------------------------------------
			'유도
			'------------------------------------------------------------------------------------------------------------------------
			CASE "judo"

				TSQL = " 		SELECT A.PlayerIDX"
				TSQL = TSQL & "		,A.MemberIDX"
				TSQL = TSQL & "		,A.EnterType "
				TSQL = TSQL & "		,A.UserID"
				TSQL = TSQL & "		,A.UserName"
				TSQL = TSQL & "		,ISNULL(A.PhotoPath, '') PhotoPath "
				TSQL = TSQL & "		,A.Team "
				TSQL = TSQL & "		,A.PlayerReln "
				TSQL = TSQL & "		,CONVERT(CHAR, CONVERT(DATE, A.SrtDate), 102) SrtDate "
				TSQL = TSQL & "		,T.SvcStartDt "
				TSQL = TSQL & "		,T.SvcEndDt "
				TSQL = TSQL & " FROM [SportsDiary].[dbo].[tblMember] A "
				TSQL = TSQL & "		left join [SportsDiary].[dbo].[tblPlayer] B on A.PlayerIDX = B.PlayerIDX AND B.DelYN = 'N' AND B.SportsGb = '"&valType&"'"
				TSQL = TSQL & "		left join [SportsDiary].[dbo].[tblTeamInfo] T on A.Team = T.Team AND T.DelYN = 'N' AND T.SportsGb = '"&valType&"'"
				TSQL = TSQL & " WHERE A.DelYN = 'N'"
				TSQL = TSQL & " 	AND A.SportsType = '"&valType&"'"
				TSQL = TSQL & "		AND A.SD_UserID = '"&valID&"' "
				TSQL = TSQL & "		AND A.SD_GameIDSET = 'Y' "

				SET TRs = DBCon.Execute(TSQL)
				IF Not(TRs.Eof Or TRs.Bof) Then

					'회원프로필 이미지 세팅
					IF len(TRs("PhotoPath")) > 0  Then
						PhotoPath 	= "../"& mid(TRs("PhotoPath"), 4, len(TRs("PhotoPath")))
					Else
						PhotoPath 	= "../images/public/profile@3x.png"
					End IF

					'------------------------------------------------------------------------------------------------------------------------
					'선수보호자 로그인의 경우 선수정보로 쿠키변경 처리
					'------------------------------------------------------------------------------------------------------------------------
					SELECT CASE TRs("PlayerReln")
						CASE "A","B","Z"

							'선수정보 조회
							TSQL = " 		SELECT A.PlayerIDX"
							TSQL = TSQL & "		,A.MemberIDX"
							TSQL = TSQL & "		,A.UserName"
							TSQL = TSQL & "		,A.Team "
							TSQL = TSQL & "		,T.SvcStartDt "
							TSQL = TSQL & "		,T.SvcEndDt "
							TSQL = TSQL & " FROM [SportsDiary].[dbo].[tblMember] A "
							TSQL = TSQL & "		left join [SportsDiary].[dbo].[tblPlayer] B on A.PlayerIDX = B.PlayerIDX AND B.DelYN = 'N' AND B.SportsGb = '"&valType&"'"
							TSQL = TSQL & "		left join [SportsDiary].[dbo].[tblTeamInfo] T on A.Team = T.Team AND T.DelYN = 'N' AND T.SportsGb = '"&valType&"'"
							TSQL = TSQL & " WHERE A.DelYN = 'N'"
							TSQL = TSQL & " 	AND A.SportsType = '"&valType&"' "
							TSQL = TSQL & "		AND A.PlayerIDX = '"&TRs("PlayerIDX")&"' "
							TSQL = TSQL & "		AND A.PlayerReln IN('R', 'K', 'S')"

							SET Rs = DBCon.Execute(TSQL)
							IF Not(Rs.Eof Or Rs.Bof) Then
								'------------------------------------------------------------------------------------------------------------------------
								'선수보호자의 경우 선수정보 조회 후 쿠키셋팅
								Response.Cookies(valType)("P_MemberIDX") = encode(TRs("MemberIDX"), 0)  	'회원등록번호[선수보호자]
								'------------------------------------------------------------------------------------------------------------------------
								'선수정보
								Response.Cookies(valType)("MemberIDX") 	= encode(Rs("MemberIDX"), 0)  		'회원등록번호
								Response.Cookies(valType)("PlayerIDX") 	= encode(Rs("PlayerIDX"), 0)  		'선수번호
								'------------------------------------------------------------------------------------------------------------------------

								IF Team <> "" Then Response.Cookies(valType)("Team") = encode(Rs("Team") , 0)   	  	'팀소속
								IF SvcStartDt <> "" Then Response.Cookies(valType)("SvcStartDt") = Rs("SvcStartDt")    	'팀 관리 서비스 시작일
								IF SvcEndDt <> "" Then Response.Cookies(valType)("SvcEndDt") = Rs("SvcEndDt ")			'팀 관리 서비스 종료일

							End IF
								Rs.Close
							SET Rs = Nothing

						CASE ELSE

							Response.Cookies(valType)("MemberIDX") = encode(TRs("MemberIDX"), 0)  '회원등록번호

							IF TRs("Team") <> "" Then Response.Cookies(valType)("Team") = encode(TRs("Team") , 0)     				'팀소속
							IF TRs("PlayerIDX") <> "" Then Response.Cookies(valType)("PlayerIDX") = encode(TRs("PlayerIDX"), 0) 	'선수번호
							IF TRs("SvcStartDt") <> "" Then Response.Cookies(valType)("SvcStartDt") = TRs("SvcStartDt")    			'팀 관리 서비스 시작일
							IF TRs("SvcEndDt") <> "" Then Response.Cookies(valType)("SvcEndDt") = TRs("SvcEndDt")    				'팀 관리 서비스 종료일

					END SELECT

					IF TRs("PlayerReln") <> "" Then Response.Cookies(valType)("PlayerReln") = encode(TRs("PlayerReln"), 0) 		'보호자와 매칭된 선수와의 관계
					IF TRs("PhotoPath") <> "" Then Response.Cookies(valType)("PhotoPath") = encode(Server.HTMLEncode(PhotoPath), 0) '회원프로필 이미지

					Response.Cookies(valType)("SrtDate") = TRs("SrtDate")													'회원가입일[선수보호자]
					Response.Cookies(valType)("EnterType") = TRs("EnterType")  												'선수구분[E:엘리트 | A:아마추어 | K:국가대표]
					Response.Cookies(valType)("UserID") = TRs("UserID")														'사용자ID
					Response.Cookies(valType)("UserName") = TRs("UserName")    												'사용자명
					Response.Cookies(valType)("SportsGb") = valType

					ReValue = TRUE
				Else
					ReValue = FALSE
				End IF

					TRs.Close
				SET TRs = Nothing


			'------------------------------------------------------------------------------------------------------------------------
			'테니스
			'------------------------------------------------------------------------------------------------------------------------
			CASE "tennis"

				TSQL = " 		SELECT A.PlayerIDX"
				TSQL = TSQL & "		,A.MemberIDX"
				TSQL = TSQL & "		,A.EnterType "
				TSQL = TSQL & "		,A.UserName"
				TSQL = TSQL & "		,A.PhotoPath"
				TSQL = TSQL & "		,A.Team "
				TSQL = TSQL & "		,A.Team2 "
				TSQL = TSQL & "		,A.PlayerReln "
				TSQL = TSQL & "		,CONVERT(CHAR, CONVERT(DATE, A.SrtDate), 102) SrtDate "
				TSQL = TSQL & "		,T.SvcStartDt "
				TSQL = TSQL & "		,T.SvcEndDt "
				TSQL = TSQL & " FROM [SD_tennis].[dbo].[tblMember] A "
				TSQL = TSQL & "		left join [SD_tennis].[dbo].[tblPlayer] B on A.PlayerIDX = B.PlayerIDX AND B.DelYN = 'N' AND B.SportsGb = '"&valType&"'"
				TSQL = TSQL & "		left join [SD_tennis].[dbo].[tblTeamInfo] T on A.Team = T.Team AND T.DelYN = 'N' AND T.SportsGb = '"&valType&"'"
				TSQL = TSQL & " WHERE A.DelYN = 'N'"
				TSQL = TSQL & " 	AND A.SportsType = '"&valType&"'"
				TSQL = TSQL & "		AND A.SD_UserID = '"&valID&"' "
				TSQL = TSQL & "		AND A.SD_GameIDSET = 'Y' "

				SET TRs = DBCon3.Execute(TSQL)
				IF Not(TRs.Eof Or TRs.Bof) Then
					'------------------------------------------------------------------------------------------------------------------------
					'회원프로필 이미지 세팅
					IF len(TRs("PhotoPath")) > 0  Then
						PhotoPath 	= "../"& mid(TRs("PhotoPath"), 4, len(TRs("PhotoPath")))
					Else
						PhotoPath 	= "../images/public/profile@3x.png"
					End IF

					'------------------------------------------------------------------------------------------------------------------------
					'선수보호자 로그인의 경우 선수정보로 쿠키변경 처리
					'------------------------------------------------------------------------------------------------------------------------
					SELECT CASE TRs("PlayerReln")
						CASE "A","B","Z"

							'선수정보 조회
							TSQL = " 		SELECT A.PlayerIDX"
							TSQL = TSQL & "		,A.MemberIDX"
							TSQL = TSQL & "		,A.UserName"
							TSQL = TSQL & "		,A.Team "
							TSQL = TSQL & "		,A.Team2 "
							TSQL = TSQL & "		,T.SvcStartDt "
							TSQL = TSQL & "		,T.SvcEndDt "
							TSQL = TSQL & " FROM [SD_tennis].[dbo].[tblMember] A "
							TSQL = TSQL & "		left join [SD_tennis].[dbo].[tblPlayer] B on A.PlayerIDX = B.PlayerIDX AND B.DelYN = 'N' AND B.SportsGb = '"&valType&"'"
							TSQL = TSQL & "		left join [SD_tennis].[dbo].[tblTeamInfo] T on A.Team = T.Team AND T.DelYN = 'N' AND T.SportsGb = '"&valType&"'"
							TSQL = TSQL & " WHERE A.DelYN = 'N'"
							TSQL = TSQL & " 	AND A.SportsType = '"&valType&"' "
							TSQL = TSQL & "		AND A.PlayerIDX = '"&TRs("PlayerIDX")&"' "
							TSQL = TSQL & "		AND A.PlayerReln IN('R', 'K', 'S')"

							SET Rs = DBCon3.Execute(TSQL)
							IF Not(Rs.Eof Or Rs.Bof) Then
								'------------------------------------------------------------------------------------------------------------------------
								'선수보호자의 경우 선수정보 조회 후 쿠키셋팅
								Response.Cookies(valType)("P_MemberIDX") = encode(TRs("MemberIDX"), 0)  	'회원등록번호[선수보호자]
								'------------------------------------------------------------------------------------------------------------------------
								'선수정보
								Response.Cookies(valType)("MemberIDX") 	= encode(Rs("MemberIDX"), 0)  		'회원등록번호
								Response.Cookies(valType)("PlayerIDX") 	= encode(Rs("PlayerIDX"), 0)  		'선수번호
								'------------------------------------------------------------------------------------------------------------------------

								IF Team <> "" Then Response.Cookies(valType)("Team") = encode(Rs("Team"), 0)   	  		'팀소속
								IF Team2 <> "" Then Response.Cookies(valType)("Team2") = encode(Rs("Team2"), 0) 		'팀소속2
								IF SvcStartDt <> "" Then Response.Cookies(valType)("SvcStartDt") = Rs("SvcStartDt")    	'팀 관리 서비스 시작일
								IF SvcEndDt <> "" Then Response.Cookies(valType)("SvcEndDt") = Rs("SvcEndDt ")			'팀 관리 서비스 종료일

							End IF
								Rs.Close
							SET Rs = Nothing

						CASE ELSE

							Response.Cookies(valType)("MemberIDX") = encode(TRs("MemberIDX"), 0)  '회원등록번호

							IF TRs("Team") <> "" Then Response.Cookies(valType)("Team") = encode(TRs("Team"), 0)     				'팀소속
							IF TRs("Team2") <> "" Then Response.Cookies(valType)("Team2") = encode(TRs("Team2"), 0)     			'팀소속2
							IF TRs("PlayerIDX") <> "" Then Response.Cookies(valType)("PlayerIDX") = encode(TRs("PlayerIDX"), 0) 	'선수번호
							IF TRs("SvcStartDt") <> "" Then Response.Cookies(valType)("SvcStartDt") = TRs("SvcStartDt")    			'팀 관리 서비스 시작일
							IF TRs("SvcEndDt") <> "" Then Response.Cookies(valType)("SvcEndDt") = TRs("SvcEndDt")    				'팀 관리 서비스 종료일

					END SELECT


					IF TRs("PlayerReln") <> "" Then Response.Cookies(valType)("PlayerReln") = encode(TRs("PlayerReln"), 0) 	'보호자와 매칭된 선수와의 관계

					Response.Cookies(valType)("SrtDate") = TRs("SrtDate")													'회원가입일[선수보호자]
					Response.Cookies(valType)("EnterType") = TRs("EnterType")  												'선수구분[E:엘리트 | A:아마추어 | K:국가대표]
					'Response.Cookies(valType)("UserID") = TRs("UserID")														'사용자ID
					Response.Cookies(valType)("PhotoPath") = encode(Server.HTMLEncode(PhotoPath), 0)						'회원프로필 이미지
					Response.Cookies(valType)("UserName") = TRs("UserName")    												'사용자명
					Response.Cookies(valType)("SportsGb") = valType

					ReValue = TRUE
				Else
					ReValue = FALSE
				End IF

					TRs.Close
				SET TRs = Nothing

			'------------------------------------------------------------------------------------------------------------------------
			'자전거
			'------------------------------------------------------------------------------------------------------------------------
''			CASE "bike"          ' ' 2020-11-12일 자전거를 쓰지 않아 막았음 (Aramdry) - 사용시 위에 case로 풀것
			CASE "disablebike"	' 2020-11-12일 자전거를 쓰지 않아 막았음 (Aramdry) - 사용시 위에 case로 풀것

				TSQL = " 		SELECT A.PlayerIDX"
				TSQL = TSQL & "		,A.MemberIDX"
				TSQL = TSQL & "		,A.EnterType "
				TSQL = TSQL & "		,A.UserName"
				TSQL = TSQL & "		,A.PhotoPath"
				TSQL = TSQL & "		,A.PlayerReln "
				TSQL = TSQL & "		,CONVERT(CHAR, CONVERT(DATE, A.SrtDate), 102) SrtDate "
				TSQL = TSQL & " FROM [SD_Bike].[dbo].[tblMember] A "
				TSQL = TSQL & " WHERE A.DelYN = 'N'"
				TSQL = TSQL & " 	AND A.SportsType = '"&valType&"'"
				TSQL = TSQL & "		AND A.SD_UserID = '"&valID&"' "
				TSQL = TSQL & "		AND A.SD_GameIDSET = 'Y' "

				SET TRs = DBCon3.Execute(TSQL)
				IF Not(TRs.Eof Or TRs.Bof) Then

					'회원프로필 이미지 세팅
					IF len(TRs("PhotoPath")) > 0  Then
						PhotoPath 	= "../"& mid(TRs("PhotoPath"), 4, len(TRs("PhotoPath")))
					Else
						PhotoPath 	= "../images/public/profile@3x.png"
					End IF

					'------------------------------------------------------------------------------------------------------------------------
					'선수보호자 로그인의 경우 선수정보로 쿠키변경 처리
					'------------------------------------------------------------------------------------------------------------------------
					SELECT CASE TRs("PlayerReln")
						CASE "A","B","Z"

							'선수정보 조회
							TSQL =  " 		SELECT A.PlayerIDX"
							TSQL = TSQL & "		,A.MemberIDX"
							TSQL = TSQL & "		,A.UserName"
							TSQL = TSQL & " FROM [SD_Bike].[dbo].[tblMember] A "
							TSQL = TSQL & " WHERE A.DelYN = 'N'"
							TSQL = TSQL & " 	AND A.SportsType = '"&valType&"' "
							TSQL = TSQL & "		AND A.PlayerIDX = '"&TRs("PlayerIDX")&"' "
							TSQL = TSQL & "		AND A.PlayerReln IN('R', 'K', 'S')"

							SET Rs = DBCon3.Execute(TSQL)
							IF Not(Rs.Eof Or Rs.Bof) Then
								'------------------------------------------------------------------------------------------------------------------------
								'선수보호자의 경우 선수정보 조회 후 쿠키셋팅
								Response.Cookies(valType)("P_MemberIDX") = encode(TRs("MemberIDX"), 0)  	'회원등록번호[선수보호자]
								'------------------------------------------------------------------------------------------------------------------------
								'선수정보
								Response.Cookies(valType)("MemberIDX") 	= encode(Rs("MemberIDX"), 0)  		'회원등록번호
								Response.Cookies(valType)("PlayerIDX") 	= encode(Rs("PlayerIDX"), 0)  		'선수번호
								'------------------------------------------------------------------------------------------------------------------------
							End IF
								Rs.Close
							SET Rs = Nothing

						CASE ELSE

							Response.Cookies(valType)("MemberIDX") = encode(TRs("MemberIDX"), 0)  '회원등록번호

							IF TRs("PlayerIDX") <> "" Then Response.Cookies(valType)("PlayerIDX") = encode(TRs("PlayerIDX"), 0) 	'선수번호

					END SELECT

					IF TRs("PlayerReln") <> "" Then Response.Cookies(valType)("PlayerReln") = encode(TRs("PlayerReln"), 0) 	'보호자와 매칭된 선수와의 관계

					Response.Cookies(valType)("SrtDate") = TRs("SrtDate")													'회원가입일[선수보호자]
					Response.Cookies(valType)("EnterType") = TRs("EnterType")  												'선수구분[E:엘리트 | A:아마추어 | K:국가대표]
					Response.Cookies(valType)("PhotoPath") = encode(Server.HTMLEncode(PhotoPath), 0)						'회원프로필 이미지
					Response.Cookies(valType)("UserName") = TRs("UserName")    												'사용자명
					Response.Cookies(valType)("SportsGb") = valType

					ReValue = TRUE
				Else
					ReValue = FALSE
				End IF

					TRs.Close
				SET TRs = Nothing

			'------------------------------------------------------------------------------------------------------------------------
			'배드민턴
			'------------------------------------------------------------------------------------------------------------------------
			CASE "badminton"


		END SELECT

		SET_INFO_COOKIE = ReValue

	END FUNCTION
	'========================================================================================================
	'로그인 로그
	'========================================================================================================
	FUNCTION INFO_LOGINLOG(valID, valName, valSEX)

		TSQL = "		INSERT INTO [SD_Member].[dbo].[tblLoginLog] ("
		TSQL = TSQL & "		UserID"
		TSQL = TSQL & "		,UserName"
		TSQL = TSQL & "		,UserSEX"
		TSQL = TSQL & "		,PROTOCOL"		'프로토콜 버전
		TSQL = TSQL & "		,SOFTWARE"		'웹서버 버전
		TSQL = TSQL & "		,HTTPREFERER"	'이전페이지
		TSQL = TSQL & "		,AGENT"			'브라우저 정보 및 OS정보
		TSQL = TSQL & "		,REMOTEADDR"	'IP
		TSQL = TSQL & "		,WriteDate"
		TSQL = TSQL & " )"
		TSQL = TSQL & " VALUES ("
		TSQL = TSQL & "		'"&valID&"'"
		TSQL = TSQL & "		,'"&valName&"'"
		TSQL = TSQL & "		,'"&valSEX&"'"
		TSQL = TSQL & "		,'"&Request.serverVariables("SERVER_PROTOCOL") & "'"
		TSQL = TSQL & "		,'"&Request.serverVariables("SERVER_SOFTWARE") & "'"
		TSQL = TSQL & "		,'"&Request.Servervariables("HTTP_REFERER") & "'"
		TSQL = TSQL & "		,'"&Request.Servervariables("HTTP_USER_AGENT") & "'"
		TSQL = TSQL & "		,'"&Request.Servervariables("REMOTE_ADDR") & "'"
		TSQL = TSQL & "		,GETDATE()"
		TSQL = TSQL & " )"

		DBCon3.Execute(TSQL)

	END FUNCTION
	'========================================================================================================
	'RandNumber
	'========================================================================================================
	Function random_str()
		str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" '랜덤으로 사용될 문자 또는 숫자

		strlen = 6 '랜덤으로 출력될 값의 자릿수 ex)해당 구문에서 10자리의 랜덤 값 출력

		Randomize '랜덤 초기화

		For i = 1 To strlen '위에 선언된 strlen만큼 랜덤 코드 생성
			r = Int((36 - 1 + 1) * Rnd + 1)  ' 36은 str의 문자갯수
			serialCode = serialCode + Mid(str,r,1)
		Next

		random_str = serialCode

	End Function
	'========================================================================================================
	'랜덤숫자
	'예)2015 - 4자리
	'========================================================================================================
	Function random_Disigt_str()
		Randomize '랜덤 초기화
		'4자리
		bufNum = int(9000 * rnd) + 1000
		random_Disigt_str = bufNum
	End Function
	'========================================================================================================
	'Tag 변환
	'========================================================================================================
	Function ReplaceTagText(str)
		dim txtTag

		IF str <> "" Then
			txtTag = replace(str,  "<", "&lt;")
			txtTag = replace(txtTag, ">", "&gt;")
			txtTag = replace(txtTag, "'", "&apos;")
			txtTag = replace(txtTag, chr(39), "&#39;")
			txtTag = replace(txtTag, chr(34), "&quot;")
			txtTag = replace(txtTag, chr(10), "<br>")

			ReplaceTagText = txtTag
		END IF
	End Function
	'========================================================================================================
	'Tag 복호화
	'========================================================================================================
	Function ReplaceTagReText(str)
		dim txtTag

		IF str <> "" Then
			txtTag = replace(str,  "&lt;", "<")
			txtTag = replace(txtTag, "&gt;", ">")
			txtTag = replace(txtTag, "&apos;", "'")
			txtTag = replace(txtTag, "&#39;", chr(39))
			txtTag = replace(txtTag, "&quot;", chr(34))
			txtTag = replace(txtTag, "<br>", chr(10))
			ReplaceTagReText = txtTag
		END IF
	End Function
	'========================================================================================================
	'Injection
	'========================================================================================================
	Function fInject(argData)
		Dim strCheckArgSQL
		Dim arrSQL
		Dim i

		strCheckArgSQL = LCase(Trim(argData))

		arrSQL = Array("exec ","sp_","xp_","insert ","update ","delete ","drop ","select ","union ","truncate ","script","object ","applet","embed ","iframe ","where ","declare ","sysobject","@variable","1=1","null","carrige return","new line","onload","char(","xmp","javascript","script","iframe","document","vbscript","applet","embed","object","frame","frameset","bgsound","alert","onblur","onchange","onclick","ondblclick","onerror","onfocus","onload","onmouse","onscroll","onsubmit","onunload","ptompt","</div>")

		For i=0 To ubound(arrSQL) Step 1
			If(InStr(strCheckArgSQL,arrSQL(i)) > 0) Then
				Select Case  arrSQL(i)
				Case "'"
						arrSQL(i) ="홑따옴표"
				Case "char("
					arrSQL(i) ="char"
			  End SELECT

				response.write "<SCRIPT LANGUAGE='JavaScript'>"
				response.write "  alert('허용되지 않은 문자열이 있습니다. [" & arrSQL(i) & "]') ; "
				response.write "  history.go(-1);"
				response.write "</SCRIPT>"
				response.end
			End If

			If(InStr(strCheckArgSQL,server.urlencode(arrSQL(i))) > 0) Then
				   Select Case  arrSQL(i)
				   Case "'"
					arrSQL(i) ="홑따옴표"
				   Case "char("
					arrSQL(i) ="char"
				   End SELECT
				response.write "<SCRIPT LANGUAGE='JavaScript'>"
				response.write "  alert('허용되지 않은 문자열이 있습니다. [" & arrSQL(i) & "]') ; "
				response.write "  history.go(-1);"
				response.write "</SCRIPT>"
				response.end
			End If

		Next

		'Xss 필터링
		'argData = Replace(argData,"&","&amp;")
		'argData = Replace(argData,"\","&quot;")
		'argData = Replace(argData,"<","&lt;")
		'argData = Replace(argData,">","&gt;")
		'argData = Replace(argData,"'","&#39;")
		'argData = Replace(argData,"""","&#34;")

		fInject = argData
	End Function
	'========================================================================================================
	' 암호화
	'========================================================================================================
	Function encode(str, chipVal)
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""

		chipVal = CInt(chipVal)
		str = StringToHex(str)

		For i = 0 To Len(str) - 1
			TempChar = Mid(str, i + 1, 1)
			Conv = InStr(Ref, TempChar) - 1
			Cipher = Conv Xor chipVal
			Cipher = Mid(Ref, Cipher + 1, 1)
			Temp = Temp + Cipher
		Next

		encode = Temp

	End Function
	'========================================================================================================
	' 복호화
	'========================================================================================================
	Function decode(str, chipVal)
		Dim Temp, TempChar, Conv, Cipher, i: Temp = ""

		chipVal = CInt(chipVal)

		For i = 0 To Len(str) - 1
		  TempChar = Mid(str, i + 1, 1)
		  Conv = InStr(Ref, TempChar) - 1
		  Cipher = Conv Xor chipVal
		  Cipher = Mid(Ref, Cipher + 1, 1)
		  Temp = Temp + Cipher
		Next

		Temp = HexToString(Temp)
		decode = Temp

	End Function
	'========================================================================================================
	' 문자열 -> 16진수
	'========================================================================================================
	Function StringToHex(pStr)
		Dim i, one_hex, retVal

		IF pStr<>"" Then
			For i = 1 To Len(pStr)
			  one_hex = Hex(Asc(Mid(pStr, i, 1)))
			  retVal = retVal & one_hex
			Next
		End IF

		StringToHex = retVal

	End Function
	'========================================================================================================
	' 16진수 -> 문자열
	'========================================================================================================
	Function HexToString(pHex)
		Dim one_hex, tmp_hex, i, retVal

		For i = 1 To Len(pHex)
		  one_hex = Mid(pHex, i, 1)

		  If IsNumeric(one_hex) Then
				  tmp_hex = Mid(pHex, i, 2)
				  i = i + 1
		  Else
				  tmp_hex = Mid(pHex, i, 4)
				  i = i + 3
		  End If

		  retVal = retVal & Chr("&H" & tmp_hex)

		Next

		HexToString = retVal

	End Function
	'========================================================================================================
	'가입된 회원계정 목록 출력쿼리
	'	valType 함수 사용 페이지 타입
	'	ACCOUNT 	종목메인설정		 ./user_account.asp
	'	ACCOUNTSET 	종목메인설정변경 	./user_account_type.asp
	'	CHECKYES 	가입유무체크 		 ./check_yes_id.asp
	'========================================================================================================
	FUNCTION INFO_QUERY_JOINACCOUNT(valSportsGb, valType)
		dim txt_SQL

		SELECT CASE valType
			CASE "ACCOUNT" 		: txt_SQL = " AND M.SD_GameIDSET = 'Y'"
			CASE "ACCOUNTSET" 	: txt_SQL = ""
		END SELECT

		SELECT CASE valSportsGb
			CASE "judo"
				TSQL = "     	SELECT M.MemberIDX "
				TSQL = TSQL & "   	,M.SD_GameIDSET "
				TSQL = TSQL & " 	,CONVERT(CHAR, CONVERT(DATE, M.SrtDate), 102) SrtDate "
				TSQL = TSQL & "   	,CASE M.EnterType  "
				TSQL = TSQL & "     	WHEN 'E' THEN "
				TSQL = TSQL & "       		CASE M.PlayerReln  "
				TSQL = TSQL & "         		WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
				TSQL = TSQL & "        		 	WHEN 'Z' THEN '엘리트-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
				TSQL = TSQL & "        		 	WHEN 'R' THEN '엘리트-선수('+[SportsDiary].[dbo].[FN_TeamNm]('"&valSportsGb&"','', M.Team)+')'"
				TSQL = TSQL & "         		WHEN 'K' THEN '엘리트-비등록선수' "
				TSQL = TSQL & "         		WHEN 'S' THEN '엘리트-예비후보' "
				TSQL = TSQL & "         		WHEN 'T' THEN '엘리트-지도자('+ISNULL([SportsDiary].[dbo].[FN_PubName]('sd03900' + M.LeaderType),'')+')'+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')"
				TSQL = TSQL & "         		WHEN 'D' THEN '일반' "
				TSQL = TSQL & "       			END "
				TSQL = TSQL & "     	WHEN 'A' THEN "
				TSQL = TSQL & "       		CASE M.PlayerReln "
				TSQL = TSQL & "         		WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'Z' THEN '생활체육-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'R' THEN '생활체육-선수('+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')+')' "
				TSQL = TSQL & "         		WHEN 'T' THEN '생활체육-지도자('+ISNULL([SportsDiary].[dbo].[FN_PubName]('sd03900' + M.LeaderType),'')+')'+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')"
				TSQL = TSQL & "         		WHEN 'D' THEN '일반' "
				TSQL = TSQL & "       			END "
				TSQL = TSQL & "    		WHEN 'K' THEN "
				TSQL = TSQL & "       		CASE M.PlayerReln "
				TSQL = TSQL & "         		WHEN 'R' THEN '국가대표-선수('+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')+')'"
				TSQL = TSQL & "         		WHEN 'T' THEN '국가대표-지도자('+ISNULL([SportsDiary].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+'-'+ISNULL([SportsDiary].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')+')'"
				TSQL = TSQL & "       		END "
				TSQL = TSQL & "   		END PlayerRelnNm "
				TSQL = TSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
				TSQL = TSQL & "   	left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = '"&valSportsGb&"' AND P.DelYN = 'N' "
				TSQL = TSQL & " WHERE M.DelYN = 'N' "
				TSQL = TSQL & "   	AND M.SportsType = '"&valSportsGb&"' "
				TSQL = TSQL & "   	AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
				TSQL = TSQL &		txt_SQL
				TSQL = TSQL & " ORDER BY M.EnterType "
				TSQL = TSQL & "   	,M.PlayerReln "

			CASE "tennis"
				TSQL = "     	SELECT M.MemberIDX"
				TSQL = TSQL & "   	,M.SD_GameIDSET"
				TSQL = TSQL & "   	,CONVERT(CHAR, CONVERT(DATE, M.SrtDate), 102) SrtDate "
				TSQL = TSQL & "   	,CASE M.EnterType  "
				TSQL = TSQL & "     	WHEN 'E' THEN "
				TSQL = TSQL & "     		CASE M.PlayerReln "
				TSQL = TSQL & "       			WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
				TSQL = TSQL & "       			WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
				TSQL = TSQL & "       			WHEN 'Z' THEN '엘리트-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
				TSQL = TSQL & "       			WHEN 'T' THEN '엘리트-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+')'+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')"
				TSQL = TSQL & "       			WHEN 'D' THEN '일반' "
				TSQL = TSQL & "       			WHEN 'R' THEN "
				TSQL = TSQL & "           			CASE WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team2) IS NULL THEN '<span class=""affiliation"">엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')+')</span>'"
				TSQL = TSQL & "             			ELSE '<span class=""affiliation"">엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')+' / '+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team2),'')+')</span>'"
				TSQL = TSQL & "             			END"
				TSQL = TSQL & "             	END"
				TSQL = TSQL & "     	WHEN 'A' THEN "
				TSQL = TSQL & "     		CASE M.PlayerReln "
				TSQL = TSQL & "       			WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
				TSQL = TSQL & "       			WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
				TSQL = TSQL & "       			WHEN 'Z' THEN '생활체육-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
				TSQL = TSQL & "       			WHEN 'T' THEN '생활체육-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+')'+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')"
				TSQL = TSQL & "       			WHEN 'D' THEN '일반' "
				TSQL = TSQL & "       			WHEN 'R' THEN "
				TSQL = TSQL & "           			CASE WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team2) IS NULL THEN '<span class=""affiliation"">생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')+')</span>'"
				TSQL = TSQL & "             			ELSE '<span class=""affiliation"">생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team),'')+' / '+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valSportsGb&"', M.Team2),'')+')</span>'"
				TSQL = TSQL & "             			END"
				TSQL = TSQL & "             	END"
				TSQL = TSQL & "       	END PlayerRelnNm "
				TSQL = TSQL & " FROM [SD_Tennis].[dbo].[tblMember] M"
				TSQL = TSQL & "     left join [SD_Tennis].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = '"&valSportsGb&"' AND P.DelYN = 'N' "
				TSQL = TSQL & " WHERE M.DelYN = 'N' "
				TSQL = TSQL & "     AND M.SportsType = '"&valSportsGb&"' "
				TSQL = TSQL & "     AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
				TSQL = TSQL &		txt_SQL
				TSQL = TSQL & " ORDER BY M.EnterType "
				TSQL = TSQL & "     ,M.PlayerReln "

			CASE "bike"
				TSQL = "     	SELECT M.MemberIDX"
				TSQL = TSQL & "   	,M.SD_GameIDSET"
				TSQL = TSQL & "   	,CONVERT(CHAR, CONVERT(DATE, M.SrtDate), 102) SrtDate "
				TSQL = TSQL & "   	,CASE M.EnterType  "
				TSQL = TSQL & "     	WHEN 'E' THEN "
				TSQL = TSQL & "       		CASE M.PlayerReln  "
				TSQL = TSQL & "         		WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'Z' THEN '엘리트-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'R' THEN "
				TSQL = TSQL & "   					CASE WHEN [SD_Bike].[dbo].[FN_TeamNm]('"&valSportsGb&"', M.Team) <> '' THEN '엘리트-선수('+[SD_Bike].[dbo].[FN_TeamNm]('"&valSportsGb&"', M.Team)+')' "
				TSQL = TSQL & "							ELSE '엘리트-선수' "
				TSQL = TSQL & "							END"
				TSQL = TSQL & "       			END "
				TSQL = TSQL & "     	WHEN 'A' THEN "
				TSQL = TSQL & "       		CASE M.PlayerReln "
				TSQL = TSQL & "         		WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'Z' THEN '생활체육-보호자('+M.PlayerRelnMemo+'-'+P.UserName+')'"
				TSQL = TSQL & "         		WHEN 'R' THEN "
				TSQL = TSQL & " 					CASE WHEN [SD_Bike].[dbo].[FN_TeamNm]('"&valSportsGb&"', M.Team) <> '' THEN '생활체육-선수('+[SD_Bike].[dbo].[FN_TeamNm]('"&valSportsGb&"', M.Team)+')' "
				TSQL = TSQL & "							ELSE '생활체육-선수' "
				TSQL = TSQL & "							END"
				TSQL = TSQL & "       			END "
				TSQL = TSQL & "   		END PlayerRelnNm "
				TSQL = TSQL & " FROM [SD_Bike].[dbo].[tblMember] M"
				TSQL = TSQL & "   	left join [SD_Bike].[dbo].[sd_bikePlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = '"&valSportsGb&"' AND P.DelYN = 'N' "
				TSQL = TSQL & " WHERE M.DelYN = 'N' "
				TSQL = TSQL & "   	AND M.SportsType = '"&valSportsGb&"' "
				TSQL = TSQL & "   	AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
				TSQL = TSQL &		txt_SQL
				TSQL = TSQL & " ORDER BY M.EnterType "
				TSQL = TSQL & "   	,M.PlayerReln "


			CASE "badminton"
		END SELECT

		INFO_QUERY_JOINACCOUNT = TSQL

	END FUNCTION
	'========================================================================================================
	'종목별 가입계정 카운트 반환
	'========================================================================================================
	FUNCTION CHK_COUNT_SPORTSGB_JOINUS(valSportsGb)
   		SELECT CASE valSportsGb
   			CASE "judo"
   				TSQL = " 		SELECT ISNULL(COUNT(*), 0) cnt"
				TSQL = TSQL & " FROM [Sportsdiary].[dbo].[tblMember] "
				TSQL = TSQL & " WHERE DelYN = 'N' "
				TSQL = TSQL & " 	AND SportsType = '"&valSportsGb&"' "
				TSQL = TSQL & "		AND SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
   				SET TRs = DBCon.Execute(TSQL)

   			CASE "tennis"
				TSQL = " 		SELECT ISNULL(COUNT(*), 0) cnt"
				TSQL = TSQL & " FROM [SD_Tennis].[dbo].[tblMember] "
				TSQL = TSQL & " WHERE DelYN = 'N' "
				TSQL = TSQL & " 	AND SportsType = '"&valSportsGb&"' "
				TSQL = TSQL & "		AND SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
   				SET TRs = DBCon3.Execute(TSQL)

   			CASE "bike"
				TSQL = " 		SELECT ISNULL(COUNT(*), 0) cnt"
				TSQL = TSQL & " FROM [SD_Bike].[dbo].[tblMember] "
				TSQL = TSQL & " WHERE DelYN = 'N' "
				TSQL = TSQL & " 	AND SportsType = '"&valSportsGb&"' "
				TSQL = TSQL & "		AND SD_UserID = '"&request.Cookies("SD")("UserID")&"' "
   				SET TRs = DBCon3.Execute(TSQL)
   		END SELECT

		CHK_COUNT_SPORTSGB_JOINUS = TRs(0)

			TRs.Close
		SET TRs = Nothing

   	END FUNCTION
   	'========================================================================================================
	'종목 국문 반환
	'========================================================================================================
	FUNCTION ReplaceSportsGbText(valSportsGb)
		dim txt_SubjectGb

		SELECT CASE valSportsGb
   			CASE "judo" 		: txt_SubjectGb = "유도"
   			CASE "tennis" 		: txt_SubjectGb = "테니스"
   			CASE "bike"	 		: txt_SubjectGb = "자전거"
   			CASE "badminton" 	: txt_SubjectGb = "배드민턴"
   		END SELECT

		ReplaceSportsGbText = txt_SubjectGb

	END FUNCTION
	'========================================================================================================
	'통합 로그아웃 처리페이지
	'========================================================================================================
	FUNCTION SET_COOKIES_LOGOUT()
   		dim txt_SDType, i

   		IF LIST_SPORTSTYPE <> "" Then

			txt_SDType = Split(LIST_SPORTSTYPE, "|")

			'쿠키 삭제 처리
			With response
				.Expires = -1

				FOR i = 1 To Ubound(txt_SDType)
   					IF txt_SDType(i) <> "" Then
						.Cookies(txt_SDType(i)).Domain = ".sportsdiary.co.kr"
						.Cookies(txt_SDType(i)).path = "/"
						.Cookies(txt_SDType(i))	= ""
					End IF
				NEXT

			End With

			SET_COOKIES_LOGOUT = "TRUE"

		Else
			SET_COOKIES_LOGOUT = "FALSE"
		End IF

   	END FUNCTION
	'========================================================================================================
	'Server.URLEncode --> URLDecode
	'========================================================================================================
	FUNCTION URLDecode(sText)
		dim sDecoded : sDecoded = sText
		dim oRegExpr, oMatchCollection

		SET oRegExpr = Server.CreateObject("VBScript.RegExp")
			oRegExpr.Pattern = "%[0-9,A-F]{2}"
			oRegExpr.Global = True

		SET oMatchCollection = oRegExpr.Execute(sText)

		For Each oMatch In oMatchCollection
			sDecoded = Replace(sDecoded,oMatch.value,Chr(CInt("&H" & Right(oMatch.Value,2))))
		Next

		URLDecode = sDecoded

	END FUNCTION
	'========================================================================================================
    '비밀번호가 임시 비밀번호인지 체크 후 임시비밀번호인 경우 비밀번호 변경페이지로 이동시킵니다.
    '/include/gnbType/player_gnb.asp
    '========================================================================================================
    FUNCTION CHK_USERPASS_TYPE()

        IF decode(request.cookies("SD")("UserPassGb"), 0) = "Y" Then
            response.write "<script>"
            response.write "    alert('임시발급된 비밀번호로 로그인하였습니다. 비밀번호를 변경하여야합니다.\n비밀번호 변경페이지로 이동합니다.');"
            response.write "    $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/pwd_change.asp');"
            response.write "</script>"
            response.end
        End IF
    END FUNCTION
    '========================================================================================================

  FUNCTION IPHONEYN()	'아이폰여부체크  by 백 190809 수정
		Dim M_AGENT
		M_AGENT = LCase(Request.ServerVariables("HTTP_USER_AGENT"))
		If InStr(M_AGENT,"ipad") > 0 or InStr(m_agent,"iphone") > 0 Or InStr(M_AGENT, "ipod") > 0 Then
			IPHONEYN = "1"
		Else
			IPHONEYN = "1"
		End if

		'	If(Len(Request.ServerVariables("HTTP_USER_AGENT"))=0) Then
		'		strAgent = "NONE"
		'	Else
		'		strAgent = Request.ServerVariables("HTTP_USER_AGENT")
		'	End if
		'	mobile = Array("iPhone", "ipad", "ipod")
		'	imb = 0
		'	For Each n In mobile
		'		If (InStr(LCase(strAgent), LCase(n)) > 0) Then
		'			imb = imb + 1
		'		End If
		'	Next
		'	IPHONEYN = imb
    END FUNCTION

  M_conKey = "w암호화 비밀키" ' 암호화 비밀키
	'M_conIV = Replace(USER_IP,".","") & "초기화 백터" '초기화 벡터 (결제중 아이피가 변경되면 오류발생가능성 )
	'M_conIV = Replace(date,"-","") & "초기화 백터" '초기화 벡터 (자정문제발생)
	M_conIV = year(date) & "초기화 백터" '초기화 벡터 (자정문제발생)

  Function mallEncode(ByVal word, ByVal zero)

		'If chkBlank(word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 	objEncrypter.Key = M_conKey
		objEncrypter.IV = M_conIV

		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"

		' 문자열 암호화
		mallEncode =objEncrypter.Encrypt(word)
		Set objEncrypter = Nothing
	End Function

  iLIMemberIDXG = decode(Request.Cookies("SD")("MemberIDX"),0)

  SportsGb = "sdmain"

%>
