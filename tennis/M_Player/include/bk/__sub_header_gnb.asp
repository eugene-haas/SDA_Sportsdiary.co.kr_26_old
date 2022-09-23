<!-- S: gnb-btn -->
<%If "2월오픈예정" < "2월오픈예정" Then%>
<div class="hamBtn bluy">
  <button class="btn" type="button">메뉴보기</button>
</div>
<%End If%>

<!-- S: right_side -->
<div class="right_side">
  <!-- S: hamBtn -->
  <!-- <div class="hamBtn">
    <a href="#" class="btn menu">
      <span class="ic_deco nav"></span>
    </a>
  </div> -->
  <!-- E: hamBtn -->
  <!-- S: home_btn gnb 열면 제거 -->
  <a href="/tennis/m_player/main/main.asp" class="btn btn_home">
    <span class="ic_deco">
      <i class="fa fa-home"></i>
    </span>
  </a>
  <!-- E: home_btn gnb 열면 제거 -->
</div>
<!-- E: right_side -->

<!-- #include file="./gnbType/player_gnb.asp" -->
<!-- E: gnb-btn -->
