<%
	If hasown(oJSONoutput, "IDX") = "ok" Then  '테이블 명
		idx = chkStrRpl(oJSONoutput.IDX,"")
	End If


	If hasown(oJSONoutput, "TIDX") = "ok" Then  '테이블 명
		tidx = chkStrRpl(oJSONoutput.TIDX,"")
	End If

	If hasown(oJSONoutput, "GBIDX") = "ok" Then  '테이블 명
		gbidx = chkStrRpl(oJSONoutput.GBIDX,"")
	End If

	If hasown(oJSONoutput, "CDC") = "ok" Then  '자유형 100 .. 의 코드
		cdc = chkStrRpl(oJSONoutput.CDC,"")
		If Len(cdc) = 1 Then
			cdc = "0"& cdc
		End if
	End If

	If hasown(oJSONoutput, "F1") = "ok" Then  '검색필드
		F1 = chkStrRpl(oJSONoutput.F1,"")
	End If
	If hasown(oJSONoutput, "F2") = "ok" Then  '필드데이터
		F2 = chkStrRpl(oJSONoutput.F2,"")
	End If





	Set db = new clsDBHelper


	fld = " idx,tidx,gbidx,levelno,midxL,midxR,teamL,teamR,teamnmL,teamnmR,scoreL,scoreR,winmidx,result,gangno,roundno,orderno   "
	fld = fld &  " ,(case when midxL =  winmidx then 'W' else 'L' end) as LWL, (case when midxR =  winmidx then 'W' else 'L' end) as RWL     ,sidonmL, sidonmR , sayoocode, vstype "
	SQL = "Select " & fld & " from sd_gameMember_vs where idx = " & idx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Response.write sql
'Call rsdrow(rs)

	arrUp = rs.GetRows()

	If IsArray(arrUp) Then  '부전이니까 업데이트 할대상을 찾자.
		For x = LBound(arrUp, 2) To UBound(arrUp, 2)
			l_idx  = arrUP(0,x)
			l_tidx  = arrUP(1,x)
			l_gbidx  = arrUP(2,x)
			l_levelno  = arrUP(3,x)
			l_midxL  = arrUP(4,x)
			l_midxR  = arrUP(5,x)
			l_teamL  = arrUP(6,x)
			l_teamR  = arrUP(7,x)
			l_teamnmL  = arrUP(8,x)
			l_teamnmR  = arrUP(9,x)
			l_scoreL  = arrUP(10,x)
			l_scoreR  = arrUP(11,x)
			l_winmidx  = arrUP(12,x)
			l_result  = arrUP(13,x)
			l_gangno  = arrUP(14,x)
			l_roundno  = arrUP(15,x)
			l_orderno  = arrUP(16,x)


			l_LWL  = arrUP(17,x)
			l_RWL  = arrUP(18,x)
			l_sidoL  = arrUP(19,x)
			l_sidoR  = arrUP(20,x)
			l_sayoocode = arrUP(21,x)
			l_vstype = arrUP(22,x)
		Next

	

	End if
%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <!-- <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button> -->
      <button type='button' class='close' onclick="window.location.reload();">×</button>
      <h4 class="modal-title" id="myModalLabel">승패 결과입력</button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody" style="overflow:hidden;">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              

							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										 <%If l_vstype = "T" then%><%=l_gangno%>강 <%End if%>
								  </div>
							</div>


						<div class="row" >
							<div class="col-md-6" style="width:25%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<%=l_teamnmL%> VS <%=l_teamnmR%>
								  </div>
							</div>

							<div class="col-md-6" >
								  <div class="form-group" >
								  </div>
							</div>
							<div class="col-md-6" >
								  <div class="form-group">

								  </div>
							</div>

						</div>			  
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>


            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<!-- <th><%=l_sidoL%></th>
								<th><%=l_teamnmL%></th> -->
								<th id="lresult"><%If l_LWL = "W" then%>승<%else%>-<%End if%></th>
								<th>vS</th>
								<th id="rresult"><%If l_RWL = "W" then%>승<%else%>-<%End if%></th>
								<!-- <th><%=l_teamnmR%></th>
								<th><%=l_sidoR%></th> -->
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
						<tr>



								<th><input type="button" class="btn btn-primary" id="ltotal" value="<%=l_teamnmL%>" onclick="mx.setSaveTn(<%=idx%>,<%=l_midxL%>,<%=l_midxR%>,'L');"></th>
								<th>:</th>
								<th><input type="button" class="btn btn-primary" id="rtotal" value="<%=l_teamnmR%>" onclick="mx.setSaveTn(<%=idx%>,<%=l_midxL%>,<%=l_midxR%>,'R');"></th>
						</tr>




					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>
	<%'#######################################################%>





      </div>
    </div>




  </div>
</div>

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
