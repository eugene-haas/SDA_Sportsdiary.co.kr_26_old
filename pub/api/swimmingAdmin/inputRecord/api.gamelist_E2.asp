<%
  starttype = 3


	'G1firstRC				'(예선/본선) as a 첫주자기록 (단체)
	'G2firstRC				'(본선) as b 첫주자기록 (단체)

	'G1korSin				'a 한국신기록
	'G1gameSin				'a 대회신기록
	'G1firstmemberSin		'a 첫주자신기록(단체)

	'G2KorSin				'b 한국신기록
	'G2gameSin				'b 대회신기록 
	'G2firstmemberSin		'b 첫주자신기록 (단체)

  patnercntfld = " ,(select count(*) from sd_gameMember_partner where gameMemberIDX = a.gameMemberIDX and delyn = 'N'  and odrno < 5 ) as ptncnt "

  addfld = " ,G1firstRC,G1korSin,G1gameSin,G1firstmemberSin,G2firstRC,G2KorSin,G2gameSin,G2firstmemberSin,a.itgubun "
  fld = " a.gameMemberIDX,a.gubun,a.gametime,a.gametimeend,a.place,a.PlayerIDX,a.userName,a.gbIDX,a.levelno,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.tryoutgroupno,a.tryoutsortNo,a.tryoutstateno,a.tryoutresult,a.roundNo,a.SortNo,a.stateno,a.gameResult,a.Team,a.TeamNm,a.userClass,a.Sex,a.requestIDX     ,a.bestscore,a.bestOrder,a.bestCDBNM,a.bestidx,a.bestdate,a.besttitle,a.bestgamecode,a.bestArea,a.startType,		a.ksportsno,a.kno,a.sidonm   ,CAST(a.tryouttotalorder as int) as tryouttotalorder ,a.tryoutOrder,a.gameOrder "

  fld = fld & "," & fldb & addfld '53번부터 cda, cdc 추가 해서 2개 밀었음..
  fld = fld & patnercntfld

   ' a.tryoutsortno > 0 and a.sortno > 0 레인번호가 설정된 값만 가져오자
  tbl = " SD_gameMember as a inner join tblRGameLevel as b	 ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx and a.delYN = 'N' and b.delYN = 'N' "
  

	SQL = "select "&fld&"  from "&tbl&" where  a.gubun in (1,3) and a.tryoutsortno > 0 and b.RgameLevelidx = "&lidx&"  order by "
	If fldsort = "" then
	SQL = SQL & " a.tryoutsortno asc "
	Else
	SQL = SQL & "  tryouttotalorder asc "
	End if	

  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Response.write sql
'Call rsdrow(rs)
'Response.end



  If Not rs.EOF Then
		arrR = rs.GetRows()
		attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
		joocnt = 1
		startstr = ""
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
대진표가 작성되지 않았습니다. 
<!-- 예선이 종료되지 않았습니다. > 대회관리>부서선택>대진표설정 진행(레인배정) > 경기순서생성확인 -->
<%else%>
			  <table id="swtable_<%=lidx%>" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">

						<tr>
								<th><a href="javascript:$('#btn_<%=lidx%>').click();" class="btn btn-default">순서</a></th>
								<th>선수ID</th>
								<th style="width:80px;">이름</th>
								<th>ID2</th>
								<th>이름2</th>
								<th>소속팀</th>
								<th>시도</th>
								<th><a href="javascript:$('#btn2_<%=lidx%>').click();" class="btn btn-default">순위</a></th>
								<th>기록</th>
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

			l_G1firstRC = arrR(53,ari)
			l_G1korSin = arrR(54,ari)
			l_G1gameSin = arrR(55,ari)
			l_G1firstmemberSin = arrR(56,ari)

			l_G2firstRC = arrR(57,ari)
			l_G2KorSin = arrR(58,ari)
			l_G2gameSin = arrR(59,ari)
			l_G2firstmemberSin = arrR(60,ari)
			l_itgubun= arrR(61,ari) '단체

			l_ptncnt = arrR(62,ari)

			
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

			l_result = l_tryoutresult
			l_orderno = l_tryoutorder
			l_totalorderno = l_tryouttotalorder

			firstRC = l_G1firstRC
			firstSin = l_G1firstmemberSin
			korSin = l_G1korSin
			gameSin = l_G1gameSin



			SinRC = "" '라인초기화
			'신기록이 있다면
			If korSin <> "" Then
				SinRC = KorSin
			End if
			If korSin <> "" Then
				SinRC = gameSin
			End if

			
			l_err = ""
			Select Case  l_result
			Case "0",""
				l_result = "000.00"
			Case Else
				If isNumeric(l_result) = True then
					l_result = Left(	l_result,3) & "." & right(l_result,2)
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


				%><!-- #include virtual = "/pub/html/swimming/recordList_E2.asp" --><%

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