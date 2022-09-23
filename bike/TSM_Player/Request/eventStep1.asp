<!-- #include file="../Library/header.bike.asp" -->

<%
  HostIDX = request("HostIDX")
  if HostIDX = "" then HostIDX = 1
  MemberIDX = decode(request.Cookies("SD")("MemberIDX"),0)
  UserPhone = decode(request.Cookies("SD")("UserPhone"),0)
  UserBirth = decode(request.Cookies("SD")("UserBirth"),0)
  UserName = request.Cookies("SD")("UserName")
  Sex = request.Cookies("SD")("Sex")
  TitleIDX = request("TitleIDX")
  Title = request("Title")

  if MemberIDX = "" then response.redirect "../main/index.asp"
  if TitleIDX = "" then response.redirect "../main/index.asp"
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
</head>
<body>
<div id="app" class="l selectEventStep1" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">참가 종목 선택</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_subTitle">
      <h2 class="m_subTitle__title">{{qs.title}}</h2>
    </div>

    <div class="summary">
      <div class="summary__inner">
        <p class="summary__days">
          대회기간: {{competitionInfo.duration}} <br />
          참가신청기간: {{competitionInfo.applyDuration}}
        </p>
        <button class="summary__btn" @click="openLayer('summary')">대회요강</button>
        <button class="summary__btn" @click="openLayer('titleRule')">대회규정</button>
        <button class="summary__btn" @click="openLayer('eventRule')">종목설명</button>
      </div>
    </div>

    <!-- :href="'./eventStep2.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + qs.titleIdx + '&Title=' + qs.title + '&eventType=' + eventType.eType" -->

    <!-- 참가신청 전 일 경우 -->
    <div class="eventBtns" v-if="!appliedEventType">
      <a class="eventBtns__btn"
        v-for="(eventType, index) in competitionInfo.eventTypeList"
        :class="{s_track: index == 0, s_road: index == 1}"
        @click="openCautionLayer(eventType.eType)" ><span>{{eventType.eType}} 경기</span>
      </a>
    </div>

    <!-- 참가신청 후 -->
    <div class="eventBtns" v-if="appliedEventType">
      <template v-for="(eventType, index) in competitionInfo.eventTypeList">
      <!-- 참가신청되지 않은 종목 btn disabled 처리 및 링크방지. 안내 레이어 오픈.  -->
      <a class="eventBtns__btn" v-if="appliedEventType === eventType.eType"
        :class="{s_track: index == 0, s_road: index == 1, s_disable: appliedEventType !== eventType.eType}"

        :href="'./eventStep2.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + qs.titleIdx + '&Title=' + qs.title + '&EventType=' + eventType.eType"
        >
        <span>{{eventType.eType}} 경기</span>
      </a>
      <a class="eventBtns__btn" v-if="appliedEventType !== eventType.eType"
        :class="{s_track: index == 0, s_road: index == 1, s_disable: appliedEventType !== eventType.eType}"

        @click="openCautionLayer"
        >
        <span>{{eventType.eType}} 경기</span>
      </a>
      </template>

      <!-- :href="'./eventStep2.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + qs.titleIdx + '&Title=' + qs.title + '&eventType=' + eventType.eType" -->
      <!-- <a class="eventBtns__btn s_road"><span>로드경기</span></a> -->
    </div>

    <div class="">

      <p class="infoTxt s_title">< 대회 참가신청방법 안내 ></p>
      <p class="infoTxt">
        <span class="infoTxt__mark">-</span>단체 팀원 모두 스포츠다이어리 회원가입 필수입니다.<br />
        <span class="infoTxt__mark">-</span>파트너 변경 및 신청취소는 참가신청 기간 중에만 가능합니다.<br />
        <span class="infoTxt__mark">-</span>대진추첨 후 참가신청 취소 또는 대회당일 불참 팀은 참가비 환불 불가합니다<br />
        <span class="infoTxt__mark">-</span>참가비 입금후 신청취소를 할 경우 취소일부터 10일 이내 환불처리 진행됩니다.<br />
        <span class="infoTxt__mark">-</span>대회장에서의 추가신청 및 파트너 변경 불가 합니다.<br />
        <span class="infoTxt__mark">-</span>신청내역이 확인되지 않는 동호인은 고객센터로 문의바랍니다.
      </p>

      <p class="infoTxt s_title">< 문의전화 ></p>
      <p class="infoTxt">
        <span class="infoTxt__mark">-</span>스포츠다이어리 고객센터<br />: 02-704-0282<br />
        <span class="infoTxt__mark">-</span>운영시간<br />: 평일 9:00 ~ 18:00 (점심시간 12:00 ~ 13:00)
      </p>

    </div>

  </div>

  <!-- scrp layer -->
  <div class="m_reqLayer [ _overLayer  _reqLayer ]">
    <div class=" [ _overLayer__backdrop ]"></div>
    <div class="m_reqLayer__inner [ _overLayer__box ]">

      <div class="m_reqLayer__header">
        <h1 class="m_reqLayer__headerTitle [ _overLayer__title ]">{{layer.title}}</h1>
        <button class="m_reqLayer__headerClose"  @click="closeLayer();">닫기</button>
      </div>
      <div class="m_reqLayer__content [ _overLayer__wrap ]">
        <div class="m_img">
          <img :src="layer.img" />
        </div>

        <div class="m_reqLayerBtns">
          <button class="m_reqLayerBtns__btn" @click="closeLayer();">확인</button>
        </div>

      </div>
    </div>
  </div>

  <!-- caution layer  -->
  <div class="m_guideLayer [ _overLayer _cautionLayer  ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">

      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle s_caution [ _overLayer__title ]">주의사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText s_caution">
          로드경기는 번외경기로<br /> 트랙종목과 중복 참가가<br /> 불가합니다.
        </p>
        <p class="m_guideLayer__subText">
          참가자 분께서는 대회요강을 참조하시고 참가에 임해주시기 바랍니다.
        </p>

        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn s_gray" @click="cautionLayer.el.close();">닫기</button>
          <a class="m_guideLayerBtns__btn" v-if="!appliedEventType" :href="'./eventStep2.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + this.qs.titleIdx + '&Title=' + this.qs.title + '&EventType=' + cautionLayer.eventType">다음</a>
        </div>

      </div>
    </div>
  </div>

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>

  var vm = new Vue({
    mixins: [mixInLoader],
    el: '#app',
    data: {
      qs: {},
      competitionInfo: {
        duration: '',
        applyDuration: '',
        eventTypeList: []
      },
      layer: {
        el: {},
        img: '',
        title: '',
        summary: '',
        summaryTitle: '대회요강',
        titleRule: '',
        titleRuleTitle: '대회규정',
        eventRule: '',
        eventRuleTitle: '종목설명',
      },
      cautionLayer:{
        el:{},
        eventType: undefined,
      },
      appliedEventType: undefined,
    },
    methods: {
      openLayer: function(type){
        this.layer.img = this.layer[type];
        this.layer.title = this.layer[type + 'Title'];
        this.layer.el.open()
      },
      closeLayer: function(){
        this.layer.el.close();
        this.layer.img = '';
        this.layer.title = '';
      },
      openCautionLayer: function(eType){
        this.cautionLayer.el.open();
        this.cautionLayer.eventType = eType;
      },
    },
    created() {
      this.qs.hostIdx  = '<%=HostIDX%>';
      this.qs.memberIdx = '<%=MemberIDX%>';
      this.qs.titleIdx = '<%=TitleIDX%>';
      this.qs.title = '<%=Title%>';

      axios.all([
        // + 대회 상세정보
        axios({
          url: '../ajax/title/detail_R.asp',
          method: 'get',
          params: {titleIdx: this.qs.titleIdx}
        }),
        // + 신청 정보
        axios({
          url: '../ajax/Member/Apply/info_R.asp',
          method: 'get',
          params: {
            titleIdx: this.qs.titleIdx,
            memberIdx: this.qs.memberIdx
          }
        })
      ])
      .then(
        axios.spread((resDetail, resApplyInfo)=>{
          if(!resDetail.data) throw new Error('error');

          this.competitionInfo.duration = resDetail.data.startDate.replace(/-/g, '.') + ' ~ ';
          this.competitionInfo.duration +=
          (resDetail.data.startDate.substr(0, 4) == resDetail.data.endDate.substr(0, 4))
          ? resDetail.data.endDate.substring(5).replace(/-/g, '.')
          : resDetail.data.endDate.replace(/-/g, '.');

          this.competitionInfo.applyDuration = resDetail.data.applyStart.replace(/-/g, '.') + ' ~ ';
          this.competitionInfo.applyDuration +=
          (resDetail.data.applyStart.substr(0, 4) == resDetail.data.applyEnd.substr(0, 4))
          ? resDetail.data.applyEnd.substring(5).replace(/-/g, '.')
          : resDetail.data.applyEnd.replace(/-/g, '.');

          this.competitionInfo.eventTypeList = resDetail.data.eventTypeList;

          this.layer.summary = resDetail.data.summary;
          this.layer.eventRule = resDetail.data.eventRule;
          this.layer.titleRule = resDetail.data.titleRule;

          if(!resApplyInfo.data.applyList) throw new Error('error');
          if(resApplyInfo.data.applyList.solo.length !== 0) this.appliedEventType = resApplyInfo.data.applyList.solo[0].eventType
          else if(resApplyInfo.data.applyList.group.length !== 0) this.appliedEventType = resApplyInfo.data.applyList.group[0].eventType
        })
      )
      .catch(error=>{ console.log(error) })
    },
    mounted() {
      this.layer.el = new OverLayer({
        overLayer: $('._reqLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      this.cautionLayer.el = new OverLayer({
        overLayer: $('._cautionLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
    }
  })
</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
