<%
'request
tidx = oJSONoutput.Get("TIDX")
tcd = oJSONoutput.Get("TCD")


leaderinfo = request.Cookies("leaderinfo")
If leaderinfo <> "" And session("chkrndno") = "" Then

	Set leader = JSON.Parse( join(array(leaderinfo)) )

	s_team =  leader.Get("a")
	s_username =  leader.Get("b")
	s_birthday = leader.Get("c")
	s_userphone =  leader.Get("d")
	s_tidx = leader.Get("e")
	s_idx = leader.Get("f")

End if

	Set db = new clsDBHelper


	pagesize = 20


'	strFieldName = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt,GameTitleIDX    ,ViewState,ViewStateM,ViewYN,MatchYN,stateNo"	


	

'	strSort = "  order by GameS desc, gametitleidx desc"
'	strSortR = "  order by  GameS , gametitleidx"
	'search
'	If chkBlank(F2) Then
'		strWhere = " DelYN = 'N' and ( gameS >=  '"& year(date) & "-01-01" &"' and  gameS < '"& CDbl(year(date))+1 & "-01-01" &"' )  "

'	대회정보
	SQL = "Select GameTitleName,games,gamee,gamearea from sd_gameTitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gametitle = rs(0)
	games = rs(1)
	gamee = rs(2)
	gamearea = rs(3)



	SQL = ""
	SQL = SQL & " select count(*) from "
	SQL = SQL & " tblGameRequest_imsi as a  "
	SQL = SQL & " inner join tblGameRequest_imsi_r as b "
	SQL = SQL & "	on a.seq = b.seq and b.delyn = 'N'  "
	SQL = SQL & " where a.delyn = 'N' and a.team = '"&tcd&"' and a.tidx = '"&tidx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If CDbl(rs(0)) > 0 then
		recordcnt = rs(0)

		'페이지수
		totalpagecount = int(recordcnt / pagesize)
		if ( recordcnt mod pagesize ) > 0 then totalpagecount = totalpagecount + 1
		if totalpagecount <= 0 then : totalpagecount = 1


		cdbnmsql = "(select top 1 cdbnm from tblGameRequest_imsi_r where seq = a.seq) as cdbnm "

		fldboo = " ,(SELECT  STUFF(( select ','+ itgubun + CDCNM from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM,itgubun order by itgubun for XML path('') ),1,1, '' )) as cdcnm "
		fld = " a.playeridx,a.username,a.birthday,a.sex,a.CDB,    "&cdbnmsql&"    ,a.userclass,a.seq " & fldboo &  ", a.teamnm"
		SQL = "Select "&fld&" from tblGameRequest_imsi as a  where a.team = '"&tcd&"' and a.tidx = '"&tidx&"' and delyn = 'N'  and leaderidx = '"&s_idx&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrP = rs.GetRows()
			teamnm = arrP(9,0)
			'Call getrowsdrow(arrP)
		End If

	 Else
			totalpagecount = 1
	 End if	 

	

	db.Dispose
	Set db = Nothing
%>
  
  
  <link rel="stylesheet" href="/home/css/default.css?ver=1.8">
  <link rel="stylesheet" href="/home/css/style.css?ver=1.8">






   <div class="l_print">
      <ol>

<!-- 		 <li class="l_print__page"> -->
	<!--             <section class="m_applyConfirm"> -->
	<!--                <header class="m_applyConfirm__header"> -->
	<!--                   <div class="m_applyConfirm__header__info"> -->
	<!--                      <dl class="m_applyConfirm__header__info__list"> -->
	<!--                         <dt class="m_applyConfirm__header__info__list__head">소속명 :</dt> -->
	<!--                         <dd>수영을 사랑하는 모임</dd> -->
	<!--                      </dl> -->
	<!--                      <dl class="m_applyConfirm__header__info__list"> -->
	<!--                         <dt class="m_applyConfirm__header__info__list__head">신청자 :</dt> -->
	<!--                         <dd>한경일</dd> -->
	<!--                      </dl> -->
	<!--                   </div> -->
	<!--                   <h1 class="m_applyConfirm__header__title">참가신청확인서(1/2)</h1> -->
	<!--                </header> -->
	<!--                <div class="m_applyConfirm__con"> -->
	<!--                   <div class="m_applyConfirm__con__header"> -->
	<!--                      <h2 class="m_applyConfirm__con__header__title">2019 ARENA KOREA MASTERS 다이빙 대회</h2> -->
	<!--                      <div class="m_applyConfirm__con__header__info"> -->
	<!--                         <dl class="m_applyConfirm__con__header__info__list"> -->
	<!--                            <dt class="m_applyConfirm__con__header__info__list__head">대회기간 :</dt> -->
	<!--                            <dd>2019.12.14 ~ 2019.12.17</dd> -->
	<!--                         </dl> -->
	<!--                         <dl class="m_applyConfirm__con__header__info__list"> -->
	<!--                            <dt class="m_applyConfirm__con__header__info__list__head">대회장소 :</dt> -->
	<!--                            <dd>김천</dd> -->
	<!--                         </dl> -->
	<!--                      </div> -->
	<!--                   </div> -->
	<!--                   <table class="m_applyConfirm__con__tbl"> -->
	<!--                      <thead class="m_applyConfirm__con__tbl__head"> -->
	<!--                         <tr> -->
	<!--                            <th>No</th> -->
	<!--                            <th>이름</th> -->
	<!--                            <th>생년월일</th> -->
	<!--                            <th>성별</th> -->
	<!--                            <th>나이</th> -->
	<!--                            <th>학년</th> -->
	<!--                            <th>종별</th> -->
	<!--                            <th>세부종목</th> -->
	<!--                         </tr> -->
	<!--                      </thead> -->
	<!--                      <tbody class="m_applyConfirm__con__tbl__body"> -->
	<!--                         <tr> -->
	<!--                            <td>1</td> -->
	<!--                            <td>최연하</td> -->
	<!--                            <td>2011.0406</td> -->
	<!--                            <td>여</td> -->
	<!--                            <td>20</td> -->
	<!--                            <td>20</td> -->
	<!--                            <td>여자일반부</td> -->
	<!--                            <td> -->
	<!--                               <span>여자 / 혼계영400m / 일반부 / +200 / - </span> -->
	<!--                            </td> -->
	<!--                         </tr> -->
	<!--                      </tbody> -->
	<!--                   </table> -->
	<!--                </div> -->
	<!--                <footer class="m_applyConfirm__footer"> -->
	<!--                   <span class="m_applyConfirm__footer__noti">상기 기재사항이 사실과 틀림없음을 확인합니다.</span> -->
	<!--                   <span class="m_applyConfirm__footer__date">2020. 01. 31</span> -->
	<!--                   <dl class="m_applyConfirm__footer__name"> -->
	<!--                      <dt>참가팀명 :</dt> -->
	<!--                      <dd><span>수영을사랑하는모임</span>(인)</dd> -->
	<!--                   </dl> -->
	<!--                </footer> -->
	<!--             </section> -->
<!--          </li> -->


<%
startno = 0 'LBound(arrH, 2)
For x = 0 To totalpagecount-1
%>


         <li class="l_print__page">
            <section class="m_applyConfirm">
               <header class="m_applyConfirm__header">
                  <div class="m_applyConfirm__header__info">
                     <dl class="m_applyConfirm__header__info__list">
                        <dt class="m_applyConfirm__header__info__list__head">소속명 :</dt>
                        <dd><%=teamnm%></dd>
                     </dl>
                     <dl class="m_applyConfirm__header__info__list">
                        <dt class="m_applyConfirm__header__info__list__head">신청자 :</dt>
                        <dd><%=s_username%></dd>
                     </dl>
                  </div>
                  <h1 class="m_applyConfirm__header__title">참가신청확인서(<%=x+1%>/<%=totalpagecount%>)</h1>
               </header>
               <div class="m_applyConfirm__con">
                  <div class="m_applyConfirm__con__header">
                     <h2 class="m_applyConfirm__con__header__title"><%=gametitle%></h2>
                     <div class="m_applyConfirm__con__header__info">
                        <dl class="m_applyConfirm__con__header__info__list">
                           <dt class="m_applyConfirm__con__header__info__list__head">대회기간 :</dt>
                           <dd><%=Replace(games,"-",".")%> ~ <%=Replace(gamee,"-",".")%></dd>
                        </dl>
                        <dl class="m_applyConfirm__con__header__info__list">
                           <dt class="m_applyConfirm__con__header__info__list__head">대회장소 :</dt>
                           <dd><%=gamearea%></dd>
                        </dl>
                     </div>
                  </div>

				  <table class="m_applyConfirm__con__tbl">
                     <thead class="m_applyConfirm__con__tbl__head">
                        <tr>
                           <th>No</th>
                           <th>이름</th>
                           <th>생년월일</th>
                           <th>성별</th>
                           <th>나이</th>
                           <th>학년</th>
                           <th>종별</th>
                           <th>세부종목</th>
                        </tr>
                     </thead>
                     <tbody class="m_applyConfirm__con__tbl__body">


								<%
									n = 1
									listno = 0
									If IsArray(arrP) Then 
										For ari = startno To UBound(arrP, 2)
										'a.playeridx,a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass
										a_pidx = arrP(0, ari)
										a_nm = arrP(1, ari)
										a_birth = isnulldefault(arrP(2, ari),"")
										a_sex = arrP(3, ari)
										If a_sex = "1" Then
											a_sexstr = "남"
										Else
											a_sexstr = "여"
										End if
										a_CDB = arrP(4, ari)
										a_CDBNM = isnulldefault(arrP(5, ari),"")
										a_userclass = arrP(6, ari)
										a_seq = arrP(7,ari)

										a_cdcnm = arrP(8,ari)
										listno = ari + 1
										
										'유년부및 나이 요청 21.2.25
										If InStr(a_CDBNM,"초등") > 0 then
											If CDbl(a_userclass) < 5 Then
												a_CDBNM = Replace(a_CDBNM , "초등", "유년")
											End if	
										End if				
					

										'6자리로 오는구만
										If a_birth <> "" then
											If CDbl(Left(a_birth,2)) >  CDbl(Right(year(date),2))  Then
												a_birth = "19"& a_birth
											Else
												a_birth = "20"& a_birth
											End If
											chkbirth = Left(a_birth,4)& "-"& Mid(a_birth,5,2) & "-" & Right(a_birth,2)
										End if

										a_age = korAge(chkbirth)

										'유년부및 나이 요청 21.2.25
										%>

											<tr>
											   <td><%=listno%></td>
											   <td><%=a_nm%></td>
											   <td><%=Left(a_birth,4)&"."&Mid(a_birth,5)%><!--2011.0406--></td>
											   <td><%=a_sexstr%></td>
											   <td><%=a_age%></td>
											   <td><%=a_userclass%></td>

											   <td>
											   <%If InStr(a_CDBNM, "남자") > 0   Or  InStr(a_CDBNM,"여자") > 0 then%>
											   <%=a_CDBNM%>
											   <%else%>
											   <%=a_sexstr%>자<%=a_CDBNM%>
											   <%End if%>

											   
											   </td>
											   <td>
														<%
														If a_cdcnm <> "" Then
															a_cdcnmarr = Split(a_cdcnm,",")
														
															  for s = 0 To ubound(a_cdcnmarr) 
															  
															  %><span><%=a_sexstr%>자 / <%=Mid(a_cdcnmarr(s),2)%> / <%=a_CDBNM%>  <!--+200 / - --> <%'=ubound(a_cdcnmarr)%></span><%

																If n Mod pagesize =  0 Then
																	startno = ari + 1
																	Response.write "</td></tr>"
																	Exit For
																End If
						  									    
																n = n + 1
															  Next
															  
														End If
														%>

												  <!--<span>여자 / 혼계영400m / 일반부 / +200 / - </span>-->

											   </td>
											</tr>
										<%
										If n Mod pagesize =  0 Then
											startno = ari + 1
											Exit For
										End if

										Next
									End If
									
									'중간에 안나왔을수 있으니
									startno = ari + 1

								%>

								<%
								'남은걸 찍을 필요없음 자동 맞추어짐...
								If x = totalpagecount-1 Then '마지막 페이지라면
								'Response.write n
								'남은갯수만큼 루프
								remainderloopcnt = Abs( n - pagesize)
									If remainderloopcnt = 0 Then
									else
										'Response.write remainderloopcnt & "<span>-------- <span class=""t_ls4"">이하여백</span> --------</span>"
									End if
								End if
								%>	


<!-- 						<tr> -->
	<!--                            <td>1</td> -->
	<!--                            <td>최연하</td> -->
	<!--                            <td>2011.0406</td> -->
	<!--                            <td>여</td> -->
	<!--                            <td>20</td> -->
	<!--                            <td>20</td> -->
	<!--                            <td>여자일반부</td> -->
	<!--                            <td> -->
	<!--                               <span>여자 / 혼계영400m / 일반부 / +200 / - </span> -->
	<!--                               <span>여자 / 혼계영400m / 일반부 / +200 / - </span> -->
	<!--                            </td> -->
<!--                         </tr> -->


					 </tbody>
                  </table>
               </div>
               <footer class="m_applyConfirm__footer">
                  <span class="m_applyConfirm__footer__noti">상기 기재사항이 사실과 틀림없음을 확인합니다.</span>
                  <span class="m_applyConfirm__footer__date"><%=year(date)%>. <%=Mid(date,6,2)%>. <%=Right(date,2)%></span>
                  <dl class="m_applyConfirm__footer__name">
                     <dt>참가팀명 :</dt>
                     <dd><span><%=teamnm%></span>(인)</dd>
                  </dl>
               </footer>
            </section>
         </li>

<%next%>	  
	  
	  </ol>
   </div>
