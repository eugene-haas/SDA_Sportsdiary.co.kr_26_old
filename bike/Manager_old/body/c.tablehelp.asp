<%
 'Controller ################################################################################################

	SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if

	
	
	SQL = "SELECT o.name , i.rows,  (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




%>
<%'View ####################################################################################################%>

        <!-- S: sub-content -->
        <div class="sub-content">


			<!-- s: 정보 검색 -->
				<div class="info_serch box-shadow" id="gameinput_area">

					<div class="search-box">
						<ul id="ul_1">
							<li>

							<select id="selectTabelList" style="width:auto;"> 
							<%
							  if(IsArray(arr)) Then
								For ar = LBound(arr, 2) To UBound(arr, 2) 
								  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
								NEXT
							  End IF
							%>
							</select>
							<a class="blue-btn" href="javascript:mx.copyTable('selectTabelList')" style="width:100px;">테이블 복사</a>
							</li>
						</ul>
					</div>

				</div>
			<!-- e: 정보 검색 -->



            <!-- S: competition_management -->
            <div class="competition_management">


    			<!-- s: 테이블 리스트 -->
    				<div class="table-box basic-table-box">
    					<table cellspacing="0" cellpadding="0">
    						<tr>
    							<th style="width:20%;">table</th><th style="width:10%;">rows</th><th>comment</th><th style="width:20%;">column</th>
    						</tr>
    						<tr id="contest">
        						<%
								DN = "SD_Bike"
        						Do Until rs.eof
								If rs(2) = "" Or Len(rs(2)) >= 1 Then
									MD = 2 'update
								Else 
									MD = 1 'insert
								End if        							
									
									If rs(0) = "sysdiagrams" Then

									else
									%>
										<tr>
											<td class="date"><span><%=rs(0)%></span></td>
											<td class="name"><span><%=rs(1)%></span></td>
											<td class="name"><span>
											<input type='text' value='<%=rs(2)%>'  onblur="if(this.value !=''){mx.SendPacket(this,{'CMD':mx.CMD_TABLECMT,'NM':'<%=rs(0)%>','DN':'<%=DN%>','CMT':this.value, 'MD':<%=MD%>})}" style="width:100%;">
											</span></td>
											<td><a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'<%=rs(0)%>','DN':'<%=DN%>' })" class="white-btn">컬럼 주석</a></td>
										</tr>									
									
									<%
									End if
        						  rs.movenext
        						  Loop
        						  Set rs = Nothing
        						%>
                            </tr>
    					</table>
    				</div>
    			<!-- e: 테이블 리스트 -->

            </div>
            <!-- E: competition_management -->
		</div>
		<!-- s: sub-content -->

