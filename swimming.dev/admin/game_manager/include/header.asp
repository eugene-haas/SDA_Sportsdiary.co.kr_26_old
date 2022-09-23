
<script>
   const g_user_info = <%=Cookies_adminDecode%> || null;
   if (g_user_info === null) {
      alert('로그인해주세요.')
      window.location = '/game_manager/index.asp'
   }
</script>
<header id="header" class="l_header" v-clock>
   <a v-show="g_page_props.hideBack !== true" class="l_header__btn-back" href="javascript:history.back()">
      뒤로가기
   </a>
   <h1 ref="title" class="l_header__title">{{user_info.C_TNAME}}</h1>
   <span class="l_header__text t_right">{{user_info.C_ID}}</span>
   <button @click="reqLogout()" class="m_btn t_size-s t_dark-blue" type="button">로그 아웃</button>
</header>
<script src="/game_manager/js/include/header.js<%=INCLUDE_HEADER_VER%>"></script>
