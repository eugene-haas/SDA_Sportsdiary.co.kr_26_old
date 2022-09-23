<!DOCTYPE html>
<html lang="ko">
<head>
  ﻿<!-- S: config -->
  <!-- #include file="../include/config.asp" -->
  <!-- #include file='../include/css/join_style.asp' -->
  <link rel="stylesheet" href="/front/css/join/join3_type3_userInfo.css">
  <!-- E: config -->
  <%
  	'=================================================================
  	'STEP3
  	'선수보호자 회원가입[A, B, Z]
  	'=================================================================
     	dim UserName      	: UserName        	= fInject(Request("UserName"))
  	dim UserBirth     	: UserBirth       	= decode(fInject(Request("UserBirth")),0)

  	dim sd_child    	: sd_child        	= fInject(Request("sd_child"))  	'자녀선수의 정보확인 동의
  	dim SportsType    	: SportsType      	= fInject(Request("SportsType"))    '종목구분
  	dim EnterType     	: EnterType       	= fInject(Request("EnterType"))     '회원구분[E:엘리트 | A:생활체육]
  	dim PlayerReln    	: PlayerReln      	= fInject(Request("PlayerReln"))    '가입자 구분

  	'선수정보
  	dim PlayerIDX    	: PlayerIDX     	= fInject(Request("PlayerIDX"))     'PlayerIDX
  	dim PlayerID    	: PlayerID      	= fInject(Request("PlayerID"))
  	dim PlayerName    	: PlayerName    	= fInject(Request("PlayerName"))
  	'dim PlayerBirth   	: PlayerBirth     	= fInject(Request("PlayerBirth"))
  	dim PlayerSEX     	: PlayerSEX     	= fInject(Request("PlayerSEX"))
  	dim PlayerPhone   	: PlayerPhone     	= fInject(Request("PlayerPhone"))
  	dim Team      		: Team          	= fInject(Request("Team"))        '소속코드
  	dim Team2     		: Team2         	= fInject(Request("Team2"))       '소속코드2
  	dim TeamNm     	 	: TeamNm          	= fInject(Request("TeamNm"))      '소속명
  	dim TeamNm2     	: TeamNm2         	= fInject(Request("TeamNm2"))     '소속명2


  	IF  sd_child = "" OR SportsType = "" OR EnterType = "" OR UserBirth = "" OR UserName = "" OR Team = "" OR PlayerIDX = "" Then
  		Response.Write "<script>"
  		Response.Write "	alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.');"
  		Response.Write "	history.back();"
  		Response.Write "</script>"
  		Response.End
  	End IF

  	dim PlayerTeam 		: PlayerTeam 		= TeamNm
  	'소속2팀이 있는 경우
  	IF TeamNm2 <> "" Then PlayerTeam = PlayerTeam &" / "& TeamNm2

  '	dim cnt_JoinMember	: cnt_JoinMember 	= CHK_JOINUS(UserName, UserBirth)			'통합ID계정 있는지 체크
  	dim txtJoinInfo 	: txtJoinInfo		= INFO_JOINUS_MEMBER(UserName, UserBirth)	'통합회원 정보 출력


  %>
  <script type="text/javascript">

  	//maxlength 체크
  	function maxLengthCheck(object){
  		if (object.value.length > object.maxLength){
  			object.value = object.value.slice(0, object.maxLength);
  		}
  	}

    	//회원가입항목 체크
   	function chk_frm(){
  		//선수와의 관계
  		if(!$('input:radio[name=PlayerReln]').is(':checked')){
  			alert('선수와의 관계를 선택해 주세요.');
  			return;
  		}
  		else{
  			if($('input:radio[name=PlayerReln]:checked').val()=='Z' && $('#PlayerRelnMemo').val()==''){
  				alert('선수와의 관계를 입력해 주세요.');
  				$('#PlayerRelnMemo').focus();
  				return;
  			}
  		}

  		var strAjaxUrl     	= '../Ajax/join_OK_type3.asp';
  		var SportsType    	= $('#SportsType').val();
  		var EnterType   	= $('#EnterType').val();
  		var PlayerReln    	= $('input:radio[name=PlayerReln]:checked').val();
  		var PlayerRelnMemo 	= $('#PlayerRelnMemo').val();
  		var PlayerIDX      	= $('#PlayerIDX').val();
  		var PlayerPhone    	= $('#PlayerPhone').val();
  		var Team      		= $('#Team').val();
  		var Team2     		= $('#Team2').val();
  		var TeamNm      	= $('#TeamNm').val();
  		var TeamNm2     	= $('#TeamNm2').val();

  		$.ajax({
  			url: strAjaxUrl,
  			type: 'POST',
  			dataType: 'html',
  			data: {
  				SportsType   	: SportsType
  				,EnterType    	: EnterType
  				,PlayerReln   	: PlayerReln
  				,PlayerIDX    	: PlayerIDX
  				,PlayerPhone  	: PlayerPhone
  				,PlayerRelnMemo : PlayerRelnMemo
  				,Team     		: Team
  				,Team2      	: Team2
  				,TeamNm     	: TeamNm
  				,TeamNm2    	: TeamNm2
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

  	//선수와의 관계 radio버튼 체크
  	function Chk_RadioBtn(){

  		if($('input:radio[name=PlayerReln]:checked').val()!='Z') {
  			$('#PlayerRelnMemo').attr('disabled',true);//비활성화 설정
  			$('#PlayerRelnMemo').val('');
  		}
  		else{
  			$('#PlayerRelnMemo').attr('disabled',false);
  		}
  	}

  	$(document).ready(function(e) {
  		// 원하는 값(A)을 체크
  		$('input:radio[name=PlayerReln]:radio[value=A]').attr('checked', true);
  		//선수와의 관계 비활성화
  		$('#PlayerRelnMemo').attr('disabled',true); //설정
  		$('#PlayerRelnMemo').val('');
  	});

  </script>
</head>
<body>
  <div class="dim"></div>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>회원가입</h1>
  </div>
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub join join-2">
    <ul class="join-step flex">
      <li>이용약관</li>
      <li>가입자정보</li>
      <li class="on">회원정보</li>
    </ul>
    <form name="s_frm" method="post" class="conf_player_info">
      <input type="hidden" name="SportsType" id="SportsType" value="<%=SportsType%>" />
      <input type="hidden" name="EnterType" id="EnterType" value="<%=EnterType%>" />
      <input type="hidden" name="PlayerIDX" id="PlayerIDX" value="<%=PlayerIDX%>" />
      <input type="hidden" name="PlayerPhone" id="PlayerPhone" value="<%=PlayerPhone%>" />
      <input type="hidden" name="Team" id="Team" value="<%=Team%>" />
      <input type="hidden" name="Team2" id="Team2" value="<%=Team2%>" />
      <input type="hidden" name="TeamNm" id="TeamNm" value="<%=TeamNm%>" />
      <input type="hidden" name="TeamNm2" id="TeamNm2" value="<%=TeamNm2%>" />
      <input type="hidden" name="PlayerTeam" id="PlayerTeam" value="<%=PlayerTeam%>" />
      <fieldset>
        <legend>회원가입 입력</legend>
        <ul class="join-order">
          <li>종목</li>
          <li> <span>:: 테니스 ::</span> </li>
        </ul>
        <h2>선수 개인정보</h2>
        <ul class="join-form">
          <li>
            <p>선수와의 관계<span class="compulsory">＊</span></p>
            <div class="parents-select">
              <input type="radio" name="PlayerReln" id="PlayerReln" value="A" onClick="Chk_RadioBtn();" checked />
              <label for="joinMan">부</label>
              <input type="radio" name="PlayerReln" id="PlayerReln" value="B" onClick="Chk_RadioBtn();" />
              <label for="joinWoMan">모</label>
              <input type="radio" name="PlayerReln" id="PlayerReln" value="Z" onClick="Chk_RadioBtn();" />
              <label for="joinMan">기타</label>
              <input type="text" name="PlayerRelnMemo" id="PlayerRelnMemo" placeholder="예)이모"  disabled />
            </div>
          </li>
          <li>
            <p>이름</p>
            <p><%=PlayerName%></p>
          </li>
          <!--
          <li>
            <p>생년월일</p>
            <p><%=PlayerBirth%> ( <%=PlayerSEX%> )</p>
          </li>
  		 -->
          <li>
            <p>성별</p>
            <p><%=PlayerSEX%></p>
          </li>
          <li>
            <p>소속</p>
            <p><%=PlayerTeam%></p>
          </li>
        </ul>
        <h2>회원 정보</h2>
        <%=txtJoinInfo%>
      </fieldset>
    </form>
    <div class="container">
      <div class="btn-center"> <a href="javascript:history.back();" class="btn-left">이전</a> <a href="javascript:chk_frm();" class="btn-right" data-target=".welcome_modal">다음</a> </div>
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
