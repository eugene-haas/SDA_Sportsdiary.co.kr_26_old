<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!-- #include file='./include/config.asp' -->
	<%
	   	'================================================================================================
		'계정추가(종목별 회원계정추가) 페이지
	   	'1. 회원로그인 후 이용가능
		'2. 접근 권한
	   	' 	1) 통합회원 가입 후 계정추가 btn 클릭시
		'	2) 각 종목별 Gnb영역 or 마이페이지에서 계정추가 btn 클릭시
	   	'================================================================================================
		dim SD_UserID		: SD_UserID     = Request.Cookies("SD")("UserID")
		dim SD_UserName    	: SD_UserName   = Request.Cookies("SD")("UserName")
		dim SD_MemberIDX   	: SD_MemberIDX	= decode(Request.Cookies("SD")("MemberIDX"), 0)
		dim SD_UserBirth   	: SD_UserBirth  = decode(Request.Cookies("SD")("UserBirth"), 0)

		'각 종목 Gnb영역에서 계정추가를 할 경우 종목값 전달받음
		'   - 통합회원 가입 후 계정추가의 경우는 종목값 없음.
		dim SportsType    : SportsType    = Request("SportsType")


	'	UserID = "player11"
	'	UserName = "김우람"
	'	MemberIDX = "190"
	'	UserBirth = "19990101"

	'	response.write "UserID="&UserID&"<br>"
	'	response.write "UserName="&UserName&"<br>"
	'	response.write "MemberIDX="&MemberIDX&"<br>"
	'	response.write "UserBirth="&UserBirth&"<br>"


		IF SD_UserID = "" OR SD_UserName = "" OR SD_UserBirth = "" OR SD_MemberIDX = "" Then
			Response.Write "<script>"
	 		Response.Write "	alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.');"
			Response.Write "	history.back();"
			Response.Write "</script>"
			Response.End
		End IF
	%>
	<script type="text/javascript">

		//회원구분 선택
		function MemberType_Select(valSportsType, valStep, valMemType){
			var strURL = '';

	    	switch(valStep){
	      		//종목구분    [유도 | 테니스 | 자전거]
	      		case 'sel_SportsType' :
					$('#SportsType').val(valSportsType);
					$('#EnterType').val('');
					$('#PlayerReln').val('');

	        		//selector output
	        		MemberType_Select_Act(valSportsType, valStep, valMemType);
	        		break;

				//회원구분    [선수 | 지도자 | 보호자 | 일반]
				case 'sel_MemberType':
					$('#PlayerReln').val(valMemType);

					if(valMemType=='D') { //일반
						switch(valSportsType){
							case 'judo'   	: strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join4_type4.asp'; break; //선수, 지도자, 보호자, 일반
							case 'tennis'   : strURL = 'http://tennis.sportsdiary.co.kr/tennis/M_Player/Main/join1_type4_userInfo.asp'; break; //선수, 지도자, 보호자, 일반
							//case 'bike'     : strURL = '없음'; break; //선수, 보호자
						}
						//회원가입페이지 이동
						on_Submit(strURL);
					}
					else{
						//selector output
						MemberType_Select_Act(valSportsType, valStep, valMemType);
					}
					break;

	      		//가입구분    [엘리트 | 생활체육]
	      		case 'sel_EnterType' :
	        		$('#EnterType').val(valMemType);

	        		if(valMemType=='E') {
						switch($('#PlayerReln').val()){
							case 'P' : //엘리트 보호자
								switch(valSportsType){
									case 'judo'   	: strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join3_type3.asp'; break;
									//case 'tennis' : strURL = '없음'		//http://tennis.sportsdiary.co.kr/tennis/M_Player/Main/join1_type3_userInfo.asp'; break;
									//case 'bike'   : strURL = '없음'		//http://bike.sportsdiary.co.kr/bike/M_Player/Main/join1_type3_search_child.asp'; break;
								}
								on_Submit(strURL);    //회원가입페이지 이동
								break;

							case 'T' : //엘리트 지도자
								switch(valSportsType){
									case 'judo'   	: strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join3_type7.asp'; break;
									//case 'tennis'     : strURL = '없음'; break; //지도자
									//case 'bike'     	: strURL = '없음'; break; //지도자
								}
								on_Submit(strURL);    //회원가입페이지 이동
								break;

							case 'R' : //엘리트 선수 다음단계 이동
								//selector output
								MemberType_Select_Act(valSportsType, valStep, valMemType);
								break;
						}
	        		}
	        		else{ //생활체육
						switch($('#PlayerReln').val()){
							case 'P' : //생활체육 보호자
								switch(valSportsType){
									case 'judo'   	: strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join3_type3.asp'; break;
									case 'tennis'   : strURL = 'http://tennis.sportsdiary.co.kr/tennis/M_Player/Main/join1_type3_search_child.asp'; break;
									case 'bike'   	: strURL = 'http://bike.sportsdiary.co.kr/bike/M_Player/Main/join1_type3_search_child.asp'; break;
								}
								break;

							case 'T' :  //생활체육 지도자
								switch(valSportsType){
									case 'judo'   	: strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join3_type5.asp'; break;
									case 'tennis'   : strURL = 'http://tennis.sportsdiary.co.kr/tennis/M_Player/Main/join1_type5_coach.asp'; break;
									//case 'bike'     : strURL = '없음'; break; //지도자
								}
								break;

							case 'R' : //생활체육 선수
								switch(valSportsType){
									case 'judo'   	: strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join3_type5.asp'; break;
									case 'tennis'   : strURL = 'http://tennis.sportsdiary.co.kr/tennis/M_Player/Main/join1_type5_player.asp'; break;
									case 'bike'   	: strURL = 'http://bike.sportsdiary.co.kr/bike/M_Player/Main/join1_type5_userInfo.asp'; break;
								}
								break;
						}
						on_Submit(strURL);    //회원가입페이지 이동
	        		}
	       			break;

	      		//선수구분[Ⅰ] 선택  [대한체육회 등록선수 | 대한체육회 비등록선수]
	      		case 'sel_PlayerType' :
	       			$('#PlayerReln').val(valMemType);

	        		if(valMemType=='K') { //비등록선수
	         			//selector output
	          			MemberType_Select_Act(valSportsType, valStep, valMemType);
	        		}
	        		else{ //등록선수
	          			switch(valSportsType){
	            			case 'judo'   : strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join3_type1.asp'; break;
							//case 'tennis'   : strURL = '없음'; break;
	            			//case 'bike'     : strURL = '없음'; break;
	          			}
	          			on_Submit(strURL);    //회원가입페이지 이동
	        		}
	       			break;

	      		//선수구분[Ⅱ] 선택  [대한체육회 선수등록 유경험 | 대한체육회 선수등록 무경험]
	      		case 'sel_PlayerType_Ex' :
	        		$('#PlayerReln').val(valMemType);

	        		switch(valSportsType){
	          			case 'judo'   : strURL = 'http://judo.sportsdiary.co.kr/M_Player/Main/join3_type2.asp'; break; //선수등록 유/무경험
	          			//case 'tennis'   : strURL = '없음'; break;
	          			//case 'bike'     : strURL = '없음'; break;
	        		}
	        		on_Submit(strURL);   //회원가입페이지 이동
	        		break;
	    		}
	  		}

	  	//회원구분 선택 후 종목별 계정추가 페이지로 이동합니다.
	  	function on_Submit(valURL){
			$('#s_frm').attr('action', valURL);
			$('#s_frm').submit();
	  	}


		var showIdx = 0;  /* step 처음 보여질 section */

		function joinStepNext(tg) {
			var $tg = $(tg); /* tg = .form-group */
			var $step = $(".step", $tg);
			var $stepList = $(".step-list", $step);
			var $btnList = $(".btn-list", $stepList);
			var $selectedStep = $step.eq(showIdx);

			$selectedStep.hide();
			showIdx++;
			$selectedStep = $step.eq(showIdx);
			if ($selectedStep.find(".step-list").children().length < 1) {
				return;
			}
			$selectedStep.show();
		}

		function joinStepPrev(tg) {
			var $btnPrev = $(tg); /* tg = .btn-prev */
			var $step = $(".step");
			var $selectedStep = $btnPrev.parents(".step");

			$selectedStep.hide();
			showIdx--;
			$selectedStep = $step.eq(showIdx);
			$selectedStep.show();
		}

		//회원구분 Selector 출력합니다.
		function MemberType_Select_Act(valSportsType, valStep, valMemType){
			var strAjaxUrl = './ajax/join_MemberTypeGb.asp';

			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',
				data: {
					valSportsType   : valSportsType
					,valStep    	: valStep
					,valMemType   	: valMemType
				},
				success: function(retDATA) {

					console.log(retDATA);

					if(retDATA){
						var strcut = retDATA.split('|');

						if (strcut[0]=='TRUE') {

							switch(valStep){
								case 'sel_SportsType'   : $('#sel_MemberType').html(strcut[1]); break;      //회원구분
								case 'sel_MemberType'   : $('#sel_EnterType').html(strcut[1]); break;       //가입구분
								case 'sel_EnterType'  : $('#sel_PlayerType').html(strcut[1]); break;      //선수구분1
								case 'sel_PlayerType'   : $('#sel_PlayerType_Ex').html(strcut[1]); break;   //선수구분2
							}
							joinStepNext(".form-group");
						}
						else{
							alert('잘못된 접근입니다.\n확인 후 다시 이용하세요.');
							return;
						}
					}
				},
				error: function(xhr, status, error){
					if(error){
						alert('오류발생! - 시스템관리자에게 문의하십시오!');
						return;
					}
				}
			});
		}

		$(document).ready(function(){
		<%
		'	IF SportsType <> "" Then
		'   	response.write "alert('"&SportsType&"');"
		'     	response.write "MemberType_Select('"&SportsType&"','sel_SportsType');"
		'   End IF
		%>
		});
	</script>
</head>
<body>
<div class="l">

	<div class="l_header">

		<div class="m_header s_sub">
	    <!-- #include file="./include/header_back.asp" -->
	    <h1 class="m_header__tit">계정추가 가입자 정보</h1>
	    <!-- #include file="./include/header_home.asp" -->
	  </div>

	</div>


	<div class="l_content m_scroll [ _content _scroll ]">
		<form name="s_frm" id="s_frm" method="post">
		  <input type="hidden" name="SportsType" id="SportsType" value="<%=SportsType%>">
		  <input type="hidden" name="EnterType" id="EnterType">
		  <input type="hidden" name="PlayerReln" id="PlayerReln">
		  <input type="hidden" name="UserName" id="UserName" value="<%=UserName%>">
		  <input type="hidden" name="UserBirth" id="UserBirth" value="<%=UserBirth%>">

		  <!-- S: main -->
		  <div class="main user_info pack">

		    <!-- S: form-group -->
		    <div class="form-group clearfix">
		      <!-- S: step step-1 -->
		      <section class="step step-1">
		        <h3>종목을 선택해 주세요.</h3>
		        <!-- S: step-list -->
		        <ul id="sel_SportsType" class="step-list">
		          <li><a href="javascript:MemberType_Select('judo','sel_SportsType','');" class="btn btn-list">유도</a></li>
		          <!--종목계정 사용안함
		          <li><a href="javascript:MemberType_Select('tennis','sel_SportsType','');" class="btn btn-list">테니스</a></li>

		          <li><a href="javascript:MemberType_Select('bike','sel_SportsType','');" class="btn btn-list">자전거</a></li>
		           -->
		          <!--<li><a href="#" class="btn btn-list">배드민턴</a></li>-->
		        </ul>
		        <!-- E: step-list -->
		      </section>
		      <!-- E: step step-1 -->

		      <!-- S: step step-2 -->
		      <section class="step step-2">
		        <h3>회원구분을 선택해 주세요.</h3>
		        <a href="#" onclick="joinStepPrev(this);" class="btn btn-prev btn-info">
		          <i class="fa fa-arrow-left"></i>
		          <span class="txt">이전</span>
		        </a>
		        <!-- S: step-list -->
		        <ul id="sel_MemberType" class="step-list">
		          <!--
		      <li><a href="#" class="btn btn-list">선수</a></li>
		          <li><a href="#" class="btn btn-list">지도자</a></li>
		          <li><a href="#" class="btn btn-list">보호자</a></li>
		          <li><a href="#" class="btn btn-list">일반</a></li>
		    -->
		        </ul>
		        <!-- E: step-list -->
		      </section>
		      <!-- E: step step-2 -->

		      <!-- S: step step-3 -->
		      <section class="step step-3 type-a">
		        <h3>가입구분을 선택해 주세요.</h3>
		        <a href="#" onclick="joinStepPrev(this);" class="btn btn-prev btn-info">
		          <i class="fa fa-arrow-left"></i>
		          <span class="txt">이전</span>
		        </a>
		        <!-- S: step-list -->
		        <ul id="sel_EnterType" class="step-list">
		          <!--
		          <li><a href="#" class="btn btn-list">엘리트</a></li>
		          <li><a href="#" class="btn btn-list">생활체육</a></li>
		      -->
		        </ul>
		        <!-- E: step-list -->
		      </section>
		      <!-- E: step step-3 type-a -->

		      <!-- S: step step-3 type-b -->
		      <section class="step step-3 type-b">
		        <h3>선수구분[Ⅰ]을 선택해 주세요.</h3>
		        <a href="#" onclick="joinStepPrev(this);" class="btn btn-prev btn-info">
		          <i class="fa fa-arrow-left"></i>
		          <span class="txt">이전</span>
		        </a>
		        <!-- S: step-list-->
		        <ul id="sel_PlayerType" class="step-list">
		          <!--
		          <li><a href="#" class="btn btn-list">대한체육회 등록선수</a></li>
		          <li><a href="#" class="btn btn-list">대한체육회 비등록선수</a></li>
		    -->
		        </ul>
		        <!-- E: step-list-->
		      </section>
		      <!-- E: step step-3 type-b -->

		      <!-- S: step step-4 -->
		      <section class="step step-4 final">
		        <h3>선수구분[Ⅱ]을 선택해 주세요.</h3>
		        <a href="#" onclick="joinStepPrev(this);" class="btn btn-prev btn-info">
		          <i class="fa fa-arrow-left"></i>
		          <span class="txt">이전</span>
		        </a>
		        <!-- S: step-list -->
		        <ul id="sel_PlayerType_Ex" class="step-list">
		          <!--
		          <li><a href="#" class="btn btn-list">대한체육회 선수등록 유경험</a></li>
		          <li><a href="#" class="btn btn-list">대한체육회 선수등록 무경험</a></li>
		      -->
		        </ul>
		        <!-- E: step-list -->
		      </section>
		      <!-- E: step step-4 -->
		    </div>
		    <!-- E: form-group -->

		    <!-- S: small_link -->
		    <div class="small_link"> <a href="#" class="btn btn-link" data-toggle="modal" data-target="#member-type-guide"> <span class="ic_deco"><i class="fa fa-info-circle"></i></span> <span>회원가입 기준 안내</span> <span class="triangle"></span> </a> </div>
		    <!-- E: small_link -->
		    <!--
		    <div class="cta">
		      <a href="javascript:chk_Submit();" class="btn btn-ok btn-block">다음</a>
		    </div>
		  -->
		  </div>
		  <!-- E: main -->
		</form>
	</div>

	<!-- S: 회원가입 기준 안내 모달 -->
	<div class="modal fade confirm-modal member-type-guide gb-modal" id="member-type-guide">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="confirm-modal" onClick="$('#member-type-guide').modal('hide');"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">회원가입 기준 안내</h4>
	      </div>
	      <div class="modal-body member-type-guide">
					<div role="tabpanel" class="gb-tab">
						<!-- Nav tabs -->
						<ul class="nav nav-tabs" role="tablist">
							<li role="presentation" class="active"><a href="#gb-tab1" aria-controls="gb-tab1" role="tab" data-toggle="tab">선수</a></li>
							<li role="presentation"><a href="#gb-tab2" aria-controls="gb-tab2" role="tab" data-toggle="tab">지도자</a></li>
							<li role="presentation"><a href="#gb-tab3" aria-controls="gb-tab3" role="tab" data-toggle="tab">보호자</a></li>
							<li role="presentation"><a href="#gb-tab4" aria-controls="gb-tab4" role="tab" data-toggle="tab">일반</a></li>
						</ul>

						<!-- Tab panes -->
						<div class="tab-content">
							<!-- s: 선수 -->
							<div role="tabpanel" class="tab-pane active" id="gb-tab1">
								<h4><i class="fa fa-caret-right"></i>선수구분</h4>
								<p class="t-title"><span>1. 엘리트 선수</span><span>2. 생활체육(동호인)</span></p>
								<p class="blue-txt">1.엘리트선수 : 대한체육회 등록선수, 비등록 선수로 구분</p>
								<ul>
									<li>
									 <span class="l-number">1)</span>
									 <span class="r-txt">
										대한체육회 등록선수<br>
									 </span>
									</li>
									<li>
									 <span class="l-number">-</span>
									 <span class="r-txt">
										현재 년도 대한체육회 등록된 선수 (이전 년도에 등록된 선수는 해당 없음)
									 </span>
									</li>
									<li>
									 <span class="l-number">2)</span>
									 <span class="r-txt">
										대한체육회 비등록선수
									 </span>
									</li>
									<li>
									 <span class="l-number">-</span>
									 <span class="r-txt">
										대한체육회에 선수등록 이력이 없으나 엘리트 소속팀에서 훈련하고 있는 선수
									 </span>
									</li>
									<li>
									 <span class="l-number">-</span>
									 <span class="r-txt">
										이전 년도에 등록이력이 있지만 현재 대한체육회에 등록이 안되어 엘리트 소속팀에서 훈련하고 있는 선수
									 </span>
									</li>
									<li>
									 <span class="l-number">※</span>
									 <span class="r-txt">
										엘리트 선수 대회에 출전이 불가한 상태 이므로 본인의 대회 기록정보는 없음
									 </span>
									</li>
									<div class="h-20"></div>
									<li class="blue-txt">
									 <span class="l-number">2.</span>
									 <span class="r-txt">
										생활체육(동호인)
									 </span>
									</li>
									<li>
									 <span class="l-number">-</span>
									 <span class="r-txt">
										희망하는 종목에서 생활체육 활동을 하고있는 아마추어 동호인
									 </span>
									</li>
									<li>
									 <span class="l-number">-</span>
									 <span class="r-txt">
										협회에서 정한 절차에 따라 동호인 부에 동호인 등록을 마친 자
									 </span>
									</li>
									<li>
									 <span class="l-number">※</span>
									 <span class="r-txt">
										유도 : 전국 사설도장 및 클럽으로 등록 된 소속으로 가입해야 함
									 </span>
									</li>
								</ul>
							</div>
							<!-- e: 선수 -->
							<!-- s: 지도자 -->
							<div role="tabpanel" class="tab-pane" id="gb-tab2">
								<h4><i class="fa fa-caret-right"></i>지도자 구분</h4>
								<p class="t-title"><span>1. 엘리트 지도자</span><span>2. 생활체육 지도자</span></p>
								<ul>
									<li class="blue-txt">
									 <span class="l-number">1.</span>
									 <span class="r-txt">
										엘리트지도자: 대한체육회 등록된 선수지도자
									 </span>
									</li>
									<li class="blue-txt">
									 <span class="l-number">2.</span>
									 <span class="r-txt">
										생활체육(동호인)지도자:  생활체육(동호인)  지도자<br><br>
									 </span>
									</li>
									<li>
									 <span class="l-number">※</span>
									 <span class="r-txt">
										 유도:  생활체육대회참가신청가능
									 </span>
									</li>
								</ul>
							</div>
							<!-- e: 지도자 -->
							<!-- s: 보호자 -->
							<div role="tabpanel" class="tab-pane" id="gb-tab3">
								<h4><i class="fa fa-caret-right"></i>보호자 구분</h4>
								<p class="t-title"><span>1. 엘리트 보호자</span><span>2. 생활체육 보호자</span></p>
								<ul>
									<li>
									 <span class="l-number">※</span>
									 <span class="r-txt">
										선수 및 동호인이 스포츠다이어리 APP에 회원가입이 되어있어야 보호자 계정가입이 가능함
									 </span>
									</li>
									<li>
									 <span class="l-number">※</span>
									 <span class="r-txt">
										각 선수 및 생활체육(동호인) 개인의 선택의 따라 공유된 훈련정보 조회가능
									 </span>
									</li>
									<li class="blue-txt">
									 <span class="l-number">1.</span>
									 <span class="r-txt">
										엘리트보호자: 대한체육회등록선수, 비등록선수의 학부모, 친척 관계의 보호자여야 함
									 </span>
									</li>
									<li class="blue-txt">
									 <span class="l-number">2.</span>
									 <span class="r-txt">
										생활체육(동호인)보호자: 생활체육(동호인)의 보호자
									 </span>
									</li>
								</ul>
							</div>
							<!-- e: 보호자 -->
							<!-- s: 일반 -->
							<div role="tabpanel" class="tab-pane" id="gb-tab4">
								<h4><i class="fa fa-caret-right"></i>일반</h4>
								<p class="t-title">스포츠다이어리 회원가입시 기본 계정</p>
								<ul>
									<li>
									 <span class="l-number">※</span>
									 <span class="r-txt">
										 선수, 생활체육(동호인), 지도자, 보호자에 해당할 경우 ‘계정추가’로 이용
									 </span>
									</li>
									<li>
									 <span class="l-number">※</span>
									 <span class="r-txt">
										선수 및 생활체육(동호인)의 훈련정보 열람 및 지도자와 상담이 불가한 기본계정임
									 </span>
									</li>
								</ul>
							</div>
							<!-- e: 일반 -->
						</div>

					</div>






























	        <!-- <section>
	          <h3>대한체육회 등록선수</h3>
	          <ul>
	            <li>- 올해 대한체육회에 등록된 선수에 한함</li>
	            <li>- 올해 이전 년도에 등록된 선수는 회원가입 불가</li>
	          </ul>
	        </section>
	        <section>
	          <h3>대한체육회 비등록선수</h3>
	          <ul>
	            <li>- 대한체육회 선수등록을 한 번도 하지 않았으나 엘리트소속팀에서 훈련을 하고 있는 선수의 경우<br>
	              (올해 이전에 대한체육회에 한번이라도 등록한 선수에 한함)</li>
	            <li>- 훈련기록 및 해당 소속의 지도자관리(팀매니저를 통해)를 받을 수 있고, 대회정보도 조회할 수 있으나 본인은 대회출전이 불가한 선수이므로 본인의 대회기록정보는 없음</li>
	          </ul>
	          <div>
	            <p>대한체육회 선수등록을 한 번도 하지 않았으나 엘리트소속팀에서 훈련을 하고 있는 선수의 경우 (올해 이전 등록한 선수 포함 <br>훈련기록 및 해당 소속의 지도자관리(팀매니저를 통해)를 받을 수 있고, 대회정보도 조회할 수 있으나 본인은 대회출전이 불가한 선수이므로 본인의 대회기록정보는 없음</p>
	          </div>
	        </section>
	        <section>
	          <h3>생활체육 지도자(관장/사범) 및 선수(관원)</h3>
	          <ul>
	            <li>- 향후 생활체육도 엘리트와 동일하게 회원DB화 정책 마련</li>
	            <li>- 지도자(관장/사범) 및 선수(관원)의 회원가입을 통해, 엘리트와 동일한 팀(소속)코드별 지도자와 선수 체육인번호 발급 예정</li>
	            <li>- 본 앱에 회원가입이 된 지도자와 선수만이 생활체육대회의 참가신청 및 참가자격 부여</li>
	            <li>- 전국 사설도장 및 클럽이 등록된 소속으로 회원가입이 되어야함 <br>
	              (개인/일반회원으로 가입시 대회정보 조회 및 체육관 정보 공유 불가)
	            <li>
	            <li>- 대한체육회에 엘리트로 등록되어 있는 체육관(ex, 파이널유도멀티짐) 및 체육관 소속선수라고 해도 <br>
	              생활체육 대회참가 및 훈련관리시 반드시 생활체육 회원가입은 필수</li>
	            <li>- 회원가입이 완료된 생활체육인은 향후 스포츠다이어리 어플리케이션을 통해 생활체육은 물론 엘리트 대회의 경기결과 및 선수분석 데이터조회 가능</li>
	          </ul>
	          <div class="exam">
	            <p>선수출신이 출전할 수 있는 생활체육대회의 경우, 스포츠다이어리에서 선수출신을 구분할 수 있는 기능은 없습니다. <br>
	              대회참가신청의 권한이 있는 지도자(관장/사범)가 책임하에 참가신청시 해당 종별에 맞춰 소속 선수(관원)를 신청/선택 해야 합니다. <br>
	              선수출신도 생활체육대회를 참가하기 위해서는 스포츠다이어리 어플리케이션의 생활체육 구분으로 선수(관원) 가입자로 신규 회원가입을 해야 합니다. </p>
	          </div>
	        </section>
	        <section>
	          <h3>선수 보호자 </h3>
	          <ul>
	            <li>- 대한체육회에 올해 등록된 선수의 학부모, 친척 관계의 보호자여야 함<br>
	              (해당 선수에게 데이터공유 확인 절차 문자전송 후 매칭 됨)</li>
	            <li>- 선수의 보호자는 올해 대한체육회에 등록된 선수가 먼저 스포츠다이어리 어플리케이션에 회원가입 한 이후에 가입이 가능함</li>
	            <li>- 회원가입 된 보호자는 모든 대회정보는 물론 공유된 선수의 훈련정보도 일부 조회 가능</li>
	            <li class="empha">※ 대한체육회 비등록선수 및 생활체육 선수(관원)의 보호자도 위의 절차대로 선수가 먼저 회원가입 후에 가입/사용이 가능합니다.</li>
	          </ul>
	        </section>
	        <section>
	          <h3>일반 회원</h3>
	          <ul>
	            <li>- 일반회원은 대회정보만 조회 가능</li>
	            <li>- 소속팀이 없는 선생님들도 회원가입 가능</li>
	            <li>- 선수의 보호자도 일반으로 회원가입이 가능하나, 선수의 훈련정보 열람 및 지도자와 상담이 불가함</li>
	          </ul>
	        </section> -->
	        <!-- <section class="hereafter">
	              <h3>※향후 회원가입자 구분 추가 예정</h3>
	              <ul>
	                <li>- 대한체육회 비등록 선수</li>
	              </ul>
	              <div class="exam">
	                <p class="tit">(예) </p>
	                <p>대한체육회 선수등록을 한 번도 하지 않았으나 엘리트소속팀에서 훈련을 하고 있는 선수의 경우 (올해 이전 등록한 선수 포함) <br>훈련기록 및 해당 소속의 지도자관리(팀매니저를 통해)를 받을 수 있고, 대회정보도 조회할 수 있으나 본인은 대회출전이 불가한 선수이므로 본인의 대회기록정보는 없음</p>
	              </div>
	            </section> -->
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	<!-- E: 회원가입 기준 안내 모달 -->

	<!-- #include file='./include/footer.asp' -->
	<script src="./js/join_step.js"></script>
	<script type="text/javascript">

		$("#member-type-guide").modal();
	</script>

</div>
</body>
</html>
