<!-- #include file='../include/config.asp' -->
<!-- #include file='../include/css/join_style.asp' -->
<link rel="stylesheet" href="../css/page/reqRequest/req_club.css">
<script>
	function chk_onSubmit(){
		//시/도
		if(!$('#AreaGb').val()){
			alert('시/도를 선택해 주세요.');
			$('#AreaGb').focus();
			return;
		}

		//시/군/구
		if(!$('#AreaGbDt').val()){
			alert('시/군/구를 선택해 주세요.');
			$('#AreaGbDt').focus();
			return;
		}

		//소속이름
		if(!$('#TeamNm').val()){
			alert('소속이름을 입력해 주세요.');
			$('#TeamNm').focus();
			return;
		}

		//요청자
		if(!$('#ReqName').val()){
			alert('요청자 이름을 입력해 주세요.');
			$('#ReqName').focus();
			return;
		}

		var strAjaxUrl = '../ajax/req_club_write.asp';
		var AreaGb = $('#AreaGb').val();
		var AreaGbDt = $('#AreaGbDt').val();
		var TeamNm = $('#TeamNm').val();
		var ReqName = $('#ReqName').val();

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				AreaGb		: AreaGb
				,AreaGbDt	: AreaGbDt
				,TeamNm		: TeamNm
				,ReqName	: ReqName
			},
			success: function(retDATA) {

				console.log(retDATA);

				var strcut = retDATA.split('|');

				if (strcut[0] == 'TRUE') {
					$('.welcome_modal').modal('show');
				}
				else{  //FALSE
					var msg = '';

					switch (strcut[1]) {
						case '66' 	: msg = '회원가입에 실패하였습니다.\n관리자에게 문의하세요.'; break;
						default		: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
					}
					alert(msg);
					return;
				}
			},
			error: function(xhr, status, error){
				if(error !=''){
					alert ('조회중 에러발생 - 시스템관리자에게 문의하십시오!');
					return;
				}
			}
		});
	}

	/*
	function make_box_sel(element, attname, code, action_type){
		//생활체육 지역조회
		if(action_type=='Join_AreaGb_A'){
			var strAjaxUrl = '../Select/Join_AreaGb_Select_A.asp';
		}
		//생활체육 상세지역조회
		else if(action_type=='Join_AreaGbDt_A'){
			var strAjaxUrl = '../Select/Join_AreaGbDt_Select_A.asp';
		}
		else{}

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				attname	: attname
				,code	: code
			},
			success: function(retDATA) {

			//	console.log(retDATA);

				if(retDATA){
					$('#'+element).html(retDATA);
				}
			},
			error: function(xhr, status, error){
				if(error !=''){
					alert ('조회중 에러발생 - 시스템관리자에게 문의하십시오!');
					setseq = '';
					return;
				}
			}
		});
	}
	*/

	//상세지역 조회 셀렉박스 생성
	function chk_AreaGbDt(code){
		//make_box_sel('sel_AreaGbDt', 'AreaGbDt', code, 'Join_AreaGbDt_A');
		make_box('sel_AreaGbDt', 'AreaGbDt', code, 'Join_AreaGbDt_A');
	}

	$(document).ready(function(){
		//make_box_sel('sel_AreaGb','AreaGb','','Join_AreaGb_A');
		make_box('sel_AreaGb','AreaGb','','Join_AreaGb_A');
	});
</script>
</head>
<body class="join-body">
	<!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>소속생성요청 작성</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: main -->
  <div class="main req_club_write pack">
    <!-- S: form-group -->
    <div class="form-group">
      <ul>
        <li class="sel_box" id="sel_AreaGb">
          <select id="AreaGb" name="AreaGb">
            <option value="">시/도 선택</option>
            <!--
            <option>서울시</option>
            <option>경기도</option>
            -->
          </select>
        </li>
        <li class="sel_box" id="sel_AreaGbDt">
          <select id="AreaGbDt" name="AreaGbDt">
            <option value="">시/군/구 선택</option>
            <!--
            <option>용인</option>
            <option>고양</option>
            <option>성남</option>
            -->
          </select>
        </li>
        <li>
          <input type="text" placeholder="소속이름을 입력해주세요" name="TeamNm" id="TeamNm" />
        </li>
        <li>
          <input type="text" placeholder="요청자를 입력해주세요" name="ReqName" id="ReqName" />
        </li>
      </ul>
    </div>
    <!-- E: form-group -->

    <div class="cta">
      <!--
      <a href="#" data-toggle="modal" data-target=".req_comp" data-backdrop="static" data-keyboard="false" class="btn btn-ok btn-block">등록</a>
      -->
      <a href="javascript:chk_onSubmit();" data-target=".req_comp" data-backdrop="static" data-keyboard="false" class="btn btn-ok btn-block">등록</a>
    </div>

  </div>
  <!-- E: main -->

  <!-- S: user_agree_info -->
  <div class="user_agree_info">
    <!-- S: guide_txt -->
    <div class="guide_txt">
      <ul>
        <li>
          <p>신규소속 생성 요청은 KATA 및 스포츠다이어리 관리자 확인 후 진행됩니다. 해당 게시판에서 생성여부를 확인 하시고 회원님의 소속을 추가 요청해주시기 바랍니다.</p>
        </li>
        <li>
          <p>회사는 소속생성요청  게시판 서비스 위해 개인정보 (항목: 이름)를 수집하고 있습니다. 아래 "등록"을 누르시면 개인정보취급방침에 동의하게 됩니다.</p>
        </li>
      </ul>
    </div>
    <!-- E: guide_txt -->
  </div>
  <!-- E: user_agree_info -->

  <!-- S: req_comp -->
  <div class="modal fade req_comp welcome_modal">
    <!-- S: modal-dialog -->
    <div class="modal-dialog">
      <!-- S: modal-content -->
      <div class="modal-content">
        <!-- S: modal-body -->
        <div class="modal-body">
          <p>신청 되었습니다.</p>
        </div>
        <!-- E: modal-body -->
        <!-- S: modal-footer -->
        <div class="modal-footer">
          <a href="./req_club.asp" class="btn btn-block btn-cancel">확인</a>
        </div>
        <!-- E: modal-footer -->
      </div>
      <!-- E: modal-content -->
    </div>
    <!-- E: modal-dialog -->
  </div>
  <!-- E: req_comp -->
  <script src="../js/main.js"></script>
</body>
</html>
