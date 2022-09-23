<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################


'  max=100
'  min=1
'  Randomize
'  response.write(Int((max-min+1)*Rnd+min)) & "--"
' response.write PN

	intPageNum = PN
	intPageSize = 20
	strTableName = " tblPlayer as a "

	strFieldName = " PlayerIDX,MemberIDX,userID,startyear,nowyear,userType,ksportsno,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,UserPhone,ProfileIMG,WriteDate,EnterType,TeamNm,userClass,Team,DelYN ,kskey, chkmsg"

	strSort = "  order by playeridx desc"
	strSortR = "  order by playeridx "


	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and entertype = 'A' "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
'			fieldarr = array("gameS")
'			F1_0 = F2(0)
'
'			For i = 0 To ubound(fieldarr)
'				Select Case i
'				Case 0
'					findyear = F2(i)
'				End Select
'			next
		Else
			strWhere = " DelYN = 'N' and entertype = 'A' and "&F1&" like '%"& F2 &"%' "
		End if
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If


PAGE_ENTERTYPE = "A"
pageYN = getPageState( "MN0603", "선수관리" ,Cookies_aIDX , db)
'memoYN = getPageState( "MN0622", "문자관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">선수관리</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0603'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) >= 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/playersform.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>

		<!-- 문자정보 -->
		<%If msnopen = True Then '제공안함%>
		<div class="box box-primary <%If memoYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
			<div class="box-header with-border">
			  <h3 class="box-title">문자관리 (동시사용금지)</h3>

			  <div class="box-tools pull-right">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=memoYN%>','PC':'MN0122'},'/setPageState.asp')"><i class="fa fa-<%If memoYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
			  </div>
			</div>

			<div class="box-body" id="gameinput_area">
				<%If CDbl(ADGRADE) > 500 then%>
				<!-- s: 등록화면 -->

				<div class="col-md-2">
				<select class="form-control" onchange="mx.setMsgCfg($(this).val(),'sido')">
					  <option value="">==시도선택==</option>
					 <%
					  SQL = "select sido,boonm,teamcode,message from tblMsgSend_cfg where delyn = 'N' and adminid = '"&Cookies_aID&"' and mtype = '1' "
					  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					  If Not rs.EOF Then
						 arrCfg = rs.GetRows()
						 cfg_sido = isnulldefault(arrCfg(0, 0),"")
						 cfg_boo = isnulldefault(arrCfg(1, 0),"")
						 cfg_teamcode = isnulldefault(arrCfg(2, 0),"")
						 cfg_message = isnulldefault(arrCfg(3, 0),"")
					  End If

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

					<select class="form-control" onchange="mx.setMsgCfg($(this).val(), 'boo')">
					  <option value="">==부선택==</option>
					 <option value="Y" <%if Cstr(cfg_boo) = "Y" then%>selected<%end if%>>초등부</option>
					  <option value="Z" <%if Cstr(cfg_boo) = "Z" then%>selected<%end if%>>중학부</option>
					  <option value="7" <%if Cstr(cfg_boo) = "7" then%>selected<%end if%>>고등부</option>
					  <option value="8" <%if Cstr(cfg_boo) = "8" then%>selected<%end if%>>대학부</option>
					  <option value="9" <%if Cstr(cfg_boo) = "9" then%>selected<%end if%>>일반부</option>
					</select>
					<input type="text" class="form-control" placeholder="소속팀코드" onblur="mx.setMsgCfg($(this).val(), 'teamcode')" value="<%=cfg_teamcode%>">
				</div>

			 <div class="col-md-1" style="width:50px;">
					<span style="font-size:60px;">+</span>
				</div>

				  <div class="col-md-4" style="height:100px;overflow-x:auto;">
				  <%
				  SQL = " SELECT top 1000 username as '이름',userphone as '핸드폰',teamnm as '소속',sido as '시도' from tblPlayer where chkmsg = 'Y' "
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
				  <!-- <div class="col-md-1">
						<a class="btn btn-danger">명단삭제</a>
				  </div> -->


				<!-- e: 등록 화면 -->
				<%End if%>
			</div>
      </div>
		<%End if%>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">


							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="username" <%If F1 = "username" then%>selected<%End if%>>선수명</option>
											<option value="TeamNm" <%If F1 = "TeamNm" then%>selected<%End if%>>소속명</option>
											<option value="nowyear" <%If F1 = "nowyear" then%>selected<%End if%>>등록년도</option>
										</select>
								  </div>
							</div>




						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'amplayer.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'amplayer.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>


								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <a class="btn btn-danger">총:<%=intTotalCnt%></a>
								  </div>
							</div>
						</div>
            </div>
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>NO</th>
								<th>선수번호</th>
								<th>첫등록</th>
								<th>현재등록</th>
								<th>이름</th>
								<th>한문</th>
								<th>영어</th>
								<th>생년월일</th>
								<th>소속팀1코드</th>
								<th>소속명</th>
 								<th>부(코드)</th>
<!-- 								<th>학년</th> -->
<!-- 								<th>국가</th> -->
<!-- 								<th>시도</th> -->
<!-- 								<th>종목코드</th> -->
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

			l_idx = arrR(0, ari)
			l_MemberIDX = arrR(1, ari)
			l_userID = arrR(2, ari)
			l_startyear = arrR(3, ari)
			l_nowyear = arrR(4, ari)
			l_userType = arrR(5, ari)
			l_ksportsno = arrR(6, ari)
			l_kskey = arrR(28, ari)

			l_ksportsnoS = arrR(7, ari)
			l_UserName = arrR(8, ari)
			l_userNameCn = arrR(9, ari)
			l_userNameEn = arrR(10, ari)
			l_Birthday = arrR(11, ari)
			l_Sex = arrR(12, ari)
			l_nation = arrR(13, ari)
			l_sidoCode = arrR(14, ari)
			l_sido = arrR(15, ari)
			l_CDA = arrR(16, ari)
			l_CDANM = arrR(17, ari)
			l_CDB = arrR(18, ari)
			l_CDBNM = arrR(19, ari)
			l_UserPhone = arrR(20, ari)
			l_ProfileIMG = arrR(21, ari)
			l_WriteDate = arrR(22, ari)
			l_EnterType = arrR(23, ari)
			l_TeamNm = arrR(24, ari)
			l_userClass = arrR(25, ari)
			l_Team = arrR(26, ari)
			l_DelYN = arrR(27, ari)
			'28 kskey
			l_chkmsg = arrR(29, ari) '문자발송여부 플레그


	%>

	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
			<td><%=no%></td>
			<td><%=l_kskey%><%'=l_ksportsno%></td>
			<td><%=l_startyear%><%'=l_ksportsnoS%></td>
			<td><%=l_nowyear%><%'=l_ksportsnoS%></td>
			<td><%=l_UserName%></td>
			<td><%=l_userNameCn%></td>
			<td><%=l_userNameEn%></td>
			<td><%=Left(l_Birthday,6)%>(<%If l_Sex = "1" then%>남<%else%>여<%End if%>)</td>
			<td><%=l_Team%></td>
			<td><%=l_TeamNm%></td>
			<td><%=l_CDBNM%>&nbsp;(<%=l_CDB%>)</td>
<!-- 			<td><%=l_userClass%></td> -->
<!-- 			<td><%=l_nation%></td> -->
<!-- 			<td><%=l_sido%></td> -->
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
