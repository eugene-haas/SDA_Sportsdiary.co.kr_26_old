<%
'#############################################
'검색이름의 참가팀 대진표 목록
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End if
	If hasown(oJSONoutput, "CDA") = "ok" Then 
		cda = oJSONoutput.CDA
	End if	
	If hasown(oJSONoutput, "PIDX") = "ok" Then 
		pidx = oJSONoutput.PIDX
	End if	

	'경기순서
	If hasown(oJSONoutput, "DD") = "ok" then
		dd = Replace(oJSONoutput.DD,"/","-")
	End If
	If hasown(oJSONoutput, "AMPM") = "ok" then
		ampm = oJSONoutput.AMPM
	End if	


	SQL = "select gbidx,cda from  sd_gameMember as a left join sd_gameMember_partner as b on a.gameMemberIDX = b.gameMemberIDX and a.DelYN = 'N' and b.delYN = 'N' "
	SQL = SQL & " where a.gametitleidx = "&tidx&" and (a.playeridx = '"&pidx &"' or b.playeridx = '"&pidx&"') " 'a.CDA = 'D2' and
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		arr = rs.GetRows()
	End if	

	
	fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm ,resultopenAMYN,resultopenPMYN,levelno"


	If ampm = "am" then
		tm1 = "10:00"
		tm2 = "09:00"
		'오전 오후 두개 가져오자.
		SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&dd&"' and tryoutgameingS > 0) order by gameno " 'tryoutgameingS 진행될 초
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		tabno = "4"
	else
		tm1 = "13:00"
		tm2 = "12:00"	
		SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (finalgamedate = '"&dd&"' and finalgameingS > 0)    order by gameno2 "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		tabno = "6"
	End if

'Response.write sql

	If rs.eof Then
		returnresult = 1
	else
		arrR = rs.GetRows()
	End if	

	'다이빙 아티스틱 수구
	If ampm = "am" then
			fld = " a.RGameLevelidx,a.GbIDX,a.ITgubun,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.SetBestScoreYN,a.tryoutgamedate,a.tryoutgamestarttime,a.tryoutgameingS "
			fld = fld & " ,a.finalgamedate,a.finalgamestarttime,a.finalgameingS,a.gameno,a.joono,a.gameno2,a.joono2,a.gubunam,a.gubunpm ,a.resultopenAMYN,a.resultopenPMYN,a.levelno,a.roundcnt"
			fld = fld & " , (select count(*) from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx ) as gcnt " '신규추가 필드 
			'다이빙(날짤1개로사용) 아티스틱(날짜2개로 사용) 수구까지
			SQL = "select "&fld&" from tblRGameLevel as a "
			SQL = SQL & "	where a.delyn = 'N' and a.gametitleidx =  " & tidx  & " and a.CDA in ('E2','F2') and (a.tryoutgamedate = '"&dd&"' or a.finalgamedate = '"&dd&"')  " 'and tryoutgamestarttime = '10:00'  "
			SQL = SQL & " and (  grouplevelidx is null or grouplevelidx = RGameLevelidx ) "
			SQL = SQL & " order by cast(a.gameno as int ) "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.EOF Then
				if returnresult = 1 then
					Call oJSONoutput.Set("result", 1 )
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson

					Set rs = Nothing
					db.Dispose
					Set db = Nothing
					Response.end
				end if		
			else
				arrRs = rs.GetRows()
			End If
	
	else
			fld = " a.RGameLevelidx,a.GbIDX,a.ITgubun,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.SetBestScoreYN,a.tryoutgamedate,a.tryoutgamestarttime,a.tryoutgameingS "
			fld = fld & " ,a.finalgamedate,a.finalgamestarttime,a.finalgameingS,a.gameno,a.joono,a.gameno2,a.joono2,a.gubunam,a.gubunpm ,a.resultopenAMYN,a.resultopenPMYN,a.levelno,a.roundcnt"
			fld = fld & " , (select count(*) from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx ) as gcnt " '신규추가 필드 
			'다이빙(날짤1개로사용) 아티스틱(날짜2개로 사용) 수구까지
			SQL = "select "&fld&" from tblRGameLevel as a "
			SQL = SQL & "	where a.delyn = 'N' and a.gametitleidx =  " & tidx  & " and a.CDA in ('E2','F2') and (a.tryoutgamedate = '"&dd&"' or a.finalgamedate = '"&dd&"')  " 'and tryoutgamestarttime = '10:00'  "
			SQL = SQL & " and (  grouplevelidx is null or grouplevelidx = RGameLevelidx ) "
			SQL = SQL & " order by cast(a.gameno as int ) "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.EOF Then
				if returnresult = 1 then
					Call oJSONoutput.Set("result", 1 )
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson

					Set rs = Nothing
					db.Dispose
					Set db = Nothing
					Response.end
				end if		
			else
				arrRs = rs.GetRows()
			End If	
	end if




	Set rs = Nothing
	db.Dispose
	Set db = Nothing	
'################################################

%>
				<%If IsArray(arrR) Then%>
					<h3 class="hide">경기순서 표</h3>
          <table class="match-order-con__tab-box__con">
            <thead class="match-order-con__tab-box__con__thead">
              <tr>
                <th>순서</th>
                <th>부별</th>
                <th>종목</th>
                <th>정보</th>
              </tr>
            </thead>
            <tbody class="match-order-con__tab-box__con__tbody">
              <!-- match-order-con__tab-box__con__link-info 아이디 값에따라 색 변화 -->
              <!-- match-order-con__tab-box__con__tbody > td
              s_yellow =색변화 -->
						<%
						For ari = LBound(arrR, 2) To UBound(arrR, 2)
							l_idx = arrR(0, ari)
							l_GbIDX = arrR(1, ari)
							l_ITgubun = arrR(2, ari)
							l_CDA = arrR(3, ari)
							l_CDANM = arrR(4, ari)
							l_CDB = arrR(5, ari)
							l_CDBNM = arrR(6, ari)
							l_CDC = arrR(7, ari)
							l_CDCNM = arrR(8, ari)
							l_SetBestScoreYN = arrR(9, ari)
							l_tryoutgamedate = arrR(10, ari)
							l_tryoutgamestarttime = arrR(11, ari)
							l_tryoutgameingS = arrR(12, ari)
							l_finalgamedate = arrR(13, ari)
							l_finalgamestarttime = arrR(14, ari)
							l_finalgameingS = arrR(15, ari)
							l_gameno = arrR(16, ari)
							l_joono = arrR(17, ari)
							l_resultopenAMYN = arrR(22,ari)
							l_resultopenPMYN = arrR(23,ari)
							l_levelno = arrR(24,ari)


							l_gubun = arrR(20, ari)
							If l_gubun = "1" Then
							gubunstr = "예선"
							Else
							gubunstr = "결승"
							End if

							selectval = l_idx &"_"& l_levelno

							%>
							  <tr>
								<%
								If IsArray(arr) Then  '오전
									For a = LBound(arr, 2) To UBound(arr, 2)
										gbidx = arr(0, a)	
										f_cda = arr(1,a)						

										if f_cda = "D2" then
										If Cstr(gbidx) = Cstr(l_gbidx) Then
										findtds = "<span class=""s_yellow"">"
										findtde = "</span>"
										End if
										end if

									Next
								End if
								%>

								<td><%=findtds%><%=l_gameno%>_<%=l_joono%><%=findtde%></td>
								<td><%=shortBoo(l_CDBNM)%></td>
								<td><%=l_CDCNM%>[<%=gubunstr%>]</td>
								<td class="match-order-con__tab-box__con__link-info">
									<%If l_resultopenAMYN = "Y" then%>
									<a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':<%=tabno%>,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkRecordMatch">기록보기</a>
									<%else%>
									<a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':<%=tabno%>,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkPlayerMatch">선수보기</a>
									<%End if%>
								</td>
							  </tr>
							<%
						findtds = ""
						findtde = ""
						Next 
						%>

            </tbody>
          </table>
				<%End if%>

        <%
        '#################################################################################################################
        if IsArray(arrRs) then

					For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
						s_CDA = arrRs(3, ari)
						s_CDC = arrRs(5, ari)
						if s_CDA = "E2" then
							if s_CDC = "31" then
								CDASG = "OK"
							else
								CDAE2 = "OK"
							end if
						end if
						if s_CDA = "F2" then
							CDAF2 = "OK"
						end if          
					next

          '다이빙####

          if CDAE2 = "OK" then        
          %>
					
						<table class="match-order-con__tab-box__con" style="margin-top:5px;">
							<thead class="match-order-con__tab-box__con__thead">
								<tr>
									<th>순서</th>
									<th>(다이빙)종목</th>
									<th>라운드</th>
									<th>정보</th>
								</tr>
							</thead>
							<tbody class="match-order-con__tab-box__con__tbody">
                    <%
											i = 1
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
												l_idx = arrRs(0, ari)
												l_GbIDX = arrRs(1, ari)
												l_ITgubun = arrRs(2, ari)
												l_CDA = arrRs(3, ari)
												l_CDANM = arrRs(4, ari)
												l_CDB = arrRs(5, ari)
												l_CDBNM = arrRs(6, ari)
												l_CDC = arrRs(7, ari)
												l_CDCNM = arrRs(8, ari)
												l_tryoutgamedate = arrRs(10, ari)
												l_tryoutgamestarttime = arrRs(11, ari)
												l_finalgamedate = arrRs(13, ari)
												l_finalgamestarttime = arrRs(14, ari)
												l_gameno = arrRs(16, ari)
												l_resultopenAMYN = arrRs(22,ari)
												l_resultopenPMYN = arrRs(23,ari)
												l_levelno = arrRs(24,ari)
												l_roundcnt = arrRs(25,ari)

												l_gcnt = arrRs(26,ari)

                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if

												if ((l_tryoutgamestarttime = tm1 or l_tryoutgamestarttime = tm2) and l_tryoutgamedate = dd) or _
												((l_finalgamestarttime = tm1 or l_finalgamestarttime = tm2) and l_finalgamedate = dd)  then 
                        if l_CDA = "E2" then
                        %>

												<%'선수찾기
												If IsArray(arr) Then  '오전
													For a = LBound(arr, 2) To UBound(arr, 2)
														gbidx = arr(0, a)	
														f_cda = arr(1,a)						

														If Cstr(gbidx) = Cstr(l_gbidx) Then
														findtds = "<span class=""s_yellow"">"
														findtde = "</span>"
														End if

													Next
												End if
												%>
												<tr>
													<td><%=findtds%><%=i%><%=findtde%></td>
													<td><%=itgubunstr%>&nbsp;<%=shortBoo(l_CDBNM)%> <%=l_CDCNM%> <%If l_gcnt > 0 then%><span style="color:red;font-size:12px;">&nbsp;+<%=l_gcnt-1%></span><%End if%></td>
													<td style="text-align:center;"><%=l_roundcnt%>R</td>												
												%>
													<td class="match-order-con__tab-box__con__link-info">
													<%If l_resultopenAMYN = "Y"  then%>
													<a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':<%=tabno%>,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkRecordMatch">기록보기</a>
													<%else%>
													<a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':<%=tabno%>,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkPlayerMatch">선수보기</a>
													<%end if%>													
													</td>
												</td>
												</tr>												
												<%
												i = i + 1
                        end if
                        end if
                      Next
                    %>
                  </tbody>
                </table>
          <%
          end if

          '아티스틱###

          if CDAF2 = "OK" then        
          %>

						<h3 class="hide">경기순서 표</h3>
						<table class="match-order-con__tab-box__con" style="margin-top:5px;">
							<thead class="match-order-con__tab-box__con__thead">
								<tr>
									<th>순서</th>
									<th>(아티스틱)종목</th>
									<th>라운드</th>
									<th>정보</th>
								</tr>
							</thead>
							<tbody class="match-order-con__tab-box__con__tbody">
                    <%
											i = 1 
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
												l_idx = arrRs(0, ari)
												l_GbIDX = arrRs(1, ari)
												l_ITgubun = arrRs(2, ari)
												l_CDA = arrRs(3, ari)
												l_CDANM = arrRs(4, ari)
												l_CDB = arrRs(5, ari)
												l_CDBNM = arrRs(6, ari)
												l_CDC = arrRs(7, ari)
												l_CDCNM = arrRs(8, ari)
												l_tryoutgamedate = arrRs(10, ari)
												l_tryoutgamestarttime = arrRs(11, ari)
												l_finalgamedate = arrRs(13, ari)
												l_finalgamestarttime = arrRs(14, ari)
												l_gameno = arrRs(16, ari)
												l_resultopenAMYN = arrRs(22,ari)
												l_resultopenPMYN = arrRs(23,ari)
												l_levelno = arrRs(24,ari)
												l_roundcnt = arrRs(25,ari)
												
												l_gcnt = arrRs(26,ari)

                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if
                        
                        '경기만
												if ((l_tryoutgamestarttime = tm1 or l_tryoutgamestarttime = tm2) and l_tryoutgamedate = dd) or _
												((l_finalgamestarttime = tm1 or l_finalgamestarttime = tm2) and l_finalgamedate = dd)  then 
                        if l_CDA = "F2"  then
												%>
												<tr>

												<%'선수찾기
												If IsArray(arr) Then  '오전
													For a = LBound(arr, 2) To UBound(arr, 2)
														gbidx = arr(0, a)	
														f_cda = arr(1,a)						

														If Cstr(gbidx) = Cstr(l_gbidx) Then
														findtds = "<span class=""s_yellow"">"
														findtde = "</span>"
														End if
													Next
												End if
												%>

												<td><%=findtds%><%=i%><%=findtde%><%'=l_gameno%></td>
												<td><%=itgubunstr%>&nbsp;<%=shortBoo(l_CDBNM)%>&nbsp;<%=l_CDCNM%> <%If l_gcnt > 0 then%><span style="color:red;font-size:12px;">&nbsp;+<%=l_gcnt-1%></span><%End if%></td>
												
												<%
												Select Case l_CDC 
												Case "04","06","12"	'테크니컬
												
													if l_tryoutgamedate = l_finalgamedate then
														roundstr = "테크+프리"
													else
														if l_tryoutgamedate = start_gamedate then
															roundstr = "테크니컬"
														else
															roundstr = "프리루틴"													
														end if
													end if

												Case "01" '피겨솔로

													if l_tryoutgamedate = l_finalgamedate then
														roundstr = "피겨+프리"
													else
														if l_tryoutgamedate = start_gamedate then
															roundstr = "피겨루틴"
														else
															roundstr = "프리루틴"													
														end if
													end if

												Case "02","03" '피겨듀엣 ,'피겨팀
														roundstr = "프리루틴"
												Case Else '프리 루틴
														roundstr = "프리루틴"												
												end select


												' If l_resultopenAMYN = "Y" and l_resultopenPMYN = "Y" then
												' 	resulttext = "경기종료"
												' else
												' 	resulttext = "-"
												' end if
												%>
													<td style="text-align:center;"><%=roundstr%></td>
													<td class="match-order-con__tab-box__con__link-info">
													<%If l_resultopenAMYN = "Y" and l_resultopenPMYN = "Y" then%>
													<a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':<%=tabno%>,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkRecordMatch">기록보기</a>
													<%else%>
													<a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':<%=tabno%>,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkPlayerMatch">선수보기</a>
													<%end if%>
													</td>
												</tr>
												<%
												i = i + 1
                        end if
                        end if
                      Next
                    %>
                  </tbody>
                </table>
          <%
          end if

          '수구######

          if CDASG = "OK" then        
          %>

								<h3 class="hide">경기순서 표</h3>                
                <table>
                  <thead>
                    <tr>
                      <th>경기순서</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
                        l_CDA = arrRs(0, ari)
                        l_CDBNM = arrRs(1, ari)
                        l_CDC = arrRs(2, ari)
                        l_CDCNM = arrRs(3, ari)
                        l_tryoutgamedate = arrRs(4, ari)
                        l_finalgamedate = arrRs(5, ari) '다이빙은 안씀
                        l_tryoutgamestarttime = arrRs(6, ari) '10:00 오전 13:00 > 오후 값고정
                        l_finalgamestarttime = arrRs(7, ari) '다이빙안씀
                        l_ITgubun = arrRs(8,ari)

                        'if l_tryoutgamestarttime = "09:00" then
                        if l_tryoutgamedate = start_gamedate and l_CDA = "E2" and l_CDC = "31" then
                        %><tr><td><%=l_CDBNM%>&nbsp;<%=l_CDCNM%></td></tr><%
                        end if
                        'end if
                      Next
                    %>
                  </tbody>
                </table>
              
          <%
          end if

        end if
        '#################################################################################################################
        %>					
