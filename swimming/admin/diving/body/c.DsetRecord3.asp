<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->


<style type="text/css">
input[type=checkbox]
{
  /* Double-sized Checkboxes */
  -ms-transform: scale(2); /* IE */
  -moz-transform: scale(2); /* FF */
  -webkit-transform: scale(2); /* Safari and Chrome */
  -o-transform: scale(2); /* Opera */
  margin-top:10px;
}	
</style>

<%
 'Controller ################################################################################################

  'request 처리##############
	tidx= oJSONoutput.Get("TIDX")
	didx= oJSONoutput.Get("DIDX")
	ampm = "am" 'AM (파이널개념이 없으므로 모두 am으로 처리하면 됨) 예선 , 본선없음 am

	If tidx = "" Then
	Response.End
	End if
  'request 처리##############

	Set db = new clsDBHelper

	SQL = "select gametitlename from sd_gametitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gametitle = rs(0)

	
	'경기순서를 만들자 들어오면 경기순서가 있는지 확인하고 sum(gameno) = 0 then
	SQL = "select sum(cast(gameno as int)) from  tblRGameLevel Where delyn = 'N' and gametitleidx =  "&tidx&"  and CDA='E2' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If CDbl(rs(0)) = 0  then
		SQL = "UPDATE A  SET A.gameno = A.RowNum FROM ( Select gameno,rank() over(Order By cdc,sexno,Rgamelevelidx) As rowNum From tblRGameLevel Where delyn = 'N' and gametitleidx =  "&tidx&"  and CDA='E2' and CDC <> '31'  ) as A " '수구는 빼야함
		Call db.execSQLRs(SQL , null, ConStr)
		sortstr = " order by cdc, sexno,Rgamelevelidx "
	Else
		sortstr = " order by cast(gameno as int) "	
	End if


	If chkBlank(F1) = false Then '남여
		sexstr = " and sexno = '"&F1&"' "
	End If
	If chkBlank(F2) = False  Then '종목
		cdcstr = " and CDC = '"&F2&"' "
	End if

	chktable = " ,(select max(gubun) from sd_gameMember where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N'   and tryoutsortno > 0 ) as makegame " '대진표
	fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB"

	cdbnmlist = "(SELECT  STUFF(( select ','+ CDBNM from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx group by CDBNM for XML path('') ),1,1, '' ))"
	fld = fld & ", (case when grouplevelidx is null then CDBNM else "&cdbnmlist&" end ) as CDBNM " '여러부서로 보여줘야함.

	fld = fld & ",CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime"
	fld = fld & ",finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm,RCOK1,RCOK2, resultopenAMYN,resultopenPMYN "& chktable 

	fld = fld & " , isnull(RoundCnt,0), isnull(judgeCnt,0) , grouplevelidx ,gamecodeidx  , (select count(*) from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx ) as gcnt " '신규추가 필드 
	' RoundCnt, judgeCnt " '라운드수, 심사위원수

	fld = fld & " ,(select top 1 isnull(jidx1,0) from sd_gameMember_roundRecord  Where tidx = "&tidx&"  And lidx =  a.RGameLevelidx ) as chkjidx " '심판배정여부 체크
	fld = fld & " , gameno_temp "

	'수구빼고 31
	SQL = "select "&fld&" from tblRGameLevel  as a where  delyn = 'N' and gametitleidx =  " & tidx  & "  and CDA='E2'  and CDC <> '31' and (  grouplevelidx is null or grouplevelidx = RGameLevelidx )   " & sexstr & cdcstr & sortstr  '소팅 게임날짜 게임순서, cdc , sexno , cdb
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If Not rs.EOF Then
		arrR = rs.GetRows()
		gamedate = isnulldefault(arrR(10,0),"")
		gamedate = Replace(gamedate,"-","/")
	End If
%>

<%'View ####################################################################################################%>
      <div class="box box-primary">
			<div class="box-header with-border">
			  <h3 class="box-title"><%=gametitle%></h3>  <span style="color:green;"></span>
			</div>

		<div class="box-body" id="gameinput_area">
				<div class="row">
							<div class="col-md-6"><%'td%>
								  <div class="form-group">
										<label>다이빙 검색</label>
										<div class="row">
											<div class="col-md-6" style="width:100%;">
												  <div class="form-group">

													<div class="input-group date">
													  <div class="input-group-addon">
														<i class="fa  fa-user"></i>
													  </div>
														<select id="F1" class="form-control">
																<option value="" <%If  F1 = "" then%>selected<%End if%>>전체</option>
																<option value="1" <%If  F1 = "1" then%>selected<%End if%>>남자</option>
																<option value="2" <%If F1 = "2" then%>selected<%End if%>>여자</option>
																<option value="3" <%If F1 = "3" then%>selected<%End if%>>혼성</option>
														</select>
													</div>
												  </div>
											</div>

										</div>
								  </div>
							</div><%'#####################################################################################가로 한줄%>

							<div class="col-md-6">
								  <div class="form-group">
										<label>&nbsp;</label>
										<div class="row">
											<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
												  <div class="form-group" id = "cdcnmlist">
														<select id="F2" class="form-control">
															<option value="" <%If  F2 = "" then%>selected<%End if%>>전체</option>
															<option value="21" <%If  F2 = "21" then%>selected<%End if%>>플렛포옴다이빙</option>
															<option value="22" <%If  F2 = "22" then%>selected<%End if%>>스프링보오드1M</option>
															<option value="23" <%If  F2 = "23" then%>selected<%End if%>>스프링보오드3M</option>
															<option value="24" <%If  F2 = "24" then%>selected<%End if%>>싱크로다이빙3M</option>
															<option value="25" <%If  F2 = "25" then%>selected<%End if%>>싱크로다이빙10M</option>
															<option value="26" <%If  F2 = "26" then%>selected<%End if%>>스프링다이빙</option>
														</select>
												  </div>
											</div>
											<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
												  <div class="form-group">
														<a href="javascript:px.goSubmit( {'TIDX':<%=tidx%>,'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
												  </div>
											</div>
										</div>
								  </div>
							</div>
				</div>

        </div>
      </div>




	  <div style="width:100%;height:50px;background:#eeeeee">
	  &nbsp;&nbsp;<a href="javascript:mx.sumGame()" class="btn btn-default">선택항목 경기통합</a>
	  &nbsp;&nbsp;<a href="javascript:mx.divGame(<%=tidx%>)" class="btn btn-default" style="margin-left:-10px;">선택항목 해제</a>
	  &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;<a href="javascript:mx.refereeWindow(<%=tidx%>,'E2')" class="btn btn-warning">대회심판배정</a>
	  </div>





			<!-- 탭모양 버튼을 만들자 -->
			<div class="box-header with-border" style="text-align:right;margin-bottom:-17px;">
						<div style="width:82px;float:right;">&nbsp;</div>
						<a href="javascript:mx.setJudgeAll(<%=tidx%>)" class="btn btn-primary" style="float:right;">심판배정</a>
						<div style="width:455px;float:right;">&nbsp;</div>
						<a href="javascript:mx.setGameno(<%=tidx%>)" class="btn btn-primary" style="float:right;">경기순서적용</a>
			</div>

		<%
			    '예선본선이 없으므로 필드는 tryout 으로 사용 gameno 사용
				If IsArray(arrR) Then 
				lastno = UBound(arrR, 2)
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
					'rsdata
							l_idx = arrR(0, ari)
							l_GbIDX = arrR(1, ari)
							l_ITgubun = arrR(2, ari)
							l_CDA = arrR(3, ari)
							l_CDANM = arrR(4, ari)
							l_CDB = arrR(5, ari)
							l_CDBNM = arrR(6, ari)
							l_CDC = arrR(7, ari)
							l_CDCNM = arrR(8, ari)
							l_SetBestScoreYN = arrR(9, ari)

							l_tryoutgamedate = arrR(10, ari)  '대회날짜
							l_tryoutgamestarttime = isnulldefault(arrR(11, ari),"") '오전 오후 시간으로 구분
							l_tryoutgameingS = arrR(12, ari)

							l_gameno = arrR(16, ari) '경기순서
							l_joono = arrR(17, ari)

							l_gubunam = arrR(20, ari) '1 ,3 오전 , 예전/결승
							l_gubunpm  = arrR(21, ari)'1 ,3 오후 , 예전/결승

							l_RCOK1 = arrR(22,ari) 'tryout 결과 전송 YN
							l_RCOK2 = arrR(23,ari) '결승 결과 전송 YN

							rtopenAMYN = arrR(24,ari) '앱노출 오전
							rtopenPMYN = arrR(25,ari) '앱노출 오후

							makegame =  arrR(26,ari) '추첨완료여부 (1)

							l_RoundCnt =  arrR(27,ari)  '라운드수
							l_judgeCnt =  arrR(28,ari)   '심사위원수
							l_grouplevelidx = isnulldefault(arrR(29, ari),"") '그룹 묶음 
							l_gamecodeidx = isnulldefault(arrR(30, ari),"") '게임난이율 테이블 인덱스
							l_gcnt = arrR(31,ari)
							l_chkjidx = isNulldefault(arrR(32,ari),"0") '심판배정여부체크 배정전이면 0 라운드 설정도 안되어있다면 null

							'게임번호 임시저장소
							l_gameno_temp = arrR(33,ari)
						'redata
					%>
				<%If makegame = "1"  Then '설정전이라면%>
						  <div class="box box-primary collapsed-box" style="margin-bottom:1px;">
							<div class="box-header with-border" >
							  <input type="checkbox" id="chk_<%=l_idx%>" value="<%=l_grouplevelidx%>_<%=l_idx%>" onclick="mx.sumCheck($(this))"><!-- 부통합해서 경기한다. 경기순서가 같아져야한다. 라운드수가 같아야한다. 난의율, 날짜 오전오후 통일 -->
							  <h3 class="box-title">
							  &nbsp;&nbsp;<%=l_CDCNM%> / <%=l_CDBNM%>  <%If l_gcnt > 0 then%><span style="color:red;font-size:12px;"> <!--외--> <%'=l_gcnt-1%></span><%End if%>
							  </h3>
							  
							  <div class="box-tools pull-right">
									<!-- 순서대로보여줄꺼임 -->
								  <%'통합된거, 검색된거라면 그리지 않는다.%>
									<input id="gameno_<%=l_idx%>" value="<%=l_gameno_temp%>" class="form-control" style="width:100px;float:left;" 
									  onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.tempOrder('E2',<%=tidx%>,<%=l_idx%>,$(this).val(), $(this).prop('defaultValue'))"
									 >

								  <input id="player_<%=l_idx%>" value="<%=l_gameno%>" class="form-control" style="width:100px;float:left;" <%If l_grouplevelidx <> "" then%>disabled<%End if%> onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeOrder('E2',<%=tidx%>,<%=l_idx%>,$(this).val(), $(this).prop('defaultValue'))">
									
									
									
									<%
									If l_judgeCnt = "" Or l_judgeCnt = "0" or l_grouplevelidx <> "" then
										selectstyle = ""
									Else
										selectstyle = "background:#DFDC9D;"
									End If
									%>
									<select id="rd_<%=l_idx%>" class="form-control" style="width:80px;float:left;<%=selectstyle%>" onchange="mx.setRound(<%=tidx%>, <%=l_idx%>, <%=l_GbIDX%>, $(this).val() , '<%=l_chkjidx%>')"
									<%If l_grouplevelidx <> "" then%>disabled<%End if%>>
											<%If l_RoundCnt = "" Or l_RoundCnt = "0" then%>
											<option value="" >RD</option>
											<%End if%>
											<%for r = 5 to 7%>
											<option value="<%=r%>" <%If CDbl(l_RoundCnt) = r then%>selected<%End if%> >R <%=r%></option>
											<%next %>
									</select>

									<select id="j_<%=l_idx%>" class="form-control" style="width:100px;float:left;<%=selectstyle%>" onchange="mx.setJudgeCnt(<%=tidx%>, <%=l_idx%>, <%=l_GbIDX%>, $(this).val(), '<%=l_chkjidx%>')">
											<%If l_judgeCnt = "" Or l_judgeCnt = "0" then%>
											<option value="" >심사</option>
											<%End if%>
											<option value="5"  <%If CDbl(l_judgeCnt) = 5 then%>selected<%End if%>>5심</option>
											<option value="7"  <%If CDbl(l_judgeCnt) = 7 then%>selected<%End if%>>7심</option>
											<option value="9"  <%If CDbl(l_judgeCnt) = 9 then%>selected<%End if%>>9심</option>
											<option value="11"  <%If CDbl(l_judgeCnt) = 11 then%>selected<%End if%>>11심</option>
									</select>

									<input type="text" id="gamedate_<%=l_idx%>" placeholder="대회날짜" value="<%=l_tryoutgamedate%>" class="form-control"  style="width:100px;float:left;text-align:right" onchange="mx.setGamedate2(<%=tidx%>, <%=l_idx%>, <%=l_GbIDX%>, $(this).val())">

									<select id="ap_<%=l_idx%>" class="form-control" style="width:80px;float:left;" onchange="mx.setAMPM(<%=tidx%>, <%=l_idx%>, <%=l_GbIDX%>, $(this).val())">
											<%If l_tryoutgamestarttime = "" then%>
											<option value="" >선택</option><!-- 난의도 등의 설정 가져오기 -->
											<%End if%>
											<option value="10:00"  <%If Cstr(l_tryoutgamestarttime) = "10:00" then%>selected<%End if%>>오전</option>
											<option value="13:00" <%If Cstr(l_tryoutgamestarttime) = "13:00" then%>selected<%End if%>>오후</option>
									</select>
							  
								  <!-- 라운드와 심판이 배정수가 정해졌나 확인필요 -->
								  <button class = "btn btn-<%If l_chkjidx = "0" Or l_chkjidx ="" then%>default<%else%>warning<%End if%>" type="button" style="margin-right:60px;" onclick="mx.setreferee(<%=tidx%>,<%=l_idx%>, 'chkpass')" id ="btn4_<%=l_idx%>">심판배정</button>
								  <button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="mx.getGameList('game_<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')"><i class="fa fa-plus"></i></button>

							  </div>
							</div>
				<%ELSE%>
						  <div class="box box-primary collapsed-box" style="margin-bottom:1px;">
							<div class="box-header with-border" >

							  <input type="checkbox" id="chk_<%=l_idx%>" value="<%=l_grouplevelidx%>_<%=l_idx%>" onclick="mx.sumCheck($(this))"><!-- 부통합해서 경기한다. 경기순서가 같아져야한다. 라운드수가 같아야한다. 난의율, 날짜 오전오후 통일 -->
							  <h3 class="box-title">
							  &nbsp;&nbsp;<%=l_CDCNM%> / <%=l_CDBNM%>  <span style="color:red;font-size:12px;">대진표미추첨</span>
							  </h3>
							  
							  <div class="box-tools pull-right">
								  <input id="player_<%=l_idx%>" value="<%=l_gameno%>" class="form-control" style="width:100px;float:left;" <%If l_grouplevelidx <> "" then%>disabled<%End if%> onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeOrder('E2',<%=tidx%>,<%=l_idx%>,$(this).val(), $(this).prop('defaultValue'))">
									<select id="rd_<%=l_idx%>" class="form-control" style="width:80px;float:left;" disabled>
									</select>

									<select id="j_<%=l_idx%>" class="form-control" style="width:100px;float:left;" disabled>
									</select>
									<input type="text" id="gamedate_<%=l_idx%>"  class="form-control"  style="width:100px;float:left;text-align:right"  disabled>

									<select id="ap_<%=l_idx%>" class="form-control" style="width:80px;float:left;" disabled>
									</select>
								  <button class = "btn btn-<%If l_chkjidx = "0" Or l_chkjidx ="" then%>default<%else%>warning<%End if%>" type="button" style="margin-right:60px;"  disabled>심판배정</button>
								  <button type="button" class="btn btn-box-tool"  disabled><i class="fa fa-plus"></i></button>

							  </div>
							</div>
				<%End if%>



							<div class="box-body" id="game_<%=l_idx%>" style="tabindex:<%=CDbl(ari) + 1%>">
								  <!-- 여기테이블리스트 include -->
							</div>
						  </div>							
					
					<%
					pre_gameno = r_a2
					Next
				End if
		%>

<script type="text/javascript">
<!--
<%
If IsArray(arrR) Then 
	For ari = LBound(arrR, 2) To UBound(arrR, 2)
%>
//	$('#gamedate_<%=ari%>').datepicker({format: 'yyyy/mm/dd',locale:'KO',autoclose: true});	
<%
	next
end if
%>
//-->
</script>










					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>


