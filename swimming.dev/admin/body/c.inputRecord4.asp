<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
  'request 처리##############
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX '종목인덱스
	End If
	If hasown(oJSONoutput, "GB") = "ok" then
		gbidx =  oJSONoutput.GB '종목인덱스
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx =  oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "LNM") = "ok" then
		lnm= oJSONoutput.LNM
	End if

  'request 처리##############


	Set db = new clsDBHelper

	'첫번째 수구 종목 가져오기


	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx ,  cda,cdb,cdc,RGameLevelidx,resultopenAMYN "

	If idx = "" then
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn = 'N' and gametitleidx = "&tidx & " and cda= 'E2' and cdc = '31' "
	Else
	SQL = "Select top 1 " & fld & " from tblRGameLevel as a where delyn='N' and  RGameLevelidx = "& idx
	End if

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'	Response.write sql
'	Call rsdrow(rs)
'	Response.end

	If Not rs.EOF Then
		idx = rs(9)
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2)
		tidx = rs(4)

		cda = rs(6)
		cdb = rs(7)
		cdc = rs(8)
		resultopenAMYN = rs(10)
		levelno = cda & cdb & cdc
	End If

	fld = "gameMemberidx,team,teamnm,starttype,tryoutgroupno,tryoutsortno,gbidx,gametitleidx,levelno,gubun,sidonm,tryouttotalorder,requestidx  ,tabletype " 'tabletype N L T 설정전, 리그, 토너먼트
	SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N' order by tryoutsortno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)





	If Not rs.eof Then
		arrT = rs.GetRows()

		attcnt = UBound(arrT, 2) + 1
		starttype = arrT(3,0)
		gno = arrT(4,0)
		sno = arrT(5,0)
		gubun = arrT(9,0) '0 hide

		savetabletype = arrT(13,0) '대진표형태


		if savetabletype = "L"  or  ( savetabletype = "N" and attcnt <= 4 ) then '####################################
			'리그
			tabletype = 1
			tableno = attcnt

			'리그 소팅번호 배정 - 리그 대진표 생성 일괄 (starttype = 3 으로설정하자)
			If gno = "1" Then
				'왼쪽메뉴 다시그려야하니까
				SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'  order by tryoutsortno "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				arrT = rs.GetRows()



				SQL = "select idx,midxL,midxR,teamL,teamR,scoreL,scoreR,winmidx from sd_gameMember_vs where tidx = "&tidx&" and levelno = '"&levelno&"' and delyn = 'N'  order by idx "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




				If Not rs.eof then
				arrX = rs.GetRows()
				End if
			End If

			'대진표 생성은 버튼으로 생성 (순서 설정한 후에 )

		Else'#############################################
			If (savetabletype = "T") or ( savetabletype = "N" and attcnt > 4) Then
				'토너먼트 16강까지만
				tabletype = 2
				tableno = attcnt
				'토너먼트 순서 배정

				Select Case tableno
				Case 5,6,7,8
				tablernd  = 8
				Case 9,10,11,12,13,14,15,16
				tablernd = 16
				Case Else
				tablernd = 32
				End Select


				'리그 소팅번호 배정 - 리그 대진표 생성 일괄 (starttype = 3 으로설정하자) 부족한 갯수만큼 temp(부전팀 생성)
				If gno = "1" Then
					SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'   order by tryoutsortno "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					arrT = rs.GetRows()
				End if

			end if

		End if
	End if

'페이지 입력폼 상태 확인
pageYN = getPageState( "MN0111", "대회관리2" ,Cookies_aIDX , db)
%>





<style>
.slash {
  background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><line x1="0" y1="100%" x2="100%" y2="0" stroke="gray" /></svg>');
}
.backslash {
  background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><line x1="0" y1="0" x2="100%" y2="100%" stroke="gray" /></svg>');
}
.slash, .backslash { text-align: left; }
.slash div, .backslash div { text-align: right; }
table {
	border-collapse: collapse;
	border: 1px solid gray;
}
th, td {
	border: 1px solid gray;
	padding: 5px;
	text-align: center;
}
</style>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>">
        <div class="box-header with-border">
          <!-- <h3 class="box-title"><%=title%></h3> -->  <span style="color:green;"> <%=lnm%></span>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0111'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/inputRecord4form.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


<div class="row">
            <div class="col-md-6"  style="width:25%;">
				  <div class="form-group">


	  <%'===============%>
				<table class="table table-bordered table-hover">
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th style="text-align:center;">NO</th><th style="text-align:center;">소속</th>
						</tr>
					</thead>
					<tbody style="text-align:center;">

						<%
							If IsArray(arrT) Then
								For ari = LBound(arrT, 2) To UBound(arrT, 2)
									t_midx = arrT(0,ari)
									t_team =  arrT(1,ari)
									t_teamnm =  arrT(2,ari)
									sortno = arrT(5,ari)
									t_ridx  = arrT(12,ari)
									%>
										<tr >
											<td><%=sortno%></td>
											<td>
											<%If t_teamnm <> "부전" then%>
											<a href="javascript:mx.orderList(<%=t_ridx%>)" class="btn btn-default"><%=t_teamnm%></a>
											<%else%>
											<%=t_teamnm%>
											<%End if%>
											</td>
										</tr>
									<%
								Next
							End if
						%>

					</tbody>
				</table>
	  <%'===============%>
		<button type="button" class="btn btn-primary" onclick="mx.sendRC(<%=tidx%>,'<%=levelno%>',<%=idx%>)"  style="width:100px;">실적전송</button>


				  </div>
            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6" style="width:75%;">
				  <div class="form-group">







	  <%'===============%>
	  <div class="row" id="tournament2">
			<%
			If tabletype = 1 Then
				If gubun > 0 then
					Call drowLeageRT(arrT, arrX, "admin")
				End if
			Else

				If gubun > 0 then
%>
				<script type="text/javascript">
					mx.makeGameTable(<%=tidx%>,'<%=levelno%>',<%=tabletype%>,<%=tableno%>,'drow');
					//mx.OnShowTourn(1, null , null, null);
				</script>
<%
				End if
			End if
			%>

	  </div>






	  <%'===============%>



				  </div>
			</div>


</div>




</div>
