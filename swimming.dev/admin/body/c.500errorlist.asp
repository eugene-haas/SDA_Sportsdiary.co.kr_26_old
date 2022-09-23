<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	intPageNum = PN
	intPageSize = 20
	strTableName = " TB_LOG as a "

	strFieldName = " LOG_SEQ,USER_ID,USER_IP,USER_OS,BROWSER,REFFER,ERR_URL,ERR_CONTENT,ERR_FILE,ERR_LINE,REG_DATE "

	strSort = "  order by LOG_SEQ desc"
	strSortR = "  order by LOG_SEQ"

	'search
	If chkBlank(F2) Then
		strWhere = " DB_TYPE = '100'  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
		Else
			strWhere = " DB_TYPE = '100'  and "&F1&" like '%"& F2 &"%' "
		End if
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( LOG_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10



  If Not rs.EOF Then
		'arrR = rs.GetRows()
  End If

pageYN = getPageState( "MN0104", "소속관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">500.100 에러</h3>
        </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              

							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="ERR_URL" <%If F1 = "ERR_URL" then%>selected<%End if%>>ERR_URL</option>
											<option value="USER_IP" <%If F1 = "USER_IP" then%>selected<%End if%>>USER_IP</option>
										</select>
								  </div>
							</div>


						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										<input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'500errorlist.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'500errorlist.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>									
									

								  </div>
							</div>
						</div>			  
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->

            <div class="box-body">
				<%Call rsdrow(rs)%>
            </div>
          </div>
        </div>

	  </div>



		<nav>
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
			%>
		</nav>


		<form method="post" id="testff" target="_blank">
		<input type="text" id="testlink"> <a href="javascript:document.getElementById('testff').action=$('#testlink').val();document.getElementById('testff').submit()" class="btn btn-default">테스트링크</a>
		</form>