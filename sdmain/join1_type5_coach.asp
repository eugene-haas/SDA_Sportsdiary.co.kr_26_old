<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!--#include file="./include/config.asp"-->
	<%
		'로그인이 되어있다면 메인페이지 이동
	  	'Check_NoLogin()

		dim sd_terms 		: sd_terms      	= fInject(Request("sd_terms"))
		dim privacy_terms 	: privacy_terms 	= fInject(Request("privacy_terms"))
		dim data_terms 		: data_terms    	= fInject(Request("data_terms"))
		dim EnterType   	: EnterType     	= fInject(Request("EnterType"))     '회원구분[E:엘리트 | A:생활체육]
		dim SportsType  	: SportsType    	= fInject(Request("SportsType"))    '종목구분
		dim PlayerReln  	: PlayerReln    	= fInject(Request("PlayerReln"))  	'가입자 구분
		dim UserName  		: UserName    		= fInject(Request("UserName"))
		dim UserBirth  		: UserBirth    		= fInject(Request("UserBirth"))

	'	response.Write "sd_terms="&sd_terms&"<br>"
	'	response.Write "privacy_terms="&privacy_terms&"<br>"
	'	response.Write "data_terms="&data_terms&"<br>"
	'	response.Write "EnterType="&EnterType&"<br>"
	'	response.Write "SportsType="&SportsType&"<br>"
	'	response.Write "PlayerReln="&PlayerReln&"<br>"
	'	response.End


	'  	IF sd_terms = "" OR privacy_terms = "" OR data_terms = "" OR EnterType = "" OR SportsType = "" OR PlayerReln = "" Then
	'      	Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
	'		Response.End
	'    End IF


	%>
	<script>
		function chk_onSubmit(){
			/*
			if(!$('#UserName').val()){
				alert("이름을 입력해 주세요.");
				$('#UserName').focus();
				return;
			}
			*/

			//레슨지역 시/도
			if(!$('#AreaGb').val()){
				alert("레슨지역 시/도를 선택해 주세요.");
				$('#AreaGb').focus();
				return;
			}

			//레슨지역 시/군/구
			if(!$('#AreaGbDt').val()){
				alert("레슨지역 시/군/구를 선택해 주세요.");
				$('#AreaGbDt').focus();
				return;
			}

			//레슨지역 상세주소
			if(!$('#LessonAreaDt').val()){
				alert("레슨지역 상세주소를 입력해 주세요.");
				$('#LessonAreaDt').focus();
				return;
			}

			//레슨코트명
			if(!$('#CourtNm').val()){
				alert("레슨코트명을 입력해 주세요.");
				$('#CourtNm').focus();
				return;
			}

			//소속
			if(!$('#TeamNm').val() && !$('#Team').val()){
				alert("소속 검색을 해주세요.");
				$('#TeamNm').focus();
				return;
			}

			/*
			//상호명
			if(!$('#ShopNm').val()){
				alert("상호명을 입력해 주세요.");
				$('#ShopNm').focus();
				return;
			}
			*/

			$("#s_frm").attr("action", "../tennis/M_Player/main/join4_type5.asp");
			$('#s_frm').submit();
		}

		function make_box(element, attname, code, action_type){
			//생활체육 지역조회
			if(action_type=="Join_AreaGb_A"){
				var strAjaxUrl = "../tennis/M_Player/Select/Join_AreaGb_Select_A.asp";
			}
			//생활체육 상세지역조회
			else if(action_type=="Join_AreaGbDt_A"){
				var strAjaxUrl = "../tennis/M_Player/Select/Join_AreaGbDt_Select_A.asp";
			}
			else{}

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					attname	: attname
					,code		: code
				},
				success: function(retDATA) {

				//	console.log(retDATA);

					if(retDATA){
						$("#"+element).html(retDATA);
					}

					if (retDATA == null) {
						//조회종료 효과
						alert ("조회 데이터가 없습니다!");
						return;
					}
				},
				error: function(xhr, status, error){
					if(error){
						alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
						setseq = '';
						return;
					}
				}
			});
		}

		//소속정보 입력 자동완성 기능
	  	function FND_TeamInfo(val, valName, valCode, sObj, keycode){

			var strAjaxUrl = "./ajax/user_divn_coach.asp";
	    	var Fnd_KeyWord = val.replace(/ /g, '');    		//클럽명 공백제거

			var Fnd_TeamNm = valName.id;
			var chk_Team = '';			//소속2 검색시 소속1과 중복되는지 체크

			/*
			if(Fnd_TeamNm == "TeamNm2"){
				if(!$('#TeamNm').val()) {
					alert("소속1 검색을 진행하세요.");
					$('#'+Fnd_TeamNm).val('');
					$('#'+valCode).val('');
					$('#TeamNm').focus();
					return;
				}
				else{
					chk_Team = $('#Team').val()	;
				}
			}
			*/

	  		//방향키 keydown/keyup시 조회안되게(키포커스 이동 막음)
			if(keycode==37||keycode==38||keycode==39||keycode==40){	}
			else{

				$.ajax({
					url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',
					data: {
						Fnd_KeyWord : Fnd_KeyWord
						,Fnd_TeamNm : Fnd_TeamNm	//TeamNm
						,Fnd_Team 	: valCode		//Team
						,chk_Team	: chk_Team		//소속2 검색시 소속1과 중복되는지 체크
						,sObj		: sObj			//view list id
					},
					success: function(retDATA) {

						//console.log(retDATA);

						$('#'+sObj).children().remove();
						$('#'+sObj).append(retDATA);

						//console.log($('#'+sObj+'_'+valCnt).children().length);

						if ($('#'+sObj).children().length > 0) {
							$('#'+sObj).show();
						}
						else {
							$('#'+sObj).hide();
						}
					},
					error: function(xhr, status, error){
						if(error!=""){
							alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
							return;
						}
					}
				});
			}
		}

		//소속정보 조회 후 Input 필드에 넣기
		function Info_InputData(valObj, valCode, valObjNm, valName, sObj){
			console.log(valObj + "=" + valCode);
			console.log(valObjNm + "=" + valName);

			$('#'+valObj).val(valCode);
			$('#'+valObjNm).val(valName);

			$('#'+sObj).hide();
		}

		//상세지역 조회 셀렉박스 생성
		function chk_AreaGbDt(code){
			make_box("sel_AreaGbDt", "AreaGbDt", code, "Join_AreaGbDt_A");
		}

		$(document).ready(function(){
			make_box("sel_AreaGb","AreaGb","","Join_AreaGb_A");
		});


	</script>
</head>
<body>
<div class="l">

	<div class="l_header">
	  <div class="m_header s_sub">
	    <!-- #include file="./include/header_back.asp" -->
	    <h1 class="m_header__tit">회원구분 정보</h1>
	    <!-- #include file="./include/header_home.asp" -->
	  </div>
	</div>

	<div class="l_content m_scroll [ _content _scroll ]">

	  <!-- S: main -->
	  <div class="main user_divn pack">
	    <form name="s_frm" id="s_frm" method="post">

	        <input type="hidden" id="sd_terms" name="sd_terms" value="<%=sd_terms%>" />
	        <input type="hidden" id="privacy_terms" name="privacy_terms" value="<%=privacy_terms%>" />
	        <input type="hidden" id="data_terms" name="data_terms" value="<%=data_terms%>" />
	        <input type="hidden" id="EnterType" name="EnterType" value="<%=EnterType%>" />
	        <input type="hidden" id="SportsType" name="SportsType" value="<%=SportsType%>" />
	        <input type="hidden" id="PlayerReln" name="PlayerReln" value="<%=PlayerReln%>" />
	        <input type="hidden" id="UserBirth" name="UserBirth" value="<%=UserBirth%>" />
	        <input type="hidden" id="Team" name="Team" />

	      <!-- S: input-list -->
	      <div class="input-list">
	        <ul>
	          <li>
	            <p>테니스 생활체육(동호인) 지도자(코치)</p>
	          </li>
	          <li class="txt_guide">
	            <p>※ 레슨정보는 추후 스포츠다이어리에서 제공하는 레슨회원모집 매칭 서비스 외 다양한 서비스 이용 시 사용됩니다.</p>
	          </li>
	          <li>
	            <label>
	              <input type="text" class="input-control" id="UserName" name="UserName" placeholder="이름" value="<%=UserName%>" readonly />
	            </label>
	            <!--<p class="text-warning">특수문자, 숫자를 사용할 수 없습니다.</p>-->
	          </li>
	          <li class="sel_box" id="sel_AreaGb">
	            <select id="AreaGb" name="AreaGb">
	              <option value="">시/도 선택</option>
	            </select>
	          </li>
	          <li class="sel_box" id="sel_AreaGbDt">
	            <select id="AreaGbDt" name="AreaGbDt">
	              <option value="">시/군/구 선택</option>
	            </select>
	          </li>
	          <li>
	          <input type="text" class="input-control" id="LessonAreaDt" name="LessonAreaDt" placeholder="레슨지역 상세주소" />
	          <!--
	            <select id="LessonAreaDt" name="LessonAreaDt">
	              <option>레슨지역 상세주소 입력</option>
	            </select>
	            -->
	          </li>
	          <li>
	          <input type="text" class="input-control" id="CourtNm" name="CourtNm" placeholder="레슨코트명" />
	          <!--
	            <select id="CourtNm" name="CourtNm">
	              <option>레슨코트명 입력</option>
	            </select>
	            -->
	          </li>
	          <li>
	           <label>
	                <input type="text" class="input-control" id="TeamNm" name="TeamNm" placeholder="소속 검색" onKeyUp="FND_TeamInfo(this.value, this, 'Team', 'ClubNm', event.keyCode);" />
	              </label>
	              <!-- S: 검색어 자동 완성 보이기 -->
	              <ul class="srch_res_list show_list" id="ClubNm">
	              <!--
	                <li><a href="#">강남스타일</a></li>
	                <li><a href="#">영업부</a></li>
	                <li><a href="#">오락부</a></li>
	                <li><a href="#">강남스타일</a></li>
	                <li><a href="#">영업부</a></li>
	                <li><a href="#">오락부</a></li>
	                -->
	              </ul>
	              <!-- E: 검색어 자동 완성 보이기 -->
	              <!--
	            <label>
	              <input type="text" id="TeamNm" name="TeamNm" placeholder="소속검색">
	            </label>
	            -->
	          </li>
	          <li class="team_choice">
	            선택사항
	          </li>
	          <li>
	            <label>
	              <input type="text" class="input-control" id="ShopNm" name="ShopNm" placeholder="상호명 입력">
	            </label>
	          </li>
	        </ul>
	      </div>
	      <!-- E: input-list -->
	    </form>

	    <!-- S: small_link -->
	    <!-- <div class="small_link">
	      <a href="./fnd_pwd.asp" class="btn btn-link">
	        <span>신규 소속 생성 요청</span>
	        <span class="triangle"></span>
	      </a>
	    </div> -->
	    <!-- E: small_link -->

	  </div>
	  <!-- E: main -->

	  <!-- S: user_agree_info -->
	  <div class="user_agree_info">
	        <!-- S: guide_txt -->
	    <div class="guide_txt">
	      <ul>
	        <li>
	          <p>소속을 잘못 선택하여 가입할 경우 해당소속으로 대회참 가에 불이익 혹은 소속팀의 다양한 정보를 받지 못할 수 있으니, 소속선택은 반드시 신중히 선택하여 주시기 바랍 니다.</p>
	        </li>
	        <li>
	          <p>본인의 소속이 없을 경우 <u><a href="./req_club.asp">신규소속생성요청</a></u> 게시판을 이용하여 신청해주시기 바랍니다.</p>
	        </li>
	        <li>
	          <p>엘리트선수(또는 선수출신)의 생활체육대회 참가가 불가 합니다. 선수이력이 있는 회원이 순수 아마추어 종별의 경기에 참가한 현장을 적발 하였을 경우 메달 박탈은 물론 이후 대회참가여부에 큰 영향을 미칠 수 있음을 알려드립 니다.</p>
	        </li>
	      </ul>
	    </div>
	    <!-- E: guide_txt -->
	  </div>
	  <!-- E: user_agree_info -->

	  <div class="cta">
	    <a href="javascript:chk_onSubmit();" class="btn btn-ok btn-block btn_chk_account">다음</a>
	  </div>

	</div>
  <!-- #include file="./include/footer.asp"-->

</div>
</body>
</html>
