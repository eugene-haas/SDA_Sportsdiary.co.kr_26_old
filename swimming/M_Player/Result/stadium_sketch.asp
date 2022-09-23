<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->

  <!-- <link rel="stylesheet" href="http://sdmain.sportsdiary.co.kr/sdmain/css/library/swiper.min.css">
  <script src="http://sdmain.sportsdiary.co.kr/sdmain/js/library/swiper.min.js"></script> -->
</head>
<body>
<div id="app" class="l" v-bind:class="{s_xdata: no_data}" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">현장스케치</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

		<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll stadium_sketch sd-main-A [ _content _scroll ]" v-bind:class="{s_xdata: no_data}">

    <div class="m_searchTags">
      <div class="m_searchTags__infoBox">
        <p class="m_searchTags__infoTxt">{{agePickChk}}<span>&#44;</span></p>
        <p class="m_searchTags__infoTxt">{{gamePickChk}} </p>
        <button class="m_searchTags__btn" @click="openSearching"><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt=""></div></button>
      </div>
    </div>

    <div class="sd_photoList">
      <!-- 등록된 이미지가 없을 경우.  검색버튼 선택 함수에 app.no_data=true  -->
      <div v-if="no_data" class="m_dataEmpty"><img src="http://img.sportsdiary.co.kr/images/SD/img/empty_image_@3x.png" alt="등록된 이미지가 없습니다"></div>
      <!-- // 등록된 이미지가 없을 경우 -->

      <!-- 등록된 이미지가 있을 경우 -->
      <div id="List" v-if="!no_data">
        <div class="m_loadingbar" v-if="loading" v-bind:class="{m_dflex: loading}">
          <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
        </div>
        <div class="photoList_wrap">
          <!-- <span class="sd_photoList__item" v-for="(listimg, key) in sketch_list"><span class="sd_photoList__itemInner"><img :src="listimg" alt=""></span></span> -->
        </div>
      </div>
      <div v-if="list_more && !no_data"><button id="More" class="sd_photoList__more" @click="listMore">더보기</button></div>
      <!-- // 등록된 이미지가 있을 경우 -->
    </div>
  </div>
  <!-- E: main -->

  <!-- search popup -->
  <div class="l_upLayer [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox m_searching__area [ _overLayer__box ]">

      <div class="m_searchPopup__header">
        <button class="m_searchPopup__close [ _overLayer__close ]" @click="closePopup"><img src="http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png" alt="닫기"></button>
      </div>

      <div class="l_upLayer__wrapCont m_searchPopup__cont [ _overLayer__wrap ]">
        <div class="m_searchPopup__control no_search">
          <button class="m_searchPopup__fliter">필터</button>
          <button type="button" class="m_searchPopup__submit [ _searching ]" @click="popupSearchOption"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt="조회"></button>
        </div>
        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">
          <div class="m_searchPopup__panel">
            <p class="m_searchPopup__cehckTit">기간</p>
            <div class="m_searchPopup__checkWrap">
              <div class="m_searchPopup__checkGroup">
                <span v-for="(age,key) in age_list">
                  <input type="radio" name="search_age" v-bind:id="popupIdFor('search_age',key)" hidden v-model="agePick" v-bind:value="age.year"><label v-bind:for="popupIdFor('search_age',key)">{{age.year}}</label>
                </span>
              </div>
            </div>
            <p class="m_searchPopup__cehckTit">대회명</p>
            <div class="m_searchPopup__checkWrap">
              <div class="m_searchPopup__checkGroup" v-for="(gn,key) in gamename_list" v-if="key==0 || key%4==0">
                <span v-for="(gamename,key2) in gamename_list" v-if="key2>=key && key2<(key/4+1)*4">
                  <input type="radio" name="search_game_name" v-bind:id="popupIdFor('search_game_name',key2)"  hidden v-model="gamePick" v-bind:value="gamename.name" @change="tidxChange(gamename.tidx)">
                  <label v-bind:for="popupIdFor('search_game_name',key2)">{{gamename.name}}</label>
                </span>
              </div>
            </div>
          </div>

          <!-- <div class="m_searchPopup__panel [ _panelPlayerList ]" id="searchplayerlist">
          </div> -->

        </div>
      </div>
    </div>
  </div>
  <!-- // search popup -->

	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>

<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  let app=new Vue({
    el:"#app",
    data:{
      no_data:false,// 등록된 이미지가 있으면 false, 없으면 true
      loading:false,// data불러왔는지 유무
      sketch_list:[],// 불러온 data가 연결되는 곳
      sketch_PN_page:null,//현재 불러오는 data의 페이지 수
      sketch_PN:0,// 현재 불러오는 data 파일의 번호(몇번째인지)
      sketch_basic_len:10,// json data 기본 개수
      tidx:null,//
      sketch_pastlen:null,// 이전에 보여진 목록 수
      list_more:false,// 더보기 버튼 나오는지 여부

      // popup 관련
      agePick:null,// 기간
      gamePick:null,// 대회명
      agePickChk:null,// 선택된 기간
      gamePickChk:null,// 선택된 대회명
      age_list:[],
      gamename_list:[],
      layer:null,// popup layer

      
      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      initList:function(){
        // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"136","PN":"4"}
        this.sketch_PN_page=null;
        this.sketch_PN=0;
        this.sketch_list=[];
        this.sketch_pastlen=null;
        if(!this.no_data) document.querySelector(".photoList_wrap").innerHTML="";

        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+this.tidx+'","PN":"","PT":"Y"}').then(response=>{
          this.sketch_PN_page=Number(response.data.jlist[0].page);// 전체 페이지 수

          // 불러온 내용이 없으면
          if(this.sketch_PN_page==0){
            this.no_data=true;
            return;
          }else{
            this.no_data=false;
          }

          this.sketchList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+this.tidx+'","PN":"'+(this.sketch_PN+1)+'"}');// json
        });
      },
      sketchList:function(sketch_img_urls){
        this.loading=true;
        axios.get(sketch_img_urls).then(response=>{
          this.loading=false;

          let urls=response.data.jlist, imgs="";
          for(var i=0;i<urls.length;i++){
            // 아래 링크는 확인용
            imgs+="<a href='stadium_sketch_detail.asp?"+this.tidx+"-"+(Math.ceil((this.sketch_pastlen+(i+1))/10))+"-"+(i+1)+"' class='sd_photoList__item'><span class='sd_photoList__itemInner'><img src="+urls[i].link+" alt=''></span></a>";// ---.asp?tidx-PN번호-선택한 이미지번호
            this.sketch_list.push(urls[i].link);
          }
          $(".photoList_wrap").append(imgs);

          // 더보기 버튼
          if(this.sketch_PN<this.sketch_PN_page-1){
            this.list_more=true;
          }else{
            this.list_more=false;
            return;
          }
        });
      },
      // 목록 있으면 추가
      listMore:function(){
        // this.sketch_PN>0? this.sketch_PN-=1 : this.sketch_PN=0;
        this.sketch_PN+=1;
        this.sketch_pastlen=this.sketch_list.length;// 이전 목록 수
        this.sketchList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+this.tidx+'","PN":"'+(this.sketch_PN+1)+'"}');
      },


      // tidx change
      tidxChange:function(tidx){
        this.tidx=tidx;
      },
      // popup list
      popupList:function(url){
        axios.get(url).then(response=>{
          this.age_list=response.data.jlist[0].age;
          this.gamename_list=response.data.jlist[0].gamename;

          // 기본 조건
          this.agePickChk=this.agePick=this.age_list[0].year;
          this.gamePickChk=this.gamePick=this.gamename_list[0].name;
        });
      },
      // 검색버튼 선택
      popupSearchOption:function(){
        this.agePickChk=this.agePick;
        this.gamePickChk=this.gamePick;
        this.initList();

        this.layer.close();
        setTimeout(()=>{
          $(".m_searchPopup__checkWrap").scrollLeft(0);
        },230);
      },
      // 팝업 닫을 때 선택한 옵션 처음 옵션으로
      closePopup:function(){
        setTimeout(()=>{
          this.agePick=this.agePickChk;
          this.gamePick=this.gamePickChk;
          $(".m_searchPopup__checkWrap").scrollLeft(0);
        },230);
      },
      // show popup
      openSearching:function(){
        $('._filterBtn').removeClass('s_on');
        $('._sliderWrap').addClass('s_filtering');
        $('._sliderWrap').removeClass('s_searching');
        this.layer.open();
      }
    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }
      
      if(window.matchMedia("(orientation:landscape)").matches){
        $("html").addClass("landscape");
      }else{
        $("html").removeClass("landscape");
      }
      window.addEventListener("orientationchange", function(){
        if(window.matchMedia("(orientation:portrait)").matches){
          $("html").addClass("landscape");
        }else{
          $("html").removeClass("landscape");
        }
      },false);

      let now=new Date();
      this.agePickChk=now.getFullYear();

      // 위에서 tidx는 지정한 이유는, 이 파일을 바로 열었을 때의 확인용 값
      let urlparam_tidx=location.href.indexOf("tidx=");
      if(urlparam_tidx>0){
        let param_tidx=location.href.substr(urlparam_tidx+5);// +5는 t i d x = 다음의 위치
        this.tidx=param_tidx;
      }
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      let referrer=document.referrer || "./stadium_sketch.asp";
      history.replaceState("list", null, null);
      window.onpopstate=(evt)=>{
        if(evt.state=="list" && this.layer.status=="open"){
          this.layer.close();
        }else{
          location.href=referrer;
        }
      }
      this.layer=new OverLayer({
        overLayer:$("._searchLayer"),
        emptyHTML:"정보를 불러오고 있습니다.",
        errorHTML:"",
      });
      this.layer.on("beforeOpen",function(){history.pushState("view",null,null)});
      this.layer.on("beforeClose",function(){history.pushState("list",null,null)});
      

      // popup
      // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"81000","YS":"2019"}
      axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"81000","YS":"'+this.agePickChk+'"}').then(response=>{
        this.age_list=response.data.jlist[0].age;
        this.gamename_list=response.data.jlist[0].gamename;

        // 기본 조건
        this.agePickChk=this.agePick=this.age_list[0].year;
        if(this.tidx==null){
          this.gamePickChk=this.gamePick=this.gamename_list[0].name;
          this.tidx=this.gamename_list[0].tidx;
        }
        // created에서 받은 tidx를 찾아 해당 타이틀 가져오기
        else{
          let urlparam_txt;
          for(var i in this.gamename_list){
            if(this.gamename_list[i].tidx==this.tidx){
              urlparam_txt=this.gamename_list[i].name;
            }
          }
          this.gamePickChk=this.gamePick=urlparam_txt;
        }

        // 연도에 맞는 목록
        this.initList();
      });
    },
  });
</script>
</body>
</html>
