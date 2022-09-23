<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->
</head>
<body>
<div id="app" class="l m_bg_f2f2f2 instituteSchedule" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">대회일정/결과</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_calendarHeader">
      <button id="btntoday" class="calendarFooter__btn" type="button" @click="btnToday">오늘</button>
      <div class="m_calendarCtrl">
        <button class="m_calendarCtrl__btn s_prev" @click="gameScheduleChange('prev')">&lt;</button>
        <div>
          <select class="m_calendarCtrl__inputDate" v-model="yy" @change="gameScheduleChange">
            <option v-for="(yy,key) in yylist" :value="yy.year">{{yy.year}}년</option>
          </select>
          <span class="m_calendarCtrl__date">{{yy}}년</span>
        </div>
        <button class="m_calendarCtrl__btn s_next" @click="gameScheduleChange('next')">&gt;</button>
      </div>
      <a href="./institute-search.asp" class="m_calendarHeader__link">월별</a>
    </div>

    <div>
      <button type="button" class="preMonthSchedule" v-bind:class="{s_on: prev_month_view || yy!=curYy || mm=='01'}" @click="prevMonthView"><span class="preMonthSchedule__txt">이전월 보기</span><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/arrow_down_@3x.png" alt=""></span></button>

      <div class="m_loadingbar" v-if="loadinglist" v-bind:class="{m_dflex: loadinglist}">
        <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
      </div>

      <div class="scheduleBoard" v-for="(gameschedule,key) in game_schedule" v-bind:class="{s_disabled: gameschedule.mm<mm && yy==curYy}">
        <h3 class="scheduleBoard__tit" v-bind:class="{s_current: mm==gameschedule.mm && yy==curYy}">{{gameschedule.mm}}월</h3>
        <div class="m_schedule__wrap" v-if="gameschedule.mminfo!='nodata'">
          <button class="m_schedule__pop" v-for="(gameinfo,key2) in gameschedule.mminfo" @click="showPopup(gameinfo.poplink, gameinfo.id)">
            <span class="m_schedule__info" v-bind:class="gameinfo.class">{{gameinfo.status}}<em v-if="gameinfo.status=='D-'">{{dDay(gameinfo.dday)}}</em></span>
            <p class="m_schedule__txt">{{gameinfo.title}}</p>
          </button>
        </div>
      </div>

    </div>
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
        <div class="m_loadingbar" v-if="loadingpop" v-bind:class="{m_dflex: loadingpop}">
          <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
        </div>
        <div v-else>
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

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>

<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  let app=new Vue({
    el:"#app",
    data:{
      curYy:null,// 현재연도
      yy:null,// 선택연도
      mm:null,// 월
      prev_month_view:false,// 이전월 보기
      yylist:[],// 연도 목록

      schedule_popno:null,// 대회일정에서 선택시 팝업 내용이 있는 파일 번호
      game_schedule:[],// 대회일정

      popinfo_list:[],// 팝업 내용

      loadinglist:false,
      loadingpop:false,

      layer:null,//

      
      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      //
      startYear:function(url){
        axios.get(url).then(response=>{
          this.yylist=response.data.jlist;
        },(error)=>{
          console.log("error. startYear");
          console.log(error);
        });
      },

      prevMonthView:function(){
        this.prev_month_view=!this.prev_month_view;
      },
      //
      gameSchedule:function(url){
        this.loadinglist=true;
        this.game_schedule=[];
        axios.get(url).then(response=>{
          this.loadinglist=false;
          this.game_schedule=response.data.jlist[0].month;
        },(error)=>{
          console.log("error gameSchedule : ");
          console.log(error);
        });
      },
      gameScheduleChange:function(dir){
        if(dir=="prev"){
          // 2019           2018 
          if(this.yy>this.yylist[this.yylist.length-1].year){
            this.yy=Number(this.yy)-1;
          }
        }else if(dir=="next"){
          // 2109           2020
          if(this.yy<this.yylist[0].year){
            this.yy=Number(this.yy)+1;
          }
        }
        this.prev_month_view=false;
        this.gameSchedule('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"61000","YS":"'+this.yy+'"}');
      },
      // today
      btnToday:function(){
        this.yy=this.curYy;
        this.gameSchedule('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"61000","YS":"'+this.yy+'"}');
      },

      // popup
      showPopup:function(poplink,tidx){
        this.popupInfoList(poplink,tidx);
        this.layer.open();
      },
      // 팝업 닫을 때 스크롤바 위로
      closePopup:function(){
        setTimeout(()=>{
          $(".l_upLayer__wrapCont").scrollTop(0);
        },230);
      },
      // 팝업 내용
      popupInfoList:function(poplink,tidx){
        this.loadingpop=true;
        this.popinfo_list=[];
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62000","tidx":"'+tidx+'","poplink":"'+poplink+'"}').then(response=>{
          this.loadingpop=false;
          this.popinfo_list=response.data.jlist[0];
        });
      },
    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }

      let now=new Date();
      this.curYy=this.yy=String(now.getFullYear());
      this.mm=now.getMonth()+1;
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      let referrer=document.referrer || "./institute-schedule.asp";
      history.replaceState("list", null, null);
      window.onpopstate=(evt)=>{
        if(evt.state=="list" && this.layer.status=="open"){
          this.layer.close();
        }else{
          location.href=referrer;
        }
      }
      this.layer=new OverLayer({
        overLayer:$("._overLayer"),
        emptyHTML:"정보를 불러오고 있습니다.",
        errorHTML:"",
      });
      this.layer.on("beforeOpen",function(){history.pushState("view", null, null)});
      this.layer.on("beforeClose",function(){history.pushState("list", null , null)});

      
      this.startYear('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"61100"}');
      this.gameSchedule('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"61000","YS":"'+this.yy+'"}');
      // 연도 목록
      // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"61100"}
      // 연도별
      // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"61000","YS":"2019"}
      // 팝업 내용
      // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62000","tidx":"146","poplink":"3"}
    },
  });
</script>
</body>
</html>
<!-- <% 'AD_DBClose() %> -->
