<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file='./include/config.asp' -->
  <%
      '========================================================================================================
    	'통합ID 설정(유도의 경우) 페이지
      '   - 통합회원DB에 동일인 계정이 여러개의 경우 1개정보만 남기고 삭제처리합니다.
      '========================================================================================================

    	dim UserName  : UserName    = fInject(trim(Request("UserName")))
    	dim UserBirth : UserBirth   = decode(fInject(trim(Request("UserBirth"))), 0)

  '	test 계정
  '  	UserName = "김유기"
  '	UserBirth = "19530608"

  	dim txt_JoinUs  '가입회원 목록
    	dim LRs, LSQL

    	IF UserName = "" OR UserBirth = "" Then
      	Response.Write "<script>alert('잘못된 경로로 접근하셨거나 누락된 항목이 있습니다.'); history.back();</script>"
      	Response.End
    	End IF


    	'// 유도회원가입 정보가 있다면 출력합니다.
  	'	- 유도DB 데이터를 통합회원DB에 복사하였기 때문입니다.

     	LSQL =  "     	SELECT M.MemberIDX"
  	LSQL = LSQL & "   	,M.UserID "
  	LSQL = LSQL & "   	,M.UserID + ' - 유도 ' +"
  	LSQL = LSQL & "  	 	CASE M.EnterType "
  	LSQL = LSQL & "     	WHEN 'E' THEN "
  	LSQL = LSQL & "       		CASE PlayerReln  "
  	LSQL = LSQL & "         		WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'Z' THEN '엘리트-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'R' THEN '엘리트-선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'K' THEN '엘리트-비등록선수'"
  	LSQL = LSQL & "         		WHEN 'S' THEN '엘리트-예비후보'"
  	LSQL = LSQL & "         		WHEN 'T' THEN '엘리트-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'D' THEN '일반'"
  	LSQL = LSQL & "      		END "
  	LSQL = LSQL & "     	WHEN 'A' THEN "
  	LSQL = LSQL & "       		CASE PlayerReln "
  	LSQL = LSQL & "         		WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'Z' THEN '생활체육-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
  	LSQL = LSQL & "         		WHEN 'R' THEN '생활체육-선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'T' THEN '생활체육-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "        			WHEN 'D' THEN '일반' "
  	LSQL = LSQL & "       			END"
  	LSQL = LSQL & "    		WHEN 'K' THEN "
  	LSQL = LSQL & "       		CASE PlayerReln "
  	LSQL = LSQL & "         		WHEN 'R' THEN '국가대표-선수('+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "         		WHEN 'T' THEN '국가대표-지도자('+ISNULL(SportsDiary.dbo.FN_PubName('sd03900'+LeaderType),'')+'-'+ISNULL(SportsDiary.dbo.FN_TeamNm2('judo', M.Team),'')+')'"
  	LSQL = LSQL & "       			END"
  	LSQL = LSQL & "   		END PlayerRelnNm "
  	LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M"
  	LSQL = LSQL & "   	left join [SportsDiary].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = 'judo' AND P.DelYN = 'N' "
  	LSQL = LSQL & " WHERE M.DelYN = 'N' "
  	LSQL = LSQL & "   	AND M.SportsType = 'judo' "
  	LSQL = LSQL & "     AND M.UserName = '"&UserName&"'"
  	LSQL = LSQL & "     AND M.Birthday = '"&UserBirth&"'"
  	LSQL = LSQL & " ORDER BY M.EnterType "
  	LSQL = LSQL & "   	,M.PlayerReln "

  ' 	response.Write LSQL

    	SET LRs = DBCon.Execute(LSQL)
    	IF Not(LRs.Eof or LRs.bof) Then
      	Do Until LRs.Eof

  			txt_JoinUs = txt_JoinUs & "<li>"
  			txt_JoinUs = txt_JoinUs & "  <label class='bind_whole ic_check act_btn'>"
  			txt_JoinUs = txt_JoinUs & "   <input type='radio' name='join_IDX' id='join_IDX' value='"&LRs("UserID")&"'>"
  			txt_JoinUs = txt_JoinUs & "   <span class='using'>"&LRs("PlayerRelnNm")&"</span>"
  			txt_JoinUs = txt_JoinUs & "   <svg version='1.1' xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'>"
  			txt_JoinUs = txt_JoinUs & "     <path d='M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16'></path>"
  			txt_JoinUs = txt_JoinUs & "   </svg>"
  			txt_JoinUs = txt_JoinUs & "  </label>"
  			txt_JoinUs = txt_JoinUs & "</li>"

        	LRs.movenext
      	Loop
    	END IF

      	LRs.Close
    	SET LRs = Nothing
  %>
  <script>
    function chk_Submit(){

      if(!($('#sd_terms').is(':checked'))){
        alert('아이디 확인을 위한 개인정보 제공 동의는 필수입니다.');
        $('#sd_term').focus();
        return;
      }

      if($('input:radio[name=join_IDX]:checked').length == 0){
        alert('사용하실 통합ID를 선택해 주세요.');
        return;
      }

      $('.conf_modal').modal();
    }

    function SET_JoinUsID(){

      var strAjaxUrl = './ajax/total_id_sel.asp';
      var join_IDX = $('input:radio[name=join_IDX]:checked').val();

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          UserName    : '<%=UserName%>'
          ,UserBirth  : '<%=UserBirth%>'
          ,join_IDX   : join_IDX
        },
        success: function(retDATA) {

          //console.log(retDATA);

          if(retDATA){

            var strcut = retDATA.split('|');

            if(strcut[0] == 'TRUE') {

              //로그인 하지 않고 회원가입>가입유무 체크페이지(combin_check.asp)에서 넘어온 경우
              if(strcut[1]==''){
                alert('사용하실 통합ID['+join_IDX+'] 설정이 성공적으로 이루어졌습니다.\nID['+join_IDX+'] 로그인 후 이용하세요.');
                $(location).attr('href', './login.asp');
              }
              else{    //로그인 후 통합아이디 설정한 경우
                alert('사용하실 통합ID['+join_IDX+'] 설정이 성공적으로 이루어졌습니다.');

                //$(location).attr('href', './index.asp');
                $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/main/index.asp');
              }
            }
            else{ //FALSE키
  			switch(strcut[1]){
  				case '66'	: msg_log = '통합ID 설정을 완료하지 못하였습니다.\n확인 후 다시 이용하세요.'; break;
  				default 	: msg_log = '잘못된 접근입니다.\n확인 후 다시 이용하세요.';             //200
  			}

              alert(msg_log);
              $('.conf_modal').hide();
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
  </script>
</head>
<body>
<div class="l">
  <div class="l_header">
  	<div class="m_header s_sub">
  		<!-- #include file="./include/header_back.asp" -->
  		<h1 class="m_header__tit">통합 아이디 선택</h1>
  		<!-- #include file="./include/header_home.asp" -->
  	</div>
  </div>

  <!-- S: main -->
  <div class="l_content m_scroll total_id id_sel [ _content _scroll ]">

    <!-- S: total_guide -->
    <div class="total_guide">
      <!-- S: top_section -->
    <section class="top_section">
      <h2>Sports Diary 가 새로워 집니다.</h2>
      <p>각 종목 및 회원 구분 별 아이디를 통합해서<br>새로워진 스포츠다이어리를 이용해 보세요.</p>
      <p><strong>회원구분 전환으로 종목 및 회원 권한 별<br> 화면 이동이 더 빠르고 쉬워 졌어요!!</strong></p>
      <div class="img_box">
        <img src="images/combine_id.png" alt="선수, 보호자, 지도자 모두 통합 아이디로 이용 가능합니다.">
      </div>
      <p>부모/엘리트/지도자 별 화면을 <br>이제 통합아이디 하나로 사용할 수 있습니다.</p>
    </section>
    <!-- E: top_section -->
    </div>
    <!-- E: total_guide -->

    <!-- S: top_section -->
    <section class="top_section">
      <h2><%=UserName%>님의 보유 아이디 입니다.</h2>
      <p>스포츠다이어리에서 이용할 통합아이디를 선택해주세요.</p>
    </section>
    <!-- E: top_section -->

    <!-- S: list-group -->
    <div class="list-group">
      <ul class="chk_radio">
        <%=txt_JoinUs%>
      <!--
        <li>
          <label class="bind_whole ic_check act_btn">
            <input type="radio" name="user_id">
            <span class="txt">sportsdiary5082</span>
            <span class="using">유도(엘리트선수)</span>
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
          </label>
        </li>
        <li>
          <label class="bind_whole ic_check act_btn">
            <input type="radio" name="user_id">
            <span class="txt">sportsdiary5082</span>
            <span class="using">유도(엘리트선수)</span>
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
          </label>
        </li>
        <li>
          <label class="bind_whole ic_check act_btn">
            <input type="radio" name="user_id">
            <span class="txt">sportsdiary5082</span>
            <span class="using">유도(엘리트선수)</span>
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
          </label>
        </li>
        -->
      </ul>
    </div>
    <!-- E: list-group -->

    <p class="req">
      <label class="bind_whole ic_check act_btn on">
        <span class="txt">아이디 확인을 위한 개인정보 제공 동의(필수)</span>
        <input type="checkbox" id="sd_terms" name="sd_terms" checked>
        <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
            <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
          </svg>
      </label>
    </p>

    <div class="cta">
    <a href="javascript:chk_Submit();" class="btn btn-ok btn-block">확인</a>
      <!--
      <a href="chk_Submit();" class="btn btn-ok btn-block" data-toggle="modal" data-target=".conf_modal">확인</a>
      -->
    </div>

  </div>
  <!-- E: main -->

  <!-- S: conf_modal -->
  <div class="modal fade conf_modal">
    <!-- S: modal-dialog -->
    <div class="modal-dialog">
      <!-- S: modal-content -->
      <div class="modal-content">
        <!-- S: modal-body -->
        <div class="modal-body">
          <p>선택하신 아이디를 통합 아이디로 <br>설정하시겠습니까?<br>설정 후에는 변경이 불가합니다.</p>
        </div>
        <!-- E: modal-body -->
        <!-- S: modal-footer -->
        <div class="modal-footer">
          <div class="btn-list clearfix">
            <a href="#" class="btn btn-cancel" data-dismiss="modal">취소</a>
            <a href="javascript:SET_JoinUsID();" class="btn btn-ok">확인</a>
          </div>
        </div>
        <!-- E: modal-footer -->
      </div>
      <!-- E: modal-content -->
    </div>
    <!-- E: modal-dialog -->
  </div>
  <!-- E: conf_modal -->

  <!-- #include file='./include/footer.asp' -->

  <script>
    /**
     * 회원 아이디 선택 tab 기능
     */
    WholeAgree.start('.req'); // 개인 정보 제공 동의 체크 박스
    WholeAgree.start('.id_sel'); /* 통합 ID 선택 */

    // function tabList () {
    //   var $tabIpt = $('.list-group .act_btn input');
    //   $tabIpt.on('click', function(){
    //     if ($(this).is(':checked')) {
    //       $tabIpt.parents('.act_btn').removeClass('on');
    //       $(this).parents('.act_btn').addClass('on');
    //     } else {
    //       $(this).parents('.act_btn').removeClass('on');
    //     }
    //   })
    // }
    // tabList();
  </script>
  
</div>
</body>
</html>
