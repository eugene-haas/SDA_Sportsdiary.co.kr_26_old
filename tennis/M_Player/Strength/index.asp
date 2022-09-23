<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
    PlayerReln      =  decode(Request.Cookies("PlayerReln"),0)

    check_login()


if IsNull(fInject(Request("TrRerdDate")))then
    if IsNull(fInject(Request("StimFistCd_h")))then
       datetimepicker1_h=Date()
    else
        if fInject(Request("datetimepicker1_h"))="" then
           datetimepicker1_h=Date()
        else
            datetimepicker1_h=fInject(Request("datetimepicker1_h"))
        end if
    end if
else
   datetimepicker1_h=fInject(Request("TrRerdDate"))
    StimFistCd_h="0"
end if


    if IsNull(fInject(Request("StimFistCd_h")))then
        StimFistCd_h="0"
    else
         if fInject(Request("StimFistCd_h"))="" then
           StimFistCd_h="0"
        else
            StimFistCd_h=fInject(Request("StimFistCd_h"))
        end if
    end if

%>
<script type="text/javascript">
    var PlayerReln = "<%=PlayerReln %>";
    var subTopCate = 2;
</script>
<script  type="text/javascript" src="../js/Strength.js"></script>
<body>
<form name="frm" id="frm" method="post">
  <input type="hidden" name="LeaderIDX" id="LeaderIDX" value="" >
  <input type="hidden" name="StimFistCd_h" id="StimFistCd_h" value="<%=StimFistCd_h %>">
  <input type="hidden" name="datetimepicker1_h"id="datetimepicker1_h"   value="<%=datetimepicker1_h %>">
  <input type="hidden" name="COUNT"id="COUNT">
  <input type="hidden" name="p_TEAMTRAI"id="p_TEAMTRAI">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>체력측정</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub train strength">
    <div class="top-icon-menu">
      <%
        '회원구분에 따른 메뉴 include
        SELECT CASE decode(request.Cookies("PlayerReln"), 0)
          CASE "D"
          %>
          <!-- S: include top-menu -->
          <!-- #include file = '../include/sub_topmenu/monoType/topmenu.asp' -->
          <!-- E: include top-menu -->
          <%
          CASE "A", "B", "Z"
          %>
          <!-- S: include parents-type 보호자 회원 menu -->
          <!-- #include file = '../include/sub_topmenu/parentsType/topmenu.asp' -->
          <!-- E: include parents-type 보호자 회원 menu -->
          <%
          CASE ELSE
          %>
          <!-- S: include player-type 선수 회원 menu-->
          <!-- 엘리트, 국가대표, 생활체육 선수 -->
          <!-- #include file = '../include/sub_topmenu/playerType/topmenu.asp' -->
          <!-- E: include player-type 선수 회원 menu-->

          <%
        END SELECt
      %>
      <p>나의 체력 상태를 입력하고 <span>동일체급</span> <br /> 혹은
      <span>국가대표 선수</span>의 체력과 비교해보세요.</p>
    </div>
    <!-- S : datepicker-wrap 훈련날짜 -->
    <div class="datepicker-wrap">
      <label for="datetimepicker1">측정날짜</label>
      <div class='input-group date' >
        <input id="datetimepicker1" type="date" class="form-control" onChange="DateAfer(); return false;" value="<%=datetimepicker1_h %>"/>
        <span class="input-group-addon">
          <span class="glyphicon glyphicon-calendar"></span>
        </span>
      </div>
      <a href="#" class="btn-navy" onClick="DateToday(); return false;">오늘</a>
    </div>
    <!-- E : datepicker-wrap 훈련날짜 -->
    <!-- S : 컨디션 -->
    <div class="navyline-top-list">
        <label for="StimFistCd">측정항목</label>
        <select id="StimFistCd"onchange='StimFistCd_serch();'>
        </select>
    </div>

     <div id="guide-tip" class="navyline-top-list guide-tip clearfix"> </div>
     <div class="exc-list">
      <ul id ="exc-list" >
      </ul>
    </div>
    <div class="container">
      <a href="#" class="btn-full" onClick="SaveData(); return false;">기록 저장</a>
    </div>
    <%if PlayerReln="A" OR PlayerReln="B" OR PlayerReln="Z" THEN %>
    <%ELSE %>

    <%END IF %>
   </div>
  <!-- E : sub -->

  <!-- S: strength-index -->
  <div class="main strength-index">
    <div class="main-bg">
      <span class="ic-deco">
        <img src="http://img.sportsdiary.co.kr/sdapp/strength/ic_heart@3x.png" alt/>
      </span>
      <!-- S: main-tit -->
      <div id="StimMidCd" class="main-tit">
        <h3>근력,근파워,민첩성,유연성<br>근지구력,협응력,심폐지구력</h3>
        <p>나의 체력을 측정해보세요!</p>
      </div>
      <!-- E: main-tit -->
    </div>
  </div>
    <!-- E: strength-index -->


  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->

  <script>
    /**
   * 훈련일지, 대회일지, 체력측정 top-icon-menu 인덱싱
   */
    function subMenuCate(menu, cateIdx){
      var $menu = null; // top-icon-menu
      var $menuImg = null; // 메뉴 이미지
      var $menuLi = null; // 메뉴 li
      var menuImgSrc = []; // 메뉴 이미지 src

      if (cateIdx == undefined) {
        return;
      }

      function _init(menu){
        $menu = $(menu);
        $menuImg = $('img', $menu);
        $menuLi = $('li', $menu);
        $menuImg.each(function(){
          menuImgSrc.push($(this).context.src)
        });
      }

      function _evt(cateIdx){
        var onImg;
        var onIdx;
        for (var i in menuImgSrc) {
          onImg = menuImgSrc[i].match('_on');
          onIdx = i;
          break;
        }
        var findOnImg = onImg.input.replace('_on', '_off');
        _solveOnImg(onIdx, findOnImg);
        _chkOnImg(cateIdx);
      }

      function _chkOnImg(cateIdx){
        var onSrc = menuImgSrc[cateIdx].replace('_off','_on');
        $menuLi.eq(cateIdx).find('img').attr('src', onSrc);
      }

      function _solveOnImg(idx, findOnImg) {
        $menuLi.eq(idx).find('img').attr('src', findOnImg);
      }

      _init(menu);
      _evt(cateIdx)
    }

    subMenuCate('.top-icon-menu', subTopCate); // top-icon-menu 인덱싱
  </script>
</form>
</body>
