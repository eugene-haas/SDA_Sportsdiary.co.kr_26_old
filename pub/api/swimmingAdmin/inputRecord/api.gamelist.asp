<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "LIDX") = "ok" Then 'tblRGameLevel.RGameLevelidx
		lidx = oJSONoutput.LIDX
	End If

	If hasown(oJSONoutput, "AMPM") = "ok" Then
		ampm = oJSONoutput.AMPM
	End If

	If hasown(oJSONoutput, "GUBUN") = "ok" Then
		gubun = oJSONoutput.GUBUN '예선 결승 구분값 1, 3
	End If

	If hasown(oJSONoutput, "SORT") = "ok" Then
		fldsort = oJSONoutput.SORT
	End If

	'경기번호는

	Set db = new clsDBHelper



	'자기정보 AM
	If ampm = "am" Then
		fld = "RgameLevelidx,gametitleidx, gubunam,tryoutgamedate,tryoutgamestarttime,gameno,tryoutgameingS,gbidx,cda,cdc  " '52부터
		gnostr = " gameno "
		tmstr = " tryoutgamestarttime "
		gubunstr = " gubunam "
		dtstr = " tryoutgamedate "
	Else
		fld = "RgameLevelidx,gametitleidx, gubunpm,finalgamedate,finalgamestarttime,gameno2,finalgameingS,gbidx,cda,cdc   "
		gnostr = " gameno2 "
		tmstr = " finalgamestarttime "
		gubunstr = " gubunpm "
		dtstr = " finalgamedate "
	End if

	fldb = "b."& Replace(fld,",",",b.")

	  SQL = "Select "&fld&" from tblRGameLevel where RgameLevelidx = " & lidx
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  If Not rs.EOF Then
			arrI = rs.GetRows()
	  End If

	'Call getrowsdrow(arrI)


	If IsArray(arrI) Then
		For ari = LBound(arrI, 2) To UBound(arrI, 2)
			tidx =  arrI(1,ari)
			'gubun = arrI(2,ari) '예선 결승 1,3
			gamedate = arrI(3,ari) '경기일자
			starttim = arrI(4,ari) '시작시간
			gno = arrI(5, ari) '경기번호
			gameing = arrI(6, ari) '내경기시간
			gbidx = arrI(7,ari)
			cda = arrI(8,ari) '종목코드
			chk_cdc  = arrI(9,ari)
		Next
	End if


	Select Case cda
	Case "E2" '다이빙
		'Response.write chk_cdc
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.gamelist_E2.asp" --><%
		Response.End
	Case "F2" '아티스틱
		'Response.write chk_cdc
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.gamelist_F2.asp" --><%
		Response.end
	Case "D2"
	End  Select






  '레인수 가져오기
  SQL = "select ranecnt from sd_gametitle where gametitleidx = " & tidx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  raneCnt = rs(0) '레인수

  'startType 가져오기 (시작이 예선인지 결승인지 1, 3)
  SQL = "Select top 1 starttype from sd_gameMember where delyn = 'N' and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  starttype = rs(0)


	'G1firstRC				'(예선/본선) as a 첫주자기록 (단체)
	'G2firstRC				'(본선) as b 첫주자기록 (단체)

	'G1korSin				'a 한국신기록
	'G1gameSin				'a 대회신기록
	'G1firstmemberSin		'a 첫주자신기록(단체)

	'G2KorSin				'b 한국신기록
	'G2gameSin				'b 대회신기록
	'G2firstmemberSin		'b 첫주자신기록 (단체)

  patnercntfld = " ,(select count(*) from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and delyn = 'N'  and odrno < 5 ) as ptncnt "

  addfld = " ,G1firstRC,G1korSin,G1gameSin,G1firstmemberSin,G2firstRC,G2KorSin,G2gameSin,G2firstmemberSin "
  fld = " a.gameMemberIDX,a.gubun,a.gametime,a.gametimeend,a.place,a.PlayerIDX,a.userName,a.gbIDX,a.levelno,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.tryoutgroupno,a.tryoutsortNo,a.tryoutstateno,a.tryoutresult,a.roundNo,a.SortNo,a.stateno,a.gameResult,a.Team,a.TeamNm,a.userClass,a.Sex,a.requestIDX     ,a.bestscore,a.bestOrder,a.bestCDBNM,a.bestidx,a.bestdate,a.besttitle,a.bestgamecode,a.bestArea,a.startType,		a.ksportsno,a.kno,a.sidonm   ,a.tryouttotalorder,a.tryoutOrder,a.gameOrder "

  fld = fld & "," & fldb & addfld  & patnercntfld   '53번부터 cda, cdc 추가 해서 2개 밀었음..


   ' a.tryoutsortno > 0 and a.sortno > 0 레인번호가 설정된 값만 가져오자
  tbl = " SD_gameMember as a inner join tblRGameLevel as b	 ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delYN = 'N' and b.delYN = 'N' "

  'SQL = SQL & " case when a.tryoutgroupno = 0 then a.RoundNo else a.tryoutgroupno end asc,case when a.tryoutgroupno = 0 then a.SortNo else a.tryoutsortno end asc "
  '예선 본선구분 #####################



  If gubun = "1"  Then '예선 (starttype)
	SQL = "select "&fld&"  from "&tbl&" where  a.gubun in (1,3) and a.starttype = 1 and  a.tryoutsortno > 0 and b.RgameLevelidx = "&lidx&"  order by "

	'여기 상황에 따라서 잘불러야한다.
	If fldsort = "" then
	SQL = SQL & " a.tryoutgroupno asc, a.tryoutsortno asc "
	Else
	SQL = SQL & " a.tryoutgroupno asc, a.tryoutOrder asc "
	End if


  Else '결승

	If starttype = "1" Then '예선부터 시작한 결승
		SQL = "select "&fld&"  from "&tbl&" where  a.gubun in (1,3) and  a.starttype =1 and a.sortno > 0  and b.RgameLevelidx = "&lidx&" order by "

	  '여기 상황에 따라서 잘불러야한다.
	  If fldsort = "" then
	  SQL = SQL & " a.RoundNo asc, a.SortNo asc "
	  Else
	  SQL = SQL & " a.RoundNo asc, a.gameOrder asc "
	  End if

	Else '바로 결승

		SQL = "select "&fld&"  from "&tbl&" where  a.gubun in (1,3) and a.starttype = 3 and  a.tryoutsortno > 0 and b.RgameLevelidx = "&lidx&"  order by "
		If fldsort = "" then
		SQL = SQL & " a.tryoutgroupno asc, a.tryoutsortno asc "
		Else
		SQL = SQL & " a.tryoutgroupno asc, a.tryoutOrder asc "
		End if

	End if

  End If

  SQLPrint = sql

'Response.write sql
'Response.end

  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  '예선 본선구분 #####################

'If user_ip = "112.187.195.132" then
'Response.write sql
'''Call rsdrow(rs)
'Response.End
'End if



  If Not rs.EOF Then
		arrR = rs.GetRows()
		attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
		joocnt = Ceil_a(attcnt / raneCnt) '조수
		startType = arrR(36, 0) '1 예선부터 시작 3 결승부터 시작
		If startType = "1" Then
			startstr = "예선경기"
		Else
			startstr = "결승경기"
		End if
		'Response.write joocnt
  End If


  '사유코드 가져오기#####################
  SQL = "select code,codeNm from tblCode  where gubun = 2 and CDA = '"&cda&"' and delyn = 'N'  order by sortno asc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
		arrC = rs.GetRows()
  End if
  '사유코드 가져오기#####################
%>


    <div class="box-body">
	<%If IsArray(arrR) = false Then%>
		<%'=SQLPrint%><br>
		예선 종료 후, 확인 가능합니다.
		<!-- 예선이 종료되지 않았습니다. > 대회관리>부서선택>대진표설정 진행(레인배정) > 경기순서생성확인 -->
	<%else%>
			  <table id="swtable_<%=lidx%>" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">

						<tr>
								<th>조</th>
								<th><a href="javascript:$('#btn_<%=gno%>').click();" class="btn btn-default">레인</a></th>
								<th>선수ID</th>
								<%If ADGRADE > 500 then%>
								<th>체전번호</th>
								<%End if%>
								<th style="width:80px;">이름</th>
								<th>소속팀</th>
								<th>시도</th>
								<th><a href="javascript:$('#btn2_<%=gno%>').click();" class="btn btn-default">순위</a></th>
								<th>총순위</th>
								<th>첫주자기록</th>
								<th>첫주자신기록</th>
								<th>신기록</th>
								<th>기록</th>
								<%If ADGRADE > 500 then%>
								<th>Qualified</th>
								<%End if%>
								<th>사유</th>
								<th>오더등록</th>

						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">

						<%

							i = 1
							jno = 1
								firsttab = ubound(arrR,1)
								For ari = LBound(arrR, 2) To UBound(arrR, 2)

									l_midx = arrR(0, ari) 'midx
									l_gubun= arrR(1, ari)
									l_gametime= arrR(2, ari)
									l_gametimeend= arrR(3, ari)
									l_place= arrR(4, ari)
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
									l_bestscore= arrR(28, ari)
									l_bestOrder = arrR(29, ari)

									l_bestCDBNM= arrR(30, ari)
									l_bestidx = arrR(31, ari)
									l_bestdate = arrR(32, ari)
									l_besttitle= arrR(33, ari)
									l_bestgamecode= arrR(34, ari)
									l_bestArea = arrR(35, ari)
									l_startType = arrR(36, ari) '1 예선부터 시작 3 결승부터 시작




									'a.ksportsno,a.kno,a.sidonm,a.tryouttotalorder "
									'####################
									l_ksportsno = arrR(37,ari)
									l_kno = arrR(38,ari)
									l_sidonm = arrR(39,ari)
									l_tryouttotalorder	 = arrR(40, ari) '총순위  (부에 총 조에 대한 순위) 예선 결승 시작인 경우 들어간다.
									l_tryoutorder	 = arrR(41, ari) '조순위
									l_gameOrder	 = arrR(42, ari) '결과 최종순위

									l_lidx = arrR(43,ari)

									'l_tidx = arrR(44,ari)
									l_ampm = arrR(45,ari)
									l_gamedate = arrR(46,ari)
									l_gametime  = arrR(47,ari)
									l_gno  = arrR(48,ari)
									'l_ss  = arrR(49,ari)
									'l_gbidx = arrR(50,ari)

									'l_tryouttotalorder	 = arrR(40, ari) '총순위  (부에 총 조에 대한 순위) 예선 결승 시작인 경우 들어간다.
									'l_tryoutorder	 = arrR(41, ari) '조순위
									'l_gameOrder	 = arrR(42, ari) '결과 최종순위
									'l_orderno
									'l_totalorderno


									l_G1firstRC = arrR(53,ari)
									l_G1korSin = arrR(54,ari)
									l_G1gameSin = arrR(55,ari)
									l_G1firstmemberSin = arrR(56,ari)

									l_G2firstRC = arrR(57,ari)
									l_G2KorSin = arrR(58,ari)
									l_G2gameSin = arrR(59,ari)
									l_G2firstmemberSin = arrR(60,ari)
									l_ptncnt = arrR(61,ari)


									If l_tryoutgroupno > 0 Then

										chkrowno = l_tryoutgroupno
										l_raneno = l_tryoutsortNo

										l_orderno = 0
										l_totalorderno = 0

									Else
										chkrowno = l_roundNo
										l_raneno = l_SortNo

										l_orderno = 0
										l_totalorderno = 0
									End if



							firstRC = "" '라인초기화
							firstSin = "" '라인초기화
							Select Case ampm
							Case "am"  ' 오전경기

								If l_ampm = "1" then'예선
									gameTypestr = "예선"

									l_result = l_tryoutresult
									l_orderno = l_tryoutorder
									l_totalorderno = l_tryouttotalorder

									firstRC = l_G1firstRC
									firstSin = l_G1firstmemberSin
									korSin = l_G1korSin
									gameSin = l_G1gameSin

								Else'결승
									Select Case CStr(starttype)
									Case "3"  '시작이 결승으로 한거라면
										l_result = l_tryoutresult
										l_orderno = l_tryoutorder
										l_totalorderno = l_tryouttotalorder

										firstRC = l_G1firstRC
										firstSin = l_G1firstmemberSin
										korSin = l_G1korSin
										gameSin = l_G1gameSin

									Case "1"  '결승경기라면
										chkrowno = l_roundNo
										l_raneno = l_SortNo

										l_result = l_gameResult
										l_orderno = l_gameOrder
										l_totalorderno = l_gameOrder

										firstRC = l_G2firstRC
										firstSin = l_G2firstmemberSin
										korSin = l_G2korSin
										gameSin = l_G2gameSin
									End Select
								End If
%><!--<%="처음"%> --><%
							Case "pm" '오후경기

								If CStr(gameno2) = "1" then'예선
%><!--<%="예선"%> --><%
									gameTypestr = "예선"

									l_result = l_tryoutresult
									l_orderno = l_tryoutorder
									l_totalorderno = l_tryouttotalorder

									firstRC = l_G1firstRC
									firstSin = l_G1firstmemberSin
									korSin = l_G1korSin
									gameSin = l_G1gameSin
								
								Else'결승
%><!--:<%=l_G2korSin%>:<%=starttype%>: --><%
									Select Case Cstr(starttype)
									Case "3"  '시작이 결승으로 한거라면
										l_result = l_tryoutresult
										l_orderno = l_tryoutorder
										l_totalorderno = l_tryouttotalorder

										firstRC = l_G1firstRC
										firstSin = l_G1firstmemberSin
										korSin = l_G1korSin
										gameSin = l_G1gameSin
									
									Case "1"  '결승경기라면
										chkrowno = l_roundNo
										l_raneno = l_SortNo

										l_result = l_gameResult
										l_orderno = l_gameOrder
										l_totalorderno = l_gameOrder

										firstRC = l_G2firstRC
										firstSin = l_G2firstmemberSin
										korSin = l_G2korSin
										gameSin = l_G2gameSin
									End Select

								End If

							End select

								SinRC = "" '라인초기화
								'신기록이 있다면
								If korSin <> "" Then
									SinRC = KorSin
								End if
								If korSin = "" And gameSin <> "" Then
									SinRC = gameSin
								End if


								l_err = ""
								Select Case  l_result
								Case "0",""
									l_result = "00:00.00"
								Case Else
									If isNumeric(l_result) = True then
										l_result = Left(	l_result,2)& ":"	& Mid(l_result,3,2)& "."&Mid(l_result,5,2)
									Else
										l_err = l_result
										l_result = ""
									End if
								End Select



								'***************
								'체크해서 그리는 부분 중요 하다고 하자...나중에 또 확인할듯
								'***************
								If chkrowno > 0 Then '레인이 배정되었다면 그려라...***************
								If ari =  0 or prejoo <> chkrowno Then
									%>
									</tbody>
									<tbody  id="contest_<%=ari%>"  class="gametitle" >

									<%
								End If


										%><!-- #include virtual = "/pub/html/swimming/recordList.asp" --><%

								End If

								pre_gameno = r_a2
								i = i + 1
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
