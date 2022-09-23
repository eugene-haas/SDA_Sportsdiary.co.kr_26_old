<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<% 'Storage 변수 영역 
  Dim REQ : REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
%>

<% 'Reuqest 데이터 영역
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(Request("tGameTitleIdx")))
  crypt_ReqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
  LSQL = "SELECT GameTitleName"
  LSQL = LSQL & " FROM tblGameTitle "
  LSQL = LSQL & " where GameTitleIDX = '" & reqGameTitleIdx & "'"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRs("GameTitleName")
      LRs.MoveNext
    Loop
  End If
%>
<script type="text/javascript" src="../../js/GameTitleMenu/scoreTotal_result_popup.js"></script>
<script>
  var locationStr;
</script>
<style>
	#left-navi{display:none;}
	#header{display:none;}
</style>
<!-- S: content -->
<input type="hidden" id="selGameTitleIdx" name="selGameTitleIdx" value="<%=crypt_ReqGameTitleIdx%>">
<div class="ranking_result_popup">
	<h2 class="top_title">대회명 : [<%=tGameTitleName%>] - 예선 최종 순위 결과</h2>
	<div class="search_box" id="divGameLevelMenu">
    <%
  
        MAXRanking = 0
        LSQL = " EXEC tblGameTotalRanking_Searched_STR '" & reqGameTitleIdx &"', '','','1'" 
        Set LRs = DBCon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                MAXRanking = LRs("MAXRanking")
              LRs.MoveNext
            Loop
        End If
      
      %>
    <select id="selRanking" name="selRanking"  onChange='OnGameLevelChanged()'>
      <option value="">::랭킹 선택::</option>
      <% For i = 1 To cdbl(MAXRanking) %>
           <option value="<%=i%>"><%=i%></option>
      <% Next %>
    </select>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
    <a href='javascript:OnResultSearch()'>조회</a>
    <!--<a href='javascript:OnRankingResultExcelClick(<%=strjson%>);'>출력</a>-->
	<!-- s: 검색 -->
	</div>
	<!-- e: 검색 -->
	<!-- s: 리스트 table -->
	<div class="list_box">
    <span id="LoadSpan" name="LoadSpan"></span>
    <div id="DP_TeamGbResult">
      <table cellspacing="0" cellpadding="0">
        <tr>
          <th>순위</th>
          <th>팀</th>
          <th>점수</th>
        </tr>
        <tr>
          <td></td>
          <td></td>
          <td></td>
        </tr>
      </table>
       <%'Response.Write "LSQL"& LSQL & "<BR/>"%>
    </div>
	</div>
	<!-- e: 리스트 table -->
	<script>
		function popupOpen(addrs, w, h){
			if (w === undefined)
				w = 1280;
			if (h === undefined)
				h = 747;
			var popWidth = w; // 팝업창 넓이
			var popHeight = h; // 팝업창 높이
			var winWidth = document.body.clientWidth; // 현재창 넓이
			var winHeight = document.body.clientHeight; // 현재창 높이
			var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
			var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
			var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
			var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데


			var popUrl = addrs; //팝업창에 출력될 페이지 URL
			var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
			window.open(popUrl,"",popOption);
		}
	</script>
</div>
<!-- E: content -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>