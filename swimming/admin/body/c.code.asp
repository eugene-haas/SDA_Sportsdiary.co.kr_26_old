<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	'search
	If F1 = "" Then
		F1 = "gubun"
	End if
	If chkBlank(F2) Then
		fld = " idx,code,codenm,CDA " 
		tbl = " tblcode "
		strWhere = " gubun = '1' and DelYN = 'N'  "
	else
		If CDbl(F2) > 3 Then
			tbl = " tblTeamGbInfo "

			Select Case F2
			Case "4"
				fld = " teamgbIDX,cd_boo,cd_booNm,PteamGb " 
				strWhere = " DelYN = 'N' and  cd_type = '2' "
			Case "5"
				fld = " teamgbIDX,teamGb,teamgbNm,PteamGb " 
				strWhere = " DelYN = 'N' and  cd_type = '1' "
			Case "6"
				tbl = " tblSidoInfo "
				fld = " sidoIDX,sido,sidoNm,'' " 
				strWhere = " DelYN = 'N'  "
			Case "7"
				tbl = " tblcode "
				fld = " idx,code,codenm,CDA " 
				strWhere = " gubun = '2' and DelYN = 'N'    "
			End Select 


		else
			fld = " idx,code,codenm,CDA " 
			tbl = " tblcode "
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "
		End if
	End if

	SQL = "select "& fld &" from "&tbl&" where " & strwhere

'Response.write sql
'Response.end
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If
%>


<%'View ####################################################################################################%>
      <div class="box box-primary collapsed-box"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">코드관리</h3>

          <div class="box-tools pull-right">

          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->

			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">

						<div class="col-md-6" style="width:30%;padding-left:20px;padding-right:0px;text-align:left;">
							  <div class="form-group">
										<input type="hidden" id="F1" value="<%=F1%>">

										<div class="input-group date">
										<div class="input-group-addon">
										  <i class="fa fa-fw fa-search"></i>
										</div>

										<select id="F2" class="form-control"  onchange="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'code.asp')">
											<option value="1" <%If F2 = "1" then%>selected<%End if%>>라운드코드</option>
											<option value="2" <%If F2 = "2" then%>selected<%End if%>>사유코드</option>
											<option value="3" <%If F2 = "3" then%>selected<%End if%>>국가코드</option>
											<option value="4" <%If F2 = "4" then%>selected<%End if%>>종별코드</option>
											<option value="5" <%If F2 = "5" then%>selected<%End if%>>종목코드</option>
											<option value="6" <%If F2 = "6" then%>selected<%End if%>>시도코드</option>
											<option value="7" <%If F2 = "7" then%>selected<%End if%>>에러코드</option>
										</select>
										</div>
							  </div>
						</div>

						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">

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
								<th>코드</th>
								<th>코드명칭</th>
								<th>종목코드</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


<%


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

l_idx = arrR(0, ari)
l_code = arrR(1, ari)
l_codeNm = arrR(2, ari)
l_CDA = arrR(3, ari)

	%><!-- #include virtual = "/pub/html/swimming/codeList.asp" --><%


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
