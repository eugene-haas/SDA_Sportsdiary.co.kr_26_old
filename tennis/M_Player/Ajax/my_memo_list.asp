<!--#include file="../Library/ajax_config.asp"-->
<%
	'========================================================================================
	'나의메모장 목록 페이지
	'========================================================================================

	Check_Login()

	dim UserID		: UserID		= request.Cookies("SD")("UserID")

	dim BlockPage   : BlockPage 	= 5	'페이지
	dim B_PSize   	: B_PSize 		= 10	'페이지내 보여지는 목록카운트

	dim currPage   	: currPage  	= fInject(Request("currPage"))
	dim SDate   	: SDate 		= fInject(Request("SDate"))
	dim EDate   	: EDate 		= fInject(Request("EDate"))
	dim search_date : search_date 	= fInject(Request("search_date"))
	dim fnd_KeyWord : fnd_KeyWord 	= fInject(Request("fnd_KeyWord"))

	dim TotCount, TotPage
	dim CSearch, CSearch2
	dim cnt				'카운트

	IF Len(currPage) = 0 Then currPage = 1

	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', WriteDate)>=0 AND DateDiff(d, WriteDate, '"&EDate&"')>=0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', WriteDate)=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, WriteDate, '"&EDate&"')=0 "
	Else
	End IF

	IF fnd_KeyWord <> "" Then
		CSearch2 = "AND (Title like '%"&fnd_KeyWord&"%' OR Contents like '%"&fnd_KeyWord&"%') "
	END IF

	CSQL = 	" 		SELECT COUNT(*) "
	CSQL = CSQL & "		,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") "
	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcMemo]"
	CSQL = CSQL & "	WHERE DelYN = 'N' "
	CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "		AND UserID = '"&UserID&"' "&CSearch&CSearch2

	SET CRs = DBCon3.Execute(CSQL)
		TotalCount = CRs(0)
		TotalPage = CRs(1)


	CSQL =  "   	SELECT TOP "&currPage * B_PSize
	CSQL = CSQL & "		MemoIDX  "
	CSQL = CSQL & "		,UserID  "
	CSQL = CSQL & "     ,UserName  "
	CSQL = CSQL & "     ,Title  "
	CSQL = CSQL & "     ,Contents  "
	CSQL = CSQL & "     ,WriteDate  "
	CSQL = CSQL & "     ,CONVERT(CHAR(10), WriteDate, 102) WDate  "
	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcMemo] "
	CSQL = CSQL & " WHERE DelYN = 'N' "
	CSQL = CSQL & "     AND SportsGb = '"&SportsGb&"'"
	CSQL = CSQL & "		AND UserID = '"&UserID&"' "&CSearch&CSearch2
	CSQL = CSQL & " ORDER BY WriteDate DESC "

'	response.Write "ChkSQL="&CSQL&"<br>"

	SET CRs = DBCon3.Execute(CSQL)

	FndData = FndData & "<div class='container'>"
    FndData = FndData & "  <ul class='qa-pack'>"

	If Not(CRs.Eof Or CRs.Bof) Then

		CRs.Move (currPage - 1) * B_PSize

		Do Until CRs.eof
			cnt = cnt + 1

			Title = ReplaceTagReText(CRs("Title"))


			FndData = FndData & "<li class='word-list' onclick=""chk_Submit('VIEW','"&CRs("MemoIDX")&"','"&currPage&"');"">"
			FndData = FndData & "  <a href='#' class='tit' data-parent='board-contents'><span class='txt'>"&Title&"</span>"


			IF DateDiff("H", CRs("WriteDate"), Now())<24 Then 	FndData = FndData & "<span class='ic-new'>N</span>"

			FndData = FndData & "  </a>"
			FndData = FndData & "	<p class='write-info clearfix'>"
			FndData = FndData & "		<span>"&CRs("WriteDate")&"</span>"
			FndData = FndData & "	</p>"
			FndData = FndData & "</li>"

			CRs.movenext
		Loop
	Else
		IF fnd_KeyWord <> "" Then
			FndData = FndData & "	<li class='word-list'><h4 class='no-list'>일치하는 글이 없습니다</h4></li>"
		ELSE
			FndData = FndData & "	<li class='word-list'><h4 class='no-list'>등록된 글이 없습니다</h4></li>"
		End IF
	End IF

	FndData = FndData & "	</ul>"
    FndData = FndData & "</div>"

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

	CStrPG = CStrPG & " <div class='pagination'>"

	intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	If intTemp = 1 Then

	Else
		CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');""><img src='http://img.sportsdiary.co.kr/sdapp/board/board-l-arrow@3x.png' alt='이전페이지'></a> "
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
		CStrPG = CStrPG & " <a href=""javascript:chk_Submit('LIST','','"&intTemp&"');""><img src='http://img.sportsdiary.co.kr/sdapp/board/board-r-arrow@3x.png' alt='다음페이지'></a> "
	End IF

    CStrPG = CStrPG & "</div>"

	response.Write CStrPG


	DBClose3()


%>
