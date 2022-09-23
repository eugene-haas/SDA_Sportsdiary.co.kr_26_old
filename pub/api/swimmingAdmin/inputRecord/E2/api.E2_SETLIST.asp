<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	lidx = oJSONoutput.Get("LIDX") 'tblRGameLevel.RGameLevelidx
	ampm = "am" 'AM (파이널개념이 없으므로 모두 am으로 처리하면 됨) 예선 , 본선없음 am
	'starttype = 3

	Set db = new clsDBHelper

	fld = "RgameLevelidx,gametitleidx, gubunam,tryoutgamedate,tryoutgamestarttime,gameno,tryoutgameingS,gbidx,cda,cdc  " 
	gnostr = " gameno "
	tmstr = " tryoutgamestarttime " '오전 오후 구분
	gubunstr = " gubunam "
	dtstr = " tryoutgamedate "
	fldb = "b."& Replace(fld,",",",b.")


	  'grouplevelidx, RoundCnt, judgeCnt " '라운드수, 심사위원수
	  SQL = "Select "&fld&", isNull(grouplevelidx, 0) , isnull(RoundCnt,0), isnull(judgeCnt,0) , gamecodeidx  , (select count(*) from tblRGameLevel where grouplevelidx is not null and grouplevelidx = L.grouplevelidx ) as gcnt   from tblRGameLevel as L where RgameLevelidx = " & lidx
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  If Not rs.EOF Then
			arrI = rs.GetRows()
	  End If

	'Call getrowsdrow(arrI)

	If IsArray(arrI) Then
		For ari = LBound(arrI, 2) To UBound(arrI, 2)
			tidx =  arrI(1,ari)
			gamedate = arrI(3,ari) '경기일자

			grouplevelidx = arrI(10,ari) '그룹 묶음 
			RoundCnt =  arrI(11,ari)  '라운드수
			judgeCnt =  arrI(12,ari)   '심사위원수
			gamecodeidx = isnulldefault(arrI(13, ari),"") '게임난이율 테이블 인덱스
			gcnt = arrI(14,ari) '묶인부갯수
		Next
	End if



  addfld = " ,G1firstRC,G1korSin,G1gameSin,G1firstmemberSin,G2firstRC,G2KorSin,G2gameSin,G2firstmemberSin,a.itgubun "
  addfld = addfld & ", (select count(*)  from sd_gameMember_roundRecord where midx = a.gamememberidx and gamecodeseq > 0 ) as setCodeCount " '난이율설정된 갯수
  addfld = addfld & " ,case when a.itgubun = 'T' then (SELECT  STUFF(( select ','+ username from SD_gameMember_partner where gamememberidx = a.gamememberidx for XML path('') ),1,1, '' )) else '' end"   '파트너 있을때 단체일때 이름가져오기

  fld = " a.gameMemberIDX,a.gubun,a.gametime,a.gametimeend,a.place,a.PlayerIDX,a.userName,a.gbIDX,a.levelno,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.tryoutgroupno,a.tryoutsortNo,a.tryoutstateno,a.tryoutresult,a.roundNo,a.SortNo,a.stateno,a.gameResult,a.Team,a.TeamNm,a.userClass,a.Sex,a.requestIDX     ,a.bestscore,a.bestOrder,a.bestCDBNM,a.bestidx,a.bestdate,a.besttitle,a.bestgamecode,a.bestArea,a.startType,		a.ksportsno,a.kno,a.sidonm   ,CAST(a.tryouttotalorder as int) as tryouttotalorder ,a.tryoutOrder,a.gameOrder "

  fld = fld & "," & fldb & addfld  '53번부터 cda, cdc 추가 해서 2개 밀었음..

   'a.tryoutsortno > 0 and a.sortno > 0 순서번호가 설정된 값만 가져오자
   tbl = " SD_gameMember as a inner join tblRGameLevel as b	 ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delYN = 'N'  "
  
	If grouplevelidx = "0" Then '단독운영 / 묶음 운영
		SQL = "select "&fld&"  from "&tbl&" where b.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and b.RgameLevelidx = " & lidx & " order by "
		SQL = SQL & " a.tryoutsortno asc "
	else
		SQL = "select "&fld&"  from "&tbl&" where b.delyn = 'N' and a.gubun in (1,3) and a.tryoutsortno > 0 and (b.RgameLevelidx = " & lidx & " or  b.grouplevelidx = " & grouplevelidx & ")  order by "
		SQL = SQL & " b.gameno, a.tryoutsortno asc "
	End if
aaa = sql
   Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
		arrR = rs.GetRows()
		attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
		joocnt = 1
  End If



'배정된 심판정보 가져오기
fld = "isnull(jidx1,0),isnull(jidx2,0),isnull(jidx3,0),isnull(jidx4,0),isnull(jidx5,0),isnull(jidx6,0),isnull(jidx7,0),isnull(jidx8,0),isnull(jidx9,0),isnull(jidx10,0),isnull(jidx11,0),isnull(jidx12,0),isnull(jidx13,0),isnull(jidx14,0),isnull(jidx15,0)"
fld = fld & ",name1,name2,name3,name4,name5,name6,name7,name8,name9,name10,name11,name12,name13,name14,name15"
SQL = "Select top 1 "&fld&"  From sd_gameMember_roundRecord  Where tidx = "&tidx&"  And lidx = " & lidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then
	arrJ = rs.GetRows()
End if
%>




            <div class="box-body">

<%If IsArray(arrR) = false Then%>
<%'=SQLPrint%><br>
대진표가 작성되지 않았습니다. 
<!-- 예선이 종료되지 않았습니다. > 대회관리>부서선택>대진표설정 진행(레인배정) > 경기순서생성확인 -->
<%else%>
<%'=aaa%>
			  <table id="swtable_<%=lidx%>" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">

						<tr>
								<th>순서</th>
								<th style="width:80px;">부</th>
								<th style="width:80px;">R</th>
								<th style="width:80px;">선수</th>
								<th>선수</th>
								<th>소속</th>
								<th>시도</th>

								<%For odr = 1 To judgeCnt%>
								<th>심사<%=odr%></th>
								<%next%>
								<th>난의율</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
<%

		For ari = LBound(arrR, 2) To UBound(arrR, 2)
			l_midx = arrR(0, ari) 'midx
			l_PlayerIDX= arrR(5, ari)
			l_userName= arrR(6, ari)
			l_gbIDX= arrR(7, ari)
			l_levelno= arrR(8, ari)
			l_CDA= arrR(9, ari)
			l_CDANM= arrR(10, ari)
			l_CDB= arrR(11, ari)
			l_CDBNM= arrR(12, ari)
			l_CDC= arrR(13, ari)
			l_CDCNM= arrR(14, ari)
			l_tryoutgroupno= arrR(15, ari)
			l_tryoutsortNo= arrR(16, ari)
			l_tryoutstateno= arrR(17, ari)
			l_tryoutresult= arrR(18, ari)
			l_roundNo= arrR(19, ari)
			l_SortNo= arrR(20, ari)
			l_stateno= arrR(21, ari)
			l_gameResult= arrR(22, ari)
			l_Team= arrR(23, ari)
			l_TeamNm= shortNm(arrR(24, ari))
			l_userClass= arrR(25, ari)
			l_Sex= arrR(26, ari)
			l_requestIDX= arrR(27, ari)

			l_startType = arrR(36, ari) '1 예선부터 시작 3 결승부터 시작
			'####################
			l_ksportsno = arrR(37,ari)
			l_kno = arrR(38,ari)
			l_sidonm = arrR(39,ari)
			l_tryouttotalorder	 = arrR(40, ari) '총순위  (부에 총 조에 대한 순위) 예선 결승 시작인 경우 들어간다.
			l_tryoutorder	 = arrR(41, ari) '조순위
			l_gameOrder	 = arrR(42, ari) '결과 최종순위

			l_lidx = arrR(43,ari)

			l_ampm = arrR(45,ari)
			l_gamedate = arrR(46,ari)
			l_gno  = arrR(48,ari)
			l_itgubun= arrR(61,ari) '단체
			l_gamecode= arrR(62,ari) '난이율등록된 코드 갯수

			If l_itgubun = "T" then
				l_teammemberstr = arrR(63, ari)
				membernm = Split(l_teammemberstr, ",")
				l_userName = membernm(0)
				l_userName2 = membernm(1)
			End if

			chkrowno = l_tryoutgroupno

			l_raneno = l_tryoutsortNo

			If chkrowno > 0 Then '순서가 배정되었다면 그려라...***************

				'#####################################%>
							<tr class="gametitle" id="titlelist_<%=l_midx%>"  style="text-align:center;">
								<td>
								<%If chkrowno > 0 then%>
										<span><input  id="player_<%=l_midx%>" value = "<%=l_raneno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeMemberOrder(<%=l_midx%>,this.value,'<%=l_lidx%>',<%=lidx%>)" ></span>
								<%End if%>
								</td>

									<td><%=Replace(Replace(l_CDBNM,"남자","남자<br>"),"여자","여자<br>")%></td>
									<td>1~<%=RoundCnt%></td>
									<td><%=l_userName%></td>
									<td><%=l_userName2%></td>
									<td><%=l_TeamNm%></td>
									<td><%=l_sidoNm%></td>
									<%
									If isArray(arrJ) = True then
										For jx = LBound(arrJ, 2) To UBound(arrJ, 2)
											For odr = 0 To judgeCnt-1
												If arrJ(odr,jx) > 0 then
													If ari = 0 then
													%><td><a href="javascript:mx.changeJudge(<%=tidx%>, <%=lidx%>,<%=odr+1%>,<%=arrJ(odr,jx)%>)" class="btn btn-default"><%=arrJ(odr+15,jx)%></a></td><%
													Else
													%><td><%=arrJ(odr+15,jx)%></td><%
													End If
												Else
													%><td>-</td><%
												End if
											Next
										Next
								
									%>

									<%If RoundCnt =  l_gamecode then%>
									<td><a href="javascript:mx.setGameCodeWindow(<%=tidx%>,<%=lidx%>,<%=l_midx%>)" class="btn btn-primary">난이률설정 <%=l_gamecode%></a></td>
									<%else%>
									<td><a href="javascript:mx.setGameCodeWindow(<%=tidx%>,<%=lidx%>,<%=l_midx%>)" class="btn btn-default">난이률설정 <%=l_gamecode%></a></td>
									<%End if%>
									
									<%
									Else
										%><!--라운드설정안됨--><%
									End if
									%>
							</tr>
						<%
						prejoo = chkrowno
						%>
				<%'####################################

			End If
		Next
%>

					</tbody>
				</table>
<%End if%>

            </div>
<%

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>