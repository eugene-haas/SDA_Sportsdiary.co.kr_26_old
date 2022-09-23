<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'메인페이지 공지사항 리스트 조회페이지
	'===========================================================================================
'	Check_Login()

 	dim LSQL, LRs
  	dim FormData

'	FormData = "<li class='list_tit'>공지사항</li>"

  	'ViewTp[A:전체 | T:선수소속팀]
	LSQL =  " 		SELECT TOP 5 "
	LSQL = LSQL & " 	NtcIDX "
	LSQL = LSQL & " 	,Title "
	LSQL = LSQL & " 	,WriteDate "
	LSQL = LSQL & " 	,Notice "
	LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSvcNotice]"
	LSQL = LSQL & " WHERE DelYN = 'N' "
	LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"' "
	LSQL = LSQL & "   	AND BRPubCode = 'BR01' "
	LSQL = LSQL & "   	AND ViewTp = 'A' "
   	LSQL = LSQL & "   	AND ViewYN = 'Y' "	'출력구분
	LSQL = LSQL & " ORDER BY WriteDate DESC "

'	response.Write LSQL

	SET LRs = DBCon3.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then

		Do Until LRs.Eof

			FormData = FormData & "<li class='m_list__item'>"
			FormData = FormData & "	<a href='../board/notice-view.asp?NtcIDX="&LRs("NtcIDX")&"' class='m_list__link'>"

'			IF LRs("Notice") = "Y" Then FormData = FormData & "[필독]&nbsp;"

			FormData = FormData & "·&nbsp;" & ReplaceTagReText(LRs("Title"))

			If DateDiff("H", LRs("WriteDate"), Now())<24 Then
				FormData = FormData & "<span class=""m_list__badgeNewBg""></span><span class=""m_list__badgeNew"">N</span>"
			End IF

			FormData = FormData & " </a>"
			FormData = FormData & "</li>"

			LRs.MoveNext
		Loop
	Else
		FormData = FormData & "<li class=""m_list__item""><a href='#' class=""m_list__link"">등록된 공지사항이 없습니다.</a></li>"
	End IF

		LRs.Close
	SET LRs = Nothing

	DBClose3()

	response.Write FormData
%>
