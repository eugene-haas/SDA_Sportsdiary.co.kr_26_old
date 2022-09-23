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
<div id="app" class="l applyHistory m_bg_f2f2f2" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">참가신청내역</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>

    <!--  -->
    <div class="major_banner">
      <div class="banner banner_sm carousel">
        <div class="bxslider">

          <div style="background-color:#CFB09C;">
            <% if (IPHONEYN() <> "0") then %>
            <a onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/mobile/coupon/coupon_list.asp')">
            <% else %>
            <a href="http://www.sdamall.co.kr/mobile/coupon/coupon_list.asp" target="_blank">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/bi_banner_sm.jpg" alt="">
            </a>
          </div>

          <div style="background-color: #454344">
            <% if (IPHONEYN() <> "0") then %>
            <a onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=44')">
            <% else %>
            <a href="http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=44" target="_blank">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/1_sm.jpg" alt="">
            </a>
          </div>

          <div style="background-color: #BFBFBF">
            <% if (IPHONEYN() <> "0") then %>
            <a onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=44')">
            <% else %>
            <a href="http://www.sdamall.co.kr/mobile/brand/brand_list.asp?brandSEQ=44" target="_blank">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/2_sm.jpg" alt="">
            </a>
          </div>

          <div style="background-color: #020202">
            <% if (IPHONEYN() <> "0") then %>
            <a onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/mobile/Product/detail.asp?seq=384757')">
            <% else %>
            <a href="http://www.sdamall.co.kr/mobile/Product/detail.asp?seq=384757" target="_blank">
            <% end if%>
              <img src="http://img.sportsdiary.co.kr/images/etc/banner/tempBi/3_sm.jpg" alt="">
            </a>
          </div>


        </div>
      </div>
    </div>
    <!--  -->

  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_subTitle">
      <h2 class="m_subTitle__title s_noBorderBottom">{{qs.title}}</h2>

      <p class="additional">
        <span>D{{titleDDay}}</span><span>{{titleDuration}}</span>
      </p>

      <div class="m_borderBtns">
        <a :href="'../Request/applicant.asp?HostIDX=' + qs.hostIdx + '&titleIdx=' + qs.titleIdx + '&title=' + qs.title" class="m_borderBtns__btn">신청자정보</a>
        <a :href="'../Request/eventStep1.asp?HostIDX=' + qs.hostIdx + '&titleIdx=' + qs.titleIdx + '&title=' + qs.title" class="m_borderBtns__btn">종목추가</a>
      </div>
    </div>

    <div class="m_apply s_board" v-for="(payment, index) in paymentList" :class="{ s_cancel: (payment.paymentStateText == '취소됨' || payment.paymentStateText == '환불완료') }" >
      <div class="m_apply__header">
        <span class="m_apply__status" :class="{ s_canceled: (payment.paymentStateText == '취소됨' || payment.paymentStateText == '환불완료'),  s_success: payment.paymentStateText == '입금완료' }">{{payment.paymentStateText}}</span>
        <button class="m_apply__cacnelBtn" @click="closeAccount(payment, index)" v-if="payment.paymentStateText == '입금대기' || payment.paymentStateText == '입금완료'">신청 취소</button>
      </div>
      <p class="m_vAccount">
        가상계좌 (예금주: {{payment.accountHolder}})<br />
        {{payment.bank}} {{payment.account}}
      </p>

      <div class="m_apply__group" v-if="payment.soloEvent.length !== 0">
        <p class="m_apply__groupTitle">
          {{ payment.soloEvent[0].gender }} / 개인
        </p>
        <ul class="m_apply__list">
          <li class="m_apply__item" v-for="event in payment.soloEvent">
            <span class="m_apply__text s_event">{{event.name}}</span><span class="m_apply__cost s_event">{{numberWithCommas(event.price)}} 원</span>
          </li>

          <!-- <li class="m_apply__item"><span class="m_apply__text s_event">제외경기</span><span class="m_apply__cost s_event">30,000 원</span></li>
          <li class="m_apply__item"><span class="m_apply__text s_event">스크래치경기</span><span class="m_apply__cost s_event">30,000 원</span></li> -->
          <li class="m_apply__item" v-if="payment.soloEventDiscount != 0">
            <span class="m_apply__text s_discount">{{payment.soloEvent.length}}종목 할인</span><span class="m_apply__cost s_discount">{{numberWithCommas(payment.soloEventDiscount)}} 원</span>
          </li>
        </ul>
      </div>

      <div class="m_apply__group" v-if="payment.groupEvent.length !== 0">
        <p class="m_apply__groupTitle">
          {{payment.groupEvent[0].gender}} / 단체
        </p>
        <ul class="m_apply__list">
          <li class="m_apply__item" v-for="event in payment.groupEvent">
            <span class="m_apply__text s_event">{{event.courseLength}} {{event.name}} ({{event.minPlayer + '~' + event.maxPlayer + '인'}})</span><span class="m_apply__cost s_event">{{numberWithCommas(event.price)}} 원</span>
          </li>
        </ul>
      </div>

      <div class="m_apply__total">
        <p class="m_apply__totalInner">
          <span>합계</span> <span class="m_apply__totalCost">{{numberWithCommas(payment.totalPrice)}} 원</span>
        </p>
      </div>

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
  var vm = new Vue({
    mixins: [mixInLoader],
    el: '#app',
    data: {
      qs: {},
      refundLayer: {
        el: {},
        holder: '',
        bank: '',
        account: '',
        currentPayment: undefined,
      },
      titleInfo: {
        startDate: '',
        endDate: ''
      },
      paymentList: []
    },
    methods: {
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
      closeAccount: function(payment, index){

        if(!confirm('정말 취소하시겠습니까? 취소 이후에는 새롭게 진행해야 합니다.')) return;

        let params = {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          paymentIdx: this.paymentList[index].paymentIdx,
        }

        // + 입금상태 확인
        axios({
          url:'../ajax/payment/payment_history_r.asp',
          method:'get',
          params: params
        })
        // + 입금완료 상태 취소 환불 정보 받기 and 취소
        .then(response=>{
          // 0 입금대기
          // 1 입금완료
          this.paymentList[index] = response.data.paymentList[0];
          if(this.paymentList[index].paymentState !== 1) return true;

          return new Promise((resolve, reject)=>{
            this.refundLayer.el.open();
            var vm = this;

            var elResolve = document.querySelector('._cancelEventResolve');
            var elReject = document.querySelector('._cancelEventReject');
            var resolveHandler = function(){

              let params = {
                memberIdx: vm.qs.memberIdx,
                paymentIdx: payment.paymentIdx,
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
        // + 입금대기 상태 취소
        .then(isCancel=>{
          if(!isCancel) return;
          let params = {
            paymentIdx: this.paymentList[index].paymentIdx,
            memberIdx: this.qs.memberIdx,
          }

          return axios({
            url: '../ajax/Payment/payment_cancel_W.asp',
            method: 'post',
            params: params
          })
          .then(response=>{
            // console.log('response');
          })
        })
        // 가상계좌별 리스트 갱신
        .then(()=>{
          return this.r_paymentHistory()
        })
        .catch(error=>{
          console.log(error);
        })

      },
      r_paymentHistory: function(){
        let params = {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx
        }

        return axios({
          url:'../ajax/payment/payment_history_r.asp',
          method:'get',
          params: params
        })
        .then(response=>{
          if(response.data.paymentList.length === 0) return;
          this.paymentList = response.data.paymentList;
          // + sorting
          // let list = response.data.paymentList.map(item=>{
          //   switch(item.paymentState){
          //     case 1: item.order = 1; break; //입금완료
          //     case 0: item.order = 2; break; //입금대기
          //     case 3: item.order = 3; break; //환불중
          //     case 4: item.order = 4; break; //환불완료
          //     case 2: item.order = 5; break; //취소됨
          //   }
          //   return item;
          // })
          // this.paymentList = list.sort(function(a, b){
          //   return a.order - b.order;
          // });

        })
      }
    },
    computed: {
      titleDuration: function(){
        return this.titleInfo.startDate.replace(/-/g, '.') + ' ~ ' + this.titleInfo.endDate.replace(/-/g, '.')
      },
      titleDDay: function(){
        let dday = moment().diff(moment(this.titleInfo.startDate), 'days');
        if(dday>0){ dday = '+' + dday; }
        return dday;
      }
    },
    created() {
      this.qs.hostIdx  = '<%=HostIDX%>';
      this.qs.memberIdx = '<%=MemberIDX%>';
      this.qs.titleIdx = '<%=TitleIDX%>';
      this.qs.title = '<%=Title%>';

      axios({
        url: '../ajax/title/detail_R.asp',
        method: 'get',
        params: {titleIdx: this.qs.titleIdx}
      })
      .then(resDetail=>{
        if(!resDetail.data) throw new Error('error');

        this.titleInfo.startDate = resDetail.data.startDate;
        this.titleInfo.endDate = resDetail.data.endDate;
      })
      .then(()=>{
        return this.r_paymentHistory()
      })
      .then(()=>{

      })


    },
    mounted() {
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
