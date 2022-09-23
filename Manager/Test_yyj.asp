<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
<%
	TotGameCnt = Request("TotGameCnt")

	If TotGameCnt = "" Then 
		TotGameCnt = 4
	Else 
		TotGameCnt = TotGameCnt
	End If 

'화면 가로 사이즈 1000px
Monitor_MaxSize_Width = "1270"

'환면 세로 사이즈 720px
Monitor_MaxSize_Height = "600"


'총열수 계산
oneSideCnt = TotGameCnt/2
'Response.Write oneSideCnt&"<br>"

'한쪽메 만들 테이블수
trCnt = oneSideCnt/2
'Response.Write trCnt
'선수명단사이즈
PlayerWidth="100"


'선수명단사이즈를 제외한 사이즈
LineWidth = Monitor_MaxSize_Width - (PlayerWidth*2)

LineHeight = Monitor_MaxSize_Height / (TotGameCnt/2)



'왼쪽넘버
LeftNum = 1
RightNum = oneSideCnt+1


'박스크기
BoxWidth  = 10
BoxHeight = LineHeight
PlayerWidth  = 80
PlayerHeight = LineHeight

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


'한쪽에 생성되는 대진표라인
Function MakeTD(cnt)
	If cnt = "4" Then 
		MakeTD = 0
	ElseIf cnt = "8" Then 
		MakeTD = 1
	ElseIf cnt = "16" Then 
		MakeTD = 2
	ElseIf cnt = "32" Then 
		MakeTD = 3
	ElseIf cnt = "64" Then 
		MakeTD = 4
	ElseIf cnt = "128" Then 
		MakeTD = 5
	End If 
End Function 
%>
<script language="javascript">
function chk_frm(){
	var f = document.frm;
	f.action = "";
	f.submit();
}
</script>
</head>
<body>
<form name="frm" method="post">
<select name="TotGameCnt" onChange="chk_frm()">
	<option value="4" <%If TotGameCnt = 4 Then %>selected<%End If%>>4</option>
	<option value="8" <%If TotGameCnt = 8 Then %>selected<%End If%>>8</option>
	<option value="16" <%If TotGameCnt = 16 Then %>selected<%End If%>>16</option>
	<option value="32" <%If TotGameCnt = 32 Then %>selected<%End If%>>32</option>
	<option value="64" <%If TotGameCnt = 64Then %>selected<%End If%>>64</option>
	<option value="128" <%If TotGameCnt = 128 Then %>selected<%End If%>>128</option>
</select>
</form>
<!--토너먼트가 그려질 화면 사이즈 테이블 생성-->
<table width="<%=Monitor_MaxSize_Width%>px" border="0" style="border-collapse:  collapse;  border-spacing: 0;">
	<%
		'대진표열 생성
		For i = 1 To oneSideCnt
	%>
	<tr>
		<td width="<%=PlayerWidth%>px" height="<%=PlayerHeight%>px"> <font size="1;">좌상대<%=LeftNum%></font></td>
		<%
			LeftNum = LeftNum + 1
		%>
		<!--좌측 라인 생성S-->
			<td width="<%=BoxWidth%>">--</td>
		<!--좌측 라인 생성E-->
		<!--***************************좌측중간 대진라인***************************-->
		<%
			k = 1			
			z = 1
			'Response.Write MakeTD(TotGameCnt)
			
			For x = 1 To MakeTD(TotGameCnt)

				If i Mod k*2  = 1 Then 
							
		%>
		<td rowspan="<%=k*2%>" width="<%=BoxWidth*2%>px" height="<%=Boxheight%>px" valign="middle">
			<font size="1"><%=z%></font>
		</td>
		<%				
				End If 
					k = k*2
					z = z + 1
			Next
			


		%>
		<!--***************************좌측중간 대진라인***************************-->
		<!--$$$$$$$$$$$$$$$$$$$$$$$$$$$결승라인$$$$$$$$$$$$$$$$$$$$$$$$$$$-->
		<%
			If i = 1 Then 
		%>
		<td rowspan="<%=oneSideCnt%>" >
			<table width="100%">
				<tr>
					<td>-</td>
				</tr>
			</table>
		</td>
		<%
			End If 
		%>
		<!--$$$$$$$$$$$$$$$$$$$$$$$$$$$결승라인$$$$$$$$$$$$$$$$$$$$$$$$$$$-->

		<!--***************************우측중간 대진라인***************************-->
		<%
			k = k *2
			For x = MakeTD(TotGameCnt) To 1 Step -1

				If i Mod k/2  = 1 Then 
					
		%>
		<td rowspan="<%=k/2%>" width="<%=BoxWidth*2%>px" height="<%=Boxheight%>px" valign="middle"><font size="1;"><%=k/2%></font></td>
		<%				
				End If 
					k = k/2
			Next
			
		%>
		<!--***************************우측중간 대진라인***************************-->
		<!--우측 라인 생성S-->
		<td width="<%=BoxWidth%>">--</td>
		<!--우측 라인 생성S-->
		<td width="<%=PlayerWidth%>px" height="<%=PlayerHeight%>px"><font size="1;">우상대<%=RightNum%></td>
		<%
			RightNum = RightNum + 1
		%>
	</tr>
	<%
		Next
	%>
	
</table>