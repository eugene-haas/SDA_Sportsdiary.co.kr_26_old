<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<style>


	.backslash {
		background: url('..\images\backslash.png');
		background-size: 100% 100%;
		text-align: left;
	}
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

</style

<%
  REQ = "{}"

  Set oJSONoutput = JSON.Parse(REQ)

	Dim tGameTitleIDX
	Dim tStadiumIDX
	Dim DEC_GameDay

	tGameTitleIDX = fInject(Request("GameTitleIdx"))
	tStadiumIDX  = fInject(Request("StadiumIDX"))
	tGameDay = fInject(Request("GameDay"))
	If ISNull(tGameTitleIDX) Or tGameTitleIDX = "" Then
		GameTitleIDX = ""
		DEC_GameTitleIDX = ""
	Else
		GameTitleIDX = tGameTitleIDX
		DEC_GameTitleIDX = crypt.DecryptStringENC(tGameTitleIDX)
	End If

	If ISNull(tStadiumIDX) Or tStadiumIDX = "" Then
		StadiumIDX = ""
		DEC_StadiumIDX = ""
	Else
		StadiumIDX = tStadiumIDX
		DEC_StadiumIDX = crypt.DecryptStringENC(tStadiumIDX)
	End If

	If ISNull(tGameDay) Or tGameDay = "" Then
		GameDay = ""
		DEC_GameDay= ""
	Else
		GameDay = tGameDay
		DEC_GameDay = tGameDay
	End If
%>

<html>
  <head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta charset="utf-8">
  <title>경기 진행순서</title>
  <link href="/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css">
  <script src="/js/jquery-1.12.2.min.js"></script>
  <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <link href="/css/lib/jquery-ui.min.css" rel="stylesheet" media="screen">
  <script src="/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <link rel="stylesheet" href="/css/admin/admin.d.style.css">
  <script src="../../js/CommonAjax.js"></script>
  <script src="../../js/GameNumber/SettingGameOrder.js"></script>
  <script src="../../dev/dist/Common_Js.js"></script>
  <script type="text/javascript" src="../../js/library/jquery-ui.min.js"></script>
</head>

<body>
  <!-- S: setup-header -->
  <div class="setup-header">
    <h3 id="myModalLabel"><span class="tit">경기 진행순서 설정</span> <span class="txt"></span></h3>
  </div>
  <!-- E: setup-header -->
  
  <!-- S: setup-body -->
  <div class="Game_operation  game-number" >
    <!-- S: top-ctr -->
    <div class="search_box" >
		<%
			Admin_Authority = crypt.DecryptStringENC(Request.Cookies(global_HP)("Authority"))
      Admin_UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))
      IF (Admin_Authority <> "O") Then
        Dim tblGameTitleCnt :tblGameTitleCnt = 0
        LSQL = " SELECT GameTitleIDX, GameTitleName"
        LSQL = LSQL & " FROM tblGameTitle "
        LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = '" & DEC_GameTitleIDX & "'" 
        Set LRs = Dbcon.Execute(LSQL)

        IF Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            tblGameTitleCnt = tblGameTitleCnt + 1
            tGameTitleName = LRs("GameTitleName")
						crypt_GameTitleIDX =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
            LRs.MoveNext()
          Loop
        End If   
        LRs.Close         

        IF cdbl(tblGameTitleCnt) = 0 Then
          LSQL = " SELECT Top 1 GameTitleIDX, GameTitleName"
          LSQL = LSQL & " FROM tblGameTitle "
          LSQL = LSQL & " WHERE DelYN = 'N' " 
          LSQL = LSQL & " Order By WriteDate desc " 

          Set LRs = Dbcon.Execute(LSQL)

          IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
              crypt_GameTitleIDX =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
							DEC_GameTitleIDX = LRs("GameTitleIDX")
              tGameTitleName = LRs("GameTitleName")
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         
        End IF
		%>
		<input type="text" name="strGameTtitle" id="strGameTtitle" placeholder="검색할 대회명을 입력해 주세요." value="<%=tGameTitleName%>" style="width:750px">
    <input type="hidden" name="selGameTitleIdx" id="selGameTitleIdx" value="<%=crypt_GameTitleIDX%>">
		
		<% Else%>
     <select id="selGameTitleIdx" name="selGameTitleIdx"  onchange="OnGameTitleChanged(this.value)">
        <option value="">::대회 선택::</option>
          <% 
              Dim GameTitleIdxCnt : GameTitleIdxCnt = 0
              LSQL = " SELECT a.GameTitleIDX, a.GameTitleName"
              LSQL = LSQL & " FROM tblGameTitle a "
              LSQL = LSQL & " INNER JOIN tblAdminGameTitle d on d.AdminID = '" & Admin_UserID &"' And a.GameTitleIDX = d.GameTitleIDX " 
              LSQL = LSQL & " WHERE a.DelYN = 'N'" 
              Set LRs = Dbcon.Execute(LSQL)

              IF Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                    GameTitleIdxCnt = GameTitleIdxCnt  + 1
                    tGameTitleIdx = LRs("GameTitleIDX")
                    crypt_tGameTitleIdx = crypt.EncryptStringENC(tGameTitleIdx)
                    tGameTitleName = LRs("GameTitleName")
              
                    IF(Len(DEC_GameTitleIDX) = 0 ) Then
                      IF (GameTitleIdxCnt = 1) Then
                        DEC_GameTitleIDX = tGameTitleIdx
                        crypt_GameTitleIDX = crypt.EncryptStringENC(DEC_GameTitleIDX)
                      End IF
                    End IF

                    If CDBL(DEC_GameTitleIDX) = CDBL(tGameTitleIdx)Then 
                      %>
                        <option value="<%=crypt_tGameTitleIdx%>" selected> <%=tGameTitleName%></option>
                      <% Else %>
                        <option value="<%=crypt_tGameTitleIdx%>" > <%=tGameTitleName%></option>
                      <%
                    End IF
                  LRs.MoveNext()
                Loop
              End If   
              LRs.Close         
          %>
      </select>
    <% End IF %>
		<a href="javascript:OnGameTitleSearch();" class="gray_btn">검색</a>
		</div>
    <!-- E: top-ctr -->
  </div>

	<!-- S: SettingGameOrder -->
	<div class="setting_game_order">
		<!-- S:table-1 -->
		<div class="table-1" id="divGameLevelList" name="divGameLevelList">
			<!-- S: top-search -->
			<div class="top-search">
				<input type="text" id="txtGameLevelName" name="txtGameLevelName" placeholder="종별을 검색해주세요." >
				
				<a  href="javascript:OnGameLevelSearch();" >조회</a>
			</div>
			<!-- E: top-search -->
			<table cellspacing="0" cellpadding="0"  id="tableGameNumberLevel">
				<tr>
					<th>종별</th>
					<th>미지정</th>
				</tr>
				<tbody>
					<tr>
						<td colspan=2>	
							조회 결과가 존재 하지 않습니다.
						</td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" id="selGameLevel" name="selGameLevel" value="">
		</div>
		<!--  E: table-1 -->
		<!-- S:table-2 -->
		<div class="table-2" id="divGameTourney" name="divGameTourney">
			<!-- S: top-search -->
			<div class="top-search">
				<input type="text" id="txtGameTourenyName" name="txtGameTourenyName" placeholder="종별을 검색해주세요.">
				<a href="javascript:OnGameTourenySearch();" >조회</a>
			</div>
			<!-- E: top-search -->
			<table cellspacing="0" cellpadding="0" id="tableToureny" name="tableToureny">
				<thead>
					<tr>
						<th>경기</th>
						<th>vs</th>
						<th>경기번호</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan=3>	
							조회 결과가 존재 하지 않습니다.
						</td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" id="hiddenGameTourney" name="hiddenGameTourney" />
		</div>
		<!--  E: table-2 -->
		<!-- S:table-3 -->
		<div class="table-3">
			<!-- S: top-search -->
			<div class="top-search">
				<span class="s-name">경기진행순서</span>
				<%'Response.Write "LSQL" & LSQL 	& "<BR/>" %>
				
				<div id="divStadiumGameDay" name="divStadiumGameDay">

					<select id="selStadiumIDX" name="selStadiumIDX" onchange="OnStadiumChanged();">
						<option value="">::경기장소 선택::</option>
						<%
							LSQL = " SELECT StadiumIDX ,GameTitleIDX ,StadiumName ,StadiumCourt ,StadiumTime ,StadiumAddr ,StadiumAddrDtl "
							LSQL = LSQL & " FROM tblStadium A "
							LSQL = LSQL & " Where A.DelYN = 'N'"
							LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
							
							Set LRs = Dbcon.Execute(LSQL)
							If Not (LRs.Eof Or LRs.Bof) Then
								Do Until LRs.Eof
								r_StadiumIDX = LRs("StadiumIDX")
								crypt_StadiumIDX = crypt.EncryptStringENC(r_StadiumIDX)
								r_StadiumName = LRs("StadiumName")
								r_StadiumCourt = LRs("StadiumCourt")

								
								if DEC_StadiumIDX <> "" Then
								%>
								<option value="<%=crypt_StadiumIDX%>" <%If cdbl(DEC_StadiumIDX) = cdbl(r_StadiumIDX) Then%> selected <%End If%> ><%=r_StadiumName%><%=r_StadiumIDX%> ( 코트 : <%=r_StadiumCourt%>)</option>
								<% Else %>
								<option value="<%=crypt_StadiumIDX%>" ><%=r_StadiumName%><%=r_StadiumIDX%> ( 코트 : <%=r_StadiumCourt%>)</option>
								<% End IF %>
								<%
									LRs.MoveNext
								Loop
							End If            

							LRs.Close    
						%>
					</select>
					
					<select id="selGameDay" name="selGameDay"  onchange="OnStadiumChanged();">
						<option value="" <%If GameDay = "" Then%>selected<%End If%>>::경기일자 선택::</option>
						<%
							
							LSQL = " SELECT GameDay"
							LSQL = LSQL & " FROM "
							LSQL = LSQL & " ("
							LSQL = LSQL & " SELECT A.GameDay"
							LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
							LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
							LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
							LSQL = LSQL & " WHERE A.DelYN = 'N'"
							LSQL = LSQL & " AND B.DelYN = 'N'"
							LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
							IF DEC_StadiumIDX <> "" Then
								LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
							End IF
							LSQL = LSQL & " AND A.GameDay IS NOT NULL"
							LSQL = LSQL & " "
							LSQL = LSQL & " UNION ALL"
							LSQL = LSQL & " "
							LSQL = LSQL & " SELECT A.GameDay"
							LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
							LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
							LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
							LSQL = LSQL & " WHERE A.DelYN = 'N'"
							LSQL = LSQL & " AND B.DelYN = 'N'"
							IF DEC_StadiumIDX <> "" Then
								LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
							End IF
							LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
							LSQL = LSQL & " AND A.GameDay IS NOT NULL"
							LSQL = LSQL & " ) AS AA"
							LSQL = LSQL & " WHERE AA.GameDay <> ''"
							LSQL = LSQL & " GROUP BY AA.GameDay"
							'Response.Write "LSQL" & LSQL & "<BR/>"
							Set LRs = Dbcon.Execute(LSQL)

							IF DEC_StadiumIDX <> "" Then
								If Not (LRs.Eof Or LRs.Bof) Then

									Do Until LRs.Eof
								%>
										<option value="<%=LRs("GameDay") %>" <%If DEC_GameDay= LRs("GameDay") Then%>selected<%End If%>><%=LRs("GameDay") %></option>
								<%
										LRs.MoveNext
									Loop

								End If
							End IF

							LRs.Close
						%>
					</select>
				</div>
				
				<a href="javascript:OnGameScheduleSearch();">조회</a>
				<a href= "#" class="blue-btn all-view">펼쳐보기</a>
				<a href="javascript:PrintSchedule();" class="blue-btn">출력</a>
				<div class="r-con">
					<input type="text" class="date_ipt" id="initDatePicker" name="initDatePicker">
					<a href="javascript:initGameSchedule();">생성</a>
					<!--<a href="javascript:autoGameSchedule();" class="red-btn">자동진행순서</a>-->
				</div>
			</div>
			<!-- E: top-search -->
			<div id="divGameSchedule" name="divGameSchedule">
				<table cellspacing="0" cellpadding="0" id="tableGameSchedule" name="tableGameSchedule" >
					<thead>
						<tr>
							<th>경기진행 표</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1. 진행순서 조회 시 [경기장소]와 [경기일자] 선택 후 조회를 해주세요.</td>
						</tr>
						<tr>
							<td>2. 진행순서 생성 시 [경기장소] 선택, 경기진행 표에 경기를 넣고 달력으로 날짜 선택, 저장을 눌러주세요.</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!--  E: table-3 -->
	</div>
	<!-- E: SettingGameOrder -->
  <!-- E: setup-body -->
</body>
</html>

<script>
 var $allView = $(".all-view");
 var $tableOne = $("#divGameLevelList");
 var $tableTow = $("#divGameTourney");
 var $tableThree = $(".table-3");
$allView.click(function(){

	if(!($tableOne.hasClass("on"))){
		$tableOne.addClass("on");
		$(this).html("전체보기")
	}else{
		$tableOne.removeClass("on");
		$(this).html("펼치기")
	}
	if(!($tableTow.hasClass("on"))){
		$tableTow.addClass("on");
	}else{
		$tableTow.removeClass("on");
	}
	if(!($tableThree.hasClass("on"))){
		$tableThree.addClass("on");
	}else{
		$tableThree.removeClass("on");
	}
})
</script>