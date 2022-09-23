<%
	If hasown(oJSONoutput, "TIDX") = "ok" Then  '테이블 명
		tidx = chkStrRpl(oJSONoutput.TIDX,"")
	End If

	If hasown(oJSONoutput, "F1") = "ok" Then  '검색필드
		F1 = chkStrRpl(oJSONoutput.F1,"")
	End If
	If hasown(oJSONoutput, "F2") = "ok" Then  '필드데이터
		F2 = chkStrRpl(oJSONoutput.F2,"")
	End If



	Set db = new clsDBHelper


	strSort = "  order by " & IDXFIELDNM & " desc"
	strSortR = "  order by " & IDXFIELDNM

	If F1 <> "" And F2 <> "" Then
		sdate = F1 & "-01-01"
		edate = Cdbl(F2) + 1 & "-01-01"
		strWhere =  " delyn = 'N'  and gametitleidx <> "&tidx&"  and gameS >= '"&sdate&"' and gameE < '"&edate&"' "
	else
		F1 = year(date)
		F2 = year(date)
		sdate = year(date) & "-01-01"
		edate = CDbl(year(date))+ 1 & "-01-01"
		strWhere =  " delyn = 'N' and gametitleidx <> "&tidx&"  and gameS >= '"&sdate&"' and gameE < '"&edate&"' "
	End if

	gamecnt = " (select count(*) from tblRgameLevel where gametitleidx = a.gametitleidx )  as gcnt "
	strSql = "SELECT gametitleidx,titlecode,gametitlename,gameS,gameE,gamearea,kgame,gubun,"&gamecnt&"  FROM sd_gameTitle as a WHERE " &strwhere
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		
%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">타대회복사</button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              

							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<%For sy = year(date)-3 To year(date)%>
											<option value="<%=sy%>" <%If CStr(sy) = CStr(F1) then%>selected<%End if%>><%=sy%></option>
											<%next%>
										</select>  
								  </div>
							</div>

							<div class="col-md-6" style="width:40px;">
										~
							</div>


						<div class="row" >
							<div class="col-md-6" style="width:15%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										<select id="F2" class="form-control">
											<%For ey = year(date)-3 To year(date)%>
											<option value="<%=ey%>" <%If CStr(ey) = CStr(F2) then%>selected<%End if%>><%=ey%></option>
											<%next%>
										</select>

										<div class="input-group-addon" onmousedown="mx.gameSearchList( <%=tidx%>, $('#F1').val() , $('#F2').val()  )">
										  <i class="fa fa-fw fa-search"></i>
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


            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>

								<th>NO</th>
								<th>대회코드</th>
								<th>대회명</th>
								<th>경기수</th>
								<th>대회기간</th>
								<th>장소</th>
								<th>체전</th>
								<th>구분</th>
								<th>대회복사</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%
					Do Until rs.eof

' gametitleidx,titlecode,gametitlename,gameS,gameE,gamearea,kgame,gubun
l_idx = rs(0)
l_gamecode = rs(1)
l_gametitlename = rs(2)
l_games = rs(3)
l_gameE = rs(4)
l_gamearea = rs(5)
l_kgame = rs(6)
l_gubun = rs(7)
l_gcnt = rs(8)


					 %><!-- #include virtual = "/pub/html/swimming/gamecopylist.asp" --><%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>

					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>
	<%'#######################################################%>





      </div>





    </div>

  	<div class="modal-footer">
		<a href="#" class="btn btn-default" data-dismiss="modal">닫기</a>
    </div>


  </div>
</div>

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
