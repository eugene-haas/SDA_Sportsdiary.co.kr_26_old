<!--#include file="../Library/ajax_config.asp"-->
<%
	'========================================================================================
	'질문과 답변 목록 페이지
		'QnAType = P 선수용
	'========================================================================================
	'Check_Login()

    dim MemberIDX   : MemberIDX 	= decode(request.Cookies("SD")("MemberIDX"), 0)

	dim BlockPage   : BlockPage 	= 5	'페이지
	dim B_PSize   	: B_PSize 		= 10	'페이지내 보여지는 목록카운트

	dim TotCount, TotPage
	dim CSearch, CSearch2

	dim currPage   	: currPage  	= fInject(Request("currPage"))
	dim SDate   	: SDate 		= fInject(Request("SDate"))
	dim EDate   	: EDate 		= fInject(Request("EDate"))
	dim fnd_user	: fnd_user 		= fInject(Request("fnd_user"))
	dim search_date : search_date 	= fInject(Request("search_date"))

	dim cnt				'카운트

    '==================================================================================
	'답변글 정보 조회
	'==================================================================================
  	FUNCTION RE_CONTENTS(IDX)

		LSQL =  "   	SELECT COUNT(*)  "
		LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA] "
		LSQL = LSQL & " WHERE SportsGb = '"&SportsGb&"' "
		LSQL = LSQL & "     AND DelYN = 'N' "
		LSQL = LSQL & "     AND QnAType = 'P' "
		LSQL = LSQL & "     AND ReQnAIDX =  "&IDX

'		response.Write LSQL

		SET LRs = DBCon3.Execute(LSQL)
		IF LRs(0) > 0 Then
			RE_CONTENTS = TRUE
		Else
			RE_CONTENTS = FALSE
		End IF
			LRs.Close
		SET LRs = Nothing

  	END FUNCTION
    '==================================================================================

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

	'작성자 조회
	IF fnd_user <> "" Then
		CSearch2 = " And UserName Like '%"&fnd_user&"%' "
	End IF


	CSQL = 	" 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") "
	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA]"
	CSQL = CSQL & "	WHERE DelYN = 'N' "
	CSQL = CSQL & "		AND QnAType = 'P' "
	CSQL = CSQL & "		AND ReQnAIDX = 0 "
	CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "&CSearch&CSearch2

	SET CRs = DBCon3.Execute(CSQL)
		TotalCount = CRs(0)
		TotalPage = CRs(1)


	CSQL =  "   	SELECT TOP "&currPage * B_PSize
	CSQL = CSQL & "		QnAIDX  "
	CSQL = CSQL & "		,MemberIDX  "
	CSQL = CSQL & "     ,ReQnAIDX  "
	CSQL = CSQL & "     ,UserName  "
	CSQL = CSQL & "     ,Title  "
	CSQL = CSQL & "     ,Contents  "
	CSQL = CSQL & "     ,WriteDate  "
	CSQL = CSQL & "     ,CONVERT(CHAR(10), WriteDate, 102) WDate  "
	CSQL = CSQL & "     ,ViewCnt  "
	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA] "
	CSQL = CSQL & " WHERE SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "     AND DelYN = 'N' "
	CSQL = CSQL & "     AND QnAType = 'P' "
	CSQL = CSQL & "     AND ReQnAIDX = 0 "&CSearch&CSearch2
	CSQL = CSQL & " ORDER BY WriteDate DESC "

'	response.Write "ChkSQL="&CSQL&"<br>"

	SET CRs = DBCon3.Execute(CSQL)

	If Not(CRs.Eof Or CRs.Bof) Then
		CRs.Move (currPage - 1) * B_PSize

		FndData = FndData & "  <ul>"

		Do Until CRs.eof
			cnt = cnt + 1

			IF CINT(CRs("MemberIDX")) = CINT(MemberIDX) Then
				FndData = FndData & "<li class='word-list' onclick=""chk_Submit('VIEW','"&CRs("QnAIDX")&"','"&currPage&"');"">"
			Else
				FndData = FndData & "<li class='word-list' onclick=""alert('읽기 권한이 없습니다.'); return;"">"
			End IF

			FndData = FndData & "  <a href='#' class='tit' data-parent='board-contents'><h4 class='txt'>"&ReplaceTagReText(CRs("Title"))&""

			'자신이 작성한 질문에 대한 답변글이 있는지 체크
			IF RE_CONTENTS(CRs("QnAIDX")) = TRUE Then FndData = FndData & "<span class='ic-re-bg'></span><span id='icon_re' class='ic-re'>Re</span>"

			If DateDiff("H", CRs("WriteDate"), Now())<24 Then 	FndData = FndData & "<span class='ic-new-bg'></span><span class='ic-new'>N</span>"

			FndData = FndData & "  </h4>"

			FndData = FndData & "  </a>"
			FndData = FndData & "	<p class='write-info clearfix'>"
			FndData = FndData & "	<span>"&CRs("UserName")&"</span>"
			FndData = FndData & "	<span>"&CRs("WDate")&"</span>"
			FndData = FndData & "	<span class='seen'>조회수</span>"
			FndData = FndData & "	<span>"&formatnumber(CRs("ViewCnt"), 0)&"</span>"
			FndData = FndData & "	</p>"
			FndData = FndData & "</li>"

			CRs.movenext
		Loop
		FndData = FndData & "	</ul>"
	Else

		FndData = FndData & "	<h4 class='no-list'>등록된 글이 없습니다</h4>"

	End IF

		CRs.Close
	SET CRs = Nothing



    FndData = FndData & "<script>"

	IF  cnt = 0 THEN
		FndData = FndData & "	$('.pagination').hide();"
		FndData = FndData & "	$('.state-cont').attr('class','state-cont no-contents');"
		FndData = FndData & "	$('#record_bg').show();"
	Else
		FndData = FndData & "	$('.state-cont').attr('class','state-cont');"
		FndData = FndData & "	$('#record_bg').hide();"
	End IF

    FndData = FndData & "</script>"

	response.Write FndData


	dim intTemp

	CStrPG = CStrPG & " <div class='board-bullet'>"

	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	If intTemp = 1 Then

	Else
		CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');""><img src='http://img.sportsdiary.co.kr/sdapp/board/board-l-arrow@3x.png' alt='이전페이지'></a> "
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
		CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp&"');""><img src='http://img.sportsdiary.co.kr/sdapp/board/board-r-arrow@3x.png' alt='다음페이지'></a> "
	End IF

    CStrPG = CStrPG & "</div>"

	response.Write CStrPG


	DBClose3()


%>
