<nav id="nav" class="l_nav" v-clock>
   <div class="l_nav__header">
      <a :href="first_page && first_page.Link">
         <img src="/images/logo_sm.svg" alt="Evaluation Management System">
      </a>
   </div>
   <ul class="l_nav__con">
      <li v-for="nav_info1 in nav_list" class="l_nav__list">
         <a :href="nav_info1.Link" :target="nav_info1.PopupYN === 'Y'?'_blank':''" @mouseover="handleMouseOver(nav_info1)" @mouseleave="handleMouseLeave(nav_info1)" class="l_nav__link" :class="{'l_nav__link--active':nav_info1.isActive || nav_info1.isHover}">
            <img v-if="nav_info1.ImgLink && (nav_info1.isActive || nav_info1.isHover)" class="l_nav__img" :src="nav_info1.ImgLink.replace('.svg', '_white.svg')" alt="">
            <img v-else class="l_nav__img" :src="nav_info1.ImgLink" alt="">
            {{nav_info1.RoleDetailGroup1Nm}}
         </a>
         <ul v-if="nav_info1.isActive && 1 < nav_info1.nav_list2.length" class="l_nav__inner">
            <li v-for="nav_info2 in nav_info1.nav_list2" class="l_nav__inner-list">
               <a v-html="nav_info2.RoleDetailGroup2Nm" :href="nav_info2.Link || undefined" class="l_nav__inner-link" :class="{'l_nav__inner-link--active':nav_info2.isActive, 'l_nav__inner-link--title': !nav_info2.Link}">
               </a>
            </li>
         </ul>
      </li>
   </ul>
   <div class="l_nav__footer">
      <img src="/images/logo_SD.svg" alt="스포츠다이어리">
   </div>
</nav>
<script src="/js/include/nav.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
