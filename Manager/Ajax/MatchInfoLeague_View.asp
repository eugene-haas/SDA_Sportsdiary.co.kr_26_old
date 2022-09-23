<!--#include virtual="/Manager/Library/config.asp"-->
<%

	GameTitleIDx = fInject(Request("GameTitleIDx"))
	TeamGb       = fInject(Request("TeamGb"))
	Level        = fInject(Request("Level"))
	GroupGameGb  = fInject(Request("GroupGameGb"))
	Count = 1
	
	'UnearmWin sd042001일반
	'UnearmWin sd04200부전일반
	'LeftRightGb sd033001 왼쪽
	'LeftRightGb sd033002 오른쪽

	'대회정보 선택==========================================================================================
	TSQL = "SELECT "
	TSQL = TSQL&" GameTitleName " 
	TSQL = TSQL&" ,GameS "
	TSQL = TSQL&" ,GameE "
	TSQL = TSQL&" ,GameArea"
	TSQL = TSQL&" FROM Sportsdiary.dbo.tblGameTitle " 
	TSQL = TSQL&" WHERE DelYN='N'"
	TSQL = TSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"

	Set TRs = Dbcon.Execute(TSQL)

	If Not(TRs.Eof Or TRs.Bof) Then 
		GameTitleName = TRs("GameTitleName")
		GameS         = TRs("GameS")
		GameE         = TRs("GameE")
		GameArea      = TRs("GameArea")
	End If 
	'대회정보 선택==========================================================================================
	
	'체급정보 선택==========================================================================================
	LevelSQL ="SELECT "
	LevelSQL = LevelSQL&" LevelNm"
	LevelSQL = LevelSQL&" ,SportsDiary.dbo.Fn_TeamGbNm('judo',TeamGb) As TeamGbNm "
	LevelSQL = LevelSQL&" FROM sportsdiary.dbo.tblLevelInfo "
	LevelSQL = LevelSQL&" WHERE DelYN='N'"
	LevelSQL = LevelSQL&" AND SportsGb='judo'"
	LevelSQL = LevelSQL&" AND Level = '"&Level&"'"

	Set LevelRs = Dbcon.Execute(LevelSQL)

	If Not(LevelRs.Eof Or LevelRs.Bof) Then 
		TEamGbNm = LevelRs("TeamGbNm")
		
		If GroupGameGb = "sd040001" Then 
			GroupGameNm = "개인전"
			LevelNm = LevelRs("LevelNm")
		ElseIf GroupGameGb = "sd040002" Then 
			GroupGameNm = "단체전"
		End If 
		
		
			
	End If 
	'체급정보 선택==========================================================================================	

	'참가선수 카운팅========================================================================================

	If GroupGameGb = "sd040001" Then
		CSQL = "SELECT "
		CSQL = CSQL&" Count(RplayerIDX) AS Cnt"
		CSQL = CSQL&" FROM SportsDiary.dbo.tblRPlayer"
		CSQL = CSQL&" WHERE DelYn = 'N'"
		CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"	
		CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"
		CSQL = CSQL&" AND Level = '"&Level&"'"
		CSQL = CSQL&" AND GroupGameGb = '"&GroupGameGb&"'"
	Else

	CSQL = "SELECT "
	CSQL = CSQL&" Count(RgameGroupSchoolidx) AS Cnt"
	CSQL = CSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
	CSQL = CSQL&" WHERE DelYn = 'N'"
	CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"	
	CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"

	End If

	Set CRs = Dbcon.Execute(CSQL)

	LevelCnt = CRs("Cnt")
	'참가선수 카운팅========================================================================================


	If LevelCnt > 0 Then 

	'대진표의 높이
	Main_Width  = "1100"
	Main_Height = "750"


%>
<table border="0" width="<%=Main_Width%>px" height="<%=Main_Height%>px">
	<tr>
		<td valign="top" height="100px;">
			<!--대회타이틀 및 일정 체급 참가선수 정보-->
			<table width="100%"  border="0">
				<tr>
					<td align="center"><font size="2"><b><%=GameTitleName%></b></font></td>
				</tr>
				<tr>
					<td align="center"><font size="1"><%=GameS%>~<%=GameE%>/<%=GameArea%></font></td>
				</tr>
				<tr>
					<td align="center"><font size="1"><%=TEamGbNm%> >  <%=GroupGameNm%> <%=LevelNm%></font></td>
				</tr>
				<tr>
					<td align="center"><font size="1">참가선수 : <%=LevelCnt%></font></td>
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
				
<%
	End If 
%>
					<%

						'개인전 
						If GroupGameGb = "sd040001" Then
							USQL = " SELECT PlayerIDX, UserName, Team, TeamDtl, Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm"
							USQL = USQL&" FROM SportsDiary.dbo.tblRPlayer"
							USQL = USQL&" WHERE DelYN = 'N'"
							USQL = USQL&" AND GameTitleIDX = '" & GameTitleIDX & "'"
							USQL = USQL&" AND GroupGameGb = '" & GroupGameGb & "'"
							USQL = USQL&" AND TeamGb = '" & TeamGb & "'"
							USQL = USQL&" AND Level = '" & Level & "'"
							USQL = USQL&" AND DelYN = 'N'"
							USQL = USQL&" ORDER BY PlayerNum"	
						Else
							USQL = " SELECT '' AS PlayerIDX, '' AS UserName, Team, TeamDtl, '' AS Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm"
							USQL = USQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
							USQL = USQL&" WHERE DelYN = 'N'"
							USQL = USQL&" AND GameTitleIDX = '" & GameTitleIDX & "'"
							USQL = USQL&" AND TeamGb = '" & TeamGb & "'"
							USQL = USQL&" AND DelYN = 'N'"
							USQL = USQL&" ORDER BY SchNum"
						End If


						Set URs = Dbcon.Execute(USQL)
						If Not(URs.Bof Or URs.Eof) Then

							Arr_Player = URs.Getrows()
							Cnt_Arr_Player = UBound(Arr_Player,2)
							ReDim ReturnSTR(Cnt_Arr_Player)

							For i = 0 To Cnt_Arr_Player
								ReturnSTR(i) = Arr_Player(0,i) & "," & Arr_Player(1,i) & "," & Arr_Player(2,i) & "," & Arr_Player(3,i) & "," & Arr_Player(4,i) & "," & Arr_Player(5,i) 
							Next
						End If

							

						If Cnt_Arr_Player <> "" Then 	
					%>
					<!--테이블생성-->
					<table border="1" align="center" style="border-collapse:collapse; border:1px gray solid;" width="800px" height="500px"  align="center">
						<tr>
							<td></td>
							<%
								'해당되는 선수수만큼 Loop
								For i = 0 To Cnt_Arr_Player
							%>
									<!--선수명-->
									<td width="100px;">
										<%If GroupGameGb = "sd040001" Then%>
											<p class="player-name"><span><%=Arr_Player(1,i)%></span> </p>
											<p class="player-school"><%=Arr_Player(5,i)%></p>
										<%Else%>
											<p class="player-name"><span><%=Arr_Player(5,i)%></span> </p>
										<%End If%>
									</td>
									<!--선수명-->
							<%
								Next
								
							%>
						</tr>
						<!--하위 데이터-->
						<%
							For i = 0 To Cnt_Arr_Player
						%>	
						<tr>
							<!--선수명-->
							<td width="100px;">
								<%If GroupGameGb = "sd040001" Then%>
									<p class="player-name"><span><%=Arr_Player(1,i)%></span> </p>
									<p class="player-school"><%=Arr_Player(5,i)%></p>
								<%Else%>
									<p class="player-name"><span><%=Arr_Player(5,i)%></span> </p>
								<%End If%>
							</td>
							<!--선수명-->
							<%
								'경기수 만큼 loop 
							%>
							<%
								For j = 0 To Cnt_Arr_Player 
							%>
								<!--경기진행-->
								<%
									If i <> j  Then 
								%>
								<!-- 경기입력 -->
								<td class="write">
									<%If GroupGameGb = "sd040001" Then%>
										<p class="player-name"><%=Arr_Player(1,i)%> vs <%=Arr_Player(1,j)%></p>
									<%Else%>
										<p class="player-name"><%=Arr_Player(5,i)%> vs <%=Arr_Player(5,j)%></p>
									<%End If%>

									<%
										If i < j Then
											ReturnSTR(i) = ReturnSTR(i) & "," & Count
											ReturnSTR(j) = ReturnSTR(j) & "," & Count
										
									%>
										<BR>경기순번 : <%=Count%>
									<%
											Count = Count + 1
										End If
									%>
								</td>

								<%
									Else 
								%>
								<!--경기미진행-->
								<td class="no"></td>
								<%
									End If 
								%>
							<%
								Next
								
							%>
						</tr>
						<%
							Next
							
						%>
						<!--하위 데이터-->
					</table>
				<%
					End If	
				%>

						
			
			
