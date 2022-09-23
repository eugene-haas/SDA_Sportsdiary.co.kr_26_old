<!-- #include file='./include/config.asp' -->
<script>
  //더보기
  $(function(){
    $(document).on('click', '.more', function(){
      var strAjaxUrl="./ajax/req_club.asp";
      var fnd_KeyWord = $('#fnd_KeyWord').val();
      var cnt_board = $('#cnt_board').val();
      var ID = $(this).attr("id");

      if(ID) {
        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
              fnd_KeyWord     : fnd_KeyWord
              ,fnd_LastID   : ID
              ,cnt_board    : cnt_board
            },
          cache: false,
          success: function(retDATA) {

            //console.log(retDATA);

            $(".view_list").append(retDATA);
            $("#more"+ID).remove(); // removing old more button

          },
          error: function(xhr, status, error){
            if(error!=""){
              alert ("오류발생! - 시스템관리자에게 문의하십시오!");
              return;
            }
          }
        });
      }
      return false;
    });
  });

  //목록조회
  function view_match(valType){

	//키워드검색
	//[AreaGb시/도, AreaGbDt시/군/구, TeamNm,소속명, ReqName요청자명]

	if(valType=="FND"){
		if(!$("#fnd_KeyWord").val()){
		  alert("검색할 키워드를 입력해주세요.");
		  $("#fnd_KeyWord").focus();
		  return;
		}
	}
	else{
		$("#fnd_KeyWord").val("");
	}


    var strAjaxUrl="./ajax/req_club.asp";
    var fnd_KeyWord   = $("#fnd_KeyWord").val();

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
	  	fnd_KeyWord	: fnd_KeyWord
	  },
      success: function(retDATA) {

        //console.log(retDATA);

        $(".view_list").html(retDATA);

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
    view_match(); //목록조회
  });

</script>
</head>
<body>
  <input type="hidden" name='cnt_board' id='cnt_board' />

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="./include/sub_header_arrow.asp" -->
    <h1>신규소속 생성요청</h1>
    <!-- #include file="./include/sub_header_gnb.asp" -->
  </div>
  <!-- E: sub-header -->
  
  <!-- S: main -->
  <div class="main board req_club pack">
    <!-- S: 검색어 입력 -->
    <div class="srch_box">
      <ul>
        <li>
          <a href="javascript:view_match('ALL');" class="btn btn-org">전체목록</a>
          <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" placeholder="검색어 입력" autocomplete="off">
          <a href="javascript:view_match('FND');" class="btn btn-gray">검색</a>

        </li>
      </li>
      </ul>
    </div>
    <!-- E: 검색어 입력 -->
    <!-- S: view_list -->
    <div class="view_list" id="view_list">

    </div>
    <!-- E: view_list -->

    <!-- S: cta -->
    <div class="cta">
      <a href="./req_club_write.asp" class="btn btn-ok btn-block">요청 작성하기</a>
    </div>
    <!-- E: cta -->

  </div>
  <!-- E: main -->

  <!-- #include file='./include/footer.asp' -->

</body>
</html>
