<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
  'request 처리##############
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	Else
		Response.redirect "/index.asp"
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
 
 'Controller ################################################################################################

	'search
	If F1 = "" Then
		F1 = "CDA"
	End if
	If chkBlank(F2) Then

	else
		findWhere = " and "&F1&" = '"& F2 &"' "
	End if


	SQL = "select titlecode from sd_gametitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		codepre = LCase(Left(rs(0),2)) 
		If codepre = "nr" Then
			gamesinpass = true
		End if
	End if


	
	fld = " gameMemberIDX,gubun,ksportsno,PlayerIDX,userName,gbIDX,levelno,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,startType,tryoutgroupno,tryoutsortNo,tryoutstateno,G1firstRC,tryoutresult,tryoutOrder,tryouttotalorder,roundNo,SortNo,stateno,G2firstRC,gameResult,gameOrder,Team,TeamNm,sidonm,userClass,Sex,requestIDX,bestscore,bestOrder,bestCDBNM,bestIDX,bestdate,bestTitle,bestGameCode,bestArea,raneNo,ITgubun,G1korSin,G1gameSin,G1firstmemberSin,G2KorSin,G2gameSin,G2firstmemberSin,rcType  ,RCOK1ID, RCOK2ID      ,G1korSinPre,G1gameSinPre,G2KorSinPre,G2gameSinPre,G1korTie,G2korTie,G1gameTie,G2gameTie "

	tbl = " sd_gameMember "
	strwhere = " delyn = 'N' and  gametitleidx = '" & tidx & "' and (G1korSin > 0 or G1gameSin > 0 or G2korSin > 0 or G2gameSin > 0 or G1korTie > 0 or G1gameTie > 0  or G2korTie > 0 or G2gameTie > 0 )"


	SQL = "select "& fld &" from "&tbl&" where " & strwhere & findWhere

'Response.write sql
'Response.end
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If


'Call GetRowsDrow(arrr)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary collapsed-box"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title">신기록승인</h3>

          <div class="box-tools pull-right">

          </div>
        </div>

		<div class="box-body" id="gameinput_area">

        </div>

      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">

						<div class="col-md-6" style="width:30%;padding-left:20px;padding-right:0px;text-align:left;">
							  <div class="form-group">
										<input type="hidden" id="F1" value="<%=F1%>">

										<div class="input-group date">
										<div class="input-group-addon">
										  <i class="fa fa-fw fa-search"></i>
										</div>

										<select id="F2" class="form-control"  onchange="px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'TIDX':'<%=tidx%>'} ,'rcOK.asp')">
											<option value="D2" <%If F2 = "" Or F2 = "D2" then%>selected<%End if%>>경영</option>
											<option value="E2" <%If F2 = "E2" then%>selected<%End if%>>다이빙/수구</option>
											<option value="F2" <%If F2 = "F2" then%>selected<%End if%>>아티스틱스위밍</option>
										</select>

										</div>
							  </div>
						</div>

						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">

									</div>									
									

								  </div>
							</div>
							<div class="col-md-6" style="width:49%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
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
								<th>종별</th>
								<th>부</th>
								<th>세부종목</th>
								<th>이름</th>
								<th>소속</th>
								<th>시도</th>
								<th>라운드</th>
								<th>구분</th>
								<th>신기록</th>
								<th>기준기록</th>
								<th>인정여부</th>
								<th>승인여부</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">


<%


	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2)

				l_gameMemberIDX = arrR(0, ari)
				l_gubun = arrR(1, ari)
				l_ksportsno = arrR(2, ari)
				l_PlayerIDX = arrR(3, ari)
				l_userName = arrR(4, ari)
				l_gbIDX = arrR(5, ari)
				l_levelno = arrR(6, ari)
				l_CDA = arrR(7, ari)
				l_CDANM = arrR(8, ari)
				l_CDB = arrR(9, ari)
				l_CDBNM = arrR(10, ari)
				l_CDC = arrR(11, ari)
				l_CDCNM = arrR(12, ari)
				l_startType = arrR(13, ari)
				l_tryoutgroupno = arrR(14, ari)
				l_tryoutsortNo = arrR(15, ari)
				l_tryoutstateno = arrR(16, ari)
				l_G1firstRC = arrR(17, ari)
				l_tryoutresult = arrR(18, ari)
				l_tryoutOrder = arrR(19, ari)
				l_tryouttotalorder = arrR(20, ari)
				l_roundNo = arrR(21, ari)
				l_SortNo = arrR(22, ari)
				l_stateno = arrR(23, ari)
				l_G2firstRC = arrR(24, ari)
				l_gameResult = arrR(25, ari)
				l_gameOrder = arrR(26, ari)
				l_Team = arrR(27, ari)
				l_TeamNm = arrR(28, ari)
				l_sidonm = arrR(29, ari)
				l_userClass = arrR(30, ari)
				l_Sex = arrR(31, ari)
				l_requestIDX = arrR(32, ari)
				l_bestscore = arrR(33, ari)
				l_bestOrder = arrR(34, ari)
				l_bestCDBNM = arrR(35, ari)
				l_bestIDX = arrR(36, ari)
				l_bestdate = arrR(37, ari)
				l_bestTitle = arrR(38, ari)
				l_bestGameCode = arrR(39, ari)
				l_bestArea = arrR(40, ari)
				l_raneNo = arrR(41, ari)
				l_ITgubun = arrR(42, ari)

				l_G1korSin = isNullDefault(arrR(43, ari),"")
				l_G1gameSin = isNullDefault(arrR(44, ari),"")
				l_G1firstmemberSin = isNullDefault(arrR(45, ari),"")
				l_G2KorSin = isNullDefault(arrR(46, ari),"")
				l_G2gameSin = isNullDefault(arrR(47, ari),"")
				l_G2firstmemberSin = isNullDefault(arrR(48, ari),"")

				l_rcType   = arrR(49, ari) 'R08  일반 ....

				l_RCOK1ID = arrR(50, ari)
				l_RCOK2ID = arrR(51, ari)

				l_rc1 = Left(l_RCOK1ID,1)
				l_rc2 = Left(l_RCOK2ID,1)

				l_G1korSinPre = isNullDefault(arrR(52, ari),"")
				l_G1gameSinPre = isNullDefault(arrR(53, ari),"")
				l_G2KorSinPre = isNullDefault(arrR(54, ari),"")
				l_G2gameSinPre = isNullDefault(arrR(55, ari),"")

				l_G1korTie =  isNullDefault(arrR(56, ari),"")
				l_G2korTie =  isNullDefault(arrR(57, ari),"")
				l_G1GameTie = isNullDefault(arrR(58, ari),"")
				l_G2GameTie = isNullDefault(arrR(59, ari),"")

				
				singistr= ""
				singipre = ""

				Select Case l_startType
				
				Case "1" '예선부터 시작
					'예선값과 결승값비교
					'한국신기록이 있다면 끝
					If l_G1KorSin = "" Then

						If l_G2KorSin = "" Then '결승 한국신기록
							
							If l_G1gameSin = "" Then '예선 대회신기록 
								singipre = l_G2gameSinPre
								singi = l_G2gameSin 
								sinround = "결승"
								singistr = "대회신기록"	
								savefld = "2"
							Else '대회 신기록
								singipre = l_G1gameSinPre
								singi = l_G1gameSin 
								sinround = "예선"
								singistr = "대회신기록"
								savefld = "1"
							End if
						Else
							'한국신 결승
							singipre = l_G2KorSinPre
							singi = l_G2KorSin
							sinround = "결승"
							singistr = "한국신기록" 
							savefld = "2"
						End if

					Else '예선한국신기록 있고

						If l_G2KorSin = "" Then '예선 한국신기록

							singipre = l_G1KorSinPre
							singi = l_G1KorSin
							sinround = "예선"
							singistr = "한국신기록"
							savefld = "1"
						
						Else '기록이 두개면 비교

							If CDbl(l_G2KorSin) > CDbl(l_G1KorSin) Then
								'예선 한국신기록
								singipre = l_G1KorSinPre
								singi = l_G1KorSin
								sinround = "예선"
								singistr = "한국신기록"
								savefld = "1"
							Else
								'본선 한국신기록
								singipre = l_G2KorSinPre
								singi = l_G2KorSin
								sinround = "결승"
								singistr = "한국신기록"
								savefld = "2"
							End if

						End if

			
					End if
					


				Case "3" '결승부터 시작
					'한국신기록이 있다면 끝
					If l_G1KorSin <> "" Then
						singipre = l_G1korSinPre
						singi = l_G1KorSin 
						sinround = "결승"
						singistr = "한국신기록"
					Else

						If l_G1gameSin <> "" then
							singipre = l_G1gameSinPre
							singi = l_G1gameSin 
							sinround = "결승"
							singistr = "대회신기록"						
						End if
					
					End If

				End Select 




				'#############################
				

					If l_G1KorTie <>"" Then
						singi = l_G1KorTie
						If singistr = "" then
						sinround = ""
						singistr = "한국타이"
						Else
						singistr = singistr & ",한국타이"
						End if
					End If
					
					If l_G2KorTie  <>"" Then '한국
						singi = l_G2KorTie
						If singistr = "" then
						sinround = ""
						singistr = "한국타이"
						Else
						singistr = singistr & ",한국타이"
						End if
					End if
						
					If l_G1GameTie <>"" Then
						singi = l_G1gameTie 
						If singistr = "" then
						sinround = ""
						singistr = "대회타이"
						Else
						singistr = singistr & ",대회타이"
						End if
					End If

					If l_G2GameTie <>"" Then
						singi = l_G2gameTie 
						If singistr = "" then
						sinround = ""
						singistr = "대회타이"
						Else
						singistr = singistr & ",대회타이"
						End if
					End if					



				
				



	%><!-- #include virtual = "/pub/html/swimming/list.rcOK.asp" --><%


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
