<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX '종목인덱스
	End If
	If hasown(oJSONoutput, "GB") = "ok" then
		gbidx =  oJSONoutput.GB '종목인덱스
	End If
	If hasown(oJSONoutput, "TGB") = "ok" then
		tidx =  oJSONoutput.TGB
	End If
	If hasown(oJSONoutput, "LNM") = "ok" then
		lnm= oJSONoutput.LNM
	End if




  'request 처리##############

  Set db = new clsDBHelper

	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx "

	If idx = "" Then
	'마지막 대회 번호를 가져오자.
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' order by gametitleidx desc, gbidx asc "
	else
	SQL = "Select " & fld & " from tblRGameLevel as a where RGameLevelidx =  '"&idx&"' "
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		If rs(2) = "수구" Then
			%>
			<script type="text/javascript">
			<!--
			px.goSubmit({'IDX':<%=idx%>,'SHOWTYPE':'drow'},'gamedraw2.asp');
			//-->
			</script>
			<%
			Response.end
		End if
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2)
		gametitlename = rs(3)
		titledetail = rs(0) & " " & rs(1) & " " & rs(2)
		tidx = rs(4)
		gbidx = rs(5)
	End If


  '++++++++++++++++++++++++
  '레인수 가져오기
  SQL = "select ranecnt from sd_gametitle where gametitleidx = " & tidx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  raneCnt = rs(0) '레인수

  '@@@@@@@@@@@@@
  fld = " gameMemberIDX,gubun,gametime,gametimeend,place,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,tryoutgroupno,tryoutsortNo,tryoutstateno,tryoutresult,roundNo,SortNo,stateno,gameResult,Team,TeamNm,userClass,Sex,requestIDX     ,bestscore,bestOrder,bestCDBNM,bestidx,bestdate,besttitle,bestgamecode,bestArea,sidonm "
  SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun in (1, 3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  order by tryoutgroupno,tryoutsortNo asc"	 'gubun = 1 예선 3본선

'  Response.write sql
  
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


  joocnt = 0
  If Not rs.EOF Then
		arrR = rs.GetRows()
		attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
		joocnt = Ceil_a(attcnt / raneCnt) '조수
  End If




  SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun in (1, 3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' and sortno > 0  order by roundno,sortno asc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  joocnt2 = 0
  If Not rs.EOF Then
		arrR2 = rs.GetRows()
		attcnt2 = CDbl(UBound(arrR2, 2)) + 1 '참가명수
		joocnt2 = Ceil_a(attcnt2 / raneCnt) '조수
  End If

  'Response.write idx & " " & gbidx
  'Call getrowsdrow(arrr2)
  '===================
  '@@@@@@@@@@@@@








  'rowspan 값 구하기 엑셀이 깨진다 정확하지 않으면
  SQL = "select tryoutgroupno, count(*),max(startType) from SD_gameMember where   delYN = 'N' and gubun in (1, 3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' group by tryoutgroupno order by tryoutgroupno asc  " 'gubun = 1 예선 3 본선
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
		Rcnt = rs.GetRows()
		startType = Rcnt(2, 0) '1 예선부터 시작 3 결승부터 시작
		If startType = "1" Then
			startstr = "예선경기"
		Else
			startstr = "결승경기"
		End if
  End If



  '결승 부서수 그냥 1인가
  SQL = "select roundno, count(*),max(startType) from SD_gameMember where   delYN = 'N' and gubun in (1, 3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  and sortno > 0  group by roundno order by roundno asc  " 'gubun = 1 예선 3 본선
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
		Rcnt2 = rs.GetRows()
  End If



%>


<%'View ####################################################################################################%>
      <div class="box box-primary collapsed-box">
        <div class="box-header with-border">
          <h3 class="box-title"><%=lnm%></h3>
			  <!-- #include virtual = "/pub/html/swimming/starttableForm.asp" -->
		</div>
      </div>


<div class="box-body" id="gameinput_area">


<div class="row">
				<%'2020-12-02 sticky 기능 추가(.t_sticky) by chansoo%>
            <div class="col-md-6 t_sticky"  style="width:25%;">
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
							<td onmousedown="mx.setFocus(<%=i%>)"><%=startstr%><%=i%></td>
						</tr>
						<%Next%>

						<%For i = 1 To joocnt2%>
						<tr id="jmn_<%=i%>999">
							<td onmousedown="mx.setFocus(<%=i%>999)">결승경기<%=i%></td>
						</tr>
						<%Next%>
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
									<a href="javascript:px.goSubmit({'IDX':<%=tidx%>,'TITLE':'<%=gametitlename%>','KYN':'N'},'contestlevel.asp?idx=<%=tidx%>')" id="btnsave" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i> 세부종목보기</a>
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">

										  <%If startType = "1" then%>
										  <a href="javascript:px.goSubmit({'IDX':<%=idx%>},'excel01.asp');" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>예선엑셀</a>
										  <%End if%>

										  <%If startType = "3" Or  IsArray(arrR2) Then%>
										  <a href="javascript:px.goSubmit({'IDX':<%=idx%>,'STARTTYPE':<%=startType%>},'excel02.asp');" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>결승엑셀</a>
										  <%End if%>


										  <!-- <a href="javascript:px.exportExcel( '<%=gametitlename%>', '<%=titledetail%>' ,'swtable')" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>화면다운로드</a> -->
								  </div>
							</div>
						</div>
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->

            <div class="box-body" id="swtable">
              <table  class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>조</th>
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
	If IsArray(arrR) Then
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
			l_sidonm = arrR(36,ari)

			If startType = "3" Then '구분만
				'l_tryoutgroupno = l_roundNo
				'l_tryoutsortNo = l_SortNo
			End if


	If l_tryoutgroupno > 0 then
	If ari =  0 or prejoo <> l_tryoutgroupno Then
	'If ari > 0 And i Mod raneCnt  = 1 Then
		%>
		</tbody>
		<tbody  id="contest_<%=l_tryoutgroupno%>"  class="gametitle">
		<%
	'End If
	End If
	End if

		%><!-- #include virtual = "/pub/html/swimming/startTableList.asp" --><%


		pre_gameno = r_a2
		i = i + 1
		Next
	End if
%>




					</tbody>
				</table>









<%'결승이 있으면 출력하자..=============================================

If startType = "1" Then '결승이 있는것만
If IsArray(arrR2) Then

'arrR = arraySort (arrR, 20, "Text", "desc" )

%>
              <table  class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th colspan = "6">결승</th>
						</tr>
						<tr>
								<th>조</th>
								<th>레인</th>
								<th>이름</th>
								<th>시도</th>
								<th>소속</th>
								<th>학년</th>
						</tr>
					</thead>
					<tbody id="contest_2"  class="gametitle">
					<%

						If IsArray(arrR2) Then
							For ari = LBound(arrR2, 2) To UBound(arrR2, 2)

								l_idx = arrR2(0, ari)
								l_gubun= arrR2(1, ari)
								l_gametime= arrR2(2, ari)
								l_gametimeend= arrR2(3, ari)
								l_PlayerIDX= arrR2(5, ari)
								l_userName= arrR2(6, ari)
								l_gbIDX= arrR2(7, ari)
								l_CDANM= arrR2(10, ari)
								l_CDBNM= arrR2(12, ari)
								l_CDCNM= arrR2(14, ari)
								l_roundNo= arrR2(19, ari)
								l_SortNo= arrR2(20, ari)
								l_TeamNm= arrR2(24, ari)
								l_userClass= arrR2(25, ari)
								l_sidonm = arrR(36,ari)

						If l_roundNo > 0 then

						If ari =  0 or prejoo2 <> l_roundNo Then
							%>
							</tbody>
							<tbody  id="contest_<%=l_roundNo%>999"  class="gametitle">
							<%
						End If
						End if

							%>

							<%'If l_SortNo > 0 then%>
							<tr class="gametitle" id="titlelist2_<%=l_idx%>"  style="text-align:center;">

								<%If l_roundNo > 0 then%>
									<%If ari =  0 or prejoo2 <> l_roundNo Then%>
										<td  rowspan="<%=Rcnt2(1, l_roundNo-1)%>" style="vertical-align:middle;"><%=l_roundNo%></td>
									<%End if%>
								<%else%>
									<td>&nbsp;</td>
								<%End if%>

									<%If l_roundNo > 0 then%>
									<td><%=l_SortNo%></td>
									<%else%>

									<%End if%>
								</td>
								<td><%=l_username%></td>
								<td><%=l_sidonm%></td>
								<td><%=l_teamnm%></td>
								<td><%=l_userClass%></td>
							</tr>
							<%prejoo2 = l_roundNo%>
							<%'End if%>

							<%

							Next
						End if
					%>




					</tbody>
				</table>

<%
End if
End if%>










            </div>
          </div>
        </div>

	  </div>
	  <%'===============%>



				  </div>
			</div>


</div>




</div>
