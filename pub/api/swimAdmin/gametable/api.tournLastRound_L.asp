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
poptitle = title & " " & teamnm & " (" & areanm & ")  예선 대진표"


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
	Sub setFinalMember(ByVal idx, ByVal sortno, ByVal levelno)
		Dim insertfield, selectfield,selectSQL,SQL, rs,nextRound,midx,nextSortNo,nextgubun

		'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태( 코트 준비 또는 대기 기간 필요)
		insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo "
		selectfield = "2 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,"&levelno&","&Left(levelno,5)&",TeamANa,TeamBNa,tryoutgroupno,key3name,1,"&sortno&"  "
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

	SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,lastroundmethod from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		lastroundmethod = rs("lastroundmethod") '최종라운드 방식 (0 방식선택안됨 1, 리그 2 토너먼트)
		entrycnt = rs("entrycnt")					'참가제한인원수
		attmembercnt = rs("attmembercnt")		'참가신청자수
		courtcnt = rs("courtcnt")					'코트수
		levelno = rs("level")							'레벨
		lastjoono = rs("lastjoono")					'마지막에 편성된 max 조번호
        bigo=rs("bigo")
		endround = rs("endround") '진행될 최종라운드
		poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"

		if bigo <>"" then 
        poptitle = poptitle & " <p><span style='color:blue'> ※공지글※</span><p><p<span>"&bigo&"</span><p>"
        end if 

		If Left(levelno,3) = "200" Then
			joinstr = " left "
			singlegame =  true
		Else
			joinstr = " inner "
			singlegame = false
		End if
	End if
'기본정보#####################################


	SQL = "Select gameMemberIDX from sd_TennisMember where  gameTitleIdx = " & tidx & " and gamekey3 = "&levelno&" and round =  1 " 'and playerIDX > 1 "
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

				'예선총명수로 참가자 명수 확정
				strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& k_levelno & " and gubun in (0, 1)  and DelYN = 'N' "
				SQL = "SELECT  COUNT(*) as gcnt,max(tryoutgroupno) from "&strtable&" where "&strWhere
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				tcnt = 0
				joono = 1

				If CDbl(rs(0)) > 0 Then
					joono = rs(1)	'조번호
					tcnt = CDbl(joono) * 2				'토너먼트 총참가자
				End If
				k_depth = lastdepth(tcnt)

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
					Call setFinalMember(rs(0),i ,levelno)
				i = i + 1
				rs.movenext
				loop
		Next
		End if
	End if



'기본정보#####################################

	'대진표에 생성자가 있는지 확인
	strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
	SQL = "SELECT gameMemberIDX ,userName,t_rank,rndno1,rndno2,tryoutgroupno,gubun FROM  " &strtable&   " where " & strWhere & " ORDER BY gameMemberIDX ASC"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		'같은 부의 최종 라운드 선수 정보를 가져온다.
		strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
		SQL = "SELECT gameMemberIDX ,userName,t_rank,rndno1,rndno2,tryoutgroupno,gubun FROM  " &strtable&   " where " & strWhere & " ORDER BY gameMemberIDX ASC"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
	End if

'#############



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

Response.write rscnt

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


'스코어 입력 정보 가져오기
'#############################
	strwhere = " a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and a.gubun >= "&TOURNSET&" " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료
	strsort = " order by  a.Round asc, a.SortNo asc"
	strAfield = " a.Round , a.SortNo , a. gamememberIDX  " '열 인덱스(기준)
	strBfield = " b.gameMemberIDX2 , b.resultIDX , b.stateno ,winResult,b.courtno,a.playerIDX " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
	strfield = strAfield &  ", " & strBfield 

	SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1   where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
	End if

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
								
								<%If mgubun = "3" Or CDbl(rd) > 1 Then '고정%>
									<%If m1name = "부전" then%>
										<span style="color:blue;"><%=m1name%></span>
									<%ElseIf m1name = "--" then%>

									<%else%>
										<%=m1name%> & <%=m2name%>
									<%End if%>
								<%else%>
									<%If m1name = "부전" then%>
									<a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'><span style="color:blue;"><%=m1name%></span><%=mgubun%></a>
									<%else%>
										<a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'><%=m1name%> & <%=m2name%></a>
									<%End if%>
								<%End if%>
								
								<br>
								<%If Fix(sortno mod 2) = 1 then%>
								<%'Call drowCourt(rd, sortno) '코트입력 부분%>
								<%End if%>

								<%If mgubun = "3" Then '편성완료라면%>
									<%If CDbl(mrd) > 1 then%>
										<!-- <a href="#" class="btn_a">취소</a> -->
									<%End if%>
										
										<%
											'다음 라운드 진출자로 등록 되었는지 확인
											temp_sortno = 0
											For nr = LBound(arrRS, 2) To UBound(arrRS, 2)
												nr_mrd	= arrRS(4, nr)
												nr_sortno	= arrRS(5, nr) 
												nr_m1name		= arrRS(1, nr) 
												nr_playeridx =  arrRS(11, nr) 

												If CDbl(sortno) Mod 2 = 1 Then
													temp_sortno = CDbl(sortno) +1
												Else 
													temp_sortno = sortno
												End If
												temp_sortno = Fix(CDbl(temp_sortno) /2)

												If  CDbl(temp_sortno) = CDbl(nr_sortno) And CDbl(nr_mrd) = CDbl(nextround)  Then '다음 라운드 소트 번호에 값이 있다면
													If CDbl(nr_playeridx) = 1 Then
													else
														nextmember = True
														Exit For
													End if
												End If
												temp_sortno = 0
											next
											
											Call oJSONoutput.Set("result", 0 )
											strjson = JSON.stringify(oJSONoutput)
										%>

										<%If m1name <> "부전"   And nextmember =  False And CDbl(m1pidx) > 1  then%>
										<%'If m1name <> "부전" And CDbl(m1pidx) > 1 then%>
											<a href='javascript:mx.SetTournGameResult(<%=strjson%>)' class="btn_a">승 </a>

											<%If Fix(sortno mod 2) = 1 then%>
											<br><%Call drowCourt(rd, sortno) '코트입력 부분%>
											<%End if%>

										
										<%else%>
											<%If nr_m1name = m1name And m1name <> "부전"  Then '진출자라면%>
												<%If nr_m1name = "--" then%>
												<span class="winnercell" style="background:green;">빈자리</span>
												<%else%>
												<span class="winnercell">승리</span>
												<%End if%>
											<%End if%>
										<%End if%>
										<%
										nextmember = False
										%>
								<%End if%>



								</div>
							<%
						Exit for
					End if
				Next
				
				If chkmember = False And CDbl(rd) = 1 And CDbl(mgubun)= 2 Then '편성완료 전이라면
					
					oJSONoutput.T_MIDX = 0
					oJSONoutput.T_SORTNO = sortno
					oJSONoutput.T_DIVID = "cell_"&rd&"_"&sortno
					oJSONoutput.S3KEY = levelno
					strjson = JSON.stringify(oJSONoutput)					
					%>
					<div id="no_<%=rd%>_<%=sortno%>" style="flex:1;height:100%;background:#C7E61D;"><%=sortno%></div>					
					<div id="cell_<%=rd%>_<%=sortno%>" style="flex:10;height:100%;"><a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'>빈박스</a></div><%
				End if


			End If

		End Sub


'#############################################

%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
<h3 id='myModalLabel'><%=poptitle%></h3>
<h2><%=poptitle_sub%></h2>
<h2><%=poptitle_sub1%></h2>
<h2 id="sqlquery"></h2>

<%'<!-- #include virtual = "/pub/api/swimAdmin/gametable/api.gameCourt.asp" -->%>
</div> 

<div class='modal-body'>

<table border="0">
   <thead>
	  <tr>
        <th style="width:3px;font-size:3px;"></th>
		<th width="*" style="padding-left: 310px; text-align: left;"><h2>본선대진  <a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.setLastRound(<%=idx%>,'<%=teamnm%>','<%=areanm%>','<%=levelno%>')" class = "btn_a" style="border:1px solid black">새로고침</a><span id="loadmsg"></span></h2>
		</th>	  
	  </tr>
   </thead>


   <tbody>
    <tr>

		<td style="width:3px;font-size:3px;"></td>
	<%'본선#################%>		
		<td>
          <table class="tourney_admin <%=drowCnt%>" id ="tourney_admin" border="0">

			<thead>
              <tr>
                    <%For i = 1 To depthCnt
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
                            <a class="btn_a"   id="set_Round_a<%=i %>"  href='javascript:mx.tornGameIn(<%=strjson%>)'><%=btnstr%></a> 
                        </span>
                    </th>
					<%Next%>
              </tr>
            </thead>

            <tbody>
                <tr>
                    <%For i = 1 To depthCnt
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


</div>
<!-- #include virtual = "/pub/api/swimAdmin/gametable/inc.tournbtn.asp" --><%

db.Dispose
Set db = Nothing
%>
