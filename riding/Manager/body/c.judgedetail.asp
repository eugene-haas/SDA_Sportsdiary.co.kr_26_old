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
	'tblRGameLevel 가 없는  tidx 제거 하자.
	fieldstr =  "GameTitleIDX,GameTitleName,GameS,GameE,GameYear,GameArea,kgame "
	SQL = "Select  "&fieldstr&" from sd_TennisTitle as a where " & findWhere & " and gametitleidx in ( select gametitleidx from tblRGameLevel where DelYN = 'N' group by gametitleidx )  order by GameS desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Response.end


	If Not rss.EOF Then
		arrPub = rss.GetRows()


		If tidx = "" Then
			If IsArray(arrPub)  Then
				tidx = arrPub(0, 0)
				kgame = arrPub(6, 0)
			End if


		End if
	End If


'Response.write sql
'Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'Call rsdrow(rss)



	If tidx = "" Then
		%>
		<script>px.goSubmit( {'F1':[0,1,2],'F2':['<%=year(date)-1%>','',''],'F3':[]} , 'judgedetail.asp');</script>
		<%
		'Response.write "대회가 존재하지 않습니다. 대회를 생성해 주십시오."
		Response.end
	End if

	'Response.write "#######################"&kgame

	'년도별 대회별 각경기 리스트
	strTableName2 = "  tblRGameLevel as a left join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx  and b.DelYN = 'N'  "
	strfieldA = " a.RGameLevelidx,a.GbIDX " ',a.GameTitleIDX,a.GbIDX,b.useyear,b.levelno
	strfieldB = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,b.TeamGbNm,isnull(a.judgecnt,0), a.judgemaxpt, judgesignYN,judgeshowYN    ,b.ridingclass , b.ridingclasshelp    ,judgeB,judgeE,judgeM,judgeC,judgeH,  teamgb,judgecnt,bestsc     ,a.maxChk,a.minChk , a.gameday2 "
	strFieldName2 = strfieldA &  "," & strfieldB
	strSort2 = "  ORDER BY gameno asc"
	strWhere2 = " a.GameTitleIDX = '"&tidx&"' and a.DelYN = 'N' "

	SQL = "Select "&strFieldName2&" from "&strTableName2&" where " & strWhere2 & strSort2
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Response.write sql
'Response.end

	'Call rsdrow(rs)
	'Response.end
	'Response.write f_gbidx

	If Not rs.EOF Then
		arrNo = rs.GetRows()
		If find_gbidx = "" Then
			If IsArray(arrNo)  Then
				find_gbidx = arrNo(1, 0)
				'Response.write find_gbidx &"ddd"
			End if
		End if
	Else
		Response.write "종목이 하나도 없는 대회가 있음 ( 년도의 종목이 생성되지 않은 세부종목이 있습니다. )"
		Response.end
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

					select_f_B = arrNo(13, ar)
					select_f_E = arrNo(14, ar)
					select_f_M = arrNo(15, ar)
					select_f_C = arrNo(16, ar)
					select_f_H = arrNo(17, ar)

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

'sss =  f_ridx & "_" & find_gbidx

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

						select_f_B = arrNo(13, ar)
						select_f_E = arrNo(14, ar)
						select_f_M = arrNo(15, ar)
						select_f_C = arrNo(16, ar)
						select_f_H = arrNo(17, ar)

						select_f_teamgb = arrNO(18,ar)
						select_f_boocnt = arrNo(19,ar)
						select_f_bestsc = arrNo(20,ar)

						select_f_MAX =  arrNo(21,ar)
						select_f_MIN =  arrNo(22,ar)

						select_f_date2 = arrNo(23,ar)

						Exit for
					End If
				'End If
			End if
		f_pregbidx = f_gbidx
		Next
	End if

'장애물 A타입이 아닌 모든경우 기본값
maxrndno = 1


	'find_gbidx
	'Select sum( isnull(a.maxval,0) * isnull(a.gesoo,0) )  from tblTeamGbInfoDetail_S1   where delYN = 'N' and testtype in (1,2)  and idx = 36

'최고가능점수 구하기
SQL = ";with idxtbl as ( "
SQL = SQL & " Select top 1 a.idx from tblTeamGbInfoDetail as a INNER JOIN tblTeamGbInfo as b ON a.useyear= b.useyear and b.teamgb = b.teamgb and a.ridingclass = b.ridingclass and a.ridingclasshelp = b.ridingclasshelp  "
SQL = SQL & " where a.delYN = 'N' and b.teamgbidx = '"&find_gbidx&"' and a.teamgb = '"&select_f_teamgb&"' ), "
SQL = SQL & "maxtbl as ( "
SQL = SQL & " Select  sum( isnull(maxval,0) * isnull(gesoo,0) ) as maxval  from tblTeamGbInfoDetail_S1  where delYN = 'N' and testtype in (1,2)  and idx in (select idx from idxtbl) "
SQL = SQL & ") "

SQL = SQL & " select isnull(maxval,0) from maxtbl "

'Response.write sql
'Response.end
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



If Not rs.eof Then
select_f_judgemaxpt = rs(0)
SQL = " update tblRgameLevel Set judgemaxpt = "&select_f_judgemaxpt&" Where RGameLevelidx = " & select_f_ridx
Call db.execSQLRs(SQL , null, ConStr)
End If


'sss =  f_ridx & "_" & find_gbidx & "A" & F2_2 &  "***"


    ' ===============================================================================================
    ' sub function
    ' ===============================================================================================

    ' ===============================================================================================
    ' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
	'fnc >> GetOrderType >> fn_riding.asp

    sel_orderType = GetOrderType(select_f_classhelp, select_f_teamgb, select_f_class)

	'단체전 / 개인전 분류
	If  Left(select_f_teamgb,3) = "202" Then
		gametypestr = "단체"
	Else
		gametypestr = "개인"
	End if

	If select_f_teamgb = "20103" Then '복합마술(마장마술)
		sousoojerm = 1
	Else
		sousoojerm = 3
	End if

'sss =  f_ridx & "_" & find_gbidx & "A" & F2_2 &  "***"

'Response.write "$$$$$$$$$$" & select_f_teamgb  & "<br>"
'Response.write "$$$$$$$$$$" & select_f_classhelp
'Response.write select_f_judgecnt & "##3"


'실적저장여부###############
SQL = "select top 1 essend from tblGameRecord where tidx = '"&tidx&"' and gbidx = '"&find_gbidx&"'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
if not rs.eof Then
	essend = rs("essend")
end if
'실적저장여부###############



%>
<!-- ###############<%=sel_orderType%><%=select_f_teamgb%>@@ -->


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>심사관리 > 심사기록입력</h1></div>

  <%'If CDbl(ADGRADE) > 500 then%>


	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/JudgeFindform.asp" -->
	</div>
	<!-- e: 정보 검색 -->
    <hr />


	<%If select_f_teamgb <> "20103" And select_f_teamgb <> "20208" Then '복합마술 릴레이%>


	<div class="row form-group">
	  <div class="table-responsive col-sm-8">
		<table cellspacing="0" cellpadding="0" class="table table-hover">
		   <thead><tr><th>통합부</th><th>현실인원</th><th>참가수</th><th>성립조건</th><th>통합체크</th></tr></thead>
		   <tbody id="contest_sub">
		   <tr class="gametitle" ></tr>
			  <!-- #include virtual = "/pub/html/riding/boocontrollistno.asp" -->
			</tbody>
		 </table>
	  </div>
		<div class="col-sm-2">
			<a href="javascript:mx.sumBooInJudge('<%=tIdx%>', '<%=find_gbidx%>', '<%=sel_orderType%>')" class="btn btn-primary" style="margin:10px 0;">통합</a>
			<a href="javascript:mx.divBooInJudge('<%=tIdx%>', '<%=find_gbidx%>', '<%=sel_orderType%>')" class="btn btn-danger" style="margin:10px 0;">분리</a>
			<a href="javascript:mx.refreshBooInJudge('<%=tIdx%>', '<%=find_gbidx%>','<%=nowgameyear%>')" class="btn btn-primary">부 현상황 조회(실인원)</a>
		</div>
	</div>
<%End if%>


<div class="info_serch">
<!-- #include virtual = "/pub/html/riding/judgeformdetail.asp" -->
</div>

<%'<!-- #include virtual = "/pub/html/riding/judgemodal.asp" -->%>




<script type="text/javascript" src="/pub/js/sort/sortable-tables.min.js?v=1.1.2"></script>
<!-- <script type="text/javascript" src="/pub/js/print/print.min.js?v=1.1.2"></script> -->
<script type="text/javascript" src="/pub/js/print/printThis.js?v=1.1.2"></script>
<script type="text/javascript">
<!--
	function findtd(obj){
		//console.log($(this).closest('th').prevAll().length);
	}
//-->
</script>



  <div class="table-responsive" id="printdiv">

		<div class="container-fluid">
			<div class="row">


					<%Select Case select_f_classhelp%>

					<%Case CONST_TYPEA1 , CONST_TYPEA2 'type A%>
						<div class="col-sm-5 text-center bg-primary">
							<h3 class="lead" style="float:left;"><%=select_f_date%> &nbsp;<%=select_f_stime%>~<%=select_f_etime%></h3>

									<%If kgame= "Y" then%>
									<div style="padding-top:15px;">
									<!-- <input class="form-control ip_txt" value="" style="width:300px;" type="datetime-local" id="meeting-time"  name="meeting-time" value=""  min="<%=year(now)-1%>-01-01T00:00" max="<%=year(now)+1%>-12-06T00:00"> -->
									&nbsp;<input id="kgame2rounddt" type="text" maxlength="16" value="<%=select_f_date2%>"  placeholder="<%=date%> 00:00 형식으로 입력"  class="form-control" style="width:220px;float:left;margin-left:5px;">
									<a href="javascript:mx.setDTK2RND(<%=select_f_ridx%>,$('#kgame2rounddt').val())" class="btn btn-default" style="float:left;">저장</a>
									</div>
									<%End if%>


						</div>
						<div class="col-sm-7 text-center bg-primary">
							<h3 class="lead"><%=select_f_title%></h3>
						</div>

					<%Case else%>
						<div class="col-sm-5 text-center bg-primary"  style="height:74px;">
							<h3 class="lead"><%=select_f_date%> &nbsp;&nbsp;&nbsp;  <%=select_f_stime%>~<%=select_f_etime%></h3>
						</div>
						<div class="col-sm-7 text-center bg-primary">
							<h3 class="lead"><%=select_f_title%>

							&nbsp;&nbsp;<a href="javascript:$('#printdiv').printThis({importCSS: false,loadCSS: 'http://ridingadmin.sportsdiary.co.kr/pub/js/print/print_table.css',header: '<h1><%=select_f_title%></h1>'});" class="btn btn-default">화면인쇄</a>

							&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>, 1)' class="btn btn-default">결과인쇄</a>
							&nbsp;&nbsp;<a href='javascript:$("#kssend").attr("class", "btn btn-danger");mx.saveResult(<%=tidx%>,<%=find_gbidx%>, "<%=kgame%>","<%=select_f_teamgb%>")' class="btn btn-<%if essend = "Y" then%>danger<%else%>default<%end if%>" id="kssend">결과/실적저장</a>
							</h3>
						</div>

					<%End select%>


			</div>
		</div>

		<table  cellspacing="0" cellpadding="0" class="table table-hover" id="tblriding">
			<thead>

				<%'Select Case Select_f_teamgbnm%>
				<%'Case "마장마술"%>
				<%If sel_orderType = "MM" Then%>
				<tr>
					<th rowspan="2">출전순서<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<th rowspan="2">시각</th>
					<th rowspan="2">통합부명</th><th rowspan="2">선수명</th><th rowspan="2">마명</th><th rowspan="2">소속</th>
					<th rowspan="2">참가부명</th><th rowspan="2">경기상태</th><th rowspan="2">기권/실격</th><th rowspan="2">사유서제출</th><th rowspan="2">기록입력</th>

					<th rowspan="2">총점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<!-- <th rowspan="2">종합관찰<br>총점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th><!-- console.log($(this).closest('th').prevAll().length+1) -->

					<th colspan="<%=select_f_boocnt%>"  >심판위원<%'=select_f_judgecnt%></th>
					<th rowspan="2">비율<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>

			<%If gametypestr = "단체" then%>
					<th rowspan="2">전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
					<th rowspan="2">단체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
					<th rowspan="2">단체총비율<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
			<%else%>
					<th rowspan="2">부별순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
					<th rowspan="2">전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
			<%End if%>

				</tr>

				<tr>
					<%If select_f_B = "Y" then%>
					<th>B지점<br>비율<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_E = "Y" then%>
					<th>E지점<br>비율<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_M = "Y" then%>
					<th>M지점<br>비율<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_C = "Y" then%>
					<th>C지점<br>비율<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_H = "Y" then%>
					<th>H지점<br>비율<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
				</tr>


				<%'Case "장애물"%>
				<%Else '마장마술아닌것들 (장애물)%>
					<%Select Case select_f_classhelp%>
					<%Case CONST_TYPEA1 , CONST_TYPEA2, CONST_TYPEA_1 'type A%>

					<%If select_f_classhelp <> CONST_TYPEA_1 then%>
					<tr>
						<td colspan="17" style="text-align:right;" class="tbl-btnarea">
							<%
								SQL = "Select max(round) from SD_tennisMember where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '" &find_gbidx & "'"
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
								If isNull(rs(0)) = False  Then
									maxrndno = rs(0)
								End if
							%>
						<%If kgame = "Y" then%>
							<%
							Select Case maxrndno
							Case "1" : kbtn_nm = "2라운드 생성"
							Case "2" : kbtn_nm = "결승 결과생성"
							Case "3" : kbtn_nm = "1단계 재경기 생성"
							Case "4" : kbtn_nm = "2단계 재경기 생성"
							End Select
							%>
							<a class="btn btn-danger" disabled>체전</a>&nbsp;&nbsp;
							<a href="javascript:$('#printdiv').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1><%=select_f_title%></h1>'});" class="btn btn-default">화면인쇄</a>&nbsp;&nbsp;

								&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>,1)' class="btn btn-default">결과인쇄</a>
								&nbsp;&nbsp;<a href='javascript:mx.saveResult(<%=tidx%>,<%=find_gbidx%>, "<%=kgame%>","<%=select_f_teamgb%>")' class="btn btn-default">최종결과저장</a>


							<%If select_f_teamgb <> "20103" Then '복합마술은 재경기가 없다.%>
							<a href="javascript:mx.makeReGame(<%=maxrndno%>,<%=tidx%>,<%=find_gbidx%>,'<%=kgame%>','<%=sel_orderType%>')" class="btn btn-primary"><%=kbtn_nm%></a>
							<%End if%>


						<%else%>
							<a class="btn btn-danger" disabled>일반</a>&nbsp;&nbsp;
							<a href="javascript:$('#printdiv').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1><%=select_f_title%></h1>'});" class="btn btn-default">화면인쇄</a>&nbsp;&nbsp;
							&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>,1)' class="btn btn-default">결과인쇄</a>
							&nbsp;&nbsp;<a href='javascript:mx.saveResult(<%=tidx%>,<%=find_gbidx%>, "<%=kgame%>","<%=select_f_teamgb%>")' class="btn btn-default">최종결과저장</a>


							<%If select_f_teamgb <> "20103" Then '복합마술은 재경기가 없다.%>
							<a href="javascript:mx.makeReGame(<%=maxrndno%>,<%=tidx%>,<%=find_gbidx%>,'<%=kgame%>','<%=sel_orderType%>')" class="btn btn-primary">재경기생성</a>
							<%End if%>

						<%End if%>
						</td>
					</tr>
					<%End if%>

					<tr>
						<th>출전순서<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th><th>경기상태</th><th>기권/실격</th><th>사유서제출</th><th>기록입력</th>
						<th>총소요시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>시간감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>장애감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>감점합계<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>

			<%If gametypestr = "단체" then%>
						<th>전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체총시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체총감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<%If select_f_classhelp <> CONST_TYPEA_1 and kgame = "N" And select_f_teamgb <> "20103" Then %>
						<th class='hidehtml'>재경기</th>
						<%End if%>
			<%else%>
						<th>부별순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<%If select_f_classhelp <> CONST_TYPEA_1 and kgame = "N" And select_f_teamgb <> "20103" Then %>
						<th class='hidehtml'>재경기</th>
						<%End if%>
			<%End if%>
					</tr>


					<%Case CONST_TYPEB 'type B%>
					<tr><!-- +6 한이유는 위에 tr 첫번째의 (아래 th갯수 8개 - th(1단계 + 2단계)) -->
						<th rowspan="2">출전순서<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>

						<th rowspan="2">통합부명</th><th rowspan="2">선수명</th><th rowspan="2">마명</th><th rowspan="2">소속</th><th rowspan="2">참가부명</th><th rowspan="2">경기상태</th><th rowspan="2">기권/실격</th><th rowspan="2">사유서제출</th><th rowspan="2">기록입력</th><th colspan="4">1단계</th><th colspan="4">2단계</th>
			<%If gametypestr = "단체" then%>
						<th rowspan="2">전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length +6 )" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length + 6)" class="btn btn-default btn-xs">▼</button></span></th>
						<th rowspan="2">단체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▼</button></span></th>
						<th rowspan="2">단체총시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▼</button></span></th>
						<th rowspan="2">단체총감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▼</button></span></th>
			<%else%>
						<th rowspan="2">부별순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▼</button></span></th>
						<th rowspan="2">전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length +6 )" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length + 6)" class="btn btn-default btn-xs">▼</button></span></th>
			<%End if%>
					</tr>
					<tr><!-- 10에 이유는 tr이 두개여서 아래쪽 갯수만큼 붙임 -->
						<th>총소요<br />시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length + 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>시간<br />감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length + 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>장애<br />감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length + 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>감점<br />합계<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>총소요<br />시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>시간<br />감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>장애<br />감점<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>감점<br />합계<br><span><button onclick="sortTD($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
					</tr>

					<%Case CONST_TYPEC 'type C%>
					<tr>
						<th>출전순서<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th><th>경기상태</th><th>기권/실격</th><th>사유서제출</th><th>기록입력</th>
						<th>소요시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>벌초<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>총소요시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
			<%If gametypestr = "단체" then%>
						<th>전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체총시간<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체총벌초<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
			<%else%>
						<th>부별순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>전체순위<br><span><button onclick="sortTD($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTD ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
			<%End if%>
					</tr>
					<%End Select%>
				<%End if%>
				<%'End Select%>

			</thead>
			<tbody id="listcontents">







<%


'Response.write kgame & maxrndno &  "###########################"
	If kgame = "Y" Then '체전
		For rndlist = 1 To maxrndno
			Select Case CDbl(rndlist)
				Case 1
					'2라운드 순위의 역순으로 출전순서 생성 해서 복사
					%><!-- #include virtual = "/pub/html/riding/judgelist.asp" --><%
				Case 2
					If select_f_teamgb <> "20103" Then
					'1단계 + 2단계 합산으로 출전 순위를 만들어서 결승 생성
					%><!-- #include virtual = "/pub/html/riding/judgelist1.asp" --><%
					End if
				Case 3
					If select_f_teamgb <> "20103" Then
					'결승
					%><!-- #include virtual = "/pub/html/riding/judgelist2.asp" --><%
					End if
				Case 4
					If select_f_teamgb <> "20103" Then
					'재경기 1회
					%><!-- #include virtual = "/pub/html/riding/judgelist3.asp" --><%
					End if
				Case 5
					If select_f_teamgb <> "20103" Then
					'재경기 1회
					%><!-- #include virtual = "/pub/html/riding/judgelist4.asp" --><%
					End if
				Case Else
					'2라운드 이상 없슴 공지.
			End Select
		next

	Else '비체전

		For rndlist = 0 To maxrndno
			Select Case rndlist
				Case 1
					'본경기
					%><!-- #include virtual = "/pub/html/riding/judgelist.asp" --><%
				Case 2
					'재경기 1회
					If select_f_teamgb <> "20103" Then
					%><!-- #include virtual = "/pub/html/riding/judgelist1.asp" --><%
					End if
				Case 3
					'재경기 2회
					If select_f_teamgb <> "20103" Then
					%><!-- #include virtual = "/pub/html/riding/judgelist2.asp" --><%
					End if
				Case Else
					'2라운드 이상 없슴
			End Select
		next

	End if


'복합마술인 경우 찾아서 하나 더 그리자... (그럼 소팅번호가 어떻게 되나. 복합마술은 단체전 없음)
If select_f_teamgb = "20103" Then
	%><!-- #include virtual = "/pub/html/riding/judgelistBM.asp" --><%
End if
%>

			</tbody>
	  </table><br><br>
  </div>

<%'결과 생성버튼
If select_f_teamgb = "20103" Then

	'장애물이 어떤걸까
	If sel_orderType = "MM" Then
		'첫번째 gbidx 가 장애물
		rt_gbidx = bm_gbidx1
	Else
		'두번째 gbidx 가 장애물
		rt_gbidx = find_gbidx
	End if

	%>
		<table  cellspacing="0" cellpadding="0" class="table table-hover" id="tblridingBMRT">
			<thead>
				<tr><th><%'생성할지 물어보자..%>
				<a href="javascript:mx.makeBMResult(<%=tidx%>,<%=bm_gbidx1%>,<%=find_gbidx%>,'<%=kgame%>','<%=sel_orderType%>')" class="btn btn-primary">최종 결과 생성</a>

				<a href="javascript:mx.saveResult(<%=tidx%>,<%=rt_gbidx%>,'<%=kgame%>','<%=select_f_teamgb%>')" class="btn btn-primary">최종 결과 저장</a>
				</th></tr>
			</thead>
		</table>



	<!-- #include virtual = "/pub/html/riding/judgelistBMResult.asp" -->
	<%
End if
%>



<%
'################################
'타이틀 정렬  설정
'################################
%>
<script type="text/javascript">
	var myTable = document.getElementById( "tblriding" );
	var replace = replacement( myTable );
	function sortTD( index ){    replace.ascending( index );    }
	function reverseTD( index ){    replace.descending( index );    }


	var myTableR1 = document.getElementById( "tblriding1" );

	if (myTableR1 != undefined){

	var replaceR1 = replacement( myTableR1 );
		function sortTDR1( index ){    replaceR1.ascending( index );    }
		function reverseTDR1( index ){    replaceR1.descending( index );    }
	}

	var myTableR2 = document.getElementById( "tblriding2" );

	if (myTableR2 != undefined){

	var replaceR2 = replacement( myTableR2 );
		function sortTDR2( index ){    replaceR2.ascending( index );    }
		function reverseTDR2( index ){    replaceR2.descending( index );    }
	}



	var myTableRBM = document.getElementById( "tblridingBM" ); //복합마술 2번째경기

	if (myTableRBM != undefined){

	var replaceRBM = replacement( myTableRBM );
		function sortTDRBM( index ){    replaceRBM.ascending( index );    }
		function reverseTDRBM( index ){    replaceRBM.descending( index );    }
	}

	var myTableRBMResult = document.getElementById( "tblridingBMResult" ); //복합마술 2번째경기

	if (myTableRBMResult != undefined){

	var replaceRBMResult = replacement( myTableRBMResult );
		function sortTDRBMResult( index ){    replaceRBMResult.ascending( index );    }
		function reverseTDRBMResult( index ){    replaceRBMResult.descending( index );    }
	}

</script>





</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>
