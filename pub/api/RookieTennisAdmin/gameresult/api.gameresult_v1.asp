<%
'#############################################
'대진표 리그 화면 준비 
'#############################################


'request
idx = oJSONoutput.IDX 'tblRGameLevel idx
tidx = oJSONoutput.TIDX
levelno = oJSONoutput.LEVELNO

title = oJSONoutput.TITLE
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = title & " " & teamnm & " (" & areanm & ") "


Set db = new clsDBHelper


'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	SQL = "Select GameS,titleCode,titleGrade,gametitlename from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		games = Left(rs("games"),10)
		titlecode = rs("titlecode")
		titlegrade = rs("titleGrade")
		gametitle = rs("gametitlename")
	End if


	SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,joocnt,lastroundmethod from  tblRGameLevel  where DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		entrycnt = rs("entrycnt")					'참가제한인원수
		attmembercnt = rs("attmembercnt")		'참가신청자수
		courtcnt = rs("courtcnt")					'코트수
		levelno = rs("level")							'레벨
		lastjoono = rs("lastjoono")					'마지막에 편성된 max 조번호
		joocnt = rs("joocnt")
        bigo=rs("bigo")
		endround = rs("endround") '진행될 최종라운드
		lastroundmethod = rs("lastroundmethod") '최종라운드 방식 1 리그 2 토너먼트
	End if
'기본정보#####################################

	ranknames = "" '순위확정된 선수명
	rankpidxs = "" '순위확정된 선수 pidx

	Function getRPoint(ByVal levelno ,ByVal titleGrade,ByVal rankno)
	'	베테랑 별도 개나리부, 국화(open), 신인부(rest), 오픈부
		'20101 개나리 20102 국화부
		'20103 베테랑
		'20104 신인부 20105 오픈부
		Dim teamcode , pt
		teamcode = Left(levelno,5)

		If teamcode = "20101" Or teamcode = "20104" then
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: pt = array(175,112,79,35,18,9)
			Case 2: pt = array(200,140,90,40,20,10)
			Case 3: pt = array(150,105,68,30,15,8)
			Case 4: pt = array(125,88,56,25,13,6)
			Case 5: pt = array(100,70,45,20,10,5)
			End Select
		Else '베테랑, 오픈부 예외 처리 필요
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: pt = array(350,245,158,70,35,18)
			Case 2: pt = array(400,280,180,80,40,20)
			Case 3: pt = array(500,210,135,60,30,15)
			Case 4: pt = array(250,175,112,50,25,12)
			Case 5: pt = array(200,140,90,40,20,10)
			End Select
		End if
		getRPoint = pt(rankno)
	End Function

	sub printRPoint(ByVal levelno ,ByVal titleGrade)
	'	베테랑 별도 개나리부, 국화(open), 신인부(rest), 오픈부
		'20101 개나리 20102 국화부
		'20103 베테랑
		'20104 신인부 20105 오픈부
		Dim teamcode , pt
		teamcode = Left(levelno,5)
		If teamcode = "20101" Or teamcode = "20104" then
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: Response.write "175,112,79,35,18,9"
			Case 2: Response.write "200,140,90,40,20,10"
			Case 3: Response.write "150,105,68,30,15,8"
			Case 4: Response.write "125,88,56,25,13,6"
			Case 5: Response.write "100,70,45,20,10,5"
			End Select
		Else '베테랑, 오픈부 예외 처리 필요
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: Response.write "350,245,158,70,35,18"
			Case 2: Response.write "400,280,180,80,40,20"
			Case 3: Response.write "500,210,135,60,30,15"
			Case 4: Response.write "250,175,112,50,25,12"
			Case 5: Response.write "200,140,90,40,20,10"
			End Select
		End if
	End sub

'본선 정보, 스코어 정보 function
'#############################
	Sub tournInfo(ByVal arrRS , ByVal rd, ByVal i ,ByVal tidx,ByVal levelno,ByVal title,ByVal teamnm, ByVal ranklist ,ByVal lastroundmethod)
		Dim ar ,m1idx,m1name,m1teamA,m1teamB,mrd,msortno,m2name,m2teamA,m2teamB,mgubun,marchange
		Dim chkmember,nextround,nr,nextmember,nr_m1name,m1pidx,nr_sortno,temp_sortno,nr_playeridx
		Dim mrndno1,mrndno2,mrndno,mtrank,mtryoutgroupno,n,mwinno
		Dim SQL, insertvalue1,insertvalue2,rksplit
		chkmember = False
		temp_sortno = 0

		If IsArray(arrRS) Then

			For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

				m1pidx			= arrRS(11, ar) 
				m2pidx			= arrRS(16, ar)
				m1idx				= arrRS(0, ar) 
				m1name			= arrRS(1, ar)  
				m1teamA			= arrRS(2, ar) 
				m1teamB			= arrRS(3, ar) 
				mrd					= arrRS(4, ar) 
				msortno			= arrRS(5, ar) 
				m2name			= arrRS(6, ar) 
				m2teamA			= arrRS(7, ar) 
				m2teamB			= arrRS(8, ar) 
				mgubun			= arrRS(9, ar) 
				mchange			= arrRs(10,ar)
				nextround		= CDbl(mrd) + 1

				mrndno1			= arrRs(12,ar)
				mrndno2			= arrRs(13,ar)
				mtrank			= arrRs(14,ar)
				mtryoutgroupno = arrRs(15,ar)
				mwinno			 = arrRs(17,ar) '리그 순위 0 3 은 3위

				If m1teamB = "" Then
					m1team = m1teamA
				else
					m1team = m1teamA & ", " & m1teamB
				End If
				If m2teamB = "" Then
					m2team = m2teamA
				else
					m2team = m2teamA & ", " & m2teamB
				End If

				'Response.write rd & "-" & mrd & "<br>" ' 3라운드

				If CDbl(lastroundmethod) = 1 Then '최종라운드라면 1리그 2 토너먼트 
					'리그에 참여된 3팀과과 순위를 가져온다. 3명이라고 단정하자.

					If rankpidxs <> "" then
						rksplit = Split(rankpidxs, ",")
						For n = 0 To ubound(rksplit)
							If CStr(rksplit(n)) = CStr(m1pidx) Then
									notprint = True
									Exit for
							End if
						Next
					End If

					If notprint = False then					
						Select Case CDbl(mwinno)
						Case 1  
						selectrankno = 0
						rankno = 1
						Case 2 
						selectrankno = 1
						rankno = 2
						Case 3,0 
						selectrankno = 2
						rankno = 3
						End Select 

						getpt = getRPoint(levelno , titleGrade, selectrankno)
						'데이터가 하나라도 있다면 업데이트나 인서트 삭제 처리 만 가능하도록
						insertvalue1 = " "&m1pidx&",'"&m1name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&games&"' "
						insertvalue2 = " "&m2pidx&",'"&m2name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&games&"' "
						SQL = "insert into sd_TennisRPoint_log (PlayerIDX,userName, getpoint,rankno, titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate) values ("&insertvalue1&"), ("&insertvalue2&")"
						Call db.execSQLRs(SQL , null, ConStr)

						'로그에 넣기////////////
						'rankingpoint '대회시작할대 가지고 있는 값으로 넣어준다. (둘의 합) select 1번 예선 정보를 찾아서 포인트를 넣어준다.
						'rankingresultIDX = 1,2, 3 만 구해보자.... result 에서 order by resultIDX  top 3 으로 해봐야할듯. 1등과 2등은 마지막꺼, 3, 4 는 이름으로

						SQL = "update  sd_TennisScore Set  ranking = "&rankno&"  where  key1 = "&tidx&"  and key3 = "&left(levelno,5)&" and  playerIDX = " & m1pidx & " and delYN = 'N'  "
						Call db.execSQLRs(SQL , null, ConStr)
						'로그에 넣기////////////

						%>
						<tr>
							<td><%=rankno%></td>
							<td><%=m1name%></td>
							<td><%=m1team%></td>
							<td><%=m2name%></td>
							<td><%=m2team%></td>
						</tr>

						<%
					End If
					
					'다음 라운드 진출자로 등록 되었는지 확인
					'프린트한 선수는 다음 검색에서 제외
					If rankpidxs = "" then
						rankpidxs = m1pidx
					Else
						rankpidxs = rankpidxs & "," & m1pidx
					End If				

				else
					If CDbl(rd) = CDbl(mrd) Then
						'다음 라운드 진출자로 등록 되었는지 확인
						'프린트한 선수는 다음 검색에서 제외
						notprint = false

						If rankpidxs <> "" then
							rksplit = Split(rankpidxs, ",")
							For n = 0 To ubound(rksplit)
								If CStr(rksplit(n)) = CStr(m1pidx) Then
										notprint = True
										Exit for
								End if
							Next
						End If
								
						If notprint = False then

							If i = 1 then
								rankno = 1
								selectrankno = 0
							else
								rankno =2^(i-1)
								'Response.write i & "**"& 2^3 & "^^"& rankno & "--<br>"
								selectrankno = i - 1
							End if
							If ranklist = False then	
								getpt = getRPoint(levelno , titleGrade, selectrankno)
								'데이터가 하나라도 있다면 업데이트나 인서트 삭제 처리 만 가능하도록
								insertvalue1 = " "&m1pidx&",'"&m1name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&games&"' "
								insertvalue2 = " "&m2pidx&",'"&m2name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&games&"' "
								SQL = "insert into sd_TennisRPoint_log (PlayerIDX,userName, getpoint,rankno, titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate) values ("&insertvalue1&"), ("&insertvalue2&")"
								Call db.execSQLRs(SQL , null, ConStr)

								'로그에 넣기////////////
								'rankingpoint '대회시작할대 가지고 있는 값으로 넣어준다. (둘의 합) select 1번 예선 정보를 찾아서 포인트를 넣어준다.
								'rankingresultIDX = 1,2, 3 만 구해보자.... result 에서 order by resultIDX  top 3 으로 해봐야할듯. 1등과 2등은 마지막꺼, 3, 4 는 이름으로

								'rankingresultIDX 음~~~
								SQL = "update  sd_TennisScore Set  ranking = "&rankno&"  where  key1 = "&tidx&"  and key3 = "&left(levelno,5)&" and  playerIDX = " & m1pidx & " and delYN = 'N'  "
								Call db.execSQLRs(SQL , null, ConStr)
								'로그에 넣기////////////
							End if
							%>
							<tr>
								<td><%=rankno%></td>
								<td><%=m1name%></td>
								<td><%=m1team%></td>
								<td><%=m2name%></td>
								<td><%=m2team%></td>
							</tr>
						<%
						End If
						
						'다음 라운드 진출자로 등록 되었는지 확인
						'프린트한 선수는 다음 검색에서 제외
						If rankpidxs = "" then
							rankpidxs = m1pidx
						Else
							rankpidxs = rankpidxs & "," & m1pidx
						End If

					End If

				End if
			Next


		End If
	End Sub

	Function getDepthDrow(ByVal tidx, ByVal levelno) '드로우와 라운드수를 구한다.
		Dim SQL, rs, dorwCnt,depthCnt
		Dim rtvalue(2)
		'본선 1라운드 최종 소팅 번호로 명수 확정
		SQL = "SELECT top 1 sortNo from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun >1  and DelYN = 'N'  and round = 1 order by sortno desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		drowCnt = 0
		If Not rs.eof Then
			drowCnt = rs(0)		'총참가자(sorting 마지막 번호)
		End If

		'강수 계산##############
		if drowCnt <=2 then
		drowCnt = 2
		depthCnt = 2
		elseif drowCnt >2 and drowCnt <=4 then
		drowCnt = 4
		depthCnt = 3
		elseif drowCnt >4 and drowCnt <=8 then
		drowCnt=8
		depthCnt = 4
		elseif drowCnt >8 and  CDbl(drowCnt) <=16 then
		drowCnt=16
		depthCnt = 5
		elseif drowCnt >16 and  drowCnt <=32 then
		drowCnt=32
		depthCnt = 6
		elseif drowCnt >32 and  drowCnt <=64 then
		drowCnt=64
		depthCnt = 7
		elseif drowCnt >64 and  drowCnt <=128 then
		drowCnt=128
		depthCnt = 8
		elseif drowCnt >128 and  drowCnt <=256 then
		drowCnt=256
		depthCnt = 9
		end if 
		
		rtvalue(1) = drowCnt
		rtvalue(2) = depthCnt
		getDepthDrow = rtvalue
	End Function

	Function getPlayerlist(ByVal tidx, ByVal levelno, ByVal lastroundmethod)
		Dim strwhere, strsort,strAfield, strBfield, strfield,SQL,rs
		If CDbl(lastroundmethod) = 1 Then '최종라운드 리그
		strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun in (0,1) " 
		else
		strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun >= 2 and a.playerIDX > 1 and a.sortNo > 0" 
		End if
		strsort = " order by a.Round asc,a.SortNo asc"
		strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
		strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno,b.playerIDX      , t_rank "
		strfield = strAfield &  ", " & strBfield

		SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then 
			getPlayerlist = rs.getrows()
		Else
			getPlayerlist = ""	
		End If
	End function

	Sub rsDrowEditor(ByVal rs, ByVal levelno)
		Dim fname,idx
		response.write "<table class='table-list' >"
		Response.write "<thead id=""headtest"">"
		For i = 0 To Rs.Fields.Count - 1
			Select Case Rs.Fields(i).name
			Case "rankno" : fname = "순위"
			Case "userName" : fname = "이름"
			Case "getpoint" : fname = "획득 포인트"
			Case Else : fname = "hide"
			End Select 
			If fname <> "hide" then
			response.write "<th>"& fname &"</th>"
			End if
		Next
		response.write "<th>삭제</th>"
		Response.write "</thead>"

		ReDim rsdata(Rs.Fields.Count) '필드값저장

		Do Until rs.eof
			idx = rs("idx")
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			
			%>
				<tr class="rgametitle" id="r_<%=idx%>">
					<%
						For i = 0 To Rs.Fields.Count - 1
							Select Case Rs.Fields(i).name
							Case "rankno" : fname = "순위"
							Case "userName" : fname = "이름"
							Case "getpoint" : fname = "획득포인트"
							Case "idx" 
								fname = "hide"
							Case Else : fname = "hide"
							End Select 
							If fname <> "hide" then						
								If fname = "순위"  Then
									Response.write "<td><input type='number' min='1' id='prank_"&idx&"' value='"&rsdata(i)&"' onblur=""if(this.value !=''){sd.changeRank("&idx&",this.value,"&levelno&")}"" style='height:30px;'></td>"
								
								ElseIf fname = "획득포인트" Then
									'inparam = " 베테랑, 오픈, 왕중왕 중복 확인, 틀어갈곳 표시, 올해우승 양쪽들어감 정리필요"
									Response.write "<td><input type='number' min='1'  id='pt_"&idx&"' value='"&rsdata(i)&"' onblur=""if(this.value !=''){sd.changePt("&idx&",this.value,"&levelno&")}""  style='height:30px;'>"&inparam&"</td>"
								
								else
									Response.write "<td>" & rsdata(i)   & "</td>"
								End If

							End if
						Next

						    
						Response.write "<td><a href=""javascript:if (confirm('포인트 정보를 삭제 하시겠습니까?')== true){sd.delranker("&idx&");}"" class='btn'>삭제</a></td>"
					%>
				</tr>
			<%
		rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End if
		Response.write "</tbody>"
		Response.write "</table>"
	End Sub

'#############################

	'인서트 자료가 있는지 확인겸 가져오기
	SQL = "Select userName,rankno,getpoint,idx,PlayerIDX,titleCode from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " order by rankno asc"
	Set rslog = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rslog.EOF Then 
		ranklist = True
	Else
		ranklist = False
	End If


	ddarr = getDepthDrow(tidx,levelno)
	drowCnt = ddarr(1)
	depthCnt = ddarr(2)

	'본선정보
	arrT = getPlayerlist(tidx,levelno, lastroundmethod)

	'32강까지의 round 값을 구한다.
	Dim roundnoArr(6)
	n = 1
	For i = depthCnt To 1 Step -1
		roundnoArr(n) = i
		If n = 6 Then
			Exit for
		End if
	n = n + 1
	Next


	'최종라운드#############
	lastroundcheck = Right(levelno,3)
	tn_last_rd = false
	'If lastroundcheck = "007" Then
	If lastroundcheck = "007" And  areanm = "최종라운드"  Then
		tn_last_rd = True
		lastdepth = depthCnt

		'같은부의 levelno,endRound 가져오기
		SQL = " Select level,endRound from tblRGameLevel  where  DelYN = 'N' and  gameTitleIdx = " & tidx & " and teamgb = '"&Left(levelno,5)&"' and level <> '"&levelno&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if



'##############################################
' 소스 뷰 경계
'##############################################
%>


<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=levelno%>-- <%=poptitle%></h3>

  </div>
<!-- 헤더 코트e -->

<div class='modal-body game-ctr'>


	<div class="scroll_box"  id="orderinfo" style="height:200px;margin-top:5px;">
		<table class="table table-striped set_tourney_table">
		<tr><th>순위</th><th>이름</th><th>팀</th><th>이름</th><th>팀</th><tr>

		<%
		If CDbl(depthCnt) > 6 Then
			depthCnt = 6
		End if
		For i = 1 To depthCnt
			Call tournInfo(arrT, roundnoArr(i), i ,tidx,levelno,gametitle,teamnm,ranklist , lastroundmethod)
		Next
		
		'최종라운드라면 나머지 4명이외도 가져와야하니까
		If  tn_last_rd = True  Then
			Do Until rs.eof '최종라운드에 포함대 토너먼트
				nlevelno = rs("level")
				endround = rs("endRound")

				Select Case CDbl(endRound)
				Case 1,2 : hideRDcnt = 0
				Case 4 : hideRDcnt = 1
				Case 8 : hideRDcnt = 2
				Case 16 : hideRDcnt = 3
				Case 32 : hideRDcnt = 4
				Case 64 : hideRDcnt = 5
				End Select 

				ddarr = getDepthDrow(tidx,nlevelno)
				drowCnt = ddarr(1)				'참여자
				depthCnt = ddarr(2)				'라운드수
				If CDbl(depthCnt) > 6 Then	'32강이 넘는다면 강제 고정
					depthCnt = 6
				End if

				arrT = getPlayerlist(tidx,nlevelno , 0)
				n = 1
				For i = depthCnt To 1 Step -1
					roundnoArr(n) = i
				n = n + 1
				Next

				For i = 1 + hideRDcnt To depthCnt '- hideRDcnt - 1
					'Response.write depthCnt - hideRDcnt - 1 & "<br>"
					Call tournInfo(arrT, roundnoArr(i), i+1 ,tidx,nlevelno,gametitle,teamnm,ranklist ,0)	 'arrRS ,  rd,  i , tidx, levelno, title, teamnm,  ranklist
				next
			rs.movenext
			loop
		End if
		%>
		</table>
	</div>



	<!-- 개별 목록 수정삭제 -->
		<div id="printpoint" style="width:100%;margin:auto;height:50px;overflow:auto;text-align:center;font-size:18px;padding-top:3px;padding-bottom:8px;">
		포인트 정보 : <%Call printRPoint(levelno , titleGrade)%>
		<a href="javascript:if (window.confirm('적용된 랭킹이 모두 삭제된 후 다시 자동 계산 됩니다.')){sd.resetResult(<%=idx%>,<%=levelno%>,'<%=teamnm%>','<%=areanm%>')}" class="btn">전체 삭제 후 다시 반영</a>
		</div>


		<div id="orderinfo2"  class="scroll_box" style="height:250px;margin-top:5px;" >
		<%
		'인서트된 자료 다시검색
		SQL = "Select userName,rankno,getpoint,idx,PlayerIDX,titleCode from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " order by rankno asc"
		Set rslog = db.ExecSQLReturnRS(SQL , null, ConStr)
		Call rsDrowEditor(rslog,levelno)%>
		</div>
	<!-- 개별 목록 수정삭제 -->

	<!-- 개별 목록 생성 -->
		<div id="orderinfo3" style="width:100%;margin:auto;height:40px;margin-top:3px;">
		<table class='table table-striped set_tourney_table'>
		<tr>
			<th>이름</th>
			<td>
				<input type="text" id="pname"  style="margin-top:10px;">
			</td>
			<th>순위</th>
			<td>
			<select  id="prankno">
				<option value="1" >1</option>
				<option value="2" >2</option>
				<option value="4" >4</option>
				<option value="8" >8</option>
				<option value="16">16</option>
				<option value="32">32</option>
				<option value="512">참여</option>
			</select>
			</td>
			<th>포인트</th>
			<td>
				<input type="number" min="1" id="ppoint"  style="height:30px;margin-top:10px;">
			</td>
			<td><a href="javascript:sd.setranker(<%=levelno%>)" class="btn">등록</a></td>
		</tr>
		</table>
		</div>
	<!-- 개별 목록 생성 -->

</div>



<%
	'인서트 자료가 있는지 확인겸 가져오기
	SQL = "Select top 1 userName,rankno,getpoint,idx,PlayerIDX,titleCode from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " order by rankno asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		chk_titleCode = rs("titleCode")
	Else
		chk_titleCode = 0
	End If

	'포인트 만료 
	If CDbl(chk_titleCode) > 0 Then
		SQL = "Update sd_TennisRPoint_log  Set ptuse = 'N' where titleCode = " & chk_titleCode & " and teamGb = " & Left(levelno,5) & " and ptuse = 'Y' and titleIDX < " & tidx
		Call db.execSQLRs(SQL , null, ConStr)
	End if


db.Dispose
Set db = Nothing
%>