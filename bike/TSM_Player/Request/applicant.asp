<!-- #include file="../Library/header.bike.asp" -->

<%
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
<div id="app" class="l applicant" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">신청자 등록</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_subTitle">
      <h2 class="m_subTitle__title">{{qs.title}}</h2>
    </div>

    <div>
      <p class="m_cautionTxt">
        <span class="m_cautionTxt__refMark">※</span>참가신청 기간 외에는 등록 및 수정이 불가합니다.
      </p>
      <!-- scrp  -->
      <h3 class="m_formTitle">SCRP등급선택</h3>
      <div class="m_formItem">
        <div class="m_formItem__inner s_low" v-if="scrpUseFg">
          <span class="m_formItem__text">{{moreInfo.scrp}}</span>
          <button class="m_formItem__btn s_induce" @click="scrpLayer.el.open()">등급선택</button>
        </div>

        <div class="m_formItem__inner s_low" v-if="!scrpUseFg">
          <span class="m_formItem__text">{{moreInfo.scrp}}</span>
          <button class="m_formItem__btn" @click="alert('대회 참가 및 SCRP 등급의 이력이 있습니다.\nSCRP 등급 수정은 불가합니다. 관련문의는 고객센터로 연락 바랍니다.(02-704-0282)')">등급선택</button>
        </div>
      </div>

      <!-- 기본정보  -->
      <h3 class="m_formTitle">기본정보</h3>
      <div class="m_formItem">
        <p class="m_formItem__inner s_low">
          <span class="m_formItem__text">{{memberInfo.name}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_low">
          <span class="m_formItem__text">{{memberInfo.birth}}{{memberInfo.gender}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_low">
          <span class="m_formItem__text">{{memberInfo.phoneNum}}</span>
        </p>
      </div>

      <!-- 추가정보 -->
      <h3 class="m_formTitle">추가정보</h3>
      <div class="m_formItem">
        <p class="m_formItem__label">혈액형</p>
        <div class="m_formRadios">
          <label class="m_formRadios__item"><input type="radio" name="blood" hidden checked class="m_formRadios__radio" value="A" v-model="moreInfo.bloodType" :disabled="!applyOpenFg" /><span class="m_formRadios__button">A</span></label>
          <label class="m_formRadios__item"><input type="radio" name="blood" hidden class="m_formRadios__radio" value="O" v-model="moreInfo.bloodType" :disabled="!applyOpenFg" /><span class="m_formRadios__button">O</span></label>
          <label class="m_formRadios__item"><input type="radio" name="blood" hidden class="m_formRadios__radio" value="B" v-model="moreInfo.bloodType" :disabled="!applyOpenFg" /><span class="m_formRadios__button">B</span></label>
          <label class="m_formRadios__item"><input type="radio" name="blood" hidden class="m_formRadios__radio" value="AB" v-model="moreInfo.bloodType" :disabled="!applyOpenFg" /><span class="m_formRadios__button">AB</span></label>
        </div>
      </div>
      <div class="m_formItem">
        <label class="m_formItem__label">자전거 경력</label>
        <div class="m_formItem__inner">
          <select class="m_formItem__select" v-model="moreInfo.career" :disabled="!applyOpenFg">
            <option value="0">선택해주세요</option>
            <option v-for="option in moreInfo.careerOptions" :value="option.idx">{{option.name}}</option>
          </select>
        </div>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__label">자전거 프레임</p>
        <div class="m_formItem__inner">
          <select class="m_formItem__select" v-model="moreInfo.frame" :disabled="!applyOpenFg">
            <option value="0">선택해주세요</option>
            <option v-for="option in moreInfo.frameOptions" :value="option.idx">{{option.name}}</option>
          </select>
        </div>
      </div>
      <div class="m_formItem" v-if="moreInfo.giftOptions.length !== 0">
        <p class="m_formItem__label">티셔츠</p>
        <div class="m_formRadios">
          <label class="m_formRadios__item" v-for="option in moreInfo.giftOptions" :disabled="!applyOpenFg">
            <input type="radio" name="gift" hidden class="m_formRadios__radio" :value="option.giftNo" v-model="moreInfo.gift" :disabled="!applyOpenFg"/><span class="m_formRadios__button">{{option.option}}</span>
          </label>
        </div>
      </div>

      <!-- 보호자 정보 수정 -->
      <!-- <template v-if="this.applyOpenFg && memberInfo.adultYN  || (!memberInfo.adultYN && !parentInfo.agree)"> -->
      <template v-if="this.applyOpenFg && (memberInfo.adultYN || (!memberInfo.adultYN && !parentInfo.agree))">
      <h3 class="m_formTitle">보호자 정보 <span class="m_formTitle__status" v-if="!memberInfo.adultYN">보호자동의대기</span></h3>
      <div class="m_formItem">
        <p class="m_formItem__label">이름</p>
        <div class="m_formItem__inner">
          <input type="text" placeholder="보호자 이름을 입력해주세요." name="parentName" class="m_formItem__input"  maxlength="40" v-model="parentInfo.name" />
        </div>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__label">핸드폰</p>
        <div class="m_formPhone">
          <select class="m_formPhone__select" v-model="parentInfo.phoneNum1">
            <option value="010">010</option>
            <option value="011">011</option>
            <option value="016">016</option>
            <option value="017">017</option>
            <option value="018">018</option>
            <option value="019">019</option>
          </select>
          <input type="tel" class="m_formPhone__input" maxlength="4" v-model="parentInfo.phoneNum2" />
          <input type="tel" class="m_formPhone__input" maxlength="4" v-model="parentInfo.phoneNum3" />
        </div>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__label">참가자와의 관계</p>
        <div class="m_formRadios">
          <label class="m_formRadios__item"><input type="radio" name="applicantRelation" hidden class="m_formRadios__radio" value="부" v-model="parentInfo.relationship" @change="changeParentReationship($event.target.value);" /><span class="m_formRadios__button">부</span></label>
          <label class="m_formRadios__item"><input type="radio" name="applicantRelation" hidden class="m_formRadios__radio" value="모" v-model="parentInfo.relationship" @change="changeParentReationship($event.target.value);" /><span class="m_formRadios__button">모</span></label>
          <label class="m_formRadios__item"><input type="radio" name="applicantRelation" hidden class="m_formRadios__radio" value="기타" v-model="parentInfo.relationship" @change="changeParentReationship($event.target.value);" /><span class="m_formRadios__button">기타</span></label>

          <!-- <label class="m_formRadios__item"><input type="radio" name="applicantRelation" hidden class="m_formRadios__radio" value="부" v-model="parentInfo.relationshipCtrl" /><span class="m_formRadios__button">부</span></label>
          <label class="m_formRadios__item"><input type="radio" name="applicantRelation" hidden class="m_formRadios__radio" value="모" v-model="parentInfo.relationshipCtrl" /><span class="m_formRadios__button">모</span></label>
          <label class="m_formRadios__item"><input type="radio" name="applicantRelation" hidden class="m_formRadios__radio" value="기타" v-model="parentInfo.relationshipCtrl" /><span class="m_formRadios__button">기타</span></label> -->
        </div>
        <div class="m_formItem__inner" v-show="parentInfo.etcRelationshipFg">
          <input type="text" class="m_formItem__input" placeholder="참가자와의 관계를 입력해주세요." v-model="parentInfo.etcRelationship" />
        </div>
      </div>
      <div class="m_formItem" v-if="!memberInfo.adultYN && parentInfo.parentInfoIdx" >
        <div class="m_btns">
          <button class="m_btns__btn" @click="sendSMS">문자재발송</button>
        </div>
      </div>
      <p class="m_cautionTxt">
        <span class="m_cautionTxt__refMark">※</span>미성년자는 보호자 동의 완료 이후 가상계좌가 발급됩니다. <br />미성년자는 보호자 동의 후 보호자 정보 수정이 불가합니다.
      </p>
      </template>

      <!-- 보호자 정보 읽기 -->
      <!-- <template v-if="!this.applyOpenFg || (!memberInfo.adultYN && parentInfo.agree)"> -->
      <template v-if="!this.applyOpenFg || !memberInfo.adultYN && parentInfo.agree ">
      <h3 class="m_formTitle">보호자 정보 <span class="m_formTitle__status" v-if="!memberInfo.adultYN">보호자동의완료</span></h3>
      <div class="m_formItem">
        <p class="m_formItem__label">이름</p>
        <p class="m_formItem__inner">
          <input type="text" class="m_formItem__input" v-model="parentInfo.name" disabled />
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__label">핸드폰</p>
        <p class="m_formItem__inner">

          <!-- <input type="text" class="m_formItem__input" v-model="parentInfo.phoneNum1 + '-' + parentInfo.phoneNum2 + '-' + parentInfo.phoneNum3" disabled /> -->
          <input type="text" class="m_formItem__input" :value="parentInfo.phoneNum1 + '-' + parentInfo.phoneNum2 + '-' + parentInfo.phoneNum3" disabled />

        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__label">참가자와의 관계</p>
        <p class="m_formItem__inner">
          <input type="text" class="m_formItem__input" v-model="parentInfo.relationship" disabled />
        </p>
      </div>
      <p class="m_cautionTxt">
        <span class="m_cautionTxt__refMark">※</span>미성년자는 보호자 동의 완료 이후 가상계좌가 발급됩니다. <br />미성년자는 보호자 동의 후 보호자 정보 수정이 불가합니다.
      </p>
      </template>


      <h3 class="m_formTitle">서약서 동의</h3>
      <div class="m_formItem">
        <label class="m_formCheck">
          <div class="m_formCheck__checkWrap"><input type="checkbox" class="m_formCheck__checkbox" hidden  v-model="moreInfo.agree" /><span class="m_formCheck__button"></span></div>
          <p class="m_formCheck__text">하기 사항에 대하여 서약합니다.</p>
        </label>
      </div>

      <p class="m_cautionTxt">
        <span class="m_cautionTxt__refMark">※</span> 본인은 대회에 참가함에 있어<br />
        <span class="m_cautionTxt__refMark">1.</span> 대회규정을 준수하고 대회운영진의 통제에 성실히 따른다.<br />
        <span class="m_cautionTxt__refMark">2.</span> 대회 (경주, 부대행사) 중 발생되는 모든 사고(상해, 사망 등) 와 관련한 민·형사상의 책임에 대해 본인이 책임지며, 대회 참가 시 가입된 보험의 보험금 이외에 추가 보상을 요구하지 않는다.<br />
        <span class="m_cautionTxt__refMark">3.</span> 대회 (경주, 부대행사) 기간 발생되는 개인 물품의 파손 및 분실에 대해 본인이 책임을 지며, 타인이나 주최 측에 일체 보상을 요구 하지 않는다.<br />
        <span class="m_cautionTxt__refMark">4.</span> 본 대회의 홍보를 위해 신문, 잡지, 방송 (라디오,TV) 등 각종 언론매체에 본인의 이름과 사진을 자유롭게 사용할 것을 허락 한다.<br />
        <span class="m_cautionTxt__refMark">5.</span> 본 대회 참가신청서를 제출한 후 천재지변 등 기타 부득이한 사유를 제외하고 불참 할 경우 참가비는 반환되지 않으며, 어떠한 이의도 제기하지 않는다.<br />
        <span class="m_cautionTxt__refMark">6.</span> 서약서에 자발적으로 동의하고 본 서약서 외의 다른 구두 선언이나 발언을 하지 않을 것에 동의한다.<br />
      </p>

    </div>

    <div class="m_bottomBtns">
      <button class="m_bottomBtns__btn s_gray" @click="history.back();">이전</button>
      <button class="m_bottomBtns__btn" @click="next">다음</button>
    </div>

  </div>

  <!-- scrp  레이어 -->
  <div class="m_reqLayer SCRPLayer [ _overLayer  _scrpLayer ]">
    <div class=" [ _overLayer__backdrop ]"></div>
    <div class="m_reqLayer__contWrap [ _overLayer__box ]">
      <div class="m_reqLayer__header">
        <h1 class="m_reqLayer__headerTitle [ _overLayer__title ]">SCRP등급 선택</h1>
        <button class="m_reqLayer__headerClose [ _overLayer__close ]" >닫기</button>
      </div>

      <div class="m_reqLayer__content [ _overLayer__wrap ]">
        <p class="guideText"><span class="guideText__mark">*</span> 해당 등급 안에서 본인 레벨을 구분 선택해 주시기 바랍니다. <span class="guideText__em">(중복선택불가)</span></p>

        <template v-for="content in scrpLayer.contents">
        <p class="SCRPTableHeader">{{content.scrpGrade}}</p>
        <table class="SCRPTable">
          <tbody>
            <template v-for="listItem in content.scrpList">
            <tr v-for="(item, index) in listItem.items">
              <th :rowspan="listItem.items.length" v-if="index === 0"> {{listItem.scrpLevel}} </th>

              <td class="SCRPTable__SCRPItem">{{item.title}}</td>
              <td class="SCRPTable__SCRPDescription">{{item.desc}}</td>

              <td :rowspan="listItem.items.length" class="SCRPTable__check" v-if="index === 0">
                <label>
                  <input type="radio" name="scrp" hidden class="SCRPTable__radio" :value="listItem.scrpLevelNo" v-model="scrpLayer.selectedLevelNo" />
                  <span class="SCRPTable__radioBtn" @click="changeSCRPLevel(content, listItem)"></span>
                </label>
              </td>

            </tr>
            </template>
          </tbody>
        </table>
        </template>

        <!-- <div class="m_reqLayerBtns">
          <button class="m_reqLayerBtns__btn" @click="scrpLayer.el.close();">확인</button>
        </div> -->

      </div>

    </div>
  </div>

  <!-- guide  레이어 -->
  <div class="m_guideLayer [ _guideLayer _overLayer ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">

      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle [ _overLayer__title ]">안내사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText">
          보호자 동의서가 발송<br /> 되었습니다.
        </p>
        <p class="m_guideLayer__subText">
          보호자 동의가 완료되어야 참가신청 진행이 완료됩니다.
        </p>
        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn s_gray" @click="guideLayer.el.close();navGuideLayer.el.open();">확인</button>
        </div>
      </div>
    </div>
  </div>

  <!-- nav guide  레이어 -->
  <div class="m_guideLayer [ _navGuideLayer _overLayer ]">
    <div class="m_guideLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="m_guideLayer__contentWrap [ _overLayer__box ]">

      <div class="m_guideLayer__header">
        <h1 class="m_guideLayer__headerTitle [ _overLayer__title ]">안내사항</h1>
      </div>
      <div class="m_guideLayer__content [ _overLayer__wrap ]">

        <p class="m_guideLayer__mainText">
          종목 선택 및 추가페이지로 이동하시겠습니까?
        </p>
        <!-- <p class="m_guideLayer__subText">

        </p> -->
        <div class="m_guideLayerBtns">
          <button class="m_guideLayerBtns__btn s_gray" @click="navGuideLayer.el.close();">닫기</button>
          <a class="m_guideLayerBtns__btn" :href="'./eventStep1.asp?TitleIDX=' + qs.titleIdx + '&Title=' + qs.title">종목선택</a>
        </div>

      </div>
    </div>
  </div>

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>

  preload("http://img.sportsdiary.co.kr/images/SD/icon/check_on_s_@3x.png");


  function maxLengthCheck(object){
    if (object.value.length > object.maxLength){
      object.value = object.value.slice(0, object.maxLength);
    }
  }

  var vm = new Vue({
    mixins: [mixInLoader],
    el:'#app',
    data:{
      qs: {},
      applyOpenFg: false,
      scrpUseFg: false,
      scrpTitleName: '',

      memberInfo:{
        name: '-',
        gender: '',
        birth: '-',
        phoneNum: '-',
        adultYN: undefined,
      },

      originMoreInfo:{
        SCRP: undefined,
        bloodType: undefined,
        career: undefined,
        frame: undefined,
        gift: undefined,
        agree: undefined,
      },
      moreInfo:{
        scrp: '선택해주세요',
        bloodType: 'A',
        career: 0,
        careerOptions: [],
        frame: 0,
        frameOptions: [],
        gift: '2',
        giftOptions: [],
        agree: false,
      },

      scrpLayer: {
        el: {},
        contents: [],
        selectedLevel: '',
        selectedLevelNo: undefined,
        selectedGrade: '',
      },

      originParentInfo:{
        pName: undefined,
        pPhoneNum: undefined,
        pRelation: '부',
      },
      parentInfo:{
        parentInfoIdx: undefined,
        agree: false,
        name: '',
        phoneNum: '',
        phoneNum1: '010',
        phoneNum2: '',
        phoneNum3: '',
        relationship: '부',
        etcRelationship: '',
        etcRelationshipFg: false
      },

      guideLayer:{
        el:{}
      },
      navGuideLayer:{
        el:{}
      }
    },
    watch:{
      'parentInfo.phoneNum1': function(){
        this.parentInfo.phoneNum = this.parentInfo.phoneNum1 + '-' + this.parentInfo.phoneNum2 + '-' + this.parentInfo.phoneNum3;
      },
      'parentInfo.phoneNum2': function(){
        this.parentInfo.phoneNum = this.parentInfo.phoneNum1 + '-' + this.parentInfo.phoneNum2 + '-' + this.parentInfo.phoneNum3;
      },
      'parentInfo.phoneNum3': function(){
        this.parentInfo.phoneNum = this.parentInfo.phoneNum1 + '-' + this.parentInfo.phoneNum2 + '-' + this.parentInfo.phoneNum3;
      }
    },
    methods:{
      e_sendSMS: function(){
        return axios({
          url: '../ajax/Member/parent_text_send.asp',
          method: 'get',
          params: {
            parentInfoIdx: this.parentInfo.parentInfoIdx,
            memberIdx: this.qs.memberIdx,
            titleIdx: this.qs.titleIdx,
          }
        })
      },
      w_parentInfo: function(params){
        let parameter = (params) ? params : {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          parentInfoIdx: this.parentInfo.parentInfoIdx,
          pName: this.parentInfo.name,
          pPhonenum: (this.parentInfo.phoneNum2 && this.parentInfo.phoneNum3) ? this.parentInfo.phoneNum1 + '-' + this.parentInfo.phoneNum2 + '-' + this.parentInfo.phoneNum3 : undefined,
          pRelation: (this.parentInfo.relationship == '부' || this.parentInfo.relationship == '모') ? this.parentInfo.relationship : this.parentInfo.etcRelationship,
        }

        return axios({
          url: '../ajax/Member/parent_info_w.asp',
          method: 'post',
          params: parameter
        })
      },

      sendSMS: function(){
        let isValid = true;

        // + 보호자 정보 데이터 변경 확인
        let isUpdate = false;
        let parentInfoParams = {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          parentInfoIdx: this.parentInfo.parentInfoIdx,
          pName: this.parentInfo.name,
          pPhoneNum: this.parentInfo.phoneNum,
          pRelation: (this.parentInfo.relationship == '부' || this.parentInfo.relationship == '모') ? this.parentInfo.relationship : this.parentInfo.etcRelationship,
        }
        for(key in this.originParentInfo){
          if(this.originParentInfo[key] !== parentInfoParams[key]){ isUpdate = true; break; }
        }

        // + 보호자 정보 유효성 검사
        for(key in parentInfoParams){
          if(key === 'parentInfoIdx'){ continue; }
          if(!parentInfoParams[key]){ isValid = false; break; }
        }
        if(!isValid){alert('보호자 정보를 확인해주세요.');return;}
        let regPhone = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;
        if(!regPhone.test(parentInfoParams.pPhoneNum)){ alert('유효하지 않은 핸드폰 번호 입니다.'); return; }

        Promise.resolve(isUpdate)
        .then((isUpate)=>{
          if(!isUpdate) return; // + 보호자 정보 업데이트 없으면 then
          return this.w_parentInfo(parentInfoParams)
          .then(response=>{
            if(!response.data.return){
              if(response.data.message === '본인핸드폰'){
                alert('보호자 정보를 올바르게 입력하세요.(ex:본인 핸드폰 번호로 등록은 불가능합니다.)');
              }
              else if(response.data.message === '동의내역있음'){
                alert('이미 동의된 보호자 정보가 있어 수정이 불가합니다.')
              }
              else {
                alert('문제가 발생했습니다. 관리자에 문의하세요.')
              }
              throw new Error('error');
              return;
            }
            for(key in this.originParentInfo){ this.originParentInfo[key] = parentInfoParams[key]; }
          })
          .catch(error=>{ throw new Error(error) })
        })
        .then(()=>{
          this.e_sendSMS()
          .then(response=>{
            if(!response.data.return){throw new Error('error'); return;}
            this.guideLayer.el.open();
          })
          .catch(error=>{ throw new Error(error) })
        })
        .catch(error=>{
          console.log(error)
        })
      },

      changeSCRPLevel: function(content, item){
        this.scrpLayer.selectedGrade = content.scrpGrade;
        this.scrpLayer.selectedLevel = item.scrpLevel;
        this.scrpLayer.selectedLevelNo = item.scrpLevelNo;

        this.moreInfo.scrp = this.scrpLayer.selectedGrade + '/' + this.scrpLayer.selectedLevel;

        setTimeout(()=>{
          this.scrpLayer.el.close();
        }, 100);

      },

      changeParentReationship: function(value){
        if(value === '기타'){
          this.parentInfo.etcRelationshipFg = true;
        }
        else{
          this.parentInfo.etcRelationshipFg = false;
        }
      },

      next: function(){
        let isValid = true;

        // + 추가 정보 데이터 변경 확인
        let isMoreInfoUpdated = false;
        let moreInfoParams = {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          SCRP: this.scrpLayer.selectedLevelNo,
          bloodType: this.moreInfo.bloodType,
          career: this.moreInfo.career,
          frame: this.moreInfo.frame,
          gift: this.moreInfo.gift,
          agree: (this.moreInfo.agree) ? 'Y' : 'N'
        }
        for(key in this.originMoreInfo){
          if(this.originMoreInfo[key] !== moreInfoParams[key]){ isMoreInfoUpdated = true; break; }
        };


        // + 보호자 정보 데이터 변경 확인
        let isParentInfoUpdated = false;
        let parentInfoParams = {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
          parentInfoIdx: this.parentInfo.parentInfoIdx,
          pName: this.parentInfo.name,
          pPhoneNum: this.parentInfo.phoneNum,
          pRelation: (this.parentInfo.relationship == '부' || this.parentInfo.relationship == '모') ? this.parentInfo.relationship : this.parentInfo.etcRelationship,
        }

        for(key in this.originParentInfo){
          if(this.originParentInfo[key] !== parentInfoParams[key]){ isParentInfoUpdated = true; break; }
        }

        // + 추가정보 유효성 검사
        for(key in moreInfoParams){ if(!moreInfoParams[key]){ isValid = false; break; }}
        if(!isValid){alert('모든 항목을 입력해주세요.');return;}

        // + 보호자 정보 유효성 검사
        for(key in parentInfoParams){
          if(key === 'parentInfoIdx'){ continue; }
          if(!parentInfoParams[key]){ isValid = false; break; }
        }
        if(!isValid){alert('보호자 정보를 확인해주세요.');return;}
        let regPhone = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;
        if(!regPhone.test(parentInfoParams.pPhoneNum)){ alert('유효하지 않은 핸드폰 번호 입니다.'); return; }

        // + 추가정보 유효성 검사
        if(!this.moreInfo.agree){alert('서약서동의를 하셔야 신청자 등록이 진행됩니다.');return;}


        Promise.resolve()
        // + 추가 정보 저장
        .then(()=>{
          if(!isMoreInfoUpdated) return; // + 추가정보 데이터 변경 없을시 then

          return axios({
            url: '../ajax/Member/Additional_info_W.asp',
            methods: 'post',
            params: moreInfoParams
          })
          .then(response=>{
            if(!response.data.return){throw new Error('error');}
            for(key in this.originMoreInfo){ this.originMoreInfo[key] = moreInfoParams[key] };
          })
          .catch(error=>{ throw new Error('error') })

        })
        // + 보호자 정보 저장
        .then(()=>{
          if(!isParentInfoUpdated) return; // + 보호자정보 데이터 변경 없을시 then

          return this.w_parentInfo(parentInfoParams)
          .then(response=>{
            if(!response.data.return){
              if(response.data.message === '본인핸드폰'){
                alert('보호자 정보를 올바르게 입력하세요.(ex:본인 핸드폰 번호로 등록은 불가능합니다.)');
              }
              else if(response.data.message === '동의내역있음'){
                alert('이미 동의된 보호자 정보가 있어 수정이 불가합니다.')
              }
              else {
                alert('문제가 발생했습니다. 관리자에 문의하세요.')
              }
              throw new Error('error');
              return;
            }
            if(!this.parentInfo.parentInfoIdx){
              this.parentInfo.parentInfoIdx = response.data.parentInfoIdx;
              // !@# 확인 parentINfoParams 와 this.parentInfo 참조 관계
              parentInfoParams.parentInfoIdx = response.data.parentInfoIdx;
            }
            for(key in this.originParentInfo){ this.originParentInfo[key] = parentInfoParams[key]; }
          })
          .catch(error=>{ console.log(error); throw new Error('error'); })

        })
        // + 보호자 동의 문자 발송
        .then(()=>{
          if(
            this.memberInfo.adultYN || // + 성인이면 then
            this.parentInfo.agree || // + 보호자 동의 완료면 then
            !isParentInfoUpdated // + 보호자 정보 데이터 변겅 없으면 then
          ) return true;

          return this.e_sendSMS()
          .then(response=>{
            if(!response.data.return){throw new Error('error');}
            this.guideLayer.el.open();
            return false;
          })
          .catch(error=>{ throw new Error('error'); });
        })
        // + 보호자 문자 발송 팝업
        .then(isOpen=>{
          if(isOpen){ this.navGuideLayer.el.open(); }
        })
        .catch(error=>{
          console.log('error');
        })
      },
    },
    created(){
      this.qs.memberIdx = <%=MemberIDX%>
      this.qs.titleIdx = <%=TitleIDX%>
      this.qs.title = '<%=Title%>'

      axios({
        url:'../ajax/member/additional_info_option_R.asp',
        method:'get',
        params:{
          titleIdx: this.qs.titleIdx
        }
      })
      .then(response=>{
        if(response.data.CAREER.length !== 0) this.moreInfo.careerOptions = response.data.CAREER;
        if(response.data.BRAND.length !== 0) this.moreInfo.frameOptions = response.data.BRAND;
        if(response.data.gift.length !== 0) this.moreInfo.giftOptions = response.data.gift;
      })
      .then(()=>{
        axios.all([
          axios({
            url:'../ajax/title/detail_R.asp',
            method:'get',
            params:{
              titleIdx: this.qs.titleIdx,
            }
          }),
          axios({
            url:'../ajax/member/SCRP_Table_R.asp',
            method:'get',
            params:{
              titleIdx: this.qs.titleIdx,
              memberidx: this.qs.memberIdx
            }
          }),
          axios({
            url:'../ajax/member/info_r.asp',
            method:'get',
            params:{
              titleIdx: this.qs.titleIdx,
              memberidx: this.qs.memberIdx
            }
          })
        ])
        .then(
          axios.spread((resCompetitionInfo, resSCRP, resInfo)=>{
            this.applyOpenFg = (resCompetitionInfo.data.applyOpen == 'Y') ? true : false;

            // + scrp 수정 조건
            if(
              this.applyOpenFg && // + 참가신청 가능
              (
                resInfo.data.SCRPInfo.length == 0 || // + scrp 이력 존재하지 않거나
                resInfo.data.SCRPInfo[0].titleIdx === this.qs.titleIdx // + scrp 이력이 현(첫) 대회 일경우
              )
            ) this.scrpUseFg = true;

            // 현대회 신청자 정보가 없으면 이전 대회 정보 불러와서 바인딩
            let resMoreInfo = resInfo.data.moreInfo[0] || {};
            this.originMoreInfo.SCRP = resMoreInfo.scrpLevelNo || this.originMoreInfo.SCRP;
            this.originMoreInfo.bloodType = resMoreInfo.blood || this.originMoreInfo.blood;
            this.originMoreInfo.career = resMoreInfo.career || this.originMoreInfo.career;
            this.originMoreInfo.frame = resMoreInfo.frame || this.originMoreInfo.frame;
            this.originMoreInfo.gift = (resMoreInfo.gift) ? resMoreInfo.gift[0] : this.originMoreInfo.career;
            this.originMoreInfo.agree = resMoreInfo.agree  || this.originMoreInfo.agree;

            let resParentInfo = resInfo.data.parentInfo[0] || {};
            this.originParentInfo.pName = resParentInfo.name || this.originParentInfo.name;
            this.originParentInfo.pPhoneNum = resParentInfo.phoneNum || this.originParentInfo.phoneNum;
            this.originParentInfo.pRelation = resParentInfo.relationship || this.originParentInfo.relationship;

            Promise.resolve()
            .then(()=>{
              if(resInfo.data.moreInfo.length !== 0) return resInfo

              return axios({
                url: '../ajax/member/info_latest_R.asp',
                method: 'get',
                params: {
                  memberIdx: this.qs.memberIdx
                }
              })
              .then(response=>{
                return response;
              })

            })
            .then(resInfo=>{
              if(resSCRP.data.scrp.length !== 0) this.scrpLayer.contents = resSCRP.data.scrp;

              // + 회원정보
              let resMemberInfo = resInfo.data.memberInfo;
              if(resMemberInfo.length !== 0){
                this.memberInfo.name = resMemberInfo[0].name;
                this.memberInfo.birth = resMemberInfo[0].birth;
                this.memberInfo.gender = '(' + resMemberInfo[0].gender + ')';
                this.memberInfo.phoneNum = resMemberInfo[0].phoneNum;
                this.memberInfo.adultYN = (resMemberInfo[0].adultYN == 'Y') ? true : false ;
              }

              // + 추가정보
              let resMoreInfo = resInfo.data.moreInfo;
              if(resMoreInfo.length !== 0){

                this.moreInfo.bloodType = resMoreInfo[0].blood;
                this.moreInfo.career = resMoreInfo[0].career;
                this.moreInfo.frame = resMoreInfo[0].frame;
                this.moreInfo.gift = resMoreInfo[0].gift[0];
                this.moreInfo.agree = (resMoreInfo[0].agree === 'Y') ? true : false;

                this.scrpLayer.selectedLevelNo = resMoreInfo[0].scrpLevelNo;
                this.scrpLayer.selectedLevel = resMoreInfo[0].scrpLevel;
                this.scrpLayer.selectedGrade = resMoreInfo[0].scrpGrade;

                if(this.scrpLayer.selectedGrade && this.scrpLayer.selectedLevel) this.moreInfo.scrp = this.scrpLayer.selectedGrade + '/' + this.scrpLayer.selectedLevel;
                else this.moreInfo.scrp = '선택해주세요';


              }

              // + 보호자정보
              let resParentInfo = resInfo.data.parentInfo;
              if(resParentInfo.length !== 0){
                this.parentInfo.agree = (resParentInfo[0].agree === 'Y') ? true : false;
                this.parentInfo.parentInfoIdx = resParentInfo[0].parentInfoIdx;
                this.parentInfo.name = resParentInfo[0].name;
                let phone = resParentInfo[0].phoneNum.split('-');
                this.parentInfo.phoneNum1 = phone[0];
                this.parentInfo.phoneNum2 = phone[1];
                this.parentInfo.phoneNum3 = phone[2];
                this.parentInfo.relationship = resParentInfo[0].relationship;

                if(resParentInfo[0].relationship == '부'|| resParentInfo[0].relationship == '모')
                  this.parentInfo.relationship = resParentInfo[0].relationship
                else{
                  this.parentInfo.etcRelationshipFg = true;
                  this.parentInfo.relationship = '기타';
                  this.parentInfo.etcRelationship = resParentInfo[0].relationship;
                }
              }
            })



          })
        )
      })
    },
    mounted(){

      this.scrpLayer.el = new OverLayer({
        overLayer: $('._scrpLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      // this.scrpLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.scrpLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});

      this.guideLayer.el = new OverLayer({
        overLayer: $('._guideLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      })
      // this.guideLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.guideLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});

      this.navGuideLayer.el = new OverLayer({
        overLayer: $('._navGuideLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      })
      // this.navGuideLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.navGuideLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});


      <%
        a = request.Cookies("a")
        If a <> "" then
      %>
        if(/iPhone|iPad|iPod/i.test(navigator.userAgent)){
          $("._content").on('focus', 'input, select', function(){ $(".l_header").css("position", "absolute") });
          $("._content").on('blur', 'input, select', function(){ $(".l_header").css("position", "fixed") });
        }
      <%End If%>
    },
  })
</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
