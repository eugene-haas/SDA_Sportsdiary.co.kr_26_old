<%
'#############################################
'대진표 리그 화면 준비 
'#############################################

'request
idx = oJSONoutput.IDX 'tblRGameLevel idx
tidx = oJSONoutput.TIDX
levelno = oJSONoutput.LEVELNO

title = Trim(oJSONoutput.TITLE)
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = title & " " & teamnm & " (" & areanm & ") "

Set db = new clsDBHelper

Call oJSONoutput.Set("PIDX", 0 )
Call oJSONoutput.Set("RNKTYPE", 0 )


booarr =  array("여자부★","남자부★","여자부★★","남자부★★")

'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strresulttable = " sd_TennisResult "
	logtbl = "sd_TennisRPoint_log"
	ptbl = "tblPlayer"

	SQL = "Select GameS,titleCode,titleGrade,gametitlename,gameyear from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		games = Left(rs("games"),10)
		titlecode = rs("titlecode")
		titlegrade = rs("titleGrade")
		gametitle = rs("gametitlename")
		nowyearchk = rs("gameyear") '해당년도
	End If
	
	SQL = " Select level,endRound,lastroundmethod,LastRchk,gameday from  tblRGameLevel  where DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		levelno = rs("level")								'레벨
		endround = rs("endround")						'진행될 최종라운드
		lastroundmethod = rs("lastroundmethod") '최종라운드 방식 1 리그 2 토너먼트
		LastRchk = rs("LastRchk")						'최종라운드에서 몇강까지 반영할지 여부
		gameday = rs("gameday")
		If gameday = "" Then
			gameday = games							'여자부★ , 남자부★ 우승자 우승 날짜로 사용
		End if
	End if
'기본정보#####################################

	ranknames = ""		'순위확정된 선수명
	rankpidxs = ""		'순위확정된 선수 pidx

	'지급해야할 몰포인트 정보 남겨두기
	Function getMallpoint(ByVal rankno)
		Dim mallpt
		mallpt = array(22000,12000,6000,3000,2000,1000)

		If CDbl(rankno) > 5 Then '32강이 넘은게 온다면 무시 하고
		getRPoint = 0
		Else
			If isnumeric(rankno) = True then
				getMallpoint = mallpt(rankno)
			End if
		End if		
	End Function

	Function getRPoint(ByVal levelno ,ByVal titleGrade,ByVal rankno)
		'20101 여자부★  20102 여자부★★
		'20104 남자부★ 20105 남자부★★
		Dim teamcode , pt
		teamcode = Left(levelno,5)
		If teamcode = "20101" Or teamcode = "20104" Then '원스타 여, 남
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: pt = array(26000,16000,10000,6000,3000,1000)
			Case 2: pt = array(26000,16000,10000,6000,3000,1000)
			Case 3: pt = array(26000,16000,10000,6000,3000,1000)
			Case 4: pt = array(26000,16000,10000,6000,3000,1000)
			Case 5: pt = array(26000,16000,10000,6000,3000,1000)
			Case Else
				pt = array(0,0,0,0,0,0)			
			End Select
		Else '투스타
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: pt = array(26000,16000,10000,6000,3000,1000)
			Case 2: pt = array(26000,16000,10000,6000,3000,1000)
			Case 3: pt = array(26000,16000,10000,6000,3000,1000)
			Case 4: pt = array(26000,16000,10000,6000,3000,1000)
			Case 5: pt = array(26000,16000,10000,6000,3000,1000)
			Case Else 
				pt = array(0,0,0,0,0,0)
			End Select
		End If

		If CDbl(rankno) > 5 Then '32강이 넘은게 온다면 무시 하고
		getRPoint = 0
		Else
			If isnumeric(rankno) = True then
				getRPoint = pt(rankno)
			End if
		End if
	End Function

	sub printRPoint(ByVal levelno ,ByVal titleGrade)
		'베테랑 별도 개나리부, 국화(open), 신인부(rest), 오픈부
		'20101 개나리 20102 국화부
		'20103 베테랑
		'20104 신인부 20105 오픈부
		Dim teamcode , pt
		teamcode = Left(levelno,5)
		If teamcode = "20101" Or teamcode = "20104" then
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: Response.write "26000,16000,10000,6000,3000,1000"
			Case 2: Response.write "26000,16000,10000,6000,3000,1000"
			Case 3: Response.write "26000,16000,10000,6000,3000,1000"
			Case 4: Response.write "26000,16000,10000,6000,3000,1000"
			Case 5: Response.write "26000,16000,10000,6000,3000,1000"
			End Select
		Else '베테랑, 오픈부 예외 처리 필요
			Select Case CDbl(titleGrade) 'SA GA, A , B , C
			Case 1: Response.write "26000,16000,10000,6000,3000,1000"
			Case 2: Response.write "26000,16000,10000,6000,3000,1000"
			Case 3: Response.write "26000,16000,10000,6000,3000,1000"
			Case 4: Response.write "26000,16000,10000,6000,3000,1000"
			Case 5: Response.write "26000,16000,10000,6000,3000,1000"
			End Select
		End if
	End sub



'본선 정보, 스코어 정보 function
'#############################
	Sub tournInfo(ByVal arrRS , ByVal rd, ByVal i ,ByVal tidx,ByVal levelno,ByVal title,ByVal teamnm, ByVal ranklist ,ByVal lastroundmethod)
		Dim ar ,m1idx,m1name,m1teamA,m1teamB,mrd,msortno,m2name,m2teamA,m2teamB,mgubun,marchange
		Dim chkmember,nextround,nr,nextmember,nr_m1name,m1pidx,nr_sortno,temp_sortno,nr_playeridx
		Dim mrndno1,mrndno2,mrndno,mtrank,mtryoutgroupno,n,mwinno
		Dim SQL, insertvalue1,insertvalue2,rksplit ,         boo1, boo2 ,getpt, getmallpt
		Dim rs '//쩝 안넣어서 아래로 타고 내려감 ㅡㅡ 조심햇
		Dim minv , maxv ,logcnt '대회 두번 참여자 포인트 하나만

		Dim in2to1,rnkcnt1,rnkcnt2

		Dim win,lose, winp, losep, rfield, ptblsub
		Dim teamidx1,teamidx2,teamidx,sumpts,sumptsA,sumptsB,windiff,ptdiff, m1upno, m2upno
		m1upno = 0 '승급 번호 1 원스타 2투스타
		m2upno  = 0
		win = 0
		lose = 0
		winp = 0
		losep = 0
		windiff = 0
		ptdiff = 0
		in2to1 = 0

		chkmember = False
		temp_sortno = 0

		If IsArray(arrRS) Then

			For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
				'data
					m1pidx			= arrRS(11, ar) 
					m2pidx			= arrRS(16, ar)
					m1idx				= arrRS(0, ar) 
					m1name			= arrRS(1, ar)  
					m1teamA		= arrRS(2, ar) 
					m1teamB		= arrRS(3, ar) 
					mrd				= arrRS(4, ar) 
					msortno			= arrRS(5, ar) 
					m2name			= arrRS(6, ar) 
					m2teamA		= arrRS(7, ar) 
					m2teamB		= arrRS(8, ar) 
					mgubun			= arrRS(9, ar) 
					mchange			= arrRs(10,ar)
					If isnull(mrd) = True Then
					
					else
					nextround		= CDbl(mrd) + 1
					End if

					mrndno1			= arrRs(12,ar)
					mrndno2			= arrRs(13,ar)
					mtrank			= arrRs(14,ar)
					mtryoutgroupno = arrRs(15,ar)
					mwinno			 = arrRs(17,ar) '리그 순위 0 3 은 3위

					boo1 = arrRs(18,ar) '랭킹반영부서 (오픈부 참여 선택에서)
					boo2 = arrRs(19,ar)
					rnkcnt1 = arrRs(20,ar) '입상횟수
					rnkcnt2 = arrRs(21,ar) '입상휫수

				'data

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

				'최종라운드 처리######################################################(최종라운드는 안쓸꺼 같지만 일딴 유지
				If CDbl(lastroundmethod) = 1 Then '최종라운드라면 1리그 2 토너먼트 
					'리그에 참여된 3팀과 순위를 가져온다. 3명이라고 단정하자.

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
						Case Else 
							selectrankno = 2
							rankno = 3
						End Select 

						getpt = getRPoint(levelno , titleGrade, selectrankno)
						getmallpt = getMallpoint(selectrankno)

						'데이터가 하나라도 있다면 업데이트나 인서트 삭제 처리 만 가능하도록
						If ranklist = False then	'인서트자료가 없다면
							If CDbl(getmallpt) > 0 Then

								'20101,20104 원스타 처리  우승횟수 , 2회 우승 (승격) firstcount 1등횟수
								'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
								'**** 모든 랭킹 정보는 매해 첫대회에 초기화 되도록 관리자 페이지 별도 작업 진행
								Select Case  CDbl(rankno)
								Case  1 '1등 
									Select Case Left(levelno,5) 
									Case "20101", "20104" '***원스타  (승급시, teamgb, belongBoo변경)***
										SQL = "update "&ptbl&" Set "
										SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
										SQL = SQL & " dblrnk= 'Y', chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = 1, "
										SQL = SQL & " userlevel = '2.0' , "
										SQL = SQL & " stateNO = 100, " '원스타승급

										If Left(levelno,5)  = "20101" then
											SQL = SQL & " teamgb = '20102' , "
											SQL = SQL & " belongBoo = '"&booarr(2)&"' , "
										Else
											SQL = SQL & " teamgb = '20105', "
											SQL = SQL & " belongBoo = '"&booarr(3)&"' , "
										End if

										SQL = SQL & " firstcount = 0, rankcnt = 0 " '승급 일등카운트 초기화 , 랭킹횟수 초기화
										SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
										Call db.execSQLRs(SQL , null, ConStr) 

									Case "20102", "20105" '투스타 
										' 2회 우승자는 ★★(2star) 참가자격 박탈 				
										' 4회 입상자(준우승, 3위)도 ★★(2star) 참가자격 박탈 (이건나중에 하자 이야기좀 해보고)
										SQL = "update "&ptbl&" Set "
										SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
										SQL = SQL & " dblrnk= case when firstcount > 1 then 'Y' else 'N' end, chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = 1, "
										SQL = SQL & " stateNO = case when firstcount > 1 then 200 else stateNo end, "
										SQL = SQL & " firstcount = firstcount + 1,rankcnt = rankcnt + 1 " 
										SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
										Call db.execSQLRs(SQL , null, ConStr) 
									End Select 

								Case "2","3","4" '입상자 카운트 조건 만족시 승급
									'rankcnt 
									Select Case Left(levelno,5) 
									Case "20101", "20104" '***원스타  (승급시, teamgb, belongBoo변경)***
										If cdbl(rnkcnt1) + 1 = 2 Then'승급
											SQL = "update "&ptbl&" Set "
											SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " dblrnk= 'Y', chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&", "
											SQL = SQL & " userlevel = '2.0' ,  stateNO = 100, " '원스타승급

											If Left(levelno,5)  = "20101" then
												SQL = SQL & " teamgb = '20102' , belongBoo = '"&booarr(2)&"' , "
											Else
												SQL = SQL & " teamgb = '20105',  belongBoo = '"&booarr(3)&"' , "
											End if

											SQL = SQL & " firstcount = 0, rankcnt = 0 " '승급 일등카운트 초기화 , 랭킹횟수 초기화
											SQL = SQL & " where playerIDX = '"&m1pidx&"' " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr) 
										Else
											SQL = "update "&ptbl&" Set "
											SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&" ,rankcnt = rankcnt + 1 "
											SQL = SQL & " where playerIDX = '"&m1pidx&"' " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr) 														
										End If
										If cdbl(rnkcnt2) + 1 = 2 Then'승급
											SQL = "update "&ptbl&" Set "
											SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " dblrnk= 'Y', chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&", "
											SQL = SQL & " userlevel = '2.0' ,  stateNO = 100, " '원스타승급

											If Left(levelno,5)  = "20101" then
												SQL = SQL & " teamgb = '20102' , belongBoo = '"&booarr(2)&"' , "
											Else
												SQL = SQL & " teamgb = '20105',  belongBoo = '"&booarr(3)&"' , "
											End if

											SQL = SQL & " firstcount = 0, rankcnt = 0 " '승급 일등카운트 초기화 , 랭킹횟수 초기화
											SQL = SQL & " where playerIDX = '"&m2pidx&"' " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr) 
										Else
											SQL = "update "&ptbl&" Set "
											SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&" ,rankcnt = rankcnt + 1 "
											SQL = SQL & " where playerIDX =  '"&m2pidx&"'  " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr)
										End if									

									Case "20102", "20105" '투스타 
										SQL = "update "&ptbl&" Set "
										SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
										SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&" ,rankcnt = rankcnt + 1 "
										SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
										Call db.execSQLRs(SQL , null, ConStr)
									End Select 




								Case Else
										SQL = "update "&ptbl&" Set "
										SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
										SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&""
										SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
										Call db.execSQLRs(SQL , null, ConStr) 									
								End Select

								'본선 8강기준############################################
								'@@@@@@@@@@@@@@@@@ ? 왜이렇게 했지 흠... 쿼리를 잘못만든거 같은데
								'playeridx 로 gubun = 3 인것들의 갯수를 가져온다.
								'본선 8강기준############################################
								If CDbl(rankno) <= 32 Then '본선 8강인사람들  8강까지의  득점(득, 실) , 포인트 (득, 실)  > 32강까지 다시 변경 2019.03.11

									'승수만 넣자.
									SQL = "select COUNT(a.PlayerIDX) - 1 as cnt  from sd_tennismember as a inner join sd_TennisMember_partner as b on a.gameMemberIDX = b.gamememberidx  "
									SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.gamekey3 = '"&levelno&"' and a.PlayerIDX > 1 and a.gubun > 2 and  a.playeridx = "&m1pidx&"   group by a.PlayerIDX "
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
									If Not rs.eof Then
										win = rs(0)
										lose = 0
									Else
										win = 0
										lose = 0
									End if




									rfield  ="r.resultIDX , r.gameMemberIDX1 as midx1, r.gameMemberIDX2 as midx2,r.winresult, r.m1set1,r.m2set1   ,'"&midx&"' as mymidx  "
									rfield = rfield & " ,(Select (Cast(sum(leftscore) as varchar)  + ',' + Cast(sum(rightscore) as varchar)) As sumpts from sd_TennisResult_record  where resultIDX = r.resultIDX and setno = 1 and  gameend = 1 ) as sumpts "
									
									SQL = "select top 1 "&rfield&" from sd_TennisResult as r where r.GameTitleIDX =  '"&tidx&"' and r.Level = '"&levelno&"' and r.delyn = 'N' and r.stateno= 1 and (  gameMemberIDX1 = '"&m1idx&"' or gameMemberIDX2 = '"&m1idx&"' )  " 
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

									If Not rs.eof Then
										teamidx1 = rs("midx1")
										teamidx2 = rs("midx2")
										teamidx = rs("mymidx")
										sumpts = rs("sumpts")
										
										If sumpts = "" Or isnull(sumpts) = true Then
											sumptsA = 0
											sumptsB = 0
										Else
											sumptsA = Split(sumpts,",")(0)
											sumptsB = Split(sumpts,",")(1)
										End If
										
										If CStr(teamidx1) = CStr(teamidx) Then
											'win = rs("m1set1")
											'lose = rs("m2set1")
											winp = sumptsA
											losep  = sumptsB
										Else
											'win = rs("m2set1")
											'lose = rs("m1set1")
											winp = sumptsB
											losep  = sumptsA
										End if

										windiff = CDbl(win) - Cdbl(lose)  '승점차
										ptdiff = CDbl(winp) - CDbl(losep) '포인트차 
										'Response.write m1pidx & " " & winp & "<br>"
									End if

								End if
							'본선 8강기준############################################
							'@@@@@@@@@@@@@@@@@
							'본선 8강기준############################################

								'누적포인트 저장*****************
									SQL = "update " & ptbl  & " Set sdpoint = sdpoint +  " &getpt& " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') "
									Call db.execSQLRs(SQL , null, ConStr)
								'누적포인트 저장*****************

								in2to1 = 0
								if boo1 = booarr(0) Or  boo1 = booarr(1) Then '원스타인데 투스타 참여
									If  Left(levelno,5)= "20102" Or  Left(levelno,5)=  "20105" then '투스타 
										in2to1 = 1
									End if
								End if


								'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
								SQL = "select stateNO,playerIDX from tblplayer where playerIDX in ('"&m1pidx&"','"&m2pidx&"') "
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
								If Not rs.eof Then
										If Cstr(rs(1)) = Cstr(m1pidx) Then
											Select Case  CDbl(rs(0))
											Case 100  '한번 들어가면 계속 쭉 100상태임...
												m1upno = 1
											Case 200
												m1upno = 2
											Case Else 
												m1upno = 0
											End Select
										Else
											If Cstr(rs(1)) = Cstr(m2pidx) Then
												Select Case  CDbl(rs(0))
												Case 100  '한번 들어가면 계속 쭉 100상태임...
													m2upno = 1
												Case 200
													m2upno = 2
												Case Else 
													m2upno = 0
												End Select
											End If												
										End if
								End if

								insertvalue1 = " "&m1pidx&",'"&m1name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&gameday&"',"&getmallpt&" ,"&win&","&lose&","&winp&","&losep&","&windiff&","&ptdiff&","&m1upno&" , "&in2to1&" "
								insertvalue2 = " "&m2pidx&",'"&m2name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&gameday&"',"&getmallpt&" ,"&win&","&lose&","&winp&","&losep&","&windiff&","&ptdiff&","&m2upno&" ,"&in2to1&"  "
								SQL = "insert into "&logtbl&" (PlayerIDX,userName, getpoint,rankno, titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate,mallpoint,wincnt,lostcnt,winpoint,lostpoint,windiff,ptdiff,upgrade,in2to1) values ("&insertvalue1&"), ("&insertvalue2&")"
								Call db.execSQLRs(SQL , null, ConStr)		

							End if
						End if
						%>
						
						<%If CDbl(getmallpt) > 0 then%>
						<tr>
							<td width="10%"><%=rankno%></td><td width="15%"><%=m1name%></td><td width="30%"><%=m1team%></td><td width="15%"><%=m2name%></td><td width="30%"><%=m2team%></td>
						</tr>
						<%End if%>

						<%
					End If
					
					'다음 라운드 진출자로 등록 되었는지 확인
					'프린트한 선수는 다음 검색에서 제외
					If rankpidxs = "" then
						rankpidxs = m1pidx
					Else
						rankpidxs = rankpidxs & "," & m1pidx
					End If				



				Else '##############################################본선 서브
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

							i = CDbl(i)
							If i = 1 Then 'i 는 시작라운드
								rankno = 1
								selectrankno = 0
							else
								rankno =2^(i-1)
								selectrankno = i - 1
							End if

							getpt = getRPoint(levelno , titleGrade, selectrankno) '32강이 넘어가면 0
							getmallpt = getMallpoint(selectrankno)
							
							If ranklist = False then	'인서트자료가 없다면
								
								If CDbl(getmallpt) > 0 then

									'20101,20104 원스타 처리  우승횟수 , 2회 우승 (승격) firstcount 1등횟수
									'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
									'**** 모든 랭킹 정보는 매해 첫대회에 초기화 되도록 관리자 페이지 별도 작업 진행
									Select Case  CDbl(rankno)
									Case  1 '1등
										Select Case Left(levelno,5) 
										Case "20101", "20104" '원스타  (승급시, teamgb, belongBoo변경)

											SQL = "update "&ptbl&" Set "
											SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " dblrnk= 'Y', chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = 1, "
											SQL = SQL & " userlevel = '2.0' , "
											SQL = SQL & " stateNO = 100, " '원스타승급

											If Left(levelno,5)  = "20101" then
												SQL = SQL & " teamgb = '20102' , "
												SQL = SQL & " belongBoo = '"&booarr(2)&"' , "
											Else
												SQL = SQL & " teamgb = '20105', "
												SQL = SQL & " belongBoo = '"&booarr(3)&"' , "
											End if

											SQL = SQL & " firstcount = 0, rankcnt = 0 " '승급 일등카운트 초기화 , 랭킹횟수 초기화
											SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr) 
											
										Case "20102", "20105" '투스타 
											' 2회 우승자는 ★★(2star) 참가자격 박탈 				
											' 4회 입상자(준우승, 3위)도 ★★(2star) 참가자격 박탈 (이건나중에 하자 이야기좀 해보고)
											SQL = "update "&ptbl&" Set "
											SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " dblrnk= case when firstcount > 1 then 'Y' else 'N' end, chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = 1, "
											SQL = SQL & " stateNO = case when firstcount > 1 then 200 else stateNo end, "
											SQL = SQL & " firstcount = firstcount + 1 ,rankcnt = rankcnt + 1 "
											SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr) 
										End Select 


									'###
									Case "2","3","4" '입상자 카운트 조건 만족시 승급
										'rankcnt 
										Select Case Left(levelno,5) 
										Case "20101", "20104" '***원스타  (승급시, teamgb, belongBoo변경)***
											If cdbl(rnkcnt1) + 1 = 2 Then'승급
												SQL = "update "&ptbl&" Set "
												SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
												SQL = SQL & " dblrnk= 'Y', chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&", "
												SQL = SQL & " userlevel = '2.0' ,  stateNO = 100, " '원스타승급

												If Left(levelno,5)  = "20101" then
													SQL = SQL & " teamgb = '20102' , belongBoo = '"&booarr(2)&"' , "
												Else
													SQL = SQL & " teamgb = '20105',  belongBoo = '"&booarr(3)&"' , "
												End if

												SQL = SQL & " firstcount = 0, rankcnt = 0 " '승급 일등카운트 초기화 , 랭킹횟수 초기화
												SQL = SQL & " where playerIDX = '"&m1pidx&"' " '플레이어 update.
												Call db.execSQLRs(SQL , null, ConStr) 
											Else
												SQL = "update "&ptbl&" Set "
												SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
												SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&" ,rankcnt = rankcnt + 1 "
												SQL = SQL & " where playerIDX = '"&m1pidx&"' " '플레이어 update.
												Call db.execSQLRs(SQL , null, ConStr) 														
											End If
											If cdbl(rnkcnt2) + 1 = 2 Then'승급
												SQL = "update "&ptbl&" Set "
												SQL = SQL & " levelup = " & nowyearchk& ",gameday='"&gameday&"',titlecode = "&titlecode&", "
												SQL = SQL & " dblrnk= 'Y', chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&", "
												SQL = SQL & " userlevel = '2.0' ,  stateNO = 100, " '원스타승급

												If Left(levelno,5)  = "20101" then
													SQL = SQL & " teamgb = '20102' , belongBoo = '"&booarr(2)&"' , "
												Else
													SQL = SQL & " teamgb = '20105',  belongBoo = '"&booarr(3)&"' , "
												End if

												SQL = SQL & " firstcount = 0, rankcnt = 0 " '승급 일등카운트 초기화 , 랭킹횟수 초기화
												SQL = SQL & " where playerIDX = '"&m2pidx&"' " '플레이어 update.
												Call db.execSQLRs(SQL , null, ConStr) 
											Else
												SQL = "update "&ptbl&" Set "
												SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
												SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&" ,rankcnt = rankcnt + 1 "
												SQL = SQL & " where playerIDX =  '"&m2pidx&"'  " '플레이어 update.
												Call db.execSQLRs(SQL , null, ConStr)
											End if									

										Case "20102", "20105" '투스타 
											SQL = "update "&ptbl&" Set "
											SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&" ,rankcnt = rankcnt + 1 "
											SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr)
										End Select 


									'###
									Case Else
											SQL = "update "&ptbl&" Set "
											SQL = SQL & " gameday='"&gameday&"',titlecode = "&titlecode&", "
											SQL = SQL & " chkTIDX = "&tidx&", chklevel='"&left(levelno,5)&"', lastorder = "&rankno&""
											SQL = SQL & " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') " '플레이어 update.
											Call db.execSQLRs(SQL , null, ConStr) 									
									End Select

									'본선 8강기준############################################
									'@@@@@@@@@@@@@@@@@
									'본선 8강기준############################################
									If CDbl(rankno) <= 32 Then '본선 8강인사람들  8강까지의  득점(득, 실) , 포인트 (득, 실) 

									'$$$$$$$$$$$$$
										'승수만 넣자.
										SQL = "select COUNT(a.PlayerIDX) - 1 as cnt  from sd_tennismember as a inner join sd_TennisMember_partner as b on a.gameMemberIDX = b.gamememberidx  "
										SQL = SQL & " where a.GameTitleIDX = "&tidx&" and a.gamekey3 = '"&levelno&"' and a.PlayerIDX > 1 and a.gubun > 2 and  a.playeridx = "&m1pidx&"   group by a.PlayerIDX "
										Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
										If Not rs.eof Then
											win = rs(0)
											lose = 0
										Else
											win = 0
											lose = 0
										End if



										'요기부터는 잘못된거같은데 일딴 그냥 두자 승수만 넣자.
										rfield  ="r.resultIDX , r.gameMemberIDX1 as midx1, r.gameMemberIDX2 as midx2,r.winresult, r.m1set1,r.m2set1   ,'"&midx&"' as mymidx  "
										rfield = rfield & " ,(Select (Cast(sum(leftscore) as varchar)  + ',' + Cast(sum(rightscore) as varchar)) As sumpts from sd_TennisResult_record  where resultIDX = r.resultIDX and setno = 1 and  gameend = 1 ) as sumpts "

										SQL = "select top 1 "&rfield&" from sd_TennisResult as r where r.GameTitleIDX =  '"&tidx&"' and r.Level = '"&levelno&"' and r.delyn = 'N' and r.stateno= 1 and (  gameMemberIDX1 = '"&m1idx&"' or gameMemberIDX2 = '"&m1idx&"' )  " 
										Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

										If Not rs.eof Then
											teamidx1 = rs("midx1")
											teamidx2 = rs("midx2")
											teamidx = rs("mymidx")
											sumpts = rs("sumpts")
											
											If sumpts = "" Or isnull(sumpts) = true Then
												sumptsA = 0
												sumptsB = 0
											Else
												sumptsA = Split(sumpts,",")(0)
												sumptsB = Split(sumpts,",")(1)
											End If
											
											If CStr(teamidx1) = CStr(teamidx) Then
												'win = rs("m1set1")
												'lose = rs("m2set1")
												winp = sumptsA
												losep  = sumptsB
											Else
												'win = rs("m2set1")
												'lose = rs("m1set1")
												winp = sumptsB
												losep  = sumptsA
											End if

											windiff = CDbl(win) - Cdbl(lose)  '승점차
											ptdiff = CDbl(winp) - CDbl(losep) '포인트차 
										End If
									'$$$$$$$$$$$$$


									End if
									'본선 8강기준############################################
									'@@@@@@@@@@@@@@@@@
									'본선 8강기준############################################

									'누적포인트 저장*****************
										SQL = "update " & ptbl  & " Set sdpoint = sdpoint +  " &getpt& " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') "
										Call db.execSQLRs(SQL , null, ConStr)
									'누적포인트 저장*****************

									in2to1 = 0
									if boo1 = booarr(0) Or  boo1 = booarr(1) Then '원스타인데 투스타 참여
										If  Left(levelno,5)= "20102" Or  Left(levelno,5)=  "20105" then '투스타 
											in2to1 = 1 '실지로 사용되진 않음 아직은...다른식으로 처리중
										End if
									End if


									'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
									SQL = "select stateNO,playerIDX from tblplayer where playerIDX in ('"&m1pidx&"','"&m2pidx&"') "
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
									If Not rs.eof Then
											If Cstr(rs(1)) = Cstr(m1pidx) Then
												Select Case  CDbl(rs(0))
												Case 100  '한번 들어가면 계속 쭉 100상태임...
													m1upno = 1
												Case 200
													m1upno = 2
												Case Else 
													m1upno = 0
												End Select
											Else
												If Cstr(rs(1)) = Cstr(m2pidx) Then
													Select Case  CDbl(rs(0))
													Case 100  '한번 들어가면 계속 쭉 100상태임...
														m2upno = 1
													Case 200
														m2upno = 2
													Case Else 
														m2upno = 0
													End Select
												End If												
											End if
									End if

									insertvalue1 = " "&m1pidx&",'"&m1name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&gameday&"',"&getmallpt&" ,"&win&","&lose&","&winp&","&losep&","&windiff&","&ptdiff&","&m1upno&" , "&in2to1&" "
									insertvalue2 = " "&m2pidx&",'"&m2name&"',"&getpt&","&rankno&","&titlegrade&","&titlecode&","&tidx&",'"&title&"',"&Left(levelno,5)&",'"&teamnm&"','"&gameday&"',"&getmallpt&" ,"&win&","&lose&","&winp&","&losep&","&windiff&","&ptdiff&","&m2upno&" , "&in2to1&" "
									SQL = "insert into "&logtbl&" (PlayerIDX,userName, getpoint,rankno, titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,Gamedate,mallpoint,wincnt,lostcnt,winpoint,lostpoint,windiff,ptdiff,upgrade ,in2to1) values ("&insertvalue1&"), ("&insertvalue2&")"  'in2to1 원스타가 투스타에 참가했을때 1을 넣어서 구분할수 있도록 한다.
									Call db.execSQLRs(SQL , null, ConStr)		
	

								End if
							End if
							%>
							<%If CDbl(getmallpt) > 0 then%>
							<tr><td><%=rankno%></td><td><%=m1name%></td><td><%=m1team%></td><td><%=m2name%></td><td><%=m2team%></td></tr>
							<%End if%>
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
		SQL = "SELECT top 1 sortNo from "&strtable&" where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun >1  and DelYN = 'N'  and round = 1 order by sortno desc"
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

	'대진표 선수정보 가져오기
	Function getPlayerlist(ByVal tidx, ByVal levelno, ByVal lastroundmethod)
		Dim strwhere, strsort,strAfield, strBfield, strfield,SQL,rs     ,boo1,boo2,rnkcnt1,rnkcnt2
		If CDbl(lastroundmethod) = 1 Then '최종라운드 리그
			strwhere = "  a.delYN = 'N' and a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun in (0,1) " 
		else
			strwhere = "  a.delYN = 'N' and a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun >= 2 and a.playerIDX > 1 and a.sortNo > 0" 
		End if

		boo1 = " , (select belongBoo from "&ptbl&" where playerIDX = a.playerIDX)	as boo1 " '선수가 삭제된 경우 NULL
		boo2 = " , (select belongBoo from "&ptbl&" where playerIDX = b.playerIDX)	as boo2 "		

		rnkcnt1 = " , (select rankcnt from "&ptbl&" where playerIDX = a.playerIDX)	as rnkcnt1 " '입상횟수
		rnkcnt2 = " , (select rankcnt from "&ptbl&" where playerIDX = a.playerIDX)	as rnkcnt2 " 

		strsort = " order by a.Round asc,a.SortNo asc"
		strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
		strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno,b.playerIDX      ,t_rank  " &  boo1 & boo2 &  rnkcnt1 & rnkcnt2
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
		Dim fname,idx,rsi,SQL,rnkpidx, rnk2, rnk3, upmember
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
			rnkpidx = rs("playeridx")
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

									Response.write "<td style='text-align:left;padding-left:8px;'><input type='number' min='1' id='prank_"&idx&"' value='"&rsdata(i)&"' onblur=""if(this.value !=''){sd.changeRank("&idx&",this.value,"&levelno&")}"" style='height:30px;'>"
								

									If rndupchk = "체크여부" Then '체크안되게 막음
										'만약 부서가 (신인부 2개년도에 걸쳐 오픈부나 신인부에서 준우승 2회 또는 3위이상 4회입상경력) ############
										'신인부(오픈부) 랭킹 반영시에만 체크
										If Left(levelno ,5) = "20104" Or  Left(levelno ,5) = "20105" then

										If CDbl(rsdata(i)) <=4 Then
											'일시승격요건 (4강이내, 2년전부터)  내부 1등한건이 있다면 패스, 
											SQL = "select rankno from "&logtbl&" where playeridx = " & rnkpidx & " and rankno <= 4 and gamedate  > '" & dateAdd("yyyy", -2, Date()) & "' and teamGb in ( 20104 , 20105 ) " 
											Set rsi = db.ExecSQLReturnRS(SQL , null, ConStr)

											rnk2 = 0 '준우승 2회 체크
											rnk3 = 0 '3등이내 4회 체크
											upmember = False '우승자 체크 (외부 우승자인경우는 화면 전환 뒤 내용보고 파악)

											Do Until rsi.eof 
												If CDbl(rsi(0)) = 1 Then
													upmember = True '1회라도 우승한 사람 제외
												End If
												
												If CDbl(rsi(0)) = 2 Then '준우승 체크
													rnk2 = rnk2 + 1
												End If

												rnk3 = rnk3 + 1 '3등이상 횟수 체크
											rsi.movenext
											Loop
											
											If upmember = false Then
												If rnk2 > 1 Then
													oJSONoutput.RNKTYPE = 62
													oJSONoutput.PIDX = rnkpidx
													strjson = JSON.stringify(oJSONoutput)
													'Response.write "<a href='javascript:sd.setRanker("&strjson&")' class='btn'>일시승격처리(준우승2회)</a>"
												ElseIf rnk3 > 3 Then
													oJSONoutput.RNKTYPE = 63
													oJSONoutput.PIDX = rnkpidx
													strjson = JSON.stringify(oJSONoutput)
													'Response.write "<a href='javascript:sd.setRanker("&strjson&")' class='btn'>일시승격처리(3위이상 4회)</a>"
												Else
													oJSONoutput.RNKTYPE = 64
													oJSONoutput.PIDX = rnkpidx
													strjson = JSON.stringify(oJSONoutput)
													'Response.write "<a href='javascript:sd.setRanker("&strjson&")' class='btn_a'>일시승격대상미달</a>"
												End If
											Else
												'Response.write "자동승격자"
											End if
										End If

										End if
										'만약 부서가 (신인부 2개년도에 걸쳐 오픈부나 신인부에서 준우승 2회 또는 3위이상 4회입상경력) ############									
									End if



									Response.write "</td>"
								
								
								ElseIf fname = "획득포인트" Then
									'inparam = " 베테랑, 오픈, 왕중왕 중복 확인, 틀어갈곳 표시, 올해우승 양쪽들어감 정리필요"
									Response.write "<td><input type='number' min='1'  id='pt_"&idx&"' value='"&rsdata(i)&"' onblur=""if(this.value !=''){sd.changePt("&idx&",this.value,"&levelno&")}""  style='height:30px;width:98%;'>"&inparam&"</td>"
								
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
	SQL = "Select userName,rankno,getpoint,idx,PlayerIDX,titleCode from "&logtbl&" where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " and adminINdata = 'N'  order by rankno asc"
	Set rslog = db.ExecSQLReturnRS(SQL , null, ConStr)

	'If  Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
	'	Response.write levelno
	'End if

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
	reDim roundnoArr(6)
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

		lastrdgang = 0
		If CDbl(lastroundmethod) = 2 Then '최종라운드라면 1리그 2 토너먼트  2^
			SQL = "Select max(sortno) from "&strtable&" where gameTitleIDX = " & tidx & " and gamekey3 = " & levelno & " and round = 1"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If isnull(rs(0)) = True Then
				lastrdgang = 0
			Else
				lastrdgang = rs(0) '4강 8강 16강
			End If
		End if
		
		'같은부의 levelno,endRound 가져오기 
		SQL = " Select level,endRound,LastRchk from tblRGameLevel  where  DelYN = 'N' and  gameTitleIdx = " & tidx & " and teamgb = '"&Left(levelno,5)&"' and level <> '"&levelno&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if
















'##############################################
' 소스 뷰 경계
'##############################################
%>

<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=levelno%>-- <%=poptitle%>
	

	&nbsp;&nbsp;<a href="/resultexcel.asp?tidx=<%=tidx%>&levelno=<%=levelno%>"><i class="far fa-file-excel"></i></a>	

	</h3>   
  </div>
<!-- 헤더 코트e -->

<div class='modal-body game-ctr'>


	<div class="scroll_box"  id="orderinfo" style="height:200px;margin-top:5px;">
		<table class="table table-striped "><!-- set_tourney_table -->
		<tr><th>순위</th><th>이름</th><th>팀</th><th  style="width:100px;">이름</th><th>팀</th><tr>

		<%
		If CDbl(depthCnt) > 6 Then
			depthCnt = 6
		End if
		For i = 1 To depthCnt
			Call tournInfo(arrT, roundnoArr(i), i ,tidx,levelno,Trim(gametitle),teamnm,ranklist , lastroundmethod)
		Next

		
		'최종라운드라면 나머지 4명이외도 가져와야하니까
		If  tn_last_rd = True  Then
			Do Until rs.eof '최종라운드에 포함대 토너먼트
				nlevelno = rs("level")
				endround = rs("endRound") '진행할 마지막 라운드
				LastRchk = rs("LastRchk") '최종라운드 전 몇강까지 체크할지

				Select Case CDbl(endRound)
				Case 1 : hideRDcnt = 0
				Case 2 : hideRDcnt = 0
				Case 4 : hideRDcnt = 1
				Case 8 : hideRDcnt = 2
				Case 16 : hideRDcnt = 3
				Case 32 : hideRDcnt = 4
				Case 64 : hideRDcnt = 5
				End Select 



				ddarr = getDepthDrow(tidx,nlevelno)
				drowCnt = ddarr(1)				'참여자 128강
				depthCnt = ddarr(2)				'라운드수
				'If CDbl(depthCnt) > 6 Then	'32강이 넘는다면 강제 고정 ( 1개 짜리만)
				'	depthCnt = 6
				'End if

				reDim roundnoArr(depthCnt)

				arrT = getPlayerlist(tidx,nlevelno , 0)
				n = 1
				For i = depthCnt To 1 Step -1
					roundnoArr(n) = i '6,5,4,3,2,1
					'Response.write i & "<br>"
				n = n + 1
				Next
		
				'Response.write roundnoArr(1 + hideRDcnt) & "########<br>"	
				'Response.write hideRDcnt & "########<br>"	
				'Response.end

					'숨긴라운드 + 1 부터 
					stgang = LastRchk
					For i = 1 + hideRDcnt To depthCnt

						If CDbl(LastRchk) = 0 Then '입력안된상태라면
							Call tournInfo(arrT, roundnoArr(i), i+1 ,tidx,nlevelno,Trim(gametitle),teamnm,ranklist ,0)	 'arrRS ,  rd,  i , tidx, levelno, title, teamnm,  ranklist
						Else
							'roundnoArr(i) << 시작할 강위치
							Call tournInfo(arrT, roundnoArr(i), stgang ,tidx,nlevelno,Trim(gametitle),teamnm,ranklist ,0)	 'arrRS ,  rd,  i , tidx, levelno, title, teamnm,  ranklist
							stgang = CDbl(stgang)+ 1
							'Response.write stgang & "-------------$$$$$$$$$$$<br>"
						End if
					Next




			rs.movenext
			loop
		End if
		%>
		</table>
	</div>

















<%'If aaa = "안보임" then%>
	<!-- 개별 목록 수정삭제 -->
		<div id="printpoint" style="width:100%;margin:auto;height:50px;overflow:auto;text-align:center;font-size:18px;padding-top:3px;padding-bottom:8px;">
		포인트 정보 : <%Call printRPoint(levelno , titleGrade)%>
		<a href="javascript:if (window.confirm('적용된 랭킹이 모두 삭제된 후 다시 자동 계산 됩니다.')){sd.resetResult(<%=idx%>,<%=levelno%>,'<%=teamnm%>','<%=areanm%>')}" class="btn">전체 삭제 후 다시 반영</a>
		</div>


		<div id="orderinfo2"  class="scroll_box" style="height:250px;margin-top:5px;" >
		<%
		'인서트된 자료 다시검색
		SQL = "Select userName,rankno,getpoint,idx,PlayerIDX,titleCode from "&logtbl&" where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " order by rankno asc"
		Set rslog = db.ExecSQLReturnRS(SQL , null, ConStr)

If  Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
'	Response.write sql
'	Call rsdrow(rslog)
'	Response.end
End if		
		Call rsDrowEditor(rslog,levelno)%>
		</div>
	<!-- 개별 목록 수정삭제 -->

	<!-- 개별 목록 생성 -->
		<div id="orderinfo3" style="width:100%;margin:auto;height:30px;margin-top:3px;">
		<table class='table table-striped set_tourney_table'>
		<tr>
			<th>이름</th>
			<td style="width:150px;">
				<input type="text" id="pname"  style="margin-top:10px;width:200px;height:28px;">
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
<%'End if%>
</div>


<%
'If aaa = "안보임" then
	'인서트 자료가 있는지 확인겸 가져오기
	SQL = "Select top 1 userName,rankno,getpoint,idx,PlayerIDX,titleCode from "&logtbl&" where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " order by rankno asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		chk_titleCode = rs("titleCode")
	Else
		chk_titleCode = 0
	End If

	'포인트 만료  (1년단위로 만료되어야해서 제거)
	If CDbl(chk_titleCode) > 0 Then
		SQL = "Update "&logtbl&"  Set ptuse = 'N' where titleCode = " & chk_titleCode & " and teamGb = " & Left(levelno,5) & " and ptuse = 'Y' and titleIDX < " & tidx
		'Call db.execSQLRs(SQL , null, ConStr)
	End if
'End if


db.Dispose
Set db = Nothing










'누적포인트 저장(재설정시 뺀다)*****************
											'원스타 선수인경우 이번대회에 (랭킹들어간걸로 확인해서 두개 가 있다면 이번부의 포인트와 다른것의 포인트를 비교해서 큰것이 들어가도록 처리해준다.
	'										if boo1 = booarr(0) Or  boo1 = booarr(1) then
	'
	'											minv = 0
	'											maxv = 0
	'											logcnt = 0
	'											SQL = "select count(*), max(getpoint),min(gtpoint) from sd_TennisRPoint_log where titleidx =  " & tidx & " and playeridx = '" & m1pidx & "'"
	'											Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'												logcnt = rs(0)
	'												maxv = rs(1)
	'												minv = rs(2)
	'
	'												If CDbl(logcnt) > 1  Then '내값이 업데이트 된상태다...2개
	'													If CDbl(maxv) > CDbl(getpt) Then
	'														'이전들어간 값이  큰거다. 암거도 하지말자.
	'													ElseIf CDbl(minv) < CDbl(getpt) Then
	'														'getpt - minv 한만큼 업데이트
	'														SQL = "update " & ptbl  & " Set sdpoint = sdpoint +  " & getpt - minv  & " where playerIDX = '"&m1pidx&"'"
	'														Call db.execSQLRs(SQL , null, ConStr)
	'													ElseIf CDbl(maxv) = CDbl(getpt) And CDbl(minv) = CDbl(getpt) Then
	'														'두개의 값이 같은경우 이전값 그대로 두자.
	'													End if
	'												else
	'													SQL = "update " & ptbl  & " Set sdpoint = sdpoint +  " &getpt& " where playerIDX = '"&m1pidx&"'"
	'													Call db.execSQLRs(SQL , null, ConStr)
	'												End If
	'											End if
	'										if boo2 = booarr(0) Or  boo1 = booarr(2) then'								
	'
	'											minv = 0
	'											maxv = 0
	'											logcnt = 0
	'											SQL = "select count(*), max(getpoint),min(gtpoint) from sd_TennisRPoint_log where titleidx =  " & tidx & " and playeridx = '" & m2pidx & "'"
	'											Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'												logcnt = rs(0)
	'												maxv = rs(1)
	'												minv = rs(2)
	'
	'												If CDbl(logcnt) > 1  Then '내값이 업데이트 된상태다...2개
	'													If CDbl(maxv) > CDbl(getpt) Then
	'														'이전들어간 값이  큰거다. 암거도 하지말자.
	'													ElseIf CDbl(minv) < CDbl(getpt) Then
	'														'getpt - minv 한만큼 업데이트
	'														SQL = "update " & ptbl  & " Set sdpoint = sdpoint +  " & getpt - minv  & " where playerIDX = '"&m2pidx&"'"
	'														Call db.execSQLRs(SQL , null, ConStr)
	'													ElseIf CDbl(maxv) = CDbl(getpt) And CDbl(minv) = CDbl(getpt) Then
	'														'두개의 값이 같은경우 이전값 그대로 두자.
	'													End if
	'												else
	'													SQL = "update " & ptbl  & " Set sdpoint = sdpoint +  " &getpt& " where playerIDX = '"&m2pidx&"'"
	'													Call db.execSQLRs(SQL , null, ConStr)
	'												End If
	'
	'										Else
	'											SQL = "update " & ptbl  & " Set sdpoint = sdpoint +  " &getpt& " where playerIDX in ('"&m1pidx&"','"&m2pidx&"') "
	'											Call db.execSQLRs(SQL , null, ConStr)
	'										End If
'누적포인트 저장(재설정시 뺀다)*****************		
%>