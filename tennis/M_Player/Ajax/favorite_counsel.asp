<!--#include file="../Library/ajax_config.asp"-->
<%
	dim BlockPage   : BlockPage   = 5 '페이지
	dim B_PSize     : B_PSize     = 10 '페이지내 보여지는 목록카운트

	dim TotCount, TotPage
	dim CSearch, CSearch2

	dim currPage    : currPage    	= fInject(Request("currPage"))
	dim SDate     	: SDate     	= fInject(Request("SDate"))
	dim EDate     	: EDate     	= fInject(Request("EDate"))
	dim search_date : search_date   = fInject(Request("search_date"))

	dim UserID    	: UserID    	= decode(Request.Cookies("UserID"), 0)

	dim CSQL, CRs, LRs

  	IF Len(currPage) = 0 Then currPage = 1


	'기간선택
	IF SDate <> "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', L.WriteDate)>=0 AND DateDiff(d, L.WriteDate, '"&EDate&"')>=0 "
	ElseIF SDate <> "" AND EDate = "" Then
		CSearch = " AND DateDiff(d, '"&SDate&"', L.WriteDate)=0 "
	ElseIF SDate = "" AND EDate <> "" Then
		CSearch = " AND DateDiff(d, L.WriteDate, '"&EDate&"')=0 "
	Else
	End IF

	CSQL = " 		SELECT COUNT(*) "
	CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") "
	CSQL = CSQL & " FROM ( "
	CSQL = CSQL & "     SELECT *"
	CSQL = CSQL & "     FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] L "
	CSQL = CSQL & "     WHERE DelYN = 'N' "
	CSQL = CSQL & "       	AND SportsGb = '"&SportsGb&"' "&CSearch
	CSQL = CSQL & "       	AND LedrAdvIDX IN ( "
	CSQL = CSQL & "         	SELECT LedrAdvIDX "
	CSQL = CSQL & "         	FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "
	CSQL = CSQL & "         	WHERE DelYN = 'N' "
	CSQL = CSQL & "			  		AND TypeLedrAdv = 'F' "
	CSQL = CSQL & "           		AND UserID = '"&UserID&"'  "
	CSQL = CSQL & "       ) "
	CSQL = CSQL & "     UNION ALL "
	CSQL = CSQL & "     SELECT * "
	CSQL = CSQL & "     FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] L "
	CSQL = CSQL & "     WHERE DelYN = 'N' "
	CSQL = CSQL & "			AND SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "			AND (ReplyType = 'T' OR UserID = '"&UserID&"')"
	CSQL = CSQL & "       	AND ReLedrAdvIDX in( "
	CSQL = CSQL & "           	SELECT LedrAdvIDX "
	CSQL = CSQL & "         	FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "
	CSQL = CSQL & "           	WHERE DelYN = 'N' "
	CSQL = CSQL & "             	AND SportsGb = '"&SportsGb&"' "&CSearch
	CSQL = CSQL & "           		AND LedrAdvIDX IN ( "
	CSQL = CSQL & "             		SELECT LedrAdvIDX "
	CSQL = CSQL & "             		FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "
	CSQL = CSQL & "             		WHERE DelYN = 'N' "
	CSQL = CSQL & "							AND TypeLedrAdv = 'F'  "
	CSQL = CSQL & "               			AND UserID = '"&UserID&"'  "
	CSQL = CSQL & "               	) "
	CSQL = CSQL & "			) "
	CSQL = CSQL & " ) A1 "

	SET CRs = Dbcon.Execute(CSQL)
		TotalCount = CRs(0)
		TotalPage = CRs(1)

	CSQL =  " 		SELECT TOP "&currPage * B_PSize&" A1.CIDX CIDX "
	CSQL = CSQL & "     ,A1.IDX IDX "
	CSQL = CSQL & "     ,A1.IDX2 IDX2 "
	CSQL = CSQL & "     ,A1.Title Title "
	CSQL = CSQL & "     ,A1.Contents Contents "
	CSQL = CSQL & "     ,A1.UserName UserName "
	CSQL = CSQL & "     ,A1.WriteDate WriteDate "
	CSQL = CSQL & "	  	,CASE A1.PlayerReln "
	CSQL = CSQL & "			WHEN 'T' THEN SportsDiary.dbo.FN_PubName('sd03900' + A1.LeaderType) "
	CSQL = CSQL & "			WHEN 'A' THEN '부' "
	CSQL = CSQL & "			WHEN 'B' THEN '모' "
	CSQL = CSQL & "			WHEN 'Z' THEN A1.PlayerRelnMemo "
	CSQL = CSQL & "		END	LeaderType "
	CSQL = CSQL & " FROM ( "
	CSQL = CSQL & "     SELECT LedrAdvIDX CIDX "
	CSQL = CSQL & "       	,LedrAdvIDX IDX "
	CSQL = CSQL & "       	,ReLedrAdvIDX IDX2 "
	CSQL = CSQL & "       	,Title Title "
	CSQL = CSQL & "       	,Contents Contents  "
	CSQL = CSQL & "       	,L.UserName UserName  "
	CSQL = CSQL & "       	,L.WriteDate WriteDate "
	CSQL = CSQL & "       	,M.LeaderType LeaderType "
	CSQL = CSQL & "			,M.PlayerReln PlayerReln"
	CSQL = CSQL & "			,M.PlayerRelnMemo PlayerRelnMemo"
	CSQL = CSQL & "     FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] L "
	CSQL = CSQL & "			inner join [Sportsdiary].[dbo].[tblMember] M on M.UserID = L.UserID "
	CSQL = CSQL & "				AND M.DelYN = 'N' "
	CSQL = CSQL & "				AND M.SportsType = '"&SportsGb&"' "
	CSQL = CSQL & "     WHERE L.DelYN = 'N'"
	CSQL = CSQL & "         AND SportsGb = '"&SportsGb&"' "&CSearch
	CSQL = CSQL & "       	AND LedrAdvIDX IN ( "
	CSQL = CSQL & "         	SELECT LedrAdvIDX "
	CSQL = CSQL & "         	FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "
	CSQL = CSQL & "         	WHERE DelYN = 'N' "
	CSQL = CSQL & "          		AND UserID = '"&UserID&"'  "
	CSQL = CSQL & "           		AND TypeLedrAdv = 'F' "
	CSQL = CSQL & "			) "
	CSQL = CSQL & "     UNION ALL "
	CSQL = CSQL & "     SELECT LedrAdvIDX CIDX  "
	CSQL = CSQL & "       	,ReLedrAdvIDX IDX "
	CSQL = CSQL & "      	,LedrAdvIDX IDX2  "
	CSQL = CSQL & "      	,Title Title  "
	CSQL = CSQL & "       	,Contents Contents "
	CSQL = CSQL & "       	,L.UserName UserName "
	CSQL = CSQL & "       	,L.WriteDate WriteDate "
	CSQL = CSQL & "       	,M.LeaderType LeaderType "
	CSQL = CSQL & "			,M.PlayerReln PlayerReln"
	CSQL = CSQL & "			,M.PlayerRelnMemo PlayerRelnMemo"
	CSQL = CSQL & "     FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] L "
	CSQL = CSQL & "			inner join [Sportsdiary].[dbo].[tblMember] M on M.UserID = L.UserID "
	CSQL = CSQL & "       		AND M.DelYN = 'N' "
	CSQL = CSQL & "				AND M.SportsType = '"&SportsGb&"' "
	CSQL = CSQL & "	  WHERE L.DelYN = 'N' "
	CSQL = CSQL & "			AND L.SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "       	AND (ReplyType = 'T' OR L.UserID = '"&UserID&"') "
	CSQL = CSQL & "       	AND ReLedrAdvIDX IN ( "
	CSQL = CSQL & "    	 		SELECT LedrAdvIDX "
	CSQL = CSQL & "    	 		FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] L "
	CSQL = CSQL & "     		WHERE L.DelYN = 'N'"
	CSQL = CSQL & "         		AND SportsGb = '"&SportsGb&"' "&CSearch
	CSQL = CSQL & "       			AND LedrAdvIDX IN ( "
	CSQL = CSQL & "         			SELECT LedrAdvIDX "
	CSQL = CSQL & "         			FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] "
	CSQL = CSQL & "         			WHERE DelYN = 'N' "
	CSQL = CSQL & "           				AND UserID = '"&UserID&"'  "
	CSQL = CSQL & "           				AND TypeLedrAdv = 'F' "
	CSQL = CSQL & "					) "
	CSQL = CSQL & "			) "
	CSQL = CSQL & " ) A1 "
	CSQL = CSQL & " ORDER BY A1.IDX DESC "
	CSQL = CSQL & "      ,A1.IDX2 ASC "

'	response.Write CSQL

	SET CRs = Dbcon.Execute(CSQL)

	FndData = FndData & "<div class='counsel-list'>"
	FndData = FndData & " <ul>"

	IF Not(CRs.Eof Or CRs.Bof) Then

		CRs.Move (currPage - 1) * B_PSize

		Do Until CRs.eof


			'질문의 경우 타이틀출력
			IF CINT(CRs("IDX2"))=0 Then

				FndData = FndData & "<li>"
				FndData = FndData & " <div class='ic-tit'>"
				FndData = FndData & "   <span class='cut-off'>"
				FndData = FndData & "     <span id='FAV"&CRs("CIDX")&"' class='icon-favorite "

				SET LRs = Dbcon.Execute("SELECT DelYN FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] WHERE LedrAdvIDX="&CRs("CIDX")&" AND userid='"&UserID&"' AND TypeLedrAdv='F'")
				IF Not(LRs.eof or LRs.bof) Then
					IF LRs("DelYN") = "N" Then FndData = FndData & "on"
				End IF
					LRs.close

				FndData = FndData & "     ' onclick=""SET_Favorite('"&CRs("CIDX")&"', 'FAV');"">★</span>"
				FndData = FndData & "   </span>"
				FndData = FndData & " </div>"
				FndData = FndData & " <div class='counsel-tit-wrap'>"
				FndData = FndData & "   <div class='counsel-row'>"
				FndData = FndData & "     <div class='counsel-tit' onclick=""chk_Submit('VIEW','"&CRs("CIDX")&"','"&currPage&"');"">"&ReplaceTagReText(CRs("Title"))

				IF DateDiff("H", CRs("WriteDate"), Now())<24 Then FndData = FndData & "<span class='ic-new'>N</span>"

				FndData = FndData & "     </div>"
				FndData = FndData & "   </div>"
				FndData = FndData & "   <p class='write-info clearfix'>"
				FndData = FndData & "     <span>"&CRs("UserName")&"("&CRs("LeaderType")&")</span>"
				FndData = FndData & "     <span>"&replace(left(CRs("WriteDate"), 10), "-", ".")&"</span>"
				FndData = FndData & "   </p>"
				FndData = FndData & " </div>"
				FndData = FndData & "</li>"

			'답변의 경우 내용 일부 출력
      		Else

				FndData = FndData & "<li class='reply'>"
				FndData = FndData & " <div class='counsel-tit-wrap'>"
				FndData = FndData & "   <div class='counsel-row'>"
				FndData = FndData & "     <div class='counsel-tit' onclick=""chk_Submit('VIEW','"&CRs("CIDX")&"','"&currPage&"');"">"
				FndData = FndData & "       <span class='icon-gray'>답변</span> "&replace(ReplaceTagReText(CRs("Contents")),chr(10),"<br>")

				IF DateDiff("H", CRs("WriteDate"), Now())<24 Then FndData = FndData & "<span class='ic-new'>N</span>"

				FndData = FndData & "     </div>"
				FndData = FndData & "   </div>"
				FndData = FndData & "   <p class='write-info clearfix'>"
				FndData = FndData & "     <span class='skyblue'>"&CRs("UserName")&"("&CRs("LeaderType")&")</span>"
				FndData = FndData & "     <span>"&replace(left(CRs("WriteDate"), 10), "-", ".")&"</span>"
				FndData = FndData & "   </p>"
				FndData = FndData & " </div>"
				FndData = FndData & "</li>"

      		End IF

      		CRs.movenext

    	Loop

  	Else

    	FndData = FndData & "<li>일치하는 정보가 없습니다.</li>"

  	End IF

  	FndData = FndData & " </ul>"
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
