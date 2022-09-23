<%
	If hasown(oJSONoutput, "TIDX") = "ok" Then  '테이블 명
		tidx = chkStrRpl(oJSONoutput.TIDX,"")
	End If

	If hasown(oJSONoutput, "GBIDX") = "ok" Then  '테이블 명
		gbidx = chkStrRpl(oJSONoutput.GBIDX,"")
	End If

	If hasown(oJSONoutput, "CDC") = "ok" Then  '자유형 100 .. 의 코드
		cdc = chkStrRpl(oJSONoutput.CDC,"")
		If Len(cdc) = 1 Then
			cdc = "0"& cdc
		End if
	End If

	If hasown(oJSONoutput, "F1") = "ok" Then  '검색필드
		F1 = chkStrRpl(oJSONoutput.F1,"")
	End If
	If hasown(oJSONoutput, "F2") = "ok" Then  '필드데이터
		F2 = chkStrRpl(oJSONoutput.F2,"")
	End If




	Set db = new clsDBHelper

	SQL = "select sexno from tblTeamGbInfo where teamgbidx = " & gbidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	


	'한국기록
	' tblrecord 필드명 참조 rcIDX,gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,gameOrder,rane,DelYN,gubun,kskey2,kskey3,kskey4,playerIDX2,UserName2,playerIDX3,UserName3,playerIDX4,UserName4,levelno "

	'개인 ,단체 (계영인경우 다 출력해보자)
	fld = " kskey,username,TeamNm,userClass,titlename,roundstr,gameResult "
	strWhere = " cdc = '"&cdc&"'  and delyn = 'N'  " & tidxwhere   
	'strWhere = " cda = '"&cda&"' and cdc = '"&cdc&"' "  & tidxwhere  ' and delyn = 'N' 

	SQL = "Select "&fld&" from tblrecord where titleCode = '201904395' and CDA = 'D2' and CDC = '"&CDC&"' and rctype='R07'  and sex = (select top 1 sexno from tblTeamGbInfo where teamgbidx = " & gbidx & ")   order by  gamedate desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	


'Response.write sql

	If Not rs.EOF Then
		arrK = rs.GetRows()
	End If
	







	'대회긱록 (각년도별로 나오게)

		'대회의 정보(기본정보)
			SQL = "Select titlecode,b.levelno,b.pteamgb as CDA,b.cd_boo as CDB,b.teamgb as CDC,b.sexno,b.teamgbnm,b.cd_boonm  from sd_gametitle as a ,tblTeamGbInfo as b  where a.delyn = 'N' and b.delyn = 'N' and gametitleidx = "&tidx&" and teamgbidx = "&gbidx&" "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			titlecode = rs(0)
			levelno = rs(1) '음 전대회에서는 초중고가 다를수도 있으므로 cdc로 구분하자.
			cda = rs(2)
			cdb = rs(3)
			cdc = rs(4)
			sex = rs(5)
			Select Case sex
			Case "1" : sexstr = "남자"
			Case "2" : sexstr = "여자"
			Case "3" : sexstr = "혼성"
			End Select 
			cdcnm = rs(6)
			cdbnm = rs(7)

		'대회구분 구하기
			If InStr(cdbnm,"유년")  Then
				gamegubun = "대회유년"
			End If
			If InStr(cdbnm,"초등")  Then			
				gamegubun = "대회초등"
			End If
			If InStr(cdbnm,"중등") Or InStr(cdbnm,"중학")  Then
				gamegubun = "대회중등"
			End If
			If InStr(cdbnm,"고등")  Then			
				gamegubun = "대회고등"
			End If
			If InStr(cdbnm,"대학")  Then			
				gamegubun = "대회대학"
			End If
			If InStr(cdbnm,"일반")  Then			
				gamegubun = "대회일반"
			End if
			'한국기록
			'일반-참가기록



	fld = " kskey,username,TeamNm,userClass,titlename,roundstr,gameResult "
	strWhere = " titlecode = '"&titlecode&"' and  levelno = '"&levelno&"'  and delyn = 'N'   "

	SQL = "Select "&fld&" from tblrecord where "&strWhere&" and "
	SQL = SQL & " gameresult in ( select min(gameresult) from tblrecord where "&strWhere&" group by kskey)  order by gamedate desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If
%>

<div class="modal-dialog modal-xl">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
      <h4 class="modal-title" id="myModalLabel">선수기록조회(신기록)</button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              
						<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
							  <div class="form-group">
							  </div>
						</div>
						<div class="row" >
							<div class="col-md-6" style="width:15%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
									<div class="input-group date">
									</div>									
								  </div>
							</div>
							<div class="col-md-6" style="width:100%;padding-right:20px;padding-right:0px;text-align:right;">

									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
									  <span class="btn btn-default" readonly>기준종목 : <%=cdcnm%></span> <span class="btn btn-default" readonly>구분 : <%=gamegubun%>/ <%=cdbnm%></span>

							</div>

						</div>			  
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>


            <div class="box-body">

			  <table id="swtable" class="table table-bordered table-hover" style="width:50%;float:left;">
                <thead class="bg-light-blue-active color-palette">
						<tr>
							<th colspan="8"><%=sexstr%> (<%=cdcnm%>)_한국기록</th>
						</tr>
						<tr>
								<th>NO</th>
								<th>선수번호</th>
								<th>이름</th>
								<th>소속</th>
								<th>학년</th>
								<th>대회명</th>
								<th>라운드</th>
								<th>기록</th>
								<!-- <th>전기록 빼자 ㅡㅡ </th> -->
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">

					
				<%
				If IsArray(arrK) Then 
					For ari = LBound(arrK, 2) To UBound(arrK, 2)


						l_kskey = arrK(0, ari)
						l_username = arrK(1, ari)
						l_TeamNm = arrK(2, ari)
						l_userClass = arrK(3, ari)
						l_titlename = arrK(4, ari)
						l_roundstr = arrK(5, ari)
						l_gameResult = arrK(6, ari)


						 %><!-- #include virtual = "/pub/html/swimming/BestGamelistKorSin.asp" --><%
					Next
				End if
				%>

					</tbody>
				</table>

			  <%'#######################################%>

			  <table id="swtable" class="table table-bordered table-hover" style="width:50%;float:left;">
				<thead class="bg-light-blue-active color-palette">
						<tr>
							<th colspan="8"><%=cdbnm%> (<%=cdcnm%>)_대회기록</th>
						</tr>
						<tr>
								<th>NO</th>
								<th>선수번호</th>
								<th>이름</th>
								<th>소속</th>
								<th>학년</th>
								<th>대회명</th>
								<th>라운드</th>
								<th>기록</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">

			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)


						g_kskey = arrR(0, ari)
						g_username = arrR(1, ari)
						g_TeamNm = arrR(2, ari)
						g_userClass = arrR(3, ari)
						g_titlename = arrR(4, ari)
						g_roundstr = arrR(5, ari)
						g_gameResult = arrR(6, ari)

					 %><!-- #include virtual = "/pub/html/swimming/BestGamelistGameSin.asp" --><%
				Next
			End if
			%>
					</tbody>
				</table>



            </div>
          </div>
        </div>

	  </div>
	<%'#######################################################%>





      </div>





    </div>




  </div>
</div>

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
