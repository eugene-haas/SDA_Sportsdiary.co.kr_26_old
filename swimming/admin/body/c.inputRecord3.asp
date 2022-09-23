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
	'마지막 대회 번호를 가져오자.(다이빙)
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and CDA='F2'  order by gametitleidx desc, gbidx asc "
	else
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and gametitleidx =  '"&tidx&"' and CDA='F2'  "
	End If

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		title = rs(3)
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2) 
		tidx = rs(4)
		gbidx = rs(5)
	End If


If chkBlank(F1) = false Then '남여
	sexstr = " and sexno = '"&F1&"' "
End If
If chkBlank(F2) = False  Then '종목
	cdcstr = " and CDC = '"&F2&"' "
End if


	chktable = " ,(select max(gubun) from sd_gameMember where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N'   and tryoutsortno > 0 ) as makegame " '대신표
	 fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm,RCOK1,RCOK2, resultopenAMYN,resultopenPMYN "& chktable 
  '++++++++++++++++++++++++



	SQL = "select "&fld&" from tblRGameLevel  as a where delyn = 'N' and gametitleidx =  " & tidx  & "  and CDA='F2'   " & sexstr & cdcstr
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Response.end

	If Not rs.EOF Then
		arrR = rs.GetRows()
		gamedate = isnulldefault(arrR(10,0),"")
		
		gamedate = Replace(gamedate,"-","/")
	End If
%>

<%'View ####################################################################################################%>
      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title"><%=title%></h3>  <span style="color:green;"></span>
        </div>

		<div class="box-body" id="gameinput_area">
			<%'If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/inputRecordForm3.asp" -->
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
							l_gubun = 3 '결승
							l_RCOK = l_RCOK1
						Else
							l_RCOK = l_RCOK2
							l_gubun = 3

							l_gameno = l_gameno2
							l_joono = l_joono2
							l_tryoutgamedate = l_finalgamedate
							l_tryoutgamestarttime = l_finalgamestarttime
							l_tryoutgameingS = l_finalgameingS
						End if

						rtopenAMYN = arrR(24,ari)
						rtopenPMYN = arrR(25,ari)
					%>
						  <div class="box box-primary collapsed-box" style="margin-bottom:1px;">
							<div class="box-header with-border" >
							  <h3 class="box-title">
							  <!-- 순위소팅 --><button type="button" style="border:0px;" onclick="mx.getGameList2('game_<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="btn2_<%=l_idx%>"></button>

							  <button type="button" style="border:0px;" onclick="mx.getGameList('game_<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="btn_<%=l_idx%>">&nbsp;&nbsp;<%=l_CDCNM%> / <%=l_CDBNM%></button> 
							  


				  


							  </h3>
							  <div class="box-tools pull-right">
							  
							  
							  
					  <%If ADGRADE > 500 then%>
							 
							  <%If l_RCOK = "Y" then%>
							  <button class = "btn btn-warning" type="button" style="margin-right:60px;" onclick="mx.sendResult('<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','3','<%=l_ITgubun%>')" id ="btn4_<%=l_idx%>">실적전송(완료)</button>
							  <%else%>
							  <button class = "btn btn-primary" type="button" style="margin-right:60px;" onclick="mx.sendResult('<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','3','<%=l_ITgubun%>')" id ="btn4_<%=l_idx%>">실적전송</button>
							  <%End if%>

							  <button class = "btn <%If rtopenAMYN = "Y" then%>bg-yellow<%else%>btn-default<%End if%>" type="button" style="margin-right:60px;" onclick="mx.setAppShow('appyn_<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')" id ="appyn_<%=l_idx%>">APP노출</button>

					<%End if%>


								<button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="mx.getGameList('game_<%=l_idx%>',<%=l_idx%>,'<%=ampm%>','<%=l_gubun%>')">
								<i class="fa fa-plus"></i>
								</button>
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


