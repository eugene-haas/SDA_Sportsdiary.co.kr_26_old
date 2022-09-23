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

<%
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)

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
        LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = '" & reqGameTitleIdx & "'" 
        Set LRs = Dbcon.Execute(LSQL)

        IF Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            tblGameTitleCnt = tblGameTitleCnt + 1
            tGameTitleName = LRs("GameTitleName")
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
              crypt_reqGameTitleIdx =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
              tGameTitleName = LRs("GameTitleName")
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         
        End IF
		%>
		<input type="text" name="strGameTtitle" id="strGameTtitle" placeholder="검색할 대회명을 입력해 주세요." value="<%=tGameTitleName%>" style="width:750px">
    <input type="hidden" name="selGameTitleIdx" id="selGameTitleIdx" value="<%=crypt_reqGameTitleIdx%>">
		
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
              
                    IF(Len(reqGameTitleIdx) = 0 ) Then
                      IF (GameTitleIdxCnt = 1) Then
                        reqGameTitleIdx = tGameTitleIdx
                        crypt_reqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
                      End IF
                    End IF

                    If CDBL(reqGameTitleIdx) = CDBL(tGameTitleIdx)Then 
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
		<a href="javascript:OnSearchClick();" class="gray_btn">검색</a>
		</div>
    <!-- E: top-ctr -->
  </div>
	<!-- S: SettingGameOrder -->
	<div class="setting_game_order">
		<!-- S:table-1 -->
		<div class="table-1">
			<!-- S: top-search -->
			<div class="top-search">
				<input type="text">
				<a href="#">조회</a>
			</div>
			<!-- E: top-search -->
			<table cellspacing="0" cellpadding="0">
				<tr>
					<th colspan="2">종별순서</th>
				</tr>
				<tr>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
				</tr>
			</table>
		</div>
		<!--  E: table-1 -->
		<!-- S:table-2 -->
		<div class="table-2">
			<!-- S: top-search -->
			<div class="top-search">
				<input type="text">
				<a href="#">조회</a>
			</div>
			<!-- E: top-search -->
			<table cellspacing="0" cellpadding="0">
				<tr>
					<th>경기종목</th>
				</tr>
				<tr>
					<td>
						<span>종목1</span>
					</td>
				</tr>
				<tr>
					<td>
						<span>종목1</span>
					</td>
				</tr>
				<tr>
					<td>
						<span>종목1</span>
					</td>
				</tr>
				<tr>
					<td>
						<span>종목1</span>
					</td>
				</tr>
				<tr>
					<td>
						<span>종목1</span>
					</td>
				</tr>
			</table>
		</div>
		<!--  E: table-2 -->
		<!-- S:table-3 -->
		<div class="table-3">
			<!-- S: top-search -->
			<div class="top-search">
				<select name="" id="">
					<option value="">경기장</option>
				</select>
				<input type="text">
				<a href="#">조회</a>
				<a href="#">저장</a>
				<a href="#" class="red-btn">자동진행순서</a>
			</div>
			<!-- E: top-search -->
			<table cellspacing="0" cellpadding="0">
				<tr>
					<th>번호</th>
					<th>1</th>
					<th>2</th>
					<th>3</th>
					<th>4</th>
					<th>5</th>
					<th>6</th>
				</tr>
				<tr>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
				</tr>
				<tr>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
				</tr>
				<tr>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
					<td>
						<span>1</span>
					</td>
				</tr>
			</table>
		</div>
		<!--  E: table-3 -->
	</div>
	<!-- E: SettingGameOrder -->
  <!-- E: setup-body -->
</body>
</html>