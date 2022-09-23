<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	'search
	If chkBlank(F2) Then
		strWhere = " idx > 0  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then

		Else
			strWhere = " "&F1&" like '%"& F2 &"%' "
		End if
	End if

	SQL = "select idx,reqID,reqNm,reqCon,reqgubun,reqING,UIID,UINm,UIURL,pgID,pgNm,JsonURL,TotalTestID,bigo,test,rtOK,writedate,reqA,jsonres,reqID2 from tblQA  where "&strWhere&" order by reqID asc , UIID asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If


pageYN = getPageState( "MN0901", "QA" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">QA</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0901'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/QAform.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              

							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="UINM" <%If F1 = "UINM" then%>selected<%End if%>>UI정의</option>
											<option value="reqid" <%If F1 = "reqid" then%>selected<%End if%>>요구사항키</option>
											<option value="uinm" <%If F1 = "uinm" then%>selected<%End if%>>UI명칭</option>
										</select>
								  </div>
							</div>

				

						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'QA.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'QA.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>									
					
									
								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <a href="javascript:px.exportExcel( 'QA', 'qalist' ,'swtable')" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <!-- <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
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
								
								<th>REQID</th>
								<th>REQID2</th>
								<th>정의</th>
								<th>내용</th>
								<th>처리방안</th>
								<th>구분</th>
								<th>진행</th>
								<th>UIID</th>
								<th>정의</th>
								<th>URL</th>
								<th>PGID</th>
								<th>정의</th>
								<th>JSONREQ</th>
								<th>JSONRES</th>
								<th>시험ID</th>
								<th>비고</th>
								<th>검사기준</th>
								<th>판정</th>
								<th>삭제</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


<%


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)


		l_idx = arrR(0, ari)
		l_reqID = arrR(1, ari)
		l_reqNm = arrR(2, ari)
		l_reqCon = isNulldefault(arrR(3, ari),"")
		l_reqgubun = arrR(4, ari)
		l_reqING = arrR(5, ari)
		l_UIID = arrR(6, ari)
		l_UINm = arrR(7, ari)
		l_UIURL = arrR(8, ari)
		l_pgID = arrR(9, ari)
		l_pgNm = isNulldefault(arrR(10, ari),"")
		l_JsonURL = isNulldefault(arrR(11, ari),"")
		l_TotalTestID = arrR(12, ari)
		l_bigo = arrR(13, ari)
		l_test = isNulldefault(arrR(14, ari),"")
		l_rtOK = isNulldefault(arrR(15, ari),"")
		l_writedate = arrR(16, ari)
		l_reqA = isNulldefault(arrR(17, ari),"")
		l_jsonres = isNulldefault(arrR(18, ari),"")
		l_reqID2 = arrR(19, ari)

	%><!-- #include virtual = "/pub/html/swimming/list.QA.asp" --><%


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



