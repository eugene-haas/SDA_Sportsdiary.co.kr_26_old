<!-- #include virtual = "/pub/header.radingAdmin.asp" -->

<%
 'Controller ################################################################################################
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
	If hasown(oJSONoutput, "gameround") = "ok" Then '체전여부 A 두번복사여부
		gameround= oJSONoutput.gameround
	End If


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
	SQL = "Select  "&fieldstr&" from sd_TennisTitle where " & strWhere & " order by GameS desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rss.EOF Then
		arrPub = rss.GetRows()
		'Call getrowsdrow(arrpub)

		If tidx = "" Then
			If IsArray(arrPub)  Then
				tidx = arrPub(0, 0)
				GameTitleName = arrPub(1,0)
				kgame = arrPub(6, 0)
			End if
		Else

			If IsArray(arrPub)  Then
				For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
					f_tidx = arrPub(0, ar)
					f_tnm = arrPub(1, ar)

					If CStr(f_tidx) = CStr(F2_1) Then
						kgame = arrPub(6, ar)
						gametitlename = f_tnm
					End if
				Next
			End if


		End if
	End If


	If tidx = "" Then
		Response.write "대회가 존재하지 않습니다. 대회를 생성해 주십시오."
		Response.end
	End if

	'Response.write "#######################"&kgame
	'년도별 대회별 각경기 리스트
	strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.GbIDX " ',a.GameTitleIDX,a.GbIDX,b.useyear,b.levelno
	strfieldB = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,b.TeamGbNm,isnull(a.judgecnt,0), a.judgemaxpt, judgesignYN,judgeshowYN    ,b.ridingclass , b.ridingclasshelp    ,judgeB,judgeE,judgeM,judgeC,judgeH,  teamgb,judgecnt,bestsc     ,a.maxChk,a.minChk "
	strFieldName2 = strfieldA &  "," & strfieldB
	strSort2 = "  ORDER BY gameno asc"
	strWhere2 = " a.GameTitleIDX = '"&tidx&"' and a.gbidx = "&find_gbidx&" and a.DelYN = 'N' and b.DelYN = 'N' "

	SQL = "Select "&strFieldName2&" from "&strTableName2&" where " & strWhere2 & strSort2
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Call rsdrow(rs)
	'Response.end
	'Response.write f_gbidx

	If Not rs.EOF Then
		arrNo = rs.GetRows()
		'Call getrowsdrow(arrNo)

		If find_gbidx = "" Then
			If IsArray(arrNo)  Then
				find_gbidx = arrNo(1, 0)
			End if
		End if
	End If
	rs.close

	If IsArray(arrNo)  Then
		For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
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

					Exit for
			else
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

						Exit for
					End If
				'End If
			End if
		f_pregbidx = f_gbidx
		Next
	End if

'장애물 A타입이 아닌 모든경우 기본값
maxrndno = 1

    ' ===============================================================================================
    ' sub function
    ' ===============================================================================================

    ' ===============================================================================================
    ' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
	'fnc >> GetOrderType >> fn_riding.asp

    sel_orderType = GetOrderType(select_f_classhelp, select_f_teamgb, select_f_class)

	If select_f_teamgb = "20103" Then '복합마술(마장마술)
		sousoojerm = 1
	Else
		sousoojerm = 3
	End if


'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/riding/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/contest.js<%=CONST_JSVER%>"></script>

  <style>
		html,body,h1,div,p,span,table,colgroup,col,thead,tbody,tr,th,td,br{margin:0;padding:0;overflow:initial;}
		body{font-weight: bold;font-family:Calibri, Arial, Helvetica, sans-serif;background:#fff;box-sizing:border-box;}

		.page{width:290mm;height:198mm;font-size:9pt;font-weight:400;margin:0 auto 30px auto;}
		.page+.page{page-break-before:always;}

		.header{display:flex;flex-wrap:wrap;justify-content:space-between;}
		.header__titleName{width:100%;}
		.header__titleDate{width:50%;}
		.header__titleLevel{width:50%;text-align:right;}

		table{width:100%;margin-top:1mm;}
		table th{border:0.01mm solid #ccc;text-align:center;font-weight:400;line-height:1.1;}
		table td{border:0.01mm solid #ccc;font-weight:400;line-height:1.2;padding:0 1mm 0 .5mm;}

		table th.order{width:7.5mm;} /* 출전순서 */
		table th.partName{width:11mm;} /* 통합부명 */
		table th.playerName{width:13mm;} /* 선수명 */
		table th.horseName{width:20mm;} /* 마명 */
		table th.belongName{width:25mm;} /* 소속 */

		table th.partRanking{width:7.5mm;} /* 부별순위 */
		table th.totalRanking{width:7.5mm;} /* 전체순위*/

		table td.order{text-align:left;} /* 출전순서 */
		table td.partName{text-align:left;} /* 통합부명 */
		table td.playerName{text-align:left;} /* 선수명 */
		table td.horseName{text-align:left;} /* 마명 */
		table td.belongName{text-align:left;} /* 소속 */

		table td.partRanking{text-align:right;} /* 부별순위 */
		table td.totalRanking{text-align:right;} /* 전체순위 */


		/* 마장마술 */
		table.dressage th{height:6mm;}
		table.dressage td{height:8mm;font-size:8pt;}

		table.dressage td.pointRate{text-align:right;} /* 지점별 비율 */
		table.dressage td.pointRanking{text-align:right;} /* 지점별 순위 */
		table.dressage td.totalRate{text-align:right;} /* 총비율 */

		table.dressage tfoot tr th.noBorder{border:0;}
		table.dressage tfoot tr td.noBorder{border:0;}
		table.dressage tfoot tr td{height:16mm;}


		/* 장애물 */
		table.obstacles th{height:8mm;}
		table.obstacles td{font-size:8pt;}

		/* tableA, 2phase */
		table.obstacles th.obstacle{width:7.5mm;} /* 장애물 */
		table.obstacles th.etc{} /* 비고 */
		table.obstacles th.duration{width:10mm;} /* 소요시간 */
		table.obstacles th.timePenalty{width:7.5mm;} /* 시간감점 */
		table.obstacles th.obstaclePenalty{width:7.5mm;} /* 장애감점 */
		table.obstacles th.totalPenalty{width:7.5mm;} /* 감점합계 */

		table.obstacles.s_2phase td{height:5.2mm;}
		table.obstacles.s_TableA td{height:10mm;}
		table.obstacles td.obstacle{text-align:right;} /* 장애물 */
		table.obstacles td.etc{text-align:right;} /* 비고 */
		table.obstacles td.duration{text-align:right;} /* 소요시간 */
		table.obstacles td.timePenalty{text-align:right;} /* 시간감점 */
		table.obstacles td.obstaclePenalty{text-align:right;} /* 장애감점 */
		table.obstacles td.totalPenalty{text-align:right;} /* 감점합계 */


		/* tableC */
		table.obstacles th.duration_c{width:12mm;} /* 소요시간 */
		table.obstacles th.timePenalty_c{width:12mm;} /* 벌초 */
		table.obstacles th.totalDuration_c{width:12mm;} /* 총소요시간 */

		table.obstacles.s_TableC td{height:10mm;}
		table.obstacles td.duration_c{text-align:right;} /* 소요시간 */
		table.obstacles td.timePenalty_c{text-align:right;} /* 벌초 */
		table.obstacles td.totalDuration_c{text-align:right;} /* 총 소요시간 */


		/* 장애물 하단 */
		table.obstaclesBottom{margin-top:3mm;}
		table.obstaclesBottom th{height:8mm;}
		table.obstaclesBottom td{height:8mm;}
		table.obstaclesBottom th.game{width:25mm;text-align:center;}
		table.obstaclesBottom th.phase{width:25mm;text-align:center;}
		table.obstaclesBottom td.length{width:40mm;text-align:center;}
		table.obstaclesBottom td.tempo{width:40mm;text-align:center;}
		table.obstaclesBottom td.allowed{width:40mm;text-align:center;}
		table.obstaclesBottom td.limit{width:40mm;text-align:center;}
		table.obstaclesBottom td.sign{text-align:left;padding:0 2mm;}

		@media print{
			.page{margin-bottom:0px;}
		}

    /* @page{margin:3mm;} */


  </style>

</head>
<body <%=CONST_BODY%>>


<%
'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select top 1 a.judgecnt,a.judgemaxpt,a.judgesignYN,a.judgeshowYN,b.ridingclass , b.ridingclasshelp,  a.Bname,a.Ename,a.Mname,a.Cname,a.Hname      ,a.judgeB,a.judgeE,a.judgeM,a.judgeC,a.judgeH  from tblRGameLevel  as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx  where a.delyn = 'N' and b.delyn = 'N'  and  a.gametitleidx = '"&tidx&"' and a.Gbidx = '"&find_gbidx&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If
	rs.close

'Response.write sql
'Response.write sel_orderType
'Call getrowsdrow(arrc)

	If IsArray(arrC) Then
			r_judgecnt = arrC(0, 0)
			r_judgemaxpt = arrC(1, 0)
			r_judgesignYN = arrC(2, 0)
			r_judgeshowYN = arrC(3, 0)
			r_class = arrC(4, 0)
			r_classhelp = arrC(5, 0)

			Bjname = arrC(6, 0) '심판
			Ejname = arrC(7, 0)
			Mjname = arrC(8, 0)
			Cjname = arrC(9, 0)
			Hjname = arrC(10, 0)

			j_B = arrC(11, 0)
			j_E = arrC(12, 0)
			j_M = arrC(13, 0)
			j_C = arrC(14, 0)
			j_H = arrC(15, 0)
	End if




''''''''''''''''''''''''
'Response.write request("p")
'Response.write gameround &"########################"

If gameround = "" Then
	r_rdno = 1 '라운드 정보
else
	r_rdno = gameround '라운드 정보
End if



	'장애물정보
	tidxgbidx = tidx & find_gbidx
	field = " tidxgbidx,tidx,chk1,chk2,chk3,deduction1,deduction2,deduction3,deduction4,d4second,d5second,deduction5, hurdle1,hurdle2,hurdle3,hurdle4,hurdle5,hurdle6,hurdle7,hurdle8,hurdle9,hurdle10,hurdle11,hurdle12,hurdle13,hurdle14,hurdle15,hurdle16,hurdle17,hurdle18,hurdle19,hurdle20, hurdle2pahasegubun,totallength1,mspeed1,time1,limittime1,totallength2,mspeed2,time2,limittime2,installname,designname,useOK  "
	SQL = "select  " &field& " from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx  & "' and roundno =  " & r_rdno
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		Dim hurdleArr(19)
		If rs.EOF Then
			'장애물 기준 및 배치정보를 설정해주세요.
		Else
			For i = 0 To 19
				hurdleArr(i) = isNullDefault(rs("hurdle" & i+1),"")
			next
			jm01 = rs("chk1")
			jm02 = rs("chk2")
			jm08 = rs("chk3")

			jm03 = rs("deduction1")
			jm04 = rs("deduction2")
			jm05 = rs("deduction3")

			jm06 = rs("deduction4")
			jm07 = rs("d4second")

			jm09 = rs("d5second")
			jm10 = rs("deduction5")

			hurdle2pahasegubun = isNullDefault(rs("hurdle2pahasegubun"),"0") '구분값 1라운드 2라운드

			totallength1= rs("totallength1")
			mspeed1 = rs("mspeed1")
			time1 = rs("time1")
			limittime1 = rs("limittime1")

			totallength2= rs("totallength2")
			mspeed2 = rs("mspeed2")
			time2 = rs("time2")
			limittime2 = rs("limittime2")

			installname = rs("installname")
			designname = rs("designname")
			useOK = rs("useOK")  '실지 사용여부 설정 확인버튼 누를때 업데이트
		End If



		'마장마술 각지점별 순서 생성
		'ptorder_1,ptorder_2,ptorder_3,ptorder_4,ptorder_5
		If sel_orderType = "MM" Then

			If j_B = "Y" then
				'전체순위 업데이트 (각경기별) 전체업데이트   기준 score_total >> score_per 로 변경 19년 7월 8일 희정요청
				wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&find_gbidx&"' and gubun < 100 and ( (tryoutresult  = '0' and per_1 > 0) or  (tryoutresult in ('r','e') ) )   "
				Selecttbl = "( SELECT ptorder_1,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  per_1 end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
				SQL = "UPDATE A  SET A.ptorder_1 = A.RowNum FROM " & selecttbl
				Call db.execSQLRs(SQL , null, ConStr)
			End if

			If j_E = "Y" then
				'전체순위 업데이트 (각경기별) 전체업데이트   기준 score_total >> score_per 로 변경 19년 7월 8일 희정요청
				wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&find_gbidx&"' and gubun < 100 and ( (tryoutresult  = '0' and per_2 > 0) or  (tryoutresult in ('r','e') ) )   "
				Selecttbl = "( SELECT ptorder_2,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  per_2 end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
				SQL = "UPDATE A  SET A.ptorder_2 = A.RowNum FROM " & selecttbl
				Call db.execSQLRs(SQL , null, ConStr)
			End If

			If j_M = "Y" then
				'전체순위 업데이트 (각경기별) 전체업데이트   기준 score_total >> score_per 로 변경 19년 7월 8일 희정요청
				wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&find_gbidx&"' and gubun < 100 and ( (tryoutresult  = '0' and per_3 > 0) or  (tryoutresult in ('r','e') ) )   "
				Selecttbl = "( SELECT ptorder_3,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  per_3 end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
				SQL = "UPDATE A  SET A.ptorder_3 = A.RowNum FROM " & selecttbl
				Call db.execSQLRs(SQL , null, ConStr)
			End If

			If j_C = "Y" then
				'전체순위 업데이트 (각경기별) 전체업데이트   기준 score_total >> score_per 로 변경 19년 7월 8일 희정요청
				wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&find_gbidx&"' and gubun < 100 and ( (tryoutresult  = '0' and per_4 > 0) or  (tryoutresult in ('r','e') ) )   "
				Selecttbl = "( SELECT ptorder_4,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  per_4 end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
				SQL = "UPDATE A  SET A.ptorder_4 = A.RowNum FROM " & selecttbl
				Call db.execSQLRs(SQL , null, ConStr)
			End If

			If j_H = "Y" then
				'전체순위 업데이트 (각경기별) 전체업데이트   기준 score_total >> score_per 로 변경 19년 7월 8일 희정요청
				wherestr = " and gametitleidx =  '"&tidx&"' and gamekey3 = '"&find_gbidx&"' and gubun < 100 and ( (tryoutresult  = '0' and per_5 > 0) or  (tryoutresult in ('r','e') ) )   "
				Selecttbl = "( SELECT ptorder_5,RANK() OVER (Order By tryoutresult, Case when (tryoutresult = '0') then  per_5 end desc ) AS RowNum FROM SD_tennisMember where DelYN = 'N' "&wherestr&" ) AS A "
				SQL = "UPDATE A  SET A.ptorder_5 = A.RowNum FROM " & selecttbl
				Call db.execSQLRs(SQL , null, ConStr)
			End if
		End If


	'Gbidx 의 내용 위에 꺼랑 조인해서 가져오기.....class classhelp
	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
	fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 "
	fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval , a.jinputtxtarr ,a.bigo, a.bigo2    ,ptorder_1,ptorder_2,ptorder_3,ptorder_4,ptorder_5 "

	
	If sel_orderType = "릴레이" then
	fldnm = fldnm & " , (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ) )  as pnm " '그룹소속선수들
	fldnm = fldnm & " ,a.t_win, a.t_lose "
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and a.gubun < 100 order by tryoutsortno,a.tryoutgroupno asc"
	Else
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = "&r_rdno&" and a.gubun < 100 order by a.total_order, a.boo_orderno asc"
	End if

	'order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	If Not rs.EOF Then
		listcnt = rs.RecordCount
		arrZ = rs.GetRows()
		'Call getrowsdrow(arrz)
		'15개씩 몇개인지 나누자.
		'listcnt = CDbl(Ubound(arrZ)) + 1
		pagecnt = Ceil_a(listcnt / 15) '올림 무조건
	End If






	If select_f_classhelp = "FEI 238.2.2" Then
		'체전여부따져보자.
		If kgame = "Y" Then
				'4라운드 5라운드 제경기 값을 가져와서 3라운드 결과에 반영해 준다.

			If CDbl(r_rdno) = 3 then  
				SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 5 and a.gubun < 100 order by a.total_order, a.boo_orderno asc"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
				If Not rs.EOF Then
					arr5 = rs.GetRows()
				End If

				SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 4 and a.gubun < 100 order by a.total_order, a.boo_orderno asc"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
				If Not rs.EOF Then
					arr4 = rs.GetRows()
				End If

				'#########		
				If IsArray(arrZ) Then  '1라운드
				For a1 = LBound(arrZ, 2) To UBound(arrZ, 2)
					a1_pidx = arrZ(2, a1)	'pidx

					If IsArray(arr4) Then  '4라운드
						For a4 = LBound(arr4, 2) To UBound(arr4, 2)
							r4_pidx = arr4(2, a4)	'pidx
							If CStr(a1_pidx) = CStr(r4_pidx) Then
								For i = 0 To UBound(arr4, 1)
									arrZ(i , a1)	= arr4(i, a4)  
								next
								'response.write "<div>" & UBound(arr4, 1) & "</div>" 
							End if
						Next 
					End if				

					If IsArray(arr5) Then  '5라운드
						For a5 = LBound(arr5, 2) To UBound(arr5, 2)
							r3_pidx = arr5(2, a5)	'pidx
							If CStr(a1_pidx) = CStr(r3_pidx) Then
								For i = 0 To UBound(arr5, 1)
									arrZ(i , a1)	= arr5(i, a5)  
								next
								'response.write "<div>" & UBound(arr5, 1) & "</div>" 
							End if
						Next 
					End if								

				Next 
					 Call arraySort (arrZ, 26, "Number", "desc" ) 
				End if

			End if



		else

			If CDbl(r_rdno) = 1 then  
				'2라운드 3라운드 제경기 값을 가져와서 1라운드 결과값에 반영해 준다.
				SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 3 and a.gubun < 100 order by a.total_order, a.boo_orderno asc"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
				If Not rs.EOF Then
					arr3 = rs.GetRows()
				End If

				SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 2 and a.gubun < 100 order by a.total_order, a.boo_orderno asc"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
				If Not rs.EOF Then
					arr2 = rs.GetRows()
				End If




				'##############
				If CDbl(r_rdno) = 1 Then
					
					If IsArray(arrZ) Then  '1라운드
					For a1 = LBound(arrZ, 2) To UBound(arrZ, 2)
						a1_pidx = arrZ(2, a1)	'pidx

						If IsArray(arr2) Then  '2라운드
							For a2 = LBound(arr2, 2) To UBound(arr2, 2)
								r2_pidx = arr2(2, a2)	'pidx
								If CStr(a1_pidx) = CStr(r2_pidx) Then
									For i = 0 To UBound(arr2, 1)
										arrZ(i , a1)	= arr2(i, a2)  
									next
									'response.write "<div>" & UBound(arr2, 1) & "</div>" 
								End if
							Next 
						End if				

						If IsArray(arr3) Then  '3라운드
							For a3 = LBound(arr3, 2) To UBound(arr3, 2)
								r3_pidx = arr3(2, a3)	'pidx
								If CStr(a1_pidx) = CStr(r3_pidx) Then
									For i = 0 To UBound(arr3, 1)
										arrZ(i , a1)	= arr3(i, a3)  
									next
									'response.write "<div>" & UBound(arr2, 1) & "</div>" 
								End if
							Next 
						End if								

					Next 
						 Call arraySort (arrZ, 26, "Number", "desc" ) 
					End if

				End If

			End If

		End if
	End if



	rs.close
%>

<!--
	<div id="test">
	<%=listcnt%><br>
	<%=pagecnt%><br>
	<%=Ceil_dot(8.19,1)%><br>
	</div>
 -->

<%''=sel_orderType5%>
<%'Response.end%>
<%'=r_classhelp%>
<%'=CONST_TYPEA_1%>

<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%>
<%If sel_orderType = "MM" then%>

		<!-- #include file = "./body/printMM.asp" -->

<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%>
<%ElseIf sel_orderType = "릴레이" then%>
		<!-- #include file = "./body/printRelay.asp" -->
<%else%>

	<%Select Case r_classhelp %>
	<%Case CONST_TYPEA1 , CONST_TYPEA2,CONST_TYPEA_1 'type A   재경기가 있는 장애물 %>
		<!-- #include file = "./body/printJA.asp" -->

	<%Case CONST_TYPEB 'type B%>
		<!-- #include file = "./body/printJB2phase.asp" -->

	<%Case CONST_TYPEC 'type C%>
		<!-- #include file = "./body/printJC.asp" -->

	<%End select%>
<%End if%>


<%
	Call db.Dispose
	Set db = Nothing
%>
</body>
</html>
