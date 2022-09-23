<header id="header" class="l_header" v-clock>
   <div ref="container" class="l_header__links">
      <div class="l_header__links__box">
         <button v-show="isPopup !== true" @click="historyBack()" class="l_header__links__box__btn" type="button">
            <img class="l_header__links__box__btn__img" src="/images/common/icon/back.svg" alt="닫기">
         </button>
      </div>
      <h1 ref="title" class="l_header__links__title">
         <span v-if="h1">{{h1}}</span>
         <a v-else :href="'/pages/'+sports+'/index.asp'"><img class="l_header__links__title__img" :src="'/images/logo/logo_'+sports+'.png'" :alt="sports_name"></a>
      </h1>
      <div v-if="isInfo !== true && isPopup !== true" class="l_header__links__box">
         <button @click="Aside.openAside()" class="l_header__links__box__btn" type="button">
            <img class="l_header__links__box__btn__img" src="/images/common/icon/menu.svg" alt="메뉴 열기">
         </button>
      </div>
      <div v-else-if="isPopup === true" class="l_header__links__box">
         <button @click="history.back()" class="l_header__links__box__btn" type="button">
            <img class="l_header__links__box__btn__img" src="/images/common/icon/close.svg" alt="대진표 닫기">
         </button>
      </div>
      <div v-else class="l_header__links__box">
         <a :href="'/pages/'+sports+'/index.asp'" class="l_header__links__box__btn">
            <img class="l_header__links__box__btn__img" src="/images/common/icon/home.svg" alt="홈으로 가기">
         </a>
      </div>
   </div>
   <!-- <nav class="l_header__nav" v-if="nav_obj">
      <h2 class="ir">{{nav_obj.title}} 네비게이션</h2>
      <ul v-if="nav_idx2 !== null">
         <li v-for="(item1, item1_idx) in nav_obj.list" :class="{s_on:item1_idx === nav_idx2}" class="l_header__nav__ulist">
            <a :href="item1.path">{{item1.str}}</a>
         </li>
      </ul>
      <template v-if="nav_idx3 !== null">
         <h3 class="ir">{{nav_obj.title+'-'+nav_obj.list[nav_idx2].str}} 상세 네비게이션</h3>
         <ul>
            <li v-for="(item2, item2_idx) in nav_obj.list[nav_idx2].list" :class="{s_on:item2_idx === nav_idx3}" class="l_header__nav__ulist-detail">
               <a :href="item2.path">{{item2.str}}</a>
            </li>
         </ul>
      </template>
   </nav> -->
</header>
<script  src="/js/include/header.js<%=INCLUDE_HEADER_VER%>"></script>
