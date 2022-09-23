<header id="header" class="l_header">
   <span class="l_header__user-info">
      <strong class="l_header__user-info__name">{{user_info[user_info.aDK]}}</strong>
      님
   </span>
   <button @click="reqLogout()" class="l_header__btn-logout" type="button">Log out</button>
</header>

<script src="/js/include/header.js?ver=1.0.0.1<%=GLOBAL_VER%>"></script>
