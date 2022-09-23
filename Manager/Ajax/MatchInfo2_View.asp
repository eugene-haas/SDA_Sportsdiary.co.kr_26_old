<!--#include virtual="/Manager/Library/config.asp"-->
<%
	GameTitleIDx = fInject(Request("GameTitleIDx"))
	TeamGb       = fInject(Request("TeamGb"))
	Level        = fInject(Request("Level"))
	GroupGameGb  = fInject(Request("GroupGameGb"))

	'GameTitleIDx = "44"	
	'TeamGb       = "21001"
	'Level        = "21001002"
	'GroupGameGb  = "sd040001"


	LSQL = "SELECT "
	LSQL = LSQL&" UserName"
	LSQL = LSQL&" ,Team"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayer"
	LSQL = LSQL&" WHERE DelYn = 'N'"
	LSQL = LSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"
	LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
	LSQL = LSQL&" AND Level = '"&Level&"'"
	LSQL = LSQL&" AND GroupGameGb = '"&GroupGameGb&"'"

	Set LRs = Dbcon.Execute(LSQL)

	If Not (LRs.Eof Or LRs.Bof) Then 

	'대진표의 높이
	Main_Width  = "1100"
	Main_Height = "750"


	TotGameCnt = "2"


	'128강일때 10
	If TotGameCnt = "128" Then 
		playerHeight="10px"
		spanHeight = "8px"
		tdWidth    = "11%"
		tdCnt      = "7"
	'64강일때  20
	ElseIf TotGameCnt = "64" Then 
		playerHeight="20px"
		spanHeight = "16px"
		tdWidth    = "13%"
		tdCnt      = "6"
	'32강일때  40
	ElseIf TotGameCnt = "32" Then 
		playerHeight="40px"
		spanHeight = "32px"
		tdWidth    = "16%"
		tdCnt      = "5"
	'16강일때  80
	ElseIf TotGameCnt = "16" Then 
		playerHeight="80px"
		spanHeight = "64px"
		tdWidth    = "20%"
		tdCnt      = "4"
	'8강일때   160
	ElseIf TotGameCnt = "8" Then 
		playerHeight="160px"
		spanHeight = "128px"
		tdWidth    = "26%"
		tdCnt      = "3"
	'4강일때   320
	ElseIf TotGameCnt = "4" Then 
		playerHeight="320px"
		spanHeight = "256px"
		tdWidth    = "40%"
		tdCnt      = "2"
	'2강일때   640
	ElseIf TotGameCnt = "2" Then 
		playerHeight="640px"
		spanHeight = "512px"
		tdWidth    = "80%"
		tdCnt      = "1"
	'1강일때   1280
	End If 
	
	'한쪽에 그려져야 하는 갯수
	halfCnt = TotGameCnt/2
%>
<table border="0" width="<%=Main_Width%>px" height="<%=Main_Height%>px">
	<tr>
		<td valign="top" height="100px;">
			<!--대회타이틀 및 일정 체급 참가선수 정보-->
			<table width="100%"  border="0">
				<tr>
					<td align="center"><font size="2"><b>동트는 동해 2017 생활체육 전국 유도대회</b></font></td>
				</tr>
				<tr>
					<td align="center"><font size="1">2017.01.21~2017.01.23/강원,동해체육관</font></td>
				</tr>
				<tr>
					<td align="center"><font size="1">남자 고등부 >  개인전 -60kg</font></td>
				</tr>
				<tr>
					<td align="center"><font size="1">참가선수 : 75</font></td>
				</tr>
				<tr>
					<td align="left">
						<font size="1"><b>경기대진표</b></font>
						<hr>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="650px;" valign="top">
			<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="middle" width="48%">
						<!-- 좌측 구분 선수 S -->
						<table border="0" height="100%">
							<%
								'해당경기수만큼 선수정보 뿌림
								For i=1 To halfCnt									
							%>
							<tr>
								<td height="<%=playerHeight%>" width="100px"  style="font-size:xx-small;">용인대투혼 가나다</td>
								<%
									If TotGameCnt <> "2" And (i Mod 2 = 1) Then 
										spanstyle = "display: block; border-top: 1px solid #000; border-right: 1px solid #000; height: 8px; margin-top: 8px;"
									ElseIf TotGameCnt <> "2" And (i Mod 2 = 0) Then 
										spanstyle = "display: block; border-bottom: 1px solid #000; border-right: 1px solid #000; height: 8px; margin-top: -8px;"
									End If 
								%>
								<%
									If TotGameCnt = "2" Then 
									'2강경기일경우=====================================================================================================
								%>
								<td width="82%"><span style="display: block; border-bottom: 1px solid #000;  height: 8px; margin-top: -8px;"></span></td>
								<%
									'2강경기일경우=====================================================================================================									
								%>
								<%

									End If 
								%>
							</tr>
							<%
								Next 
							%>
						</table>
						<!-- 좌측 구분 선수 E -->
					</td>

					<td width="4%;" align="center">
						<!--가운데 라인 영역-->

						<!--가운데 라인 영역-->
					</td>
					<td valign="middle" width="48%" align="right">
						<!-- 우측 구분 선수 S -->
						<table border="0" height="100%">
							<%
								'해당경기수만큼 선수정보 뿌림
								For i=1 To halfCnt					
							%>
							<tr>								
								<%
									If TotGameCnt = "2" Then 
									'2강경기일경우=====================================================================================================
								%>
								<td width="82%"><span style="display: block; border-bottom: 1px solid #000;  height: 8px; margin-top: -8px;"></span></td>
								<%
									'2강경기일경우=====================================================================================================									
									End If 
								%>
								<td width="1px"><span style="display: block; border-bottom: 1px solid #000;  height: 8px; margin-top: -8px;"></span></td>											
								<td height="<%=playerHeight%>" width="100px"  style="font-size:xx-small;">가나다 용인대투혼</td>
							</tr>
							<%
								Next 
							%>
						</table>
						<!-- 우측 구분 선수 E -->
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	End If 
%>
