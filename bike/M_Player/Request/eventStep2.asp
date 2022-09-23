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
  EventType = request("EventType")

  if MemberIDX = "" then response.redirect "../main/index.asp"
  if TitleIDX = "" then response.redirect "../main/index.asp"
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->

</head>
<body>
<div id="app" class="l selectEventStep2" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">참가 종목 선택</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll s_hasFAB [ _content _scroll ]">
    <div class="m_subTitle">
      <h2 class="m_subTitle__title">{{qs.title}}</h2>
    </div>

    <p class="m_formSubTitle">
      개인
      <span class="m_formSubTitle__lank" v-if="eventList.soloEvent.length !== 0">{{ eventList.soloEvent[0].ratingCategory }}</span>
    </p>

    <div class="m_formItem" v-for="event in eventList.soloEvent">
      <label class="m_formCheck" @click.prevent="selectEvent(event)">
        <div class="m_formCheck__checkWrap">
          <input type="checkbox" class="m_formCheck__checkbox" hidden v-model="event.isSelected" />
          <span class="m_formCheck__button" :class="{s_applied: event.isOpenAccount}"></span>
        </div>
        <p class="m_formCheck__text" :class="{s_applied: event.isOpenAccount}">{{event.name}}</p>
      </label>
    </div>

    <!-- <div class="m_formItem">
      <label class="m_formCheck">
        <div class="m_formCheck__checkWrap"><input type="checkbox" class="m_formCheck__checkbox" hidden /><span class="m_formCheck__button"></span></div>
        <p class="m_formCheck__text">제외경기</p>
      </label>
    </div>

    <div class="m_formItem">
      <label class="m_formCheck">
        <div class="m_formCheck__checkWrap"><input type="checkbox" class="m_formCheck__checkbox" hidden /><span class="m_formCheck__button"></span></div>
        <p class="m_formCheck__text">스크래치경기</p>
      </label>
    </div> -->

    <p class="m_formSubTitle">
      단체
      <span class="m_formSubTitle__lank" v-if="eventList.groupEvent.length !== 0">{{ eventList.groupEvent[0].ratingCategory }}</span>
      <button class="m_formSubTitle__guide" @click="teamGuideLayer.el.open()">안내사항</button>
    </p>

    <template v-for="(event, index) in eventList.groupEvent">
      <div class="m_formItem">

        <span class="m_formItem__status" v-if="event.isSelected && event.teamReady == 'Y'">!팀입력완료</span>
        <span class="m_formItem__status" v-if="event.isSelected && event.teamReady == 'N'">!팀입력대기</span>
        <span class="m_formItem__status" v-if="event.isSelected && event.teamLeader == 'N'">팀원</span>

        <label class="m_formCheck" @click.prevent="selectEvent(event);">
          <div class="m_formCheck__checkWrap">
            <input type="checkbox" class="m_formCheck__checkbox" hidden v-model="event.isSelected" />
            <span class="m_formCheck__button" :class="{s_applied: event.isOpenAccount}"></span>
          </div>
          <p class="m_formCheck__text" :class="{s_applied: event.isOpenAccount}">{{event.courseLength + event.name}} {{event.playersCountText}}</p>
        </label>
      </div>


      <template v-if="event.isTeamLeader">

        <div class="m_formItem" v-if="event.isSelected && !event.isTeamShow">
          <div class="m_btns">
            <button class="m_btns__btn" @click="unfoldTeamMembers(event, index);">팀원 {{event.teamMembers.length}}명 보기</button>
          </div>
        </div>

        <!-- 수정 모드 -->
        <div v-if="event.isTeamShow && event.teamModifyStatus == 'write' ">

          <div class="m_formItem">
            <p class="m_formItem__label">팀명 등록</p>
            <div class="m_formItem__inner">
              <input type="text" placeholder="팀명을 입력해주세요." class="m_formItem__input" :value="event.teamName" @input="event.teamName=$event.target.value;changeTeamName(event);"/>
              <button class="m_formItem__btn" @click="makeTeamName(event);">중복체크</button>
            </div>
          </div>

          <div class="m_formItem">
            <p class="m_formItem__label">팀원 추가</p>
            <div class="m_formItem__inner">
              <input type="text" placeholder="팀원의 아이디를 입력해주세요." class="m_formItem__input" :value="event.mTeamMemberId" @input="event.mTeamMemberId=$event.target.value.trim();"/>
              <button class="m_formItem__btn" @click="addTeamMember(event, index)">추가</button>
            </div>
          </div>

          <template v-for="(teamMember, index) in event.teamMembers">
            <div class="m_formItem">
              <p class="m_formItem__label">
                팀원 {{ event.teamMembers.length - index }}
                <button class="m_formItem__labelBtn s_subtract" @click="delTeamMember(event, index)">삭제</button>
              </p>
            </div>

            <ul class="teamMembers">
              <li class="teamMembers__item">{{teamMember.name}}</li>
              <li class="teamMembers__item">{{teamMember.birth}}</li>
              <li class="teamMembers__item">{{teamMember.phoneNum}}</li>
            </ul>
          </template>

          <div class="m_formItem">
            <div class="m_btns">
              <button class="m_btns__btn" @click="registerTeam(event, index)">등록</button>
            </div>
            <div class="m_btns">
              <button class="m_btns__btn s_gray" @click="foldTeamMembers(event, index)">닫기</button>
            </div>
          </div>
        </div>

        <!-- 읽기 모드 -->
        <div v-if="event.isTeamShow && event.teamModifyStatus == 'read' ">

          <div class="m_formItem">
            <p class="m_formItem__inner s_low">
              <span class="m_formItem__text">{{event.teamName}}</span>
            </p>
          </div>

          <template v-for="(teamMember, index) in event.teamMembers">
            <div class="m_formItem">
              <p class="m_formItem__label">
                팀원 {{ event.teamMembers.length - index }}
              </p>
            </div>

            <ul class="teamMembers">
              <li class="teamMembers__item">{{teamMember.name}}</li>
              <li class="teamMembers__item">{{teamMember.birth}}</li>
              <li class="teamMembers__item">{{teamMember.phoneNum}}</li>
            </ul>
          </template>

          <div class="m_formItem">
            <div class="m_btns" v-if="!event.isOpenAccount">
              <button class="m_btns__btn" @click="event.teamModifyStatus = 'write' ">수정</button>
            </div>
            <div class="m_btns">
              <button class="m_btns__btn s_gray" @click="foldTeamMembers(event, index)">닫기</button>
            </div>
          </div>
        </div>

      </template>

    </template>

    <div class="m_faBtns [ _mfaBtns ]">
      <!-- <span v-if="!parentAgree">부모 동의 후 결제받기 가능</span> -->
      <button class="m_faBtns__btn" @click="openPriceLayer">가상계좌받기</button>
    </div>

  </div>

  <!-- caution layer  -->
  <div class="m_guideLayer [ _overLayer _cautionLayer ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">

      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle s_caution [ _overLayer__title ]">주의사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText s_caution">
          선택 종목을 선택해제 하시겠습니까? 선택해제시 팀원 정보가 삭제 됩니다.
        </p>
        <p class="m_guideLayer__subText">
          재등록시 다시 입력하셔야 합니다.
          진행하시겠습니까?
        </p>

        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn s_gray [ _cancelEventReject ]">닫기</button>
          <button class="m_guideLayerBtns__btn [ _cancelEventResolve ]">확인</button>
        </div>

      </div>
    </div>
  </div>

  <!-- cancel caution layer  -->
  <div class="m_guideLayer [ _overLayer _cancelCautionLayer ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">

      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle s_caution [ _overLayer__title ]">주의사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText s_caution">
          참가신청내역에서 취소 가능합니다.
        </p>
        <p class="m_guideLayer__subText">
          참가신청내역에서 취소 시 선택해제 됩니다.
        </p>

        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn s_gray" @click="cancelCautionLayer.el.close();">닫기</button>
          <a class="m_guideLayerBtns__btn" :href="'./applyHistory.asp?HostIDX=' + qs.hostIdx + '&TitleIdx=' + qs.titleIdx + '&Title=' + qs.title">참가신청내역 가기</a>
        </div>

      </div>
    </div>
  </div>

  <!-- team guide layer -->
  <div class="m_guideLayer [ _overLayer _teamGuideLayer ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">
      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle s_question [ _overLayer__title ]">안내사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText s_question">
          단체신청 안내사항
        </p>
        <p class="m_guideLayer__subText2">
          <span class="m_guideLayer__remark">1.</span> 단체전 신청 및 결제는 팀장이 대표로 진행해야 합니다.<br />
          <span class="m_guideLayer__remark">2.</span> 팀원의 참가신청 및 부모동의(미성년)가 완료되어야 단체전 결제가 가능합니다.<br />
          <span class="m_guideLayer__remark">3.</span> 팀원 변경 및 수정은 가상계좌 받기전까지 가능합니다. 이후 수정은 취소 후 재신청을 진행해야 합니다.<br />
          <span class="m_guideLayer__remark">4.</span> 팀장 및 팀원으로 종목을 등록한 ID는 검색이 되지 않습니다.<br />
          <span class="m_guideLayer__remark">5.</span> 그외 문의사항은 스포츠다이어리 고객센터에 문의주시기 바랍니다.
        </p>
        <p class="m_guideLayer__subText3">
          <문의전화><br />
          스포츠다이어리 고객센터<br />
          : 02-704-0282<br />
          운영시간<br />
          : 평일 09:00-18:00 (점심시간 12:00-13:00)
        </p>

        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn" @click="teamGuideLayer.el.close();">확인</button>
        </div>

      </div>
    </div>
  </div>

  <!-- 선택 종목 가격 레이어 -->
  <div class="priceLayer [ _overLayer _priceLayer ]">
    <div class="priceLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="priceLayer__inner [ _overLayer__box ]">

      <div class="priceLayer__header">
        <button class="priceLayer__close [ _overLayer__close ]">닫기</button>
      </div>

      <div class="priceLayer__content [ _overLayer__wrap ]">
        <h3 class="m_formTitle">선택종목</h3>
        <p class="m_cautionTxt s_small s_em">
          <span class="m_cautionTxt__refMark">※</span> 팀원대기상태 종목은 합계에 포함되지않습니다.
        </p>
        <p class="m_cautionTxt s_small s_em">
          <span class="m_cautionTxt__refMark">※</span> 참가 종목을 한번에 선택해야 할인이  적용됩니다. 만약 개인전 추가신청을 원하시면 개인전 전체 취소 후 재 참가신청을 진행해야 합니다.
        </p>

        <div class="m_apply">

          <div class="m_apply__group" v-if="priceLayer.priceByEvent.soloEvent.length !== 0">
            <p class="m_apply__groupTitle">
              개인
            </p>
            <ul class="m_apply__list">
              <li class="m_apply__item" v-for="(event, index) in priceLayer.priceByEvent.soloEvent">
                <span class="m_apply__text s_event">{{event.name}}</span>
                <span class="m_apply__cost s_event">{{numberWithCommas(event.fee)}} 원</span>
              </li>

              <li class="m_apply__item" v-if="priceLayer.priceByEvent.soloEventDiscount">
                <span class="m_apply__text s_discount">{{priceLayer.priceByEvent.soloEvent.length}}종목 할인</span>
                <span class="m_apply__cost s_discount">-{{numberWithCommas(priceLayer.priceByEvent.soloEventDiscount)}} 원</span>
              </li>
            </ul>
          </div>

          <div class="m_apply__group" v-if="priceLayer.priceByEvent.groupEvent.length !== 0">
            <p class="m_apply__groupTitle">
              단체
            </p>
            <ul class="m_apply__list">
              <li class="m_apply__item" v-for="(event, index) in priceLayer.priceByEvent.groupEvent">
                <span class="m_apply__text s_event">{{event.name}}</span>
                <span class="m_apply__cost s_event">{{numberWithCommas(event.fee)}} 원</span>
              </li>
            </ul>
          </div>

          <div class="m_apply__total">
            <p class="m_apply__totalInner">
              <span>합계</span> <span class="m_apply__totalCost">{{numberWithCommas(priceLayer.priceByEvent.totalPrice)}} 원</span>
            </p>
          </div>

        </div>

        <div class="priceLayer__btns">
          <button class="priceLayer__btn" @click="openVAccount">가상계좌받기</button>
        </div>

      </div>
    </div>
  </div>

  <!-- account layer  -->
  <div class="m_guideLayer [ _overLayer _accountLayer  ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">

      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle s_caution [ _overLayer__title ]">주의사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText">
          가상계좌가 발급되었습니다.
        </p>
        <p class="m_guideLayer__subText">
          자세한 내용은 참가신청내역 페이지에서 보실 수 있습니다.
        </p>

        <p class="m_vAccount">
          가상계좌 (예금주: 위드라인)<br />
          KEB 하나은행 {{accountLayer.account}}
        </p>
        <div class="m_apply__total">
          <p class="m_apply__totalInner">
            <span>입금액</span> <span class="m_apply__totalCost">{{numberWithCommas(accountLayer.deposit)}} 원</span>
          </p>
        </div>

        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn s_gray" @click="accountLayer.el.close();">닫기</button>
          <a class="m_guideLayerBtns__btn" :href="'./applyHistory.asp?HostIDX=' + qs.hostIdx + '&TitleIdx=' + qs.titleIdx + '&Title=' + qs.title">참가신청내역</a>
        </div>

      </div>
    </div>
  </div>

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>

  preload("http://img.sportsdiary.co.kr/images/SD/icon/check_on_s_@3x.png");

  var vm = new Vue({
    mixins: [mixInLoader],
    el: '#app',
    data: {
      qs: {},
      parentAgree: undefined,
      eventList: {
        soloEvent: [],
        groupEvent: []
      },
      eventCood: {
        solo: {},
        group: {}
      },
      cautionLayer: {
        el: {},
        currentEvent: undefined,
      },
      cancelCautionLayer: {
        el: {},
      },
      teamGuideLayer: {
        el: {},
      },
      priceLayer: {
        el: {},
        priceByEvent: {
          groupEvent: [],
          soloEvent: [],
          soloEventDiscount: '',
          totalPrice: '',
        }
      },
      accountLayer: {
        el: {},
        account: '',
        deposit: '',
      }
    },
    methods:{
      numberWithCommas: function(x){
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      },
      selectEvent: function(event){
        // 가상계좌를 받았으면 선택불가
        if(event.isOpenAccount){
          this.cancelCautionLayer.el.open();
          return;
        }

        // + 단체 취소
        if(event.type==='group' && event.isSelected){
          if(!event.isTeamLeader){ alert('팀원으로 신청되어 수정이 불가능합니다'); return; }

          new Promise((resolve, reject)=>{
            this.cautionLayer.el.open();
            var elResolve = document.querySelector('._cancelEventResolve');
            var elReject = document.querySelector('._cancelEventReject');
            var resolveHandler = function(){
              elResolve.removeEventListener('click', resolveHandler);
              elReject.removeEventListener('click', rejectHandler);
              resolve();
            }
            var rejectHandler = function(){
              elResolve.removeEventListener('click', resolveHandler);
              elReject.removeEventListener('click', rejectHandler);
              reject();
            }
            elResolve.addEventListener('click', resolveHandler);
            elReject.addEventListener('click', rejectHandler);
          })
          .then(()=>{
            delMembers = event.teamMembers.map(function(item){return item.memberIdx;})

            let params = {
              eventApplyIdx: event.eventApplyIdx,
              mode: 'all',
              teamMemberDel: delMembers.join(','),
              cancelYN: event.VAccountYN
            }

            console.log(params)

            axios({
              url: '../ajax/member/apply/team_info_D.asp',
              method: 'post',
              params: params
            })
            .then(response=>{
              console.log(response.data)
              if(!response.data) throw new Error('error');

              event.isSelected = false;

              // !@#
              event.isTeamShow = false;

              event.teamIdx = undefined;
              event.teamMembers = [];
              event.teamName = '';
            })
            this.cautionLayer.el.close();
          })
          .catch(error=>{
            this.cautionLayer.el.close();
          })

        }
        // + 개인 종목 선택/취소, 단체 선택
        else{

          let params = {
            titleIdx: this.qs.titleIdx,
            memberIdx: this.qs.memberIdx,
            eventIdx: event.eventIdx,
            eventApplyIdx: event.eventApplyIdx,
          }

          return axios({
            url:'../ajax/member/apply/event_apply_W.asp',
            method:'get',
            params: params
          })
          .then(response=>{
            console.log(response.data)
            if(!response.data.return) throw new Error('error');
            event.eventApplyIdx = response.data.eventApplyIdx;

            if(response.data.state == 'Y') event.isSelected = true;
            else event.isSelected = false;

            return response
          })
          .then(response=>{
            if(event.type!=='group') return;


            if(response.data.state == 'Y'){
              event.isTeamShow = true;
              event.teamModifyStatus = 'write';
            }
            else event.isTeamShow = false;


          })
          .catch(error=>{ console.log(error); })
        }
      },

      changeTeamName: function(event){
        if(event.teamName === event.teamNameOrigin){
          event.isChangeTeamName = false;
          event.teamIdx = event.teamIdxOrigin;
        }
        else{
          event.isChangeTeamName = true;
          event.teamIdx = undefined;
        }
      },

      makeTeamName: function(event){
        axios({
          url: '../Ajax/Title/Event/team_name_search_i.asp',
          method:'post',
          params:{
            eventIdx: event.eventIdx,
            teamName: event.teamName,
          }
        })
        .then(response=>{
          if(!response.data.return) alert('사용불가 팀명입니다.');
          else{
            alert('사용 가능한 팀명입니다.');
            event.teamIdx = response.data.teamIdx;
            event.teamIdxOrigin = response.data.teamIdx;
          }
        })
      },
      addTeamMember: function(event, index){
        // 빈값 체크
        console.log('...............................')
        console.log(event);
        console.log(event.maxPlayer)
        if(event.maxPlayer - 1 <= event.teamMembers.length){
          alert('팀원은 최대' +  event.maxPlayer + '명 까지 입니다.');
          return;
        }
        if(!event.mTeamMemberId) return;

        axios({
          url: '../ajax/Member/member_search_R.asp',
          method: 'get',
          params: {
            id: event.mTeamMemberId.trim(),
            eventIdx: event.eventIdx,
            teamIdx: event.teamIdx
          }
        })
        .then(response=>{

          if(response.data.userInfo.length === 0){
            alert('해당ID는 이미 팀 등록이 되었거나 존재하지 않는 ID 입니다. ID를 확인하세요.');
            return;
          }
          console.log(response.data.userInfo)


          if(this.qs.memberIdx == response.data.userInfo[0].memberIdx){
            alert('자신이 아닌 다른 팀원을 추가해 주세요.');
            return;
          }
          for(let i=0, ii=event.teamMembers.length; i<ii; i++){
            if(event.teamMembers[i].memberIdx == response.data.userInfo[0].memberIdx){
              alert('해당ID는 이미 팀 등록이 되었거나 존재하지 않는 ID 입니다. ID를 확인하세요.');
              return;
            }
          }
          event.teamMembers.unshift(response.data.userInfo[0]);
          event.mTeamMemberId = '';
        })
      },
      delTeamMember: function(event, index){
        event.teamMembers.splice(index, 1);
      },

      unfoldTeamMembers: function(event, index){
        this.eventList.groupEvent[index].teamModifyStatus = (this.eventList.groupEvent[index].teamMembers.length === 0) ? 'write' : 'read';
        this.eventList.groupEvent[index].isTeamShow = true;
      },
      foldTeamMembers: function(event, index){
        this.eventList.groupEvent[index].isTeamShow = false;
      },

      registerTeam: function(event, index){

        // 팀 이름 체크, 팀원 체크
        if(!event.teamIdx){
          alert('팀명 중복 체크 후 진행해주세요.');
          return;
        }
        if(event.teamMembers.length < event.minPlayer - 1){
          alert('팀인원수를 확인하세요.');
          return;
        }

        let membersOrigin = event.teamMembersOrigin.map(function(item){return item.memberIdx;})
        let members = event.teamMembers.map(function(item){return item.memberIdx;})

        // 팀원 변경 체크
        let isMembersUdpate = false;
        if(membersOrigin.length !== members.length){
          isMembersUdpate = true;
        }
        else{
          for(let i=0, ii=membersOrigin.length; i<ii; i++){
            if(membersOrigin[i] !== members[i]){
              isMembersUdpate = true;
              break;
            }
          }
        }
        console.log(isMembersUdpate, 'isupdate')

        // 팀원 및 팀명 변경 데이터 없을 시
        if(!isMembersUdpate && !event.isChangeTeamName) {
          event.teamModifyStatus = 'read';
          return;
        }

        console.log('parmas')

        let addMembers = members.filter(function(item){ return !membersOrigin.includes(item)} );
        let delMembers = membersOrigin.filter(function(item){ return !members.includes(item); });

        console.log('origin', membersOrigin)
        console.log('diff', members)

        let params = {
          memberIdx: this.qs.memberIdx,
          titleIdx: this.qs.titleIdx,
          eventApplyIdx: event.eventApplyIdx,
          teamIdx: event.teamIdx,
          teamMemberAdd: addMembers.join(','),
          teamMemberDel: delMembers.join(','),
        }

        console.log(params);
        axios({
          url: '../ajax/member/apply/team_info_W.asp',
          method:'post',
          params: params
        })
        .then(response=>{
          console.log(response.data)
          if(!response.data.return) throw new Error('error');


          event.teamModifyStatus = 'read';

          alert('팀이 등록되었습니다.')
        })
        .then(()=>{
          let params = {
            eventApplyIdx: event.eventApplyIdx,
            teamIdx: event.teamIdx
          }
          return this.r_teamMember(params, event, index)
        })
        .catch(error=>{
          console.log(error)
        })
        //  diff params
      },

      openPriceLayer: function(){
        console.log('open')

        // 부모 동의 체크
        // 선택된 종목 정보 재요청
        this.r_applyInfo()
        .then(()=>{
          if(!this.parentAgree){
            alert('보호자 동의 후 가상계좌 받기가 가능합니다.');
            return;
          }

          let eventIdxes = [];
          eventIdxes = this.eventList.soloEvent.reduce(function(pre, item){
            if(item.isSelected && item.VAccountYN === 'N'){
              pre.push(item.eventIdx);
            }
            return pre;
          }, eventIdxes);
          eventIdxes = this.eventList.groupEvent.reduce(function(pre, item){
            console.log('!!!!!!!!!')
            console.log(item)

            console.log(item.teamLeader)

            if(
              item.isSelected
              && item.VAccountYN === 'N'
              && item.teamReady === 'Y'
              && item.teamLeader === 'Y'
              // && item.teamMembers.length >= item.minPlayer
            ) pre.push(item.eventIdx);
            return pre;
          }, eventIdxes);

          console.log(eventIdxes)

          // + 단체 선택, 팀레디 상태 체크
          let a = [];
          a = this.eventList.groupEvent.reduce(function(pre, item){
            if(item.isSelected && item.teamReady === 'N') a.push(item.courseLength + item.name)
            return pre;
          }, a);

          // + 단체 선택, 팀원 or 팀장 상태 체크
          let b = [];
          b = this.eventList.groupEvent.reduce(function(pre, item){
            if(item.isSelected && item.teamLeader === 'N') b.push(item.courseLength + item.name)
            return pre;
          }, b);


          if(eventIdxes.length !== 0 && a.length !== 0){ alert('팀원대기상태 또는 팀원으로서 선택된 종목은 가상계좌 발급에서 제외됩니다.') }
          else if(a.length !== 0){ alert('팀원대기상태 또는 팀원으로서 선택된 종목은 가상계좌 발급에서 제외됩니다.') }
          else if(b.length !== 0){ alert('팀원대기상태 또는 팀원으로서 선택된 종목은 가상계좌 발급에서 제외됩니다.') }

          if(eventIdxes.length === 0) return;
          this.priceLayer.el.open();

          let params = {
            memberIdx: this.qs.memberIdx,
            eventIdx: eventIdxes.join(','),
          }
          console.log(params)

          axios({
            url: '../ajax/member/apply/fee_info_R.asp',
            method: 'post',
            params: params
          })
          .then(response=>{
            if(Object.keys(response.data.eventList).length === 0) return;
            this.priceLayer.priceByEvent =  response.data.eventList;
          })
          .catch(error=>{
            console.log(error);
          })
        })
      },
      openVAccount : function(){
        let eventIdxes = [];
        eventIdxes = this.eventList.soloEvent.reduce(function (pre, item) {
          if(
            item.isSelected
            && item.VAccountYN === 'N'
          ){ pre.push(item.eventIdx); }
          return pre;
        }, eventIdxes);
        eventIdxes = this.eventList.groupEvent.reduce(function (pre, item) {
          if(
            item.isSelected
            && item.VAccountYN === 'N'
            && item.teamReady === 'Y'
            && item.teamLeader === 'Y'
          ){ pre.push(item.eventIdx); }
          return pre;
        }, eventIdxes);

        console.log(eventIdxes)



        let params = {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          payKind: 'event',
          eventIdx: eventIdxes.join(','),
        }
        console.log(params)
        axios({
          url:'../ajax/payment/vAccount_W.asp',
          method:'post',
          params: params,
        })
        .then(response=>{
          console.log(response.data)
          if(!response.data.return) throw new Error('error');
          this.priceLayer.el.close();
          this.accountLayer.el.open();

          this.accountLayer.account = response.data.vAccount;
          this.accountLayer.deposit = response.data.depositPrice;
        })
        .then(()=>{
          return this.r_applyInfo()
        })
        .catch(error=>{
          console.log(error)
        })


      },
      r_applyInfo: function(){
        return axios({
          url: '../ajax/Member/Apply/info_R.asp',
          method: 'get',
          params: {
            titleIdx: this.qs.titleIdx,
            memberIdx: this.qs.memberIdx,
            parentInfo: 'Y',
          }
        })
        .then(response=>{
          // !@# error 처리

          if(response.data.parent){
            this.parentAgree = (response.data.parent === 'Y') ? true : false;
          }

          let applyEventList = response.data.applyList;

          console.log(applyEventList)
          applyEventList.solo.forEach((item)=>{
            this.eventCood.solo[item.eventIdx].eventApplyIdx = item.eventApplyIdx;
            this.eventCood.solo[item.eventIdx].VAccountYN = item.VAccountYN;
            this.eventCood.solo[item.eventIdx].payState = item.payState;
            this.eventCood.solo[item.eventIdx].isSelected = true;
            this.eventCood.solo[item.eventIdx].isOpenAccount = (item.VAccountYN == 'Y') ? true : false;
          })
          applyEventList.group.forEach((item, index)=>{
            this.eventCood.group[item.eventIdx].eventApplyIdx = item.eventApplyIdx;
            this.eventCood.group[item.eventIdx].VAccountYN = item.VAccountYN;
            this.eventCood.group[item.eventIdx].payState = item.payState;
            this.eventCood.group[item.eventIdx].teamIdx = item.teamIdx;
            this.eventCood.group[item.eventIdx].teamIdxOrigin = item.teamIdx;
            this.eventCood.group[item.eventIdx].teamName = item.teamName;
            this.eventCood.group[item.eventIdx].teamNameOrigin = item.teamName;
            this.eventCood.group[item.eventIdx].teamLeader = item.teamLeader;
            // !@#

            // console.log(item.teamReady);
            // this.eventCood.group[item.eventIdx].teamReady = (item.teamReady == 'N') ? '!팀대기상태' : '';

            this.eventCood.group[item.eventIdx].isSelected = true;
            this.eventCood.group[item.eventIdx].isOpenAccount = (item.VAccountYN == 'Y') ? true : false;
            this.eventCood.group[item.eventIdx].isTeamLeader = (item.teamLeader == 'Y') ? true : false;
            this.eventCood.group[item.eventIdx].teamModifyStatus = (item.teamIdx) ? 'read' : 'write';

            // !@# 싱크 확인
            let params = {
              eventApplyIdx: item.eventApplyIdx
            }


            this.r_teamMember(params, item, index)
            .catch(error=>{
              console.log(error);
            })
          })


        })
        .catch(error=>{
          console.log(error);
        })
      },
      r_teamMember: function(params, event, index){

        console.log(index)

        return axios({
          url: '../ajax/member/apply/team_member_R.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          console.log('team정보')
          console.log(response.data)
          if(response.data.teamMembers.length === 0) return;

          console.log('===============')
          console.log(event);
          this.eventCood.group[event.eventIdx].teamMembers = response.data.teamMembers;
          this.eventCood.group[event.eventIdx].teamMembersOrigin = response.data.teamMembers.map(item=>{return item});


          // team 대기 상태 체크
          console.log('teamReady')
          console.log(this.eventList.groupEvent[index])
          this.eventCood.group[event.eventIdx].teamReady = response.data.teamReady;

        })
        .catch(error=>{
          console.log(error);
        })
      },

    },
    created() {
      this.qs.hostIdx  = '<%=HostIDX%>';
      this.qs.memberIdx = '<%=MemberIDX%>';
      this.qs.titleIdx = '<%=TitleIDX%>';
      this.qs.title = '<%=Title%>';
      this.qs.eventType = '<%=EventType%>';

      axios({
        url: '../ajax/Title/Event/list_R.asp',
        method: 'get',
        params: {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          eventType: this.qs.eventType,
        }
      })
      .then(response=>{
        console.log('종목 정보')
        let eventList = response.data.eventList;
        console.log(eventList)
        this.eventList.soloEvent = eventList.soloEvent.map((item)=>{
          item.type = 'solo';
          item.isSelected = false;
          item.VAccountYN = 'N';
          item.ratingCategory = (item.ratingCategory === '전체등급') ? '' : item.ratingCategory;
          this.eventCood.solo[item.eventIdx] = item;

          return item;
        });
        this.eventList.groupEvent = eventList.groupEvent.map((item)=>{
          console.log(item)
          item.type = 'group';
          item.VAccountYN = 'N';
          item.ratingCategory = (item.ratingCategory === '전체등급') ? '' : item.ratingCategory;

          item.teamIdx = undefined;
          item.teamIdxOrigin = undefined;
          item.teamName = '';
          item.teamNameOrigin = '';
          item.teamMembers = [];
          item.teamMembersOrigin = [];
          item.mTeamMemberId = '';

          item.teamReady = 'N';
          item.playersCountText = (item.minPlayer !== item.maxPlayer) ? '(' + item.minPlayer + ' ~ ' + item.maxPlayer + '인)' : '(' + item.maxPlayer + '인)'

          item.isSelected = false;
          item.isChangeTeamName = false;
          item.isTeamLeader = true;
          item.isTeamShow = false;
          item.teamModifyStatus = 'write';

          this.eventCood.group[item.eventIdx] = item;
          return item;
        });
      })
      .then(()=>{
        return this.r_applyInfo()
      })
      .catch(error=>{
        console.log(error)
      })

    },
    mounted() {

      this.cautionLayer.el = new OverLayer({
        overLayer: $('._cautionLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      // this.cautionLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.cautionLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});

      this.cancelCautionLayer.el = new OverLayer({
        overLayer: $('._cancelCautionLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      // this.cancelCautionLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.cancelCautionLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});

      this.priceLayer.el = new OverLayer({
        overLayer: $('._priceLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      // this.priceLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.priceLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});

      this.accountLayer.el = new OverLayer({
        overLayer: $('._accountLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      // this.accountLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.accountLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});

      this.teamGuideLayer.el = new OverLayer({
        overLayer: $('._teamGuideLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });

      <%
        a = request.Cookies("a")
        If a <> "" then
      %>
        if(/iPhone|iPad|iPod/i.test(navigator.userAgent)){
          $("._content").on('focus', 'input, select', function(){ $(".l_header").css("position", "absolute") });
          $("._content").on('blur', 'input, select', function(){ $(".l_header").css("position", "fixed") });
        }
        else{
          $("._content").on('focus', 'input, select', function(){ $("._mfaBtns").css("display", "none") });
          $("._content").on('blur', 'input, select', function(){ $("._mfaBtns").css("display", "block") });
        }
      <%End If%>

    }
  })
</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
