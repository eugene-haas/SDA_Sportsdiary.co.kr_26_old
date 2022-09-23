<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	intPageNum = PN
	intPageSize = 20
	strTableName = " tblPlayer as a "

	strFieldName = " PlayerIDX,MemberIDX,userID,startyear,nowyear,userType,ksportsno,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,UserPhone,ProfileIMG,WriteDate,EnterType,TeamNm,userClass,Team,DelYN ,kskey" 

	strSort = "  order by playeridx desc"
	strSortR = "  order by playeridx "


	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  "
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
			strWhere = " DelYN = 'N' and "&F1&" like '%"& F2 &"%' "
		End if
	End if


'처음 입력 정보 쿼리
'--insert into tblTeamInfo (Team,TeamNm,nation,Sexno,TeamRegDt) (select team_cd,team_nm,'대한민국',sex,YEAR+'-01-01' from MY_player_rec )
'처음 입력 정보 쿼리

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If

'처음 입력 정보 쿼리
	'	insert into tblPlayer (userType,ksportsno,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,CDA,CDANM,CDB,CDBNM,UserPhone,EnterType,TeamNm,userclass,Team)
	'	(select 'I',ID_NO,PERSON_NO,KOR_NM,CHN_NM,ENG_NM,JUMIN_NO,SEX
	'	,SIDO_CD,(select top 1 sidonm from tblsidoinfo where sido = a.sido_cd) as a
	'	,CLASS_CD, (select top 1 PTeamGbNm from tblteamgbinfo where cd_type = 1 and pteamgb = a.CLass_CD ) as b
	'	,PKIND_CD,  (select top 1 cd_booNm from tblteamgbinfo where cd_type = 2 and cd_boo = a.PKIND_CD ) as c
	'	,PHONE_NO,'E', REMARK,  GRADE, TEAM_CD 
	'	from MY_player as a   )
'처음 입력 정보 쿼리


pageYN = getPageState( "MN0103", "선수관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">선수관리</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0103'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/sample/playersform.asp" -->
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
											<option value="username" <%If F1 = "username" then%>selected<%End if%>>선수명</option>
											<option value="TeamNm" <%If F1 = "TeamNm" then%>selected<%End if%>>소속명</option>
										</select>
								  </div>
							</div>

				


						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'players.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'players.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>									
									

								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
									  <!-- <a href="javascript:mx.copyPlayer()" class="btn btn-default">선수정보가져오기</a> -->
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
								<th>선수코드</th>
								<th>이름</th>
								<th>생년월일</th>
								<th>성별</th>
								<th>소속팀코드</th>
								<th>소속명</th>
								<th>학년</th>
								<th>시도</th>
								<th>핸드폰번호</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


<%


	If IsArray(arrR) Then 
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


	%>

	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
			<td><%=l_idx%></td>
			<td><%=l_kskey%><%'=l_ksportsno%></td>
			<td><%=l_UserName%></td>
			<td><%=Left(l_Birthday,6)%></td>
			<td><%=l_Sex%></td>
			<td><%=l_Team%></td>
			<td><%=l_TeamNm%></td>
			<td><%=l_userClass%></td>
			<td><%=l_sido%></td>
			<td><%=l_UserPhone%></td>
	</tr>

	
	<%


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
