<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->

  <%
      Check_Login()

  	dim strType 	: strType 		= fInject(Request("strType")) '글 등록구분[WR, REPLY]
  	dim CIDX 		: CIDX 			= fInject(Request("CIDX"))
  	dim currPage 	: currPage 		= fInject(Request("currPage"))
  	dim fnd_user 	: fnd_user 		= fInject(Request("fnd_user"))
  	dim search_date : search_date 	= fInject(Request("search_date"))
  	dim SDate 		: SDate 		= fInject(Request("SDate"))
  	dim EDate 		: EDate 		= fInject(Request("EDate"))

  	IF 	strType ="" THEN strType = "WR"

  	SELECT CASE strType
  		CASE "WR" : strTypeNm = "저장"
  		CASE "MOD" : strTypeNm = "수정"
  	END SELECT

  '	response.Write "strType="&strType&"<br>"
  '	response.Write "CIDX="&CIDX&"<br>"
  '	response.Write "currPage="&currPage&"<br>"
  '	response.Write "fnd_user="&fnd_user&"<br>"
  '	response.Write "search_date="&search_date&"<br>"
  '	response.Write "SDate="&SDate&"<br>"
  '	response.Write "EDate="&EDate&"<br>"

  %>
  <script type="text/javascript">
  	function frm_Reset(){
  		$('form[name="s_frm"]')[0].reset();
  	}

  	function onSubmit(){
  		$('form[name=s_frm]').attr('action',"./qa_board.asp");
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

  		var strAjaxUrl = "../Ajax/qa_board_write_ok.asp";
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
  					if(strType=="WR"){
  						alert ("내용이 등록되었습니다.");
  						$('form[name=s_frm]').attr('action',"./qa_board.asp");
  						$('form[name=s_frm]').submit();
  					}else{
  						alert ("내용이 수정되었습니다.");
  						$('form[name=s_frm]').attr('action',"./qa_board_view.asp");
  						$('form[name=s_frm]').submit();
  					}
  				}
  				else{
  					if(strType=="WR"){
  						alert ("내용을 등록하지 못하였습니다.\n다시 시도해 주세요.");
  					}else{
  						alert ("내용을 수정하지 못하였습니다.\n다시 시도해 주세요.");
  					}

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

  	function info_View(){
  		var strAjaxUrl = "../Ajax/qa_board_view.asp";
  		var CIDX = $("#CIDX").val();

  		$.ajax({
  			url: strAjaxUrl,
  			type: "POST",
  			dataType: "html",
  			data: {
  				 CIDX   		: CIDX
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
  							alert ("일치하는 정보가 없습니다.");
  							return;
  						}
  						else{
  							alert ("잘못된 접근입니다.");
  							return;
  						}
  					}
  				}
  			}, error: function(xhr, status, error){
  				if(error!=""){
  					alert ("오류발생! - 시스템관리자에게 문의하십시오!");
  					return;
  				}
  			}
  		});
  	}

  	$(document).ready(function(){
  		<%IF strType = "MOD"  Then response.Write "info_View();" %>
  	});
  </script>
</head>
<body>
<div class="l m_bg_f2f2f2">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">Q&amp;A 게시판</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>

    <div class="m_horizon"></div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">

    <form name="s_frm" method="post">
    	<input type="hidden" name="strType" id="strType" value="<%=strType%>" />
      <!-- S: 답변 후 리턴데이터-->
      <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <input type="hidden" name="fnd_user" id="fnd_user" value="<%=fnd_user%>" />
      <input type="hidden" name="search_date" id="search_date" value="<%=search_date%>" />
      <input type="hidden" name="SDate" id="SDate" value="<%=SDate%>" />
      <input type="hidden" name="EDate" id="EDate" value="<%=EDate%>" />

      <div class="m_forumWrite">
        <div class="m_forumWrite__header">
          <label for="Title" class="m_forumWrite__titLabel">제목</label>
          <input type="text" name="Title" id="Title" class="m_forumWrite__titInput" placeholder="제목을 입력해 주세요.">
        </div>

        <div id="board-contents" class="m_forumWrite__contentWrap">
          <textarea id="Contents" name="Contents" class="m_forumWrite__contentInput" placeholder="내용을 입력해 주세요."></textarea>
        </div>
      </div>

      <div class="m_forum__btnBar">

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
    </form>

  </div>

  <!-- #include file= "../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>
</body>
</html>
<!-- #include file="../Library/sub_config.asp" -->