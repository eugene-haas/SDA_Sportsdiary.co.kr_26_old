<%
 'Controller ################################################################################################
	sortd = " o.name asc"

	SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY " & sortd
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arr = rs.GetRows()
	End if

	showtype  = request("s")

	SQL = "SELECT o.name , i.rows,  (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  "&strWhere&" i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"

	
	'Response.write sql
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>
<%'View ####################################################################################################%>


      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title">KS_Swimming</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
            <!-- <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-remove"></i></button> -->
          </div>
        </div>

		<div class="box-body">
			<!-- s: 정보 검색 -->
			<div class="info_serch" id="gameinput_area">
				<div id="ul_1" class="form-horizontal">
					<div class="form-group">
						<div class="col-sm-5">
							<div class="input-group">
								<select id="selectTabelList" class="form-control">
								<%
								  if(IsArray(arr)) Then
									For ar = LBound(arr, 2) To UBound(arr, 2)
									  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
									NEXT
								  End IF
								%>
								</select>
								
								<div class="input-group-btn">
									<a href="javascript:mx.copyTable('selectTabelList')" href="tablehelp.asp" class="btn btn-default">테이블 복사</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- e: 정보 검색 -->
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>




      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <!-- <div class="box-header">
              <h3 class="box-title">Hover Data Table</h3>
            </div> -->
            <!-- /.box-header -->

			<div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
                <tr>
							<th>table</th>
							<th>rows</th>
							<th>comment</th>
							<th>column</th>
                </tr>
                </thead>
                <tbody id="tblbody">

      						<%
							DN = "ITEMCENTER"
      						Do Until rs.eof

								If rs(2) = "" Or Len(rs(2)) >= 1 Then
									MD = 2 'update
								Else 
									MD = 1 'insert
								End if
								'EXEC   sp_updateextendedproperty 'MS_Description', '주석', 'user', dbo, 'table', 테이블명     ' 업데이트쿼리
								%>
									<tr style="text-align:center;">
										<td><span><%=rs(0)%></span></td>
										<td><span><%=rs(1)%></span></td>
										<td><span>
										<input type='text' value='<%=rs(2)%>'  onblur="if(this.value !=''){mx.SendPacket(this,{'CMD':mx.CMD_TABLECMT,'NM':'<%=rs(0)%>','DN':'<%=DN%>','CMT':this.value, 'MD':<%=MD%>})}" class="form-control" style="width:100%;">
										</span></td>
										<td><span><a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'<%=rs(0)%>','DN':'<%=DN%>' })" class="btn btn-primary">컬럼 주석</a></span></td>
									</tr>

								<%
								'End if
      						  rs.movenext
      						  Loop
      						  Set rs = Nothing
      						%>


                </tbody>
                
				<!-- <tfoot>
                <tr><th>tfoor</th></tr>
                </tfoot> -->

              </table>
            </div>

          </div>
        </div>
      </div>
