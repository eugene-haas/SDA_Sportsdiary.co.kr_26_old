<%

	Sub drowLeageUSER(arr, arrs, drtype)
		Dim gbidx,tidx,lno, x, y , x_midx,y_midx,x_teamnm,y_teamnm, SQL ,x_team,y_team,x_sido,y_sido
		Dim r_idx, t,L_team,R_team,L_score,R_score, winmidx,endstr,x_orderno,left_midx

		If IsArray(arr) Then
		gbidx = arr(6,0)
		tidx = arr(7,0)
		lno = arr(8,0)

		'기존 리그 테이블 대진표 삭제
		'SQL = "delete from sd_gameMember_vs where tidx = "&tidx&" and levelno = '"&lno&"' "
		%>
		<div class="box-header" style="margin-top:10px;">

		<div class="box">
		<table class="table">
		<%
			For x = LBound(arr, 2) To UBound(arr, 2) + 1 '세로 Y
				If x =0 then
					x_midx = arr(0,x)
					x_team = arr(1,x)
					x_teamnm =  arr(2,x)
					x_sido = arr(10,x)

					x_orderno = arr(11, x) '순위
				Else
					x_midx = arr(0,x-1)
					x_team = arr(1,x-1)
					x_teamnm =  arr(2,x-1)
					x_sido = arr(10,x-1)
					x_orderno = arr(11, x-1) '순위
				End if

				Response.write "<tr style=""height:30px;"">"
				For y = LBound(arr, 2) To UBound(arr, 2) + 2 '가로 X
					If y > 0 And y < UBound(arr, 2) + 2  Then
						y_midx = arr(0,y-1)
						y_team = arr(1,y-1)
						y_teamnm =  arr(2,y-1)
						y_sido = arr(10,y-1)
					ElseIf y = UBound(arr, 2) + 2 Then '순위
						y_midx = ""
						y_team = ""
						y_teamnm =  "순위"
						y_sido = ""
					End if

					If x = 0 And y = 0 Then
						%><td class="backslash"></td><%
					elseIf y = 0  then
						%><td><%=shortNm(x_teamnm)%></td><%
					ElseIf x = 0 Then '순위
						%><td><%=shortNm(y_teamnm)%></td><%
					Else
					If x = y Then
						%><td class="backslash"></td><%
					else
						If x > y Then
							%><td style="color:#E9E8E8;" disabled><%=shortNm(x_teamnm)%> vs <%=shortNm(y_teamnm)%></td><%
						else
							If y = UBound(arr, 2) + 2 Then '##
								left_midx = arr(0, x-1)
							%><td><%=x_orderno%><!-- 순위 --></td><%
							else

								If IsArray(arrs) Then
								r_idx = ""
								endstr = ""
								For t = LBound(arrs, 2) To UBound(arrs, 2)
									idx = arrs(0,t)
									L_team = arrs(3, t)
									R_team = arrs(4, t)
									L_score = arrs(5, t)
									R_score = arrs(6, t)
									winmidx = arrs(7, t)
									If L_team = x_team And R_team= y_team Then
										r_idx = idx
										If isnull(winmidx ) = False Then
											If L_score > R_score then
											endstr = "<span style='color:red'>" & L_score & "</span> : " & R_score
											Else
											endstr = L_score & " : <span style='color:red'>" & R_score & "</span>"
											End if
										End if
									End if
								Next
								End if

							%>
							<td>
							<%If endstr = "" then%>
							경기전
							<%else%><!-- mx.soogooWindow(<%=r_idx%>) -->
							<button type="button" class="btn btn-block btn-default" onclick="mx.showJumsoo(<%=r_idx%>)"><%=endstr%></button>
							<%End if%>
							</td><%
							End if
						End if
					End if
					End if
				next
				Response.write "</tr>"
			Next

		%>
		</table>
		</div>
		</div>
		<%
		End if

	End sub

'#############################################
'대회결과
'#############################################
	Set db = new clsDBHelper

	tidx = fInject(oJSONoutput.get("TIDX"))
	levelno = fInject(oJSONoutput.get("LNO"))
	lidx = fInject(oJSONoutput.get("LIDX"))
	joo = fInject(oJSONoutput.get("JOONO"))

	If hasown(oJSONoutput, "UNM") = "ok" Then '이름으로 검색할때 보냄
		unm = fInject(oJSONoutput.UNM)
	End if

	If hasown(oJSONoutput, "SHOWTYPE") = "ok" then
		showtype = fInject(oJSONoutput.SHOWTYPE)

		If showtype = "result" Then '대회결과 출력 화면
			showtype = "gameresult"
		End if
	End if

'response.write showtype & "@@@@@@@@@@@@@@@@@@@@"

		starttypeq = "(select top 1 starttype from sd_gameMember where delyn = 'N' and gametitleidx = a.gametitleidx and levelno = a.levelno ) as starttype "
		fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2, resultopenAMYN,resultopenPMYN, "  & starttypeq
		strWhere = " a.RGameLevelidx = "&lidx&"  and a.delyn= 'N' "

		SQL = "Select top 1 " & fld & " from tblRGameLevel as a where " & strWhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			fr = rs.GetRows()

			If IsArray(fr) Then
				'오전경기에서 예선찾기
					gubunam = fr(12,0)
					gubunpm = fr(13,0)
					starttype = fr(18,0)
					CDA = fr(5,0)
					CDB = fr(7,0)
					CDC = fr(9,0)
					CDBNM = fr(8,0)
					CDCNM =  fr(10,0)
					CDBNMS = fr(10,0)

					If gubunam = "1" Or gubunpm = "1" Then '예선
						'오전경기
						fldtype = "tryout"

						If gubunam = "1" Then
							now_joo = 1
							joono = fr(14,ari)
							openRC = fr(16, 0)
							ampm = "am"
							itgubun = fr(4,0)
						End If

						'오후경기에서 예선찾기
						If joono = "" then
							If gubunpm = "1" Then
								now_joo = 1
								joono = fr(15,0)
								openRC = fr(17, 0)
								ampm = "pm"
								itgubun = fr(4,0)
							End If
						End If

					Else '결승

						If starttype = "3" Then
						fldtype = "tryout"
						Else
						fldtype = "final"
						End if

						'오전경기
						If gubunam = "3" Then
							joono = fr(14,ari)
							now_joo = 1
							openRC = fr(17, 0)
							ampm = "am"
							itgubun = fr(4,0)
						End If

						'오후경기에서 예선찾기
						If joono = "" then
							If gubunpm = "3" Then
								now_joo = 1
								joono = fr(15,0)
								openRC = fr(17, 0)
								ampm = "pm"
								itgubun = fr(4,0)
							End If
						End If
					End If

				'####################################
				If showtype = "gameresult" Then '대회결과출력이라면
						If gubunam = "3" then
						openRC = fr(16, 0)
						ampm = "am"
						End If
						If gubunpm = "3" then
						openRC = fr(17, 0)
						ampm = "pm"
						End if
				End If

				Select Case CDA
				Case "D2" '경영
					joogmook = "경영"
				Case "E2" '다이빙/수구
					If CDC = "31" Then
						joogmook = "수구"
					Else
						joogmook = "다이빙"
					End if
				Case "F2" '아티스틱
					joogmook = "아티스틱"
				End Select

				'경영외 설정
				select case CDA 
				case "E2"
					fldtype = "tryout"
					openRC = fr(16, 0)
				case "F2"
					fldtype = "tryout"
					if fr(16, 0) = "Y" and fr(17, 0) = "Y" then
					openRC = "Y"
					end if
				End select 

			End if

		End If

		If joo <> "" Then
			now_joo = joo
		End if

		'Response.write "결승<br>"
		'Response.write starttype & "타입<br>"
		'Response.write openRC & "오픈<br>"
		'response.write showtype 'tbl 수구 테이블형태
		'response.write cda

		fldnm = " (case when itgubun = 'I' then userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm "


		'gameResult > 0 and gameResult < 'a'
		If showtype = "gameresult" Then '대회결과출력이라면

			If starttype = "3" Then '결승으로 시작한경기
				'tryouttotalorder 전체순위가 되고
				If cda = "D2" then '경영'
				fld = " tryoutsortno,"&fldnm&",sidonm,teamnm,userClass,tryouttotalorder,tryoutresult,  '', gameMemberIDX , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '--' end) as birthday    ,g1korsin,g1gamesin "
				SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and tryoutsortno > 0 order by convert(int, isnull(tryouttotalorder,'9999'))   "
				Else
				fld = " tryoutsortno,"&fldnm&",sidonm,teamnm,userClass,tryouttotalorder,tryoutresult,  '', gameMemberIDX , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '--' end) as birthday    ,g1korsin,g1gamesin  "
				SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and tryoutsortno > 0 order by  convert(int, isnull(tryouttotalorder,'9999'))  "
				End If

			Else
				'gameorder 가 전체순위
				fldnm = " (case when itgubun = 'I' then userName  else  (SELECT  STUFF(( select ','+ username from sd_gameMember_partner where gamememberidx  = a.gamememberidx group by username for XML path('') ),1,1, '' ))  end) as nm "
				fld = " sortno,"&fldnm&",sidonm,teamnm,userClass,gameorder,gameresult,  '', gameMemberIDX  , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '--' end) as birthday ,    g2korsin,g2gamesin "
				SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and sortno > 0  order by  isnull(gameorder,'9999')  asc"
			End If

		else
			If fldtype = "tryout" Then
				If CDA = "D2" then
				'tblRGameLevel.resultopenAMYN '오픈여부
				fld = " tryoutsortno,"&fldnm&",sidonm,teamnm,userClass,tryoutorder,tryoutresult,tryouttotalorder    ,gameMemberIDX , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '--' end) as birthday ,g1korsin,g1gamesin"
				SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and tryoutgroupno = '"&now_joo&"' and tryoutsortno > 0 order by isnull(tryoutsortno,'9999') asc"

				Else

				fld = " tryoutsortno,"&fldnm&",sidonm,teamnm,userClass,tryoutorder,tryoutresult,tryouttotalorder    ,gameMemberIDX , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '--' end) as birthday ,g1korsin,g1gamesin"
				SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and tryoutsortno > 0 order by isnull(tryoutsortno,'9999') asc"

				End if
			Else
				'tblRGameLevel.resultopenPMYN
				fld = " sortno,"&fldnm&",sidonm,teamnm,userClass,gameorder,gameresult,  '', gameMemberIDX , (case when itgubun = 'I' then (select top 1 birthday from tblplayer where playeridx = a.playeridx) else '--' end) as birthday  ,g2korsin,g2gamesin"
				SQL = "select "&fld&" from  sd_gameMember as a  where DelYN = 'N' and GameTitleIDX = "&tidx&" and levelno = '"&levelno&"' and roundno = '"&now_joo&"' and sortno > 0  order by isnull(sortno,'9999') asc"
			End If

		End If
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


if (CDA = "E2" And CDC = "31")  then '수구라면(대진표만) 조건에 And showtype = "" 이거 붙여놓았던데 왜그랬을까 ?? 일딴 제거  2020,12-24 by baek  내용파악까지는 못함

		fld = "gameMemberidx,team,teamnm,starttype,tryoutgroupno,tryoutsortno,gbidx,gametitleidx,levelno,gubun,sidonm,tryouttotalorder,requestidx ,tabletype " 'tabletype N L T 설정전, 리그, 토너먼트
		SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'  order by tryoutsortno "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'call rsdrow(rs)
	'response.end

		If Not rs.eof then
			arrT = rs.GetRows()
			attcnt = UBound(arrT, 2) + 1
			starttype = arrT(3,0)
			gno = arrT(4,0)
			sno = arrT(5,0)
			gubun = arrT(9,0) '0 hide

			savetabletype = arrT(13,0) '대진표형태

			'리그라면
			if savetabletype = "L"  or  ( savetabletype = "N" and attcnt <= 4 ) then '####################################
				'리그
				tabletype = 1
				tableno = attcnt

				SQL = "select idx,midxL,midxR,teamL,teamR,scoreL,scoreR,winmidx from sd_gameMember_vs where tidx = "&tidx&" and levelno = '"&levelno&"' and delyn = 'N'  order by idx "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				arrX = rs.GetRows()
			else
				If (savetabletype = "T") or ( savetabletype = "N" and attcnt > 4) Then
					'토너먼트라면
					'토너먼트 16강까지만
					tabletype = 2
					tableno = attcnt
					'토너먼트 순서 배정

					Select Case tableno
					Case 5,6,7,8
					tablernd  = 8
					Case 9,10,11,12,13,14,15,16
					tablernd = 16
					Case Else
					tablernd = 32
					End Select

					SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'   order by tryoutsortno "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					arrT = rs.GetRows()
				end if
			End if

		End if


else '경영,다이빙,아티스틱

		If rs.eof Then
			Call oJSONoutput.Set("result", 1 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.end
		Else
			arr = rs.GetRows()

			If showtype = "gameresult" Then '대회결과출력이라면(대진표는 아님..)

				If openRC = "N" Then
					Call oJSONoutput.Set("result", 99 ) '종료가 되지 않음
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson

					Set rs = Nothing
					db.Dispose
					Set db = Nothing
					Response.end
				End If

				For ari = LBound(arr, 2) To UBound(arr, 2)
					l_rc = arr(6, ari)

					'Response.write l_rc &"$$<br>"
					If CDA = "E2" And CDC = "31" Then
					else
						' If l_rc  = "" Or isNull(l_rc) = True Or l_rc="0" Or l_rc="000000" Then
						' 		Call oJSONoutput.Set("result", 99 ) '종료가 되지 않음
						' 		strjson = JSON.stringify(oJSONoutput)
						' 		Response.Write strjson

						' 		Set rs = Nothing
						' 		db.Dispose
						' 		Set db = Nothing
						' 		Response.end
						' End If
					End if
				Next

			End if

		End if

	selectval = lidx &"_"& levelno
end if


'################################################
'response.write showtype
%>

<%If showtype = "gameresult" Then '대회결과출력이라면 ####################################################################################%>
	
	<%if CDA = "E2" And CDC = "31" then '수구라면#########%>
		<%
		If tabletype = 1 Then
			%><div class="drow-con__table"><%
			If gubun > 0 then
				Call drowLeageUSER(arrT, arrX, "admin")
			End If
			%></div><%
		Else
			If gubun > 0 then

				Call oJSONoutput.Set("result", 12345 )
				Call oJSONoutput.Set("tidx", tidx )
				Call oJSONoutput.Set("levelno", levelno )
				Call oJSONoutput.Set("tabletype", tabletype )
				Call oJSONoutput.Set("tableno", tableno )
				Call oJSONoutput.Set("openRC", openRC )

				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson

				Set rs = Nothing
				db.Dispose
				Set db = Nothing
				Response.end
			End if
		End if
		%>

	<%Else '############%>
		<div class="match-result-con__tab-box">
          <h3 class="hide">경기순서 표</h3>
          <table class="match-result-con__tab-box__con">
            <thead class="match-result-con__tab-box__con__thead">
							<tr>
                <th>순위</th>
                <th>선수명/출생년도</th>
                <th>시도</th>
                <th>소속</th>
                <th>학년</th>
                <th>기록</th>
                <th>비고</th>
								<%if CDA = "D2" then%><th>구간기록</th><%end if%>
								<%if CDA = "E2" or CDA = "F2" then%><th>라운드기록</th><%end if%>
              </tr>
            </thead>
            <tbody class="match-result-con__tab-box__con__tbody">
              <!-- s_highlight = 1,2,3 위 꾸며줌 -->
						<%
						If IsArray(arr) Then
							For ari = LBound(arr, 2) To UBound(arr, 2)

								l_rane = arr(0, ari)
								l_nm = arr(1, ari)
								l_sidonm= arr(2, ari)
								l_teamnm= arr(3, ari)
								l_class = arr(4, ari)

								l_order= arr(5, ari)
								l_rc = arr(6, ari)

								l_midx = arr(8,ari)

								'중복자 체크를 위해 출생년도 + 비고에 신기록 인지 표시 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$
								a_birth = Left(arr(9,ari),2)
								If a_birth = "--" Then
									'계영제외
									a_birth = ""
								else
									If CDbl(a_birth) > 30 Then
										a_birth = " (19" & a_birth & ")"
									Else
										a_birth = " (20" & a_birth & ")"
									End If
								End If

								bigo = ""
								a_ksin = isNulldefault(arr(10,ari),"")
								a_gsin = isNulldefault(arr(11,ari),"")

								if tidx  <> "124" Then '신규대회임 대회코드 없음
								If a_gsin <> "" Then
									bigo = "대회신기록"
								End If

								End if
								If a_ksin <> "" Then
									bigo = "한국신기록"
								End if
								'중복자 체크를 위해 출생년도 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$

								%>
								<tr <%If ari = 0 then%>class="s_highlight"<%End if%>>
									<td><span><%If l_order <> "" then%><%=l_order%>위<%End if%></span></td>
									<td <%If l_nm = unm then%>style="background:yellow;"<%End if%>><%=l_nm%> <%=a_birth%></td>
									<td><%=l_sidonm%></td>
									<td><%=shortNm(l_teamnm)%></td>
									<td><%=l_class%></td>
									<td><%If openRC = "Y" then%>
									<%
										Select Case CDA
										Case "D2" '경영
											Call SetRC(l_rc)
										Case "E2" '다이빙/수구
											If  CDC = "31" Then

											Else
												If isnumeric(l_rc) = True then
												Response.write FormatNumber(l_rc / 100 ,2)'Left(l_rc,3)& "." & Right(l_rc,2)
												Else
												Call SetRC(l_rc)
												End if
											End if
										Case "F2" '아티스틱
												If isnumeric(l_rc) = True then
												Response.write  FormatNumber(l_rc / 10000 ,4) 'Left(l_rc,3)& "." & Right(l_rc,4)
												Else
												Call SetRC(l_rc)
												End If
										End Select
									%>

									<%End if%></td>

									<td><%if CDA = "D2" then%><%=bigo%><%End if%></td>
									<%if CDA = "D2" then%><td><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getSectionInfo(<%=l_midx%>,'<%=ampm%>','<%=l_rc%>','<%=l_order%>','<%=l_rane%>')" >조회</button></td><%end if%>
									<%if CDA = "E2" or CDA = "F2" then%>
									<td>
									<%'진행정보를 볼수 있도록 결과전에도 오픈%>
									<button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getSectionInfo(<%=l_midx%>,'<%=ampm%>','<%=l_rc%>','<%=l_order%>','<%=l_rane%>')" >
									<%If openRC = "Y" then%>
									조회
									<%else%>
									중간조회
									<%end if%>
									</button>
									</td>
									<%end if%>
								</tr>
								<%
							Next
						End if
						%>

            </tbody>
          </table>
        </div>
	<%end if'###########f%>



<%else '대진표에서 넘어온거####################################################################################################%>

	<%if CDA = "E2" And CDC = "31" then '수구라면#########%>
			<%
			If tabletype = 1 Then
				%><div class="drow-con__table"><%
				If gubun > 0 then
					Call drowLeageUSER(arrT, arrX, "admin")
				End If
				%></div><%
			Else

				If gubun > 0 then

					Call oJSONoutput.Set("result", 12345 )
					Call oJSONoutput.Set("tidx", tidx )
					Call oJSONoutput.Set("levelno", levelno )
					Call oJSONoutput.Set("tabletype", tabletype )
					Call oJSONoutput.Set("tableno", tableno )
					Call oJSONoutput.Set("openRC", openRC )

					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson

					Set rs = Nothing
					db.Dispose
					Set db = Nothing
					Response.end
				End if
			End if
			%>


	<%Else '############%>
		  <%if CDA = "D2" then '경영만%>
			<ul class="drow-con__list" >
				<li class="drow-con__list-li<%If starttype = "1" then%> s_on<%End if%>">
					<%If CDA = "D2" And starttype = "1" then%>
					<a class="drow-con__list__link" href="javascript:mx.getMachTab('<%=tidx%>','<%=selectval%>',1,1)">예선</a>
					<%else%>
					<a class="drow-con__list__link" >예선</a>
					<%End if%>

					<%'예선조%>
					<%If CDbl(joono) > 1 then%>
								<div class="drow-con__list__box-group">
									<ul class="drow-con__list__box-group__btns clear">
										<!-- s_on = button 파란색으로 -->
										<%For i = 1 To joono%>
										<li <%If i = CDbl(now_joo) then%>class="s_on"<%End if%> ><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getMachTab('<%=tidx%>','<%=selectval%>',<%=i%>,1)" style="margin-bottom:5px;"><%=i %>조</button></li>
										<%next%>
									</ul>
								</div>
					<%End if%>
					</li>

					<li class="drow-con__list-li<%If starttype = "3" then%> s_on<%End if%>">
							<a class="drow-con__list__link" href="javascript:mx.getMachTab('<%=tidx%>','<%=selectval%>',1,3)">결승</a>

							<%If CDbl(joono) > 1 then%>
								<div class="drow-con__list__box-group">
									<ul class="drow-con__list__box-group__btns clear">
										<!-- s_on = button 파란색으로 -->
										<%For i = 1 To joono%>
										<li <%If i = CDbl(now_joo) then%>class="s_on"<%End if%>><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getMachTab('<%=tidx%>','<%=selectval%>',<%=i%>,3)"><%=i %>조</button></li>
										<%next%>
									</ul>
								</div>
							<%End if%>

				</li>
      </ul>
			<%end if%>

        <div class="drow-con__table" id = "sw_joolist">
          <h3 class="drow-con__table-header clear">
            <span class="drow-con__table-header__span"><%=CDBNM%></span>
            <span class="drow-con__table-header__span"><%=CDCNM%></span>
            <span class="drow-con__table-header__span"><%If CDA = "D2" then%><%=now_joo%>조<%End if%></span>
          </h3>
          <table class="drow-con__table-con">
            <thead class="drow-con__table-con__thead">
              <tr>
                <th scope="col"><%If cda = "D2" then%>레인<%else%>순서<%End if%></th>
                <th scope="col">선수명/출생년도</th>
                <th scope="col">시도</th>
                <th scope="col">소속</th>
                <th scope="col">학년</th>
                <th scope="col">순위</th>
                <th scope="col">기록</th>
				
								<%if CDA = "D2" then%><th>구간기록</th><%end if%>
								<%if CDA = "E2" or CDA = "F2" then%><th>라운드기록</th><%end if%>
              </tr>
            </thead>
            <tbody class="drow-con__table-con__tbody">
						<%
						If IsArray(arr) Then
							For ari = LBound(arr, 2) To UBound(arr, 2)

								l_rane = arr(0, ari) 'idx
								l_nm = arr(1, ari)
								l_sidonm= arr(2, ari)
								l_teamnm= arr(3, ari)
								l_class = arr(4, ari)

								If CDA = "D2"  then
								l_order= arr(5, ari) 'tryoutorder (예선)
								Else
								l_order= arr(7, ari) 'tryouttotalorder (전체순위)
								End if

								l_rc = arr(6, ari)
								l_midx = arr(8,ari)

								'중복자 체크를 위해 출생년도 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$
								a_birth = Left(arr(9,ari),2)
								If a_birth = "--" Then
									'계영제외
									a_birth = ""
								else
									If CDbl(a_birth) > 30 Then
										a_birth = " (19" & a_birth & ")"
									Else
										a_birth = " (20" & a_birth & ")"
									End If
								End If

								'중복자 체크를 위해 출생년도 (12/10일 상훈씨 요청(수영연맹에서 받아서)$$$$$$$$$$$$$$

								%>
								  <tr>
									<td scope="row"><%=l_rane%></td>
									<td  <%If l_nm = unm then%>style="background:yellow;"<%End if%>><%=l_nm%> <%=a_birth%></td>
									<td><%=l_sidonm%></td>
									<td><%=shortNm(l_teamnm)%></td>
									<td><%=l_class%></td>

									
									<%'순위 기록 ########################################################%>
									<td><%If openRC = "Y" then%><%=l_order%><%End if%></td>

									<td>
									<%If openRC = "Y" then%>
									<%
										Select Case CDA
										Case "D2" '경영
											Call SetRC(l_rc)
										Case "E2" '다이빙/수구
											If  CDC = "31" Then

											Else
												If isnumeric(l_rc) = True then
												Response.write FormatNumber(l_rc / 100 ,2)'Left(l_rc,3)& "." & Right(l_rc,2)
												Else
												Call SetRC(l_rc)
												End If
											End if
										Case "F2" '아티스틱
												If isnumeric(l_rc) = True then
												Response.write FormatNumber(l_rc / 10000 ,4)'Left(l_rc,2)& "." & Right(l_rc,4)
												Else
												Call SetRC(l_rc)
												End If
										End Select
									%>
									<%End if%>
									</td>
									
									<%if CDA = "D2" then%><td><button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getSectionInfo(<%=l_midx%>,'<%=ampm%>','<%=l_rc%>','<%=l_order%>','<%=l_rane%>')" >조회</button></td><%end if%>
									
									<%if CDA = "E2" or CDA = "F2" then%>
									<td>
									
									<%'진행정보를 볼수 있도록 결과전에도 오픈%>
									<button class="drow-con__list__box-group__btns__btn" type="button" name="button" onclick="mx.getSectionInfo(<%=l_midx%>,'<%=ampm%>','<%=l_rc%>','<%=l_order%>','<%=l_rane%>')" >조회</button>
									
									</td>
									<%end if%>
									<%'순위 기록 ########################################################%>
								  </tr>
								<%
							Next
						End if
						%>

            </tbody>
          </table>
        </div>
	<%End If '##########%>

<%End if%>


<%
	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
