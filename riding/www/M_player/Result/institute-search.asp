<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->
</head>
<body>
<div id="app" class="l m_bg_f2f2f2 instituteSearch" v-cloak>

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
        <button class="m_calendarCtrl__btn s_prev" @click="yearMonthChange('prev')">&lt;</button>
        <div>
          <input type="month" ref="yyyymm" v-model="date" @click="yyyymm" @change="yearMonthChange" class="m_calendarCtrl__inputDate">
          <span class="m_calendarCtrl__date">{{yy}}년 {{mm}}월</span>
          <!-- <select id="sel_year" name="" class="year" v-model="year" @change="yearMonthChange">
            <option value="2017">2017년</option>
            <option value="2018">2018년</option>
            <option value="2019">2019년</option>
            <option value="2020">2020년</option>
            <option value="2021">2021년</option>
            <option value="2022">2022년</option>
            <option value="2023">2023년</option>
            <option value="2024">2024년</option>
            <option value="2025">2025년</option>
            <option value="2026">2026년</option>
            <option value="2027">2027년</option>
            <option value="2028">2028년</option>
            <option value="2029">2029년</option>
            <option value="2030">2030년</option>
          </select>
          <select id="sel_month" name="" class="month" v-model="mon" @change="yearMonthChange">
            <option value="01">01월</option>
            <option value="02">02월</option>
            <option value="03">03월</option>
            <option value="04">04월</option>
            <option value="05">05월</option>
            <option value="06">06월</option>
            <option value="07">07월</option>
            <option value="08">08월</option>
            <option value="09">09월</option>
            <option value="10">10월</option>
            <option value="11">11월</option>
            <option value="12">12월</option>
          </select> -->
        </div>
        <button class="m_calendarCtrl__btn s_next" @click="yearMonthChange('next')">&gt;</button>
      </div>
      <a href="./institute-schedule.asp" class="m_calendarHeader__link">연도별</a>
    </div>

    <div id="calendar" class="calendarBody"></div>
  </div>

  <!-- search popup -->
  <div class="l_upLayer [ _overLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox l_riding__pop [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">대회정보</h1>
        <button class="l_upLayer__close [ _overLayer__close ]" @click="closePopup">닫기</button>
      </div>
      <div class="l_upLayer__wrapCont [ _overLayer__wrap ]" v-bind:class="{m_dflex: popinfo_list=='n'}">
        <div v-if="popinfo_list=='n'" class="no_gameinfo m_img m_loading"><img src="http://img.sportsdiary.co.kr/images/SD/img/empty_contest_info_@3x.png" alt=""></div>
        <div v-else>
          <div class="m_loadingbar" v-if="loading" v-bind:class="{m_dflex: loading}">
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
      yy:null,// 연도
      mm:null,// 월
      date:null,// 연도,월

      game_schedule:[],// 대회일정
      popinfo_list:[],// 팝업 내용

      loading:false,
      layer:null,//

      
      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      // today
      btnToday:function(){
        $("#calendar").fullCalendar("today");
        let m=$("#calendar").fullCalendar("getDate").format();
        this.yy=m.split("-")[0];
        this.mm=m.split("-")[1];
        this.date=this.yy+"-"+this.mm;
        $("#calendar").fullCalendar("removeEvents");
        $("#calendar").fullCalendar("gotoDate", this.date);
        this.callCalendar();
      },
      // 모바일에서 연월 선택시 달력 나오게
      yyyymm:function(){
        this.$nextTick(() => this.$refs.yyyymm.focus());
      },
      yearMonthChange:function(dir){
        // console.log("연도 : 월 : "+this.date);
        if(dir=="prev"){
          let m=Number(this.mm)-1;
          if(m==0){
            m=12;
            this.yy=Number(this.yy)-1;
          }
          if(m<10) m="0"+m;
          this.mm=m;
        }else if(dir=="next"){
          let m=Number(this.mm)+1;
          if(m==13){
            m=1;
            this.yy=Number(this.yy)+1;
          }
          if(m<10) m="0"+m;
          this.mm=m;
        }else{
          this.yy=this.date.split("-")[0];
          this.mm=this.date.split("-")[1];
        }
        this.date=this.yy+"-"+this.mm;
        $("#calendar").fullCalendar("removeEvents");
        $("#calendar").fullCalendar("gotoDate", this.date);
        this.callCalendar();
      },

      // show calendar
      callCalendar:function(){
        $("#calendar").fullCalendar({
          locale:"ko",
          header:false,
          height:"auto",
          eventClick:function(calEvent,jsEvent,view){
            //  calEvent.id : tidx,  calEvent.poplink : 대회일정에서 선택시 팝업 내용이 있는 파일 번호
            app.showPopup('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62000","tidx":"'+calEvent.id+'","poplink":"'+calEvent.poplink+'"}');
          }
        });

        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"60000","YS":"'+this.yy+'","MS":"'+this.mm+'"}').then(response=>{
          this.game_schedule=response.data.jlist;
          if(this.game_schedule[0].title!=""){
            $("#calendar").fullCalendar("addEventSource", app.game_schedule);
            $("#calendar").fullCalendar("rerenderEvents");
          }
        });
        // 월별
        // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"60000","YS":"2019","MS":"3"}
        // 팝업 내용
        // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62000","tidx":"146","poplink":"3"}
      },

      // show popup
      showPopup:function(url){
        this.loading=true;
        axios.get(url).then(response=>{
          this.loading=false;
          this.popinfo_list=[];
          this.popinfo_list=response.data.jlist[0];
        },(error)=>{
          console.log(": error : ");
          console.log(error);
        });

        this.layer.open({title:this.riding_title});
      },
      // 팝업 닫을 때 스크롤바 위로
      closePopup:function(){
        setTimeout(()=>{
          $(".l_upLayer__wrapCont").scrollTop(0);
        },230);
      },
    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }

      let now=new Date();
      this.yy=now.getFullYear();
      this.mm=(now.getMonth()+1)>9? now.getMonth()+1 : "0"+(now.getMonth()+1);
      // this.day=now.getDate()>9? now.getDate() : "0"+now.getDate();
      this.date=this.yy+"-"+this.mm;
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      // 뒤로 가기 할 때 팝업 닫히게
      let referrer=document.referrer || "./institute-search.asp";
      history.replaceState("list" ,null, null);
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
      this.layer.on("beforeClose",function(){history.pushState("list", null, null)});

      
      this.callCalendar();
    },
  });
</script>
</body>
</html>
<!-- <% 'AD_DBClose() %> -->
