<!DOCTYPE html>
<html lang="ko">
<head>
	﻿<!-- S: config -->
	<!-- #include file="../include/config.asp" -->
	<!-- #include file='../include/css/join_style.asp' -->
	<link rel="stylesheet" href="/front/css/join/fav_list.css">
	<link rel="stylesheet" href="/front/css/join/join1_type4_userInfo.css">
	<!-- E: config -->
	<%
		'=======================================================================================
		'일반 회원가입
		'PlayerReln --> [D]
		'=======================================================================================
		dim UserName      	: UserName    		= fInject(Request.Cookies("SD")("UserName"))
		dim UserBirth      	: UserBirth    		= decode(fInject(Request.Cookies("SD")("UserBirth")), 0)
		dim SportsType      : SportsType    	= fInject(Request("SportsType"))
		dim EnterType		: EnterType 		= "A"
		dim PlayerReln      : PlayerReln    	= fInject(Request("PlayerReln"))

		IF UserName = "" OR UserBirth = "" OR SportsType = "" OR PlayerReln = "" Then
			Response.Write "<script>"
			response.write "	alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); "
			response.write "	history.back();"
			response.write "</script>"
		  	Response.End
		End IF

	'	dim cnt_JoinMember	: cnt_JoinMember 	= CHK_JOINUS(UserName, UserBirth)	'통합ID계정 있는지 체크
		dim txtJoinInfo 	: txtJoinInfo		= INFO_JOINUS_MEMBER(UserName, UserBirth)	'통합회원 정보 출력
	%>
	<script type="text/javascript">
		//maxlength 체크
		function maxLengthCheck(object){
			if(object.value.length > object.maxLength){
			  	object.value = object.value.slice(0, object.maxLength);
			}
		}

		//회원가입항목 체크
		function chk_onSubmit(){

			var IntArr = '';
			var cnt_IntArr = 0;

			if(!$('#Job').val()){
				alert('현재 직업군을 선택해 주세요.');
				$('#Job').focus();
				return;
			}

			$('input[name=Interest]:checkbox').each(function() {
				if($(this).is(':checked')) {
					IntArr += '|' + $(this).val();
					cnt_IntArr += 1;
				}
			});

			if(cnt_IntArr==0){
				alert('관심분야는 최소 1개 이상 선택해 주세요.');
				return;
			}

			var strAjaxUrl 		= '../Ajax/join_OK_type4.asp';
			var SportsType    	= $('#SportsType').val();
			var EnterType   	= $('#EnterType').val();
			var Job       		= $('#Job').val();
			var PlayerReln    	= $('#PlayerReln').val();

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				data: {
					SportsType : SportsType
					,EnterType  : EnterType
					,PlayerReln : PlayerReln
					,Job      	: Job
					,Interest   : IntArr
				},
				success: function(retDATA) {

					//console.log(retDATA);

					if(retDATA){

						var strcut = retDATA.split('|');

						if (strcut[0] == 'TRUE') {
							$('.welcome_modal').modal();
						}
						else{  //FALSE|
							var msg = '';

							switch (strcut[1]) {
								case '99'   : msg = '이미 회원가입된 정보입니다.\n확인 후 다시 이용하세요.'; break;
								case '66'   : msg = '회원가입에 실패하였습니다.\n관리자에게 문의하세요.'; break;
								default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
							}
							alert(msg);
							return;
						}
					}
				},
				error: function(xhr, status, error){
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}



		// label 밑의 input 실행
		function inputExc($this){
			var ipt = $this.find('input');

			if ($this.hasClass('on')) {
				ipt.prop('checked', false);
			}
			else {
				ipt.prop('checked', true);
			}
		}

		//직업군 셀렉박스
		function make_boxJob(element, attname){
			var strAjaxUrl = '../Select/Join_Job_Select.asp';

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					element   : element
					,attname  : attname
				},
				success: function(retDATA) {
					$('#'+element).html(retDATA);
				},
				error: function(xhr, status, error){
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}

		  //리스트 관심분야
		function chk_InterestType(){
			var strAjaxUrl = '../ajax/join4_type4_interest.asp';

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {},
				success: function(retDATA) {
					$('#div_Interest').html(retDATA);
					// 실행
					$('.fav-list').tabFavList();
				},
				error: function(xhr, status, error){
					if(error!=''){
						alert ('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}

		$(document).on('click','#div_Interest li',function() {
			var cnt = 0;
			var index = $('#div_Interest li').index(this);

			$('input:checkbox[name=Interest]').each(function (i) {
				if(this.checked) cnt += 1;
			});

			if(cnt>3) {
				$('#div_Interest li:eq('+index+') a').removeClass('on');
				$('#div_Interest li:eq('+index+') a input').prop('checked', false);
				alert('관심분야는 최대 3개까지 선택할 수 있습니다.');
				return;
			}
		});


		$(document).ready(function(e) {

			//관심분야
			//make_box('sel_TeamCode','TeamCode',inputdata,'TeamCode')
			chk_InterestType();

			//직업 셀렉박스
			make_boxJob('sel_Job','Job');

		});

	</script>
</head>
<body class="join-body">

	<div class="dim"></div>
	<!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" -->
		<h1>회원가입</h1>
	</div>
	<!-- E: sub-header -->

	<!-- S: sub -->
	<div class="sub join join-2">
	  <ul class="join-step user-normal flex">
	    <li>이용약관</li>
	    <!-- <li></li> -->
	    <li class="on">회원정보</li>
	  </ul>
	  <form name="s_frm" method="post">
	    <input type="hidden" name="SportsType" id="SportsType" value="<%=SportsType%>" />
	    <input type="hidden" name="EnterType" id="EnterType" value="<%=EnterType%>" />
	    <input type="hidden" name="PlayerReln" id="PlayerReln" value="<%=PlayerReln%>" />
	    <input type="hidden" name="ViewManage" id="ViewManage" value="<%=ViewManage%>" />
	    <input type="hidden" name="Hidden_UserID" id="Hidden_UserID" />
	    <input type="hidden" name="ID_CheckYN" id="ID_CheckYN" value="N" />
	    <fieldset>
	      <legend>회원가입 입력</legend>
	      <!--
	      <ul class="join-order">
	        <li>종목</li>
	        <li> <span>:: 테니스 ::</span> </li>
	      </ul>
	      -->
	      <h2 class="title type4-header">회원 정보</h2>
	      <%=txtJoinInfo%>
	      <ul class="join-form no-m">
	        <li>
	          <p>직업<span class="compulsory">＊</span></p>
	          <p id="sel_Job" class="sel_box">
	            <select name="Job" id="Job">
	              <option value="">:: 현재 직업군 선택 ::</option>
	              <!--
	              <option value="">경영/사무/경리/회계</option>
	              <option value="">연구개발/설계</option>
	              <option value="">교직원(교수/교사/강사)</option>
	              <option value="">학생</option>
	              <option value="">미디어/방송</option>
	              <option value="">서비스/교육</option>
	              <option value="">금융</option>
	              <option value="">광고/디자인/문화/예술</option>
	              -->
	            </select>
	          </p>
	        </li>
	      </ul>
	      <!-- S: fav-list -->
	      <div class="fav-list">
	        <h3>[관심 분야]</h3>
	        <ul id="div_Interest" class="clearfix">
	          <!--
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>대진표결과</span> </a> </li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>경기기록실</span> </a> </li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>선수영상</span> </a> </li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>기록별통계</span></a></li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>선수전적</span></a></li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>대회일정</span></a></li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>커뮤니티</span></a></li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>체육관정보</span></a></li>
	          <li> <a href="#">
	            <input type="checkbox">
	            <span>기타정보</span></a></li>
	    	-->
	        </ul>
	      </div>
	      <!-- E: fav-list -->
	    </fieldset>
	  </form>
	  <div class="container">
	    <div class="btn-center"> <a href="javascript:history.back();" class="btn-left">이전</a> <a href="javascript:chk_onSubmit();" class="btn-right" data-target=".welcome_modal">다음</a> </div>
	  </div>
	</div>
	<!-- E: sub -->
	<!-- S: bot-config -->
	<!-- #include file="../include/bot_config.asp" -->
	<!-- E: bot-config -->

	<!-- S: 가입완료 모달 -->
	<!-- #include file="../include/modal/welcome.asp" -->
	<!-- E: 가입완료 모달 -->

	<script>
	    // 하단 메뉴
	    $('.bottom-menu').polyfillPositionBottom('.bottom-menu');
	    // 상단 이동 버튼 TOP
	    $('a.top_btn').polyfillPositionBottom('a.top_btn');


	  </script>
</body>
</html>
