<%
'#############################################
'랭킹포인트 셋팅
'#############################################

'request
midx =oJSONoutput.MIDX
levelno = oJSONoutput.LEVELNO 
tidx = oJSONoutput.TIDX
sno = oJSONoutput.SNO

Set db = new clsDBHelper

'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Function selectpoint(ByVal pidx , ByVal strwhere, ByVal per)
	Dim SQL , rs, point
	'부의 15개 포인트를 가져온다.
	SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y'  and  PlayerIDX = "&pidx&" and teamGb in "&strwhere&" order by getpoint desc )"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If isNull(rs(0)) = true Then
		point = 0
	Else
		point = rs(0)
	End If

	selectpoint = Fix(CDbl(point) / 100 * per)
End function	


Function setUserPoint(ByVal levelno, ByVal pidx)



	Dim point, pointA, strwhere,rs
	Select Case CDbl(Left(levelno,5))
	Case 20109  '가족부 이벤트성 포인트인것
		point = 0

	Case 20108,20107  '혼합복식,지도자부    예2) 혼복작성시 : 오픈부 100%, 베테랑부 80%, 신인부 70%, 국화부 50%, 개나리부 30%

		'오픈부 100%
		strwhere  = " (20105,20106)   "  
		point = selectpoint(pidx,strwhere, 100)
		'베테랑 80%
		strwhere  = "(20103)  "
		pointA = selectpoint(pidx,strwhere, 80)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End If
		'신인부 70%
		strwhere  ="(20104)    "
		pointA = selectpoint(pidx,strwhere, 70)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End if
	    '국화부 50%
		strwhere  = "(20102)  "
		pointA = selectpoint(pidx,strwhere, 50)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End if
	    '개나리 30%
		strwhere  = "(20101)  "
		pointA = selectpoint(pidx,strwhere, 30)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End if
	
	Case 20105,20106 '오픈부, 왕중왕부  지도자부(혼복처럼 랭킹없슴)
		

		'선수의 반영 부서가 베테랑 부라면 오픈부값을 추가한다.
		SQL = "select openrnkboo from tblplayer where playerIDX = " & pidx


		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		Dim boostr
		If Not rs.eof Then
			boostr = rs("openrnkboo")
		End if

		
		Select Case boostr 'rs(0)
		Case "베테랑부"
			'베테랑 80%
			strwhere  = "(20103,20105,20106)  "
			point = selectpoint(pidx,strwhere, 80)
		Case "신인부"
			'신인부 70%
			strwhere  ="(20104,20105,20106)     "
			point = selectpoint(pidx,strwhere, 70)
		Case Else 
			'오픈부 100%
			strwhere  = " (20105,20106)   "   'rnkboo > NNNNN 개나리, 국화, 신인 , 오픈, 베테랑(오픈 체크  NNNYY, NNYYY , NNNYN) 
			point = selectpoint(pidx,strwhere, 100)
		End Select 
		
	
	Case 20103 '베테랑부
		'선수의 반영 부서가 베테랑 부라면 오픈부값을 추가한다.
		SQL = "select openrnkboo from tblplayer where playerIDX = " & pidx & " and openrnkboo = '베테랑부' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof then
		strwhere  = "(" & Left(levelno,5)& ")   "
		Else
		strwhere  = "(" & Left(levelno,5)& ",20105,20106)  "
		End if
		point = selectpoint(pidx,strwhere, 100)




	Case 20102 '국화부
		strwhere  = "(20102)  "
		point = selectpoint(pidx,strwhere, 100)

	Case 20102 '개나리
		strwhere  ="("& Left(levelno,5) & ")"
		point = selectpoint(pidx,strwhere, 100)


	
	
	Case Else '신인부
		'선수의 반영 부서가 신인부 부라면 오픈부값을 추가한다.
		SQL = "select openrnkboo from tblplayer where playerIDX = " & pidx & " and openrnkboo = '신인부' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof then
		strwhere  = "(" & Left(levelno,5)& ")   "
		Else
		strwhere  = "(" & Left(levelno,5)& ",20105,20106)  "
		End if

		point = selectpoint(pidx,strwhere, 100)
	End Select 

	setUserPoint = point

End function


'##############################


Function getPlayerPoint(ByVal idx, ByVal levelno)
	Dim SQL ,rs
	Dim gameday,dblrnk,openrnkboo,chklevel,endRnkDate
	Dim myrnkboo,xmax,myattboo,arrRS

	SQL = "select gameday,dblrnk,openrnkboo,chkLevel,endRnkDate from tblPlayer where playerIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		getPlayerPoint = 0
		Exit function
	Else
		gameday = rs("gameday")
		dblrnk = rs("dblrnk")
		openrnkboo = rs("openrnkboo")
		If isnull(openrnkboo) = True Then
			openrnkboo = ""
		End If
		chklevel = rs("chkLevel")
		endRnkDate = rs("endRnkDate") '임의승급자 종료날짜
	End If

		If dblrnk = "Y" Then '	'만약 우승자라면
			Select Case  chklevel
			Case "20101"
				myrnkboo = "개나리부"
				xmax = 2
			Case "20105","20104","20106" ,"20103"
				myrnkboo = "신인부"  '오픈, 신인, 왕중왕, 베테랑부
				xmax = 3
			Case Else 
				'이런경우는 없다... 혹모르니 에러안나도록
				myrnkboo = chklevel
				xmax = 1
			End Select 
		else
			xmax = 1
			Select Case  openrnkboo
			Case "신인부" 
				myrnkboo = "신인부"
			Case "베테랑부" 
				myrnkboo = "베테랑부"
				xmax = 2
			Case else

				If isnull(chklevel) = True Or chklevel = "" then

					SQL = "select top 1 teamGbName from sd_TennisRPoint_log where  PlayerIDX = "&idx&"  and teamGbName in ('개나리부','국화부','신인부','왕중왕부','베테랑부','오픈부')  order by idx desc"
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

					If Not rs.eof then
					Do Until rs.eof 
						myattboo = rs(0)
						Select Case myattboo
						Case "개나리부"
							myrnkboo = "개나리부"
						Case "국화부" 
							myrnkboo = "국화부"

						Case "베테랑부" 
							myrnkboo = "베테랑부"
						Case "신인부" : myrnkboo = "신인부"
						Case "단체전","오픈부","왕중왕부" 
							myrnkboo = "오픈부"
						Case Else
							 myrnkboo = "랭킹없음"
						End Select 
					rs.movenext
					Loop
					Else
						 myrnkboo = "랭킹없음"
					End if

				
				Else
					Select Case chklevel
					Case "20101"
							myrnkboo = "개나리부"
					Case "20102"
							myrnkboo = "국화부"
					Case "20105","20106" 
							myrnkboo = "오픈부"
					Case "20103"
							myrnkboo = "베테랑부"
					Case Else
							myrnkboo = "알수없슴"
					End Select 
				End if			
			
			End Select


				
		end if

		'이건 남자부만 발생할수 있다.
		'중복 중 놉은 점수의 것의 인덱스 찾기
		subSQL = "SELECT titlename FROM sd_TennisRPoint_log where ptuse= 'Y' and PlayerIDX = "&idx&" group by titlename HAVING COUNT(titlename) > 1" '중복타이틀 찾기
		SQL = "select titlename from sd_TennisRPoint_log  where ptuse= 'Y' and PlayerIDX = "&idx&" and titlename in ("&subSQL&")  order by titlename, getpoint desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()
		End If

		strfield = "titleName as '대회명' ,teamGbName as '출전부서',rankno as '순위',getpoint as '포인트',ptuse as '반영', gamedate as '게임일자'  "
		SQL = "select "&strfield&"  from sd_TennisRPoint_log  where ptuse= 'Y' and PlayerIDX = "&idx&" order by getpoint desc, gamedate desc  "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		'Call rsdrow(rs)
		'Response.end

		Dim orderA,orderB,orderC,totalA,totalB,totalC,rscnt,overrapcnt,okpt, i, ar, pre,overrap
		Dim rsdata,xboonm,xorder,xpoint,xdate,x

			orderA = 1
			orderB = 1
			orderC = 1
			totalA = 0
			totalB = 0
			totalC = 0
			rscnt = Rs.Fields.Count
			overrapcnt = 0		

			ReDim rsdata(rscnt) '필드값저장

			Do Until rs.eof

				For i = 0 To rscnt - 1
					rsdata(i) = rs(i)
				Next
							okpt = True

							For i = 0 To rscnt - 1
							
								If i = 0 then
								If IsArray(arrRS) Then
								  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
									  overrap = arrRS(0, ar) '중복타이틀

									  If rsdata(i) = overrap Then

											If overrapcnt = 0  then
												okpt = true

												If  pre = "" Or overrap = pre Then
													overrapcnt = 1
												Else
													overrapcnt = 0
												End If
												pre = overrap
												Exit For
											Else
												okpt = false
												If  pre = "" Or overrap = pre Then
													overrapcnt = 1
												Else
													overrapcnt = 0
												End If
												pre = overrap
											End If
									  End If
								  Next

								End If
								End if

								
								If i = 1 Then '출전부
									xboonm = rsdata(i)
								End If

								If i = 2 Then '순위
									xorder = rsdata(i)
								End If

								If i = 3 Then '포인트
									xpoint = rsdata(i)
								End If

								If i = 5 Then '게임데이트
									xdate = rsdata(i)
								End If

								If i = 5 Then '게임일자 다음에 그리기
									
									For x = 1 To xmax
										
										If dblrnk = "Y" then
											Select Case  myrnkboo 
											Case "개나리부"
												Select Case x '여자는 중복참여불가 
												Case 1
													If orderA <= 15 then
														If CDbl(xorder) < 512 And xboonm = "개나리부" Then '512는 참가점수
															totalA = totalA + xpoint
															orderA = orderA + 1
														End if
													End if
												Case 2
													If xboonm = "국화부" then
														If  CDate(Left(xdate,10)) > CDate(Left(gameday,10)) Then
															If orderB <= 15 then
																totalB = totalB + xpoint
																orderB = orderB + 1
															End if
														End If
													End if
												End Select
											Case "신인부"
												Select Case x 
												Case 1
													If orderA <= 15 Then
														If okpt = True then
															totalA = totalA + xpoint
															orderA = orderA + 1
														End if
													End if
												Case 2
													If xboonm = "오픈부" Or xboonm = "왕중왕부" then
														If  CDate(Left(xdate,10)) > CDate(Left(gameday,10)) Then
															If orderB <= 15 then
																totalB = totalB + xpoint
																orderB = orderB + 1
															End if
														End If
													End if
												End Select 

											Case "베테랑부" '##################################2월 13일 국장요청 수정( 베테랑 소속시 베테랑 , 신인부 각각 표시)
												Select Case x '중복참여가능 
												Case 1 '신인부
													If xboonm = "신인부" then
														If orderA <= 15 then
														totalA = totalA + xpoint
														orderA = orderA + 1
														End if
													End if
												Case 2
													If xboonm = "베테랑부" Or xboonm = "단체전" Or xboonm = "오픈부" Or xboonm = "왕중왕부"  then
															If orderB <= 15 then
																totalB = totalB + xpoint
																orderB = orderB + 1
															End if
													End if
												End Select										

											Case Else 
												'베테랑
												If orderA <= 15 then
												totalA = totalA + xpoint
												orderA = orderA + 1
												End if											
											End Select 

										Else '==================================================================================================================================
											Select Case myrnkboo
											Case "베테랑부" '##################################2월 13일 국장요청 수정( 베테랑 소속시 베테랑 , 신인부 각각 표시)

												Select Case x '중복참여가능 
												Case 1 '신인부
													If xboonm = "신인부" then
														If orderA <= 15 then
														totalA = totalA + xpoint
														orderA = orderA + 1
														End if
													End if
												Case 2
													If xboonm = "베테랑부" Or xboonm = "단체전" Or xboonm = "오픈부" Or xboonm = "왕중왕부"  then
															If orderB <= 15 then
																totalB = totalB + xpoint
																orderB = orderB + 1
															End if
													End if
												End Select

											Case Else
												If myrnkboo = xboonm then
													If orderA <= 15 then
														If okpt = True Then '중복참여처리
															totalA = totalA + xpoint
															orderA = orderA + 1
														End if
													End If
												End if
											End Select 
										End if
									Next
									
								End if

							Next
						%>
				<%
			rs.movenext
			Loop

			If Not rs.eof then
			rs.movefirst
			End If
			
			'Response.write "#########################################<br>"
				'For x = 1 To xmax
				'	Select Case x
					'Case 1: 	Response.write totalA & "<br>"
					'Case 2: 	Response.write totalB & "<br>"
					'Case 3: 	Response.write totalC & "<br>"
				'	End select
				'Next
			'Response.write "#########################################<br>"

			Select Case myrnkboo
			Case "개나리부"
				If levelno = "20101" Or levelno = "20102" Then
				Else
					levelno = "x" & levelno 
				End if
			Case "국화부"
				If levelno = "20102" Then
				Else
					levelno = "x" & levelno 
				End if
			Case "베테랑부"
				If levelno = "20103" Or levelno = "20105"  Then
				Else
					levelno = "x" & levelno 
				End if
			Case "신인부"
				If levelno = "20104" Or levelno = "20105"  Then
				Else
					levelno = "x" & levelno 
				End if
			Case "오픈부"
				If levelno = "20105"  Then
				Else
					levelno = "x" & levelno 
				End if
			End Select



			Select Case levelno
			Case "20101" 
					getPlayerPoint = totalA
			Case "20102" '국화
				If dblrnk = "Y" Then '	'만약 우승자라면
					getPlayerPoint = totalB
				Else
					getPlayerPoint = totalA
				End if
			Case "20103" '베테랑
					getPlayerPoint = totalB
			Case "20104" '신인
					getPlayerPoint = totalA
			Case "20105" '오픈
				If dblrnk = "Y" Then '	'만약 우승자라면
					getPlayerPoint = totalB
				Else
					getPlayerPoint = totalA
				End If
			Case else
				'다시구함
				getPlayerPoint = setUserPoint(Mid(levelno ,2) , idx)
			End Select 
End Function 
'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



strtable = "sd_TennisMember"
strtablesub =" sd_TennisMember_partner "

strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.gubun in ( 0, 1) and a.DelYN = 'N' and a.playerIDX > 1 and a.gameMemberIDX > " & midx
strfield = " a.gameMemberIDX, a.PlayerIDX,b.PlayerIDX,a.userName,b.userName "
sortstr = " order by a.gameMemberIDX asc "
SQL = " Select top 1 " & strfield & " from  " & strtable & " as a LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX where " & strwhere & sortstr
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


If rs.eof Then
	'setrnkpt 업데이트
	SQL = "update tblRGameLevel Set  setrnkpt = 'Y' where GameTitleIDX = "&tidx&" and Level = '"&levelno&"'"
	Call db.execSQLRs(SQL , null, ConStr)
	nextmidx = 0 '끝
Else
	nextmidx = rs(0)
	p1idx = rs(1)
	p2idx = rs(2)
	p1name = rs(3)
	p2name = rs(4)


	'p1point = setUserPoint(levelno, p1idx)
	'p2point = setUserPoint(levelno, p2idx)
	p1point = getPlayerPoint(p1idx,levelno)
	p2point = getPlayerPoint(p2idx,levelno)
	



	If CDbl(p1point) >= 0 then
		SQL = "update sd_TennisMember set rankpoint = "&p1point&"  where gameMemberIDX = " & nextmidx
		Call db.execSQLRs(SQL , null, ConStr)
	End If
	If CDbl(p2point) >= 0 then	
		SQL = "update sd_TennisMember_partner set rankpoint = "&p2point&"  where gameMemberIDX = " & nextmidx
		Call db.execSQLRs(SQL , null, ConStr)	
	End if


	'랭킹포인트 로그에 반영 (화면 호출시 생성)
	point = CDbl(p1point) + CDbl(p2point)
	SQL = "update sd_TennisScore Set rankingpoint = '"&point&"' where PlayerIDX = "&p1idx&" and partnerIDX = "&p2idx&"  and key1 = "&tidx&" and key3 = " & Left(levelno,5) & " and delYN = 'N' "
	Call db.execSQLRs(SQL , null, ConStr)

End if



'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
oJSONoutput.MIDX = nextmidx
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


Response.write  p1idx  & "----------" & p1name & " : " & p1point & " --- " & p2name & " : " & p2point  & " <br>"

db.Dispose
Set db = Nothing
%>