<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<%
	'선수보호자 상담요청하기 작성페이지

	dim typeMenu 	: typeMenu 		= fInject(Request("typeMenu"))

	dim strType 	: strType 		= fInject(Request("strType")) '상담글 등록구분[WR, REPLY]
	dim CIDX 		: CIDX 			= fInject(Request("CIDX"))
	dim currPage 	: currPage 		= fInject(Request("currPage"))
	dim fnd_user 	: fnd_user 		= fInject(Request("fnd_user"))
	dim search_date : search_date 	= fInject(Request("search_date"))
	dim SDate 		: SDate 		= fInject(Request("SDate"))
	dim EDate 		: EDate 		= fInject(Request("EDate"))

	IF 	strType ="" THEN strType = "WR"
%>
<!-- E: config -->
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
		var Title = $("#Title").val();
		var Contents = $("#Contents").val();
		var strType = $("#strType").val();
		var CIDX = $("#CIDX").val();

		$.ajax({
			url: strAjaxUrl,
			type: "POST",
			dataType: "html",
			data: {
				 Contents  	: Contents
				,Title  	: Title
				,strType  	: strType
				,CIDX		: CIDX
			},
			success: function(retDATA) {

			//	alert(retDATA);

				if(retDATA=="TRUE"){
					alert ("상담내용이 등록되었습니다.");
					$('form[name=frm]').attr('action',"./<%=typeMenu%>.asp");
					$('form[name=frm]').submit();

					//$(location).attr("href", "./<%=typeMenu%>.asp");
				}
				else{
					alert ("상담내용을 등록하지 못하였습니다.\n다시 시도해 주세요.");
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
  	<input type="hidden" name="strType" id="strType" value="<%=strType%>" />
    <!-- S: 답변 후 리턴데이터-->
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="fnd_user" id="fnd_user" value="<%=fnd_user%>" />
    <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />
    <!-- E: 답변 후 리턴데이터-->
	<!-- S: sub sub-main -->
  <div class="sub sub-main board">
    <div class="write-title">
			<label for="Title">제목</label>
			<input type="text" name="Title" id="Title" />
    </div>
    <!-- S: write-cont -->
    <div class="write-cont">
      <!-- S: 게시판 작성 내용 -->
			<textarea id="Contents" name="Contents"></textarea>
      <!-- E: 게시판 작성 내용 -->
    </div>
    <!-- E: write-cont -->
		<!-- S: btn-list -->
		<div class="btn-list write">
			<a href="javascript:frm_Reset();" class="btn-left btn">취소</a>
			<a href="javascript:chk_Write();" class="btn-right btn">저장</a>
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
