	<%
 'Controller ################################################################################################
	Set db = new clsDBHelper

	'소문자키 대문자 값
	Set errdic = CreateObject("Scripting.Dictionary")
	errdic.add "e","A"
	errdic.add "r","B"
	errdic.add "w","C"
	errdic.add "d","D"




	'등록된 최소년도
	SQL = "Select min(GameYear) from sd_gameTitle where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End If
	rs.close

  	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' "
		findWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' "

		nowgameyear = year(date)
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("GameYear","gametitleidx","gbidx")
			F2_0 = F2(0)
			F2_1 = F2(1)
			F2_2 = F2(2)

			tidx = F2_1
			find_gbidx = F2_2
			strWhere = " DelYN = 'N' and "&fieldarr(0)&" = '" & F2_0 &"' and "&fieldarr(1)&" = '"& F2_1 &"' "
			findWhere = " DelYN = 'N'  and GameYear = '"&F2_0&"' "

			nowgameyear = F2_0
		Else
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "

			If LCase(F1) = "gameyear" Then
				nowgameyear = F2
			End if
		End if
	End if

	'년도별 대회명검색
	fieldstr =  "GameTitleIDX,GameTitleName,GameS,GameE,GameYear,GameArea,kgame, titlecode  "
	SQL = "Select  "&fieldstr&" from sd_gameTitle where " & findWhere & " order by GameS desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		arrPub = rss.GetRows()

		t_titlecode = arrPub(7,0)
		t_gametitlename = arrPub(1,0)

		If tidx = "" Then
			If IsArray(arrPub)  Then
				tidx = arrPub(0, 0)
				kgame = arrPub(6, 0)
			End if

		End if
	End If

	If tidx = "" Then
		Response.write "대회가 존재하지 않습니다. 대회를 생성해 주십시오."
		Response.end
	End if

	'Response.write "#######################"&kgame
	
	'년도별 대회별 각경기 리스트
	strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
	strfieldA = " a.RGameLevelidx,a.GbIDX " ',a.GameTitleIDX,a.GbIDX,b.useyear,b.levelno
	strfieldB = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,b.TeamGbNm,isnull(a.judgecnt,0), a.judgemaxpt, judgesignYN,judgeshowYN    ,b.ridingclass , b.ridingclasshelp    ,judgeB,judgeE,judgeM,judgeC,judgeH,  teamgb,judgecnt,bestsc     ,a.maxChk,a.minChk , a.gameday2 "
	strFieldName2 = strfieldA &  "," & strfieldB
	strSort2 = "  ORDER BY gameno asc"
	strWhere2 = " a.GameTitleIDX = '"&tidx&"' and a.DelYN = 'N' and b.DelYN = 'N' "

	SQL = "Select "&strFieldName2&" ,PTeamGbNm    from "&strTableName2&" where " & strWhere2 & strSort2
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Call rsdrow(rs)
	'Response.end
	'Response.write f_gbidx

	If Not rs.EOF Then
		arrNo = rs.GetRows()
		If find_gbidx = "" Then
			If IsArray(arrNo)  Then
				find_gbidx = arrNo(1, 0)
				'Response.write find_gbidx &"ddd"
			End if
		End if
	End If
	rs.close

	If IsArray(arrNo)  Then
		For ar = LBound(arrNo, 2) To UBound(arrNo, 2)
			'f_ridx = arrNo(0,ar) 'tblRGameLevel.RGameLevelidx
			f_gbidx = arrNo(1, ar)


			If F2_2 = "" Then
					select_f_ridx = arrNo(0,ar)
					find_gbidx = arrNo(1, ar)
					select_f_title =  arrNo(2, ar)
					select_f_date = arrNo(3,ar)
					select_f_stime = arrNo(4,ar)
					select_f_etime = arrNo(5,ar)
					Select_f_teamgbnm = arrNo(6,ar)
					select_f_judgecnt = arrNo(7, ar)
					select_f_judgemaxpt = arrNo(8, ar)
					select_f_judgesignYN = arrNo(9, ar)
					select_f_judgeshowYN = arrNo(10, ar)
					select_f_class = arrNo(11, ar)
					select_f_classhelp = arrNo(12, ar)

					select_f_B = arrNo(13, ar)
					select_f_E = arrNo(14, ar)
					select_f_M = arrNo(15, ar)
					select_f_C = arrNo(16, ar)
					select_f_H = arrNo(17, ar)

					select_f_teamgb = arrNO(18,ar)
					select_f_boocnt = arrNo(19,ar)
					select_f_bestsc = arrNo(20,ar)

					select_f_MAX =  arrNo(21,ar) '최고점제외
					select_f_MIN =  arrNo(22,ar)

					select_f_date2 = arrNo(23,ar)
					select_f_PTeamGbNm = arrNo(24,ar) '개인 단체 구분

					Exit for
			else
				'If f_gbidx = "" Or CStr(f_gbidx) <> CStr(f_pregbidx) Then
					If CStr(f_gbidx) = CStr(F2_2) Then
						select_f_ridx = arrNo(0,ar)
						find_gbidx = arrNo(1, ar)

'sss =  f_ridx & "_" & find_gbidx

						select_f_title =  arrNo(2, ar)
						select_f_date = arrNo(3,ar)
						select_f_stime = arrNo(4,ar)
						select_f_etime = arrNo(5,ar)
						Select_f_teamgbnm = arrNo(6,ar)
						select_f_judgecnt = arrNo(7, ar)
						select_f_judgemaxpt = arrNo(8, ar)
						select_f_judgesignYN = arrNo(9, ar)
						select_f_judgeshowYN = arrNo(10, ar)

						select_f_class = arrNo(11, ar)
						select_f_classhelp = arrNo(12, ar)

						select_f_B = arrNo(13, ar)
						select_f_E = arrNo(14, ar)
						select_f_M = arrNo(15, ar)
						select_f_C = arrNo(16, ar)
						select_f_H = arrNo(17, ar)

						select_f_teamgb = arrNO(18,ar)
						select_f_boocnt = arrNo(19,ar)
						select_f_bestsc = arrNo(20,ar)

						select_f_MAX =  arrNo(21,ar)
						select_f_MIN =  arrNo(22,ar)

						select_f_date2 = arrNo(23,ar)
						select_f_PTeamGbNm = arrNo(24,ar) '개인 단체 구분

						Exit for
					End If
				'End If
			End if
		f_pregbidx = f_gbidx
		Next
	End if

'장애물 A타입이 아닌 모든경우 기본값
maxrndno = 1


'sss =  f_ridx & "_" & find_gbidx & "A" & F2_2 &  "***"


    ' ===============================================================================================
    ' sub function
    ' ===============================================================================================

    ' ===============================================================================================
    ' classHelp를 입력받아 orderUpdate의 OrderType을 반환한다.
	'fnc >> GetOrderType >> fn_riding.asp

    sel_orderType = GetOrderType(select_f_classhelp, select_f_teamgb, select_f_class)

	If select_f_teamgb = "20103" Then '복합마술(마장마술)
		sousoojerm = 1
	Else
		sousoojerm = 3
	End if


	'마자막 사용된 상장번호
	SQL = "select max(crapeNo) from sd_gameMember where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If isnull(rs(0)) = True Then
		lastcrapeNo = year(date) & "0000"
	
	Else
		lastcrapeNo = rs(0)
	End if

%>
<!-- ###############<%=sel_orderType%><%=select_f_teamgb%>@@ -->


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대회결과관리 > 상장</h1></div>

  <%'If CDbl(ADGRADE) > 500 then%>


	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
<%'		<!-- #include virtual = "/pub/html/riding/resultFindform.asp" -->%>
	</div>
	<!-- e: 정보 검색 -->
	<div class="info_serch" id="gameread_area">
		<div class="form-horizontal" style="display: inline-block; width: 93%;">
			<div class="form-group">

				<div class="col-sm-12">
					<label class="control-label col-sm-1">상장번호</label>
					<div class="m_cert__input col-sm-2" id="c_info0"></div>

					<label class="control-label col-sm-1">상장종류</label>
					<div class="m_cert__input col-sm-2" id="c_info1"></div>
		
					<label class="control-label col-sm-1">종목</label>
					<div class="m_cert__input col-sm-2" id="c_info2"></div>
		
					<label class="control-label col-sm-1">Class</label>
					<div class="m_cert__input col-sm-2" id="c_info3"></div>
				</div>
				
				<div class="col-sm-12">
					<label class="control-label col-sm-1">종별</label>
					<div class="m_cert__input col-sm-2" id="c_info4"></div>

					<label class="control-label col-sm-1">순위</label>
					<div class="m_cert__input col-sm-2" id="c_info5"></div>
		
					<label class="control-label col-sm-1">수상자</label>
					<div class="m_cert__input col-sm-2" id="c_info6"></div>
		
					<label class="control-label col-sm-1">소속팀</label>
					<div class="m_cert__input col-sm-2" id="c_info7"></div>
				</div>
				<div class="col-sm-12">
					<label class="control-label col-sm-1">마명</label>
					<div class="m_cert__input col-sm-2" id="c_info8"></div>

					<label class="control-label col-sm-1">성적</label>
					<div class="m_cert__input col-sm-2" id="c_info9"></div>
		
					<label class="control-label col-sm-1">수상일자</label>
					<div class="m_cert__input col-sm-2" id="c_info10"></div>
		
					<label class="control-label col-sm-1">협회장</label>
					<div class="col-sm-2">
						<input id="cert_president" type="text" value="" class="form-control" onblur="px.saveText(this)"/>
					</div>
				</div>

				<div class="col-sm-12">
					<label class="control-label col-sm-1">상장내용</label>
					<div class="m_cert__input col-sm-11">
						<textarea id="cert_content" type="text" class="form-control" rows="7" onblur="px.saveText(this)"></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>





<script src="/pub/js/excel/xlsx.full.min.js"></script>
<script src="/pub/js/excel/FileSaver.min.js"></script>


<script>
//공통
// 참고 출처 : https://redstapler.co/sheetjs-tutorial-create-xlsx/
function s2ab(s) { 
    var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
    var view = new Uint8Array(buf);  //create uint8array as viewer
    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
    return buf;    
}
function exportExcel( xlsname, sheetname ){ 
	excelHandler.tablename = xlsname;
	excelHandler.sheetname = sheetname;

    // step 1. workbook 생성
    var wb = XLSX.utils.book_new();

    // step 2. 시트 만들기 
    var newWorksheet = excelHandler.getWorksheet();

	//간격조정때 사용
//      var wsrows =  [            
//            {wch: 10}, // A Cell Width
//            {wch: 50}, // B Cell Width
//         ];
//      newWorksheet['!cols'] = wsrows;


    // step 3. workbook에 새로만든 워크시트에 이름을 주고 붙인다.  
    XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());

    // step 4. 엑셀 파일 만들기 
    var wbout = XLSX.write(wb, {bookType:'xlsx',  type: 'binary'});

    // step 5. 엑셀 파일 내보내기 
    saveAs(new Blob([s2ab(wbout)],{type:"application/octet-stream"}), excelHandler.getExcelFileName());
}
</script>


<script>
var excelHandler = {
		tablename : 'gamename',
		sheetname : 'sheetname',

        getExcelFileName : function(){
            return this.tablename+ '.xlsx';
        },
        getSheetName : function(){
            return this.sheetname;
        },
        getExcelData : function(){
            return document.getElementById('tblriding'); 
        },
        getWorksheet : function(){
            return XLSX.utils.table_to_sheet(this.getExcelData());
        }
}
</script>





  <div class="table-responsive" id="printdiv">


		<div class="btn-toggle" style="margin-top:10px">
			<span><input id="cert_input_num" type="text" value=""  onblur="px.saveText(this)"  maxlength="8" placeholder="<%=year(date)%>0001..." onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"></span>
			<a href="javascript:mx.makeCrapeNo($('#cert_input_num').val())" class="btn btn-success">상장번호부여</a>
			&nbsp; 마자막사용된 번호:<%=lastcrapeNo%>

			<div class="btn-group flr" style="width:200px;">
				
				<a href="javascript:exportExcel('<%=t_gametitlename%>','<%=select_f_date%>')" title="액셀 다운로드" class="btn btn-primary flr"><span class="glyphicon glyphicon-save-file"></span>&nbsp;엑셀</a>&nbsp;

				<a href="javascript:mx.makeCrapePrint()" title="선택항목 인쇄" class="btn btn-primary">선택항목 인쇄</a>
		</div>


		<table  cellspacing="0" cellpadding="0" class="table table-hover" id="tblriding">
			<thead>

				<tr>
						<th><span style="display:none;">번호</span><input type="checkbox" id="checkAll"  onclick="px.checkAll($(this))"></th>
						<th>구분</th>
						<th>상장번호</th>
						<th>종목</th>
						<th>대회명</th>
						<th>대회코드</th>
						<th>선수명</th>
						<th>마명</th>
						<th>소속</th>
						<th>선수등록번호</th>
						<th>체육인번호</th>
						<th>Class</th>
						<th>Class안내</th>
						<th>라운드</th>

						<th>부별</th>
						<th>성적</th>

						<th>부별순위</th>
						<th>전체순위</th>
						<th>수상일자</th>
				</tr>
			</thead>
			<tbody id="listcontents">





				<%
				'#############################################
				If select_f_teamgb <> "20103" then
					If sel_orderType = "MM" Then
					%><%'<!-- #include virtual = "/pub/html/riding/crapelist.asp" -->%><%
					
					Else '장애물
						SQL = "Select max(round) from SD_gameMember where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '" &find_gbidx & "'"
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						If isNull(rs(0)) = False  Then
							maxrndno = rs(0)
						End if	
					
						If kgame = "Y" then
						%><%'<!-- #include virtual = "/pub/html/riding/crapelist_JK.asp" -->%><%
						else
						%><%'<!-- #include virtual = "/pub/html/riding/crapelist_J.asp" -->%><%
						End if
					End If

				Else


					rt_gbidx = find_gbidx
					%><%'<!-- #include virtual = "/pub/html/riding/crapelist_BM.asp" -->%><%
				End if
				%>






			</tbody>
	  </table>
	  <br><br>
  </div>

</div>
<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"></div>











