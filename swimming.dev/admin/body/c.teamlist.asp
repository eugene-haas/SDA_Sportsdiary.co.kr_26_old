<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	intPageNum = PN
	intPageSize = 20
	strTableName = " tblTeamInfo as a "

	playercnt = " (select COUNT(*) from tblPlayer where Team = a.team ) as mcnt "
	strFieldName = " TeamIDX,EnterType,Team,TeamNm,nation,sido,ZipCode,Address,AddrDtl,Sexno,groupnm,TeamTel,TeamRegDt,TeamMakeDt,SvcEndDt,WriteDate,DelYN,jangname,readername, " & playercnt& " "

	strSort = "  order by teamIDX desc"
	strSortR = "  order by TeamIDX"


	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'   and EnterType = 'E'  "
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
			strWhere = " DelYN = 'N'  and EnterType = 'E'  and "&F1&" like '%"& F2 &"%' "
		End if
	End if


'처음 입력 정보 쿼리
	'insert into tblTeamInfo  (clubyn,Team,TeamNm,sidocode,sido,ZipCode,Address,Sexno,CDB,groupnm,TeamTel,TeamRegDt,SvcEndDt,jangname,readername)
	'(select 
	'CLUB_YN,team_cd,team_nm, sido_cd,(select top 1 sidonm from tblsidoinfo where sido = a.sido_cd) as a ,ZIPCODE,ADDRESS1+ADDRESS2,SEX,PKIND_CD
	', case when right(TEAM_NM,4) = '초등학교' then '초등학교' when right(TEAM_NM,3) = '중학교' then '중학교'  when right(TEAM_NM,4) = '고등학교' then '고등학교'  when right(TEAM_NM,3) = '대학교' then '대학교' else '' end
	',PHONE_NO,REG_YEAR + '-01-01',BROKEN_DT+ '-01-01',HEAD_NM,LEADER_NM  from MY_teaminfo as a )
'처음 입력 정보 쿼리

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10



  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If

pageYN = getPageState( "MN0104", "소속관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">소속관리</h3>

          <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0104'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/teamform.asp" -->
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
											<option value="TeamNm" <%If F1 = "TeamNm" then%>selected<%End if%>>소속명</option>
											<option value="sido" <%If F1 = "sido" then%>selected<%End if%>>시도</option>
										</select>
								  </div>
							</div>


						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										<input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'teamlist.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'teamlist.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>									
									

								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
									  <a href="javascript:mx.copyTeam()" class="btn btn-default">소속정보가져오기</a>
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
								<th>등록년도</th>
								<th>팀코드</th>
								<th>구분</th>
								<th>팀명칭</th>
								<th>시도</th>
								<th>성별</th>
								<th>대표종별</th>
								<th>단체장</th>
								<th>지도자</th>
								<th>우편번호</th>
								<th>주소</th>
								<th>전화</th>
								<th>설립일</th>
								<th>해제일</th>
								<th>선수등록</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


<%


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

l_idx = arrR(0, ari)
l_EnterType = arrR(1, ari)
l_Team = arrR(2, ari)
l_TeamNm = arrR(3, ari)
l_nation = arrR(4, ari)
l_sido = arrR(5, ari)
l_ZipCode = arrR(6, ari)
l_Address = arrR(7, ari)
l_AddrDtl = arrR(8, ari)
l_Sexno = arrR(9, ari)
Select Case l_Sexno
Case "1" : sexstr = "남자"
Case "2" : sexstr = "여자"
Case "3" : sexstr = "혼성"
End Select 
l_groupnm = arrR(10, ari)
l_TeamTel = arrR(11, ari)
l_TeamRegDt = arrR(12, ari)
l_TeamMakeDt = arrR(13, ari)
l_SvcEndDt = arrR(14, ari)
l_WriteDate = arrR(15, ari)
l_DelYN = arrR(16, ari)
l_jangname = arrR(17, ari)
l_readername = arrR(18, ari)

l_mcnt = arrR(19,ari)
			

	%><!-- #include virtual = "/pub/html/swimming/gameTeamList.asp" --><%


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
