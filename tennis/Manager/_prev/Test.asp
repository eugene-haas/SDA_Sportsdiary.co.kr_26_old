<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
<%
'화면총사이즈 1000px
Monitor_MaxSize = "1000"
'몇강이지 설정
TotGameCnt = 32
'한쪽에 경기수를 결정
oneSideCnt = TotGameCnt/2
Response.Write oneSideCnt&"<br>"

'한쪽메 만들 테이블수
trCnt = oneSideCnt/2
Response.Write trCnt
'선수명단사이즈
PlayerWidth="100"

'선수명당사이즈를 제외한 사이즈
LineWidth = Monitor_MaxSize - (PlayerWidth*2)

	oneListWidth = LineWidth/(3*oneSideCnt)

	Response.Write fix(oneListWidth)
	
%>
</head>
<body>
<!--토너먼트가 그려질 화면 사이즈 테이블 생성-->
<table width="<%=Monitor_MaxSize%>px">
	<tr>
		<td>
			<table border="1" width="<%=Monitor_MaxSize%>px">
			<%
				'한쪽 기준으로 대진 테이블 생성
				For i = 1 To trCnt
			%>
				<tr>
					<td width="<%=PlayerWidth%>px">윤용진<%=i%></td>
					<%
						For j = 1 To oneSideCnt					
					%>					
					<td <%=fix(oneListWidth)%>>---</td>
					<!--다음경기라인생성용-->
					<%If j Mod 2 = 1 Then %>
					<td rowspan="2" width="<%=fix(oneListWidth)%>">-----------</td>
					<%End If %>
					<!--좌우꺽임생성용-->
					<%
						Next
					%>
					<td width="<%=PlayerWidth%>px">최승규<%=i%></td>
				</tr>
				<tr>
					<td width="<%=PlayerWidth%>px">유다영<%=i%></td>
					<%
						For k = 1 To oneSideCnt					
					%>					
					<td width="<%=fix(oneListWidth)%>">---</td>
					<%
						Next
					%>
					<td width="<%=PlayerWidth%>px">박상희<%=i%></td>
				</tr>
			<%
				Next				
			%> 
			</table>
		</td>
	</tr>
</table>
</body>
</html>