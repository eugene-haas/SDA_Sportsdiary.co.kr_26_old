<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	intPageNum = PN
	intPageSize = 20
	strTableName = " TB_LOG_TRACESWIM as a "

	strFieldName = " IDX,UID,REQ,CURURL,BROWSER,IP,WRITEDATE "
	strSort = "  order by IDX desc"
	strSortR = "  order by IDX"
	
	
	if F2 = "" then
		strWhere = " writedate > '"&date&"'  " '오늘꺼만 보자...
	else
		strWhere = F2 '오늘꺼만 보자...
	end if
	

	' Dim intTotalCnt, intTotalPage
	' Set rs = GetBBSSelectRS( LOG_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	' block_size = 10

    SQL = "Select top 2000 " & strFieldName & " from " & strTableName & "where " & strWhere & strSort 
	  Set rs = db.ExecSQLReturnRS(SQL , null, LOG_ConStr)

  '#############################################################
	Sub rsDrow(ByVal rs)
	Dim i 
		For i = 0 To Rs.Fields.Count - 1
			'response.write  Rs.Fields(i).name &","
		Next

    response.write "<div class='box-body'>"
    response.write "  <table id='swtable' class='table table-bordered table-hover' >"
    response.write "    <thead class='bg-light-blue-active color-palette'>"
	
		For i = 0 To Rs.Fields.Count - 1
			response.write "<th>"& Rs.Fields(i).name &"</th>"
		Next
		Response.write "</thead>"

		ReDim rsdata(Rs.Fields.Count) '필드값저장

		Do Until rs.eof
			For i = 0 To Rs.Fields.Count - 1
				rsdata(i) = rs(i)
			Next
			%>
				<tr class="gametitle">
					<%
						For i = 0 To Rs.Fields.Count - 1
								Response.write "<td>" & rsdata(i)   & "</td>"
						Next
					%>
				</tr>
			<%
		rs.movenext
		Loop

		If Not rs.eof then
		rs.movefirst
		End if
		Response.write "</tbody>"
		Response.write "</table>"
		Response.write "</div>"    
	End Sub

%>

<%'View ####################################################################################################%>

					<div class="box-header" style="text-align:right;padding-right:20px;">


							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="w">조건절</option>
										</select>
								  </div>
							</div>

						<div class="row">

							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="조건절 입력" value="" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'trace.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'trace.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>

								  </div>
							</div>
							
						</div>
            </div>




			<div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">당일추적로그</h3>
        </div>


    <div class="row">
		    <div class="col-xs-12">

          <div class="box">
            <div class="box-body">
			      	<%Call rsdrow(rs)%>
            </div>
          </div>

        </div>
	  </div>





