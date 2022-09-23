<%
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


	strSort = "  order by gameS desc"
	strSortR = "  order by gameS "

	If F1 <> "" And F2 <> "" Then
		sdate = F1 & "-01-01"
		edate = Cdbl(F2) + 1 & "-01-01"
		strWhere =  " delyn = 'N'  and gametitleidx <> "&tidx&"  and gameS >= '"&sdate&"' and gameE < '"&edate&"' "
	else
		F1 = year(date)
		F2 = year(date)
		sdate = year(date) & "-01-01"
		edate = CDbl(year(date))+ 1 & "-01-01"
		strWhere =  " delyn = 'N'  and gametitleidx <> "&tidx&"  and gameS >= '"&sdate&"' and gameE < '"&edate&"' "
	End if


	fld = " gametitleidx,titlecode,gametitlename,gameS,gameE,gamearea,kgame,gubun "
	SQL = "SELECT "&fld& "  FROM sd_gameTitle   WHERE " &strwhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">랭킹엑셀다운로드</button></h4>
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


						<div class="row" >
							<div class="col-md-6" style="width:15%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										<select id="F2" class="form-control">
											<%For ey = year(date)-3 To year(date)%>
											<option value="<%=ey%>" <%If CStr(ey) = CStr(F2) then%>selected<%End if%>><%=ey%></option>
											<%next%>
										</select>

										<div class="input-group-addon" onmousedown="mx.gameSearchList2( <%=tidx%>,<%=gbidx%>,'<%=cdc%>', $('#F1').val() , $('#F2').val()  )">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>									
									

								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
								  </div>
							</div>

						</div>			  
            </div>


            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th><input type="checkbox"  onClick="px.toggle(this,'chk_game')"></th>
								<th>NO</th>
								<th>대회코드</th>
								<th>대회명</th>
								<th>대회기간</th>
								<th>장소</th>
								<th>체전</th>
								<th>구분</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%
					Do Until rs.eof

						l_idx = rs(0)
						l_gamecode = rs(1)
						l_gametitlename = rs(2)
						l_games = rs(3)
						l_gameE = rs(4)
						l_gamearea = rs(5)
						l_kgame = rs(6)
						l_gubun = rs(7)

						Select Case l_kgame
						Case "N" : l_kgame = "비체전"
						Case "G" : l_kgame = "전국체전"
						Case "Y" : l_kgame = "소년체전"
						Case "W" : l_kgame = "동계체전"
						End Select 



					 %><!-- #include virtual = "/pub/html/swimming/baseGameList.asp" --><%
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
		<a href="javascript:mx.setBestExcelDown(<%=tidx%>,<%=gbidx%>,'<%=cdc%>')" class="btn btn-primary" >엑셀다운로드(남)</a>
		<a href="javascript:mx.setBestExcelDown2(<%=tidx%>,<%=gbidx%>,'<%=cdc%>')" class="btn btn-primary" >엑셀다운로드(여)</a>

		<!-- <a href="#" class="btn btn-default" data-dismiss="modal">닫기</a> -->
    </div>


  </div>
</div>

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
