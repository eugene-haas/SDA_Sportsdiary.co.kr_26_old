<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()

	dim BlockPage  	 	: BlockPage 	= 5	'페이지
	dim B_PSize   		: B_PSize 		= 10	'페이지내 보여지는 목록카운트

	dim currPage   		: currPage  	= fInject(Request("currPage"))
	dim SDate   		: SDate 		= fInject(Request("SDate"))
	dim EDate   		: EDate 		= fInject(Request("EDate"))
	dim fnd_user		: fnd_user 		= fInject(Request("fnd_user"))
	dim search_date 	: search_date 	= fInject(Request("search_date"))

	'dim MemberIDX		: MemberIDX 	= decode(request.Cookies("MemberIDX"), 0)
	'선수 보호자 회원의 경우 MemberIDX 쿠키 교체되었기 때문에 선수보호자 MemberIDX로 교체
	SELECT CASE decode(request.Cookies("PlayerReln"), 0)
		CASE "A","B","Z" 	: MemberIDX = decode(request.Cookies("P_MemberIDX"),0)
		CASE ELSE			: MemberIDX = decode(request.Cookies("MemberIDX"),0)
	END SELECT

	dim Team			: Team 			= decode(request.Cookies("Team"), 0)

	dim TotCount, TotPage
	dim CSQL, CRs
	dim CSearch, CSearch2


	IF Len(currPage) = 0 Then currPage = 1

	'기간선택
	IF SDate <> "" and EDate <> "" Then
		CSearch = " And DateDiff(d, '"&SDate&"', N.WriteDate)>=0 And DateDiff(d, N.WriteDate, '"&EDate&"')>=0 "
	ElseIF SDate <> "" and EDate = "" Then
		CSearch = " And DateDiff(d, '"&SDate&"', N.WriteDate)=0 "
	ElseIF SDate = "" and EDate <> "" Then
		CSearch = " And DateDiff(d, N.WriteDate, '"&EDate&"')=0 "
	Else
	End IF

	'작성자 조회
	IF fnd_user <> "" Then CSearch2 = " And N.UserName Like '%"&fnd_user&"%' "

	CSQL = 	" 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") "
	CSQL = CSQL & " FROM (	"
	CSQL = CSQL & "		SELECT TOP 3 "
	CSQL = CSQL & "		 	N.UserName "
	CSQL = CSQL & "			,N.WriteDate "
	CSQL = CSQL & "			,N.ViewCnt "
	CSQL = CSQL & "			,N.Title "
	CSQL = CSQL & "			,N.NtcIDX "
	CSQL = CSQL & "			,N.Notice "
	CSQL = CSQL & "			,SportsDiary.dbo.FN_PubName('sd03900' + M.LeaderType) LeaderType "
	CSQL = CSQL & "			,1 al "
	CSQL = CSQL & "	 	FROM [Sportsdiary].[dbo].[tblSvcNotice] N "
	CSQL = CSQL & "			left join [Sportsdiary].[dbo].[tblMember] M on M.UserID = N.UserID "
	CSQL = CSQL & "				AND M.DelYN = 'N' "
	CSQL = CSQL & "	 	WHERE N.DelYN = 'N' "
	CSQL = CSQL & "			AND BRPubCode = 'BR02' "
	CSQL = CSQL & "			AND N.Team = '"&Team&"' "
	CSQL = CSQL & "			AND N.Notice = 'Y' "
	CSQL = CSQL & "			AND N.ViewTp = 'T' "&CSearch&CSearch2
	CSQL = CSQL & "			AND N.NtcIDX in( "
	CSQL = CSQL & "				SELECT NtcIDX "
	CSQL = CSQL & "				FROM [Sportsdiary].[dbo].[tblSvcNoticeSub] "
	CSQL = CSQL & "				WHERE MemberIDX = '"&MemberIDX&"' "
	CSQL = CSQL & "					AND DelYN = 'N' "
	CSQL = CSQL & "				) "
	CSQL = CSQL & "		UNION ALL "
	CSQL = CSQL & "		SELECT "
	CSQL = CSQL & "			 N.UserName "
	CSQL = CSQL & "			,N.WriteDate "
	CSQL = CSQL & "			,N.ViewCnt "
	CSQL = CSQL & "			,N.Title "
	CSQL = CSQL & "			,N.NtcIDX "
	CSQL = CSQL & "			,N.Notice "
	CSQL = CSQL & "			,SportsDiary.dbo.FN_PubName('sd03900' + M.LeaderType) LeaderType"
	CSQL = CSQL & "			,2 al "
	CSQL = CSQL & "	 	FROM [Sportsdiary].[dbo].[tblSvcNotice] N "
	CSQL = CSQL & "			left join [Sportsdiary].[dbo].[tblMember] M on M.UserID = N.UserID "
	CSQL = CSQL & "				AND M.DelYN = 'N' "
	CSQL = CSQL & "	 	WHERE N.DelYN = 'N' "
	CSQL = CSQL & "			AND BRPubCode = 'BR02' "
	CSQL = CSQL & "			AND N.Team = '"&Team&"' "
	CSQL = CSQL & "			AND N.ViewTp = 'T' "&CSearch&CSearch2
	CSQL = CSQL & "			AND N.NtcIDX in( "
	CSQL = CSQL & "				SELECT NtcIDX "
	CSQL = CSQL & "				FROM [Sportsdiary].[dbo].[tblSvcNoticeSub] "
	CSQL = CSQL & "				WHERE MemberIDX = '"&MemberIDX&"' "
	CSQL = CSQL & "					AND DelYN = 'N' "
	CSQL = CSQL & "				) "
	CSQL = CSQL & "			AND N.NtcIDX NOT IN( "
	CSQL = CSQL & "				SELECT TOP 3 NtcIDX "
	CSQL = CSQL & "				FROM [Sportsdiary].[dbo].[tblSvcNotice] "
	CSQL = CSQL & "				WHERE N.DelYN = 'N' "
	CSQL = CSQL & "					AND BRPubCode = 'BR02' "
	CSQL = CSQL & "					AND N.Team = '"&Team&"' "
	CSQL = CSQL & "					AND N.Notice = 'Y' "
	CSQL = CSQL & "					AND ViewTp = 'T' "&CSearch&CSearch2
	CSQL = CSQL & "					AND NtcIDX in( "
	CSQL = CSQL & "						SELECT NtcIDX "
	CSQL = CSQL & "						FROM [Sportsdiary].[dbo].[tblSvcNoticeSub] "
	CSQL = CSQL & "						WHERE MemberIDX = '"&MemberIDX&"' "
	CSQL = CSQL & "							AND DelYN = 'N' "
	CSQL = CSQL & "						) "
	CSQL = CSQL & "				) "
	CSQL = CSQL & "	) A	"

'	response.Write CSQL

	SET CRs = Dbcon.Execute(CSQL)
		TotalCount = CRs(0)
		TotalPage = CRs(1)

	'BRPubCode[BR01전체공지 | BR02선수용 | BR03부모용 | BR04팀매니저용]
	'ViewTp[열람구분A:전체,T:선수소속팀]
	CSQL = "SELECT TOP "&currPage * B_PSize
	CSQL = CSQL & "	 	A.UserName UserName "
	CSQL = CSQL & "		,A.WriteDate WriteDate "
	CSQL = CSQL & "		,A.ViewCnt ViewCnt "
	CSQL = CSQL & "		,A.Title Title "
	CSQL = CSQL & "		,A.NtcIDX NtcIDX "
	CSQL = CSQL & "		,A.Notice Notice "
	CSQL = CSQL & "		,A.LeaderType LeaderType "
	CSQL = CSQL & "FROM (	"
	CSQL = CSQL & "		SELECT TOP 3 "
	CSQL = CSQL & "		 	N.UserName "
	CSQL = CSQL & "			,N.WriteDate "
	CSQL = CSQL & "			,N.ViewCnt "
	CSQL = CSQL & "			,N.Title "
	CSQL = CSQL & "			,N.NtcIDX "
	CSQL = CSQL & "			,N.Notice "
	CSQL = CSQL & "			,SportsDiary.dbo.FN_PubName('sd03900' + M.LeaderType) LeaderType "
	CSQL = CSQL & "			,1 al "
	CSQL = CSQL & "	 	FROM [Sportsdiary].[dbo].[tblSvcNotice] N "
	CSQL = CSQL & "			left join [Sportsdiary].[dbo].[tblMember] M on M.UserID = N.UserID "
	CSQL = CSQL & "				AND M.DelYN = 'N' "
	CSQL = CSQL & "	 	WHERE N.DelYN = 'N' "
	CSQL = CSQL & "			AND BRPubCode = 'BR02' "
	CSQL = CSQL & "			AND N.Team = '"&Team&"' "
	CSQL = CSQL & "			AND N.Notice = 'Y' "
	CSQL = CSQL & "			AND ViewTp = 'T' "&CSearch&CSearch2
	CSQL = CSQL & "			AND NtcIDX in( "
	CSQL = CSQL & "				SELECT NtcIDX "
	CSQL = CSQL & "				FROM [Sportsdiary].[dbo].[tblSvcNoticeSub] "
	CSQL = CSQL & "				WHERE MemberIDX = '"&MemberIDX&"' "
	CSQL = CSQL & "					AND DelYN = 'N' "
	CSQL = CSQL & "			) "
	CSQL = CSQL & "		UNION ALL "
	CSQL = CSQL & "		SELECT "
	CSQL = CSQL & "			 N.UserName "
	CSQL = CSQL & "			,N.WriteDate "
	CSQL = CSQL & "			,N.ViewCnt "
	CSQL = CSQL & "			,N.Title "
	CSQL = CSQL & "			,N.NtcIDX "
	CSQL = CSQL & "			,N.Notice "
	CSQL = CSQL & "			,SportsDiary.dbo.FN_PubName('sd03900' + M.LeaderType) LeaderType"
	CSQL = CSQL & "			,2 al "
	CSQL = CSQL & "	 	FROM [Sportsdiary].[dbo].[tblSvcNotice] N "
	CSQL = CSQL & "			left join [Sportsdiary].[dbo].[tblMember] M on M.UserID = N.UserID "
	CSQL = CSQL & "				AND M.DelYN = 'N' "
	CSQL = CSQL & "	 	WHERE N.DelYN = 'N' "
	CSQL = CSQL & "			AND BRPubCode = 'BR02' "
	CSQL = CSQL & "			AND N.Team = '"&Team&"' "
	CSQL = CSQL & "			AND ViewTp = 'T' "&CSearch&CSearch2
	CSQL = CSQL & "			AND NtcIDX in( "
	CSQL = CSQL & "				SELECT NtcIDX "
	CSQL = CSQL & "				FROM [Sportsdiary].[dbo].[tblSvcNoticeSub] "
	CSQL = CSQL & "				WHERE MemberIDX = '"&MemberIDX&"' "
	CSQL = CSQL & "					AND DelYN = 'N' "
	CSQL = CSQL & "			) "
	CSQL = CSQL & "			AND NtcIDX NOT IN( "
	CSQL = CSQL & "				SELECT TOP 3 NtcIDX "
	CSQL = CSQL & "				FROM [Sportsdiary].[dbo].[tblSvcNotice] "
	CSQL = CSQL & "				WHERE N.DelYN = 'N' "
	CSQL = CSQL & "					AND BRPubCode = 'BR02' "
	CSQL = CSQL & "					AND N.Team = '"&Team&"' "
	CSQL = CSQL & "					AND N.Notice = 'Y' "
	CSQL = CSQL & "					AND ViewTp = 'T' "&CSearch&CSearch2
	CSQL = CSQL & "					AND NtcIDX in( "
	CSQL = CSQL & "						SELECT NtcIDX "
	CSQL = CSQL & "						FROM [Sportsdiary].[dbo].[tblSvcNoticeSub] "
	CSQL = CSQL & "						WHERE MemberIDX = '"&MemberIDX&"' "
	CSQL = CSQL & "							AND DelYN = 'N' "
	CSQL = CSQL & "					) "
	CSQL = CSQL & "			) "
	CSQL = CSQL & "	) A	"
	CSQL = CSQL & " ORDER BY A.al, "
	CSQL = CSQL & "		A.WriteDate DESC "

'	response.Write CSQL
'	response.End()

	SET CRs = Dbcon.Execute(CSQL)



	If Not(CRs.Eof Or CRs.Bof) Then
		CRs.Move (currPage - 1) * B_PSize

		Do Until CRs.eof
			cnt = cnt + 1

			IF CRs("Notice")="Y" Then
				If cnt <= 3 Then
					FndData = FndData & "	<li class='require' style='cursor:pointer;' onclick=""chk_Submit('VIEW','"&CRs("NtcIDX")&"','"&currPage&"');"">"
				Else
					FndData = FndData & "	<li style='cursor:pointer;' onclick=""chk_Submit('VIEW','"&CRs("NtcIDX")&"','"&currPage&"');"">"
				End IF

			Else
				FndData = FndData & "	<li style='cursor:pointer;' onclick=""chk_Submit('VIEW','"&CRs("NtcIDX")&"','"&currPage&"');"">"
			End IF

			FndData = FndData & "	  <h4>"

			IF CRs("Notice") = "Y" Then FndData = FndData & "[필독]&nbsp;"

			FndData = FndData & ReplaceTagReText(CRs("Title"))

			If DateDiff("H", CRs("WriteDate"), Now())<24 Then FndData = FndData & "<span class='ic-new'>N</span>"


			FndData = FndData & "	  </h4>"
			FndData = FndData & "	  <p class='write-info clearfix'>"
			FndData = FndData & "		<span>"&CRs("UserName")&"("&CRs("LeaderType")&")</span>"
			FndData = FndData & "		<span>"&replace(left(CRs("WriteDate"),10), "-",".")&"</span>"
			FndData = FndData & "		<span class='seen'>조회수</span>"
			FndData = FndData & "		<span>"&CRs("ViewCnt")&"</span>"
			FndData = FndData & "	  </p>"
			FndData = FndData & "	</li>"

			CRs.movenext
		Loop
	Else

		FndData = FndData & "	<li>"
		FndData = FndData & "	  <h4 class='no-list'>등록된 글이 없습니다</h4>"
		FndData = FndData & "	</li>"

	End IF

		CRs.Close
	SET CRs = Nothing


	FndData = FndData & "<script>"

	IF  cnt = 0 THEN
		' FndData = FndData & "	$('#div_Main').attr('class','sub sub-main board no-contents');"
		FndData = FndData & "	$('#record_bg').show();"
	Else
		' FndData = FndData & "	$('#div_Main').attr('class','sub sub-main board');"
		FndData = FndData & "	$('#record_bg').hide();"
	End IF

    FndData = FndData & "</script>"


	response.Write FndData


	dim intTemp
	CStrPG = CStrPG & " <p>&nbsp;</p>"
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
