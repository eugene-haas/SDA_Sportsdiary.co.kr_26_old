<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->
  <!-- #include file="../Library/sub_config.asp" -->
  <script type="text/javascript">
    $(document).ready(function(){

      var strAjaxUrl = "../Ajax/faq.asp";
      var FAPubCode = $("#FAPubCode").val();

       $.ajax({
         url: strAjaxUrl,
         type: "POST",
         dataType: "html",
         data: {
           FAPubCode : FAPubCode
         },
         success: function(retDATA) {
           $("#faq-contents").html(retDATA);
           $("#faq-contents").faqMove("#faq-contents");
         },
         error: function(xhr, status, error){
           if(error!=""){
    			   alert ("오류발생! - 시스템관리자에게 문의하십시오!");
    			   return;
    			 }
         }
       });
    });
  </script>
</head>
<body>
<div class="l">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">자주하는 질문</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <!-- S: sub -->
  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_faqHeader">
      <p class="m_faqHeader__txt">스포츠다이어리를 사용하시면서 아래의 경우 외에 궁금한 사항이 있으시면 저희 스포츠다이어리로 연락주시기 바랍니다.</p>
      <p class="m_faqHeader__listTit">&middot; 서비스 이용 및 시스템관련 문의</p>
      <ul class="m_faqHeader__list">
        <li class="m_faqHeader__item">
          <%=global_name2%>팀 담당&nbsp;&nbsp;<a href="tel:<%=global_num2%>" class="m_faqHeader__pointTxt"> <%=global_num2%></a>
        </li>
      </ul>
    </div>

    <form name="s_frm" method="post">
    	<input type="hidden" name="FAPubCode" id="FAPubCode" value="<%=FAPubCode%>" />
      <!-- S: 부트스트랩 아코디언 -->

      <div id="faq-contents" class="m_faqBox panel-group accordion [ _panelBox ]" role="tablist" aria-multiselectable="true">
        <!-- S: faq-markup -->
        <!-- S: panel
        <div class="panel panel-default">
          <a data-toggle="collapse" data-parent=".accordion" href=".faq1" class="panel-title clearfix" aria-expanded="false">
            <p class="panel-ic-q">Q</p>
            <p class="panel-txt-q">내용1</p>
            <p class="ic-caret sw on"><span class="caret"></span></p>
          </a>
          <div class="faq1 panel-collapse collapse in" role="tabpanel" aria-expanded="true">
            <div class="panel-body">
              <p class="panel-ic-a">A</p>
              <p class="panel-txt-a">내용답변1</p>
            </div>
          </div>
        </div>
         E: panel -->
        <!-- S: panel
        <div class="panel panel-default">
          <a data-toggle="collapse" data-parent=".accordion" href=".faq5" class="panel-title clearfix collapsed" aria-expanded="false">
            <p class="panel-ic-q">Q</p>
            <p class="panel-txt-q">내용2</p>
            <p class="ic-caret sw on"><span class="caret"></span></p>
          </a>
          <div class="faq5 panel-collapse collapse " role="tabpanel" aria-expanded="true">
            <div class="panel-body">
              <p class="panel-ic-a">A</p>
              <p class="panel-txt-a">내용답변2</p>
            </div>
          </div>
        </div>
         E: panel -->
        <!-- E: faq-markup -->
      </div>

      <!-- E: 부트스트랩 아코디언 -->
    </form>
  </div>
  <!-- E : sub -->

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
  <script>
    var $selected;
    $("._panelBox").on('click', '.panel-title', function(){
      if($(this).hasClass('on')){ $(this).removeClass('on'); return; }
      if($selected){ $selected.removeClass('on'); }
      $selected = $(this);
      $selected.addClass('on');
    });
  </script>

</div>
</body>
</html>
