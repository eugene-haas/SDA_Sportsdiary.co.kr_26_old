<!--#include virtual="/Manager/Library/config.asp"-->
<%

	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"

  If Request.Cookies("UserID") = "" Then
    Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
    Response.End
  End If 

	'조회조건 데이터
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	SelType = fInject(Request("SelType"))
	



	If SelType = "1" Then
		GroupGameGb = "sd040001"
		'엑셀다운로드
		fileNm = "개인전참가자명단"	
	Else
		GroupGameGb = "sd040002"
		fileNm = "단체전전참가자명단"	
	End If


	LSQL = "SELECT SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName,"
	LSQL = LSQL & " CASE WHEN A.GroupGameGb = 'sd040001' THEN '개인전' ELSE '단체전' END AS GroupGameGbNM,"
	LSQL = LSQL & " A.Team, CASE WHEN A.TeamDtl = '0' THEN '조 없음' ELSE A.TeamDtl END TeamDtl, Sportsdiary.dbo.FN_TeamGbNm(A.SportsGb, A.TeamGb) AS TeamGbNM,"
	LSQL = LSQL & " Sportsdiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.Team) AS TeamNM, LeaderNM, Level, PlayerIDX,"
	LSQL = LSQL & " Sportsdiary.dbo.FN_LevelNm(A.SportsGb, A.TeamGb, A.Level) AS LevelNM, Sportsdiary.dbo.FN_PlayerName(PlayerIDX) PlayerNM, TeamTel, LeaderHP,"
	LSQL = LSQL & " CASE WHEN SubstituteYN = 'Y' THEN '후보' ELSE '선발' END AS SubstituteYN_NM, CASE WHEN Sex = 'Man' THEN '남' ELSE '여' END AS Gender,"
	LSQL = LSQL & " REPLACE(Sportsdiary.dbo.FN_PlayerBirth(A.PlayerIDX),'-','') AS PlayerBirth, Sportsdiary.dbo.FN_PlayerpersonCode(A.PlayerIDX) AS PlayerpersonCode, leaderemail,"
	LSQL = LSQL & " ("
	LSQL = LSQL & "  SELECT PlayerGrade "
	LSQL = LSQL & "  FROM Sportsdiary.dbo.tblGameRequest "
	LSQL = LSQL & "  WHERE GameTitleIDX = A.GameTitleIDX AND DelYN = 'N' AND TeamGb = A.TeamGb AND Level = A.Level "
	LSQL = LSQL & "  AND GroupGameGb = A.GroupGameGb AND PlayerCode = A.PlayerIDX AND GameTitleidx = A.GameTitleidx"
	LSQL = LSQL & "  ) AS PlayerGrade"
	LSQL = LSQL & " FROM Sportsdiary.dbo.tblRplayerMaster A "
	LSQL = LSQL & " INNER JOIN ("
	LSQL = LSQL & " 			SELECT GameTitleIDX, GroupGameGb, Team, LeaderNM, TeamTel, LeaderHP, leaderemail"
	LSQL = LSQL & " 			FROM tblgamerequest"
	LSQL = LSQL & " 			WHERE DelYN = 'N' AND LeaderNm <> ''"
	LSQL = LSQL & " 			GROUP BY GameTitleIDX, GroupGameGb, Team, LeaderNM, TeamTel, LeaderHP, leaderemail"
	LSQL = LSQL & " 			) B ON B.GameTitleIDX = A.GameTitleIDX AND B.GroupGameGb = A.GroupGameGb AND B.Team = A.Team"
	LSQL = LSQL & " WHERE A.GameTitleIDX = '" & GameTitleIDX & "' "
	LSQL = LSQL & " AND A.GroupGameGb = '" & GroupGameGb & "' AND A.DelYN = 'N'"
	LSQL = LSQL & " ORDER BY Sportsdiary.dbo.FN_TeamNm(A.SportsGb, A.TeamGb, A.Team), TeamGb , Level ASC"




	Set LRs = Dbcon.Execute(LSQL)

%>
	<%
		If Not(LRs.Eof Or LRs.Bof) Then 
	%>
		<table border="1">
			<tr>
				<td>대회명</td>
				<td>구분</td>
				<td>소속명</td>
				<td>팀코드</td>
				<td>조</td>
				<td>종별</td>
				<td>체급</td>
				<td>선수명</td>
				<td>체육인번호</td>
				<td>성별</td>
				<td>생년월일</td>
				<td>학년</td>
				<td>지도자명</td>
				<td>연락처1</td>
				<td>연락처2</td>
				<td>이메일</td>
				<td>후보여부</td>

			</tr>
	<%
			Do Until LRs.Eof 
	%>
	<tr>
		<td style="mso-number-format:\@"><%=LRs("GameTitleName")%></td>
		<td style="mso-number-format:\@"><%=LRs("GroupGameGbNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("TeamNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("Team")%></td>
		<td style="mso-number-format:\@"><%=LRs("TeamDtl")%></td>
		<td style="mso-number-format:\@"><%=LRs("TeamGbNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("LevelNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("PlayerNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("PlayerpersonCode")%></td>

		<td style="mso-number-format:\@"><%=LRs("Gender")%></td>

		<td style="mso-number-format:\@"><%=LRs("PlayerBirth")%></td>

		<td style="mso-number-format:\@"><%=LRs("PlayerGrade")%></td>
		<td style="mso-number-format:\@"><%=LRs("LeaderNM")%></td>
		<td style="mso-number-format:\@"><%=LRs("TeamTel")%></td>
		<td style="mso-number-format:\@"><%=LRs("LeaderHP")%></td>
		<td style="mso-number-format:\@"><%=LRs("leaderemail")%></td>
		<td style="mso-number-format:\@"><%=LRs("SubstituteYN_NM")%></td>
	</tr>
	<%
				LRs.MoveNext
			Loop 
		Else
			Response.Write "<script>"
			Response.Write "alert('자료가 없습니다.');"
			Response.Write "history.back();"
			Response.Write "</script>"
		End If 

		Response.Buffer = True
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "Content-disposition","attachment;filename="&fileNm&".xls"
	%>
</table>
