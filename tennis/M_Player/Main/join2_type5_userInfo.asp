<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- S: config -->
  <!-- #include file="../include/config.asp" -->
  <!-- #include file='../include/css/join_style.asp' -->
  <link rel="stylesheet" href="/front/css/join/join2_type5_userInfo.css">
  <link rel="stylesheet" href="/front/css/join/fav_list.css">
  <!-- E: config -->
  <%
  	'=================================================================
  	'STEP2
  	'생활체육 선수/관원, 지도자 회원가입
  	'=================================================================
     	dim UserName      	: UserName      = fInject(Request("UserName"))    			'이름
  	dim UserBirth     	: UserBirth     = decode(fInject(Request("UserBirth")), 0)  '생년월일
     	dim EnterType     	: EnterType		= fInject(Request("EnterType"))     		'회원구분[E:엘리트 | A:생활체육]
  	dim SportsType    	: SportsType    = fInject(Request("SportsType"))    		'종목구분
  	dim PlayerReln    	: PlayerReln    = fInject(Request("PlayerReln"))    		'가입자 구분
  	dim Team        	: Team          = fInject(Request("Team"))        			'소속코드
  	dim Team2       	: Team2         = fInject(Request("Team2"))       			'소속명
  	dim TeamNm      	: TeamNm        = fInject(Request("TeamNm"))      			'소속코드2
  	dim TeamNm2     	: TeamNm2       = fInject(Request("TeamNm2"))     			'소속명2
  	dim AreaGb      	: AreaGb        = fInject(Request("AreaGb"))      			'레슨지역 시/도
  	dim AreaGbDt      	: AreaGbDt      = fInject(Request("AreaGbDt"))     		 	'레슨지역 시/군/구
  	dim LessonAreaDt    : LessonAreaDt  = fInject(Request("LessonAreaDt"))  		'레슨지역상세 주소
  	dim CourtNm     	: CourtNm       = fInject(Request("CourtNm"))     			'레슨코트명
  	dim ShopNm      	: ShopNm        = fInject(Request("ShopNm"))      			'레슨상호명

  '	dim cnt_JoinMember	: cnt_JoinMember= CHK_JOINUS(UserName, UserBirth)	'통합ID계정 있는지 체크
  	dim txtJoinInfo 	: txtJoinInfo	= INFO_JOINUS_MEMBER(UserName, UserBirth)	'통합회원 정보 출력


  	IF UserName = "" OR UserBirth = "" OR SportsType = "" OR EnterType = "" OR PlayerReln = "" OR Team = "" OR TeamNm = "" Then
  	 	Response.Write "<script>"
  		response.write "	alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); "
  		response.write "	history.back();"
  		response.write "</script>"
  	  	Response.End
  	End IF

   	'==================================================================================
  	'레슨지역 시/도 출력
  	dim AreaGbNm

  	LSQL = "    	SELECT SidoNm "
  	LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSidoInfo]"
  	LSQL = LSQL & " WHERE DelYN = 'N'"
  	LSQL = LSQL & "   AND SportsGb = '"&SportsGb&"'"
  	LSQL = LSQL & "   AND Sido = '"&AreaGb&"' "

  	SET LRs = DBCon3.Execute(LSQL)
  	IF Not(LRs.Eof Or LRs.Bof) Then
  		AreaGbNm = LRs("SidoNm")
  	End IF
  		LRs.Close
  	SET LRs = Nothing
  	'==================================================================================

  %>
</head>
<body>
<script type="text/javascript">

	//maxlength 체크
	function maxLengthCheck(object){
		if(object.value.length > object.maxLength){
			object.value = object.value.slice(0, object.maxLength);
		}
	}

    //회원가입항목 체크
    function chk_frm(){

		//주특기기술
		var IntArr = '';
		var cnt_Skill = 0;

		//운동시작년도
		if(!$('#PlayerStartYear').val()){
			alert('운동시작년도를 입력해 주세요.');
			$('#PlayerStartYear').focus();
			return;
		}

		<%
		IF PlayerReln = "R" Then	'선수[R]
		%>
			//사용손
			if(!$('#HandUse').val()){
				alert('사용손을 선택해 주세요.');
				$('#HandUse').focus();
				return;
			}

			//복식리턴포지션
			if(!$('#PositionReturn').val()){
				alert('복식 리턴 포지션 선택해 주세요.');
				$('#PositionReturn').focus();
				return;
			}

			//백핸드타입
			if(!$('#HandType').val()){
				alert('백핸드타입 선택해 주세요.');
				$('#HandType').focus();
				return;
			}

			$('input[name=Skill]:checkbox').each(function() {
				if($(this).is(':checked')) {
					IntArr += '|' + $(this).val();
					cnt_Skill += 1;
				}
			});

			if(cnt_Skill == 0){
				alert('주특기기술은 최소 1개 이상 선택하세요.');
				return;
			}

		<%
		Else	'지도자[T]
		%>
			//레슨지역 시/도
			if(!$('#AreaGb').val()){
				alert('레슨지역 시/도를 선택해 주세요.');
				$('#AreaGb').focus();
				return;
			}

			//레슨지역 시/군/구
			if(!$('#AreaGbDt').val()){
				alert('레슨지역 시/군/구를 선택해 주세요.');
				$('#AreaGbDt').focus();
				return;
			}

			//레슨지역 상세주소
			if(!$('#LessonAreaDt').val()){
				alert('레슨지역 상세주소를 입력해 주세요.');
				$('#LessonAreaDt').focus();
				return;
			}

			//레슨코트명
				if(!$('#CourtNm').val()){
				alert('레슨코트명을 입력해 주세요.');
				$('#CourtNm').focus();
				return;
			}

			//상호명
			if(!$('#ShopNm').val()){
				alert('상호명을 입력해 주세요.');
				$('#ShopNm').focus();
				return;
			}
		<%
		End IF
		%>

		var strAjaxUrl		= '../Ajax/join_OK_type5.asp';
		var SportsType      = $('#SportsType').val();
		var EnterType       = $('#EnterType').val();
		var PlayerReln      = $('#PlayerReln').val();
		var Team            = $('#Team').val();
		var Team2           = $('#Team2').val();
		var TeamNm          = $('#TeamNm').val();
		var TeamNm2         = $('#TeamNm2').val();
		var LeaderType      = $('input:radio[name=LeaderType]:checked').val();
		var PlayerStartYear = $('#PlayerStartYear').val();
		var PlayerTall      = $('#PlayerTall').val();
		var PlayerWeight    = $('#PlayerWeight').val();
		var BloodType       = $('#BloodType').val();
		var UserPhone       = $('#UserPhone1').val() + '-' + $('#UserPhone2').val() + '-' + $('#UserPhone3').val();
		var HandUse         = $('#HandUse').val();
		var PositionReturn  = $('#PositionReturn').val();
		var HandType        = $('#HandType').val();
		var LessonArea      = $('#AreaGb').val();
		var LessonArea2     = $('#AreaGbDt').val();
		var LessonAreaDt    = $('#LessonAreaDt').val();
		var CourtNm       	= $('#CourtNm').val();
		var ShopNm        	= $('#ShopNm').val();


		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {
				SportsType         : SportsType
				,EnterType        	: EnterType
				,PlayerReln         : PlayerReln
				,Team             	: Team
				,Team2            	: Team2
				,TeamNm           	: TeamNm
				,TeamNm2          	: TeamNm2
				,PlayerStartYear  	: PlayerStartYear
				,PlayerTall         : PlayerTall
				,PlayerWeight       : PlayerWeight
				,BloodType          : BloodType
				,LeaderType    		: LeaderType
				,HandUse      		: HandUse
				,PositionReturn   	: PositionReturn
				,HandType     		: HandType
				,Skill        		: IntArr
				,LessonArea     	: LessonArea
				,LessonArea2    	: LessonArea2
				,LessonAreaDt   	: LessonAreaDt
				,CourtNm      		: CourtNm
				,ShopNm       		: ShopNm
			},
			success: function(retDATA) {

				console.log(retDATA);

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
							default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.';  //200
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

	//주특기 목록 출력
	function chk_InfoSkill(){

		var strAjaxUrl = '../Ajax/join2_type5_userInfo_Skill.asp';

		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			data: {},
			success: function(retDATA) {
				$('#div_Skill').html(retDATA);
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

  	$(document).on('click','#div_Skill li',function() {
		var cnt = 0;
		var index = $('#div_Skill li').index(this);

		$('input:checkbox[name=Skill]').each(function (i) {
			if(this.checked) cnt += 1;
		});

		if(cnt>3) {
			$('#div_Skill li:eq('+index+') a').removeClass('on');
			$('#div_Skill li:eq('+index+') a input').prop('checked', false);
			alert('주특기는 최대 3개까지 선택할 수 있습니다.');
			return;
		}
	});

  	$(document).ready(function(e) {

		chk_InfoSkill();    //다득점 기술 목록 출력

		make_box('sel_HandUse','HandUse','','Join_HandUse');      //사용손
		make_box('sel_HandType','HandType','','Join_HandType');     //백핸드타입
		make_box('sel_PositionReturn','PositionReturn','','Join_PositionReturn'); //복식리턴포지션

  	});
</script>
  <div id="txt"></div>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>회원가입</h1>
  </div>
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub join join-4">
    <ul class="join-step flex">
      <li>이용약관</li>
      <li>가입자정보</li>
      <li class="on">회원정보</li>
    </ul>
    <form name="s_frm" method="post">
      <input type="hidden" name="EnterType" id="EnterType" value="<%=EnterType%>" />
      <input type="hidden" name="PlayerReln" id="PlayerReln" value="<%=PlayerReln%>" />
      <input type="hidden" name="SportsType" id="SportsType" value="<%=SportsType%>" />
      <input type="hidden" name="Team" id="Team" value="<%=Team%>" />
      <input type="hidden" name="Team2" id="Team2" value="<%=Team2%>" />
      <input type="hidden" name="TeamNm" id="TeamNm" value="<%=TeamNm%>" />
      <input type="hidden" name="TeamNm2" id="TeamNm2" value="<%=TeamNm2%>" />
      <input type="hidden" name="AreaGb" id="AreaGb" value="<%=AreaGb%>" />
      <fieldset>
        <legend>회원가입 입력</legend>
        <ul class="join-order">
          <li>종목</li>
          <li><span>:: 테니스 ::</span> </li>
        </ul>
        <%=txtJoinInfo%>
        <%
           SELECT CASE PlayerReln
              CASE "R"
              %>
        <ul class="join-form">
          <li>
            <p>소속1</p>
            <p><span class="point-or"><%=TeamNm%></span></p>
          </li>
          <li>
            <p>소속2</p>
            <p><span class="point-or"><%=TeamNm2%></span></p>
          </li>
          <li>
            <p>사용손<span class="compulsory">＊</span></p>
            <p id="sel_HandUse">
              <select name="HandUse" id="HandUse" >
                <option value="">사용손 선택</option>
              </select>
            </p>
          </li>
          <li>
            <p>복식리턴포지션<span class="compulsory">＊</span></p>
            <p id="sel_PositionReturn">
              <select name="PositionReturn" id="PositionReturn" >
                <option value="">복식 리턴 포지션 선택</option>
              </select>
            </p>
          </li>
          <li>
            <p>백핸드타입<span class="compulsory">＊</span></p>
            <p id="sel_HandType">
              <select name="HandType" id="HandType" >
                <option value="">백핸드타입 선택</option>
              </select>
            </p>
          </li>
          <div class="fav-list">
            <h3>[주특기]</h3>
            <ul id="div_Skill" class="clearfix">
              <!--
                <li>
                  <a href="#">
                      <input type="checkbox">
                      <span>대진표결과</span>
                  </a>
                </li>
                -->
            </ul>
          </div>
        </ul>
        <%
              CASE "T"
              %>
        <ul class="join-form">
          <li>
            <p>소속</p>
            <p><span class="point-or"><%=TeamNm%></span></p>
          </li>
          <li class="manager-divn">
            <p>지도자 구분<span class="compulsory">＊</span></p>
            <p class="manager-sel">
              <label>
                <input type="radio" name="LeaderType" id="LeaderType" checked value="2">
                <span>감독</span></label>
              <label>
                <input type="radio" name="LeaderType" id="LeaderType" value="3">
                <span>코치</span></label>
              <label>
                <input type="radio" name="LeaderType" id="LeaderType" value="4">
                <span>기타</span></label>
            </p>
          </li>
          <li>
            <p>레슨지역 시/도<span class="compulsory">＊</span></p>
            <p class="over-txt">
              <input type="text" name="AreaGbNm" id="AreaGbNm" value="<%=AreaGbNm%>" readonly />
            </p>
          </li>
          <li>
            <p>레슨지역 시/군/구<span class="compulsory">＊</span></p>
            <p class="over-txt">
              <input type="text" name="AreaGbDt" id="AreaGbDt" value="<%=AreaGbDt%>" readonly />
            </p>
          </li>
          <li>
            <p>레슨상세주소<span class="compulsory">＊</span></p>
            <p class="over-txt">
              <input type="text" name="LessonAreaDt" id="LessonAreaDt" value="<%=LessonAreaDt%>" readonly />
            </p>
          </li>
          <li>
            <p>레슨코트명<span class="compulsory">＊</span></p>
            <p class="over-txt">
              <input type="text" name="CourtNm" id="CourtNm" value="<%=CourtNm%>" readonly />
            </p>
          </li>
          <li>
            <p>상호명<span class="compulsory">＊</span></p>
            <p class="over-txt">
              <input type="text" name="ShopNm" id="ShopNm" value="<%=ShopNm%>" readonly />
            </p>
          </li>
        </ul>
        <%
          END	SELECT
           %>
        <ul class="join-form">
          <li class="hang-deco">
            <p>운동시작년도<span class="compulsory">＊</span></p>
            <p class="over-txt">
              <input type="number" name="PlayerStartYear" id="PlayerStartYear" placeholder="1990" maxlength="4" oninput="maxLengthCheck(this)" onKeyUp="if($('#PlayerStartYear').val().length==4){$('#PlayerTall').focus();}" />
            </p>
            <span class="txt-deco">년도</span> </li>
          <li class="hang-deco">
            <p>키</p>
            <p class="over-txt">
              <input type="number" name="PlayerTall" id="PlayerTall" placeholder="180" onKeyPress="chk_Number();" />
            </p>
            <span class="txt-deco">cm</span> </li>
          <li class="hang-deco">
            <p>체중</p>
            <p class="over-txt">
              <input type="number" name="PlayerWeight" id="PlayerWeight" placeholder="67" onKeyPress="chk_Number();" />
            </p>
            <span class="txt-deco">kg</span> </li>
          <li>
            <p>혈액형</p>
            <p>
              <select name="BloodType" id="BloodType">
                <option value="">혈액형 선택</option>
                <option value="A"> A</option>
                <option value="B"> B</option>
                <option value="AB">AB</option>
                <option value="O"> O</option>
              </select>
            </p>
          </li>
        </ul>
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
