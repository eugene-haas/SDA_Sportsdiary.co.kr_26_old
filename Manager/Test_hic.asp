<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
<%
'화면총사이즈 1000px
Monitor_MaxSize = "1000"
'몇강이지 설정
TotGameCnt = 8
'총열수 계산
oneSideCnt = TotGameCnt/2
Response.Write oneSideCnt&"<br>"

'한쪽메 만들 테이블수
trCnt = oneSideCnt/2
Response.Write trCnt
'선수명단사이즈
PlayerWidth="100"

'선수명당사이즈를 제외한 사이즈
LineWidth = Monitor_MaxSize - (PlayerWidth*2)
	

Function Chk_TD(cnt)
	If cnt = "4" Then 
		Chk_TD = 1
	ElseIf cnt = "8" Then 
		Chk_TD = 2
	ElseIf cnt = "16" Then 
		Chk_TD = 4
	ElseIf cnt = "32" Then 
		Chk_TD = 6
	ElseIf cnt = "64" Then 
		Chk_TD = 8
	ElseIf cnt = "128" Then 
		Chk_TD = 10
	End If 
End Function 

'가운데 대진을 표 만들 갯수
Function Chk_RowTD(cnt)
	If cnt = "4" Then 
		Chk_RowTD = 1
	ElseIf cnt = "8" Then 
		Chk_RowTD = 2
	ElseIf cnt = "16" Then 
		Chk_RowTD = 4
	ElseIf cnt = "32" Then 
		Chk_RowTD = 6
	ElseIf cnt = "64" Then 
		Chk_RowTD = 8
	ElseIf cnt = "128" Then 
		Chk_RowTD = 10
	End If
End Function 

%>
</head>
<body>
<!--토너먼트가 그려질 화면 사이즈 테이블 생성-->
<table width="<%=Monitor_MaxSize%>px" border="1">
	<%
		'대진표열 생성
		For i = 1 To oneSideCnt
	%>
	<tr>
		<td>1</td>
		<!--좌측 라인-->
		<td>
			<%
				If i Mod 2 = 1 Then 
			%>
			┐
			<%
				Else 			
			%>
			┘
			<%
				End If 
			%>
		</td>
		<!--좌측 라인-->
		<!--좌측중간 대진라인-->
		<%
			If i Mod Chk_TD(TotGameCnt) = 1 Then 
		%>
		<td rowspan="<%=Chk_TD(TotGameCnt)%>"></td>
		<%
			ElseIf i Mod Chk_TD(TotGameCnt) = 1 Then
			End If 
		%>
		<!--좌측중간 대진라인-->
		<!--결승라인-->
		<%
			If i = 1 Then 
		%>
		<td rowspan="<%=oneSideCnt%>">----</td>
		<%
			End If 
		%>
		<!--결승라인-->
		<!--우측중간 대진라인-->
		<%
			If i Mod Chk_TD(TotGameCnt) = 1 Then 
		%>
		<td rowspan="<%=Chk_TD(TotGameCnt)%>"></td>
		<%
			End If 
		%>
		<!--우측중간 대진라인-->
		<!--우측 라인-->
		<td>
			<%
				If i Mod 2 = 1 Then 
			%>
			┌
			<%
				Else 			
			%>
			└
			<%
				End If 
			%>
		</td>
		<!--우측 라인-->
		<td>1</td>
	</tr>
	<%
		Next
	%>
	
</table>