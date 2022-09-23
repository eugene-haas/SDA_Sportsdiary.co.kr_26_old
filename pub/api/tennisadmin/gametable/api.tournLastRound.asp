<%
'#############################################
'대진표 리그 화면 준비 
'#############################################

'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = title & " " & teamnm & " (" & areanm & ")  "
levelno = oJSONoutput.LevelNo

If hasown(oJSONoutput, "rdtype") = "ok" then
	rdtype = oJSONoutput.rdtype
	if rdtype ="" then 
		rdtype=0
	end if 
Else
	Call oJSONoutput.Set("rdtype", 0 )
	rdtype=0
End if


Call oJSONoutput.Set("T_MIDX", 0 )
Call oJSONoutput.Set("T_SORTNO", 0 )
Call oJSONoutput.Set("T_DIVID", 0 )
Call oJSONoutput.Set("T_ATTCNT", 0 )
Call oJSONoutput.Set("T_NOWRD", 0 )
Call oJSONoutput.Set("T_RDID", 0 )
Call oJSONoutput.Set("S3KEY", 0 )
Call oJSONoutput.Set("SCIDX", 0 ) '결과테이블 인덱스
Call oJSONoutput.Set("POS", 0 )

Set db = new clsDBHelper


	'강수 계산
	Function lastdepth(tcnt)
		Dim depthCnt
			if tcnt <=2 then
			depthCnt = 2
			elseif tcnt >2 and tcnt <=4 then
			depthCnt = 3
			elseif tcnt >4 and tcnt <=8 then
			depthCnt = 4
			elseif tcnt >8 and  CDbl(tcnt) <=16 then
			depthCnt = 5
			elseif tcnt >16 and  tcnt <=32 then
			depthCnt = 6
			elseif tcnt >32 and  tcnt <=64 then
			depthCnt = 7
			elseif tcnt >64 and  tcnt <=128 then
			depthCnt = 8
			elseif tcnt >128 and  tcnt <=256 then
			depthCnt = 9
			end if 
			lastdepth = depthCnt
	End function

	'최종 라운드 1라운드 멤버 등록
	Sub setFinalMember(ByVal idx, ByVal sortno, ByVal levelno,ByVal gubun)
		Dim insertfield, selectfield,selectSQL,SQL, rs,nextRound,midx,nextSortNo,nextgubun

		'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태( 코트 준비 또는 대기 기간 필요)
		insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo "
		If CDbl(gubun) = 0 then
		selectfield = gubun & " ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,"&levelno&","&Left(levelno,5)&",TeamANa,TeamBNa,0,key3name,0,0  "
		Else
		selectfield = gubun & " ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,"&levelno&","&Left(levelno,5)&",TeamANa,TeamBNa,tryoutgroupno,key3name,1,"&sortno&"  "
		End if
		selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & idx

		SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		midx = rs(0)

		'파트너 insert
		insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
		selectfield =  " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa "
		SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & idx
		Call db.execSQLRs(SQL , null, ConStr)
	End Sub


'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,lastroundmethod,joocnt from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		lastroundmethod = rs("lastroundmethod") '최종라운드 방식 (0 방식선택안됨 1, 리그 2 토너먼트)
		entrycnt = rs("entrycnt")					'참가제한인원수
		attmembercnt = rs("attmembercnt")		'참가신청자수
		courtcnt = rs("courtcnt")					'코트수
		levelno = rs("level")							'레벨
		lastjoono = rs("lastjoono")					'마지막에 편성된 max 조번호 (max 값을 체크해서 업데이트 됨 , joocnt 관리자가 지정한 조수 값은 동일해야함)
		joocnt = rs("joocnt")
        bigo=rs("bigo")
		endround = rs("endround")					'진행될 최종라운드
		'poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"

		'if bigo <>"" then 
        'poptitle = poptitle & " <p><span style='color:blue'> ※공지글※</span><p><p<span>"&bigo&"</span><p>"
        'end if 

		If Left(levelno,3) = "200" Then
			joinstr = " left "
			singlegame =  true
		Else
			joinstr = " left "
			singlegame = false
		End if
	End if
'기본정보#####################################


'리그 토너먼트 구분 작업 =================
	If CDbl(rdtype) = 	0 then
		If CDbl(lastroundmethod) = 0 Then
			''타입 석어서 보내기
			Call oJSONoutput.Set("result", "0" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
		%>
		  <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 id="myModalLabel" id="m2_title">방식선택</h3>
		  </div>
		  <div class="modal-body" id="Modaltestbody">
					진행 방식을 선택해 주십시오.	
		  </div>
		  <div class="modal-footer">
			<button class="btn btn-primary" onclick=" $('#ModallastRound').modal('hide');mx.setLastRound(<%=idx%>,'<%=teamnm%>','<%=levelno%>','<%=areanm%>',1)">리그</button>
			<button class="btn btn-primary" onclick="  $('#ModallastRound').modal('hide');mx.setLastRound(<%=idx%>,'<%=teamnm%>','<%=levelno%>','<%=areanm%>',2)">토너먼트</button>
		  </div>
		<%
		Response.End
		Else
			rdtype = lastroundmethod
			oJSONoutput.rdtype	= lastroundmethod	
			
			''타입 석어서 보내기
			Call oJSONoutput.Set("result", "0" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
		End If
	Else
		SQL = "update tblRGameLevel Set lastroundmethod = "&rdtype&" where DelYN = 'N' and  RGameLevelidx = " & idx
		Call db.execSQLRs(SQL , null, ConStr)

		oJSONoutput.rdtype	= rdtype
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"
	End if	
'리그 토너먼트 구분 작업 =================


	Select Case CDbl(rdtype)
	Case 1 '리그

		SQL = "Select gameMemberIDX from sd_TennisMember where  gameTitleIdx = " & tidx & " and gamekey3 = "&levelno&" and delYN = 'N' and gubun in (0,1) "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof then
			'최종라운드와 같은 부의 마지막 강수 구하기
			SQL = " Select level,endRound from tblRGameLevel  where  DelYN = 'N' and  gameTitleIdx = " & tidx & " and teamgb = '"&Left(levelno,5)&"' and level <> '"&levelno&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				arrRD = rs.getrows()
			End if

			If IsArray(arrRD) = true Then
			i = 1
			For k = LBound(arrRD, 2) To UBound(arrRD, 2) 
					k_levelno = arrRD(0, k) 
					k_endRound = arrRD(1, k) 

					'룰강수를 가져온다.
					jooidx = CStr(tidx) & CStr(k_levelno) '생성된 추첨룰이 있다면
					SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "'"
					Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rsr.eof Then
					  k_depth = rsr(6)
					End if


					Select Case CDbl(k_endRound)
					Case 1,2 : hideRDcnt = 0
					Case 4 : hideRDcnt = 1
					Case 8 : hideRDcnt = 2
					Case 16 : hideRDcnt = 3
					Case 32 : hideRDcnt = 4
					Case 64 : hideRDcnt = 5
					End Select 

					
					chkdepth = CDbl(k_depth - hideRDcnt)

					SQL = "Select gameMemberIDX from sd_TennisMember where  gameTitleIdx = " & tidx & " and gamekey3 = "&k_levelno&" and round =  " & chkdepth & " and playerIDX > 1 "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					Do Until rs.eof
						Call setFinalMember(rs(0),i ,levelno,0) '진행된 마지막 라운드 맴버 선수로 등록
					i = i + 1
					rs.movenext
					loop
			Next
			End if
		End if


	Case 2 '토너먼트
		SQL = "Select gameMemberIDX from sd_TennisMember where  gameTitleIdx = " & tidx & " and gamekey3 = "&levelno&" and round =  1 " '1라운드 맴법가 있다면
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof then
			'최종라운드와 같은 부의 마지막 강수 구하기
			SQL = " Select level,endRound from tblRGameLevel  where  DelYN = 'N' and  gameTitleIdx = " & tidx & " and teamgb = '"&Left(levelno,5)&"' and level <> '"&levelno&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				arrRD = rs.getrows()
			End if

			If IsArray(arrRD) = true Then
			i = 1
			For k = LBound(arrRD, 2) To UBound(arrRD, 2) 
					k_levelno = arrRD(0, k) 
					k_endRound = arrRD(1, k) 

					'룰강수를 가져온다.
					jooidx = CStr(tidx) & CStr(k_levelno) '생성된 추첨룰이 있다면
					SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "'"
					Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rsr.eof Then
					  k_depth = rsr(6)
					End if


					Select Case CDbl(k_endRound)
					Case 1,2 : hideRDcnt = 0
					Case 4 : hideRDcnt = 1
					Case 8 : hideRDcnt = 2
					Case 16 : hideRDcnt = 3
					Case 32 : hideRDcnt = 4
					Case 64 : hideRDcnt = 5
					End Select 

					
					chkdepth = CDbl(k_depth - hideRDcnt)

					SQL = "Select gameMemberIDX from sd_TennisMember where  gameTitleIdx = " & tidx & " and gamekey3 = "&k_levelno&" and round =  " & chkdepth & " and playerIDX > 1 "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					Do Until rs.eof
						Call setFinalMember(rs(0),i ,levelno,2) '진행된 마지막 라운드 맴버 선수로 등록
					i = i + 1
					rs.movenext
					loop
			Next
			End if
		End if
	End Select 
'리그 토너먼트 구분 작업 =================






	Select Case CDbl(rdtype)
	Case 1 '리그

			'본선정보
			'#############################
				strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun in (0,1) "   'TOURNSET 2 본선대기 3 본선입력완료
				strsort = " order by a.Round asc,a.SortNo asc"
				strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
				strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno "
				strfield = strAfield &  ", " & strBfield

				SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				rscnt =  rs.RecordCount

				If Not rs.EOF Then 
				arrT = rs.getrows()
				End If

				ReDim mnarr(rscnt)
				If IsArray(arrT) Then
					m = 1
					For ar = LBound(arrT, 2) To UBound(arrT, 2)
						mnarr(m) = arrT(1, ar)&arrT(6,ar)
					m = m + 1
					Next
				End if
			%>
			<!-- 헤더 코트s -->
			  <div class='modal-header game-ctr'>
				<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
				<h3 id='myModalLabel'><%=levelno%>-- <%=poptitle%></h3>
			  </div>
			<!-- 헤더 코트e -->


			<div class='modal-body'>

			<table border="0">
			   <thead>
				  <tr>
					<th style="width:3px;font-size:3px;"></th>
					<th width="*" style="padding-left: 310px; text-align: left;"><h2>결승 리그 참가자  <a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.setLastRound(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=levelno%>')" class = "btn_a" style="border:1px solid black">새로고침</a>
					<span id="loadmsg"></span></h2>
					</th>	  
				  </tr>
			   </thead>

			   <tbody>
				<tr>


				<%'대기#################%>
					<td >
						<div class="title_scroll">
						<table border="1" width="300" class="table-list" id="gametable">
						  <thead>
							<tr><th>팀명</th><th  colspan="2">참여</th></tr>
						  </thead>
						  <tbody>
						   
						<%
						'최종라운드와 같은 부의 마지막 강수 구하기
						SQL = " Select level,endRound from tblRGameLevel  where  DelYN = 'N' and  gameTitleIdx = " & tidx & " and teamgb = '"&Left(levelno,5)&"' and level <> '"&levelno&"' "
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

						If Not rs.eof Then
							arrRD = rs.getrows()
						End if
						If IsArray(arrRD) = true Then
						i = 1
						For k = LBound(arrRD, 2) To UBound(arrRD, 2) 
								k_levelno = arrRD(0, k) 
								k_endRound = arrRD(1, k) 

								'룰강수를 가져온다.
								jooidx = CStr(tidx) & CStr(k_levelno) '생성된 추첨룰이 있다면
								SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "'"
								Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
								If Not rsr.eof Then
								  k_depth = rsr(6)
								End if

								Select Case CDbl(k_endRound)
								Case 1,2 : hideRDcnt = 0
								Case 4 : hideRDcnt = 1
								Case 8 : hideRDcnt = 2
								Case 16 : hideRDcnt = 3
								Case 32 : hideRDcnt = 4
								Case 64 : hideRDcnt = 5
								End Select 

								
								chkdepth = CDbl(k_depth - hideRDcnt)
								chkdepth2 = chkdepth - 1

								strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & k_levelno  & " and a.Round in ( " & chkdepth &","& chkdepth2 & ") and a.playerIDX > 1 " 'TOURNSET 2 본선대기 3 본선입력완료
								strsort = " order by a.Round desc,a.SortNo asc"
								strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
								strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno "
								strfield = strAfield &  ", " & strBfield

								SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

								Do Until rs.eof

									membershow = true
									For x = 1 To ubound(mnarr)
										If rs(1)&rs(6) = mnarr(x) Then
											membershow = false
										Exit for
										End if
									next
									If membershow = True then
										%><tr><td><%=rs(1)%> & <%=rs(6)%> :<span style='color:red'>R<%=rs(4)%></span></td><td><a href="javascript:mx.lastMemberIn2(<%=idx%>,'<%=teamnm%>','<%=areanm%>',<%=levelno%>,<%=rs(0)%>)" class='btn_a'>참여</a></td></tr><%
									End if
								i = i + 1
								rs.movenext
								loop
						Next
						End if
						%>
							

						  </tbody>
						</table>
						</div>
					</td>
				<%'대기#################%>
					
				<%'참여#################%>		
					<td>
					  <table class="tourney_admin <%=drowCnt%>" id ="tourney_admin" border="0">
						<thead>
						  <tr>
								<th>
									<span><a href="javascript:;" class="btn btn-group-sm" >1</a></span>
								</th>
						  </tr>
						</thead>

						<tbody>




						<div style="width:100%;border:1px solid green;padding:0px;margin:0px;">

									<%
									If IsArray(arrT) Then
										For ar = LBound(arrT, 2) To UBound(arrT, 2)
											m1idx				= arrT(0, ar) 
											m1name			= arrT(1, ar)  
											m2name			= arrT(6, ar) 
											%>
											<tr>
												<td>
												<div style="flex:10;height:100%;background:#E5E5E5;">
													<%=m1name%> & <%=m2name%>&nbsp;
													<a href="javascript:mx.lastMemberOut2(<%=idx%>,'<%=teamnm%>','<%=areanm%>',<%=levelno%>,<%=m1idx%>)" class='btn' >취소</a>
												</div>
												</td>
											</tr>
											<%
										Next
									End If
									%>

						</div>




						</tbody>
					  </table>
					</td>
				<%'참여#################%>
				</tr>
			   </tbody>
			</table>





	<%
	Case 2 '토너먼트
			'본선정보
			'#############################
				strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun >= "&TOURNSET&"  " 'TOURNSET 2 본선대기 3 본선입력완료
				strsort = " order by a.Round asc,a.SortNo asc"
				strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
				strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno "
				strfield = strAfield &  ", " & strBfield

				SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				rscnt =  rs.RecordCount

				If Not rs.EOF Then 
				arrT = rs.getrows()
				End If

				ReDim mnarr(rscnt)
				If IsArray(arrT) Then
					m = 1
					For ar = LBound(arrT, 2) To UBound(arrT, 2)
						mnarr(m) = arrT(1, ar)&arrT(6,ar)
					m = m + 1
					Next
				End if
				
			'강수 계산##############
				if rscnt <=2 then
				drowCnt = 2
				depthCnt = 2
				elseif rscnt >2 and rscnt <=4 then
				drowCnt = 4
				depthCnt = 3
				elseif rscnt >4 and rscnt <=8 then
				drowCnt=8
				depthCnt = 4
				elseif rscnt >8 and  CDbl(rscnt) <=16 then
				drowCnt=16
				depthCnt = 5
				end if 
			'강수 계산##############

			'#############################


					Sub tournInfo_2(ByVal arrRS , ByVal rd , ByVal sortno)
						Dim ar ,m1idx,m1name,m1teamA,m1teamB,mrd,msortno,m2name,m2teamA,m2teamB,mgubun,marchange
						Dim chkmember,nextround,nr,nextmember,nr_m1name,m1pidx,nr_sortno,temp_sortno,nr_playeridx
						Dim mrndno1,mrndno2,mrndno,mtrank,mtryoutgroupno
						chkmember = False
						nextmember = False '다음 라운드 진출여부
						temp_sortno = 0
						
						If IsArray(arrRS) Then

							For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
								m1pidx			= arrRS(11, ar) 
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
								If CDbl(mtrank) = 1 Then
									mrndno = mrndno1
								Else
									mrndno = mrndno2
								End if

								If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno) Then
									chkmember = true
									'화면 그림
										oJSONoutput.T_MIDX = m1idx
										oJSONoutput.T_NOWRD = rd
										oJSONoutput.T_SORTNO = sortno
										oJSONoutput.T_DIVID = "cell_"&rd&"_"&sortno
										oJSONoutput.S3KEY = levelno
										strjson = JSON.stringify(oJSONoutput)
										%>
											<%If CDbl(rd) = 1 then%>
											<div id="no_<%=rd%>_<%=sortno%>" style="flex:1;height:100%;background:<%If mchange = "Y"  then%>#99A5DF<%else%>#C7E61D<%End if%>;">
												<%=sortno%>
											</div>
											<%End if%>

											<div id="cell_<%=rd%>_<%=sortno%>" style="flex:10;height:100%;background:<%If mchange = "Y"  then%>#E0E7EF<%else%>#E5E5E5<%End if%>;">
											<a name="<%=m1name%>_<%=rd%>"></a><a name="mark_<%=rd%>_<%=sortno%>"></a>
											<%=m1name%> & <%=m2name%>&nbsp;
											
											<a href="javascript:mx.lastMemberOut(<%=idx%>,'<%=teamnm%>','<%=areanm%>',<%=levelno%>,<%=m1idx%>)" class='btn_a'>취소</a>

											</div>
										<%
									Exit for
								End if
							Next

						End If

					End Sub

			'#############################################

			%>
			<!-- 헤더 코트s -->
			  <div class='modal-header game-ctr'>
				<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
				<h3 id='myModalLabel'><%=poptitle%></h3>
			  </div>
			<!-- 헤더 코트e -->

			<div class='modal-body'>

			<table border="0">
			   <thead>
				  <tr>
					<th style="width:3px;font-size:3px;"></th>
					<th width="*" style="padding-left: 310px; text-align: left;"><h2>결승 토너먼트 참가자  <a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.setLastRound(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=levelno%>')" class = "btn_a" style="border:1px solid black">새로고침</a>
					<span id="loadmsg"></span></h2>
					</th>	  
				  </tr>
			   </thead>

			   <tbody>
				<tr>

				<%'진출전 라운드 선수#################%>
					<td style="height:335px;postion:relative;">
						<div class="title_scroll" style="max-height:300px;">
						<table border="1" width="300" class="table-list game-ctr" id="gametable">
						  <thead>
							<tr><th style="width:80%">팀명</th><th  style="width:20%">참여</th></tr>
						  </thead>
						  <tbody>
						   
						<%
						'최종라운드와 같은 부의 마지막 강수 구하기
						SQL = " Select level,endRound from tblRGameLevel  where  DelYN = 'N' and  gameTitleIdx = " & tidx & " and teamgb = '"&Left(levelno,5)&"' and level <> '"&levelno&"' "
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

						If Not rs.eof Then
							arrRD = rs.getrows()
						End if
						If IsArray(arrRD) = true Then
						i = 1
						For k = LBound(arrRD, 2) To UBound(arrRD, 2) 
								k_levelno = arrRD(0, k) 
								k_endRound = arrRD(1, k)
								
								'룰강수를 가져온다.
								jooidx = CStr(tidx) & CStr(k_levelno) '생성된 추첨룰이 있다면
								SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "'"
								Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
								If Not rsr.eof Then
								  k_depth = rsr(6)
								End if

								Select Case CDbl(k_endRound)
								Case 1,2 : hideRDcnt = 0
								Case 4 : hideRDcnt = 1
								Case 8 : hideRDcnt = 2
								Case 16 : hideRDcnt = 3
								Case 32 : hideRDcnt = 4
								Case 64 : hideRDcnt = 5
								End Select 

								
								chkdepth = CDbl(k_depth - hideRDcnt)
								chkdepth2 = chkdepth - 1
								'Response.write chkdepth & "<br>"

								strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & k_levelno  & " and a.Round in ( " & chkdepth &","& chkdepth2 & ") and a.playerIDX > 1 " 'TOURNSET 2 본선대기 3 본선입력완료
								strsort = " order by a.Round desc,a.SortNo asc"
								strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
								strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno "
								strfield = strAfield &  ", " & strBfield

								SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql & "<br>"
								Do Until rs.eof

									membershow = true
									For x = 1 To ubound(mnarr)
										If rs(1)&rs(6) = mnarr(x) Then
											membershow = false
										Exit for
										End if
									next

									If membershow = True then
										%><tr><td style="text-align:left;padding-left:3px;"><%=rs(1)%> : <%=rs(6)%> :<span style='color:red'>R<%=rs(4)%></span></td><td><a href="javascript:mx.lastMemberIn(<%=idx%>,'<%=teamnm%>','<%=areanm%>',<%=levelno%>,<%=rs(0)%>)" class='btn_a'>참여</a></td></tr><%
									End if
								i = i + 1
								rs.movenext
								loop
						Next
						End if
						%>
							

						  </tbody>
						</table>
						</div>
						
						<table border="1" width="300" class="table-list game-ctr" id="gametable" style="position: absolute; bottom: 0;top:350px;width: 300px;    margin-bottom: 0;    z-index: 200;">
							<tr>
								<td style="text-align:left;padding-left:3px;width:50%;">BYE</td><td><a href="javascript:mx.lastMemberIn(<%=idx%>,'<%=teamnm%>','<%=areanm%>',<%=levelno%>,0)" class='btn_a'>추가</a></td>
							</tr>
						</table>


					</td>
				<%'진출전 라운드 선수#################%>
					
				<%'진출 확정선수#################%>		
					<td>
					  <table class="tourney_admin <%=drowCnt%>" id ="tourney_admin" border="0">
						<thead>
						  <tr>
								<%For i = 1 To 1
									If i = 1 then
										roundcnt = Fix(drowCnt)
									Else
										roundcnt = Fix(roundcnt/2)
									End if
								%>
								<th>
									<span>
										<a href="javascript:;" class="btn btn-group-sm" data-collap="<%=depthcollap %>"><%=roundcnt%></a>
									</span>
									<span id="set_Round_<%=i%>">
										<%
										oJSONoutput.T_ATTCNT = roundcnt
										oJSONoutput.T_NOWRD = i
										oJSONoutput.T_RDID = "set_Round_"&i
										oJSONoutput.S3KEY = levelno
										strjson = JSON.stringify(oJSONoutput)							
										 rdcolor = gubunColor(arrT,i)
										 If rdcolor = "green" then
											btnstr = "편성완료"
										 Else
											btnstr = "재편성"
										 End if
										%>
									</span>
								</th>
								<%Next%>
						  </tr>
						</thead>

						<tbody>
							<tr>
								<%For i = 1 To 1
									If i = 1 then
										roundcnt = Fix(drowCnt)
									Else
										roundcnt = Fix(roundcnt/2)
									End If
									%>

									<td id="<%=i%>_row" style="padding:0px;">
											<%For n = 1 To roundcnt%>
												<div style="width:100%;border:1px solid <%=gubunColor(arrT,i)%>;padding:0px;margin:0px;">
													<%' 행 열을 가진 함수호출 내용 가져와 서 그림%>
													<%Call tournInfo_2(arrT, i, n)%>
												</div>
											<%next%>
									</td>
								<%Next%>
							</tr>
						</tbody>
					  </table>
					</td>
				<%'본선#################%>
				</tr>
			   </tbody>
			</table>

<%End Select%>

</div>

<%
db.Dispose
Set db = Nothing
%>
