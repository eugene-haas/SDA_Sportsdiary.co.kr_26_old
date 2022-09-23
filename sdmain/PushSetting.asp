<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file='./include/config.asp' -->
  <%
      '푸시설정페이지
      '로그인 되었다면 index.asp로 이동
      Check_Login()

      dim SD_UserID   : SD_UserID = request.Cookies("SD")("UserID")

  %>
  <script type="text/javascript">
      /*
      ================================================================================================
      푸시설정 관련
      judo.sportsdiary.co.kr/M_Player/include/gnb.asp         //앱알림 설정페이지
      judo.sportsdiary.co.kr/M_Player/ajax/PushAgreeYN.asp    //앱알림 수신동의 설정 업데이트 페이지
      judo.sportsdiary.co.kr/M_Player/ajax/PushAgree_Fnd.asp  //앱알림 수신동의 설정값 조회하여 Radio button checked처리
      judo.sportsdiary.co.kr/M_Player/ajax/PushSET_Identity.asp  //기기식별자 등록 쿠키조회하여 자동등록처리
      ================================================================================================
      */
      console.log(navigator.userAgent.indexOf("isAppVer=2.0"));

      function PushAgreeYN(str){

        console.log(str);

        var strAjaxUrl = "./Ajax/PushAgreeYN.asp";
        var strmessage = "";
        var strtype = "";

        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
            UserID : '<%=SD_UserID%>',
            AgreeYN  : str
          },
          success: function(retDATA) {

            var retarr = retDATA.split('|');

            console.log(retDATA);

            if(retarr[0] == "TRUE"){
              alert(retarr[3].replace(/n/gi,"\n"));
            }

          },
          error: function (xhr, status, error) {
            if(error!=""){
              alert ("오류발생! - 시스템관리자에게 문의하십시오!");
              return;
            }
          }
        });
      }

      //IN App에서 푸시동의[Y|N] 설정 이 후 웹으로 업데이트 호출합니다.(푸시동의 기기설정)
      function PushrcvAgree(str_agreeYN, str_datetime){
        //alert("DB입력값 [수신여부:" + str_agreeYN + ", 날짜:" + str_datetime + " ]");

        PushAgreeYN(str_agreeYN);
      }

      //Radio btn check시 처리(수신동의 변경처리)
      $(document).on('click', 'input:radio[name=PushAgree]', function(){
        if($('input:radio[name=PushAgree]:checked').val()=='Y') {
          alert('sportsdiary://goPushAgree=Y');   //수신동의함
          PushAgreeYN('Y');
        }
        else {
          alert('sportsdiary://goPushAgree=N');  //수신동의안함
          PushAgreeYN('N');
        }
      });


      //푸시수신동의 데이터 조회 하여 Radio btn checked
      function PushAgreeFnd(){
        var strAjaxUrl = './Ajax/PushAgree_Fnd.asp';

        $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {
              UserID : '<%=SD_UserID%>'
            },
            success: function(retDATA) {

              console.log(retDATA);

              if(retDATA){
                var strcut = retDATA.split('|');

                if (strcut[0] == 'TRUE') {
                  switch(strcut[1]){
                      case 'Y' : $('input[name=PushAgree]').eq(0).prop('checked', true); break;  //수신동의
                      case 'N' : $('input[name=PushAgree]').eq(1).prop('checked', true); break;  //수신거부
                      default  : $('input[name=PushAgree]').eq(0).prop('checked', false); $('input[name=PushAgree]').eq(1).prop('checked', false); //미설정된 상태
                  }
                }
                else{  //FALSE|
                  var msg = '';

                  switch (strcut[1]) {
                    case '99'   : msg = '일치하는 회원정보가 없습니다.\n확인 후 다시 이용하세요.'; break;
                    default 	: msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
                  }
                  alert(msg);
                  return;
                }
              }
            },
            error: function (xhr, status, error) {
              if(error!=''){
                alert ('오류발생! - 시스템관리자에게 문의하십시오!');
                return;
              }
            }
        });
      }


      $(document).ready(function(){
        //푸시수신동의 설정값 조회하여 Radio btn checked
        PushAgreeFnd();
      });


      /*================================================================================================*/
  </script>
</head>
<body>
<div class="l">

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">앱 알림 수신 설정</h1>
      <!-- #include file="./include/header_home.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
  	<ul class="push-modify">
  		<li>
  			<p class="push-label">항목</p>
  			<p class="push-cell">모바일 앱 마케팅 알림 동의</p>
  		</li>
  		<li>
  			<p class="push-label">이용목적</p>
  			<p class="push-cell">대회일정/결과, 대진표, 실시간 경기진행현황 및 이벤트 등에 대한 정보를 수신 받을 수 있습니다.</p>
  		</li>
  		<li>
  			<p class="push-label">보유기간</p>
  			<p class="push-cell">별도 동의 철회 시까지 또는 약관 철회 후 1주일 까지</p>
  		</li>
  		<li>
  			<p class="push-label">동의여부</p>
  			<p class="push-cell">
  				<input type="radio" name="PushAgree" id="PushAgreeY" value="Y" hidden ><label for="PushAgreeY"><span></span>동의함</label>
          &nbsp; &nbsp; &nbsp;
          <input type="radio" name="PushAgree" id="PushAgreeN" value="N" hidden ><label for="PushAgreeN"><span></span>동의안함</label>
  			</p>
  		</li>

              <!--
              <li>
  			<p class="push-label">Identity<br>(식별자)</p>
  			<p class="push-cell" onclick="idacc();">앱 알림을 수신하려면 식별자를 등록하여야합니다. 식별자를 등록하려면 해당 행을 터치해주세요.(최초 1회 등록)</p>
  		</li>
              -->
  	</ul>
  </div>

  <!-- #include file='./include/footer.asp' -->

</div>
</body>
</html>
