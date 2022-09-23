<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
	<%
		GametitleIDX = fInject(Request("GametitleIDX"))
		GameDay      = fInject(Request("GameDay"))
		MatCnt       = fInject(Request("MatCnt"))
		Modtype      = fInject(Request("Modtype"))
		Opening      = fInject(Request("Opening"))
		ModCnt       = fInject(Request("ModCnt"))

		'해당일자의 준결결승경기를 제외한 경기 보여짐
		LSQL = "SELECT IDX"
		LSQL = LSQL&" ,GameTitleIDX"
		LSQL = LSQL&" ,GameTitleName"
		LSQL = LSQL&" ,RGameLevelIDX"
		LSQL = LSQL&" ,SportsGb"
		LSQL = LSQL&" ,Level"
		LSQL = LSQL&" ,LevelNm"
		LSQL = LSQL&" ,TeamGb"
		LSQL = LSQL&" ,TeamGbNm"
		LSQL = LSQL&" ,Sex"
		LSQL = LSQL&" ,TotGameCnt"
		LSQL = LSQL&" ,GameCnt"
		LSQL = LSQL&" ,GameDay"
		LSQL = LSQL&" ,GameType"
		LSQL = LSQL&" ,GameTypeNm"
		LSQL = LSQL&" ,ISNULL(MatNum,'0') AS MatNum"
		LSQL = LSQL&" FROM Sportsdiary.dbo.tblDayList_Temp "
		LSQL = LSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
		LSQL = LSQL&" AND Replace(GameDay,'-','')='"&GameDay&"'"
		LSQL = LSQL&" AND GameCnt > 0 "
		LSQL = LSQL&" ORDER BY GameCnt DESC "
		'Response.Write LSQL
		Set LRs = Dbcon.Execute(LSQL)
	%>
	<script type="text/javascript">
	function chk_mat(gametitleidx,objidx,matidx,gameday){
		var strAjaxUrl = "/Manager/Ajax/DayList_Step2_Update.asp";
		$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',			
				data: { 
					GameTitleIDX : gametitleidx,
					IDX          : objidx ,
					MatNum       : matidx,
					GameDay      : gameday
				},		
				success: function(retDATA) {

					if(retDATA){
						document.getElementById("cnt").innerHTML = retDATA
					}
				}, error: function(xhr, status, error){						
					if(error!=""){
						alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
						return;
					}
				}
			});		
	}

function chk_frm(){
	var f = document.frm;
	if(confirm("다음단계를 진행하시겠습니까?")){
		f.action="DayListWres_Step3.asp"
		f.submit();	
	}
}
	</script>
	<body onLoad="chk_mat('<%=GametitleIDX%>','','','<%=GameDay%>');">
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>대회관리</strong> &gt; 대회순번
			</div>
			<form name="frm" method="post">
				<input type="hidden" name="GameTitleIDX" value="<%=GameTitleIDX%>">
				<input type="hidden" name="GameDay" value="<%=GameDay%>">
				<input type="hidden" name="MatCnt" value="<%=MatCnt%>">
				<input type="hidden" name="Opening" value="<%=Opening%>">
				<!--초기화처리-->
				<input type="hidden" name="ResetYN" id="ResetYN" value="Y">
			</form>
			<!-- S: table-list-wrap -->
			<div class="stit">2단계</div>
			<div class="table-list-wrap">
				<table class="table-list">
				<colgroup>
					<col width="20%" />
					<col width="16%" />
					<col width="16%" />
					<col width="16%" />
					<col width="16%" />
					<col width="16%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">종별</th>
						<th scope="col">체급</th>
						<th scope="col">총경기수</th>
						<th scope="col">경기형태</th>
						<th scope="col">8강까지경기수</th>
						<th scope="col">매트번호</th>
					</tr>
				</thead>
				<tbody>
				<%
					If Not (LRs.Eof Or LRs.Bof) Then 
						i = 1
						Do Until LRs.Eof 
				%>
				<tr>
					<td><%=LRs("TeamGbNm")%></td>
					<td><%=LRs("LevelNm")%></td>
					<td><%=LRs("TotGameCnt")%></td>
					<td><%=LRs("GameTypeNm")%></td>
					<td><%=LRs("GameCnt")%></td>
					<td>
						<select name="sel_mat" id="sel_mat" onChange="chk_mat('<%=LRs("GameTitleIDX")%>','<%=LRs("IDX")%>',this.value,'<%=GameDay%>')">
							<option value="">==매트선택==</option>
							<%
								For k=1 To MatCnt
							%>
							<option value="<%=k%>" <%If CStr(k) = CStr(LRs("MatNum")) Then%>selected<%End If%>><%=k%>매트</option>
							<%
								Next					
							%>
						</select>
					</td>
				</tr>
				<%
							i = i + 1
							LRs.MoveNext
						Loop 
					End If 
				%>
				</tbody>
			</table>
		</div>
		<!-- E: table-list-wrap -->
		<!-- S: total -->
		<table class="total">
			<colgroup>
				<%
					For k = 1 To MatCnt
				%>
				<col width="20%" />
				<%
					Next
				%>
				<col width="20%" />
			</colgroup>
			<tbody>
				<tr id="cnt">
				</tr>
			</tbody>
		</table>
		<!-- E: total -->
		<!-- S: BTN -->
		<div class="btn-center-list">
			<!--//<input type="button" value="다음" onclick="chk_frm();">-->
			<a href="#" onClick="chk_frm();" class="btn">다음</a>
		</div>
		<!-- E: BTN -->
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->