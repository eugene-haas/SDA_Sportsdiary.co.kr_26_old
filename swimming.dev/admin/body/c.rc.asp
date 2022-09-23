<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	intPageNum = PN
	intPageSize = 20
	strTableName = " tblRecord as a "

	'tblRecord
	'rcIDX,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,DelYN


	strFieldName = " rcIDX,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,DelYN " 

	strSort = "  order by rcIDX desc"
	strSortR = "  order by rcIDX "


	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		strWhere = " DelYN = 'N' and "&F1&" like '%"& F2 &"%' "
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10


'Call rsdrow(rs)
'Response.end


  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If



pageYN = getPageState( "MN0108", "기록관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">기록관리</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0108'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">

			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/html.rcform.asp" -->
			<!-- e: 등록 화면 -->

        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              

<!-- 
'R01	대회유년
'R02	대회초등
'R03	대회중등
'R04	대회고등
'R05	대회대학
'R06	대회일반
'R07	한국기록
'R08	일반-참가기록 
-->

							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="username" <%If F1 = "username" then%>selected<%End if%>>선수명</option>
											<option value="TeamNm" <%If F1 = "TeamNm" then%>selected<%End if%>>소속명</option>

											<option value="rctype" <%If F1 = "rctype" then%>selected<%End if%>>기록구분</option>
										</select>
								  </div>
							</div>

				

						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'rc.asp')}"> 
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'rc.asp')">
										  <i class="fa fa-fw fa-search"></i>
										<input type="button" value="목록불러오기" id = "getlist" onclick="mx.getlist('contest')" style="display:none;">
										&nbsp;&nbsp;기록구분: R01 ~ R08 대회유년 ~ 일반참가
										</div>
										
									</div>									
									

								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
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
								<th>NO</th>
								<th>대회코드</th>
								<th>대회명</th>
								<th>장소</th>
								<th>날짜</th>
								<th>이름</th>
								<th>소속(학년)</th>
								<th>기록</th>
								<th>순위</th>
								<th>기록구분</th>
								<th>종목</th>
								<th>부서</th>
								<th>세부종목</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


<%


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

		l_idx = arrR(0, ari)
		l_titleCode= arrR(1, ari)
		l_titlename= arrR(2, ari)
		l_CDA= arrR(3, ari)
		l_CDANM= arrR(4, ari)
		l_CDB= arrR(5, ari)
		l_CDBNM= arrR(6, ari)
		l_CDC= arrR(7, ari)
		l_CDCNM= arrR(8, ari)
		l_kskey= arrR(9, ari)
		l_ksportsno= arrR(10, ari)
		l_playerIDX= arrR(11, ari)
		l_UserName= arrR(12, ari)
		l_Birthday= arrR(13, ari)
		l_Sex= arrR(14, ari)
		l_nation= arrR(15, ari)
		l_sidoCode= arrR(16, ari)
		l_sido= arrR(17, ari)
		l_gameDate= arrR(18, ari)
		l_EnterType= arrR(19, ari)
		l_Team= arrR(20, ari)
		l_TeamNm= arrR(21, ari)
		l_userClass= arrR(22, ari)
		l_rctype= arrR(23, ari)
		l_gamearea= arrR(24, ari)
		l_gameResult= arrR(25, ari)
		l_gameOrder= arrR(26, ari)
		l_rane= arrR(27, ari)





	%><!-- #include virtual = "/pub/html/swimming/html.rcList.asp" --><%


		pre_gameno = r_a2
		Next
	End if
%>

		
					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>


		<nav>
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
			%>
		</nav>
