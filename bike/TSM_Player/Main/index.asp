<!-- #include file="../Library/header.bike.asp" -->

<%
  HostIDX = request("HostIDX")
  if HostIDX = "" then HostIDX = 1
  MemberIDX = decode(request.Cookies("SD")("MemberIDX"),0)
  UserPhone = decode(request.Cookies("SD")("UserPhone"),0)
  UserName = request.Cookies("SD")("UserName")
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->

  <style>
    .fold-enter{
      height:0;transition: all .3s ease;
    }
    .fold-enter-to{
      height:136px;transition: all .3s ease;
    }
    .fold-leave{
      height:136px;transition: all .3s ease;
    }
    .fold-leave-to{
      height:0;transition: all .3s ease;
    }
  </style>

</head>
<body>

<div id="app" class="l index m_bg_f2f2f2" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header">
      <!-- #include file="../include/header_back.asp" -->
      <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="m_header__logo">
        <img src="http://img.sportsdiary.co.kr//images/SD/logo/logo_@3x.png" class="m_header__logoImg" alt="스포츠다이어리">
      </a>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>

    <div class="m_mainTab">
      <ul>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('badminton');" class="m_mainTab__rink">배드민턴</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('judo');" class="m_mainTab__rink">유도</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('tennis');" class="m_mainTab__rink">테니스</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('riding');" class="m_mainTab__rink">승마</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('bike');" class="m_mainTab__rink s_active">자전거</a> </li>

      </ul>
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">

    <!--  -->
    <div class="major_banner">
      <div class="banner banner_lg carousel">
        <div class="bxslider">

          <div style="background-color: #FFE26F">
            <% if (IPHONEYN() <> "0") then %>
            <a href="http://sdmain.sportsdiary.co.kr/sdmain/event/Daily.asp">
            <% else %>
            <a href="http://sdmain.sportsdiary.co.kr/sdmain/event/Daily.asp">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/bi_banner_lg.jpg" alt="">
            </a>
          </div>

          <div style="background-color: #454344">
            <% if (IPHONEYN() <> "0") then %>
            <a onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=48')">
            <% else %>
            <a href="http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=48" target="_blank">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/1_lg.jpg" alt="">
            </a>
          </div>

          <div style="background-color: #090506">
            <% if (IPHONEYN() <> "0") then %>
            <a onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=44')">
            <% else %>
            <a href="http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=44" target="_blank">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/2_lg.jpg" alt="">
            </a>
          </div>

          <div style="background-color: #020202">
            <% if (IPHONEYN() <> "0") then %>
            <a onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/mobile/Product/detail.asp?seq=384757')">
            <% else %>
            <a href="http://www.sdamall.co.kr/mobile/Product/detail.asp?seq=384757" target="_blank">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/3_lg.jpg" alt="">
            </a>
          </div>

        </div>

      </div>
    </div>
    <!--  -->

    <div class="competition" v-for="title, index in titleList" :class="{s_on: (title == currentTitle)}">

      <div class="competition__header" :class="{s_on: (title == currentTitle)}">
        <h3 class="competition__name" :class="{s_on: (title == currentTitle)}" @click="activeTitle(title)">
          <span>{{title.title}}</span>
        </h3>

        <p class="competition__add">
          <span class="competition__addTxt" :class="{s_on: (title == currentTitle)}">{{title.place}}</span>
          <span class="competition__addTxt" :class="{s_on: (title == currentTitle)}">{{title.startDate}} ~ {{title.endDate}}</span>

          <!-- 운영상 임시 제거 -->
          <!-- <a class="competition__busBtn s_disable" :class="{ s_on: (title == currentTitle) }" v-if="!title.busStatus" @click="alert('참가신청 후 참가비 입금을 완료해야 버스 신청이 가능합니다.')"> 버스신청</a>
          <a class="competition__busBtn" :class="{ s_on: (title == currentTitle) }" :href="'../request/applyBus.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + title.titleIdx + '&Title=' + title.title" v-if="title.busStatus"> 버스신청</a> -->
        </p>
      </div>



      <transition name="fold">
        <div class="competition__detail" v-if="(title == currentTitle)">

          <div class="competition__btns">
            <!-- 대회요강 btn: 관리자 설정 -->
            <a class="competition__btn s_summary" v-if="currentTitle.summary" @click="openLayer(currentTitle.titleIdx, 'summary');" >대회요강</a>
            <a class="competition__btn s_summary s_disable" v-if="!currentTitle.summary" >대회요강</a>

            <!-- 참가신청 btn: 관리자 설정 + 로그인 상태 -->
            <template v-if="title.isShowApply && qs.memberIdx">
              <a class="competition__btn s_applicant" :href="'../Request/applicant.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + currentTitle.titleIdx + '&Title=' + currentTitle.title" v-if="!currentTitle.hasApplication" >참가신청</a>
              <a class="competition__btn s_applicant" :href="'../Request/eventStep1.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + currentTitle.titleIdx + '&Title=' + currentTitle.title" v-if="currentTitle.hasApplication" >참가신청</a>
            </template>
            <a class="competition__btn s_applicant s_disable" v-if="title.isShowApply && !qs.memberIdx" @click="alert('로그인 후 이용가능 합니다.')">참가신청</a>

            <!-- 대진표 btn: 관리자 설정 + 이미지url존재 유무, 대회결과 btn과 flag 공유함. -->
            <a class="competition__btn s_tree" v-if="currentTitle.matchTableOpen && currentTitle.matchTable" @click="openLayer(currentTitle.titleIdx, 'matchTable');" >대진표</a>
            <a class="competition__btn s_tree s_disable" v-if="currentTitle.matchTableOpen && !currentTitle.matchTable">대진표</a>

            <!-- 대회결과 btn: 관리자 설정 + 이미지url존재 유무, 대진표 btn과 flag 공유함. -->
            <a class="competition__btn s_result" v-if="!currentTitle.matchTableOpen && currentTitle.result" @click="openLayer(currentTitle.titleIdx, 'result');">대회결과</a>
            <a class="competition__btn s_result s_disable" v-if="!currentTitle.matchTableOpen && !currentTitle.result">대회결과</a>

            <a class="competition__btn s_video" :href="'../Result/gamevideo.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + currentTitle.titleIdx + '&StartDate=' + currentTitle.startDate.substr(0, 4)">대회영상</a>
            <a class="competition__btn s_picture" :href="'../Result/stadium_sketch.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + currentTitle.titleIdx + '&StartDate=' + currentTitle.startDate.substr(0, 4)">대회사진</a>
          </div>



          <div class="apply">
            <h4 class="apply__title">참가신청내역</h4>

            <!-- 로그인시 신청자 정보, 신청내역 btn 활성화 -->
            <div class="m_borderBtns" v-if="qs.memberIdx">
              <a :href="'../Request/applicant.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + currentTitle.titleIdx + '&Title=' + currentTitle.title" class="m_borderBtns__btn">신청자정보</a>
              <a :href="'../Request/applyHistory.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + currentTitle.titleIdx + '&Title=' + currentTitle.title" class="m_borderBtns__btn">신청내역</a>
            </div>
            <div class="m_borderBtns" v-if="!qs.memberIdx">
              <a class="m_borderBtns__btn" @click="alert('로그인 후 이용 가능합니다.')">신청자정보</a>
              <a class="m_borderBtns__btn" @click="alert('로그인 후 이용 가능합니다.')">신청내역</a>
            </div>


            <!-- 개인 참가신청 내역, 상태 -->
            <div class="apply__group" v-if="applyEvent.solo && applyEvent.solo.length != 0">
              <p class="apply__groupTitle">개인</p>

              <div class="apply__groupItem" v-for="event in applyEvent.solo">
                <div class="apply__groupItemInner">
                  <span class="apply__event">{{event.eventType}}</span>
                  <span class="apply__eventDetail" v-if="event.eventDetailType">{{event.eventDetailType}}</span>
                  <a class="apply__statusBtn">{{event.status}}</a>
                </div>
              </div>
            </div>

            <!-- 단체 참가신청 내역, 상태 -->
            <div class="apply__group" v-if="applyEvent.group && applyEvent.group.length != 0">
              <p class="apply__groupTitle">단체</p>
              <a class="apply__applicationBtn" v-if="!currentTitle.hasApplication" :href="'../Request/applicant.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + currentTitle.titleIdx + '&Title=' + currentTitle.title">참가신청서를 작성해주세요.</a>
              <div class="apply__groupItem" v-for="event in applyEvent.group">
                <div class="apply__groupItemInner">
                  <span class="apply__event">{{event.eventType}}</span>
                  <span class="apply__eventDetail">{{event.eventDetailType}}</span>
                  <a class="apply__statusBtn" >{{event.status}}</a>
                </div>
              </div>
            </div>
          </div>

        </div>
      </transition>

    </div>
  </div>

  <!-- guide layer  -->
  <div class="m_guideLayer [ _overLayer _guideLayer ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">

      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle [ _overLayer__title ]">안내사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText">
          2019 SD랭킹 사이클대회(1차)</br>
          일정지연 안내
        </p>
        <p class="m_guideLayer__subText3">
          이번 6월 8일 ~ 9일 예정의 1차대회가 대회가 양양군과 일정의 협의를 통해 대회일정을 긴급하게 연기를 하게 되었습니다.
        </p>
        <p class="m_guideLayer__subText3">
          대회일자는 최종 협의 후 확정공지 예정입니다. (8월~ 9월 사이로 진행추진 계획)
        </p>
        <p class="m_guideLayer__subText3">
          이미 참가접수를 완료 해주신 선수분들께는 불편을 드려 죄송합니다.
          다시 한 번 사죄드리며 좋은 대회를 만들도록 노력하겠습니다.
        </p>
        <p class="m_guideLayer__subText4">
          대회관련문의<br />
          : 황동현 매니저 (010-4529-7744)
        </p>

        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn" @click="guideLayer.el.close();">확인</button>
        </div>

      </div>
    </div>
  </div>

  <div class="m_reqLayer [ _overLayer _reqLayer ]">
    <div class=" [ _overLayer__backdrop ]"></div>
    <div class="m_reqLayer__inner [ _overLayer__box ]">

      <div class="m_reqLayer__header">
        <h1 class="m_reqLayer__headerTitle [ _overLayer__title ]">{{layer.title}}</h1>
        <button class="m_reqLayer__headerClose" @click="layer.el.close();">닫기</button>
      </div>
      <div class="m_reqLayer__content [ _overLayer__wrap ]">
        <div class="m_img">
          <img :src="layer.img" />
        </div>

        <div class="m_reqLayerBtns">
          <button class="m_reqLayerBtns__btn" @click="layer.el.close();">확인</button>
        </div>

      </div>
    </div>
  </div>

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>
  //상단 종목 메인메뉴 URL
  function chk_TOPMenu_URL(obj){
    switch(obj) {
      case 'badminton' : $(location).attr('href', 'http://badminton.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp'); break;
      case 'judo'		   : $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
      case 'tennis'    : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp'); break;
      case 'riding'    : $(location).attr('href', 'http://riding.sportsdiary.co.kr/m_player/main/index.asp'); break;
      case 'bike'      : $(location).attr('href', 'http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp'); break;
      default       	 : $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');
    }
  }

  var vm = new Vue({
    mixins: [mixInLoader],
    el:'#app',
    data:{
      qs: {},
      layer: {
        el: {},
        img: '',
        title: '',
        summary: '',
        summaryTitle: '대회요강',
        matchTable: '',
        matchTableTitle: '대진표',
        result: '',
        resultTitle: '대회결과',
      },
      titleList: [],
      currentTitle: {},
      applyEvent: {solo:[], group:[]},
      applicantFg: false,
      guideLayer: {
        el: {}
      }
    },
    methods:{
      // + toggle 대회 - 대회 상세 정보 오픈
      activeTitle: function(title){
        this.applyEvent = {solo:[], group:[]}

        if(this.currentTitle == title) this.currentTitle = {}
        else{
          this.currentTitle = title;

          // + 대회 상세 정보
          axios({
            url:'../ajax/title/detail_R.asp',
            method: 'get',
            params: {
              titleIdx: this.currentTitle.titleIdx
            }
          })
          .then(response=>{
            this.layer.summary = response.data.summary;
            this.layer.matchTable = response.data.tableimg;
            this.layer.matchTableOpen = (response.data.matchTableOpen == 'Y') ? true : false;
            this.layer.result = response.data.resultimg;

            this.currentTitle.summary = response.data.summary;
            this.currentTitle.matchTable = response.data.tableimg;
            this.currentTitle.matchTableOpen = (response.data.matchTableOpen == 'Y') ? true : false;
            this.currentTitle.result = response.data.resultimg;
          })
          // + 대회 신청 정보
          .then(()=>{
            if(!this.qs.memberIdx) return;

            return axios({
              url:'../ajax/member/apply/info_r.asp',
              method:'get',
              params:{
                titleIdx: this.currentTitle.titleIdx,
                memberIdx: this.qs.memberIdx,
                addInfo: 'Y'
              }
            })
            .then(response=>{
              this.currentTitle.hasApplication = (response.data.addInfo == 'Y') ? true : false;

              this.applyEvent.solo = response.data.applyList.solo.map(function(item){
                item.status = "신청중";
                item.status = (item.VAccountYN === 'Y') ? '입금대기' : item.status;
                item.status = (item.payState === 'Y') ? '결제완료' : item.status;

                return item
              })

              this.applyEvent.group = response.data.applyList.group.map(function(item){
                item.status = "!팀대기상태";
                item.status = (item.teamReady === 'Y') ? '!팀입력완료' : item.status;
                item.status = (item.VAccountYN === 'Y') ? '입금대기' : item.status;
                item.status = (item.payState === 'Y') ? '결제완료' : item.status;

                return item;
              })
            })

          })
          .catch(error=>{
            console.log(error);
          })

        }

      },
      // + 대회요강, 대진표, 대회결과 클리시 레이어 오픈
      openLayer: function(titleIdx, type){
        this.layer.img = this.layer[type];
        this.layer.title = this.layer[type + 'Title'];
        this.layer.el.open();
      },
    },
    created() {
      this.qs.hostIdx  = '<%=HostIDX%>';
      this.qs.memberIdx = '<%=MemberIDX%>';

      // + 대회 리스트
      axios({
        url:'../ajax/Title/list_R.asp',
        method:'get',
        params: {
          hostIdx: this.qs.hostIdx,
          memberIdx: this.qs.memberIdx,
        }
      })
      .then(response=>{
        if(!response.data.titleList) throw new Error('error');
        this.titleList = response.data.titleList.map((item)=>{
          item.hasApplication = false;

          item.busStatus = (item.busStatus == 'Y') ? true : false;
          item.isTitleEnd = !moment().isAfter(moment(item.endDate));

          item.startDate = item.startDate.replace(/-/g, '.');
          item.endDate = (item.startDate.substr(0, 4) == item.endDate.substr(0, 4)) ? item.endDate.substring(5).replace(/-/g, '.') : item.endDate.replace(/-/g, '.');

          // 참가신청 btn open flag
          item.isShowApply = (item.applyOpenYN = "Y") ? true : false;

          return item;
        })


        this.activeTitle(this.titleList[0])
      })
      .catch(error=>{
        console.log(error)
      })
    },
    mounted() {
      this.layer.el = new OverLayer({
        overLayer: $('._reqLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });

      this.guideLayer.el = new OverLayer({
        overLayer: $('._guideLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
    }
  })
</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
