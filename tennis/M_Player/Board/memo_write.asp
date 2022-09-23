<!-- #include file="../include/config.asp" -->
<%
	Check_Login()

	dim strType   		: strType     	= fInject(Request("strType")) '글 등록구분
	dim CIDX   	 		: CIDX      	= fInject(Request("CIDX"))
	dim currPage  		: currPage    	= fInject(Request("currPage"))
	dim fnd_KeyWord  	: fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
	dim search_date 	: search_date   = fInject(Request("search_date"))
	dim SDate     		: SDate     	= fInject(Request("SDate"))
	dim EDate     		: EDate     	= fInject(Request("EDate"))

	IF  strType ="" THEN strType = "WR"

	SELECT CASE strType
		CASE "WR" : strTypeNm = "저장"
		CASE "MOD" : strTypeNm = "수정"
	END SELECT

' response.Write "strType="&strType&"<br>"
' response.Write "CIDX="&CIDX&"<br>"
' response.Write "currPage="&currPage&"<br>"
' response.Write "fnd_KeyWord="&fnd_KeyWord&"<br>"
' response.Write "search_date="&search_date&"<br>"
' response.Write "SDate="&SDate&"<br>"
' response.Write "EDate="&EDate&"<br>"

%>
<script type="text/javascript">
	function frm_Reset(){
		$('form[name="s_frm"]')[0].reset();
	}

	function onSubmit(){
		$('form[name=s_frm]').attr('action',"./my_memo.asp");
		$('form[name=s_frm]').submit();
	}

	function chk_Write(){
		if(!$("#Title").val()){
			alert("제목을 입력해 주세요.");
			$('#Title').focus();
			return;
		}
		if(!$("#Contents").val()){
			alert("내용을 입력해 주세요.");
			$('#Contents').focus();
			return;
		}

		var strAjaxUrl = "../Ajax/my_memo_write_ok.asp";
		var Title = $("#Title").val();
		var Contents = $("#Contents").val();
		var strType = $("#strType").val();
		var CIDX = $("#CIDX").val();

		$.ajax({
			url: strAjaxUrl,
			type: "POST",
			dataType: "html",
			data: {
				Contents   : Contents
				,Title    : Title
				,strType    : strType
				,CIDX   : CIDX
			},
			success: function(retDATA) {

			//  alert(retDATA);

				if(retDATA=="TRUE"){
					if(strType=="WR"){
						alert ("내용이 등록되었습니다.");
						$('form[name=s_frm]').attr('action',"./my_memo.asp");
						$('form[name=s_frm]').submit();
					}
					else{
						alert ("내용이 수정되었습니다.");
						$('form[name=s_frm]').attr('action',"./my_memo_view.asp");
						$('form[name=s_frm]').submit();
					}
				}
				else{
					if(strType=="WR"){
						alert ("내용을 등록하지 못하였습니다.\n다시 시도해 주세요.");
						return;
					}
					else{
						alert ("내용을 수정하지 못하였습니다.\n다시 시도해 주세요.");
						return;
					}
				return;
				}
			},
			error: function(xhr, status, error){
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");
					return;
				}
			}
		});
  	}

  	//수정시 정보 조회 후 출력
	function info_View(){
		var strAjaxUrl = "../Ajax/my_memo_view.asp";
		var CIDX = $("#CIDX").val();

		$.ajax({
			url: strAjaxUrl,
			type: "POST",
			dataType: "html",
			data: {
				CIDX       : CIDX
			},
			success: function(retDATA) {
				if(retDATA){

					var strcut = retDATA.split("|");

					if(strcut[0]=="TRUE") {
						$("#Title").val(strcut[1]);
						$("#Contents").val(strcut[2]);
					}
					else{
						if(strcut[1] == 1) {
							alert ("잘못된 접근입니다.");
							return;
						}
						else{
							alert ("일치하는 글이 없습니다.");
							return;
						}
					}
				}
			},
			error: function(xhr, status, error){
				if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");
					return;
				}
			}
		});
	}

	$(document).ready(function(){
		if($('#strType').val() == "MOD") info_View();
	});
</script>
<body>
<form name="s_frm" method="post">
    <input type="hidden" name="strType" id="strType" value="<%=strType%>" />
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
    <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
    <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />

		<!-- S: sub-header -->
	  <div class="sd-header sd-header-sub">
	    <!-- #include file="../include/sub_header_arrow.asp" -->
	    <h1>나의 메모장</h1>
	    <!-- #include file="../include/sub_header_gnb.asp" -->
	  </div>
	  <!-- #include file = "../include/gnb.asp" -->
	  <!-- E: sub-header -->

  <!-- S: top-counsel -->
  <div class="top-counsel write qa-top">
    <div class="divn_bd flex container">
      <h3 class="write_guide">제목</h3>
      <input type="text" name="Title" id="Title" placeholder="제목을 입력해 주세요.">
    </div>
  </div>
  <!-- E: top-counsel -->
  <!-- S: sub sub-main -->
  <div id="board-contents" class="sub sub-main board qa-board qa-write panel-group qa-srch-board">
    <div class="type-word container">
      <textarea id="Contents" name="Contents" placeholder="내용을 입력해 주세요."></textarea>
    </div>
  </div>
  <!-- E: sub sub-main board -->

  <!-- S: btn-list -->
  <div class="btn-list qa-board-cta qa-write container flex">

    <%
  IF strType = "MOD" Then
  %>
    <a href="javascript:onSubmit();" class="btn btn-cancel">목록</a>
    <%
  Else
  %>
    <a href="javascript:history.back();" class="btn btn-cancel">취소</a>
    <%
  End IF
  %>
    <a href="javascript:chk_Write();" class="btn btn-save"><%=strTypeNm%></a>
  </div>
  <!-- E: btn-list -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
  </form>
</body>
