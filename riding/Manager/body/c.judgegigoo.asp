<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################


'Response.write request("p")

	Set db = new clsDBHelper


	'소문자키 대문자 값
	Set errdic = CreateObject("Scripting.Dictionary")
	errdic.add "e","A"
	errdic.add "r","B"
	errdic.add "w","C"
	errdic.add "d","D"


	'등록된 최소년도
	SQL = "Select min(GameYear) from sd_TennisTitle where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End If
	rs.close

  	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' "
		findWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' "

		nowgameyear = year(date)
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("GameYear","gametitleidx","gbidx")
			F2_0 = F2(0)
			F2_1 = F2(1)
			F2_2 = F2(2)

			tidx = F2_1
			find_gbidx = F2_2
			strWhere = " DelYN = 'N' and "&fieldarr(0)&" = '" & F2_0 &"' and "&fieldarr(1)&" = '"& F2_1 &"' "
			findWhere = " DelYN = 'N'  and GameYear = '"&F2_0&"' "

			nowgameyear = F2_0
		Else
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "

			If LCase(F1) = "gameyear" Then
				nowgameyear = F2
			End if
		End if
	End if

	'년도별 대회명검색
	fieldstr =  "GameTitleIDX,GameTitleName,GameS,GameE,GameYear,GameArea,kgame  "
	SQL = "Select  "&fieldstr&" from sd_TennisTitle where " & findWhere & " order by GameS desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		arrPub = rss.GetRows()


		If tidx = "" Then
			If IsArray(arrPub)  Then
				tidx = arrPub(0, 0)
				kgame = arrPub(6, 0)
			End if


		End if
	End If

	If tidx = "" Then
		%>
		<script>px.goSubmit( {'F1':[0,1,2],'F2':['<%=year(date)-1%>','',''],'F3':[]} , 'judgedetail.asp');</script>
		<%
		'Response.write "대회가 존재하지 않습니다. 대회를 생성해 주십시오."
		Response.end
	End if

	'Response.write "#######################"&kgame

	'년도별 대회별 각경기 리스트
	strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.GbIDX " ',a.GameTitleIDX,a.GbIDX,b.useyear,b.levelno
	strfieldB = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,b.TeamGbNm,isnull(a.judgecnt,0), a.judgemaxpt, judgesignYN,judgeshowYN    ,b.ridingclass , b.ridingclasshelp    ,judgeB,judgeE,judgeM,judgeC,judgeH,  teamgb,judgecnt,bestsc     ,a.maxChk,a.minChk , a.gameday2      ,loopcnt, stm,resttm,staytime1,staytime2,staytime3,bpm1,bpm2,bpm3 "
	strFieldName2 = strfieldA &  "," & strfieldB
	strSort2 = "  ORDER BY gameno asc"
	strWhere2 = " a.GameTitleIDX = '"&tidx&"' and a.DelYN = 'N' and b.DelYN = 'N' "

	SQL = "Select "&strFieldName2&" from "&strTableName2&" where " & strWhere2 & strSort2
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrNo = rs.GetRows()
		If find_gbidx = "" Then
			If IsArray(arrNo)  Then
				find_gbidx = arrNo(1, 0)
				'Response.write find_gbidx &"ddd"
			End if
		End if
	End If
	rs.close

	If IsArray(arrNo)  Then
		For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
			'f_ridx = arrNo(0,ar) 'tblRGameLevel.RGameLevelidx
			f_gbidx = arrNo(1, ar)


			If F2_2 = "" Then
					select_f_ridx = arrNo(0,ar)
					find_gbidx = arrNo(1, ar)
					select_f_title =  arrNo(2, ar)
					select_f_date = arrNo(3,ar)
					select_f_stime = arrNo(4,ar)
					select_f_etime = arrNo(5,ar)
					Select_f_teamgbnm = arrNo(6,ar)
					select_f_judgecnt = arrNo(7, ar)
					select_f_judgemaxpt = arrNo(8, ar)
					select_f_judgesignYN = arrNo(9, ar)
					select_f_judgeshowYN = arrNo(10, ar)
					select_f_class = arrNo(11, ar)
					select_f_classhelp = arrNo(12, ar)

					select_f_teamgb = arrNO(18,ar)
					select_f_boocnt = arrNo(19,ar)
					select_f_bestsc = arrNo(20,ar)

					select_f_MAX =  arrNo(21,ar) '최고점제외
					select_f_MIN =  arrNo(22,ar)

					select_f_date2 = arrNo(23,ar)

					Exit for
			else
				'If f_gbidx = "" Or CStr(f_gbidx) <> CStr(f_pregbidx) Then
					If CStr(f_gbidx) = CStr(F2_2) Then
						select_f_ridx = arrNo(0,ar)
						find_gbidx = arrNo(1, ar)

						select_f_title =  arrNo(2, ar)
						select_f_date = arrNo(3,ar)
						select_f_stime = arrNo(4,ar)
						select_f_etime = arrNo(5,ar)
						Select_f_teamgbnm = arrNo(6,ar)
						select_f_judgecnt = arrNo(7, ar)
						select_f_judgemaxpt = arrNo(8, ar)
						select_f_judgesignYN = arrNo(9, ar)
						select_f_judgeshowYN = arrNo(10, ar)

						select_f_class = arrNo(11, ar)
						select_f_classhelp = arrNo(12, ar)

						select_f_teamgb = arrNO(18,ar)
						select_f_boocnt = arrNo(19,ar)
						select_f_bestsc = arrNo(20,ar)

						select_f_MAX =  arrNo(21,ar)
						select_f_MIN =  arrNo(22,ar)

						select_f_date2 = arrNo(23,ar)


						sgg_loopcnt = arrNo(24,ar)
						sgg_stm = arrNo(25,ar)
						sgg_resttm = arrNo(26,ar)
						sgg_staytime1 = arrNo(27,ar)
						sgg_staytime2 = arrNo(28,ar)
						sgg_staytime3 = arrNo(29,ar)
						sgg_bpm1 = arrNo(30,ar)
						sgg_bpm2 = arrNo(31,ar)
						sgg_bpm3 = arrNo(32,ar)

						Exit for
					End If
				'End If
			End if
		f_pregbidx = f_gbidx
		Next
	End if

'장애물 A타입이 아닌 모든경우 기본값
maxrndno = 1




'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


SQL = ";with idxtbl as ( "
SQL = SQL & " Select top 1 a.idx from tblTeamGbInfoDetail as a INNER JOIN tblTeamGbInfo as b ON a.useyear= b.useyear and b.teamgb = b.teamgb and a.ridingclass = b.ridingclass and a.ridingclasshelp = b.ridingclasshelp  "
SQL = SQL & " where a.delYN = 'N' and b.teamgbidx = "&find_gbidx&" ), "
SQL = SQL & "maxtbl as ( "
SQL = SQL & " Select  sum( isnull(maxval,0) * isnull(gesoo,0) ) as maxval  from tblTeamGbInfoDetail_S1  where delYN = 'N' and testtype in (1,2)  and idx in (select idx from idxtbl) "
SQL = SQL & ") "

SQL = SQL & " select isnull(maxval,0) from maxtbl "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.eof Then
select_f_judgemaxpt = rs(0)
SQL = " update tblRgameLevel Set judgemaxpt = "&select_f_judgemaxpt&" Where RGameLevelidx = " & select_f_ridx
Call db.execSQLRs(SQL , null, ConStr)
End If



'토너먼트 리스트###################################################################
gidxfld = ", (SELECT  STUFF(( select top 10 ','+ CAST(idx AS varchar) from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ))  as gidx " '그룹소속선수들
pnmfld = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ) )  as pnm " '그룹소속선수들

tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx  INNER JOIN sd_gameMember_geegoo as c ON a.gameMemberIDX = c.gameMemberIDX "
fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,a.total_order  ,gamest,round ,    score_6 "
fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval "
fldnm = fldnm & gidxfld & pnmfld  & " , a.t_win, a.t_lose ,a.bigo "


fldnm = fldnm & " ,c.loop1val1,c.loop1val2,c.loop1val3,c.loop1val4,c.loop1val5,c.loop1val6,c.loop1val7 "
fldnm = fldnm & " ,c.loop2val1,c.loop2val2,c.loop2val3,c.loop2val4,c.loop2val5,c.loop2val6,c.loop2val7 "
fldnm = fldnm & " ,c.loop3val1,c.loop3val2,c.loop3val3,c.loop3val4,c.loop3val5,c.loop3val6,c.loop3val7 "

fldnm = fldnm & " ,c.total_record,c.total_perspeed,c.total_result,c.total_order,c.total_grouporder,a.gamekey1 "


'Response.write fldnm

'and round = 1 마장마술에서 쓰는 라운드 개념과 다름 실지 토너먼트 라운드 수가 들어감
SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"'  and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Call rsdrow(rs)
'Response.end

If Not rs.EOF Then
	arrZ = rs.GetRows()
	'Call getrowsdrow(arrz)
	'리그토너먼트 구분 2, 3
	'gubunLT = arrZ(1,0)
Else


	'입력값 인서트
	SQL = "select isnull(max(groupno),0) +1 from sd_gameMember_geegoo "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	geegoogroupno = rs(0)

	SQL = "insert Into sd_gameMember_geegoo (gameMemberIDX,groupno,teamNm) (Select gameMemberidx, "&geegoogroupno&",teamANa  From sd_tennisMember Where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '"&find_gbidx&"'  and gubun < 100 )"
	'Response.write sql
	'Response.end
	Call db.execSQLRs(SQL , null, ConStr)

	'다시 읽는다.
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"'  and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	arrZ = rs.GetRows()
End If







rs.close



	Select Case LCase(select_f_class)
	Case "10km"
		attno = 100
		geegookm = 10000 'm
	Case "20km"
		attno = 200
		geegookm = 20000 'm
	Case "30km"
		attno = 300
		geegookm = 30000 'm
	Case "40km"
		attno = 400
		geegookm = 40000 'm
	End Select



' ===============================================================================================
' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
'fnc >> GetOrderType >> fn_riding.asp
'teamgb > 20108, 20208 > 릴레이
sel_orderType = GetOrderType(select_f_classhelp, select_f_teamgb, select_f_class)


'실적저장여부###############
SQL = "select top 1 essend from tblGameRecord where tidx = '"&tidx&"' and gbidx = '"&find_gbidx&"'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
if not rs.eof Then
	essend = rs("essend")
end if
'실적저장여부###############

%>

<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>심사관리 > 심사기록입력</h1></div>

  <%'If CDbl(ADGRADE) > 500 then%>


	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/JudgegigooFindform.asp" -->
	</div>
	<!-- e: 정보 검색 -->
    <hr />
	<div class="info_serch">
	<!-- #include virtual = "/pub/html/riding/judgeformgigoo.asp" -->
	</div>



<%If sgg_loopcnt <> "" then%>
<%if CDbl(sgg_loopcnt) > 0 Then '1루프이상 화면표시%>


  <div class="table-responsive" id="printdiv">

		<div class="container-fluid">
			<div class="row">

				<div class="col-sm-5 text-center bg-primary"  style="height:74px;">
					<h3 class="lead"><%=select_f_date%> &nbsp;&nbsp;&nbsp;  <%=select_f_stime%>~<%=select_f_etime%></h3>
				</div>
				<div class="col-sm-7 text-center bg-primary">
					<h3 class="lead"><%=select_f_title%>

					<!-- &nbsp;&nbsp;<a href="javascript:$('#printdiv').printThis({importCSS: false,loadCSS: 'http://ridingadmin.sportsdiary.co.kr/pub/js/print/print_table.css',header: '<h1><%=select_f_title%></h1>'});" class="btn btn-default">화면인쇄</a></span> -->

					&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>, 1)' class="btn btn-default">결과인쇄</a></span>
<!-- 					<a href='javascript:mx.sendResult()' class="btn btn-default">결과전송</a></span> -->

					&nbsp;&nbsp;<a href='javascript:$("#kssend").attr("class", "btn btn-danger");mx.saveResult(<%=tidx%>,<%=find_gbidx%>, "<%=kgame%>","<%=select_f_teamgb%>")' class="btn btn-<%if essend = "Y" then%>danger<%else%>default<%end if%>" id="kssend">결과/실적저장</a>
					</h3>
				</div>

			</div>
		</div>

		<table style="float:left;width:700px;white-space:nowrap;"  cellspacing="0" cellpadding="0" class="table table-hover" id="tblriding">
			<thead>
				<tr>
					<th colspan="8">&nbsp;</th>
				</tr>
				<tr>
					<th style="padding:10px;">참가<br>번호</th>
					<th>통합<br>부명</th>
					<th>선수명</th>
					<th>마명</th>
					<th>소속</th>
					<th>경기<br>상태</th>
				</tr>
			</thead>
			<tbody id="listcontents">
			<!-- #include virtual = "/pub/html/riding/judgelist_geegoo.asp" -->
			</tbody>
	  </table>


		<div class="" style="float:left;width:calc(100% - 700px);overflow-x:auto;white-space:nowrap;">
			<table class="table table-hover">
				<thead>
					<tr>
					<%For lcnt = 1 To sgg_loopcnt%>
						<%If CStr(lcnt) = CStr(sgg_loopcnt) then%>
						<th colspan="6" style="background:#5789BB"><%=lcnt%> Loop</th>
						<%else%>
						<th colspan="7" style="background:#5789BB"><%=lcnt%> Loop</th>
						<%End if%>
					<%Next %>
						<th colspan="5">&nbsp;</th>
					</tr>
					<tr>
					<%For lcnt = 1 To sgg_loopcnt%>
							<th>도착시간</th>
							<th>Vet gate<br>도착시간</th>
							<th>stay time<br>(3-2)</th>
							<th>BPM</th>
							<th>소요시간<br>(3-1)</th>
							<th>평군속력</th>
							<%If CStr(lcnt) = CStr(sgg_loopcnt) then%>
							<%else%>
							<th style="background:orange;">출발<br>예정시간</th>
							<%End if%>
					<%Next %>
							<th>최종기록</th>
							<th>평균시속</th>
							<th>불합격<br>사유</th>
							<th>최종<br>결과</th>
							<th><a href="javascript:location.reload();" class="btn btn-default">순위</a></th>
					</tr>
				</thead>
				<tbody>

<%
	'Call getrowsdrow(arrz)
	'Response.end

	If IsArray(arrZ) Then
		For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
			in01 = 0 '앱력전갯수
			in02 = 0 '입력중갯수
			in03 = 0 '완료갯수

			r_a1 = arrZ(0, ari) 'idx
			idx = r_a1
			r_a2 = arrZ(1, ari) 'gubun   0 순서설정전 1(순서설정완료 : 비체전인경우) 100 '공지사항 이름은 sc playeridx = 0 순서번호는 ? a.tryoutsortno,a.tryoutgroupno 1번위라면 0 100부터
			r_a3 = arrZ(2, ari)' pidx
			r_a4 = arrZ(3, ari) 'unm
			r_a5 = arrZ(4, ari) '종목
			r_a6 = arrZ(5, ari) '경기 그룹번호 (체전이아니면 이것만사용)
			r_a7 = arrZ(6, ari) '출전순서

			r_a8 = isNullDefault(arrZ(7, ari),"") '최종결과 (기권/실격포함)


			r_a9 = arrZ(8, ari) '소속
			r_a10 = arrZ(9, ari) '통합부명
			r_a11 = isNullDefault(arrZ(10, ari),"") '참가부명
			r_b1 = arrZ(11, ari) 'pidx 말
			r_b2 = arrZ(12, ari) '말명칭
			r_a12 = arrZ(13, ari) ' 경기시간

			r_a14 = arrZ(14, ari) 'gbidx
			r_a15 = arrZ(15, ari) 'requestIDX 참가신청 인덱스

			r_a8_1 = arrZ(16, ari) '문서제출여부

			'##################
			',score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order
			r_sgf = arrZ(17,ari) 'sgf
			r_s1 = isNullDefault(arrZ(18,ari),"")
			r_s2 = isNullDefault(arrZ(19,ari),"")
			r_s3 = isNullDefault(arrZ(20,ari),"")
			r_s4 = isNullDefault(arrZ(21,ari),"")
			r_s5 = isNullDefault(arrZ(22,ari),"")
			r_s6 = isNullDefault(arrZ(29,ari),"")

			r_stotal = arrZ(23,ari) '장애물 소요시간
			r_sper = arrZ(24,ari) '장애물인경우 B,C 타입 소요시간 2
			r_booorder = arrZ(25,ari)
			r_totalorder = arrZ(26,ari)

			'####
			r_loop1v1 = isnulldefault(arrZ(43,ari),"") '출발
			r_loop1v2 = isnulldefault(arrZ(44,ari),"") '도착
			r_loop1v3 = isnulldefault(arrZ(45,ari),"") 'vetgate
			r_loop1v4 = isnulldefault(arrZ(46,ari),"") 'stay time
			r_loop1v5 = isnulldefault(arrZ(47,ari),"") 'BPM
			r_loop1v6 = isnulldefault(arrZ(48,ari),"") '소요시간
			r_loop1v7 = isnulldefault(arrZ(49,ari),"") '평균속력

			r_loop2v1 = isnulldefault(arrZ(50,ari),"") '출발
			r_loop2v2 = isnulldefault(arrZ(51,ari),"") '도착
			r_loop2v3 = isnulldefault(arrZ(52,ari),"") 'vetgate
			r_loop2v4 = isnulldefault(arrZ(53,ari),"") 'stay time
			r_loop2v5 = isnulldefault(arrZ(54,ari),"") 'BPM
			r_loop2v6 = isnulldefault(arrZ(55,ari),"") '소요시간
			r_loop2v7 = isnulldefault(arrZ(56,ari),"") '평균속력

			r_loop3v1 = isnulldefault(arrZ(57,ari),"") '출발
			r_loop3v2 = isnulldefault(arrZ(58,ari),"") '도착
			r_loop3v3 = isnulldefault(arrZ(59,ari),"") 'vetgate
			r_loop3v4 = isnulldefault(arrZ(60,ari),"") 'stay time
			r_loop3v5 = isnulldefault(arrZ(61,ari),"") 'BPM
			r_loop3v6 = isnulldefault(arrZ(62,ari),"") '소요시간
			r_loop3v7 = isnulldefault(arrZ(63,ari),"") '평균속력


			r_total_record= isnulldefault(arrZ(64,ari),"") '최종기록
			r_total_perspeed= isnulldefault(arrZ(65,ari),"") '평균시속
			r_total_result= isnulldefault(arrZ(66,ari),"") '최종결과
			r_total_order = isnulldefault(arrZ(67,ari),"") '순위
			r_total_grouporder = isnulldefault(arrZ(68,ari),"") '그룹순위
			r_gamekey1 =  isnulldefault(arrZ(69,ari),"") '201 개인 202  단체

			'Response.write "@@@@@@@@@@@@@@@@@@@@@@@@"&in01

			If r_a12 <> "" And isnull(r_a12) = false then
				r_gametime = Split(Left(setTimeFormat(r_a12),5),":")
				r_hh = r_gametime(0)
				r_mm = r_gametime(1)
			Else
				r_hh = 0
				r_mm = 0
			End if
			%>


		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=idx%>" >

					<%For lcnt = 1 To sgg_loopcnt%>

						<%
						Select Case lcnt
						Case 1
							r_loopv1 = r_loop2v1 '출발

							r_loopv2 = r_loop1v2 '도착
							r_loopv3 = r_loop1v3 'vetgate
							r_loopv4 = r_loop1v4 'stay time
							r_loopv5 = r_loop1v5 'BPM
							r_loopv6 = r_loop1v6 '소요시간
							r_loopv7 = r_loop1v7 '평균속력


							If isnumeric(Replace(r_loopv4,":","")) then
								If CDbl(Replace(r_loopv4,":","")) - CDbl(sgg_staytime1& "00") > 0 Then
									staybg = "style=""background:gray;"""
								Else
									staybg = ""
								End If
							Else
								staybg = ""
							End If

							If isnumeric(r_loopv5) then
								If CDbl(r_loopv5) - CDbl(sgg_bpm1) > 0 Then
									bpmbg = "style=""background:gray;"""
								Else
									bpmbg = ""
								End If
							Else
								bpmbg = ""
							End If


						Case 2
							r_loopv1 = r_loop3v1 '출발
							r_loopv2 = r_loop2v2 '도착
							r_loopv3 = r_loop2v3 'vetgate
							r_loopv4 = r_loop2v4 'stay time
							r_loopv5 = r_loop2v5 'BPM
							r_loopv6 = r_loop2v6 '소요시간
							r_loopv7 = r_loop2v7 '평균속력

							If isnumeric(r_loopv4) then
								If CDbl(Replace(r_loopv4,":","")) - CDbl(sgg_staytime2& "00") > 0 Then
									staybg = "style=""background:gray;"""
								Else
									staybg = ""
								End If
							Else
								staybg = ""
							End If

							If isnumeric(r_loopv5) then
								If CDbl(r_loopv5) - CDbl(sgg_bpm2) > 0 Then
									bpmbg = "style=""background:gray;"""
								Else
									bpmbg = ""
								End If
							Else
								bpmbg = ""
							End If

						Case 3
							r_loopv1 = "" '출발
							r_loopv2 = r_loop3v2 '도착
							r_loopv3 = r_loop3v3 'vetgate
							r_loopv4 = r_loop3v4 'stay time
							r_loopv5 = r_loop3v5 'BPM
							r_loopv6 = r_loop3v6 '소요시간
							r_loopv7 = r_loop3v7 '평균속력

							If isnumeric(r_loopv4) then
								If CDbl(Replace(r_loopv4,":","")) - CDbl(sgg_staytime3& "00") > 0 Then
									staybg = "style=""background:gray;"""
								Else
									staybg = ""
								End If
							Else
								staybg = ""
							End If


							If isnumeric(r_loopv5) then
								If CDbl(r_loopv5) - CDbl(sgg_bpm3) > 0 Then
									bpmbg = "style=""background:gray;"""
								Else
									bpmbg = ""
								End If
							Else
								bpmbg = ""
							End If

						End Select


						If Left(r_total_result,2) = "20" Then
							r_total_resultstr = "실권"
						Else
							If r_total_perspeed = "" Then
								r_total_resultstr = ""
							else
								r_total_resultstr = "완주"
							End if
						End if
						%>


						<td>
						<%
						If CDbl(lcnt) = 1 then
							%>
							<input type="hidden" id="geegookm"  value="<%=geegookm%>"><!-- 거리 -->
							<input type="hidden" id="geegooresttm"  value="<%=sgg_resttm%>"><!-- 의무휴식시간 분 -->
							<input type="hidden" id="geegooloopcnt"  value="<%=sgg_loopcnt%>"><!-- 루프수 -->
							<input type="hidden" id="starttm_<%=lcnt%>_<%=idx%>"  value="<%=sgg_stm&":00"%>"><%
						End if
						%>

						<input type="text" id="arrive_<%=lcnt%>_<%=idx%>" placeholder="도착시간" value="<%=r_loopv2%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="6"  style="width:80px;" onblur="mx.setValGeeGoo(<%=select_f_ridx%>,<%=idx%>,$(this))"></td>
						<td><input type="text" id="vetgate_<%=lcnt%>_<%=idx%>" placeholder="vet gate" value="<%=r_loopv3%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="6"  style="width:80px;" onblur="mx.setValGeeGoo(<%=select_f_ridx%>,<%=idx%>,$(this))"></td>

						<td  <%=staybg%> ><input type="text" id="staytime_<%=lcnt%>_<%=idx%>" value="<%=r_loopv4%>" readonly style="border-width:0px;border:none;width:80px;" ></td>

						<td <%=bpmbg%>><input type="text" id="bpm_<%=lcnt%>_<%=idx%>" placeholder="BPM" value="<%=r_loopv5%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="2"   style="width:45px;" onblur="mx.setValGeeGoo(<%=select_f_ridx%>,<%=idx%>,$(this))"></td>

						<td><input type="text" id="timetaken_<%=lcnt%>_<%=idx%>"  value="<%=r_loopv6%>"  readonly style="border-width:0px;border:none;width:80px;" ></td>

						<td><input type="text" id="perspeed_<%=lcnt%>_<%=idx%>"  value="<%=r_loopv7%>"   readonly style="border-width:0px;border:none;width:60px;" ></td>

						<%If CStr(lcnt) = CStr(sgg_loopcnt) then%>
						<%else%>
						<td><input type="text" id="starttm_<%=lcnt+1%>_<%=idx%>"  value="<%=r_loopv1%>"  readonly style="border-width:0px;border:none;width:80px;" ></td>
						<%End if%>
					<%next%>



						<td style="background:#eee;"><input type="text" id="total_record_<%=idx%>"  value="<%=r_total_record%>" class="form-control"   readonly style="border-width:0px;border:none;width:80px;"  ></td>

						<td  style="background:#eee;"><input type="text" id="total_perspeed_<%=idx%>"  value="<%=r_total_perspeed%>" class="form-control" readonly style="border-width:0px;border:none;width:80px;" ></td>

						<td>
								<select id="giveup_<%=idx%>" class="form-control
								<%Select case r_a8

								Case "e" : Response.write "form-control-yellow"
								Case "r" :  Response.write "form-control-gray"
								Case "w" : Response.write "form-control-gray"
								Case "d" : Response.write "form-control-red"
								Case Else
								End Select
								%>"
								onchange= "mx.setGiveUpGeeGoo(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>,'ING')" style="width:100px;" >
									<option value="">==사유==</option>

									<option value="H" <%If r_a8 = "h" then%>selected<%End if%>>대사검사 불합격(출혈 및 부종)</option>
									<option value="I" <%If r_a8 = "i" then%>selected<%End if%>>대사검사 불합격(출혈)</option>
									<option value="J" <%If r_a8 = "j" then%>selected<%End if%>>대사검사 불합격(피로도)</option>
									<option value="K" <%If r_a8 = "k" then%>selected<%End if%>>보행검사 불합격</option>
									<option value="L" <%If r_a8 = "l" then%>selected<%End if%>>보행검사, 대사검사 불합격(피로 및 파행)</option>


									<option value="E" <%If r_a8 = "e" then%>selected<%End if%>>실권(E)</option>
									<option value="R" <%If r_a8 = "r" then%>selected<%End if%>>기권(R) 진행중</option>
									<option value="W" <%If r_a8 = "w" then%>selected<%End if%>>기권(W) 시작전</option>
									<option value="D" <%If r_a8 = "d" then%>selected<%End if%>>실격(D)</option>
								</select>
						</td>

						<td style="background:#eee;"><input type="text" id="total_result_<%=idx%>"  value="<%=r_total_resultstr%>" class="form-control"   readonly style="border-width:0px;border:none;width:50px;" ></td>

						<td>
						<%
						If r_gamekey1 = "202" Then
							orderno = r_total_grouporder
						else
							Select Case r_total_order
							Case "200" : orderno = "<span style='display:none;'>A</span>E"

							Case "201" : orderno = "<span style='display:none;'>A</span>E"
							Case "202" : orderno = "<span style='display:none;'>A</span>E"
							Case "203" : orderno = "<span style='display:none;'>A</span>E"
							Case "204" : orderno = "<span style='display:none;'>A</span>E"
							Case "205" : orderno = "<span style='display:none;'>A</span>E"

							Case "300" : orderno = "<span style='display:none;'>B</span>R"
							Case "400" : orderno = "<span style='display:none;'>C</span>W"
							Case "500" : orderno = "<span style='display:none;'>D</span>D"


							Case Else
								orderno = r_total_order
							End Select
						End if
						%>
						<%=orderno%>
						</td>


		  </tr>
<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		pre_booorder = r_booorder
		Next
	End if
%>







				</tbody>
			</table>
		</div>
<%End if%>
<%End if%>

</div>


<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>
