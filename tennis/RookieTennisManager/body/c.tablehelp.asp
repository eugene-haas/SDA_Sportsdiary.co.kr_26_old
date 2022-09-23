<%
 'Controller ################################################################################################

'	SQL = "SELECT tablenm from tblDBShowTable  where sitecode = '"&sitecode&"' "
'	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
'
'
'
'	If Not rs.EOF Then 
'		arrtbl = rs.GetRows()
'	End if
'
'  if(IsArray(arrtbl)) Then
'	For ar = LBound(arrtbl, 2) To UBound(arrtbl, 2) 
'		tblnm = arrtbl(0,ar)
'		If ar = 0 Then
'			tbls = strSqlVar(tblnm)
'		Else
'			tbls = tbls &"," & strSqlVar(tblnm)
'		End if
'	NEXT
'  End IF

	'sql = "select top 1 * from sysobjects "
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'Call rsdrow(rs)

	'sortd = " o.crdate desc"
	sortd = " o.name asc"

	SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY " & sortd
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if

	showtype  = request("s")

	If showtype = "" then
	'보고싶은테이블만
	'strWhere = " o.name in ("&tbls&") and "
	End if



	SQL = "SELECT o.name , i.rows,  (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  "&strWhere&" i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Response.write tbls
%>
<%'View ####################################################################################################%>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>DB주석관리</h1></div>


			<!-- s: 정보 검색 -->
				<div class="search_top" id="gameinput_area">
					<ul id="ul_1">
						<li>
							<select id="selectTabelList" class="sl_search" style="margin-right:3px;"> 
							<%
							  if(IsArray(arr)) Then
								For ar = LBound(arr, 2) To UBound(arr, 2) 
								  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
								NEXT
							  End IF
							%>
							</select>
							<a href="javascript:mx.copyTable('selectTabelList')" href="tablehelp.asp" class="search_btn">테이블 복사</a>
						</li>
					</ul>
				</div>
			<!-- e: 정보 검색 -->


			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tr>
							<th style="width:20%;">table</th><th style="width:10%;">rows</th><th>comment</th><th style="width:20%;">column</th>
						</tr>

						<tbody id="contest">

        						<%
								DN = "ITEMCENTER"
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
											<td class="g_btn green_btn1"><a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'<%=rs(0)%>','DN':'<%=DN%>' })" class="white-btn">컬럼 주석</a></td>
										</tr>									
									
									<%
									End if
        						  rs.movenext
        						  Loop
        						  Set rs = Nothing
        						%>
					
									


						</tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->

	

		</div>
		<!-- s: 콘텐츠 끝 -->












