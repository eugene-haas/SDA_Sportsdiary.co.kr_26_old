<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	Set db = new clsDBHelper

	'등록된 최소년도
	SQL = "Select min(GameYear) from sd_TennisTitle where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End if
	
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
	fieldstr =  "GameTitleIDX,GameTitleName,GameS,GameE,GameYear,GameArea,kgame  "
	SQL = "Select  "&fieldstr&" from sd_TennisTitle where " & findWhere & " order by GameS desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		arrPub = rss.GetRows()
		If kgame = "" then
			If IsArray(arrPub)  Then
				kgame = arrPub(6,0) '체전여부 
			End if
		End if

		If tidx = "" Then
			If IsArray(arrPub)  Then
				tidx = arrPub(0, 0)
			End if
		End if
	End If

	'입력될 데이터
	SQL = "Select idx,title,fieldvalue from SD_Pub.dbo.tblinsertData where idx > 17 and delyn = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rs.EOF Then
		arrNo = rs.GetRows()
	End If
%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대회인원 밀어넣기</h1></div>


	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/makerequestform.asp" -->
	</div>
	<!-- e: 정보 검색 -->
    <hr />


  <div class="table-responsive">
  <%
    Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
	Response.write "<thead><tr><th>번호</th><th>대회명</th><th>세부종목</th><th>종별</th><th>선수명</th><th>마명</th><th>팀명칭</th></tr></thead>" '
    Response.write "<tbody id=""listcontents"">"
'    Response.write " <tr class=""gametitle"" ></tr>"
	%><%'<!-- #include virtual = "/pub/html/riding/sclist.asp" -->%><%
    Response.write "</tbody>"
    Response.write "</table><br><br><br><br>"
  %>
  </div>





</div>

