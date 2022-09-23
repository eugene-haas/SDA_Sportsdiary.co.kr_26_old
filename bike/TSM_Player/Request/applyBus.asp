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
<div id="app" class="l applyBus" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">버스신청</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_subTitle">
      <h2 class="m_subTitle__title">{{qs.title}}</h2>
    </div>

    <div class="guide">
      <p class="guide__txt">
        <span class="guide__status" :class="{s_success: busApply[0].paymentState == 1, s_cancel: busApply[0].paymentState >= 4 }" v-if="busApply[0].paymentStateText">{{busApply[0].paymentStateText}}</span>
        본인이 탑승하실 장소를 결정해 주세요.
      </p>
    </div>

    <p class="m_cautionTxt s_em">
      <span class="m_cautionTxt__refMark">※</span> 버스이용선택 지역당 30명 선착순 입니다.
    </p>

    <div class="checkWrap">
      <label class="m_formCheck" v-for="(bus, index) in busList">
        <div class="m_formCheck__checkWrap">
          <input type="radio" class="m_formCheck__checkbox" hidden :value="bus.busIdx" v-model="selectedBusIdx"/><span class="m_formCheck__button"></span>
        </div>
        <p class="busTxt" :class="{s_blur: bus.busIdx !== selectedBusIdx }">
          <span>{{bus.startDate}}({{ bus.day }}) {{bus.departmentTime}} 출발 ({{bus.startLocation}})</span><br />
          <span class="busTxt__count" :class="{s_normal : bus.busIdx == selectedBusIdx, s_warning: bus.busApplyCount >= 15}">{{bus.busApplyCount}}</span><span>/{{bus.busMemberLimit}}</span>
        </p>
      </label>
    </div>

    <div class="vAccountWrap" v-if="Object.keys(busApply[0]).length !== 0">
      <p class="m_vAccount">
        가상계좌 (예금주: 위드라인)<br />
        {{busApply[0].vAccountBank}} {{busApply[0].vAccount}}
      </p>
      <div class="m_apply__total">
        <p class="m_apply__totalInner">
          <span>입금액</span> <span class="m_apply__totalCost">{{ numberWithCommas(busApply[0].busFare)}} 원</span>
        </p>
      </div>
    </div>

    <p class="m_cautionTxt">
      <span class="m_cautionTxt__refMark">※</span> 인원이 미만이 될 경우 취소 또는 집결장소가 변경 될 수 있습니다. (개별연락 예정)<br />
      <span class="m_cautionTxt__refMark">※</span> 신청자가 30명이 넘을 경우 선착순 선정 및 버스 신청자에서 제외 될 수 있습니다. (개별연락 예정)
    </p>

    <div class="m_bottomBtns" v-if="!busApply[0].busApplyIdx">
      <button class="m_bottomBtns__btn" @click="apply">버스신청</button>
    </div>
    <div class="m_bottomBtns" v-if="busApply[0].busApplyIdx">
      <button class="m_bottomBtns__btn s_gray" @click="cancel">신청취소</button>
      <button class="m_bottomBtns__btn" @click="modify">지역변경</button>
    </div>
  </div>

  <!-- 환불정보 레이어 -->
  <div class="m_reqLayer [ _overLayer _refundLayer ]">
    <div class="m_reqLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_reqLayer__inner [ _overLayer__box ]">

      <div class="m_reqLayer__header">
        <h1 class="m_reqLayer__headerTitle [ _overLayer__title ]">환불계좌(본인계좌환불)</h1>
        <button class="m_reqLayer__headerClose" @click="closeRefundLayer">닫기</button>
      </div>

      <div class="m_reqLayer__content [ _overLayer__wrap ]">
        <div class="m_cautionTxt">
          <span class="m_cautionTxt__refMark">※</span>
          신청 취소시 환불받으실 계좌를 입력해주세요.
        </div>

        <h3 class="m_formTitle">계좌정보</h3>
        <div class="m_formItem">
          <p class="m_formItem__label">예금주</p>
          <div class="m_formItem__inner">
            <input type="text" placeholder="예금주를 입력해주세요." class="m_formItem__input" :value="refundLayer.holder"  @input="refundLayer.holder=$event.target.value;">
          </div>
        </div>
        <div class="m_formItem">
          <p class="m_formItem__label">은행선택</p>
          <div class="m_formItem__inner">
            <input type="text" placeholder="은행명을 입력해주세요." class="m_formItem__input" :value="refundLayer.bank"  @input="refundLayer.bank=$event.target.value;">
          </div>
        </div>
        <div class="m_formItem">
          <p class="m_formItem__label">계좌번호</p>
          <div class="m_formItem__inner">
            <input type="tel" placeholder="본인명의계좌(-없이 입력)." class="m_formItem__input" v-model="refundLayer.account">
          </div>
        </div>

        <div class="m_reqLayerBtns">
          <button class="m_reqLayerBtns__btn s_gray [ _cancelEventReject ]">닫기</button>
          <button class="m_reqLayerBtns__btn [ _cancelEventResolve ]">환불신청</button>
        </div>
      </div>

    </div>
  </div>

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>

  preload("http://img.sportsdiary.co.kr/images/SD/icon/check_on_s_@3x.png");

  moment.lang('ko', {
    weekdays: ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"],
    weekdaysShort: ["일","월","화","수","목","금","토"],
  });

  var vm = new Vue({
    mixins: [mixInLoader],
    el: '#app',
    data: {
      mixins: [mixInLoader],
      qs: {},
      selectedBusIdx: '',
      busList:[],
      busApply: [{}],
      refundLayer: {
        el: {},
        holder: '',
        bank: '',
        account: '',
        currentPayment: undefined,
      },
    },
    methods:{
      numberWithCommas: function(x){
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      },
      closeRefundLayer: function(){
        this.refundLayer.el.close();
        this.refundLayer.currentPayment = undefined;
        this.refundLayer.name = '';
        this.refundLayer.bank = '';
        this.refundLayer.account = '';
      },
      modify: function(){
        // 지역만 변경
        if(this.selectedBusIdx == this.busApply[0].busIdx) return;
        let params = {
          memberIdx: this.qs.memberIdx,
          busIdx: this.selectedBusIdx,
          busApplyIdx: this.busApply[0].busApplyIdx,
        }
        axios({
          url: '../ajax/Title/bus_apply_change_W.asp',
          method: 'post',
          params: params
        })
        .then(response=>{

          if(!response.data.return){
            if(response.data.message) alert(response.data.message);
          }
          else{
            this.selectedBusIdx = response.data.busIdx;
            this.busApply[0].busApplyIdx = response.data.busApplyIdx;
            alert('변경되었습니다.');
          }

        })
        // 데이터 갱신
        .then(()=>{
          return this.r_busList()
        })
        .catch(error=>{
          console.log(error)
        })
      },
      apply: function(){
        if(!this.selectedBusIdx) return;
        if(this.selectedBusIdx && this.selectedBusIdx == this.busApply[0].busIdx) return;

        let params = {
          memberIdx: this.qs.memberIdx,
          busIdx: this.selectedBusIdx,
        }

        // 버스신청
        axios({
          url: '../ajax/Title/bus_apply_W.asp',
          method: 'post',
          params: params
        })
        .then(response=>{

          if(!response.data.return){
            if(response.data.message) alert(response.data.message);
          }
          else{
            this.busApply[0].busApplyIdx = response.data.busApplyIdx;
          }

        })
        // 가상계좌 발급
        .then(response=>{
          let params = {
            memberIdx: this.qs.memberIdx,
            titleIdx: this.qs.titleIdx,
            payKind: 'bus',
            busApplyIdx : this.busApply[0].busApplyIdx
          }

          return axios({
            url: '../ajax/payment/vAccount_W.asp',
            method: 'post',
            params: params
          })
          .then(response=>{
            if(!response.data.return) throw new Error('error')
          })
        })
        // 데이터 갱신
        .then(()=>{
          return this.r_busList()
        })
        .catch(error=>{
          console.log('error');
        })

      },
      cancel: function(){
        let params = {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          paymentIdx: this.busApply[0].paymentIdx
        }
        // + 입금상태 확인
        axios({
          url:'../ajax/payment/payment_history_r.asp',
          method:'get',
          params: params
        })
        // + 환불 정보
        .then(response=>{
          // 0 입금대기
          // 1 입금완료
          // 2 취소됨
          // 3 환불중
          // 4 환불 완료

          if(response.data.paymentList.length == 0) return true;
          this.busApply[0].paymentState = response.data.paymentList[0].paymentState;
          if(this.busApply[0].paymentState !== 1) return true;

          // + 입금 완료 시 환불 정보 입력
          return new Promise((resolve, reject)=>{

            this.refundLayer.el.open();
            var vm = this;

            var elResolve = document.querySelector('._cancelEventResolve');
            var elReject = document.querySelector('._cancelEventReject');
            var resolveHandler = function(){

              let params = {
                memberIdx: vm.qs.memberIdx,
                paymentIdx: vm.busApply[0].paymentIdx,
                accountName: vm.refundLayer.holder,
                accountBank: vm.refundLayer.bank,
                accountNumber: vm.refundLayer.account,
              }

              if(!params.accountName){
                alert('예금주를 확인해주세요.')
                return;
              }
              if(!params.accountBank){
                alert('은행명을 확인해주세요.')
                return;
              }
              let regNumber = /^[0-9]+$/;
              if(!regNumber.test(params.accountNumber)){
                alert('계좌번호를 확인해주세요')
                return;
              }

              elResolve.removeEventListener('click', resolveHandler);
              elReject.removeEventListener('click', rejectHandler);

              axios({
                url: '../ajax/Payment/refund_request_W.asp',
                method: 'post',
                params: params
              })
              .then(response=>{
                if(!response.data.return) throw new Error('error');
                alert('환불 신청이 접수되었습니다');
                resolve();
              })
              .catch(error=>{
                console.log('error')
              })

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
            this.closeRefundLayer();
            return true;
          })
          .catch(()=>{
            this.closeRefundLayer();
            return false;
          })

        })
        // 버스 취소
        .then(isCancelBus=>{
          if(!isCancelBus) return;

          let params = {
            memberIdx: this.qs.memberIdx,
            busApplyIdx: this.busApply[0].busApplyIdx,
            paymentIdx: this.busApply[0].paymentIdx
          }

          return axios({
            url: '../ajax/Title/bus_apply_cancel_W.asp',
            method: 'post',
            params: params
          })
          .then(response=>{
            if(!response.data.return) throw new Error('error');
            this.busApply = [{}];
            this.selectedBusIdx = '';
          })

        })
        // 데이터 갱신
        .then(()=>{
          return this.r_busList()
        })
        .catch(error=>{
          console.log(error)
        })

      },
      r_busList: function(){
        return axios({
          url: '../ajax/Title/bus_list_R.asp',
          method: 'get',
          params: {
            titleIdx: this.qs.titleIdx,
            memberIdx: this.qs.memberIdx
          }
        })
        .then(response=>{
          this.busList = response.data.busList.map(item=>{
            item.day = moment(item.startDate).format('ddd');

            return item
          });

          if(response.data.busApply.length == 0) return;
          this.busApply = response.data.busApply;
          this.selectedBusIdx = this.busApply[0].busIdx;

        })
      },
    },
    created: function(){
      this.qs.hostIdx  = '<%=HostIDX%>';
      this.qs.memberIdx = '<%=MemberIDX%>';
      this.qs.titleIdx = '<%=TitleIDX%>';
      this.qs.title = '<%=Title%>';

      this.r_busList()
      .catch(error=>{
        console.log(error);
      });
    },
    mounted: function(){
      this.refundLayer.el = new OverLayer({
        overLayer: $('._refundLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      // this.refundLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.refundLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});

      <%
        a = request.Cookies("a")
        If a <> "" then
      %>
        if(/iPhone|iPad|iPod/i.test(navigator.userAgent)){
          $("._content").on('focus', 'input, select', function(){ $(".l_header").css("position", "absolute") });
          $("._content").on('blur', 'input, select', function(){ $(".l_header").css("position", "fixed") });
        }
      <%End If%>
    }
  })
</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
