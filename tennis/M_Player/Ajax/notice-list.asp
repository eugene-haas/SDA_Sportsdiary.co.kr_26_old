<!--#include file="../Library/ajax_config.asp"-->
<%
'	Check_Login()

	dim BlockPage   : BlockPage 	= 5	'페이지
	dim B_PSize   	: B_PSize 		= 10	'페이지내 보여지는 목록카운트

	dim TotCount, TotPage
	dim CSearch, CSearch2

	dim currPage   	: currPage  	= fInject(Request("currPage"))
	dim SDate   	: SDate 		= fInject(Request("SDate"))
	dim EDate   	: EDate 		= fInject(Request("EDate"))
	dim fnd_user	: fnd_user 		= fInject(Request("fnd_user"))
	dim search_date : search_date 	= fInject(Request("search_date"))

	dim PlayerReln	: PlayerReln 	= Request.Cookies("PlayerReln")


	dim cnt			: cnt = 0			'카운트
	dim ChkSQL


	IF Len(currPage) = 0 Then currPage = 1

	'기간선택
	IF SDate <> "" and EDate <> "" Then
		CSearch = " And DateDiff(d, '"&SDate&"', WriteDate)>=0 And DateDiff(d, WriteDate, '"&EDate&"')>=0 "
	ElseIF SDate <> "" and EDate = "" Then
		CSearch = " And DateDiff(d, '"&SDate&"', WriteDate)=0 "
	ElseIF SDate = "" and EDate <> "" Then
		CSearch = " And DateDiff(d, WriteDate, '"&EDate&"')=0 "
	Else
	End IF

	'회원구분별 조회조건
	SELECT CASE PlayerReln
		CASE "A", "B", "Z" 	: ChkSQL = " AND BRPubCode IN('BR01','BR03') "
		CASE "D" 			: ChkSQL = " AND BRPubCode = 'BR01' "
		CASE "T" 			: ChkSQL = " AND BRPubCode IN('BR01','BR04') "
		CASE Else 			: ChkSQL = " AND BRPubCode IN('BR01','BR02') "
	END SELECT

	'작성자 조회
	IF fnd_user <> "" Then
	'	CSearch2 = " And UserName Like '%"&fnd_user&"%' "
	End IF

	'BRPubCode[BR01전체공지 | BR02선수용 | BR03부모용 | BR04팀매니저용]

	'ViewTp[열람구분A:전체,T:선수소속팀]
	CSQL = " 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") "
	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcNotice]"
	CSQL = CSQL & "	WHERE DelYN = 'N'"
	CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "		AND DelYN = 'N' " &ChkSQL
    CSQL = CSQL & "		AND ViewYN = 'Y' "
	CSQL = CSQL & "		AND ViewTp = 'A' " &CSearch&CSearch2

	SET CRs = DBCon3.Execute(CSQL)
		TotalCount = CRs(0)
		TotalPage = CRs(1)


	CSQL = 	" 		SELECT TOP "&currPage * B_PSize
	CSQL = CSQL & "	 		NtcIDX "
	CSQL = CSQL & "			,Title "
	CSQL = CSQL & "			,UserName "
	CSQL = CSQL & "			,WriteDate "
	CSQL = CSQL & "			,ViewCnt "
	CSQL = CSQL & "			,Notice "
	CSQL = CSQL & "			,1 al "
	CSQL = CSQL & "		FROM [SD_tennis].[dbo].[tblSvcNotice]"
	CSQL = CSQL & "		WHERE DelYN = 'N'"
	CSQL = CSQL & "			AND SportsGb = '"&SportsGb&"'"
	CSQL = CSQL & "			AND DelYN = 'N' " &ChkSQL
    CSQL = CSQL & "			AND ViewYN = 'Y' "
	CSQL = CSQL & "			AND ViewTp = 'A' " &CSearch&CSearch2
	CSQL = CSQL & " ORDER BY WriteDate DESC "

'	response.Write "CSQL="&CSQL&"<br>"

	SET CRs = DBCon3.Execute(CSQL)



	If Not(CRs.Eof Or CRs.Bof) Then
		CRs.Move (currPage - 1) * B_PSize

		FndData = FndData & "<ul>"

		Do Until CRs.eof
			cnt = cnt + 1


			IF CRs("Notice")="Y" Then
				FndData = FndData & "	<li class='require' onclick=""chk_Submit('VIEW','"&CRs("NtcIDX")&"','"&currPage&"');"">"
				FndData = FndData & "	  <h4>[필독]&nbsp;"&ReplaceTagReText(CRs("Title"))

				If DateDiff("H", CRs("WriteDate"), Now())<24 Then FndData = FndData & "	<span class='ic-new-bg'></span><span class='ic-new'>N</span>"

				FndData = FndData & "	  </h4>"

			Else
				FndData = FndData & "	<li onclick=""chk_Submit('VIEW','"&CRs("NtcIDX")&"','"&currPage&"');"">"

				FndData = FndData & "	  <h4>"&ReplaceTagReText(CRs("Title"))

				If DateDiff("H", CRs("WriteDate"), Now())<24 Then FndData = FndData & "	<span class='ic-new-bg'></span><span class='ic-new'>N</span>"

				FndData = FndData & "	  </h4>"

			End IF


			FndData = FndData & "	  <p class='write-info clearfix'>"
			FndData = FndData & "		<span>"&CRs("UserName")&"</span>"
			FndData = FndData & "		<span>"&replace(left(CRs("WriteDate"),10), "-",".")&"</span>"
			FndData = FndData & "		<span class='seen'>조회수</span>"
			FndData = FndData & "		<span>"&CRs("ViewCnt")&"</span>"
			FndData = FndData & "	  </p>"
			FndData = FndData & "	</li>"

			CRs.movenext
		Loop

		FndData = FndData & "</ul>"

	Else

		' FndData = FndData & "	<li>"
		FndData = FndData & "	  <h4 class='no-list'>등록된 글이 없습니다</h4>"
		' FndData = FndData & "	</li>"

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
	' CStrPG = CStrPG & " <p>&nbsp;</p>"
	CStrPG = CStrPG & " <div id='boardPage' class='board-bullet'>"

	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	If intTemp = 1 Then

	Else
		CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');"" class='prev'><img src='http://img.sportsdiary.co.kr/sdapp/board/board-l-arrow@3x.png' alt='이전페이지'></a> "
	End If

	dim intLoop : intLoop = 1

	Do Until intLoop > BlockPage Or intTemp > TotalPage
		If intTemp = CInt(currPage) Then
			CStrPG = CStrPG & " <a href='#' class='on'><span>"&intTemp&"</span></a> "
		Else
			CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp&"');""><span>"&intTemp&"</span></a> "
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


	DBClose3()


%>
