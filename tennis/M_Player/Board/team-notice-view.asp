<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
	Check_Login()

	dim NtcIDX 		: NtcIDX 		= fInject(request("NtcIDX"))
	dim currPage 	: currPage 		= fInject(request("currPage"))
	dim fnd_user 	: fnd_user 		= fInject(request("fnd_user"))
	dim search_date : search_date 	= fInject(request("search_date"))
	dim SDate 		: SDate 		= fInject(request("SDate"))
	dim EDate 		: EDate 		= fInject(request("EDate"))

	dim CSQL, CRs

	IF NtcIDX = "" Then
		response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>"
		response.End()
	End IF

	CSQL = 	" 		SELECT N.Title "
	CSQL = CSQL & "		,N.Contents "
	CSQL = CSQL & "		,N.Notice "
	CSQL = CSQL & "		,CONVERT(CHAR(10), N.WriteDate, 102) WriteDate "
	CSQL = CSQL & "		,N.UserName "
	CSQL = CSQL & "		,N.ViewCnt "
	CSQL = CSQL & "		,SportsDiary.dbo.FN_PubName('sd03900' + M.LeaderType) LeaderType "
	CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcNotice] N "
	CSQL = CSQL & "		left join [Sportsdiary].[dbo].[tblMember] M on M.UserID = N.UserID "
	CSQL = CSQL & "			AND M.DelYN = 'N' "
	CSQL = CSQL & "			AND M.SportsType = '"&SportsGb&"' "
	CSQL = CSQL & " WHERE N.DelYN ='N' "
	CSQL = CSQL & "		AND N.SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "		AND N.NtcIDX = "&NtcIDX

	SET CRs = server.CreateObject ("ADODB.Recordset")
		CRs.Open CSQL, Dbcon, 1 ,3

		CRs("ViewCnt") = CRs("ViewCnt") + 1
		CRs.Update

		Title 		= ReplaceTagReText(CRs("Title"))
		Contents 	= replace(ReplaceTagReText(CRs("Contents")),chr(10), "<br>")
		Notice	 	= CRs("Notice")
		WriteDate 	= CRs("WriteDate")
		UserName 	= CRs("UserName")
		ViewCnt 	= CRs("ViewCnt")
		LeaderType	= CRs("LeaderType")

		CRs.Close
	SET CRs = Nothing


%>
<script>
	function chk_Submit(typeURL, NtcIDX, chkPage){
		$('form[name=s_frm]').attr('action',"./team-notice-list.asp");
		$('form[name=s_frm]').submit();

	}
</script>
<body>
<form name="s_frm" method="post">
	<input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />
    <input type="hidden" name="fnd_user" id="fnd_user" value="<%=fnd_user%>" />
    <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
    <input type="hidden"  class="on_val" id="on_val" name="on_val" />
  <input type="hidden"  class="active_val"  id="active_val" name="active_val"  />

	<!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>팀 공지사항</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->
	
  <!-- S: sub sub-main -->
  <div class="sub sub-main board">
    <div class="view-title">
      <h4><%IF Notice = "Y" Then response.Write "[필독]&nbsp;" End IF%><%=Title%></h4>
      <p class="write-info clearfix">
        <span><%=UserName%><%=LeaderType%></span>
        <span><%=replace(left(WriteDate, 10), "-", ".")%></span>
        <span class="seen">조회수</span>
        <span><%=formatnumber(ViewCnt, 0)%></span>
      </p>
    </div>
    <!-- S: view-cont -->
    <div class="view-cont">
      <!-- S: 게시판 작성 내용 -->
      <p><%=Contents%></p>
      <!-- E: 게시판 작성 내용 -->
    </div>
    <!-- E: view-cont -->
    <!-- S: btn-list -->
    <div class="btn-list">
      <ul>
        <li><a href="javascript: chk_Submit();" class="btn show-list">목록</a></li>
      </ul>
    </div>
    <!-- E: btn-list -->
  </div>
  <!-- E: sub sub-main board -->

  <!-- S: footer -->
  <!-- #include file="../include/bottom_menu.asp" -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
  </form>
</body>
