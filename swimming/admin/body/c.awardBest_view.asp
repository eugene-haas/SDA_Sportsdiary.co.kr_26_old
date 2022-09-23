<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX '종목인덱스
	End If
  'request 처리##############


	Set db = new clsDBHelper

	SQL = ";with tblbest as ( "
	SQL = SQL & " Select ROW_NUMBER() Over(Partition By cdc Order By gameresult) as rc, rcIDX,cdb,cdbnm,cdc,cdcnm,kskey,playeridx,username,Birthday,sido,teamnm,userclass,rctype,gamearea,gameresult,gameorder,rane  "
	SQL = SQL & " from  tblrecord where gametitleidx = '"&tidx&"' and delyn = 'N' and cda = 'D2' and Roundstr = '결승') "
	SQL = SQL & "select playeridx,count(*) as cnt from tblbest where rc = 1  group by playeridx order by 2 desc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
		arrG = rs.GetRows()
  End If

	SQL = ";with tblbest as ( "
	SQL = SQL & " Select ROW_NUMBER() Over(Partition By cdc Order By gameresult) as rc, rcIDX,cdb,cdbnm,cdc,cdcnm,kskey,playeridx,username,Birthday,sido,teamnm,userclass,rctype,gamearea,gameresult,gameorder,rane  "
	SQL = SQL & " from  tblrecord where gametitleidx = '"&tidx&"' and delyn = 'N' and cda = 'D2' and Roundstr = '결승') "
	SQL = SQL & "	select * from (select playeridx,count(*) as cnt from tblbest where rc = 1  group by playeridx ) as a inner join tblbest as b on a.playeridx = b.playeridx and b.rc = 1 where a.cnt > 1 "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If
%>


<%'View ####################################################################################################%>
      <div class="box box-primary"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">다관왕명세 (최우수 선수)</h3>

          <div class="box-tools pull-right">

          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>

			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>

	  


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
			

						<div class="row" >


							<%If hide = true then%>
								<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
									  <div class="form-group">

										<div class="input-group date">

								<select id="F1_2" class="form-control" onchange="mx.searchPlayer(<%=page%>);">
								  <option value="A" <%If CStr(F1_2) = "A" then%>selected<%End if%>>제 68회 회장 배 수영대회 (경영)</option>
								  <option value="K" <%If CStr(F1_2)= "K" then%>selected<%End if%>>국내</option>
								  <option value="F" <%If CStr(F1_2)= "F" then%>selected<%End if%>>국제</option>
							  </select>

											<div class="input-group-addon" onmousedown="alert('검색하자')">
											  <i class="fa fa-fw fa-search"></i>
											</div>
										</div>									
										

									  </div>
								</div>

								<div class="col-md-6" style="width:59%;padding-right:20px;padding-right:0px;text-align:right;">
									  <div class="form-group">
										  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
										  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
											<a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a>
									  </div>
								</div>
							<%End if%>


						</div>			  
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->

            <div class="box-body">

<%
	If IsArray(arrG) Then 
		For i = LBound(arrG, 2) To UBound(arrG, 2)
			w_pidx = arrG(0, i)
			w_cnt = arrG(1, i)

			If w_cnt > 1 And (i  = 0 Or w_cnt <> pre_w_cnt) then
	%>			  
			  
				  
			  <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th colspan="9"><%=w_cnt%>관왕</th>
						</tr>
					</thead>

					<tbody id="contest"  class="gametitle">
						<tr style="background:#eeeeee;text-align:center;">
								<td>NO</td>
								<td>이름</td>
								<td>소속</td>
								<td>학년</td>
								<td>시도</td>
								<td>순위</td>
								<td>세부종목</td>
								<td>기록</td>
						</tr>

		<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
					l_pidx = arrR(0, ari)
					l_cnt = arrR(1,ari)

					l_username = arrR(10, ari)
					l_teamnm = arrR(13, ari)
					l_classno = arrR(14, ari)
					If l_classno = "0" Then
						l_classno = ""
					End if
					l_sidonm = arrR(12, ari)

					l_cdbnm = arrR(5, ari)
					l_cdcnm = arrR(7, ari)
					l_rc = arrR(17,ari)
				If w_cnt = l_cnt then
		%>
				<tr class="gametitle" id="titlelist_<%=idx%>"  style="text-align:center;">
						<td><%=l_pidx%></td>
						<td><%=l_username%></td>
						<td><%=l_teamNm%></td>
						<td><%=l_classno%></td>
						<td><%=l_sidonm%></td>
						<td>1위</td>
						<td><%=l_cdcnm%></td>
						<td><%Call SetRC(l_rc)%></td>
				</tr>

		<%
				End if

				Next
			End if
		%>
								

					</tbody>
				</table>


	<%
			pre_w_cnt = w_cnt
			End If
		
		Next
	End if
%>

            </div>
          </div>
        </div>

	  </div>


