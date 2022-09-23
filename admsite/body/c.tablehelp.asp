<%
'request에다가......
'Select Case LCase(URL_HOST)
'Case "rtadmin.sportsdiary.co.kr","rt.sportsdiary.co.kr" : sitecode = "RTN01"
'Case "swadmin.sportsdiary.co.kr","sw.sportsdiary.co.kr" : sitecode = "SWN01"
'Case "ridingadmin.sportsdiary.co.kr","riding.sportsdiary.co.kr" : sitecode = "RDN01"
'Case "bikeadmin.sportsdiary.co.kr","bike.sportsdiary.co.kr" : sitecode = "BIKE01"
'Case "adm.sportsdiary.co.kr": sitecode = "ADN99"
'End Select 



 'Controller ################################################################################################
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
%>
<%'View ####################################################################################################%>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>DB주석관리</h1></div>


			<!-- s: 정보 검색 -->
			<div class="info_serch" id="gameinput_area">
				<div id="ul_1" class="form-horizontal">
					<div class="form-group">
						<div class="col-sm-5">
								<%If sitecode = "ADN99" then%>
								<select id="F1" class="form-control" style="float:left;width:100px;" onchange="px.goSearch({},1,$('#F1').val(),'')">
									<%'dbnmarr = array("공통","멤버","아이템센터","베드민턴","테니스","SD테니스","수영","승마","자전거","유도","APITESTER","대회실적","스포츠Player", "스포츠Diary") cfg.pub에 있어요 %>
									<%For i = 0 To ubound(dbnmarr)%>
									<option value="DB<%=addZero(i)%>" <%If F1 = "DB" & addZero(i) then%>selected<%End if%>   ><%=dbnmarr(i)%></option>
									<%next%>
								</select>
								<%End if%>
							<div class="input-group">


								
								
								<select id="selectTabelList" class="form-control"  style="float:left;">
								<%
								  if(IsArray(arr)) Then
									For ar = LBound(arr, 2) To UBound(arr, 2)
									  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
									NEXT
								  End IF
								%>
								</select>
								
								<div class="input-group-btn" >
									<a href="javascript:mx.copyTable('selectTabelList')" href="tablehelp.asp" class="btn btn-default">테이블 복사</a>
								</div>

							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- e: 정보 검색 -->

			<hr />

			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
							<th>table</th>
							<th>rows</th>
							<th>comment</th>
							<th>column</th>
						</tr>
					</thead>

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
										<td><span><%=rs(0)%></span></td>
										<td><span><%=rs(1)%></span></td>
										<td><span>
										<input type='text' value='<%=rs(2)%>'  onblur="if(this.value !=''){mx.SendPacket(this,{'CMD':mx.CMD_TABLECMT,'NM':'<%=rs(0)%>','DN':'<%=DN%>','CMT':this.value, 'MD':<%=MD%>})}" class="form-control">
										</span></td>
										<td><span><a href="javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'<%=rs(0)%>','DN':'<%=DN%>' })" class="btn btn-primary">컬럼 주석</a></span></td>
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
