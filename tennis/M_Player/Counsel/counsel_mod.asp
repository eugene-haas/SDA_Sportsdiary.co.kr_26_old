<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
	'선수보호자 상담요청하기 수정페이지

	dim CIDX 		: CIDX 			= fInject(request("CIDX"))
	dim currPage 	: currPage 		= fInject(request("currPage"))
	dim fnd_user 	: fnd_user 		= fInject(request("fnd_user"))
	dim search_date : search_date 	= fInject(request("search_date"))
	dim SDate 		: SDate 		= fInject(request("SDate"))
	dim EDate 		: EDate 		= fInject(request("EDate"))
	dim typeMenu 	: typeMenu 		= fInject(Request("typeMenu"))

	IF CIDX = "" Then
		response.Write "<script>alert('잘못된 접근입니다\n확인 후 이용하세요'); history.back();</script>"
		response.End()
	End IF

	'지도자 상담내역 조회
	ChkSQL = 	" SELECT * " &_
				" FROM [SportsDiary].[dbo].[tblSvcLedrAdv] " &_
				" WHERE DelYN = 'N' "&_
				"	AND SportsGb = '"&SportsGb&"' "&_
				" 	AND LedrAdvIDX = "&CIDX

	SET CRs = Dbcon.Execute(ChkSQL)
	IF Not(CRs.eof or CRs.bof)	Then
		Title 			= ReplaceTagReText(CRs("Title"))
		Contents 		= ReplaceTagReText(CRs("Contents"))
	Else
		response.Write "<script>alert('일치하는 정보가 없습니다.\n확인 후 이용하세요'); history.back();</script>"
		response.End()
	End IF
		CRs.Close
	SET CRs = Nothing

%>
<script type="text/javascript">
	function frm_Reset(){
		$('form[name="frm"]')[0].reset();
	}

	function chk_Write(){
		if(!$("#Title").val()){
			alert("제목을 입력해 주세요.");
			$('#Title').focus();
			return;
		}
		if(!$("#Contents").val()){
			alert("상담내용을 입력해 주세요.");
			$('#Contents').focus();
			return;
		}

		var strAjaxUrl = "../Ajax/counsel_write_ok.asp";
		var CIDX = $("#CIDX").val();
		var Title = $("#Title").val();
		var Contents = $("#Contents").val();
		var strType = $("#strType").val();

		$.ajax({
			url: strAjaxUrl,
			type: "POST",
			dataType: "html",
			data: {
				 Contents  	: Contents
				,Title  	: Title
				,CIDX  		: CIDX
				,strType  	: strType
			},
			success: function(retDATA) {

				if(retDATA=="TRUE"){
					alert ("상담내용이 수정되었습니다..");

					$('form[name=frm]').attr('action',"./counsel_view.asp");
					$('form[name=frm]').submit();

					//$(location).attr("href", "./counsel-view.asp");
				}
				else{
					alert ("상담내용을 수정하지 못하였습니다.\n다시 시도해 주세요.");
					return;
				}
			}, error: function(xhr, status, error){
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");
					return;
				}
			}
		});
	}
</script>
<body class="lack-bg">
	<!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>지도자상담</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->
	
  <form id="frm" name="frm" method="post">
	<input type="hidden" name="typeMenu" id="typeMenu" value="<%=typeMenu%>" />
    <input type="hidden" name="strType" id="strType" value="MOD" />
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="fnd_user" id="fnd_user" value="<%=fnd_user%>" />
    <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />
	<!-- S: sub sub-main -->
  <div class="sub sub-main board">
    <div class="write-title">
			<label for="Title">제목</label>
			<input type="text" name="Title" id="Title" value="<%=Title%>" />
    </div>
    <!-- S: write-cont -->
    <div class="write-cont">
      <!-- S: 게시판 작성 내용 -->
			<textarea id="Contents" name="Contents"><%=Contents%></textarea>
      <!-- E: 게시판 작성 내용 -->
    </div>
    <!-- E: write-cont -->
		<!-- S: btn-list -->
		<div class="btn-list write">
			<a href="javascript:frm_Reset();" class="btn-left btn">취소</a>
			<a href="javascript:chk_Write();" class="btn-right btn">수정</a>
		</div>
		<!-- E: btn-list -->
  </div>
  <!-- E: sub sub-main board -->
  </form>
    <!-- S: bottom-menu -->
      <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: record-bg -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
