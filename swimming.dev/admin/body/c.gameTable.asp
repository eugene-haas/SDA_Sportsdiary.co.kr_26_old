<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "TIDX") = "ok" Then 'tidx
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "CDA") = "ok" then
		cda =  oJSONoutput.CDA '대분류 코드 D2 경영
	Else
		cda = "D2"
	End If
	If hasown(oJSONoutput, "LNM") = "ok" then
		gametitle =  oJSONoutput.LNM
	End If
	
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx =  oJSONoutput.IDX
	End if

  'request 처리##############



  Set db = new clsDBHelper

	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	gameyy = " (select DATEPART(YYYY, games) as yy   from sd_gametitle where gametitleidx = a.gametitleidx ) as gameyy "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx,RGameLevelidx,"&gameyy&" "

	If idx = "" Then
	'마지막 대회 번호를 가져오자.
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and cda = '"&cda&"' and gametitleidx = "&tidx&"  order by gametitleidx desc, gbidx asc "
	else
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where RGameLevelidx =  '"&idx&"'  and cda = '"&cda&"'   "
	End if


	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2) 
		gametitlename = rs(3)
		titledetail = rs(0) & " " & rs(1) & " " & rs(2) 
		tidx = rs(4)
		gbidx = rs(5)
		idx = rs(6)
		gameyy = rs(7)
		
		
		If rs(2) = "수구" Then
			%>
			<script type="text/javascript">
			<!--
			px.goSubmit({'IDX':<%=idx%>},'gamedraw2.asp');
			//-->
			</script>			
			<%
			Response.end
		End if
	End If


  '++++++++++++++++++++++++
  '레인수 가져오기
  SQL = "select ranecnt from sd_gametitle where gametitleidx = " & tidx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  raneCnt = rs(0) '레인수

  fld = " a.gameMemberIDX,a.gubun,a.gametime,a.gametimeend,a.place,a.PlayerIDX,a.userName,a.gbIDX,a.levelno,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.tryoutgroupno,a.tryoutsortNo,a.tryoutstateno,a.tryoutresult,a.roundNo,a.SortNo,a.stateno,a.gameResult,a.Team,a.TeamNm,a.userClass,a.Sex,a.requestIDX     ,a.bestscore,a.bestOrder,a.bestCDBNM,a.bestidx,a.bestdate,a.besttitle,a.bestgamecode,a.bestArea "
  
  fldb = " ,b.RGameLevelidx,b.SetBestScoreYN,b.gubunam,b.tryoutgamedate,b.tryoutgamestarttime,b.tryoutgameingS,b.gubunpm,b.finalgamedate,b.finalgamestarttime,b.finalgameingS,b.gameno,b.joono,b.gameno2,b.joono2,a.starttype "

  SQL = "select "&fld & fldb & " from SD_gameMember as a inner join tblRgameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where a.delYN = 'N' and a.gubun in (1, 3)  and a.gametitleidx = '"&tidx&"' and a.gbidx = '"&gbidx&"' and b.gameno > 0   order by a.tryoutgroupno,a.tryoutsortNo asc"	 'gubun = 1 예선 3본선 (오전경기 불러오자)
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  joocnt = 0
  If Not rs.EOF Then
		arrR = rs.GetRows()
		attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
		joocnt = Ceil_a(attcnt / raneCnt) '조수

		starttype = arrR(50,0) '예선시작 1 '결승시작 3
		If startType = "1" Then
			startstr1 = "예선경기"
		Else
			startstr1 = "결승경기"
		End if
  End If


  '( 오후예선 또는 시작결승에 결승 또는 시작예선에 결승 레인번호가 정해진경우 )
  chkwhere = " (a.starttype = 1 and b.gubunpm = 1 ) Or (a.starttype = 3 and b.gubunpm = 3) Or (a.starttype = 1 and b.gubunpm = 3 and sortno > 0) "
  SQL = "select "&fld & fldb & " from SD_gameMember as a inner join tblRgameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx where a.delYN = 'N' and a.gubun in (1, 3)  and a.gametitleidx = '"&tidx&"' and a.gbidx = '"&gbidx&"'  and b.gameno2 >0  and ("&chkwhere&") order by a.tryoutgroupno,a.tryoutsortNo asc"	 'gubun = 1 예선 3본선 (오후경기 불러오자)
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  joocnt2 = 0
  If Not rs.EOF Then
		arrR2 = rs.GetRows()
		attcnt2 = CDbl(UBound(arrR2, 2)) + 1 '참가명수
		joocnt2 = Ceil_a(attcnt2 / raneCnt) '조수

		starttype = arrR2(50,0) '예선시작 1 '결승시작 3
		If startType = "1" Then
			startstr2 = "예선경기"
		Else
			startstr2 = "결승경기"
		End if
  End If

  '##############

'Call getrowsdrow(arrr2)


  'rowspan 값 구하기 엑셀이 깨진다 정확하지 않으면
  tbl = " SD_gameMember as a inner join tblRgameLevel as b ON a.gametitleidx = b.gametitleidx and a.gbidx = b.gbidx "
  SQL = "select a.tryoutgroupno, count(*),max(a.startType) from"&tbl&" where   a.delYN = 'N' and b.gameno > 0 and a.gubun in (1, 3)  and a.gametitleidx = '"&tidx&"' and a.gbidx = '"&gbidx&"' group by a.tryoutgroupno order by a.tryoutgroupno asc  " 'gubun = 1 예선 3 본선 (오전경기 명수)
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
		Rcnt = rs.GetRows()
		startType = Rcnt(2, 0) '1 예선부터 시작 3 결승부터 시작
  End If


  SQL = "select a.tryoutgroupno, count(*),max(a.startType) from "&tbl&" where a.delYN = 'N' and a.gubun in (1, 3)  and a.gametitleidx = '"&tidx&"' and a.gbidx = '"&gbidx&"' and b.gameno2 >0  and ("&chkwhere&")   group by a.tryoutgroupno order by a.tryoutgroupno asc  " 'gubun = 1 예선 3 본선
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
		Rcnt2 = rs.GetRows()
		startType2 = Rcnt2(2, 0) '1 예선부터 시작 3 결승부터 시작
  End If


%>


<%'View ####################################################################################################%>
      <div class="box box-primary collapsed-box">
        <div class="box-header with-border">
          <h3 class="box-title"><%=lnm%></h3>
			  <!-- #include virtual = "/pub/html/swimming/gametableForm.asp" -->
		</div>
      </div>


<div class="box-body" id="gameinput_area">


<div class="row">
            <div class="col-md-6"  style="width:25%;">
				  <div class="form-group">



	  <%'===============%>
				<table class="table table-bordered table-hover">
	                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>조선택</th>
						</tr>
					</thead>
					<tbody id="jmn">

						<%For i = 1 To joocnt%>
						<tr id="jmn_<%=i%>">
							<td onmousedown="mx.setFocus(<%=i%>)"><%=startstr1%><%=i%></td>
						</tr>
						<%Next%>

						<%
						If joocnt2 > 0 then
						For p = i To joocnt2 + i%>
						<tr id="jmn_<%=p%>">
							<td onmousedown="mx.setFocus(<%=p%>)"><%=startstr2%><%=p%></td>
						</tr>
						<%Next
						End if
						%>



					</tbody>
				</table>
	  <%'===============%>


				  </div>
            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6" style="width:75%;">
				  <div class="form-group">



	  <%'===============%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
						<div class="row">
							<div class="col-md-6" style="width:50%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group"><%'KYN 유년부의 부서가 달라져서 넣었으나 대한 채육회 정보와 틀려서 사용하지 않음 이후 사용한다고 하면 그냥 거기서 값 구하자. %>
									<a href="javascript:px.goSubmit({'CDA':'<%=cda%>','YY':'<%=gameyy%>','KYN':'N'},'gamerecord.asp')" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i> 대회목록보기</a>
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
										  <a href="javascript:px.exportExcel( '<%=gametitlename%>', '<%=titledetail%>' ,'swtable')" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀다운로드</a>
								  </div>
							</div>
						</div>			  
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>날짜</th>
								<th>라운드</th>
								<th>레인</th>
								<th>이름</th>
								<th>시도</th>
								<th>소속</th>
								<th>학년</th>
						</tr>
					</thead>
					<tbody id="contest_1"  class="gametitle">




<%

	i = 1
	jno = 1
	If IsArray(arrR) Then  '오전경기
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

			l_idx = arrR(0, ari)
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
			l_tryoutgroupno= arrR(15, ari) '예선본선 정보를 어떻게 넣을가....두개중 하나는 나오니 공통으로 묶어서 하나의 변수가지고 하자...그건 물어본뒤에 하는걸로
			l_tryoutsortNo= arrR(16, ari)
			l_tryoutstateno= arrR(17, ari)
			l_tryoutresult= arrR(18, ari)
			l_roundNo= arrR(19, ari)
			l_SortNo= arrR(20, ari)
			l_stateno= arrR(21, ari)
			l_gameResult= arrR(22, ari)
			l_Team= arrR(23, ari)
			l_TeamNm= arrR(24, ari)
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

			If startType = "3" Then
				'l_tryoutgroupno = l_roundNo '여기서 구분하고 아래에 헛갈리지 말자
				'l_tryoutsortNo = l_SortNo
			End if
			
				
			l_RGameLevelidx = arrR(36, ari)
			l_SetstScoreYN = arrR(37, ari)

			l_gunam = arrR(38, ari)
			l_tryoutgamedate = arrR(39, ari) '오전 경기 (명칭에 헛갈리지 말자)
			l_tryoutgamestarttime = arrR(40, ari)
			l_tryoutgameingS = arrR(41, ari)
			l_gunpm = arrR(42, ari)
			l_finalgamedate = arrR(43, ari)
			l_finalgamestarttime = arrR(44, ari)
			l_finalgameingS = arrR(45, ari)
			l_gameno = arrR(46, ari)
			l_joono = arrR(47, ari)
			l_gameno2 = arrR(48, ari)
			l_joono2 = arrR(49, ari)

			l_starttype = arrR(50,ari) '예선시작 1 '결승시작 3


	If l_tryoutgroupno > 0 Then'startType 으로만 구분된다. 시작점은
	If ari =  0 or prejoo <> l_tryoutgroupno Then
	'If ari > 0 And i Mod raneCnt  = 1 Then
		%>
		</tbody>
		<tbody  id="contest_<%=l_tryoutgroupno%>"  class="gametitle">
		<%
	'End If 
	End If
	End if

		%><!-- #include virtual = "/pub/html/swimming/gameTableList.asp" --><%


		pre_gameno = r_a2
		i = i + 1
		Next
	End if


'#####################################################

	i = 1
	jno = 1
	If IsArray(arrR2) Then  '오전경기
		For ari = LBound(arrR2, 2) To UBound(arrR2, 2)

			l_idx = arrR2(0, ari)
			l_gubun= arrR2(1, ari)
			l_gametime= arrR2(2, ari)
			l_gametimeend= arrR2(3, ari)
			l_place= arrR2(4, ari)
			l_PlayerIDX= arrR2(5, ari)
			l_userName= arrR2(6, ari)
			l_gbIDX= arrR2(7, ari)
			l_levelno= arrR2(8, ari)
			l_CDA= arrR2(9, ari)
			l_CDANM= arrR2(10, ari)
			l_CDB= arrR2(11, ari)
			l_CDBNM= arrR2(12, ari)
			l_CDC= arrR2(13, ari)
			l_CDCNM= arrR2(14, ari)
			l_tryoutgroupno= arrR2(15, ari) '예선본선 정보를 어떻게 넣을가....두개중 하나는 나오니 공통으로 묶어서 하나의 변수가지고 하자...그건 물어본뒤에 하는걸로
			l_tryoutsortNo= arrR2(16, ari)
			l_tryoutstateno= arrR2(17, ari)
			l_tryoutresult= arrR2(18, ari)
			l_roundNo= arrR2(19, ari)
			l_SortNo= arrR2(20, ari)
			l_stateno= arrR2(21, ari)
			l_gameResult= arrR2(22, ari)
			l_Team= arrR2(23, ari)
			l_TeamNm= arrR2(24, ari)
			l_userClass= arrR2(25, ari)
			l_Sex= arrR2(26, ari)
			l_requestIDX= arrR2(27, ari)
			l_bestscore= arrR2(28, ari)
			l_bestOrder = arrR2(29, ari)

			l_bestCDBNM= arrR2(30, ari)
			l_bestidx = arrR2(31, ari)
			l_bestdate = arrR2(32, ari)
			l_besttitle= arrR2(33, ari)
			l_bestgamecode= arrR2(34, ari)
			l_bestArea = arrR2(35, ari)

	
				
			l_RGameLevelidx = arrR2(36, ari)
			l_SetstScoreYN = arrR2(37, ari)

			l_gunam = arrR2(38, ari)
			l_tryoutgamedate = arrR2(39, ari) '오전 경기 (명칭에 헛갈리지 말자)
			l_tryoutgamestarttime = arrR2(40, ari)
			l_tryoutgameingS = arrR2(41, ari)
			l_gunpm = arrR2(42, ari)
			l_finalgamedate = arrR2(43, ari)
			l_finalgamestarttime = arrR2(44, ari)
			l_finalgameingS = arrR2(45, ari)
			l_gameno = arrR2(46, ari)
			l_joono = arrR2(47, ari)
			l_gameno2 = arrR2(48, ari)
			l_joono2 = arrR2(49, ari)

			l_starttype = arrR2(50,ari) '예선시작 1 '결승시작 3

	If l_tryoutgroupno > 0 Then
	If ari =  0 or prejoo <> l_tryoutgroupno Then
		%>
		</tbody>
		<tbody  id="contest_<%=l_tryoutgroupno%>"  class="gametitle">
		<%
	End If
	End if

		%><!-- #include virtual = "/pub/html/swimming/gameTableList2.asp" --><%


		pre_gameno = r_a2
		i = i + 1
		Next
	End if
%>








					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>
	  <%'===============%>



				  </div>
			</div>


</div>




</div>









