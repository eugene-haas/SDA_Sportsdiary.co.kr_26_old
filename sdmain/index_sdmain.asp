<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!--#include file="./include/config.asp"-->
  <%
    '로그인하지 않았다면 login.asp로 이동2018 전국 여성배드민턴대회 및 전국시도대항리그전
    '베타오픈시 주석처리, 정식오픈때 주석해제해야합니다.
    'Check_Login()

    '통합메인을 경유하지 않고 바로 유도메인으로 접근을 막기위하여
    dim valSDMAIN : valSDMAIN = encode("sd027150424",0)
    dim AppType : AppType = Request("AppType")
    dim IsFirstAccYN :IsFirstAccYN = Request("IsFirstAccYN")
  %>

  <%

    Response.Cookies("a") = "a"
    Response.Cookies("a").domain = ".sportsdiary.co.kr"
    Response.cookies("a").expires = Date() + 365

    iLISportsGb = SportsGb
  %>
  <script type="text/javascript">
    var apptype = '<%=AppType%>';

    //alert(apptype);

    //상단 종목 메인메뉴 URL
    function chk_TOPMenu_URL(obj){
      switch(obj){
        case 'judo'       : $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
        case 'tennis'     : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp'); break;
        case 'bike'      	: $(location).attr('href', 'http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp'); break;
        case 'badminton' 	: $(location).attr('href', 'http://badminton.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp'); break;
        case 'swim' 	    : $(location).attr('href', 'http://sw.sportsdiary.co.kr/list.asp'); break;
        case 'riding'  : $(location).attr('href', 'http://riding.sportsdiary.co.kr/m_player/main/index.asp'); break;
        default 			    : $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');
      }
    }
  </script>
  <style>
    /* .sports_category .link-wrap{ overflow:hidden; width:230px; margin:auto; }
    @media all and (orientation:landscape){ .sports-category .link-wrap{ width:460px; } }
    .sports-category .link-wrap>.link.s-new{ border:solid 2px #005895; }
    .sports-category .link-wrap>.link.s-new>.link>.category{ padding:19px 0; }
    .sports-category .link-wrap>.link{ display:block; width:220px; height:62px; font-size:18px; float:left; overflow:hidden; border:solid #cdcdcd 1px; margin:0 5px 10px 5px; border-radius:5px; background-color:#f2f2f2; white-space:nowrap; }
    .sports-category .link-wrap>.link>.category{ position:relative; display:inline-block; height:100%; width:120px; padding:20px 0; color:#fff; background-color:#1e5687; vertical-align:top; transform:skew(-27deg) translateX(-16px); }
    .sports-category .link-wrap>.link>.category::before{ content:''; display:block; position:absolute; width:46px; top:0; bottom:0; left:16px; background:url('http://img.sportsdiary.co.kr/sdapp/bg/bg-button-line@3x.png') no-repeat left/auto 100%; transform:skew(27deg);		}
    .sports-category .link-wrap>.link>.category>.category-inner{ display:inline-block; transform:skew(27deg) translateX(1px); text-indent:16px; line-height:100%; padding-top:3px; }
    .sports-category .link-wrap>.link>.co-logo-wrap{ position:relative; display:inline-block; width:50%; height:100%; vertical-align:top; transform:translateX(-12px); }
    .sports-category .link-wrap>.link>.co-logo-wrap.t-badminton{ background:url('http://img.sportsdiary.co.kr/sdapp/bg/bg-sihouette-badminton@3x.png') no-repeat center 0px/auto 100%; }
    .sports-category .link-wrap>.link>.co-logo-wrap.t-judo{ background:url('http://img.sportsdiary.co.kr/sdapp/bg/bg-sihouette-judo@3x.png') no-repeat center 0px/auto 100%; }
    .sports-category .link-wrap>.link>.co-logo-wrap.t-tennis{ background:url('http://img.sportsdiary.co.kr/sdapp/bg/bg-sihouette-tennis@3x.png') no-repeat center 0px/auto 100%; }
    .sports-category .link-wrap>.link>.co-logo-wrap.t-cycling{ background:url('http://img.sportsdiary.co.kr/sdapp/bg/bg-sihouette-cycle@3x.png') no-repeat center 0px/auto 100%; }
    .sports-category .link-wrap>.link>.co-logo-wrap::before{ content:''; display:block; position:absolute; width:96px; height:36px; top:0; bottom:0; margin:auto; left:0; right:0; background:url('http://img.sportsdiary.co.kr/sdapp/bg/bg-logo-shading.png') no-repeat center/96px 36px; }
    .sports-category .link-wrap>.link>.co-logo-wrap>.co-logo{ position:absolute; top:0; bottom:0; left:0; right:0; margin:auto; }
    .sports-category .link-wrap>.link>.co-logo-wrap>.co-logo.badminton{ width:72px; bottom:2px; }
    .sports-category .link-wrap>.link>.co-logo-wrap>.co-logo.judo{ width:70px; top:2px; }
    .sports-category .link-wrap>.link>.co-logo-wrap>.co-logo.tennis{ width:70px; top:2px; }
    .sports-category .link-wrap>.link>.co-logo-wrap>.co-logo.cycling{ width:80px; top:2px; } */

    .sports_category{ text-align:center; background-color:#fff; line-height:100%; }
    .sports_category>.logo_wrap>.logo{ width:100px; }
    .sports_category>.indicate{ font-size:16px; letter-spacing:-0.02em; font-weight:300; color:#999; margin-top:21px; margin-bottom:24px; }

    .link_wrap{ overflow:hidden; width:233px; margin:auto; text-align:center;font-size:0;line-height:0; }
    .link_medium{display:inline-block; width:110px; height:100px; overflow:hidden; border-radius:10px; margin-right:13px; margin-bottom:14px; vertical-align:top;}
    .link_medium>.txt{display:block; height:60px; padding-top:23px; font-size:18px; font-weight:500; color:#fff; text-align:center; line-height:100%; text-shadow:0 0 18px rgba(0, 0, 0, .7)}
    .link_medium>.txt.s_badminton{ background:#232323 url('http://img.sportsdiary.co.kr/images/SD/icon/intro_badminton_@3x.png') no-repeat center top/100% auto; }
    .link_medium>.txt.s_judo{ background:#232323 url('http://img.sportsdiary.co.kr/images/SD/icon/intro_judo_@3x.png') no-repeat center top/100% auto;}
    .link_medium>.txt.s_tennis{background:#232323 url('http://img.sportsdiary.co.kr/images/SD/icon/intro_tennis_@3x.png') no-repeat center top/100% auto;}
    .link_medium>.txt.s_cycling{background:#232323 url('http://img.sportsdiary.co.kr/images/SD/icon/intro_cycling_@3x.png') no-repeat center top/100% auto;}
    .link_medium>.txt.s_swimming{background:#232323 url('http://img.sportsdiary.co.kr/images/SD/icon/intro_swimming_@3x.png') no-repeat center top/100% auto;}
    .link_medium>.txt.s_sdamall{background:#232323 url('http://img.sportsdiary.co.kr/images/SD/icon/intro_sdamall_s_@3x.png') no-repeat center top/100% auto;}

    .link_medium>.logo_wrap{display:block; height:40px; background-color:#e6e6e6; text-align:center;}
    .link_medium>.logo_wrap>.logo{width:100%;}
    .link_medium>.logo_wrap>.logo.s_badminton{position:relative;width:72px;height:auto;top:7px;}
    .link_medium>.logo_wrap>.logo.s_judo{position:relative;width:72px;height:auto;top:10px;}
    .link_medium>.logo_wrap>.logo.s_tennis{position:relative;width:70px;height:auto;top:12px;}
    .link_medium>.logo_wrap>.logo.s_cycling{position:relative;width:83px;height:auto;top:11px;}
    .link_medium>.logo_wrap>.logo.s_swimming{position:relative;width:83px;height:auto;top:12px;}
    .link_medium>.logo_wrap>.logo.s_sdamall{position:relative;width:68px;height:auto;top:9px;}
    .link_medium:last-child{margin-right:0;}

    .link_large{position:relative; width:100%; height:60px; border-radius:10px; background-color:#830000; color:#fff; font-size:15px; text-align:center; text-indent:2px; }
    .link_large::before{content:''; display:block; position:absolute; width:156px; height:100%; left:0; right:0; margin:auto; background-color:#720000; transform:skew(-30deg); }
    .link_large>.logo_wrap{position:relative; display:inline-block; margin-top:24px;line-height:100%;margin-right:8px;}
    .link_large>.logo_wrap>.logo{width:78px;height:17px;vertical-align:top;}

    .link_large>.txt{position:relative; display:inline-block; margin-top:23px; padding-right:28px; font-size:16px; font-weight:500; background:url('http://img.sportsdiary.co.kr/sdapp/arrow/ic-arrow-right-F@3x.png') no-repeat right center/9px 16px; height:16px; line-height:100%; vertical-align:top;}

    @media all and (orientation:portrait){
      .sports_category>.logo_wrap{ margin-top:50px; }
      .sports_category .link_medium:nth-of-type(2n){margin-right:0;}
    }
    @media all and (orientation:landscape){
      .sports_category>.logo_wrap{ margin-top:40px; }
      .sports_category .link_wrap{ width:479px; }
      .sports_category .link_medium:nth-of-type(4n){margin-right:0;}
    }

  </style>
</head>
<body>
<div class="l">
  <section class="sports_category">
    <h1 class="logo_wrap"><img src="images/part/intro_sportsdiary_logo@3x.png" class="logo" alt="스포츠다이어리"></h1>
    <p class="indicate">종목을 선택해주세요</p>

    <div class="link_wrap">
      <a onclick="chk_TOPMenu_URL('badminton');" class="link_medium s_new">
        <span class="txt s_badminton">배드민턴</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_badminton.png" class="logo s_badminton" />
        </span>
      </a>
      <a onclick="chk_TOPMenu_URL('judo');" class="link_medium">
        <span class="txt s_judo">유도</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_judo.png" class="logo s_judo" />
        </span>
      </a>
      <a onclick="chk_TOPMenu_URL('tennis');" class="link_medium">
        <span class="txt s_tennis">테니스</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_tennis.png" class="logo s_tennis" />
        </span>
      </a>
      <a onclick="chk_TOPMenu_URL('bike');" class="link_medium">
        <span class="txt s_cycling">자전거</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_cycling.png" class="logo s_cycling" />
        </span>
      </a>
      <a onclick="chk_TOPMenu_URL('swim');" class="link_medium">
        <span class="txt s_swimming">수영</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_swimming_@3x.png" class="logo s_swimming" />
        </span>
      </a>
      <a onclick="chk_TOPMenu_URL('riding');" class="link_medium">
        <span class="txt s_swimming">승마</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_swimming_@3x.png" class="logo s_swimming" />
        </span>
      </a>

      <%
        Set mallobj_mp =  JSON.Parse("{}")
        Call mallobj_mp.Set("M_MIDX", iLIMemberIDXG ) '로그인이 필요없이 이동할때 0
        Call mallobj_mp.Set("M_PR", "R" ) 'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
        Call mallobj_mp.Set("M_SGB", iLISportsGb )

        'Call mallobj_mp.Set("M_BNKEY", iProductLocateIDX ) '베너URL 찾아서 보냄 상품코드가 있을시는 ? ...
        Call mallobj_mp.Set("M_BNKEY", "http://www.sdamall.co.kr/mobile/" ) ' 주소 불러서 보내기. 돼는지는 테스트 해야 함, 20181030 JH 수정완료

        strjson_mp = JSON.stringify(mallobj_mp)
        'malljsondata_mp = strjson_mp
        malljsondata_mp = mallencode(strjson_mp,0)

        MALLURL_MP = "http://www.sdamall.co.kr/pub/"
      %>

      <% if (IPHONEYN() = "0") then %>
      <a href="<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>" target="_blank" class="link_medium">
        <span class="txt s_sdamall">스다몰</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_sdamall_black.svg" class="logo s_sdamall" alt="스다몰" />
        </span>
      </a>
      <% else %>
      <a href="javascript:;" onclick="alert('sportsdiary://urlblank=<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>');" class="link_medium">
        <span class="txt s_sdamall">스다몰</span>
        <span class="logo_wrap">
          <img src="http://img.sportsdiary.co.kr/images/SD/logo/logo_sdamall_black.svg" class="logo s_sdamall" alt="스다몰" />
        </span>
      </a>
      <% end if %>
    </div>
  </section>


  <%
    dim UserID      : UserID      = request.Cookies("SD")("UserID")
    If UserID = "csg3268" OR UserID = "jaehongtest" OR UserID = "mujerk" Or UserID = "sjh123" Or UserID = "song0123" Or UserID = "player11" Or InStr(UserID, "sdtest") > 0 Then
  %>
  <div style="text-align:center">
    <a href="./apptestlink.asp">앱테스트링크</a>
  </div>
  <%
    End If
  %>

  <!-- #include file="./include/footer.asp"-->
  <!-- #include file="./include/modal_JoinUs.asp"-->
  <script>
    function cateTab() {
      var $cateBtn = $('.round_btn a');
      var $selected = null;
      $cateBtn.click(function(){
        if ($selected) {
          $selected.removeClass('on');
        }
        $selected = $(this);
        $selected.addClass('on');
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

</div>
</body>
</html>
