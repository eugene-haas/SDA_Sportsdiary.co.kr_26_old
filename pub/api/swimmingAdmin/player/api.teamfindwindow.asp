<%
	entertype = chkStrRpl(oJSONoutput.Get("ENTERTYPE"),"")
	tnm = chkStrRpl(oJSONoutput.Get("TNM"),"")

	Set db = new clsDBHelper



	If tnm <> "" then
	strSql = "SELECT team,teamnm,cdb,groupnm,TeamRegDt from  tblTeamInfo  WHERE teamnm like '%"&tnm&"%'  and entertype = '"&entertype&"' and delyn = 'N'"
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)

	  If Not rs.EOF Then
			arrR = rs.GetRows()
	  End If

	End if
%>

<div class="modal-dialog">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">팀명칭검색</button></h4>
    </div>



	<%'#######################################################%>
      <div class="row">
		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="findteamstr" placeholder="검색어를 입력해주세요" value="<%=tnm%>" class="form-control" onkeydown="if(event.keyCode == 13){mx.getTeamFind('<%=entertype%>',$(this).val())}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'amplayer.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>


								  </div>
							</div>

            </div>


            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>

								<th>NO</th>
								<th>팀명칭</th>
								<th>종별</th>
								<th>등록년도</th>
								<th>선택</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%

						If IsArray(arrR) Then
							For ari = LBound(arrR, 2) To UBound(arrR, 2)
								'team,teamnm,cdb,groupnm,l_TeamRegDt
								l_team = arrR(0, ari)
								l_teamnm = arrR(1, ari)
								l_cdb = arrR(2, ari)
								l_groupnm = arrR(3, ari)
								l_regdt = arrR(4, ari)

							%>
						  <tr class="gametitle_<%=l_tidx%>"   id="titlelist_<%=l_idx%>"  style="text-align:center;">
							<td><%=ari+1%></td>
							<td><%=l_teamnm%></td>
							<td><%=l_groupnm%></td>
							<td><%=l_regdt%></td>
							<td>
								  <a href="javascript:mx.setTeam('<%=l_teamnm%>','<%=l_team%>')" class="btn btn-primary"><i class="fa fa-fw fa-sitemap"></i>선택</a>
							</td>
						  </tr>
					<%
						Next
					End if


					%>

					</tbody>
				</table>


            </div>

          </div>
        </div>
	  </div>
	<%'#######################################################%>




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
