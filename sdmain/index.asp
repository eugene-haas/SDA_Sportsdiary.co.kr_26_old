<!DOCTYPE html>
<html lang="ko">

<head>
   <!-- #include file='./include/head.asp' -->
   <script src="./js/library/jquery.transit.js"></script>
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

'	If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" Then
'		Response.write "여기"
'		Response.end
'	End if


    Response.Cookies("a") = "a"
    Response.Cookies("a").domain = ".sportsdiary.co.kr"
    Response.cookies("a").expires = Date() + 365

    iLISportsGb = SportsGb
  %>
   <script type="text/javascript">
      var apptype = '<%=AppType%>';
      Vue.config.devtools = true;

   </script>
   <link rel="stylesheet" href="./css/fonts.css">
   <link rel="stylesheet" href="./css/index.css?ver=0.1.7">
</head>

<body>
   <div id="vue_app" class="l">
      <section class="sports_category t_flex">
         <h1 class="logo_wrap">
            <img class="logo_wrap__logo" :class="{s_setting:isSetting}" src="images/part/intro_sportsdiary_logo@3x.svg" alt="스포츠다이어리">
            <span class="sports_category__btn-noti" :class="{s_show:settingNoti}">설정 버튼을 눌러서 대표 종목을 설정해보세요.</span>
            <button v-if="!isSetting" @click="openSetting" class="sports_category__btn" type="button">
               <img src="images/part/ico_setting.svg" alt="메뉴 설정 열기">
            </button>
            <button v-else @click="closeSetting" class="sports_category__btn" type="button">
               <img src="images/part/ico_setting-close.svg" alt="메뉴 설정 닫기">
            </button>
         </h1>
         <div role="banner" class="m_banner_wrap" :class="{s_setting:isSetting}">
            <div class="m_banner">
               <a href="/sdmain/preview/sda_net.asp">
               <img src="http://img.sportsdiary.co.kr/images/SD/banner/sd_index_sdaNet.png?ver=0.0.1" alt="LIVE 스포츠 최적화 영상중계솔루션 SDA Net">
               </a>
            </div>
            <!--
            2021-03-03 상단 베너 수정
            2021-06-01 삭제 예정
            <div class="aside">
               <img src="http://img.sportsdiary.co.kr/images/SD/banner/sd_index.svg?ver=0.0.1" alt="">
               <span><em>"모두가 힘들었던 한 해였죠~"</em><br>흰소띠 신축년, 건강한 새해와<br>경기 회복을 기원드립니다.</span>
            </div> -->
            <!--
            2021-05-04 상단 베너 수정
            2021-08-01 삭제 예정
            <div class="m_banner">
               <img src="http://img.sportsdiary.co.kr/images/SD/banner/sd_index_3.svg?ver=0.0.1" alt="힘내세요! &quot;새로운 시즌이 시작되었어요~&quot; 코로나 이겨내서 최상의 기록을 세우시길 응원합니다!">
            </div> -->
            <!-- <div class="m_banner">
               <img src="http://img.sportsdiary.co.kr/images/SD/banner/sd_index_5.png?ver=0.0.1" alt="#가정의 달 스포츠다이어리가 가정의 행복과 건강을 기원합니다.">
            </div> -->
         </div>
         <div class="sports_category__main">
            <section class="link_wrap-box">
               <div class="link_wrap" :class="{s_setting:isSetting, s_selected: sel_obj.id !== undefined, s_disabled: isMoving}">
                  <div class="link_sel">
                     <ul v-if="sel_obj.id !== undefined">
                        <li class="s_selected" @click="selMenuInfo()">
                           <a :href="sel_obj.linkSrc" :class="sel_obj.class">
                              <span class="logo_wrap">
                                 <img :src="sel_obj.imgSrc" class="logo" alt="">
                              </span>
                              <span class="txt">{{sel_obj.title}}</span>
                           </a>
                        </li>
                     </ul>
                     <span>대표 종목을 선택해주세요.</span>
                  </div>
                  <ul ref="flexList" id="flexList">
                  </ul>

                  <%
                  Set mallobj_mp =  JSON.Parse("{}")
                  Call mallobj_mp.Set("M_MIDX", iLIMenuIDXG ) '로그인이 필요없이 이동할때 0
                  Call mallobj_mp.Set("M_PR", "R" ) 'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
                  Call mallobj_mp.Set("M_SGB", iLISportsGb )

                  'Call mallobj_mp.Set("M_BNKEY", iProductLocateIDX ) '베너URL 찾아서 보냄 상품코드가 있을시는 ? ...
                  Call mallobj_mp.Set("M_BNKEY", "http://www.sdamall.co.kr/mobile/" ) ' 주소 불러서 보내기. 돼는지는 테스트 해야 함, 20181030 JH 수정완료

                  strjson_mp = JSON.stringify(mallobj_mp)
                  'malljsondata_mp = strjson_mp
                  malljsondata_mp = mallencode(strjson_mp,0)

                  MALLURL_MP = "http://www.sdamall.co.kr/pub/"
                  %>
               </div>
            </section>
            <div class="l_banner">
               <a target="_blank" href="https://lifearchive.co.kr/">
                  <img src="http://img.sportsdiary.co.kr/images/SD/banner/life_banner.png?ver=0.0.2" alt="라이프 : LIFE Archive Korea">
               </a>
            </div>
         </div>

         <!-- <% if (IPHONEYN() = "0") then %>
         <a href="javascript:;" onclick="alert('sportsdiary://urlblank=<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>');" class="link_large s_sdamall">
            <span class="txt s_sdamall"><em>스</em>포츠인을 위한 혜택을 세우<em>다</em>!<strong>스다몰</strong></span>
         </a>
         <% else %>
         <a href="javascript:;" onclick="alert('sportsdiary://urlblank=<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>');" class="link_large s_sdamall">
            <span class="txt s_sdamall"><em>스</em>포츠인을 위한 혜택을 세우<em>다</em>!<strong>스다몰</strong></span>
         </a>
         <% End if %> -->



         <%'##############################################################
    If test = "test" then
		dim UserID: UserID = request.Cookies("SD")("UserID")
		If UserID = "csg3268" OR UserID = "mujerk" Or InStr(UserID, "sdtest") > 0 Then
		  %>
         <div style="text-align:center">
            <a href="./apptestlink.asp">앱테스트링크</a>
            <%=IPHONEYN%>
            <!--<a href="./apptestlink.asp">앱테스트링크<%=IPHONEYN()%></a>
			<br/>
				-->
            <span onclick="alert('sportsdiary://urlblank=http://naver.com');">alert('sportsdiary://urlblank=http://naver.com') 일때</span>
            <!--
				<br/>
			<a href="<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>">a링크</a>
				-->
         </div>
         <%
	    End If
	End if
	'##############################################################
   %>


         <!-- #include file="./include/footer.asp"-->
         <!-- #include file="./include/modal_JoinUs.asp"-->

   </div>

<script>
function setScreenWidth(){
   const el_l_wrap = document.querySelector('body');
   const minWidth = el_l_wrap.clientWidth;

   if (window.outerWidth < minWidth) {
      if (el_l_wrap) {
         el_l_wrap.style.transform = "scale("+(window.outerWidth / minWidth)+")";
         el_l_wrap.style.height = (window.outerHeight * (minWidth / window.outerWidth)) +'px';
         el_l_wrap.style.overflow = "hidden";
      }
   } else {
      if (el_l_wrap) {
         el_l_wrap.style.transform = null;
         el_l_wrap.style.height = null;
         el_l_wrap.style.overflow = null;
      }
   }
}
setScreenWidth();
window.addEventListener("DOMContentLoaded", setScreenWidth);
window.addEventListener("resize", setScreenWidth);
$(window).bind("orientationchange", function(e) {
   location.reload();
});
const vm = new Vue({
   el: "#vue_app",
   data: {
      isMoving: false, // 애니메이션 여부(true면 다른거 실행 안 하기)
      isSetting: false, // 설정 중인지 여부
      settingNoti: false, // 설정 설명 표시 여부
      option:{
         duration: 400,
         col_len: 2,
         row_len: 4, // css의 row_len도 같이 변경해주세요. calc(100% / 4),calc(100% / 4 - 15px)
         template:
         '<li>'+
            '<a href="{linkSrc}" class="{class}">'+
               '<span class="logo_wrap">'+
                  '<img src="{imgSrc}" class="logo" alt="">'+
               '</span>'+
               '<span class="txt">{title}</span>'+
            '</a>'+
         '</li>'
      },
      sel_obj: {}, // 주종목으로 선택된 menu
      selected_idx: null, // 기존 설정했던 id 저장
      menu_list: [
         {
            title: '유도',
            imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_judo.png?ver=0.0.2',
            linkSrc: 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp',
            id:0,
            class:'link_medium'
         },{
            title: '테니스',
            imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_tennis.svg?ver=0.0.2',
            linkSrc: 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp',
            id:1,
            class:'link_medium'
         },{
            title: '수영',
            imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_swimming.svg?ver=0.0.3',
            linkSrc: 'http://sw.sportsdiary.co.kr/main/index.asp', //http://sw.sportsdiary.co.kr/main/index.asp//'javascript:alert(\'준비중입니다.\')'
            id:2,
            class:'link_medium'
         },{
            title: '승마',
            imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_riding.svg?ver=0.0.3',
            linkSrc: 'http://riding.sportsdiary.co.kr/M_player/main/index.asp',
            id:3,
            class:'link_medium t_riding'
         },{
            title: '레슬링',
            imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_wrestling.svg?ver=0.0.2',
            linkSrc: '/sdmain/preview/wrestling.asp',
            id:4,
            class:'link_medium'
         },{
            title: '배드민턴',
            imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_badminton.svg?ver=0.0.3',
            linkSrc: 'http://bmapp.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp',
            id:5,
            class:'link_medium'
         },
         // {
         //    title: '스포츠다이어리',
         //    imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_sdTV.svg?ver=0.0.2',
         //    linkSrc: 'http://bmapp.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp',
         //    id:6,
         //    class:'link_medium'
         // },
         {
            title: '선택안함',
            linkSrc: '',
            id:6,
            class:'link_medium t_none',
            no: true
         }
      ]
   },
   mounted:function(){
      this.setMenuList();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
			html string을 html node로 변환
         ---------------------------------------------------------------------------------- */
      parseHTML: function (html) {
         var t = document.createElement('template');
         t.innerHTML = html;
         return t.content.cloneNode(true);
      },
      /* -----------------------------------------------------------------------------------
			template에서 변수값에 obj 넣어서 문자열로 반환
         ---------------------------------------------------------------------------------- */
      getTemplate: function (obj, idx){
         obj = obj||{};
         obj.index = idx;
         let str = this.option.template||'{id}';
         for (const key in obj) {
            str = str.split('\{'+key+'\}').join(obj[key]);
         }
         return str || '';
      },
      /* -----------------------------------------------------------------------------------
			this.menu_list의 내용을 바탕으로 list 그리기
         ---------------------------------------------------------------------------------- */
      setMenuList: function (){
         const col_len = this.option.col_len;
         const row_len = this.option.row_len;
         const box_width = this.$refs.flexList.offsetWidth/col_len;
         const box_height = this.$refs.flexList.offsetHeight/this.option.row_len;
         if (this.$refs.flexList.innerHTML) {
            for (var i = 0; i < this.menu_list.length; i++) {
               if (this.menu_list[i].id != i) {
                  this.$refs.flexList.removeChild(this.$refs.flexList.childNodes[i]);
                  break;
               }
            }
         } else {
            let strHTML = '';
            for (var i = 0; i < this.menu_list.length; i++) {
               strHTML += this.getTemplate(this.menu_list[i], i);
            }
            this.$refs.flexList.innerHTML = strHTML;
         }
         let offsetLeft = 0;
         let offsetTop = 0;
         let col_idx = 0;
         let row_idx = 0;
         for (var i = 0; i < this.$refs.flexList.children.length; i++) {
            this.$refs.flexList.children[i].onclick = this.selMenuInfo;
            col_idx = i%col_len;
            row_idx = parseInt(i/col_len);
            offsetLeft = col_idx*box_width;
            if (col_idx != 0) {
               offsetLeft += ((box_width-this.$refs.flexList.children[i].offsetWidth)/(col_len-1))*col_idx;
            }
            offsetTop = row_idx*box_height;
            // console.log(offsetLeft)
            this.$refs.flexList.children[i].style.transform = 'translate3d('+ offsetLeft + 'px, ' + offsetTop + 'px, 0)';
         }
      },
      /* -----------------------------------------------------------------------------------
			menu 정보와 index를 바탕으로 list에 dom 추가
         ---------------------------------------------------------------------------------- */
      addMenuInfo: function(obj, goIdx){
         const col_len = this.option.col_len;
         const row_len = this.option.row_len;
         const box_width = this.$refs.flexList.offsetWidth/col_len;
         const box_height = this.$refs.flexList.offsetHeight/this.option.row_len;
         const col_idx = goIdx%col_len;
         const row_idx = parseInt(goIdx/col_len);
         let offsetLeft = this.$refs.flexList.offsetLeft - 0;
         let offsetTop = this.$refs.flexList.offsetTop + 110;
         offsetLeft += col_idx*box_width;
         if (col_idx != 0) {
            offsetLeft += ((box_width-this.$refs.flexList.children[0].offsetWidth)/(col_len-1))*col_idx;
         }
         offsetTop += row_idx*box_height;
         setTimeout(function(){
            const strHTML = this.parseHTML(this.getTemplate(obj, obj.id));
            this.$refs.flexList.insertBefore(strHTML, this.$refs.flexList.children[obj.id]);
            this.$refs.flexList.children[obj.id].style.transform = '';
         }.bind(this), this.option.duration);
      },
      /* -----------------------------------------------------------------------------------
			변경된 리스트를 바탕으로 애니메이션을 실행하고
         애니메이션 끝나면 this.menu_list에 changedList덮어쓰기
         ---------------------------------------------------------------------------------- */
      changeMenuList: function (changedList){
         const col_len = this.option.col_len;
         const row_len = this.option.row_len;
         const box_width = this.$refs.flexList.offsetWidth/col_len;
         const box_height = this.$refs.flexList.offsetHeight/this.option.row_len;

         let goIdx = 0;
         let offsetLeft = 0;
         let offsetTop = 0;
         let col_idx = 0;
         let row_idx = 0;
         for (var i = 0; i < this.menu_list.length; i++) {
            goIdx = -1;
            for (var j = 0; j < changedList.length; j++) {
               if (changedList[j].id == this.menu_list[i].id) {
                  goIdx = j;
                  break;
               }
            }
            if (goIdx == -1) {
               col_idx = i%col_len;
               row_idx = parseInt(i/col_len);
               offsetLeft = col_idx*box_width;
               if (col_idx != 0) {
                  offsetLeft += ((box_width-this.$refs.flexList.children[i].offsetWidth)/(col_len-1))*col_idx;
               }
               this.$refs.flexList.children[i].innerHTML = '';
               this.sel_obj = this.menu_list[i];
               offsetTop = row_idx*box_height;
            } else {
               col_idx = goIdx%col_len;
               row_idx = parseInt(goIdx/col_len);
               offsetLeft = col_idx*box_width;
               if (col_idx != 0) {
                  offsetLeft += ((box_width-this.$refs.flexList.children[i].offsetWidth)/(col_len-1))*col_idx;
               }
               offsetTop = row_idx*box_height;
            }
            $('#'+this.$refs.flexList.id+'>li').eq(i).transition({ x: offsetLeft, y: offsetTop }, this.option.duration, 'ease');
         }
         setTimeout(function(){
            this.menu_list = changedList;
            this.setMenuList();
         }.bind(this), this.option.duration);
      },
      /* -----------------------------------------------------------------------------------
			설정 버튼 열기
         ---------------------------------------------------------------------------------- */
      openSetting: function(){
         if (this.isMoving || this.isSetting) {
            return;
         }
         const list = this.menu_list.slice();
         this.isMoving = true;
         if (this.sel_obj.id !== undefined) {//sel_obj선택
            list.splice(this.sel_obj.id, 0, this.sel_obj);
            this.addMenuInfo(this.sel_obj, this.sel_obj.id);
            this.changeMenuList(list);
            this.selected_idx = this.sel_obj.id;
            this.sel_obj = {};
            localStorage.setItem('sel_obj_id', false);
            setTimeout(function(){
               this.isMoving = false;
            }.bind(this), 400);
         } else {
            this.selected_idx = null;
            setTimeout(function(){
               this.isMoving = false;
            }.bind(this), 400);
         }
         localStorage.setItem('sel_noti', false);
         this.settingNoti = false;
         this.isSetting = true;
      },
      /* -----------------------------------------------------------------------------------
			설정 닫기 버튼 클릭
         ---------------------------------------------------------------------------------- */
      closeSetting: function(){
         if (this.isMoving || !this.isSetting) {
            return;
         }
         this.isMoving = true;
         if (this.selected_idx !== null) {
            const idx = this.selected_idx;
            const list = this.menu_list.slice();
            this.$refs.flexList.children[idx].classList.add('s_selected');
            this.sel_obj = list[idx];
            list.splice(idx, 1);
            this.changeMenuList(list);
            setTimeout(function(){
               this.isSetting = false;
               this.isMoving = false;
            }.bind(this),this.option.duration-100);
            localStorage.setItem('sel_obj_id', this.sel_obj.id);
            this.selected_idx = null;
         } else {
            this.isSetting = false;
            setTimeout(function(){
               this.isMoving = false;
            }.bind(this),this.option.duration);
         }
      },
      /* -----------------------------------------------------------------------------------
			설정 상태에서 어떤 종목 선택
         ---------------------------------------------------------------------------------- */
      selMenuInfo: function(e){
         if (!this.isSetting || this.isMoving) {
            return;
         }
         e.preventDefault();
         this.isMoving = true;
         const idx = [].indexOf.call(this.$refs.flexList.children, e.currentTarget);
         if (this.menu_list[idx].no) {//선택안함
            if (this.sel_obj.id !== undefined) {
               const list = this.menu_list.slice();
               let targetIdx = null;
               if (this.sel_obj.id > this.menu_list[idx].id) {
                  targetIdx = this.sel_obj.id - 1;
               } else{
                  targetIdx = this.sel_obj.id;
               }
               list.splice(targetIdx, 0, this.sel_obj);
               this.addMenuInfo(this.sel_obj, targetIdx);
               this.changeMenuList(list);
               this.sel_obj = {};
            }
            setTimeout(function(){
               this.isSetting = false;
               this.isMoving = false;
            }.bind(this), this.option.duration-100);
            localStorage.setItem('sel_obj_id', false);
         } else if (this.sel_obj.id !== undefined) {//바꾸기
            const list = this.menu_list.slice();
            let sel_idx = null;
            if (this.menu_list[idx].id>= this.sel_obj.id) {
               sel_idx = this.sel_obj.id;
            } else {
               sel_idx = this.sel_obj.id-1;
               if (sel_idx < 0) {
                  sel_idx = 0
               }
            }
            this.addMenuInfo(this.sel_obj, sel_idx);
            list.splice(this.sel_obj.id, 0, this.sel_obj);
            this.sel_obj = this.menu_list[idx];
            list.splice(this.menu_list[idx].id, 1);
            this.changeMenuList(list);
            setTimeout(function(){
               this.isSetting = false;
               this.isMoving = false;
            }.bind(this), this.option.duration-100);
            localStorage.setItem('sel_obj_id', this.sel_obj.id);
         } else {//추가
            this.$refs.flexList.children[idx].classList.add('s_selected');
            const list = this.menu_list.slice();
            this.sel_obj = list[idx];
            list.splice(idx, 1);
            this.changeMenuList(list);
            setTimeout(function(){
               this.isSetting = false;
               this.isMoving = false;
            }.bind(this), this.option.duration-100);
            localStorage.setItem('sel_obj_id', this.sel_obj.id);
         }
      }
   },
   created: function() {
      const sel_obj_id = localStorage.getItem('sel_obj_id');
      const isSelected = !!this.menu_list.find(function(menu_info){
         return menu_info.id == sel_obj_id;
      });
      if (isSelected) {
         this.sel_obj = this.menu_list[sel_obj_id];
         this.menu_list.splice(sel_obj_id, 1);
      }
      const sel_noti = localStorage.getItem('sel_noti');
      if (sel_noti !== 'false') {
         setTimeout(function(){
            this.settingNoti = true;
         }.bind(this), 500);
      }
   },
});
</script>
</body>

</html>
