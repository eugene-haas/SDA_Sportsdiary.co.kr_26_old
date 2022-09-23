<!--#include file="./include/config.asp"-->
<%
  '로그인하지 않았다면 login.asp로 이동
  '베타오픈시 주석처리, 정식오픈때 주석해제해야합니다.
'  Check_Login()
  dim valSDMAIN : valSDMAIN = encode("sd027150424",0)

'//쿠키테스트  
' IF(Request.Cookies("SD").HasKeys) then
'   For Each obj In Request.Cookies("SD")
'     Response.Write obj & " = " & Request.Cookies("SD")(obj)&"<BR>"
'   Next
' Else
'   Response.Write "SD = " & Request.Cookies("SD")
' End If


    
%>
<script>
  function chk_logout(){

    var strAjaxUrl = "./ajax/logout.asp";
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { },    
      success: function(retDATA) {

        if(retDATA){
          
          if (retDATA=="TRUE") {
            window.location.replace("./login.asp");
          }
          else{
            alert('로그아웃중에 오류가 발생하였습니다.');      
            return;
          }
        }
      }, 
      error: function(xhr, status, error){           
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
          return;
        }
      }
    }); 
  }
  
  //종목메인 계정 설정 체크
  function chk_JoinUser(obj){
    
   switch(obj) {
    case 'judo'   : $(location).attr('href', 'http://judo.sportsdiary.co.kr/TM_Player/Main/index.asp?valSDMAIN=<%=valSDMAIN%>'); break;
    case 'tennis' : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/m_player/main/main.asp'); break;
    default:
   }
  
  /*
  //베타오픈시 주석처리, 정식오픈때 주석해제해야합니다.
    var strAjaxUrl = "./ajax/chk_GameIDSET.asp";
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { 
        SportsType  : obj
      },    
      success: function(retDATA) {
      
        console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split("|");
          
          if(strcut[0] == "TRUE") {   
            switch(strcut[1]) {
              case "0":   //종목별 회원가입이 안된 경우 회원가입 유도
                // if(confirm("회원정보가 필요한 서비스 입니다.\n\n회원가입을 진행하시겠습니까?")){
                //   chk_logout();
                // }
                // else{
                //   return; 
                // }
                $('.chk_sub_account').modal('show');
                break;
              default:
                if(strcut[2] > 0 ){
                  switch(obj) {
                    case 'judo'   : $(location).attr('href', 'http://judo.sportsdiary.co.kr/TM_Player/Main/index.asp'); break;
                    case 'tennis' : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/m_player/main/main.asp'); break;
                    default: break;
                  }
                }
                else{
                  alert("종목메인계정 설정이 필요합니다.\n설정페이지로 이동합니다.");
                  $(location).attr('href', './category.asp?SportsType='+obj); 
                }
            }
          }
          else{
            if(strcut[1] == 200) {
              msg_log = "잘못된 접근입니다.\n확인 후 다시 이용하세요.";             
            }
            else{ //99
              msg_log = "일치하는 정보가 없습니다.\n확인 후 다시 이용하세요.";
            }
            
            alert(msg_log);
            return;
          }
        }
      }, 
      error: function(xhr, status, error){           
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
          return;
        }
      }
    });   
   */
   
  }
</script>
</head>
<body>
  <!-- S: main -->
  <div class="main category pack">

    <!-- S: top_section -->
    <section class="top_section">
      <h1>
        <a href="http://sportsdiary.co.kr" target="_blank"><img src="images/open_title.png" alt="Start! Open Beta"></a>
      </h1>
      <p class="intro_copy">스포츠다이어리 종목 통합을 위한<br><span class="bluy">오픈베타 서비스</span>를 시작합니다.</p>
      <h2>종목을 선택해주세요</h2>
      <ul class="cate_list clearfix">
        <li>
          <a href="javascript:chk_JoinUser('judo');">
            <span class="img_box">
              <img src="images/part/ic_judo@3x.png" alt="유도">
            </span>
            <span class="txt">유도</span>
          </a>
        </li>
        <li>
          <a href="javascript:chk_JoinUser('tennis');">
            <span class="img_box">
              <img src="images/part/ic_tennis@3x.png" alt="테니스">
            </span>
            <span class="txt"><span class="point_yellow">BETA</span> 테니스</span>
          </a>
        </li>
        <li class="ready">
          <div class="ribbon">
            <p>comming<br>soon</p>
          </div>
          <a href="#">
            <span class="img_box">
              <img src="images/part/ic_wrestling@3x.png" alt="레슬링">
            </span>
            <span class="txt">레슬링</span>
          </a>
        </li>
        <li class="ready">
          <div class="ribbon">
            <p>comming<br>soon</p>
          </div>
          <a href="#">
            <span class="img_box">
              <img src="images/part/ic_badminton@3x.png" alt="배드민턴">
            </span>
            <span class="txt">배드민턴</span>
          </a>
        </li>
        <li class="ready">
          <div class="ribbon">
            <p>comming<br>soon</p>
          </div>
          <a href="#">
            <span class="img_box">
              <img src="images/part/ic_kumdo@3x.png" alt="검도">
            </span>
            <span class="txt">검도</span>
          </a>
        </li>
        <li class="ready">
          <div class="ribbon">
            <p>comming<br>soon</p>
          </div>
          <a href="#">
            <span class="img_box">
              <img src="images/part/ic_cycle@3x.png" alt="싸이클">
            </span>
            <span class="txt">싸이클</span>
          </a>
        </li>
      </ul>
    </section>
    <!-- E: top_section -->
  
    <!--
    <div class="cta">
      <a href="./category.asp" class="btn btn-ok btn-block">다음</a>
    </div>
  -->
  </div>
  <!-- E: main -->

  <!-- #include file="./include/footer.asp"-->
  <!-- #include file="./include/modal_JoinUs.asp"-->
    

  <script>
    function cateTab() {
      var $cateBtn = $('.cate_list a');
      var $selected = null;
      $cateBtn.click(function(){
        if ($selected) {
          $selected.removeClass('on');
        }
        $selected = $(this);
        $selected.addClass('on')
      })
    }

    // comming soon 버튼 클릭시
    function readyChk() {
      var $readyBtn = $('.ready');
      $readyBtn.click(function(e){
        alert('해당 종목은 서비스 준비중 입니다.')
        e.preventDefault();
      });
    }

    cateTab();
    readyChk();
  </script>
</body>
</html>