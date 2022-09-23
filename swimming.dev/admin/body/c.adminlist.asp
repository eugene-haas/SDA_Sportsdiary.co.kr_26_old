<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################

	'Constr = B_ConStr
	TN = "tblAdminMember"

	Set db = new clsDBHelper

	IDXFIELDNM = "AdminMemberIDX"
	intPageSize = 20
	intPageNum = PN
	strTableName = TN
	strFieldName = " * "

	strSort = "  order by " & IDXFIELDNM & " desc"
	strSortR = "  order by " & IDXFIELDNM

	If F1 <> "" And F2 <> "" Then
		strWhere =  " SiteCode = '"&SiteCode&"' and " & F1 & " like '%" & F2 & "%'  "
	else
		strWhere = " SiteCode = '"&SiteCode&"' "
	End if

	'Set rs = GetBBSSelectRS( B_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	'block_size = 10

	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
%>
<%'View ####################################################################################################%>

      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title"></h3>

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
						<%
						jsonstr = JSON.stringify(oJSONoutput)
						%>
						<div class="col-sm-2">
							<select id="F1" class="form-control">
								<option value="UserID" <%If F1 = "UserID" then%>selected<%End if%>>아이디</option>
								<option value="adminname"  <%If F1 = "adminname" then%>selected<%End if%>>이름</option>
							</select>
						</div>
						<div class="col-sm-3">
							<div class="input-group">
								<input type="text" maxlength="20" id="F2" class="form-control" onkeydown='if(event.keyCode == 13){px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())}' value="<%=F2%>">
								<div class="input-group-btn">
									<a  href='javascript:px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())' class="btn btn-default">검색</a>
								</div>
							</div>
						</div>
						<div class="col-sm-1">
							<a href="javascript:mn.writePop('modalS',2)" class="btn btn-primary">어드민등록</a>
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
					<th>번호</th>
					<th>아이디</th>
					<th>이름</th>
					<th>작성일</th>
					<th>사용유무</th>
					<th>수정</th>
                </tr>
                </thead>
                <tbody id="tblbody">

						<%
						Do Until rs.eof
						%>
								<tr style="text-align:center;">
									<td><span><%=rs(0)%></span></td>
									<td><span><%=rs("UserID")%></span></td>
									<td><span><%=rs("adminname")%></span></td>
									<td><span><%=Left(rs("writedate"),10)%></span></td>
									<td><span><a href="javascript:mn.setBtnState('btn1_<%=rs(0)%>',<%=rs(0)%>,'<%= rs("USEYN") %>',10)" 
									
									<%If rs("USEYN")="Y" then%> class="btn btn-fix-sm btn-primary"<%Else%>class="btn btn-fix-sm btn-warning"<%End If%>

									
									
									id="btn1_<%=rs(0)%>"><%=rs("USEYN")%></a></span></td>
									<td><span><a href="javascript:mn.writePop('modalS',2, <%=rs(0)%>)" class="btn btn-primary">등급[<%=rs("Authority")%>] 수정 </a></span></td>
								</tr>

						<%
						rs.movenext
						Loop
						Set rs = Nothing
						%>

                </tbody>
				<!-- <tfoot><tr><th>tfoor</th></tr></tfoot> -->
              </table>
            </div>


		  </div>
        </div>
      </div>
