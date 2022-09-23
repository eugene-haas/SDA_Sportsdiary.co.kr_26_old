<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 10
	strTableName = " home_gameTitle "
	strFieldName = "seq,gameyear,gamemonth,title,sdate,edate,gameurl,nationNM,cityNM,DELYN,showYN,regdate "

	strSort = "  order by sdate asc"
	strSortR = "  order by sdate desc"

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and gameyear = '"& year(date) &"' "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("gameyear","gameS","gameNa")
			F1_0 = F2(0)
			F1_1 = F2(1)
			F1_2 = F2(2)

			For i = 0 To ubound(fieldarr)
				Select Case i
				Case 0
					gameyear = F2(0)
				Case 1
					findfld2 =  F2(1)
					findvalue = F2(2)
				End Select

			next

			If findvalue = "" then
				strWhere = " DelYN = 'N' and gameyear = '"& F2(0) &"'  "	
			Else
				strWhere = " DelYN = 'N' and gameyear = '"& F2(0) &"'  and "&findfld2&" Like '%"&findvalue&"%' "	
			End if

		End if
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content" >
			<div class="page_title"><h1>국제대회관리</h1></div>
			<div class="info_serch form-horizontal" id="gameinput_area"><!-- s: 폼 -->
			  <!-- s -->
				<%
					If e_idx <> "" then
						%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
					End If
				%>
						<div class="form-group">
							<label class="col-sm-1 control-label">대회명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g0" class="form-control" placeholder="대회명" value="<%=e_title%>" >
							</div>

							<label class="col-sm-1 control-label">URL</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="URL" value="<%=e_gameURL%>" >
								</select>
							</div>
							<label class="col-sm-1 control-label">국가</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g2" class="form-control" placeholder="국가명" value="<%=e_nationNM%>" >
							</div>
							<label class="col-sm-1 control-label">도시</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g3" class="form-control" placeholder="도시명" value="<%=e_cityNM%>" >
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-1 control-label">시작일</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g4" value="<%=e_GameS%>" class="form-control" onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
							</div>
							<label class="col-sm-1 control-label">종료일</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g5"  value="<%=e_GameE%>"  class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>				
							</div>
						</div>


						<div class="btn-group flr" role="group" aria-label="...">
							<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
							<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
							<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
						</div>
			  <!-- e -->
			</div>


			<div class="info_serch">
				<!-- s -->
					<div class="form-horizontal">

						<div class="form-group">
							<label class="col-sm-1 control-label">대회</label>
							<div class="col-sm-2">
								<div class="input-group">
								<select id="F1_0" class="form-control"><!-- form-control-half -->
								  <%For fny = year(date) To 2019 Step -1%>
								  <option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
								  <%Next%>
							  </select>
							  </div>
							</div>

							<div class="col-sm-2">
								<select id="F1_1" class="form-control" >
								  <option value="title" <%If CStr(F1_2) = "title" then%>selected<%End if%>>대회명</option>
								  <option value="nationnm" <%If CStr(F1_2)= "nationnm" then%>selected<%End if%>>국가</option>
								  <option value="citynm" <%If CStr(F1_2)= "citynm" then%>selected<%End if%>>도시</option>
							  </select>
							</div>
							<div class="col-sm-2">
								<input type="text" id="F1_2" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1,2],'F2':['','',''],'F3':[]} , '<%=pagename%>');}" value="<%=F1_3%>">
							</div>

							<a href="javascript:px.goSubmit( {'F1':[0,1,2],'F2':['','',''],'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
						</div>
					</div>

				<!-- e -->
			</div>

			<hr />
		  <div class="btn-toolbar" role="toolbar" aria-label="btns"></div>





			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>No.</th>
								<th>대회기간</th>
								<th>대회명</th>
								<th>링크</th>
								<th>국가</th>
								<th>도시</th>
								<th>노출여부</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
				l_seq = arrR(0, ari)
				l_gameyear = arrR(1, ari)
				l_gamemonth = arrR(2, ari)
				l_title = arrR(3, ari)
				l_sdate = arrR(4, ari)
				l_edate = arrR(5, ari)
				l_gameurl = arrR(6, ari)
				l_nationNM = arrR(7, ari)
				l_cityNM = arrR(8, ari)
				l_DELYN = arrR(9, ari)
				l_showYN = arrR(10, ari)
				l_regdate = arrR(11, ari)
				%>

				<%
				If ci = "" Then
				ci = 1 
				End if
				list_no = (intPageSize * (intPageNum-1)) + ci
				'############################
				%>
				<tr id="titlelist_<%=l_seq%>">
					<td onclick="mx.input_edit(<%=l_seq%>)"><span><%'=l_seq%><%=l_seq%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>)"><span><%=Replace(l_sdate,"-",".")%>~<%=Replace(l_edate,"-",".")%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>)"><span><%=l_title%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>)"><a href="<%=l_gameurl%>" target="_blank"><%=l_gameurl%></a></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>)"><%=l_nationNM%></td>
					<td onclick="mx.input_edit(<%=l_seq%>)"><%=l_cityNM%></td>
					<td>
						<label class="switch" title="노출여부" >
						<input type="checkbox" id="tbl_<%=l_seq%>"  value="<%=l_showYN%>" <%If l_showYN= "Y" then%>checked<%End if%> onclick="mx.setBtnState('tbl_<%=l_seq%>',<%=l_seq%>,1)">
						<span class="slider round"></span>
						</label>			
					</td>
				</tr>

				<%
				'############################
				ci = ci + 1
				Next
				End if
				%>


					</tbody>
				</table>
			</div>
			<!-- e: 테이블 리스트 -->

			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>
		</div>
		<!-- s: 콘텐츠 끝 -->
