<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	Set db = new clsDBHelper

	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	End if
%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
<script type="text/javascript">
<%if request("reqdate") = "" then%>
let startdate = new Date();
<%else%>
let startdate = new Date('<%=request("reqdate")%>');
<%end if%>
</script>
</head>
<body <%=CONST_BODY%>>

<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>



<div id="app" class="l m_bg_f2f2f2 instituteSearch" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <a href="/main/index.asp" class="m_header__backBtn">이전</a>
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
        </div>
        <button class="m_calendarCtrl__btn s_next" @click="yearMonthChange('next')">&gt;</button>
      </div>
      <!-- <a href="./institute-schedule.asp" class="m_calendarHeader__link">연도별</a> -->
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

		  <div class="l_popinfo__top">
            <p class="l_popinfo__title">{{popinfo_list.title}}</p>
            <p class="l_popinfo__titlecmt">{{popinfo_list.title_day}}</p>
          </div>
          <div class="l_popinfo__content">
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_loca"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/place_@3x.png" alt="장소"></span> 장소</p>
              <p class="l_popinfo__cmt">{{popinfo_list.location}}</p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt="주최"></span> 주최</p>
              <p class="l_popinfo__cmt">
                <span>{{popinfo_list.host}}</span>
              </p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt="주관"></span> 주관</p>
              <p class="l_popinfo__cmt">
                <span >{{popinfo_list.superviser}}</span>
              </p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt="후원"></span> 후원</p>
              <p class="l_popinfo__cmt">
                <span>{{popinfo_list.sponsor}}</span>
              </p>
            </div>

            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/apply_@3x.png" alt="경기종목"></span> 경기종목</p>
              <p class="l_popinfo__cmt">
                <span>{{popinfo_list.cdanm}}</span>
              </p>
            </div>
            <div class="l_popinfo__links">
              <a class="l_popinfo__link" @click="poplink('contestinfo','',popinfo_list.tidx)">대회일정</a>
              <a class="l_popinfo__link" v-if="popinfo_list.attyn=='Y'" @click="poplink('attinfo','',popinfo_list.tidx)">참가신청 현황</a>
              <a class="l_popinfo__link" v-if="popinfo_list.matchyn=='Y'" @click="poplink('match','',popinfo_list.tidx)">대진표</a>
              <a class="l_popinfo__link" v-if="popinfo_list.matchyn=='Y'" @click="poplink('gameorder','',popinfo_list.tidx)">경기순서</a>
              <a class="l_popinfo__link" v-if="popinfo_list.matchyn=='Y'" @click="poplink('gameresult','',popinfo_list.tidx)">대회결과/신기록</a>
            </div>
            <div class="l_popinfo__footer">
               <h2>재정후원</h2>
               <ul class="l_popinfo__footer__logo-list">
                  <li>
                     <a href="https://www.mcst.go.kr/kor/main.jsp" target="_blank">
                        <img src="http://img.sportsdiary.co.kr/images/SD/logo/swimming/popup_logo_01.svg?ver=0.0.1" alt="문화체육관광부">
                     </a>
                  </li>
                  <li>
                     <a href="https://www.kspo.or.kr/kspo/main/main.do" target="_blank">
                        <img src="http://img.sportsdiary.co.kr/images/SD/logo/swimming/popup_logo_02.svg?ver=0.0.1" alt="국민체육진흥공단">
                     </a>
                  </li>
                  <li>
                     <a href="https://www.sports.or.kr/index.do" target="_blank">
                        <img src="http://img.sportsdiary.co.kr/images/SD/logo/swimming/popup_logo_03.svg?ver=0.0.1" alt="대한체육회">
                     </a>
                  </li>
               </ul>
               <span>본 사업은 문화체육관광부, 국민체육진흥공단, 대한체육회의 재정후원을 받고 있습니다.</span>
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
      reqURL : '/pub/ajax/swimming/reqMobile.asp',
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
            app.showPopup('/pub/ajax/swimming/reqMobile.asp?req={"CMD":"62000","tidx":"'+calEvent.id+'","poplink":"'+calEvent.poplink+'"}');
          }
        });

        axios.get(this.reqURL + '?req={"CMD":"60000","YS":"'+this.yy+'","MS":"'+this.mm+'"}').then(response=>{
          this.game_schedule=response.data.jlist;
          if(this.game_schedule[0].title!=""){
            $("#calendar").fullCalendar("addEventSource", response.data.jlist);
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
		let now = startdate;
      this.yy=now.getFullYear();
      this.mm=(now.getMonth()+1)>9? now.getMonth()+1 : "0"+(now.getMonth()+1);
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


		$("#calendar").fullCalendar({
		  locale:"ko",
		  header:false,
		  height:"auto",
		  eventClick:function(calEvent,jsEvent,view){
			 //  calEvent.id : tidx,  calEvent.poplink : 대회일정에서 선택시 팝업 내용이 있는 파일 번호
			 app.showPopup('/pub/ajax/swimming/reqMobile.asp?req={"CMD":"62000","tidx":"'+calEvent.id+'","poplink":"'+calEvent.poplink+'"}');
		  }
		});

		this.yearMonthChange();
    },



  });
</script>
</body>
</html>
<!-- <% 'AD_DBClose() %> -->
