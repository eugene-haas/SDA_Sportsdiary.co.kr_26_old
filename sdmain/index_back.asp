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
   <link rel="stylesheet" href="./css/index.css?ver=0.1.6">
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
               <div class="link_wrap" :class="{s_setting:isSetting, s_selected: sel_obj.id != undefined, s_disabled: isMoving}">
                  <div class="link_sel">
                     <ul id="selBox">
                     </ul>
                     <span>대표 종목을 선택해주세요.</span>
                  </div>
                  <ul id="flex_list">
                  </ul>

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
      let el_l_wrap = document.querySelector('body');
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
const flex_list = function(option, list, sel_obj){
   option = option||{
      el: '#flex_list',
      duration: 500,
      col_len: 5,
      width: 100,
      height: 100,
      template: '<a>$title - $id</a>'
   };

   let el = document.querySelector(option.el);
   let el_sel = (option.el_sel)?document.querySelector(option.el_sel):null;
   const duration = option.duration;
   const col_len = option.col_len;
   const row_len = option.row_len;
   const template = option.template;
   const box_width = (option.width == 'auto')?(el.offsetWidth/col_len):option.width;
   const box_height = (option.height == 'auto')?(el.offsetHeight/row_len):option.height;
   let data_list = list;
   sel_obj = sel_obj||{};
   setBox(data_list);

   if (sel_obj.id != undefined) { // 미리 선택된 종목이 있을 경우
      let strHTML = '';
      strHTML = getTemplate(sel_obj, sel_obj.id);
      el_sel.innerHTML = strHTML;
      el_sel.children[0].classList.add('s_selected');
      el_sel.children[0].dataset.select = true;
      el_sel.children[0].onclick = option.onclick;
      el_sel.children[0].style.transform = 'translate3d('+ 0 + 'px, ' + 0 + 'px, 0)';
   }

   //정규식을 활용해서 html str반환
   function getTemplate(obj, idx){
      obj = obj||{};
      obj.index = idx;
      let str = template||'{id}';
      for (const key in obj) {
         str = str.split('\{'+key+'\}').join(obj[key]);
      }
      return str;
   }
   //data_list를 받아서 list html을 새로생성
   function setBox(data_list){
      if (el.innerHTML) {
         for (var i = 0; i < data_list.length; i++) {
            if (data_list[i].id != i) {
               el.removeChild(el.childNodes[i]);
               break;
            }
         }
      } else {
         let strHTML = '';
         let strHTML_inner = '';
         for (var i = 0; i < data_list.length; i++) {
            strHTML_inner = getTemplate(data_list[i], i);
            strHTML += strHTML_inner;
         }
         el.innerHTML = strHTML;
      }
      let offsetLeft = 0;
      let offsetTop = 0;
      let col_idx = 0;
      let row_idx = 0;
      for (var i = 0; i < el.children.length; i++) {
         if (option.el_sel) {
            el.children[i].onclick = option.onclick;
         }
         col_idx = (i)%col_len;
         row_idx = parseInt((i)/col_len);
         offsetLeft = (col_idx*box_width);
         if (col_idx != 0) {
            offsetLeft += ((box_width-el.children[i].offsetWidth)/(col_len-1))*col_idx;
         }
         offsetTop = (row_idx*box_height);
         // console.log(offsetLeft)
         el.children[i].style.transform = 'translate3d('+ offsetLeft + 'px, ' + offsetTop + 'px, 0)';
      }
   }
   //changedList를 받아서 없어진 요소는 애니메이션 처리 후 setBox
   function changeBox(changedList){
      changedList = changedList||[];
      let goIdx = 0;
      let offsetLeft = 0;
      let offsetTop = 0;
      let col_idx = 0;
      let row_idx = 0;
      for (var i = 0; i < data_list.length; i++) {
         goIdx = -1;
         for (var j = 0; j < changedList.length; j++) {
            if (changedList[j].id == data_list[i].id) {
               goIdx = j;
               break;
            }
         }
         if (goIdx == -1) {
            col_idx = (i)%col_len;
            row_idx = parseInt((i)/col_len);
            offsetLeft = col_idx*box_width;
            if (col_idx != 0) {
               offsetLeft += ((box_width-el.children[i].offsetWidth)/(col_len-1))*col_idx;
            }
            offsetTop = row_idx*box_height;
            if (option.el_sel) {
               // offsetLeft = 0;
               // offsetTop = -110;
               let strHTML = '';
               strHTML = getTemplate(data_list[i], i);
               el.children[i].innerHTML = '';
               el_sel.innerHTML = strHTML;
               el_sel.children[0].dataset.select = true;
               el_sel.children[0].onclick = option.onclick;
               setTimeout(function(){
                  el_sel.children[0].classList.add('s_selected');
               },0)
            }
         } else {
            col_idx = (goIdx)%col_len;
            row_idx = parseInt((goIdx)/col_len);
            offsetLeft = col_idx*box_width;
            if (col_idx != 0) {
               offsetLeft += ((box_width-el.children[i].offsetWidth)/(col_len-1))*col_idx;
            }
            offsetTop = row_idx*box_height;
         }
         $('#'+el.id+'>li').eq(i).transition({ x: offsetLeft, y: offsetTop }, duration, 'ease');
      }
      setTimeout(function(){
         data_list = changedList;
         setBox(data_list);
      },duration);
   }
   //el_sel요소를 특정 위치로 애니메이션
   function addBox(obj, id){
      const goIdx = id;
      const col_idx = (goIdx)%col_len;
      const row_idx = parseInt((goIdx)/col_len);
      let offsetLeft = el.offsetLeft - 0;
      let offsetTop = el.offsetTop - (-110);
      offsetLeft += col_idx*box_width;
      if (col_idx != 0) {
         offsetLeft += ((box_width-el.children[0].offsetWidth)/(col_len-1))*col_idx;
      }
      offsetTop += row_idx*box_height;
      if (el_sel.children.length) {
         el_sel.children[0].innerHTML = '';
         el_sel.children[0].classList.remove('s_selected');
         // $('#'+el_sel.id+'>li').eq(0).transition({ x: offsetLeft, y: offsetTop }, duration);
         setTimeout(function(){
            let strHTML = '';
            strHTML = parseHTML(getTemplate(obj, obj.id));
            el.insertBefore(strHTML, el.children[obj.id]);
            el.children[obj.id].style.transform = '';
            el.children[obj.id].dataset.select = false;
         },duration)
      }
   }
   //sel_obj를 지움
   function removeSel(){
      setTimeout(function(){
         el_sel.innerHTML = '';
      },duration);
   }
   //html 문자열을 받아 node로 변환
   function parseHTML(html) {
      var t = document.createElement('template');
      t.innerHTML = html;
      return t.content.cloneNode(true);
   }
   return {
      getTemplate: getTemplate,
      setBox: setBox,
      changeBox: changeBox,
      addBox: addBox,
      removeSel: removeSel,
      data_list: data_list,
      sel_obj: sel_obj
   };
};
      let vm = new Vue({
         el: "#vue_app",
         data: {
            isMoving: false,
            isSetting: false,
            flex_list: null,
            settingNoti: false,
            option:{
               el: '#flex_list',
               el_sel: '#selBox',
               duration: 400,
               col_len: 2,
               row_len: 4,
               width: 'auto',
               height: 'auto',
               onclick: this.selBox,
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
            sel_obj: {},
            selected_idx: null,
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
               },{
               //    title: '스포츠다이어리',
               //    imgSrc: 'http://img.sportsdiary.co.kr/images/SD/logo/sd_index/logo_sdTV.svg?ver=0.0.2',
               //    linkSrc: 'http://bmapp.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp',
               //    id:6,
               //    class:'link_medium'
               // },{
                  title: '선택안함',
                  linkSrc: '',
                  id:6,
                  class:'link_medium t_none',
                  no: true
               }
            ]
         },
         methods: {
            goUrl: function(path){
               window.location = path;
            },
            openSetting: function(){
               if (this.isMoving || this.isSetting) {
                  return;
               }
               let list = this.menu_list.slice();
               this.isMoving = true;
               if (this.sel_obj.id != undefined) {//sel_obj선택
                  list.splice(this.sel_obj.id, 0, this.sel_obj);
                  this.flex_list.addBox(this.sel_obj, this.sel_obj.id);
                  this.flex_list.changeBox(list);
                  this.flex_list.removeSel();
                  this.menu_list = list;
                  this.selected_idx = this.sel_obj.id;
                  this.sel_obj = {};
                  localStorage.setItem('sel_obj_id', false);
                  let that = this;
                  setTimeout(function(){
                     that.isMoving = false;
                  }, 400);
               } else {
                  this.selected_idx = null;
                  let that = this;
                  setTimeout(function(){
                     that.isMoving = false;
                  }, 400);
               }
               localStorage.setItem('sel_noti', false);
               this.settingNoti = false;
               this.isSetting = true;
            },
            closeSetting: function(){
               if (this.isMoving || !this.isSetting) {
                  return;
               }
               this.isMoving = true;
               if (this.selected_idx != null) {
                  let el = document.querySelector(this.option.el);
                  let idx = this.selected_idx;
                  el.children[idx].classList.add('s_selected');
                  let list = this.menu_list.slice();
                  this.sel_obj = list[idx];
                  list.splice(idx, 1);
                  this.flex_list.changeBox(list);
                  this.menu_list = list;
                  let that = this;
                  setTimeout(function(){
                     that.isSetting = false;
                     that.isMoving = false;
                  },this.option.duration-100);
                  localStorage.setItem('sel_obj_id', this.sel_obj.id);
                  this.selected_idx = null;
               } else {
                  this.isSetting = false;
                  let that = this;
                  setTimeout(function(){
                     that.isMoving = false;
                  },this.option.duration);
               }
            },
            selBox: function(e){
               let el = document.querySelector(this.option.el);
               let data_list = this.menu_list;
               let sel_obj = this.sel_obj;
               if (this.isSetting && !this.isMoving) {
                  e.preventDefault();
               } else {
                  return;
               }
               this.isMoving = true;
               // idx = e.currentTarget.dataset.idx;
               idx = [].indexOf.call(el.children, e.currentTarget);
               if (e.currentTarget.dataset.select == 'true') {//sel_obj선택
                  let list = this.menu_list.slice();
                  list.splice(this.sel_obj.id, 0, this.sel_obj);
                  this.flex_list.addBox(this.sel_obj, this.sel_obj.id);
                  this.flex_list.changeBox(list);
                  this.flex_list.removeSel();
                  this.menu_list = list;
                  this.sel_obj = {};
                  localStorage.setItem('sel_obj_id', false);
                  this.isMoving = false;
                  return;
               }
               if (this.menu_list[idx].no) {//선택안함
                  if (this.sel_obj.id != undefined) {
                     let list = this.menu_list.slice();
                     if (this.sel_obj.id> this.menu_list[idx].id) {
                        idx = this.sel_obj.id - 1;
                     } else{
                        idx = this.sel_obj.id;
                     }
                     list.splice(idx, 0, this.sel_obj);
                     this.flex_list.addBox(this.sel_obj, idx);
                     this.flex_list.changeBox(list);
                     this.flex_list.removeSel();
                     this.menu_list = list;
                     this.sel_obj = {};
                  }
                  let that = this;
                  setTimeout(function(){
                     that.isSetting = false;
                     that.isMoving = false;
                  },this.option.duration-100);
                  localStorage.setItem('sel_obj_id', false);
               } else if (this.sel_obj.id != undefined) {//바꾸기
                  let list = this.menu_list.slice();
                  let sel_idx = null;
                  if (this.menu_list[idx].id>= this.sel_obj.id) {
                     sel_idx = this.sel_obj.id;
                  } else {
                     sel_idx = this.sel_obj.id-1;
                     if (sel_idx < 0) {
                        sel_idx = 0
                     }
                  }
                  this.flex_list.addBox(this.sel_obj, sel_idx);
                  list.splice(this.sel_obj.id, 0, this.sel_obj);
                  this.sel_obj = this.menu_list[idx];
                  list.splice(this.menu_list[idx].id, 1);
                  this.flex_list.changeBox(list);
                  this.menu_list = list;
                  let that = this;
                  setTimeout(function(){
                     that.isSetting = false;
                     that.isMoving = false;
                  },this.option.duration-100);
                  localStorage.setItem('sel_obj_id', this.sel_obj.id);
               } else {//추가
                  el.children[idx].classList.add('s_selected');
                  let list = this.menu_list.slice();
                  this.sel_obj = list[idx];
                  list.splice(idx, 1);
                  this.flex_list.changeBox(list);
                  this.menu_list = list;
                  let that = this;
                  setTimeout(function(){
                     that.isSetting = false;
                     that.isMoving = false;
                  },this.option.duration-100);
                  localStorage.setItem('sel_obj_id', this.sel_obj.id);
               }
            }
         },
         created: function() {
            let sel_obj_id = localStorage.getItem('sel_obj_id');
            let isSelected = false;
            for (var i = 0; i < this.menu_list.length; i++) {
               if (this.menu_list[i].id == sel_obj_id){
                  isSelected = true;
               }
            }
            if (isSelected) {
               this.sel_obj = this.menu_list[sel_obj_id];
               this.menu_list.splice(sel_obj_id, 1);
            }
            let sel_noti = localStorage.getItem('sel_noti');
            if (sel_noti != 'false') {
               let that = this;
               setTimeout(function(){
                  that.settingNoti = true;
               },500)
            }
         },
         mounted:function(){
            setScreenWidth();
            this.flex_list = flex_list({
               el: '#flex_list',
               el_sel: '#selBox',
               duration: this.option.duration,
               col_len: this.option.col_len,
               row_len: this.option.row_len,
               width: this.option.width,
               height: this.option.height,
               onclick: this.selBox,
               template:this.option.template
            },this.menu_list, this.sel_obj);
            $(window).bind("orientationchange", function(e) {
               location.reload();
            });
         }
      });
   </script>
</body>

</html>
