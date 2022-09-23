<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	'뒤에서 왔을때 체크되는값
	If hasown(oJSONoutput, "CDA") = "ok" then
		F1 =  oJSONoutput.CDA '대분류 코드 D2 경영
	End If
	If hasown(oJSONoutput, "YY") = "ok" then
		F2 =  oJSONoutput.YY
	End If
	'뒤에서 왔을때 체크되는값



	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_gameTitle as a "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임

	'0국제, 1체전, 2장소, 3주최 , 4주관, 5후원, 6협찬, 7대회명, 8요강, 9규모, 10레인수 ,11대회코드, 12참가비 , 13대회기간 , 14신청기간 , 15대회구분 , 16구분, 17개인, 18팀, 19시도신청, 20시도승인, 21팀당2명이내제한, 22종목수
	attcnt = " (select count(*) from tblGameRequest as x left join tblGameRequest_r as y on x.RequestIDX = y.RequestIDX and y.delyn = 'N' where x.delyn='N' and x.gametitleidx  = a.gametitleidx ) as attcnt "
	strFieldName = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt,GameTitleIDX    ,ViewState,ViewStateM,ViewYN,MatchYN,stateNo, "	 & attcnt

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"


	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and ( gameS >=  '"& year(date) & "-01-01" &"' and  gameS < '"& CDbl(year(date))+1 & "-01-01" &"' )  and GameTitleIDX = (select top 1 GameTitleIDX from tblRgameLevel where GameTitleIDX = a.GameTitleIDX and DelYN='N' and cda = 'E2')  "
	Else
		strWhere = " DelYN = 'N' and ( gameS >=  '"& F2 & "-01-01" &"' and  gameS < '"& CDbl(F2)+1 & "-01-01" &"' )  and GameTitleIDX = (select top 1 GameTitleIDX from tblRgameLevel where GameTitleIDX = a.GameTitleIDX and DelYN='N' and cda = 'E2') "
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10



%>
<%'View ####################################################################################################%>

	  <div class="box-body" id="gameinput_area">


<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>
<style type="text/css">
	.col-md-6{width:25%;}
</style>


<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>개최년도</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

											<select id="F2" class="form-control">
											<%For fny =year(date)+1 To year(date)-3 Step -1%>
											<option value="<%=fny%>" <%If (F2 = "" And fny = year(date)) Or CStr(fny) = CStr(F2) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
											<%Next%>
											</select>
								  </div>
							</div>
						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
						<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<a href="javascript:px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
								  </div>
							</div>
						</div>
				  </div>

			
</div>


      </div>








      <div class="row">

		<div class="col-xs-12">
          <div class="box">

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>NO</th>
								<th>년도</th>
								<th>대회명</th>
								<th>대회기간</th>
								<th>진행상태</th>
								<th>참가신청(명)</th>
								<th>장소</th>
								<th>경기순서/심판배정</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%
					Do Until rs.eof

						l_gubun = rs(0)
						'Select Case l_gubun 
						'Case "A" : l_gubun = "전체"
						'Case "K" : l_gubun = "국내"
						'Case "F" : l_gubun = "국제"
						'End Select 
						l_kgame = rs(1)
						Select Case l_kgame 
						Case "03" : l_kgame = "통합"
						Case "01" : l_kgame = "전문"
						Case "02" : l_kgame = "생활"
						End Select 
						l_GameArea = rs(2)
						l_hostname = rs(3)
						l_subjectnm = rs(4)
						l_afternm = rs(5)
						l_sponnm = rs(6)
						l_GameTitleName = rs(7)
						l_summaryURL = rs(8)
						l_gameSize = rs(9) '규모
						l_ranecnt = rs(10)
						l_titleCode = rs(11)
						l_attmoney = rs(12)
						l_chkdates = CDate(rs(13))
						l_chkdatee = CDate(rs(14))
						l_GameS = Replace(rs(13),"-","/") & " - "
						l_GameE = Replace(rs(14),"-","/")

						l_atts = Replace(Left(rs(15),11),"-","/") & Left(setTimeFormat(CDate(rs(15))),5)  & " - "
						l_atte = Replace(Left(rs(16),11),"-","/") & Left(setTimeFormat(CDate(rs(16))),5)
						l_checkatte = CDate(rs(16))
						l_GameType = rs(17)
						Select Case l_GameType 
						Case "01" : l_GameType = "명칭"
						Case "02" : l_GameType = "승인"
						Case "09" : l_GameType = "기타"
						End Select 

						l_EnterType = rs(18)
						l_attTypeA = rs(19)
						l_attTypeB = rs(20)
						l_attTypeC = rs(21)
						l_attTypeD = rs(22)
						l_teamLimit = rs(23)
						l_attgameCnt = rs(24)
						l_idx = rs(25)

						l_ViewState = rs(26) 
						l_ViewStateM = rs(27) 
						l_ViewYN = rs(28) 
						l_MatchYN = rs(29) 
						l_stateNo = rs(30) 
						l_attcnt = rs(31)

					 %>
					 
					 
					 
					 
<%
If ci = "" Then
ci = 1 
End if
list_no = (intPageSize * (intPageNum-1)) + ci
'############################
%>

		<tr id="titlelist_<%=l_idx%>" style="text-align:center;">
			<td><%=list_no%></td>
			<td><%=Left(l_GameS,4)%></td>
			<td style="text-align:left;"><%=l_GameTitleName%></td></td>
			<td><%=l_GameS%>~<%=l_GameE%></td>


			<%If l_chkdatee > now() then%>	
			<td >진행전</td>
			<%ElseIf  l_chkdates >= now() And l_chkdatee <= now() then%>
			<td class="danger">진행중</td>
			<%else%>
			<td class="bg-gray">종료</td>
			<%End if%>
			
			<td><%=l_attcnt%></td>
			<td><%=l_gamearea%></td><!-- 전체,모바일,홈페이지 -->
			<td><span>
			<a href="javascript:px.goSubmit({'TIDX':<%=l_idx%>,'DIDX':'','KYN':'<%=l_kgame%>'},'DsetRecord3.asp')" class="btn btn-primary">경기 설정</a>
			</span></td>
	

	
		</tr>

<%ci = ci + 1%>



					 
					 
					 
					 
					 <%
					  rs.movenext
					  Loop
					  Set rs = Nothing
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




		<!-- s: 콘텐츠 끝 -->


