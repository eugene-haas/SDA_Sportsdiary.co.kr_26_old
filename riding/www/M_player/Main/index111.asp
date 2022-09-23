<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->

  <link rel="stylesheet" href="http://sdmain.sportsdiary.co.kr/sdmain/css/library/swiper.min.css">
  <script src="http://sdmain.sportsdiary.co.kr/sdmain/js/library/swiper.min.js"></script>
</head>
<body>
<div id="app" class="l riding" v-cloak>

  <!-- #include file = '../include/gnb.asp' -->

  <div class="l_header">
    <div class="m_header">
      <!-- #include file = '../include/header_back.asp' -->
      <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="m_header__logo">
        <img src="http://img.sportsdiary.co.kr//images/SD/logo/logo_@3x.png" class="m_header__logoImg" alt="스포츠다이어리">
      </a>
      <!-- #include file = '../include/header_gnb.asp' -->
    </div>

    <div class="m_mainTab">
      <ul>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('badminton');" class="m_mainTab__rink">배드민턴</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('judo');" class="m_mainTab__rink">유도</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('tennis');" class="m_mainTab__rink">테니스</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('riding');" class="m_mainTab__rink s_active">승마</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('bike');" class="m_mainTab__rink">자전거</a> </li>

      </ul>
    </div>
  </div>

  <div class="l_content m_scroll indexpage [ _content _scroll ] ">

    <!-- S: main banner 01 -->
    <!-- <div class="mainbanner__swiper [ _bannerViewer__swiper swiper-container ]">
      <p v-if="bannerloading" class="m_loading">loading..</p>
      <div class="[ swiper-wrapper ]">
        <a v-for="(data,key) in banners.banner" v-bind:href="data.url" target="_blank" class="sd_photoViewer__slide [ swiper-slide ]">
          <img class="sd_photoViewer__img" v-bind:src="data.img" alt="">
        </a>
      </div>
    </div> -->
    <!-- E: main banner 01 -->

    <!-- 대회일정/결과 -->
    <div class="m_board">
      <h3 class="m_board__tit">대회일정/결과<a href="../Result/institute-search.asp" class="m_board__moreBtn" v-if="gameinfo_list!='nodata'">더보기</a></h3>

      <!-- s_apply : 신청중,  s_dday : d-14,  s_ing : 경기중,  s_end : 경기완료 -->
      <div class="m_schedule__wrap" v-bind:class="{nodata: gameinfo_list=='nodata'}">
        <div v-if="gameinfo_list!='nodata'">
          <button v-for="(info,key) in gameinfo_list" @click="openPopup(info.id,info.poplink)" class="m_schedule__pop">
            <span class="m_schedule__info" v-bind:class="info.class">{{info.status}}<em v-if="info.status=='D-'">{{dDay(info.dday)}}</em></span>
            <p class="m_schedule__txt">{{info.title}}</p>
          </button>
        </div>
      </div>
    </div>
    <!-- // 대회일정/결과 -->

    <!-- 경기영상 -->
    <div class="m_board">
      <h3 class="m_board__tit">경기영상<a href="../Result/gamevideo.asp" class="m_board__moreBtn" v-if="gamevideo_list!='nodata'">더보기</a></h3>
      <div class="m_links__wrap">
        <div class="m_ibarea" v-if="gamevideo_list!='nodata'">
          <a v-for="(gamevideo,key) in gamevideo_list" v-bind:href="videoUrl(gamevideo.url)">
            <div class="m_img"><img v-bind:src="gamevideo.movieimg" alt=""></div>
            <p class="m_links__txt">{{gamevideo.title}}</p>
          </a>
        </div>
      </div>
    </div>
    <!-- // 경기영상 -->

    <!-- 현장스케치 -->
    <div class="m_board s_sketch">
      <h3 class="m_board__tit">현장스케치<a href="../Result/stadium_sketch.asp" class="m_board__moreBtn" v-if="fieldsketch_list!='nodata'">더보기</a></h3>
      <div class="m_links__wrap">
        <div class="m_ibarea" v-if="fieldsketch_list!='nodata'">
          <a v-for="(field,key) in fieldsketch_list" v-bind:href="sketchUrl(field.url, key)">
            <div class="m_img"><img v-bind:src="field.img" alt=""></div>
          </a>
        </div>
      </div>
    </div>
    <!-- // 현장스케치 -->

    <!-- #include file="../include/footer.asp" -->
  </div>

  <!-- search popup -->
  <div class="l_upLayer [ _overLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox l_riding__pop [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">대회정보</h1>
        <button class="l_upLayer__close [ _overLayer__close ]" @click="closePopup">닫기</button>
      </div>
      <div class="l_upLayer__wrapCont [ _overLayer__wrap ]">
        <!-- <div class="m_loadingbar" v-if="loading" v-bind:class="{m_dflex: loading}">
          <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
        </div> -->
        <!-- <div v-else> -->
        <div v-if="!loading">
          <div class="l_popinfo__top">
            <p class="l_popinfo__title">{{popinfo_list.title}}</p>
            <p class="l_popinfo__titlecmt">{{popinfo_list.title_day}}</p>
          </div>
          <div class="l_popinfo__content">
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_loca"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/place_@3x.png" alt=""></span> 장소</p>
              <p class="l_popinfo__cmt">{{popinfo_list.location}}</p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt=""></span> 주최</p>
              <p class="l_popinfo__cmt" v-for="(info,key) in popinfo_list.host">
                <span>{{key=='0'?'':', '}}{{info.name}}</span>
              </p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt=""></span> 주관</p>
              <p class="l_popinfo__cmt" v-for="(info,key) in popinfo_list.superviser">
                <span>{{key=='0'?'':', '}}{{info.name}}</span>
              </p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt=""></span> 후원</p>
              <p class="l_popinfo__cmt" v-for="(info,key) in popinfo_list.sponsor">
                <span>{{key=='0'?'':', '}}{{info.name}}</span>
              </p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_peri"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/calendar_@3x.png" alt=""></span> 대회기간</p>
              <div class="l_popinfo__txts" v-for="(info,key) in popinfo_list.gameday">
                <p class="l_popinfo__cmt">{{info.day}}</p>
                <p class="l_popinfo__ymd" v-for="(names,key2) in info.names">{{addColon(names.name)}}</p>
              </div>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_appl"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/apply_@3x.png" alt=""></span> 참가신청</p>
              <div class="l_popinfo__txts" v-for="(info,key) in popinfo_list.gameapply">
                <p class="l_popinfo__cmt">{{info.name}}</p>
                <p class="l_popinfo__ymd">{{addColon(info.day)}}</p>
              </div>
            </div>
            <div class="l_popinfo__links">
              <a class="l_popinfo__link" @click="poplink('contestinfo','',popinfo_list.tidx)">대회요강</a>
              <!-- <a class="l_popinfo__link" @click="poplink('appli',popinfo_list.appli)">참가신청</a> -->
              <a class="l_popinfo__link" v-if="popinfo_list.playtime=='1'" @click="poplink('match','',popinfo_list.tidx)">출전순서표</a>
              <a class="l_popinfo__link" @click="poplink('sketch',popinfo_list.imglen,popinfo_list.tidx)">현장스케치</a>
              <a class="l_popinfo__link" @click="poplink('video',popinfo_list.videolen)">경기영상</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- // search popup -->

  <loader :loading="loading"></loader>
</div>

<!-- #include file="../include/loader2.asp"  -->


<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  var app=new Vue({
    mixins:[mixInLoader],
    el:"#app",
    // data:{
    data(){
      return{
        name:null,
        grade:"일반",
        login_chk:false,// 로그인여부

        // loading:false,// data불러왔는지 유무
        gameinfo_list:[],// 대회일정/결과
        gamevideo_list:[],// 경기영상
        fieldsketch_list:[],// 현장스케치
        popinfo_list:[],// 팝업 내용

        // 현장스케치 이미지 맞게 찾아가려고. 경기가 같으면 -1-1, -1-2, 경기가 다르면 -1-1, -1-1
        imgurls:[],//
        imgurlslen:2,//

        // swiper viewer
        swiper_viewer:undefined,
        // banners
        banners:[],//
        bannerloading:false,//

        layer:null,//
      }
    },
    computed:{},
    methods:{
      // banners
      bannerView:function(){
        this.bannerloading=true;
        axios.get("../Result/testBanner.html").then(response=>{
          this.bannerloading=false;
          this.banners=response.data.jlist[0];

          this.$nextTick(()=>{
            this.swiperSlide(this.banners.banner.length, this.banners.delaytime);
          });
        }).catch(error=>{
          console.log("error. bannerView.");
          console.log(error);
        }).finally(()=>{
          console.log("finally");
        });
      },
      // swiper
      swiperSlide:function(len,delaytime){
        if(len>1){
          this.swiper_viewer=new Swiper("._bannerViewer__swiper",{
            autoHeight:true,
            speed:200,
            loop:true,
            autoplay:{
              delay:delaytime,
              disableOnInteraction:false,
            },
          });
        }else{
          this.swiper_viewer=new Swiper("._bannerViewer__swiper",{
            autoHeight:true,
            speed:200,
          });
        }
      },

      // 메인
      mainData:function(){
        // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"50000"}
        // this.loading=true;
        this.gameinfo_list=[];
        this.gamevideo_list=[];
        this.fieldsketch_list=[];
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"50000"}').then(response=>{
          // this.loading=false;
          this.gameinfo_list=response.data.jlist[0].gameinfo;
          this.gamevideo_list=response.data.jlist[0].gamevideo;
          this.fieldsketch_list=response.data.jlist[0].fieldsketch;
        });
      },

      // popup
      openPopup:function(tidx,poplink){
        this.popupInfoList(tidx,poplink);
        this.layer.open();
      },
      // 팝업 닫을 때 스크롤바 위로
      closePopup:function(){
        setTimeout(()=>{
          $(".l_upLayer__wrapCont").scrollTop(0);
        },230);
      },
      // 팝업 내용
      popupInfoList:function(tidx,poplink){
        // this.loading=true;
        this.popinfo_list=[];
        // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62000","tidx":"146","poplink":"3"}
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62000","tidx":"'+tidx+'","poplink":"'+poplink+'"}').then(response=>{
          // this.loading=false;
          this.popinfo_list=response.data.jlist[0];
        }).catch(error=>{
          console.log("error. popupInfoList.");
          console.log(error);
        }).finally(()=>{
          console.log("finally");
        });
      },
      // video url
      videoUrl:function(url){
        return "../result/gamevideo_detail.asp?"+url;
      },
      // sketch url
      sketchUrl:function(url,key){
        this.imgurls[key]=url;
        // console.log("url : "+url+"    key : "+key+"    imgurls[0] : "+this.imgurls[0]+"    imgurls[1] : "+this.imgurls[1]);
        if(key==1 && this.imgurls[0]==this.imgurls[1]){
          return "../result/stadium_sketch_detail.asp?"+url+"-1-2";
        }
        return "../result/stadium_sketch_detail.asp?"+url+"-1-1";
      },
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

      // let referrer=document.referrer || "./index.asp";
      // history.replaceState("list", null, null);
      // window.onpopstate=(evt)=>{
      //   if(evt.state=="list" && this.layer.status=="open"){
      //     this.layer.close();
      //   }else{
      //     location.href=referrer;
      //   }
      // }
      this.layer=new OverLayer({
        overLayer:$("._overLayer"),
        emptyHTML:"정보를 불러오고 있습니다.",
        errorHTML:"",
      });
      // this.layer.on("beforeOpen",function(){history.pushState("view",null,null)});
      // this.layer.on("beforeClose",function(){history.pushState("list",null,null)});

      this.mainData();// 확인용 json
      // this.bannerView();
    },
  })
</script>

</body>
</html>
