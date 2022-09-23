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

	If idx = "" Then
	'Response.redirect "/index.asp"
	'Response.end
	End if


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
			px.goSubmit({'IDX':<%=idx%>},'gamedraw2.asp');
			//-->
			</script>			
			<%
			Response.end
		End if
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2) 
		tidx = rs(4)
		gbidx = rs(5)
	End If





	'누락된사용자 찾아서 넣기 (단체도 일단 여기까지는 동일할듯)$$$$$$$$$$$$$$$$$$$$$$$
	SQL = "select top 1 starttype from SD_gameMember where delYN = 'N' and gubun in  (1,3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		d_starttype = rs(0)
	Else
		d_starttype = 1
	End if

	SQL = ";with  reqtbl as  "
	SQL =  SQL & " (select a.requestidx,P1_UserName,b.delyn,b.gamememberidx from tblgamerequest as a left join sd_gamemember as b on a.RequestIDX = b.requestIDX where a.gametitleidx = "&tidx&" and a.gbidx = '"&gbidx&"' and a.payok = 'Y' and a.delyn='N') "
	SQL =  SQL & " select * from reqtbl where delyn is Null or delyn = 'Y' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	Do Until rs.eof 
		d_requestidx = rs(0)
		d_playername = rs(1)
		d_delstate = rs(2)
		d_gamememberidx = rs(3)
		If d_delstate = "Y" Then
			SQL = "Update sd_gamemember set delyn = 'N' where gamememberidx = " & d_gamememberidx
			Call db.execSQLRs(SQL , null, ConStr)
		Else
		'null
			rfld = " GameTitleIDX,ITgubun,P1_ksportsno,P1_PlayerIDX,P1_UserName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,P1_Team,P1_TeamNm,P1_UserClass,P1_SEX,sidonm,RequestIDX	,joo,rane,'1'  ,'" & d_starttype & "' "
			minfld = " GameTitleIDX,Itgubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,Team,TeamNm,userClass,Sex,sidonm,requestIDX,tryoutgroupno,tryoutsortNo,gubun , starttype "  
			selectQ = "Select "&rfld&" from tblGameRequest where requestidx = " & d_requestidx
			SQL = "insert Into sd_gameMember ("&minfld&")  ("&selectQ&")"
			Call db.execSQLRs(SQL , null, ConStr)
		End if

	rs.movenext
	loop

	'Call rsdrow(rs)
	'누락된사용자 찾아서 넣기 (단체도 일단 여기까지는 동일할듯)$$$$$$$$$$$$$$$$$$$$$$$








  '++++++++++++++++++++++++
  '레인수 가져오기
  SQL = "select ranecnt from sd_gametitle where gametitleidx = " & tidx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  raneCnt = rs(0) '레인수

  fld = " gameMemberIDX,gubun,gametime,gametimeend,place,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,tryoutgroupno,tryoutsortNo,tryoutstateno,tryoutresult,roundNo,SortNo,stateno,gameResult,Team,TeamNm,userClass,Sex,requestIDX     ,bestscore,bestOrder,bestCDBNM,bestidx,bestdate,besttitle,bestgamecode,bestArea,startType "

  SQL = "select "&fld&" from SD_gameMember where delYN = 'N' and gubun in  (1,3)  and gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"'  order by "
  SQL = SQL & " case when tryoutgroupno = 0 then RoundNo else tryoutgroupno end asc,case when tryoutgroupno = 0 then SortNo else tryoutsortno end asc "	 'gubun = 1 예선 3 본선
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql


  If Not rs.EOF Then
		arrR = rs.GetRows()
		attcnt = CDbl(UBound(arrR, 2)) + 1 '참가명수
		joocnt = Ceil_a(attcnt / raneCnt) '조수
		startType = arrR(36, 0) '1 예선부터 시작 3 결승부터 시작

		f_CDA = arrR(9,0)
		If startType = "1" Then
			startstr = "예선경기"
		Else
			startstr = "결승경기"
		End if
		'Response.write joocnt 
  End If



'페이지 입력폼 상태 확인
pageYN = getPageState( "MN0105", "추첨(경영)" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>">
        <div class="box-header with-border">
          <!-- <h3 class="box-title"><%'=LNM%></h3> -->  <span style="color:green;"> <%=LNM%></span>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0105'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/gameDrawForm.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        
		

		<!-- 선수 찾아서 풀어주는 부분 만들자. 삭제처리되어있는지 확인....-->		
<!-- 		<div class="col-md-2"> -->
<!-- 			<input type="text" id="delid" value="<%=finddelid%>" class="form-control" > -->
<!-- 		</div> -->
<!-- 		<div class="col-md-2"> -->
<!-- 			<a href="javascript:px.goSubmit({'delid':$('#delid').val(),'TIDX':<%=tidx%>,'GBIDX':<%=gbidx%>,'IDX':<%=idx%>},'gamedraw.asp');" class="btn btn-default" >검색</a> -->
<!-- 			 -->
<!-- 			&nbsp;&nbsp;&nbsp;<%=delynstate%>  -->
<!-- 		</div> -->
		
		
		<!-- <div class="box-footer"></div> -->
      </div>



      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
						<div class="row">
							<div class="col-md-6" style="width:50%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
									<span style="color:red"><%=startstr%></span> 대진표 (기준기록) 
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
										 <a href="/contestlevel.asp?idx=<%=tidx%>" class="btn btn-primary"><i class="fa fa-fw fa-list-alt"></i>대회정보관리목록보기</a>
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
								<%If f_CDA = "D2" then%>
								<th>조</th>
<!-- 								<th>수동</th> -->
								<th>성별</th>
								<th>조<br>변경</th>
								<th>기록<br>구분</th>
								<th>기준<br>종목</th>
								<th>보유<br>자명</th>
								<th>소속</th>
								<th>기준<br>기록</th>
								<th>수립<br>일자</th>
								<th>수립<br>장소</th>
								<th>대회<br>명칭</th>
								<th>대회<br>코드</th>
								<th>레인<br>배정</th>
								<%else%>
								<th>순서</th>
								<th>수동</th>
								<th>성별</th>
								<th>기준<br>종목</th>
								<th>보유<br>자명</th>
								<th>소속</th>
								<%End if%>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


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
			l_tryoutgroupno= arrR(15, ari)
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
			l_bestgamecode= arrR(34, ari) '기준기록대회코드값 
			l_bestArea = arrR(35, ari)
			l_startType = arrR(36, ari) '1 예선부터 시작 3 결승부터 시작


			If l_tryoutgroupno > 0 Then
				chkrowno = l_tryoutgroupno
				l_raneno = l_tryoutsortNo
			Else
				'결승라운드는 
				chkrowno = l_roundNo
				l_raneno = l_SortNo
			End if

	If l_raneno <> "0" then
	If chkrowno > 0 then
	If ari =  0 or prejoo <> chkrowno Then
		%>
		</tbody>
		<tbody  id="contest_<%=ari%>"  class="gametitle">
		<%
	End If
	End If
	End if

	%><!-- #include virtual = "/pub/html/swimming/gameDrawList.asp" --><%


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




