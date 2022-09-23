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
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "DIDX") = "ok" then
		didx= oJSONoutput.DIDX
	End If

	If hasown(oJSONoutput, "AMPM") = "ok" then
		ampm= oJSONoutput.AMPM
	Else
		ampm = "am"
	End if

  'request 처리##############


	Set db = new clsDBHelper



	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx "

	If tidx = "" Then
	'마지막 대회 번호를 가져오자.(경영만)
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and CDA='D2' order by gametitleidx desc, gbidx asc "
	else
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and gametitleidx =  '"&tidx&"' and CDA='D2' "
	End If

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		title = rs(3)
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2)
		tidx = rs(4)
		gbidx = rs(5)
	End If


	'설정날짜
	SQL = "select idx,gamedate,am,pm,selectflag from sd_gameStartAMPM where tidx = "& tidx & " order by gamedate"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rss.EOF Then
		tmarr = rss.GetRows()
	End If




	'search
	If chkBlank(F2) Then



		If IsArray(tmarr) Then
			For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
				tm_selectflag = tmarr(4, ari)

				If ari = 0 Then
					start_gamedate = isNullDefault(tmarr(1, ari), "")
					start_am = isNullDefault(tmarr(2, ari), "") '오전 시작시간
					start_pm = isNullDefault(tmarr(3, ari), "") '오후 시작시간
				End If

			Next
		End if

	Else



		If IsArray(tmarr) Then
			For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
				tm_gamedate= tmarr(1, ari)


				If F1 = tm_gamedate Then
				start_gamedate = isNullDefault(tmarr(1, ari), "")
				start_am = isNullDefault(tmarr(2, ari), "") '오전시작시간
				start_pm = isNullDefault(tmarr(3, ari), "") '오후 시작시간
				End if

				If F2 = "am" Then
					ampm = "am"
				Else
					ampm = "pm"
				End if

			Next
		End if

	End if


	 fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm,RCOK1,RCOK2, resultopenAMYN,resultopenPMYN " 'app노출여부(결과)
  '++++++++++++++++++++++++
  If start_gamedate = "" Then
	'날짜 생성전

  else

	If ampm = "am" then
		'오전
		SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0) order by gameno "
	else
		SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (finalgamedate = '"&start_gamedate&"' and finalgameingS > 0)    order by gameno2 "
	End If

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

  End if


'Response.write sql
'Call getrowsdrow(arrr)
%>

<%'View ####################################################################################################%>
      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>  <span style="color:green;"></span>
        </div>

		<div class="box-body" id="gameinput_area">
			<%'If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/inputRecordForm.asp" -->
			<!-- e: 등록 화면 -->
			<%'End if%>
        </div>
      </div>


	  <%If ADGRADE <= 500 Then '계측기 사용자 화면 (대회요청 json)%>

	  <div style="width:100%;height:50px;background:#eeeeee">
	  <span >대회번호(TIDX):<%=tidx%></span>&nbsp;&nbsp;<a href="javascript:mx.getGameNoList(<%=TIDX%>,$('#F1').val(),$('#F2').val() )" class="btn btn-default">1. 경기번호_조수리스트</a>
	 &nbsp;&nbsp;* 콘솔로 자세한 값을 확인해주세요.
	  </div>

	  <div id="reqjson" style="width:100%;height:100px;overflow-y:scroll;background:#fff">입력</div>
	  <div id="resjson" style="width:100%;height:100px;overflow-y:scroll;background:#D9D9D9">출력</div>
	  <%End if%>

		<%
				If IsArray(arrR) Then
				lastno = UBound(arrR, 2)
					For ari = LBound(arrR, 2) To UBound(arrR, 2)

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
						l_tryoutgamedate = arrR(10, ari)
						l_tryoutgamestarttime = arrR(11, ari)
						l_tryoutgameingS = arrR(12, ari)
						l_finalgamedate = arrR(13, ari)
						l_finalgamestarttime = arrR(14, ari)
						l_finalgameingS = arrR(15, ari)
						l_gameno = arrR(16, ari)
						l_joono = arrR(17, ari)

						l_gameno2 =  arrR(18, ari)
						l_joono2 = arrR(19, ari)
						l_gubunam = arrR(20, ari)
						l_gubunpm  = arrR(21, ari)

						l_RCOK1 = arrR(22,ari) 'tryout 결과 전송 YN
						l_RCOK2 = arrR(23,ari) '결승 결과 전송 YN

						If ampm = "am" Then
							l_gubun = l_gubunam
							l_RCOK = l_RCOK1
						Else
							l_RCOK = l_RCOK2
							l_gubun = l_gubunpm

							l_gameno = l_gameno2
							l_joono = l_joono2
							l_tryoutgamedate = l_finalgamedate
							l_tryoutgamestarttime = l_finalgamestarttime
							l_tryoutgameingS = l_finalgameingS
						End if


						If l_gubun = "1" Then
						gubunstr = "예선"
						Else
						gubunstr = "결승"
						End If


						rtopenAMYN = arrR(24,ari)
						rtopenPMYN = arrR(25,ari)
					%>
						  <div class="box box-primary collapsed-box" style="margin-bottom:1px;">
							<div class="box-header with-border" >
							  <h3 class="box-title">
							  <!-- 순위소팅 --><button type="button" style="border:0px;" onclick="mx.getGameList2('game_<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="btn2_<%=l_gameno%>"></button>

							  <button type="button" style="border:0px;" onclick="mx.getGameList('game_<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="btn_<%=l_gameno%>"><%=l_gameno%>_<%=l_joono%>&nbsp;&nbsp;<%=l_CDBNM%> <%=l_CDCNM%> (<%=gubunstr%>)</button>


							  <%If ADGRADE <= 500 Then '계측기 사용자 화면%>
							  <span class="btn btn-default" onclick="mx.getINFO(<%=tidx%>,<%=l_gameno%>,'1')">2. 대회 [INDEX : <%=tidx%>]  <%=l_gameno%> 출전선수 JSON 요청</span>
                              <span class="btn btn-default" onclick="mx.setResult()">3. 결과 전송 TEST</span>
							  <span class="btn btn-default" onclick="mx.setSectionResult()">4. 구간 전송 TEST</span>
                              <%if l_CDA = "D2" then%>
                              <button class = "btn bg-green" type="button" onclick="mx.SectionInfoListWindow('game_<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="btn3_<%=l_gameno%>">구간기록조회</button>
                              <%end if%>
							  <%End if%>



							  </h3>
							  <div class="box-tools pull-right">



					  <%If ADGRADE > 500 then%>

                              <!-- 구간기록조회 -->
                              <%if l_CDA = "D2" then%>
                              <button class = "btn bg-green" type="button" onclick="mx.SectionInfoListWindow('game_<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="btn3_<%=l_gameno%>">구간기록조회</button>
                              <%end if%>

							  <%If gubunstr = "예선" Then    '게임번호,  tblRGameLevel.RGameLevelidx, 오전오후(am,pm) , l_gubun(예선, 결승 , 1, 3) %>
							  <button class = "btn btn-danger" type="button" onclick="mx.setRoundUp('<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="btn3_<%=l_gameno%>">결승레인배정</button>
							  <%End if%>

							  
							  <%'체육회 전송 잠정 보류로 일시 적으로 막아둠 내부 레코드만 저장 21.03.19 동현메니져 요청 by baek %>
							  <%'If dhtest = True then%>
							  <%If l_RCOK = "Y" then%>
							  <button class = "btn btn-warning" type="button" style="margin-right:60px;" onclick="mx.sendResult('<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>','<%=l_ITgubun%>')" id ="btn4_<%=l_gameno%>">실적전송(완료)</button>
							  <%else%>
							  <button class = "btn btn-primary" type="button" style="margin-right:60px;" onclick="mx.sendResult('<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>','<%=l_ITgubun%>')" id ="btn4_<%=l_gameno%>">실적전송</button>
							  <%End if%>
							  <%'End if%>


<!-- 							  <%If l_RCOK = "Y" then%> -->
<!-- 							  <button class = "btn btn-warning" type="button" style="margin-right:60px;" onclick="mx.sendResult('<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>','<%=l_ITgubun%>')" id ="btn4_<%=l_gameno%>">기록저장(완료)</button> -->
<!-- 							  <%else%> -->
<!-- 							  <button class = "btn btn-primary" type="button" style="margin-right:60px;" onclick="mx.sendResult('<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>','<%=l_ITgubun%>')" id ="btn4_<%=l_gameno%>">기록저장</button>  -->
<!-- 							  <%End if%> -->

							  <%'체육회 전송 잠정 보류로 일시 적으로 막아둠 내부 레코드만 저장 21.03.19 동현메니져 요청 by baek %>


							  <%If ampm = "am" then%>
							  <button class = "btn <%If rtopenAMYN = "Y" then%>bg-yellow<%else%>btn-default<%End if%>" type="button" style="margin-right:60px;" onclick="mx.setAppShow('appyn_<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="appyn_<%=l_gameno%>">APP노출</button>
							  <%else%>
							  <button class = "btn <%If rtopenPMYN = "Y" then%>bg-yellow<%else%>btn-default<%End if%>" type="button" style="margin-right:60px;" onclick="mx.setAppShow('appyn_<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="appyn_<%=l_gameno%>">APP노출</button>
							  <%End if%>
					<%End if%>


								<button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="mx.getGameList('game_<%=l_gameno%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')">
								<i class="fa fa-plus"></i>
								</button>
							  </div>
							</div>
							<div class="box-body" id="game_<%=l_gameno%>" style="tabindex:<%=CDbl(ari) + 1%>">
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
