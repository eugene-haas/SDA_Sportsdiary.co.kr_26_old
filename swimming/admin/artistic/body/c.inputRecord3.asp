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
	CDA = "F2"

	If tidx = "" Then
	Response.End
	End if
  'request 처리##############

	Set db = new clsDBHelper

	SQL = "select gametitlename from sd_gametitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	gametitle = rs(0)

	
	'경기순서를 만들자 들어오면 경기순서가 있는지 확인하고 sum(gameno) = 0 then
	SQL = "select sum(cast(gameno as int)) from  tblRGameLevel Where delyn = 'N' and gametitleidx =  "&tidx&"  and CDA='"&CDA&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If CDbl(rs(0)) = 0  then
	SQL = "UPDATE A  SET A.gameno = A.RowNum FROM ( Select gameno,rank() over(Order By cdc,sexno,Rgamelevelidx) As rowNum From tblRGameLevel Where delyn = 'N' and gametitleidx =  "&tidx&"  and CDA='"&CDA&"' and CDC <> '31'  ) as A " '수구는 빼야함
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
	fld = fld & " ,(select top 1 isnull(gamecodeseq,'') from sd_gameMember_roundRecord  Where tidx = "&tidx&"  And lidx =  a.RGameLevelidx) as chkgamecode " '난이도 입력여부 체크
	fld = fld & " ,finalgamedate,finalgamestarttime " '두번째 날짜 지정 (용도가 다르긴 한데 ㅡㅡ)

	'수구빼고 31
	SQL = "select "&fld&" from tblRGameLevel  as a where  delyn = 'N' and gametitleidx =  " & tidx  & "  and CDA='"&CDA&"'  and CDC <> '31' and (  grouplevelidx is null or grouplevelidx = RGameLevelidx )   " & sexstr & cdcstr & sortstr  '소팅 게임날짜 게임순서, cdc , sexno , cdb
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
															<option value="01" <%If  F2 = "01" then%>selected<%End if%>>솔로(Solo)</option>
															<option value="02" <%If  F2 = "02" then%>selected<%End if%>>듀엣(Duet)</option>
															<option value="03" <%If  F2 = "03" then%>selected<%End if%>>팀(Team)</option>

															<option value="04" <%If  F2 = "04" then%>selected<%End if%>>테크니컬 솔로</option>
															<option value="06" <%If  F2 = "06" then%>selected<%End if%>>테크니컬 듀엣</option>
															<option value="12" <%If  F2 = "12" then%>selected<%End if%>>테크니컬 팀</option>

															<option value="05" <%If  F2 = "05" then%>selected<%End if%>>프리 솔로</option>
															<option value="07" <%If  F2 = "07" then%>selected<%End if%>>프리 듀엣</option>
															<option value="11" <%If  F2 = "11" then%>selected<%End if%>>프리 팀</option>
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

							l_tryoutgamedate = isnulldefault(arrR(10, ari),"")  '대회날짜
							l_tryoutgamestarttime = isnulldefault(arrR(11, ari),"") '오전 오후 시간으로 구분
							l_tryoutgameingS = arrR(12, ari)

							l_gameno = arrR(16, ari) '경기순서
							l_joono = arrR(17, ari)

							l_gubunam = arrR(20, ari)
							l_gubunpm  = arrR(21, ari)

							l_RCOK1 = arrR(22,ari) 'tryout 결과 전송 YN
							l_RCOK2 = arrR(23,ari) '결승 결과 전송 YN

							rtopenAMYN = arrR(24,ari) '앱노출 1일차완료여부
							rtopenPMYN = arrR(25,ari) '앱노출 2일차완료여부

							 l_RoundCnt =  arrR(27,ari)  '라운드수
							 l_judgeCnt =  arrR(28,ari)   '심사위원수
							 l_grouplevelidx = isnulldefault(arrR(29, ari),"") '그룹 묶음 
							 l_gamecodeidx = isnulldefault(arrR(30, ari),"") '게임난이율 테이블 인덱스
							 l_gcnt = arrR(31,ari)
							 l_chkjidx = isNulldefault(arrR(32,ari),"0") '심판배정여부체크 배정전이면 0 라운드 설정도 안되어있다면 null

							 l_chkgamecode = arrR(33,ari) '난이도 입력여부 체크
							 l_finaldate = arrR(34,ari)
							 l_finalgamestarttime = isnulldefault(arrR(35, ari),"") '오전 오후 시간으로 구분

							'난이율체크도 해야한다...

							Select Case Cstr(l_tryoutgamestarttime) 
							Case "10:00" : ampm = "오전"
							Case "13:00" : ampm = "오후"
							Case Else ampm = ""
							End Select 
							Select Case Cstr(l_finalgamestarttime) 
							Case "10:00" : ampm2 = "오전"
							Case "13:00" : ampm2 = "오후"
							Case Else ampm2 = ""
							End Select 
						'redata
					%>
						  <div class="box box-primary collapsed-box" style="margin-bottom:1px;">
							<div class="box-header with-border" >
					  
							  <h3 class="box-title">
							  &nbsp;&nbsp;<%=l_CDCNM%> / <%=l_CDBNM%>  <%If l_gcnt > 0 then%><span style="color:red;font-size:12px;"><!--외--> <%'=l_gcnt-1%></span><%End if%>

							  &nbsp;&nbsp;<span style="color:green;font-size:14px;"><%=l_RoundCnt%>R <%=l_judgeCnt%>심 </span>
							  </h3>


							  <div class="box-tools pull-right">
								<%If l_tryoutgamedate <> "" then%>&nbsp;<%=l_tryoutgamedate%>&nbsp;<%=ampm%><%End if%>
								/ <%If l_finaldate <> "" then%>&nbsp;<%=l_finaldate%>&nbsp;<%=ampm2%><%End if%>



								  <%If l_tryoutgamedate = "" Or  l_RoundCnt = "0" Or l_judgeCnt = "0" Or l_chkjidx = "0" Or l_chkjidx ="" Or l_chkgamecode = "" then%>
									&nbsp;<button class = "btn btn-<%If l_chkjidx = "0" Or l_chkjidx ="" then%>default<%else%>warning<%End if%>" type="button" style="margin-right:10px;" disabled>기록저장</button>
									&nbsp;<button class = "btn btn-<%If l_chkjidx = "0" Or l_chkjidx ="" then%>default<%else%>primary<%End if%>" type="button" style="margin-right:60px;"  disabled>앱노출</button>

									<button type="button" class="btn btn-box-tool" data-widget="collapse" disabled><i class="fa fa-minus"></i></button>
								  
									<%else%>

										<%'if l_RCOK1 = "Y" then '기록저장상태%>
										&nbsp;<button class = "btn btn-<%If l_chkjidx = "0" Or l_chkjidx ="" then%>default<%else%>warning<%End if%>" type="button" style="margin-right:10px;"

										onclick="mx.sendResult(<%=l_idx%>,'<%=l_ITgubun%>')" id ="btn4_<%=l_idx%>"

										>기록저장</button>
										<%'end if%>





									
												<%if rtopenAMYN = "Y" then '일일차종료%>
													&nbsp;<button class = "btn bg-green" type="button" style="margin-right:60px;"
													onclick="mx.setAppShow('appyn_<%=l_idx%>',<%=l_idx%>)" id ="appyn_<%=l_idx%>"
													>앱노출</button>
												<%else%>
													&nbsp;<button class = "btn btn-primary" type="button" style="margin-right:60px;" 
													onclick="mx.setAppShow('appyn_<%=l_idx%>',<%=l_idx%>)" id ="appyn_<%=l_idx%>"
													>앱노출</button>									
												<%end if%>

									<button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="mx.getGameList('game_<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')"><i class="fa fa-plus"></i></button>
								  <%End if%>
							  </div>
							</div>




							  












							<div class="box-body" id="game_<%=l_idx%>" style="tabindex:<%=CDbl(ari) + 1%>">
								  <!-- 여기테이블리스트 include -->
							</div>
						  </div>							
					
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