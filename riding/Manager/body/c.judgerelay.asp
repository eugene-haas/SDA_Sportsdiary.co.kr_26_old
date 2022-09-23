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
	strfieldB = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,b.TeamGbNm,isnull(a.judgecnt,0), a.judgemaxpt, judgesignYN,judgeshowYN    ,b.ridingclass , b.ridingclasshelp    ,judgeB,judgeE,judgeM,judgeC,judgeH,  teamgb,judgecnt,bestsc     ,a.maxChk,a.minChk , a.gameday2 "
	strFieldName2 = strfieldA &  "," & strfieldB
	strSort2 = "  ORDER BY gameno asc"
	strWhere2 = " a.GameTitleIDX = '"&tidx&"' and a.DelYN = 'N' and b.DelYN = 'N' "

	SQL = "Select "&strFieldName2&" from "&strTableName2&" where " & strWhere2 & strSort2
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

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



'리그토너먼트 구분 2, 3
SQL = "Select max(gubun),count(*) from SD_tennisMember where gametitleidx ="&tidx&" and gamekey3 = '"&find_gbidx&"' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rs.eof Then
	gubunLT = rs(0)
	relayMembercnt = rs(1)
	gangtdno = getN(relayMembercnt)
End if



'토너먼트 리스트###################################################################
gidxfld = ", (SELECT  STUFF(( select top 10 ','+ CAST(idx AS varchar) from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ))  as gidx " '그룹소속선수들
pnmfld = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.gameMemberIDX order by orderno for XML path('') ),1,1, '' ) )  as pnm " '그룹소속선수들

tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 "
fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval "
fldnm = fldnm & gidxfld & pnmfld  & " , a.t_win, a.t_lose ,a.bigo "


'and round = 1 마장마술에서 쓰는 라운드 개념과 다름 실지 토너먼트 라운드 수가 들어감
SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"'  and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Call getrowsdrow(arrz)
'Call rsdrow(rs)
'Response.end

If Not rs.EOF Then
	arrZ = rs.GetRows()
	'리그토너먼트 구분 2, 3
	'gubunLT = arrZ(1,0)
End If
rs.close



'실적저장여부###############
SQL = "select top 1 essend from tblGameRecord where tidx = '"&tidx&"' and gbidx = '"&find_gbidx&"'"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
if not rs.eof Then
	essend = rs("essend")
end if
'실적저장여부###############

' ===============================================================================================
' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
'fnc >> GetOrderType >> fn_riding.asp
'teamgb > 20108, 20208 > 릴레이
sel_orderType = GetOrderType(select_f_classhelp, select_f_teamgb, select_f_class)




%>

<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>심사관리 > 심사기록입력</h1></div>

  <%'If CDbl(ADGRADE) > 500 then%>


	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/JudgerelayFindform.asp" -->
	</div>
	<!-- e: 정보 검색 -->
    <hr />
	<div class="info_serch">
	<%If gubunLT = "3" then%>
	<!-- #include virtual = "/pub/html/riding/judgerelayformdetail.asp" -->
	<%End if%>
	</div>



<script type="text/javascript" src="/pub/js/print/printThis.js?v=1.1.2"></script>


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

					&nbsp;&nbsp;<a href='javascript:$("#kssend").attr("class", "btn btn-danger");mx.saveResult(<%=tidx%>,<%=find_gbidx%>, "<%=kgame%>","<%=select_f_teamgb%>")' class="btn btn-<%if essend = "Y" then%>danger<%else%>default<%end if%>" id="kssend">결과/실적저장</a>
					</h3>
				</div>

			</div>
		</div>

		<table  cellspacing="0" cellpadding="0" class="table table-hover" id="tblriding">
			<thead>

				<%'토너먼트인지 리그인지 구별" sd_tennisMember.gubun 2, 3 리그 , 토너먼트%>
				<%If gubunLT = "2" Then%>
				<tr>
					<th>번호</th>
					<th>팀명</th>
					<th>마명</th>
					<th colspan="3">선수명</th>
					<th>기권/실격</th>
					<th>사유서</th>
					<th>승패</th>
					<th>순위</th>
					<th>비고</th>
				</tr>
				<%Else '토너먼트%>
				<tr>
					<th>경기순서</th>
					<th>팀명</th>
					<th>마명</th>
					<th colspan="3">선수명</th>
					<th>기권/실격</th>
					<th>사유서</th>
					<%For g= gangtdno To 1 Step -1%>
					<th>
					<%
					ggstr =2^g
					Select Case ggstr
					Case 4
						Response.write "준결승"
					Case 2
						Response.write "결승"
					Case Else
						Response.write ggstr & "강"
					End Select
					%>
					</th>
					<%next%>
					<th>순위</th>
				</tr>

				<%End if%>


			</thead>
			<tbody id="listcontents">







<%


'Response.write kgame & maxrndno &  "###########################"


					%><!-- #include virtual = "/pub/html/riding/judgelist_tn.asp" --><%



%>

			</tbody>
	  </table><br><br>


	  <%'===============%>
    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>


	  <input type="hidden" onclick="mx.makeGameTable(<%=tidx%>,'<%=find_gbidx%>',3,'drow')" id="drowTN">
			<%
			If gubunLT = "2" Then '리그

					Lfld = " a.gameMemberidx,a.playeridx,a.username,a.tryoutgroupno,a.tryoutsortno,a.gamekey3,a.gametitleidx,a.pubname   ,b.playeridx,b.username "
					SQL = "Select "&Lfld&" from sd_tennisMember as a left join  sd_tennisMember_partner as b on a.gameMemberidx = b.gameMemberidx  where a.gametitleidx =  '"&tidx&"' and a.gamekey3 = '"&find_gbidx&"' and a.delyn = 'N' order by a.tryoutsortno "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					arrT = rs.GetRows()

					Call drowLeage(arrT, "")


					gfldL = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.midxL group by pnm for XML path('') ),1,1, '' ))  as pnmL " '그룹소속선수들
					gfldR = ", (SELECT  STUFF(( select top 10 ','+ pnm from sd_groupMember where gameMemberIDX = a.midxR group by pnm for XML path('') ),1,1, '' ))  as pnmR " '그룹소속선수들

					'라운드 형태로 테이블 그림
					SQL = "Select orderno,idx,teamnmL,teamnmR,hnmL,hnmR,midxL,midxR "&gfldL&gfldR&",sayoocode,errL,errR ,errDocL,errDocR,   midxL,midxR,winMidx from sd_gameMember_vs as a   where tidx =  '"&tidx&"' and gbidx = '"&find_gbidx&"' and delyn = 'N' order by orderno "

					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					If Not rs.eof then
					arrL = rs.GetRows()
					'Call getrowsdrow(arrL)
					End if

			%>

	  <div class="row" id="tournament2" >
			<table cellspacing="0" cellpadding="0" class="table " style="width:98%;">
				<thead><tr><th>R</th><th>팀명</th><th>마명</th><th  colspan='3'>선수명</th><th>기권/실격사유</th><th>사유서제출</th><th>승패</th><th>경기결과</th></tr></thead>
					<tbody>
				<%
					If IsArray(arrL) Then
						For ari = LBound(arrL, 2) To UBound(arrL, 2)
							l_orderno = arrL(0,ari)
							l_idx = arrL(1,ari)
							l_teamnmL = arrL(2,ari)
							l_teamnmR = arrL(3,ari)
							l_hnmL = arrL(4,ari)
							l_hnmR = arrL(5,ari)
							l_errL = isnulldefault(arrL(11,ari),"")
							l_errR = isNulldefault(arrL(12,ari),"")
							l_errDocL = isnulldefault(arrL(13,ari),"")
							l_errdocR = isNulldefault(arrL(14,ari),"")

							l_midxL = arrL(15,ari)
							l_midxR = arrL(16,ari)
							l_winMidx = arrL(17,ari)

			l_pnmL = arrL(8, ari) '선수들
			If InStr(l_pnmL ,",") > 0 then
			pnmarrL = Split(l_pnmL,",")
				pnmL0 = pnmarrL(0)
				pnmL1 = pnmarrL(1)
				pnmL2 = pnmarrL(2)
			Else
				pnmL0 = ""
				pnmL1 = ""
				pnmL2 = ""
			End If

			l_pnmR = arrL(9, ari) '선수들
			If InStr(l_pnmR ,",") > 0 then
				pnmarrR = Split(l_pnmR,",")
				pnmR0 = pnmarrR(0)
				pnmR1 = pnmarrR(1)
				pnmR2 = pnmarrR(2)
			else
				pnmR0 = ""
				pnmR1 = ""
				pnmR2 = ""
			End if

					%>
							  <tr>
								<td style="width:100px;text-align:center;" rowspan="2">
									<%=l_orderno%> R
								</td>

								<td><span><%=l_teamnmL%></span></td>
								<td><span><%=l_hnmL%></span></td>
								<td><span><%=pnmL0%></span></td>
								<td><span><%=pnmL1%></span></td>
								<td><span><%=pnmL2%></span></td>

								<td>
								<span>
										<select id="giveupL_<%=l_idx%>" class="form-control<%If l_errL <> "" then%> btn-danger<%End if%>" onchange= "mx.setGiveUpR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'L')">
										<!-- 개별 바로바로 저장 -->
											<option value="">==사유선택==</option>
											<option value="E" <%If l_errL = "e" then%>selected<%End if%>>실권(E)</option>
											<option value="R" <%If l_errL = "r" then%>selected<%End if%>>기권(R) 진행중</option>
											<option value="W" <%If l_errL = "w" then%>selected<%End if%>>기권(W) 시작전</option>
											<option value="D" <%If l_errL = "d" then%>selected<%End if%>>실격(D)</option>
										</select>
								</span>
								</td>

								<td>
								<span>
										<select id="giveupdocL_<%=l_idx%>" class="form-control" onchange= "mx.setGiveUpDocR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'L')"><!-- 개별 바로바로 저장 -->
											<option value="">==선택==</option>
											<option value="Y"  <%If l_errDocL = "Y" then%>selected<%End if%>>○</option>
											<option value="N" <%If l_errDocL = "N" then%>selected<%End if%>>X</option>
										</select>
								</span>
								</td>
								<td><%If l_MidxL = l_winMidx then%>승<%End if%></td>
								<td style="width:100px;text-align:center;" rowspan="2">
									<button type="button" class="btn btn-block btn-default" onclick="mx.setResultWindow('<%=l_idx%>')">결과입력</button>
								</td>
							  </tr>

							  <tr>
								<td><span><%=l_teamnmR%></span></td>
								<td><span><%=l_hnmR%></span></td>
								<td><span><%=pnmR0%></span></td>
								<td><span><%=pnmR1%></span></td>
								<td><span><%=pnmR2%></span></td>

								<td>
								<span>
										<select id="giveupR_<%=l_idx%>" class="form-control<%If l_errR <> "" then%> btn-danger<%End if%>" onchange= "mx.setGiveUpR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'R')"><!-- 개별 바로바로 저장 -->
											<option value="">==사유선택==</option>
											<option value="E" <%If l_errR = "e" then%>selected<%End if%>>실권(E)</option>
											<option value="R" <%If l_errR = "r" then%>selected<%End if%>>기권(R) 진행중</option>
											<option value="W" <%If l_errR = "w" then%>selected<%End if%>>기권(W) 시작전</option>
											<option value="D" <%If l_errR = "d" then%>selected<%End if%>>실격(D)</option>
										</select>
								</span>
								</td>

								<td>
								<span>
										<select id="giveupdocR_<%=l_idx%>" class="form-control" onchange= "mx.setGiveUpDocR(<%=tidx%>,<%=find_gbidx%>,<%=l_idx%>,'R')"><!-- 개별 바로바로 저장 -->
											<option value="">==선택==</option>
											<option value="Y"  <%If l_errDocR = "Y" then%>selected<%End if%>>○</option>
											<option value="N" <%If l_errDocR = "N" then%>selected<%End if%>>X</option>
										</select>
								</span>
								</td>
								<td><%If l_MidxR = l_winMidx then%>승<%End if%></td>
							  </tr>
					<%

						Next
					End if
			%>
				</tbody>
			</table>
	  </div>
			<%






			ElseIf gubunLT = "3" Then '토너먼트
			%>
	  <div class="row" id="tournament2" style="padding-left:50px;">
				<script type="text/javascript">
					mx.makeGameTable(<%=tidx%>,'<%=find_gbidx%>',3,'drow');
				</script>
	  </div>
			<%
			End if
			%>
	  <%'===============%>




		<%If gubunLT = "3" Then '토너먼트
			fld = " idx,teamnmL,teamnmR,scoreL,scoreR,winmidx,result "
			SQL = "Select " & fld & " from sd_gameMember_vs where tidx = "&tidx&" and gbidx = '"&find_gbidx&"' and gangno = 0 and delyn = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				idx34 = rs(0)
				Lnm34 = rs(1)
				Rnm34 = rs(2)
				winidx34 = rs(5)
				result34 = rs(6)
			End if

		%>
		<table style="width:300px;">
		<tr>
			<td style="padding-left:30px;">
				<p class="ttMatch ttMatch_first" style="position:relative;<%If result34 = "L" then%>background:orange;<%End if%>">
				<span class="ttMatch__score"></span>
				<span class="ttMatch__playerWrap">
				  <span class="ttMatch__playerInner"  >
					<span class="ttMatch__player"><%=Lnm34%></span>
					<span class="ttMatch__belong"><%If Lnm34 <> "" then%><button type="button" class="btn btn-block btn-default" onclick="mx.setResultWindow('<%=idx34%>')">결과입력</button><%End if%></span>
				  </span>
				</span>
				</p>
				<p class="ttMatch ttMatch_second"  style="position:relative;<%If result34 = "R" then%>background:orange;<%End if%>">
				<span class="ttMatch__score"></span>
				<span class="ttMatch__playerWrap">
				  <span class="ttMatch__playerInner">
					<span class="ttMatch__player"><%=Rnm34%></span>
					<span class="ttMatch__belong"></span>
				  </span>
				</span>
				</p>
			</td>
		</tr>
		</table>
		<%End if%>


  </div>










</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>
