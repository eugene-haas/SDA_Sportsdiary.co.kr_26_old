<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->
</head>
<body>
<div id="app" class="l gameVideo" v-bind:class="{s_xdata: no_data}" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">경기영상</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

		<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll sd-main-A [ _content _scroll ]" v-bind:class="{s_xdata: no_data}">

    <div class="m_searchTags">
      <div class="m_searchTags__infoBox">
        <p class="m_searchTags__infoTxt" v-if="search_txt==''">{{agePickChk}}년<span>&#44;</span> </p>
        <p class="m_searchTags__infoTxt" v-if="search_txt==''">{{gamePickChk}}<span>&#44;</span> </p>
        <p class="m_searchTags__infoTxt" v-if="search_txt==''">{{eventPickChk}}<span v-if="search_txt!=''">&#44;</span> </p>
        <p class="m_searchTags__infoTxt" v-if="search_txt!=''">{{search_txt}}</p>
        <button class="m_searchTags__btn" @click="openSearching"><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt=""></div></button>
      </div>

      <div class="gamemovie" v-bind:class="{s_noVideo: no_data}">
        <!-- 등록된 이미지가 없을 경우.  검색버튼 선택 함수에 app.no_list=true  -->
        <div v-if="no_data" class="m_dataEmpty"><img src="http://img.sportsdiary.co.kr/images/SD/img/empty_video_@3x.png" alt="등록된 영상이 없습니다"></div>
        <!-- // 등록된 이미지가 없을 경우 -->

        <div v-if="!no_data">
          <div class="m_loadingbar" v-if="loading" v-bind:class="{m_dflex: loading}">
            <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
          </div>
          <div v-else>
            <a v-for="(list,key) in gameMovieList" v-bind:href="detailUrl(list.url)">
              <div class="gamemovie__img m_img"><img v-bind:src="list.movieimg" alt=""></div>
              <div class="gamemovie__info">
                <p class="gamemovie__title">{{list.title}}</p>
                <p class="gamemovie__sno">조회수 {{list.sno}}회</p>
              </div>
            </a>
          </div>

        </div>
      </div>
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
        <div class="m_searchPopup__control">
          <button class="m_searchPopup__fliter [ _filterBtn ]">필터</button>
          <input type="text" placeholder="영상제목을 입력해주세요." value="" class="m_searchPopup__input s_ignore [ _searchingInput ] " v-model="keyword" v-on:input="keyword=$event.target.value" @keyup="inputKeyup">
          <button type="button" class="m_searchPopup__submit [ _searching ]" @click="popupSearchOption"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt="조회"></button>
        </div>
        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">
          <div class="m_searchPopup__panel">
            <p class="m_searchPopup__cehckTit">기간</p>
            <div class="m_searchPopup__checkWrap">
              <div class="m_searchPopup__checkGroup">
                <span v-for="(age,key) in popup_age_list">
                  <input type="radio" name="search_age" v-bind:id="popupIdFor('search_age',key)" hidden v-model="agePick" v-bind:value="age.year"><label v-bind:for="popupIdFor('search_age',key)">{{age.year}}</label>
                </span>
              </div>
            </div>
            <p class="m_searchPopup__cehckTit">대회명</p>
            <div class="m_searchPopup__checkWrap">
              <div class="m_searchPopup__checkGroup" v-for="(gn,key) in popup_gamename_list" v-if="key==0 || key%4==0">
                <span v-for="(gamename,key2) in popup_gamename_list" v-if="key2>=key && key2<(key/4+1)*4 && gamename.name!=''">
                  <input type="radio" name="search_game_name" v-bind:id="popupIdFor('search_game_name',key2)"  hidden v-model="gamePick" v-bind:value="gamename.name" @change="valueChange('tidx',gamename.tidx)">
                  <label v-bind:for="popupIdFor('search_game_name',key2)">{{gamename.name}}</label>
                </span>
              </div>
            </div>
            <p class="m_searchPopup__cehckTit">종목</p>
            <div class="m_searchPopup__checkWrap">
              <div class="m_searchPopup__checkGroup" v-for="(gp,key) in popup_event_list" v-if="key==0 || key%4==0">
                <span v-for="(ev,key2) in popup_event_list" v-if="key2>=key && key2<(key/4+1)*4 && ev.name!=''">
                  <input type="radio" name="search_event" v-bind:id="popupIdFor('search_event',key2)" hidden v-model="eventPick" v-bind:value="ev.name" @change="valueChange('levelno',ev.levelno)"><label v-bind:for="popupIdFor('search_event',key2)">{{ev.name}}</label>
                </span>
              </div>
            </div>
          </div>

          <div class="m_searchPopup__panel [ _panelGamemovieList ]" id="searchGamemovieList">
            <div v-if="keyword!='' && search_list!='nodata'">
              <button class="m_searchPopup__listname [ _searchName ]" v-for="(stxt,key) in search_list" @click="popupSearchChoice(stxt.title,stxt.vidx)">{{stxt.title}}<span class="icon__search_add"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_add_@3x.png"></span></button>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
  <!-- // search popup -->

	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>

<script>
  $(document).ready(function(){
    $('._filterBtn').on('click', function(){
      $('._sliderWrap').addClass('s_filtering');
      $('._sliderWrap').removeClass('s_searching');

      $('._filterBtn').removeClass('s_on');
      $('._searchingInput').removeClass('s_on');
    })
    $('._searchingInput').on('click', function(){
      $('._sliderWrap').removeClass('s_filtering');
      $('._sliderWrap').addClass('s_searching');

      $('._filterBtn').addClass('s_on');
      $('._searchingInput').addClass('s_on');
    });
  });
</script>
<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  let app=new Vue({
    el:"#app",
    data:{
      loading:false,// data불러왔는지 유무

      // list
      gameMovieList:[],// 목록
      no_data:false,// 등록된 영상이 있으면 false, 없으면 true

      // 검색 관련
      agePickChk:null,// 선택된 기간
      gamePickChk:null,// 선택된 대회명
      tidx:null,
      eventPickChk:null,// 선택된 종목명
      levelno:null,
      // popup 관련
      agePick:null,// 기간
      gamePick:null,// 대회명
      eventPick:null,// 종목
      popup_age_list:[],
      popup_gamename_list:[],
      popup_event_list:[],

      search_list:[],// 검색되는 목록
      search_txt:"",// 검색하고 선택된 단어
      keyword:"",// 검색어

      layer:null,//

      
      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      // list
      movieList:function(url){
        this.loading=true;
        this.no_data=false;
        this.gameMovieList=[];
        axios.get(url).then(response=>{
          this.loading=false;
          this.gameMovieList=response.data.jlist;
          if(this.gameMovieList=="nodata"){
            this.no_data=true;
          }
        });
      },
      // video url
      detailUrl:function(url){
        return "gamevideo_detail.asp?"+url;
      },

      // popup list
      popupList:function(){
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"71000"}').then(response=>{
          this.popup_age_list=response.data.jlist[0].age;
          this.popup_gamename_list=response.data.jlist[0].gamename;
          this.popup_event_list=response.data.jlist[0].events;

          // 기본 조건
          this.agePickChk=this.agePick=this.popup_age_list[0].year;
          this.gamePickChk=this.gamePick=this.popup_gamename_list[0].name;
          this.tidx=this.popup_gamename_list[0].tidx;
          this.eventPickChk=this.eventPick=this.popup_event_list[0].name;
          this.levelno=this.popup_event_list[0].levelno;
        });
      },
      // tidx change
      valueChange:function(name,change){
        this[name]=change;
      },
      // 검색버튼 누를 때 선택된 내용이 화면에 보여지게
      popupSearchOption:function(){
        if(this.keyword==""){
          this.search_txt="";
          this.movieList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"70000","tidx":"'+this.tidx+'","levelno":"'+this.levelno+'"}');// 선택된 영상 목록 json
        }else{
          if(this.search_list!="nodata"){
            this.search_txt=this.keyword;

            // 검색어에 맞는 영상이 여러개 일 때. 해당값을 "vidxsearch":"1,21,3,44"... 이렇게 보냄
            let vidxall="";
            for(len in this.search_list){
              vidxall=vidxall+(this.search_list[len].vidx)+",";
            }
            this.movieList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"70000","tidx":"'+this.tidx+'","vidxsearch":"'+vidxall.substr(0,vidxall.lastIndexOf(","))+'"}');// 선택된 영상 목록 json
          }else{
            this.keyword="";
            alert("검색 결과가 없습니다.");
            return;
          }
        }
        this.layer.close();
        this.keyword="";

        this.agePickChk=this.agePick;
        this.gamePickChk=this.gamePick;
        this.eventPickChk=this.eventPick;
        setTimeout(()=>{
          $(".m_searchPopup__checkWrap").scrollLeft(0);
        },200);
      },
      // 검색어 검색
      searchList:function(url){
        this.search_list=[];
        axios.get(url).then(response=>{
          this.search_list=response.data.jlist;
        },(error)=>{
          console.log("error. searchList :")
          console.log(error);
        });
      },
      // 텍스트 입력
      inputKeyup:function(e){
        // v-model="keyword" 대신 v-on:input="keyword==$event.target.value" 사용함. IME를 요구하는 언어가 제대로 업데이트 되기 위해서.
        // console.log(e.key+"_"+this.keyword);
        if(e.keyCode!=13){
          // 검색어를 적다가 지워서 값이 없으면("") 전체가 보여지기 때문에
          if(this.keyword==" ") this.keyword="";
          if(this.keyword!=""){
            this.searchList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"71100","searchtxt":"'+this.keyword+'"}');
          }
        }
        if(e.keyCode==13){
          this.popupSearchOption();
          e.target.blur();
        }
      },
      // 미리보기 단어 선택
      popupSearchChoice:function(txt,vid){
        this.layer.close();
        this.search_txt=txt;
        this.keyword="";
        this.movieList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"70000","vidxsearch":"'+vid+'"}');
        this.search_list=[];
      },
      // 팝업 닫을 때 선택한 옵션 처음 옵션으로
      closePopup:function(){
        setTimeout(()=>{
          this.keyword="";
          this.agePick=this.agePickChk;
          this.gamePick=this.gamePickChk;
          this.eventPick=this.eventPickChk;
          $(".m_searchPopup__checkWrap").scrollLeft(0);
        },200);
      },
      // show popup
      openSearching:function(){
        $('._filterBtn').removeClass('s_on');
        $('._searchingInput').removeClass('s_on');
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
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      let referrer=document.referrer || "./gameVideo.asp";
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
      

      this.popupList();// 팝업 목록 json
      this.movieList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"70000"}');// 영상 목록 json
    },
  });
</script>
</body>
</html>
