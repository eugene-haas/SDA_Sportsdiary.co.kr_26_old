<%
'#############################################

'리그테이블 생성

'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then
		tidx = oJSONoutput.TIDX
	End If

	If hasown(oJSONoutput, "LNO") = "ok" Then
		gbidx = oJSONoutput.LNO 'levelno
	End If

	If hasown(oJSONoutput, "TNO") = "ok" Then
		tno = oJSONoutput.TNO '참가수
	End If


	If hasown(oJSONoutput, "CALLTYPE") = "ok" Then
		calltype = oJSONoutput.CALLTYPE  'make drow
	End If

	If hasown(oJSONoutput, "OPENRC") = "ok" Then  '결과노출여부
		openrc = chkStrRpl(oJSONoutput.OPENRC,"")
	End If


	If CDbl(tno) <=8 Then
		rndno = 8
		rndcnt = 4
	ElseIf CDbl(tno) >8 And CDbl(tno) <=16 Then
		rndno = 16
		rndcnt = 5
	ElseIf CDbl(tno) >16 And CDbl(tno) <=32 Then
		rndno = 32
		rndcnt = 6
	End if
	

'nextSortNo = Fix(CDbl(sortno) /2)  '짝수만 오니까
'nextRound = CDbl(rno) + 1 '최종라운드여부 확인
	

	Set db = new clsDBHelper

	'테이블 insert #############################################################################
	If calltype = "make" then

		SQL = "Select count(*) from sd_tennisMember where gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and delyn = 'N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		tno = rs(0)

		'토너먼트 순서 배정
		Select Case tno 
		Case 5,6,7,8 
		tablernd  = 8
		Case 9,10,11,12,13,14,15,16 
		tablernd = 16
		Case Else 
		tablernd = 32
		End Select

		'부전상대 생성
		If tablernd - tno > 0 then
			'temp 부전 생성
			ifld = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,pubcode,pubname "
			sfld = " 1, GameTitleIDX,0,'부전',gamekey1,gamekey2,gamekey3,TeamGb,key3name,pubcode,pubname "
			mselect = "select top "&CDbl(tablernd - tno)&" "&sfld&" FROM SD_tennisMember Where gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"'  and delyn = 'N' "

			'insert 	
			SQL = " insert into SD_tennisMember ("&ifld&") " & mselect
			Call db.execSQLRs(SQL , null, ConStr)

			Selecttbl = "( SELECT tryoutgroupno,tryoutsortNo,RANK() OVER (Order By gameMemberidx asc) AS RowNum FROM SD_tennisMember where  gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"'  and delyn = 'N'  ) AS A "
			SQL = "UPDATE A  SET A.tryoutgroupno = '1',A.tryoutsortNo = A.RowNum FROM " & Selecttbl '참고 *  대진표 한번으로 끝 우선 가입순으로 생성한다.
			Call db.execSQLRs(SQL , null, ConStr)
		End if
		'부전상대 생성


		
		fld = " a.gameMemberidx,a.playeridx,a.username,a.tryoutgroupno,a.tryoutsortno,a.gamekey3,a.gametitleidx,a.pubname   ,b.playeridx,b.username "
		SQL = "Select "&fld&" from sd_tennisMember as a left join  sd_tennisMember_partner as b on a.gameMemberidx = b.gameMemberidx  where a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&gbidx&"' and a.delyn = 'N' order by a.tryoutsortno "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		arr = rs.GetRows()

		'라운드 정보 insert L :left(위)    R:right(아래)
		nextcnt = rndno
		nextrndcnt = getN(rndno)


		'기존 테이블 대진표 삭제
		fld = " tidx,gbidx,midxL,midxR,teamL,teamR,teamnmL,teamnmR,   gangno,roundno,orderno,sidonmL,sidonmR     ,hidxL,hidxR,hnmL,hnmR" '말정보도
		SQL = "delete from  sd_gameMember_vs where tidx = "&tidx&" and gbidx = '"&gbidx&"' "
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = ""


		 For n = 1 To nextrndcnt '1,3,5,....
			nextcnt = nextcnt / 2

			'8/2 = 4
			'4/2 = 2
			'2/1 = 1

			For m = 1 To nextcnt
				'Response.write "라운드 : " & n + 1 & " 강수 : "& nextcnt *2 & " 라운드 : "&n&" <br>"
				If m = 1 Then
					sortno = m
				Else
					sortno = m + sortno
				End if
				
				If n = 1 And m = 1 Then 

					If IsArray(arr) Then 
						For x = LBound(arr, 2) To UBound(arr, 2)
							If x = 0 then
								gbidx = arr(5,x)
								tidx = arr(6,x)
							End if

							If x Mod 2 = 1 Then ' 아래 오른쪽 (부전인 경우 승패 생성, 다음 라운드 소팅값 계산) 
								midxR = arr(0,x)
								teamR = arr(1,x)
								teamnmR = arr(2,x)
								sidoR = arr(7,x)  'pubname 고등부
								hidxR = arr(8,x)
								hnmR = arr(9,x)

								If teamL = "0" And teamR = "0" Then
									'다음라운드 결과(부전 + 부전)
									invalue = " "&tidx&","&gbidx&","&midxL&","&midxR&",'"&teamL&"','"&teamR&"','"&teamnmL&"','"&teamnmR&"'  , "&nextcnt *2&","&n&","&x&" ,'"&sidoL&"','"&sidoR&"' "
									invalue = invalue & "  ,'"&hidxL&"','"&hidxR&"','"&hnmL&"','"&hnmR&"' "
									SQL = SQL & " insert into  sd_gameMember_vs ("&fld&" ) values ("&invalue&") "  '& "<br>"

								ElseIf teamL = "0" Then '부전(홀)
									
									invalue = " "&tidx&","&gbidx&","&midxL&","&midxR&",'"&teamL&"','"&teamR&"','"&teamnmL&"','"&teamnmR&"'  , "&nextcnt *2&","&n&","&x&" ,'"&sidoL&"','"&sidoR&"' "
									invalue = invalue & "  ,'"&hidxL&"','"&hidxR&"','"&hnmL&"','"&hnmR&"' "
									SQL = SQL & " insert into  sd_gameMember_vs ("&fld&",winmidx,result ) values ("&invalue&","&midxR&",'R') "   '& "<br>"

								ElseIf teamR = "0" Then '부전(짝)
									invalue = " "&tidx&","&gbidx&","&midxL&","&midxR&",'"&teamL&"','"&teamR&"','"&teamnmL&"','"&teamnmR&"'  , "&nextcnt *2&","&n&","&x&" ,'"&sidoL&"','"&sidoR&"' "
									invalue = invalue & "  ,'"&hidxL&"','"&hidxR&"','"&hnmL&"','"&hnmR&"' "
									SQL = SQL & " insert into  sd_gameMember_vs ("&fld&",winmidx,result ) values ("&invalue&","&midxL&",'L') "   '& "<br>"

								Else
									invalue = " "&tidx&","&gbidx&","&midxL&","&midxR&",'"&teamL&"','"&teamR&"','"&teamnmL&"','"&teamnmR&"'  , "&nextcnt *2&","&n&","&x&" ,'"&sidoL&"','"&sidoR&"' "
									invalue = invalue & "  ,'"&hidxL&"','"&hidxR&"','"&hnmL&"','"&hnmR&"' "
									SQL = SQL & " insert into  sd_gameMember_vs ("&fld&" ) values ("&invalue&") "  '& "<br>"
								End If


								'Response.write ""&nextcnt *2&","&n&","&x&" <br>"
							Else '위 왼쪽

								midxL = arr(0,x)
								teamL = arr(1,x)
								teamnmL = arr(2,x)
								sidoL = arr(7,x) 'pubname 고등부
								hidxL = arr(8,x)
								hnmL = arr(9,x)
							End if
						Next 

					End if

				ElseIf n > 1 then '이후 결과 저장 필드 

					If IsArray(arr) Then 
					invalue = " "&tidx&","&gbidx&",'','','','','',''  , "&nextcnt *2&","&n&","&sortno&",'','' "
					invalue = invalue & "  ,'','','','' "
					SQL = SQL & " insert into  sd_gameMember_vs ("&fld&" ) values ("&invalue&") " ' & <br>
					End if

				End If
				
			next
		
		Next

		'3 4위전 필드 추가 
		'#####################
		invalue = " "&tidx&","&gbidx&",'','','','','',''  , 0,0,1,'','' "
		invalue = invalue & "  ,'','','','' "
		SQL = SQL & " insert into  sd_gameMember_vs ("&fld&" ) values ("&invalue&") " ' & <br>
		'#####################

		
		Call db.execSQLRs(SQL , null, ConStr)
		'Response.write sql
		'Response.end

		'부전승 필드 업데이트 
		SQL = "select midxL,midxR,teamL,teamR,teamnmL,teamnmR ,roundno  ,orderno  "
		SQL = SQL & ",(case when midxL =  winmidx then 'W' else 'L' end) as LWL, (case when midxR =  winmidx then 'W' else 'L' end) as RWL "
		SQL = SQL & "  from sd_gameMember_vs where tidx = "&tidx&" and gbidx = '"&gbidx&"' and roundno = 1 and delYN= 'N' " 'and (midxL =  winmidx  or midxR = winmidx) "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		arrUp = rs.GetRows()

'Call getrowsdrow(arrup)
'Response.write UBound(arrUp, 2) & "<br>"

		If IsArray(arrUp) Then  '부전이니까 업데이트 할대상을 찾자.
			For x = LBound(arrUp, 2) To UBound(arrUp, 2)
					midxL = arrUP(0,x)
					midxR = arrUP(1,x)
					teamL = arrUP(2,x)
					teamR = arrUp(3,x)
					teamnmL = arrUp(4,x)
					teamnmR = arrUp(5,x)
					roundno = arrUp(6,x)
					orderno = arrUp(7,x)
					LWL = arrup(8,x)
					RWL = arrup(9,x)

					nextroundno = CDbl(roundno) + 1
					nextorderno =  Fix(CDbl(orderno/2)) 

					If nextorderno Mod 2 = 0 Then '짝수라면
						nextorderno =  nextorderno + 1
					End if

					
					
					If x Mod 2 = 0 Then '짝수면 왼족에 넣고
						inLR = "L"
					Else '홀수면 오른쪽에 넣고
						inLR = "R"
					End If

					
					If LWL = "W" Then
						strwhere = " tidx = "&tidx&" and gbidx = '"&gbidx&"' and delYN= 'N' and roundno="&nextroundno&" and orderno = "&nextorderno&" "
						SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxL&" , team"&inLR&" = '"&teamL&"', teamnm"&inLR&" = '"&teamnmL&"' where " & strwhere


'Response.write sql & "---LWL  "&x&"<br>"
						Call db.execSQLRs(SQL , null, ConStr)
					End If

					If RWL = "W" Then
						strwhere = " tidx = "&tidx&" and gbidx = '"&gbidx&"' and delYN= 'N' and roundno="&nextroundno&" and orderno = "&nextorderno&" "
						SQL = " update sd_gameMember_vs set midx"&inLR&" = "&midxR&" , team"&inLR&" = '"&teamR&"', teamnm"&inLR&" = '"&teamnmR&"' where " & strwhere
						Call db.execSQLRs(SQL , null, ConStr)

'Response.write sql & "---RWL "&x&"<br>"					
					End If					

			Next
		End if

'Response.end


		'nextSortNo = Fix(CDbl(sortno) /2)  '짝수만 오니까
		'nextRound = CDbl(rno) + 1 '최종라운드여부 확인
		'1 / 2 = 0 + 1 /왼쪽에 넣고
		'3 / 2 = 1	   /오른쪽
		'5 / 2 = 2 + 1 /왼쪽
		'7 / 2 = 3      /오른쪽

		SQL = "update sd_tennisMember set gubun = '3' where gametitleidx =  '"&tidx&"' and gamekey3 = '"&gbidx&"' and delyn = 'N' "
		Call db.execSQLRs(SQL , null, ConStr)	
	End if
	'테이블 insert #############################################################################




	'대진표 JSON ################################################################################
	nextcnt = rndno
	nextrndcnt = getN(rndno)
	ReDim rndcntarr(nextrndcnt-1) '8 강 3개 (0 부터 만들기)
	 For n = 0 To nextrndcnt-1
		nextcnt = nextcnt / 2
		rndcntarr(n) = nextcnt
	Next

	If openrc = "Y" Or openrc = "" then
	fld = " idx,tidx,gbidx,midxL,midxR,teamL,teamR,teamnmL,teamnmR,scoreL,scoreR,winmidx,result,gangno,roundno,orderno "
	fld = fld &  " ,(case when midxL =  winmidx then 'W' else 'L' end) as LWL, (case when midxR =  winmidx then 'W' else 'L' end) as RWL   "
	Else
	fld = " idx,tidx,gbidx,midxL,midxR,teamL,teamR,teamnmL,teamnmR,'-' as scoreL,'-' as scoreR,winmidx,result,gangno,roundno,orderno "
	fld = fld &  " ,'L' as LWL, 'L' as RWL   "
	End if

	SQL = "Select " & fld & " from sd_gameMember_vs where tidx = "&tidx&" and gbidx = '"&gbidx&"' and gangno > 0 and delyn = 'N' order by roundno , orderno"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	jsonstr =""
	For m = 0 To ubound(rndcntarr) '라운드갯수만큼

	   If m = 0 then
			startcnt = 0
			endcnt = rndcntarr(m)
			listarr = jsonTors_SE(rs , startcnt, endcnt)
			Set list = JSON.Parse( join(array(listarr)) )
			strjson = JSON.stringify(list)
			jsonstr = """round_"&m+1&""":" & strjson
	   Else
			startcnt = endcnt
			endcnt = endcnt + CDbl(rndcntarr(m))
			
			rs.movefirst
			listarr = jsonTors_SE(rs , startcnt, endcnt)
			Set list = JSON.Parse( join(array(listarr)) )
			strjson = JSON.stringify(list)
			jsonstr = jsonstr &",""round_"&m+1&""":" & strjson
	   End If
	   
	Next


	If calltype = "make" Then
		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	Else
		jsonstr = "{""TotalRound"":"&rndno&"," & jsonstr & "}"
		Response.write jsonstr
	End if
	'대진표 JSON ################################################################################


	Set rs = Nothing
	db.Dispose
	Set db = Nothing	




%>