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
	If hasown(oJSONoutput, "TGB") = "ok" then
		tidx =  oJSONoutput.TGB
	End If
	If hasown(oJSONoutput, "LNM") = "ok" then
		lnm= oJSONoutput.LNM
	End If

	'리그 토너먼트 변경
	If hasown(oJSONoutput, "MT") = "ok" then
		maketype = oJSONoutput.Get("MT") '1 리그 2 토너먼트 (변경요청으로 작업 중 21.3.5 by baek)
	End If

	showtype = oJSONoutput.get("SHOWTYPE")

'response.write maketype & "-------------------"
'response.end

  'request 처리##############


	Set db = new clsDBHelper


	gametitlenm = " (select gametitlename from sd_gametitle where gametitleidx = a.gametitleidx ) as titlenm "
	fld =  " CDANM,CDBNM,CDCNM, " & gametitlenm & " , gametitleidx,gbidx ,  cda,cdb,cdc "
	SQL = "Select " & fld & " from tblRGameLevel as a where RGameLevelidx =  '"&idx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	'Call rsdrow(rs)
	'Response.end

	If Not rs.EOF Then
		lnm = rs(3) & " " & rs(0) & " " & rs(1) & " " & rs(2)
		tidx = rs(4)

		cda = rs(6)
		cdb = rs(7)
		cdc = rs(8)
		levelno = cda & cdb & cdc
	End If

	fld = "gameMemberidx,team,teamnm,starttype,tryoutgroupno,tryoutsortno,gbidx,gametitleidx,levelno,gubun,sidonm  ,tabletype " 'tabletype N L T 설정전, 리그, 토너먼트
	SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N' order by tryoutsortno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Response.write sql
	'Call rsdrow(rs)
	'Response.end

	If Not rs.eof Then
		arrT = rs.GetRows()

		attcnt = UBound(arrT, 2) + 1
		starttype = arrT(3,0)
		gno = arrT(4,0)
		sno = arrT(5,0)
		gubun = arrT(9,0) '0 hide

		savetabletype = arrT(11,0)



		'maketype reload 하면 다른기능 번호바꿈이라던지 원복되버린다. maketype쓰고 제자리로 돌려놔야한다. 두번스크립트 실행하자....
		If (savetabletype = "L" and maketype = "")  or  ( savetabletype = "N" and attcnt <= 4 And maketype = "") Or maketype = "1" Then'####################################
			'리그
			tabletype = "1"
			tableno = attcnt

			'리그 토너먼트 전환으로 추가
			If maketype = "1" then
				'토너먼트에서 변경 부전생성된것들 지우기
				gno  = "0"
				SQL = "Update sd_gameMember Set tryoutgroupno = '0' where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N' "
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = " delete from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and team = '0' and teamnm = '부전' "
				Call db.execSQLRs(SQL , null, ConStr)
			End if
			'리그 토너먼트 전환으로 추가


			'리그 소팅번호 배정 - 리그 대진표 생성 일괄 (starttype = 3 으로설정하자)
			If gno = "0" Then
				Selecttbl = "( SELECT tabletype,gubun,tryoutgroupno,startType,tryoutsortNo,RANK() OVER (Order By gameMemberidx asc) AS RowNum FROM SD_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'  ) AS A "
				SQL = "UPDATE A  SET A.tabletype = 'L', A.tryoutgroupno = '1', A.startType='3',A.tryoutsortNo = A.RowNum FROM " & Selecttbl '참고 *  대진표 한번으로 끝 우선 가입순으로 생성한다.
				Call db.execSQLRs(SQL , null, ConStr)

				'왼쪽메뉴 다시그려야하니까
				SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'  order by tryoutsortno "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				arrT = rs.GetRows()

				if maketype = "1" Then
					%>
						<script>px.goSubmit({'IDX':<%=idx%>,'GB':'<%=gbidx%>'},'gamedraw2.asp');</script>
					<%
					response.end
				end if
			End If

			'대진표 생성은 버튼으로 생성 (순서 설정한 후에 )

		Else'#############################################
			If (savetabletype = "T"  and maketype = "") or ( savetabletype = "N" and attcnt > 4 And maketype = "") Or maketype = "2" Then
				'토너먼트 16강까지만
				tabletype = "2"
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

				'리그 토너먼트 전환으로 추가
				If maketype = "2" then
					gno  = "0"
					SQL = "Update sd_gameMember Set tryoutgroupno = '0' where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N' "
					Call db.execSQLRs(SQL , null, ConStr)
				end if
				'리그 토너먼트 전환으로 추가


				'리그 소팅번호 배정 - 리그 대진표 생성 일괄 (starttype = 3 으로설정하자) 부족한 갯수만큼 temp(부전팀 생성)
				If gno = "0" Then
					'temp 부전 생성
					ifld = " GameTitleIDX,ksportsno,kno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,startType,tryoutgroupno,tryoutsortNo,tryoutstateno,tryoutresult,tryoutOrder,tryouttotalorder,roundNo,SortNo,stateno,G2firstRC,gameResult,gameOrder,gametotalorder,WriteDate,Team,TeamNm,sidonm,userClass,Sex,requestIDX,raneNo,ITgubun,rcType,rcOK1ID,rcOK2ID "

					sfld = " GameTitleIDX,ksportsno,kno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,startType,tryoutgroupno,tryoutsortNo,tryoutstateno,tryoutresult,tryoutOrder,tryouttotalorder,roundNo,SortNo,stateno,G2firstRC,gameResult,gameOrder,gametotalorder,WriteDate,'0','부전','','','','',raneNo,ITgubun,rcType,rcOK1ID,rcOK2ID "

					mselect = "select top "&CDbl(tablernd - tableno)&" "&sfld&" FROM SD_gameMember Where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N' "

					'insert
					SQL = " insert into sd_gameMember ("&ifld&") " & mselect
					Call db.execSQLRs(SQL , null, ConStr)


					'==================================================
					Selecttbl = "( SELECT tabletype,gubun,tryoutgroupno,startType,tryoutsortNo,RANK() OVER (Order By gameMemberidx asc) AS RowNum FROM SD_gameMember where  gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'  ) AS A "
					SQL = "UPDATE A  SET tabletype = 'T', A.tryoutgroupno = '1', A.startType='3',A.tryoutsortNo = A.RowNum FROM " & Selecttbl '참고 *  대진표 한번으로 끝 우선 가입순으로 생성한다.
					Call db.execSQLRs(SQL , null, ConStr)


					SQL = "Select "&fld&" from sd_gameMember where gametitleidx =  '"&tidx&"' and levelno = '"&levelno&"' and delyn = 'N'  order by tryoutsortno "
					Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
					arrT = rs.GetRows()

					'대진표 생성은 버튼으로 생성 (순서 설정한 후에 )
					if maketype = "2" Then
						%>
							<script>px.goSubmit({'IDX':<%=idx%>,'GB':'<%=gbidx%>'},'gamedraw2.asp');</script>
						<%
						response.end
					end if

				End If

			End if
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
			  <!-- #include virtual = "/pub/html/swimming/gamedrawform2.asp" -->
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
								%>
									<tr >
										<td>
										<%if showtype = "drow" then%>
										<%=sortno%>
										<%else%>
										<input id="player_<%=t_midx%>" value="<%=sortno%>" style="width:40px;text-align:center;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mx.changeNo(<%=t_midx%>,this.value,3)">
										<%end if%>
										<%'=ari+1%>
										</td><td><%=t_teamnm%></td>
									</tr>
								<%
							Next
						End if
					%>

				<%if showtype <> "drow" then%>
				<tr>
					<td colspan="2">

							<div class="col-md-6" style="width:40%;">
								  <div class="form-group">
									<select id="maketype" class="form-control" onchange="px.goSubmit({'MT':$(this).val(),'IDX':<%=idx%>,'GB':'<%=gbidx%>'},'gamedraw2.asp')">
										<option value="1" <%If tabletype = "1" then%>selected<%End if%>>리그</option>
										<option value="2" <%If tabletype = "2" then%>selected<%End if%>>토너먼트</option>
									</select>
								  </div>
							</div>

					<a href="javascript:mx.makeGameTable(<%=tidx%>,'<%=levelno%>',<%=tabletype%>,<%=tableno%>,'make')" class="btn btn-default">대진표 생성</a>
					<br><br>*부전+부전 이 있으면 생성되지 않습니다
					</td>
				</tr>
				<%end if%>

					</tbody>
				</table>
	  <%'===============%>


				  </div>
            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6" style="width:75%;">
				  <div class="form-group">



	  <%'===============%>
      <input type="hidden" onclick="mx.makeGameTable(<%=tidx%>,'<%=levelno%>',<%=tabletype%>,<%=tableno%>,'drow')" id="drowTN">
	  <div class="row" id="tournament2">
			<%
			If tabletype = "1" Then
				If gubun > 0 then
					Call drowLeage(arrT, "")
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
