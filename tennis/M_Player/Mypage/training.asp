<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
  dim TraiFistCd  : TraiFistCd = fInject(request("TraiFistCd"))

  '초기메뉴 체력훈련[TA]
  IF TraiFistCd = "" Then TraiFistCd = "TA"
%>
<script type="text/javascript">
  //Tab메뉴 클릭
  function onLinkURL(type_TAB){
    $("#TraiFistCd").val(type_TAB);
    $("frm").attr({action:"./traning.asp", method:"post"}).submit();

    manage_TrainCode(type_TAB);
  }

  //훈련종류 항목 추가
  function add_TrainInfo(){
    var PlayerIDX = "<%=decode(request.Cookies("PlayerIDX"), 0)%>";
    var strAjaxUrl = "../Ajax/training-list.asp";

    if(PlayerIDX==""){
      alert("로그인 후 이용할 수 있습니다.");
      return;
      $(location).attr('href', "../Main/login.asp");
    }

    if(!$("#add_TrainNm").val()){
      alert("추가할 훈련종류 항목을 입력하세요");
      return;
    }

    var type_TAB = $("#TraiFistCd").val();
    var add_TrainNm = $("#add_TrainNm").val();

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        TraiFistCd    : type_TAB,
        add_TrainNm   : add_TrainNm,
        Type_Action   : "ADD"
      },
      success: function(retDATA) {
        if(retDATA){
          $("#"+type_TAB).html(retDATA);
          $("#add_TrainNm").val('');
        }
      }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
    });
  }

  //훈련종류 항목 수정시 object 변경
  function mod_TrainInfo(TraiMidIDX, Type_Action){
    var strAjaxUrl = "../Ajax/training-list.asp";

    if(Type_Action=="MOD"){
      $("#viewTraiMid"+TraiMidIDX).hide();
      $("#modTraiMid"+TraiMidIDX).show();
    }
    else if(Type_Action=="RESET"){
      $("#viewTraiMid"+TraiMidIDX).show();
      $("#modTraiMid"+TraiMidIDX).hide();
    }
  }


  //훈련종류 항목 수정/삭제
  function mod_TrainInfo_Proc(TraiMidIDX, Type_Action){
    if(Type_Action=="SAVE"){
      if(!$("#mod_TrainNm"+TraiMidIDX).val()){
        alert("수정할 훈련종류 항목을 입력하세요");
        return;
      }
    }

    var strAjaxUrl = "../Ajax/training-list.asp";
    var type_TAB = $("#TraiFistCd").val();
    var mod_TrainNm = $("#mod_TrainNm"+TraiMidIDX).val();

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        TraiFistCd    : type_TAB,
        mod_TrainNm   : mod_TrainNm,
        TraiMidIDX    : TraiMidIDX,
        Type_Action   : Type_Action
      },
      success: function(retDATA) {
        if(retDATA){
          $("#"+type_TAB).html(retDATA);
		  //$("#confirm-del").hide();
		  $("#confirm-del").modal('hide');
        }
      }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
    });
  }



  //TAB 클릭 훈련종류 항목 조회
  function manage_TrainCode(type_TAB){
    var strAjaxUrl = "../Ajax/training-list.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        TraiFistCd    : type_TAB,
        Type_Action   : "READY"
      },
      success: function(retDATA) {
        if(retDATA){
          $("#"+type_TAB).html(retDATA);
        }
      }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
    });
  }

  $(document).ready(function() {
    var strAjaxUrl = "../Ajax/training-list.asp";
    var TraiFistCd = $("#TraiFistCd").val();

    $.ajax({
		  url: strAjaxUrl,
		  type: 'POST',
		  dataType: 'html',
		  data: {
			TraiFistCd    : TraiFistCd,
			Type_Action   : "READY"
      },
      success: function(retDATA) {
        if(retDATA){
          $("#TA").html(retDATA);
        }
      }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
    });

    $(".btn-back").on("click",function (e) {

    });

  });
</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>훈련종류 항목관리</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->
  

  <form name="frm" method="post">
    <input type="hidden" name="TraiFistCd" id="TraiFistCd" value="<%=TraiFistCd%>" />
    <input type="hidden" name="modal_TraiMidIDX" id="modal_TraiMidIDX" />

  <!-- S: sub -->
  <div class="sub">
    <ul class="tab-menu type2">
      <li class="on"><a href="javascript:onLinkURL('TA');">체력훈련</a></li>
      <li><a href="javascript:onLinkURL('TB');">도복훈련</a></li>
    </ul>
    <div class="training-add">
        <input type="text" name="add_TrainNm" id="add_TrainNm" placeholder=":: 추가할 훈련종류를 입력하세요 ::" />
        <a href="javascript:add_TrainInfo();" class="btn-add">추가 <span>+</span></a>
    </div>
    <!--체력훈련-->
    <div id="TA" class="tabc type2"></div>
    <!--도복훈련-->
    <div id="TB" class="tabc type2" style="display:none;"></div>

  </div>
  <!-- E : sub -->

  <!-- S: 삭제시 팝업 modal -->
  <div class="modal fade" id="confirm-del" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <div class="modal-dialog modal-sm">
      <div class="modal-content modal-small">
        <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <div class="modal-txt-wrap">
            <p class="modal-txt">훈련종류를 삭제하시겠습니까?</p>
            <div id="div_TraiMidIDX" class="btn-center">
              <a href="#" class="btn-navyline-square" data-dismiss="modal">취소</a>
              <a href="javascript:mod_TrainInfo_Proc($('#modal_TraiMidIDX').val(), 'DEL');" class="btn-navy-square">삭제</a>
            </div>
          </div>
        </div>
      </div>
      <!-- ./ modal-content -->
    </div> <!-- ./modal-dialog -->
  </div>
  <!-- E : 삭제시 팝업 modal -->
  </form>

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <script>
    (function($){
      var $this;
      var $btn;
      var $titleTxt;

      $('#confirm-del').on('show.bs.modal', function(evt){
        $this = $(this);
        $btn = $(evt.relatedTarget);
        $titleTxt = $btn.data('title');

		var $okBtn = $(this).find('#div_TraiMidIDX a.btn-right');
        var $modal_TraiMidIDX = $('#modal_TraiMidIDX');

		$modal_TraiMidIDX.val($titleTxt);

      });
    })(jQuery);
  </script>

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
