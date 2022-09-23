<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'메인페이지 대회정보 리스트 조회페이지
	'===========================================================================================
'	Check_Login()

	'## 접속 사용자 아이피
	USER_IP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	If Len(USER_IP) = 0 Then USER_IP = Request.ServerVariables("REMOTE_ADDR")


	dim NDate	 	: NDate 	= Date()
	dim NYear 		: NYear 	= Year(Date())
	dim Chk_Game 	: Chk_Game 	= FALSE			'대회시작일 및 진행중정보 체크
	dim ViewCnt 	: ViewCnt 	= 3

	dim SearchDate								'institute-search.asp 조회월 파라미터값
	dim txtContents
	dim Chk_Num, cnt

'If USER_IP = "118.33.86.240" Then

	LSQL = "select top "&ViewCnt&" * from ( "

	LSQL = LSQL & "  	    SELECT   " ''K' as sitegubun
	LSQL = LSQL & "   	GameTitleIDX "
	LSQL = LSQL & "   	,P.hostTitle "
	LSQL = LSQL & "   	,GameTitleName "
	LSQL = LSQL & "   	,GameArea "
	LSQL = LSQL & "   	,CONVERT(CHAR(10), GameS, 121) GameS "
	LSQL = LSQL & "   	,CONVERT(CHAR(10), GameE, 121) GameE "
	LSQL = LSQL & "   	,CASE "
	LSQL = LSQL & "    	 	WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 and DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0 THEN '0' "
	LSQL = LSQL & "   	Else '1' "
	LSQL = LSQL & "  	END StateGame " 									'대회기간 0
	LSQL = LSQL & "   	,DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"') StartOnDate" 		'대회전 일수 (카운트다운)
   	LSQL = LSQL & "   	,CASE " 			'대회전 일수 형식 출력
   	LSQL = LSQL & "   		WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 THEN "
   	LSQL = LSQL & "				CASE WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0 THEN '진행중' ELSE '종료' END "
	LSQL = LSQL & "		ELSE 'D' + CONVERT(CHAR(10), DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"'))"
   	LSQL = LSQL & "		END StartOnDateType"								'대회카운트다운 상태값 노출
	LSQL = LSQL & "   	,GameRcvDateS "
	LSQL = LSQL & "   	,GameRcvDateE "
	LSQL = LSQL & "   	,CASE "
	LSQL = LSQL & "			WHEN DATEDIFF(d, CONVERT(DATE, GameRcvDateS), '"&NDate&"')>=0 AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameRcvDateE))>=0 THEN 'Y' "
	LSQL = LSQL & "   	ELSE 'N' "
	LSQL = LSQL & "   	END RcvOnDate " 									'참가신청 기간이면 Y
	LSQL = LSQL & "   	,T.titleGrade "
	LSQL = LSQL & "   	,T.titleCode "
	LSQL = LSQL & "   	,T.ViewYN "     									'참가신청 [Y:노출 | N:비노출]
   	LSQL = LSQL & "   	,'K' as entertype " 'T.EnterType
	LSQL = LSQL & " FROM [SD_Tennis].[dbo].[sd_TennisTitle] T "
	LSQL = LSQL & "   	left join [SD_Tennis].[dbo].[sd_TennisTitleCode] P on  T.titleGrade = P.titleGrade "
	LSQL = LSQL & "     	AND P.titleCode = T.titleCode "
	LSQL = LSQL & "     	AND P.DelYN = 'N' "
	LSQL = LSQL & " WHERE T.DelYN = 'N' "
	LSQL = LSQL & "		AND T.SportsGb = 'tennis' "
	LSQL = LSQL & "   	AND GameYear = '"&NYear&"' "
	LSQL = LSQL & "   	AND ViewState = 'Y'"  								'대회정보 달력에 노출 Y
 	LSQL = LSQL & "		AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0"				'대회종료 데이터 제외

	'LSQL = LSQL & "	ORDER BY StateGame, GameS, RcvOnDate DESC, GameRcvDateS, StartOnDate DESC"	'대회일정 기간 정렬 우선

	LSQL = LSQL & "	union "

	LSQL = LSQL & "    	SELECT    " ''S'  as sitegubun
	LSQL = LSQL & "   	GameTitleIDX "
	LSQL = LSQL & "   	,P.hostTitle "
	LSQL = LSQL & "   	,GameTitleName "
	LSQL = LSQL & "   	,GameArea "
	LSQL = LSQL & "   	,CONVERT(CHAR(10), GameS, 121) GameS "
	LSQL = LSQL & "   	,CONVERT(CHAR(10), GameE, 121) GameE "
	LSQL = LSQL & "   	,CASE "
	LSQL = LSQL & "    	 	WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 and DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0 THEN '0' "
	LSQL = LSQL & "   	Else '1' "
	LSQL = LSQL & "  	END StateGame " 									'대회기간 0
	LSQL = LSQL & "   	,DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"') StartOnDate" 		'대회전 일수 (카운트다운)
   	LSQL = LSQL & "   	,CASE " 			'대회전 일수 형식 출력
   	LSQL = LSQL & "   		WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 THEN "
   	LSQL = LSQL & "				CASE WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0 THEN '진행중' ELSE '종료' END "
	LSQL = LSQL & "		ELSE 'D' + CONVERT(CHAR(10), DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"'))"
   	LSQL = LSQL & "		END StartOnDateType"								'대회카운트다운 상태값 노출
	LSQL = LSQL & "   	,GameRcvDateS "
	LSQL = LSQL & "   	,GameRcvDateE "
	LSQL = LSQL & "   	,CASE "
	LSQL = LSQL & "			WHEN DATEDIFF(d, CONVERT(DATE, GameRcvDateS), '"&NDate&"')>=0 AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameRcvDateE))>=0 THEN 'Y' "
	LSQL = LSQL & "   	ELSE 'N' "
	LSQL = LSQL & "   	END RcvOnDate " 									'참가신청 기간이면 Y
	LSQL = LSQL & "   	,T.titleGrade "
	LSQL = LSQL & "   	,T.titleCode "
	LSQL = LSQL & "   	,T.ViewYN "     									'참가신청 [Y:노출 | N:비노출]
   	LSQL = LSQL & "   	,'S' as entertype " 'T.EnterType
	LSQL = LSQL & " FROM [SD_RookieTennis].[dbo].[sd_TennisTitle] T "
	LSQL = LSQL & "   	left join [SD_RookieTennis].[dbo].[sd_TennisTitleCode] P on  T.titleGrade = P.titleGrade "
	LSQL = LSQL & "     	AND P.titleCode = T.titleCode "
	LSQL = LSQL & "     	AND P.DelYN = 'N' "
	LSQL = LSQL & " WHERE T.DelYN = 'N' "
	LSQL = LSQL & "		AND T.SportsGb = 'tennis' "
	LSQL = LSQL & "   	AND GameYear = '"&NYear&"' "
	LSQL = LSQL & "   	AND ViewState = 'Y'"  								'대회정보 달력에 노출 Y
 	LSQL = LSQL & "		AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0"				'대회종료 데이터 제외

 	LSQL = LSQL & "		) as unionResult ORDER BY StateGame, GameS, RcvOnDate DESC, GameRcvDateS, StartOnDate DESC "

	'LSQL = LSQL & "	ORDER BY StateGame, GameS, RcvOnDate DESC, GameRcvDateS, StartOnDate DESC"	'대회일정 기간 정렬 우선

'Else

'	LSQL = "    	  SELECT TOP " &ViewCnt
'	LSQL = LSQL & "   	GameTitleIDX "
'	LSQL = LSQL & "   	,P.hostTitle "
'	LSQL = LSQL & "   	,GameTitleName "
'	LSQL = LSQL & "   	,GameArea "
'	LSQL = LSQL & "   	,CONVERT(CHAR(10), GameS, 121) GameS "
'	LSQL = LSQL & "   	,CONVERT(CHAR(10), GameE, 121) GameE "
'	LSQL = LSQL & "   	,CASE "
'	LSQL = LSQL & "    	 	WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 and DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0 THEN '0' "
'	LSQL = LSQL & "   	Else '1' "
'	LSQL = LSQL & "  	END StateGame " 									'대회기간 0
'	LSQL = LSQL & "   	,DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"') StartOnDate" 		'대회전 일수 (카운트다운)
'   	LSQL = LSQL & "   	,CASE " 			'대회전 일수 형식 출력
'   	LSQL = LSQL & "   		WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 THEN "
'   	LSQL = LSQL & "				CASE WHEN DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"')>=0 AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0 THEN '진행중' ELSE '종료' END "
'	LSQL = LSQL & "		ELSE 'D' + CONVERT(CHAR(10), DATEDIFF(d, CONVERT(DATE, GameS), '"&NDate&"'))"
'   	LSQL = LSQL & "		END StartOnDateType"								'대회카운트다운 상태값 노출
'	LSQL = LSQL & "   	,GameRcvDateS "
'	LSQL = LSQL & "   	,GameRcvDateE "
'	LSQL = LSQL & "   	,CASE "
'	LSQL = LSQL & "			WHEN DATEDIFF(d, CONVERT(DATE, GameRcvDateS), '"&NDate&"')>=0 AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameRcvDateE))>=0 THEN 'Y' "
'	LSQL = LSQL & "   	ELSE 'N' "
'	LSQL = LSQL & "   	END RcvOnDate " 									'참가신청 기간이면 Y
'	LSQL = LSQL & "   	,T.titleGrade "
'	LSQL = LSQL & "   	,T.titleCode "
'	LSQL = LSQL & "   	,T.ViewYN "     									'참가신청 [Y:노출 | N:비노출]
'   	LSQL = LSQL & "   	,'K' as entertype " 'T.EnterType
'	LSQL = LSQL & " FROM [SD_Tennis].[dbo].[sd_TennisTitle] T "
'	LSQL = LSQL & "   	left join [SD_Tennis].[dbo].[sd_TennisTitleCode] P on  T.titleGrade = P.titleGrade "
'	LSQL = LSQL & "     	AND P.titleCode = T.titleCode "
'	LSQL = LSQL & "     	AND P.DelYN = 'N' "
'	LSQL = LSQL & " WHERE T.DelYN = 'N' "
'	LSQL = LSQL & "		AND T.SportsGb = 'tennis' "
'	LSQL = LSQL & "   	AND GameYear = '"&NYear&"' "
'	LSQL = LSQL & "   	AND ViewState = 'Y'"  								'대회정보 달력에 노출 Y
' 	LSQL = LSQL & "		AND DATEDIFF(d, '"&NDate&"', CONVERT(DATE, GameE))>=0"				'대회종료 데이터 제외
'	LSQL = LSQL & "	ORDER BY StateGame, GameS, RcvOnDate DESC, GameRcvDateS, StartOnDate DESC"	'대회일정 기간 정렬 우선

'End if




	SET LRs = DBCon3.Execute(LSQL)
	If	Not (LRs.Eof Or LRs.Bof) Then
		'공식대회가 있을경우
		Do Until LRs.Eof



			txtContents = txtContents & "<li class='m_list__item'>"
	   		txtContents = txtContents & "<a href='javascript:;' onClick=""info_GameTitle('"&LRs("GameTitleIDX")&"', '"&LRs("GameTitleName")&"', '"&LRs("EnterType")&"');"" class='m_list__link'>"
			txtContents = txtContents & "<span class=""m_list__status"">"&LRs("StartOnDateType")&"</span>"
			If LRs("entertype") = "K" then
				txtContents = txtContents & "<span>["&findGrade(LRs("titleGrade"))&"그룹] "&LRs("GameTitleName") &" 대회"
			Else
				txtContents = txtContents & "<span>[SD] "&LRs("GameTitleName") &" 대회"
			End if

			txtContents = txtContents & "</a>"
			txtContents = txtContents & "</li>"

			LRs.MoveNext
		Loop

	Else
		'공식대회가 없을경우

		txtContents = txtContents & "<li class='m_list__item'><a href='#' class=""m_list__link""><span>등록된 대회일정이 없습니다.</span></a></li>"

	End If
		LRs.Close
	SET LRs = Nothing

	response.Write txtContents


	DBClose3()
%>
