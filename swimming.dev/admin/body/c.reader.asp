<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	intPageNum = PN
	intPageSize = 20
	strTableName = " tblReader as a "

	strFieldName = " startyear,userType,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,CDB,CDBNM,UserPhone,TeamNm,Team,DelYN ,kskey,idx,chkmsg "

	strSort = "  order by idx desc,kskey desc" '고유키여야 겹치지 않는다.
	strSortR = "  order by idx asc ,kskey "

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
		Else
			strWhere = " DelYN = 'N' and "&F1&" like '%"& F2 &"%' "
		End if
	End if

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

  If Not rs.EOF Then
		arrR = rs.GetRows()
		'Call getrowsdrow(arrR)
  End If

pageYN = getPageState( "MN0110", "리더관리" ,Cookies_aIDX , db)

'Response.write Request.ServerVariables("REMOTE_ADDR")
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">문자 (동시사용금지)</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0110'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			<!-- s: 등록화면 -->

			<div class="col-md-2">
                 <%
                  SQL = "select sido,boonm,teamcode,message,chkyear from tblMsgSend_cfg where delyn = 'N' and adminid = '"&Cookies_aID&"' and mtype = '2' "
                  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
                  If Not rs.EOF Then
                     arrCfg = rs.GetRows()
                     cfg_sido = isnulldefault(arrCfg(0, 0),"")
                     cfg_boo = isnulldefault(arrCfg(1, 0),"")
                     cfg_teamcode = isnulldefault(arrCfg(2, 0),"")
                     cfg_message = isnulldefault(arrCfg(3, 0),"")
                     cfg_chkyear = isnulldefault(arrCfg(4, 0),"")
                  End If
				  %>

				<select class="form-control" onchange="mx.setMsgCfg($(this).val(),'chkyear')">
	               <option value="<%=year(date)%>" <%if Cdbl(cfg_chkyear) = year(date) then%>selected<%end if%>><%=year(date)%></option>
	               <option value="<%=year(date)-1%>" <%if Cdbl(cfg_chkyear) = year(date)-1 then%>selected<%end if%>><%=year(date)-1%></option>
				</select>

			<select class="form-control" onchange="mx.setMsgCfg($(this).val(),'sido')">
	              <option value="">==시도선택==</option>
                 <%
                  SQL = "select sido,sidonm from tblSidoInfo where delyn = 'N' "
                  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
                  If Not rs.EOF Then
                		arrS = rs.GetRows()
                  End If

                  If IsArray(arrR) Then
                     For ari = LBound(arrR, 2) To UBound(arrR, 2)
                     o_sido = arrS(0, ari)
                     o_sidonm = arrS(1, ari)
                    %>
                    <option value="<%=o_sido%>" <%if Cstr(cfg_sido) = Cstr(o_sido) then%>selected<%end if%>><%=o_sidonm%></option>
                    <%
                     next
                  end if
                 %>
				</select>


				<input type="text" class="form-control" placeholder="소속팀코드" onblur="mx.setMsgCfg($(this).val(), 'teamcode')" value="<%=cfg_teamcode%>">
			</div>

         <div class="col-md-1" style="width:50px;">
				<span style="font-size:60px;">+</span>
			</div>

			  <div class="col-md-4" style="height:100px;overflow-x:auto;">
<%
              SQL = " SELECT top 1000 username as '이름',userphone as '핸드폰',teamnm as '소속',sido as '시도' from tblReader where chkmsg = 'Y' "
		        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

              call rsdrow(rs)
%>
			  </div>


			  <div class="col-md-2" style="height:100px;overflow-x:auto;">
				  <textarea class="form-control" rows="4" style="height:100px;" placeholder="문자내용을 입력하세요 ..." onblur="mx.setMsgCfg($(this).val(), 'message')"><%=cfg_message%></textarea>
			  </div>



			  <div class="col-md-1">
				  	<%If cfg_message = "" then%>
					<a class="btn btn-primary" >작성완료</a><br><br>
					<a class="btn btn-default" disabled onclick="alert('보낼 문자를 입력해 주십시오.')">문자전송</a>
					<%else%>
					<a class="btn btn-primary" >작성완료</a><br><br>
					<a class="btn btn-primary" onclick="mx.sendMessage()">문자전송</a>
					<%End if%>
			  </div>

			  <%'<!-- #include virtual = "/pub/html/swimming/readerform.asp" -->%>
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">


							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="username" <%If F1 = "username" then%>selected<%End if%>>리더명</option>
											<option value="TeamNm" <%If F1 = "TeamNm" then%>selected<%End if%>>소속명</option>
											<option value="startyear" <%If F1 = "startyear" then%>selected<%End if%>>등록년도</option>
										</select>
								  </div>
							</div>




						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'reader.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'reader.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>


								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
									  <a class="btn btn-danger">총:<%=intTotalCnt%></a>
									  <a href="javascript:mx.copyPlayer()" class="btn btn-default">리더정보가져오기</a>
								  </div>
							</div>
						</div>
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>NO</th>
								<th>번호</th>
								<th>등록번호</th>
								<th>등록년도</th>
								<th>이름</th>
								<th>생년월일</th>
								<th>성별</th>
								<th>팀코드</th>
								<th>소속명</th>
								<!-- <th>부(코드)</th> -->
								<th>시도</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle mailbox-messages">


<%


	If IsArray(arrR) Then
		If Cdbl(intPageNum) = 1 Then
			no = 1
		Else
			no = ((intPageNum-1) * intPageSize) + 1
		End if



		For ari = LBound(arrR, 2) To UBound(arrR, 2)
		'l_idx = arrR(0, ari)
		l_startyear = arrR(0, ari)
		l_userType = arrR(1, ari)
		l_UserName = arrR(2, ari)
		l_userNameCn = arrR(3, ari)
		l_userNameEn = arrR(4, ari)
		l_Birthday = arrR(5, ari)
		l_Sex = arrR(6, ari)
		l_sidoCode = arrR(7, ari)
		l_sido = arrR(8, ari)
		l_CDB = arrR(9, ari)
		l_CDBNM = arrR(10, ari)
		l_UserPhone = arrR(11, ari)
		l_TeamNm = arrR(12, ari)
		l_Team = arrR(13, ari)
		l_DelYN = arrR(14, ari)
		l_kskey = arrR(15, ari)
		l_idx = arrR(16,ari)
		l_chkmsg = arrR(17,ari)

	%>
	<tr class="gametitle" id="titlelist_<%=ari%>"  style="text-align:center;"> <!-- onclick="mx.input_edit(<%=l_idx%>)"> -->
		<td>
				<input type="checkbox" value="<%=l_idx%>" <%if l_chkmsg = "Y" then%>checked<%end if%>>
		</td>
			<td><%=no%></td>
			<td><%=l_kskey%></td>
			<td><%=l_startyear%></td>
			<td><%=l_UserName%></td>
			<td><%=Left(l_Birthday,6)%></td>
			<td><%=l_Sex%></td>
			<td><%=l_Team%></td>
			<td><%=l_TeamNm%></td>
			<!-- <td><%=l_CDBNM%>(<%=l_CDB%>)</td> -->
			<td><%=l_sido%></td>
	</tr>
	<%

		no = no + 1
		pre_gameno = r_a2
		Next
	End if
%>


					</tbody>
				</table>


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
