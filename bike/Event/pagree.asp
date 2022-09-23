<!-- #include virtual = "/pub/header.bike.asp" -->

<%
  p = ucase(request("p"))
  If p = "" Then response.end
  dp = decode(p, 0)
  MemberIDX = split(dp,",")(1)
  TitleIDX = split(dp,",")(2)


%>


<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../tsm_player/include/head.asp" -->

  <style>
    body{font-family:'NotoKR', sans-serif;}
    button{font-family: inherit;}
    pre{font-family:inherit;}
    input[disabled]{background-color:#fff;background-color:transparent;color:#333;-webkit-opacity:1;}
    [v-clock]{display:none;}

    .m_termText{font-size:1rem;margin:1rem 1.43rem 0.71rem 1.43rem;line-height:1.43rem;color:#999999;}

    .m_subTitle{overflow:hidden;color:#fff;background-color:#005895;}
    .m_subTitle__title{margin:0.71rem 0;font-size:1.14rem;text-align:center;line-height:1.79rem;letter-spacing:0.02em;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:400;}

    .m_bottomBtns{margin:1.43rem;display:flex;}
    .m_bottomBtns__btn{width:100%;height:3.57rem;border-radius:0.21rem;font-size:1rem;line-height:3.57rem;background-color:#005895;color:#fff;border:0;}
    .m_bottomBtns__btn.s_gray{background-color:#eee;color:#444;}
    .m_bottomBtns__btn.s_more{background-color:#B7BEC3;color:#fff;}
    .m_bottomBtns__btn+.m_bottomBtns__btn{margin-left:0.71rem;}

    .m_formTitle{position:relative;padding:0 1.43rem;height:2.86rem;font-size:1.14rem;line-height:2.86rem;letter-spacing:-0.02em;color:#666;background-color:#f2f2f2;}
    .m_formTitle+.m_formItem{margin-top:0.29rem;}
    .m_formItem+.m_formTitle{margin-top:0.71rem;}
    .m_formTitle__subText{float:right;font-size:1rem;color:#999;font-weight:400;}

    .m_formItem{position:relative;margin:0 1.43rem;border-bottom:0.07rem solid #eee;}
    .m_formItem.s_pointBorder{border-bottom:0.07rem solid #005895;}

    .m_formItem__label{position:relative;display:block;height:2.86rem;line-height:3.57rem;color:#666;font-size:1.14rem;}
    .m_formItem__labelBtn{position:absolute;width:1.5rem;height:1.5rem;right:0;top:0;bottom:0;margin:auto;border-radius:50%;border:0;font-size:0;}
    .m_formItem__labelBtn.s_subtract{background:url('http://img.sportsdiary.co.kr/images/SD/icon/minus_circle_@3x.png') no-repeat center/100%;}

    .m_formItem__text{font-size:1.14rem;color:#333;line-height:2.86rem;}
    .m_formItem__text.s_gray{color:#666;}
    .m_formItem__text.s_divider::after{content:'';display:inline-block;width:0.07rem;height:0.86rem;background-color:#aaa;margin:0 0.71rem;}
    .m_formItem__text.s_subLabel{display:inline-block;color:#aaa;min-width:5rem;margin-right:1.43rem;padding-left:0.71rem;box-sizing:border-box;}

    .m_formItem__inner{display:flex;align-items:center;margin:0.71rem 0;}
    .m_formItem__inner.s_low{margin:0.36rem 0;}
    .m_formItem__inner.s_highlow{margin:0;}
    .m_formItem__btn{display:inline-block;flex-shrink:0;height:2rem;margin-left:auto;padding:0.29rem 0.71rem;border:0;border-radius:0.21rem;background-color:#aaa;color:#fff;font-size:1rem;line-height:1.43rem;font-weight:500;}

    .m_formItem__select{width:100%;height:2rem;padding-top:0.43rem;box-sizing:border-box;border:0;color:#333333;font-size:1.14rem;background:url('http://img.sportsdiary.co.kr/images/SD/icon/arrow_drop_down_solid_@3x.png') no-repeat right center/0.71rem 0.36rem;}
    .m_formItem__input{width:100%;height:2rem;padding-top:0.43rem;box-sizing:border-box;border:0;font-size:1.14rem;color:#333;}

    .m_formCheck{position:relative;display:block;font-size:0;text-align:right;}
    .m_formCheck+.m_formCheck{margin-top:0.86rem;}
    .m_formCheck__checkWrap{position:absolute;display:inline-block;width:2.29rem;height:2.29rem;left:0;top:0;bottom:0;margin:auto;}
    .m_formCheck__checkbox+.m_formCheck__button{display:inline-block;width:100%;height:100%;background:url('http://img.sportsdiary.co.kr/images/SD/icon/check_off_s_@3x.png') no-repeat center/100%;}
    .m_formCheck__checkbox:checked+.m_formCheck__button{background:url('http://img.sportsdiary.co.kr/images/SD/icon/check_on_s_@3x.png') no-repeat center/100%;}
    .m_formCheck__text{display:inline-block;width:calc(100% - 2.29rem);box-sizing:border-box;padding-left:0.57rem;font-size:1.14rem;text-align:left;color:#333;line-height:3.71rem;}

    .m_reqLayer{}
    .m_reqLayer__inner{box-sizing:border-box;}
    .m_reqLayer__header{position:relative;height:2.86rem;margin:0.71rem 0.71rem 0 0.71rem;background-color:#005895;color:#fff;text-align:center;}
    .m_reqLayer__headerTitle{line-height:2.86rem;font-size:1.14rem;font-weight:500;}
    .m_reqLayer__headerClose{position:absolute;width:2.86rem;height:2.86rem;top:0;right:0;border:0;font-size:0;background:url('http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png') no-repeat center/1rem;}
    .m_reqLayer__content{background-color:#fff;margin:0 0.71rem 0.71rem 0.71rem;max-height:calc(100vh - 4.29rem);}

    .m_reqLayerBtns{display:flex;height:4.64rem;background-color:#fff;justify-content:center;}
    .m_reqLayerBtns__btn{width:8.57rem;height:2.5rem;margin:1.07rem 0;border-radius:0.21rem;border:0;color:#fff;background-color:#005895;}
    .m_reqLayerBtns__btn+.m_reqLayerBtns__btn{margin-left:0.36rem;}
    .m_reqLayerBtns__btn.s_gray{background-color:#aaa;color:#fff;}

  </style>
</head>
<body>
<div id="app" class="l">

  <div class="l_header">
    <div class="m_header s_sub">
      <h1 class="m_header__tit">보호자 동의</h1>
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_subTitle">
      <h2 class="m_subTitle__title">{{titleInfo.title}}</h2>
    </div>

    <div>
      <h3 class="m_formTitle">대회정보</h3>
      <div class="m_formItem s_pointBorder">
        <p class="m_formItem__inner s_highlow">
          <span class="m_formItem__text s_gray s_divider">{{titleInfo.place}}</span><span class="m_formItem__text s_gray">{{titleDuration}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_highlow">
          <span class="m_formItem__text s_subLabel">참가자명</span><span class="m_formItem__text">{{memberInfo.name}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_highlow">
          <span class="m_formItem__text s_subLabel">생년월일</span><span class="m_formItem__text">{{memberInfo.birth}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_highlow">
          <span class="m_formItem__text s_subLabel">성별</span><span class="m_formItem__text">{{memberGender}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_highlow">
          <span class="m_formItem__text s_subLabel">신청등급</span><span class="m_formItem__text">{{moreScrp}}</span>
        </p>
      </div>


      <h3 class="m_formTitle">서약서</h3>
      <P class="m_termText">
        상기 보호자는 SD 랭킹 Cycle Championship 에 참가함에 있어 주최 측의 경기규칙을 준수하고, 경기 중 발생할 수 있는 부상의 위험을 인지하고, 대회 중 일어난 사고 및 장비파손과 분실 등 물적, 인적 피해에 대한 책임은 전적으로 본인에게 있음을 동의하며, 보호자 동의 서약서 내용 본 대회에 참가를 허락합니다.
      </P>
      <h3 class="m_formTitle">보호자 정보</h3>
      <div class="m_formItem">
        <p class="m_formItem__inner s_low">
          <span class="m_formItem__text">{{parentInfo.name}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_low">
          <span class="m_formItem__text">{{parentInfo.relationship}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__inner s_low">
          <span class="m_formItem__text">{{parentInfo.phoneNum}}</span>
        </p>
      </div>
      <div class="m_formItem">
        <p class="m_formItem__label">보호자(동의인 주소)</p>
        <div class="m_formItem__inner" @click.prevent="openLayer" >
          <input type="text" placeholder="우편번호" class="m_formItem__input" v-model="parentInfo.postcode" disabled />
          <button class="m_formItem__btn" >주소찾기</button>
        </div>
      </div>
      <div class="m_formItem">
        <div class="m_formItem__inner">
          <input type="text" placeholder="기본주소" class="m_formItem__input" v-model="parentInfo.addr" disabled />
        </div>
      </div>
      <div class="m_formItem">
        <div class="m_formItem__inner">
          <input type="text" placeholder="나머지주소" class="m_formItem__input" v-model="parentInfo.addrDtl"/>
        </div>
      </div>

      <div class="m_formItem">
        <p class="m_formItem__label">생년월일</p>
        <div class="m_formItem__inner">
          <input type="text" placeholder="생년월일 8자리를 입력하세요." class="m_formItem__input" v-model="parentInfo.birth" />
        </div>
      </div>

      <h3 class="m_formTitle">개인정보취급방침 동의</h3>
      <div class="m_formItem">
        <label class="m_formCheck">
          <div class="m_formCheck__checkWrap"><input type="checkbox" class="m_formCheck__checkbox" hidden v-model="parentInfo.agree" /><span class="m_formCheck__button"></span></div>
          <p class="m_formCheck__text">하기 안내사항에 동의합니다.</p>
        </label>
      </div>

      <div class="m_termText" style="height:150px;overflow-y:scroll;">
        <pre style="white-space:pre-line;">
          회사는 개인정보처리방침을 통하여 이용자들이 제공하는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려 드리고 있으며 개인정보처리방침을 홈페이지 첫 화면에 공개함으로써 이용자들이 언제나 용이하게 보실 수 있도록 조치하고 있습니다.
          회사의 개인정보처리방침은 정부의 법률 및 지침 변경이나 회사의 내부 방침 변경 등으로 인하여 수시로 변경될 수 있고, 이에 따른 개인정보처리방침의 지속적인 개선을 위하여 필요한 절차를 정하고 있습니다. 그리고 개인정보처리방침을 개정하는 경우나 개인정보처리방침 변경될 경우 홈페이지 및 앱의 게시판 공지를 통해 고지하고 있습니다.
          회사의 개인정보처리방침은 다음과 같은 내용을 담고 있습니다.

          1. 개인정보 수집에 대한 동의
          2. 개인정보의 수집목적 및 이용목적
          3. 수집하는 개인정보 항목 및 수집방법
          4. 수집하는 개인정보의 보유 및 이용기간
          5. 수집한 개인정보의 공유 및 제공
          6. 이용자 자신의 개인정보 관리(열람, 정정, 삭제 등)에 관한 사항
          7. 쿠키(cookie)의 운영에 관한 사항
          8. 개인정보관련 의견수렴 및 불만처리에 관한 사항
          9. 개인정보 관리책임자 및 담당자의 소속-성명 및 연락처
          10. 고지의 의무

          1. 개인정보 수집에 대한 동의
          스포츠다이어리 이용자들이 회사의 개인정보처리방침 또는 이용약관의 내용에 대하여 「동의」버튼 또는「취소」버튼을 클릭할 수 있는 절차를 마련하여, 「동의」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.

          2. 개인정보의 수집목적 및 이용목적
          "개인정보"라 함은 생존하는 개인에 관한 정보로서 당해 정보에 포함되어 있는 성명, 주민등록번호 등의 사항에 의하여 당해 개인을 식별할 수 있는 정보(당해 정보만으로는 특정 개인을 식별할 수 없더라도 다른 정보와 용이하게 결합하여 식별할 수 있는 것을 포함)를 말합니다.
          회사는 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전 동의를 구할 예정입니다. 회사는 이용자의 사전 동의 없이는 이용자의 개인 정보를 공개하지 않으며, 종목간의 회원정보 보완에 있어서도 공개되지 않습니다. 수집된 정보는 만 19세미만 미성년자 개인정보 수집 시 법정대리인 동의 여부 확인, 각종 고지·통지 등을 목적으로 개인정보를 처리합니다. 자세한 내용은 아래와 같이 이용하고 있습니다.
          가)	첫째, 만 19세미만 미성년자 개인정보 수집 시 보호자 동의 여부 확인, 각종 고지·통지 등을 목적으로 개인
          정보를 처리합니다.

          회사는 스포츠다이어리 내 참가신청을 진행할 시 만 19세미만 미성년자의 보호자 동의 여부 확인의 목적으로 개인정보를 수집하며, 이는 원활한 대회 진행을 제공하기 위함입니다.
          나)	둘째, 수집하는 개인정보 항목과 수집 및 이용목적은 다음과 같습니다.
          ①	성명, 생년월일, 주소, 참가자와의 관계 : 대회 참가신청에 따른 이용자 식별 및 서비스 제공, 대회정보 등의 안내, 동의여부확인, 각종 고지, 통지 등을 목적으로 개인정보를 처리합니다.
          ②	신원 확인, 사실조사를 위한 연락·통지 등을 목적으로 개인정보를 처리합니다.
          ③	서비스 제공, 콘텐츠 제공, 맞춤 서비스 제공, 본인인증, 연령인증 등을 목적으로 개인정보를 처리합니다.
          ④	IP Address, 쿠키, 방문일시, 동의 기록 : 보호자동의 여부 확인 목적

          3. 수집하는 개인정보 항목 및 수집방법
          가)	대회 참가신청서 작성페이지 및 보호자동의서 작성페이지
          나)	서비스 이용과정이나 사업처리 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집 될 수 있습니다.
          ①	IP주소, 방문일시, 서비스이용기록 : 부정이용방지, 비인가 사용방지, 통계작성 등
          다)	이용자의 기본적 인권 침해의 우려가 있는 민감한 개인정보(인종 및 민족, 사상 및 신조, 출신지 및 본적지, 정치적 성향 및 범죄기록, 건강상태 및 성생활 등)는 수집하지 않으며 부득이하게 수집해야 할 경우 이용자들의 사전 동의를 반드시 구할 것입니다. 그리고, 어떤 경우에라도 입력하신 정보를 이용자들에게 사전에 밝힌 목적 이외에 다른 목적으로는 사용하지 않으며 외부로 유출하지 않습니다.
          라)	일시적인 목적 (설문조사, 이벤트, 본인확인 등)으로 입력 받은 개인정보는 그 목적이 달성된 이후에는 동일한 방법으로 사후 재생이 불가능한 상태로 처리됩니다.

          4. 수집하는 개인정보의 보유 및 이용기간
          스포츠다이어리 내 진행하는 대회의 참가신청자의 보호자로서 참가신청자가 서비스를 이용하는 동안 회사는 이용자 및 보호자의 개인정보를 계속적으로 보유하며 서비스 제공 등을 위해 이용합니다. 다만, 아래의 "6. 이용자 자신의 개인정보관리(열람, 정정, 삭제 등)에 관한 사항" 에서 설명한 절차와 방법에 따라 본인이 직접 삭제하거나 수정한 정보, 삭제를 요청한 경우에는 재생할 수 없는 방법에 의하여 디스크에서 완전히 삭제하며 추후 열람이나 이용이 불가능한 상태로 처리됩니다.
          그리고 "3. 수집하는 개인정보 항목 및 수집방법"에서와 같이 일시적인 목적 (설문조사, 이벤트, 본인확인 등)으로 입력 받은 개인정보는 그 목적이 달성된 이후에는 동일한 방법으로 사후 재생이 불가능한 상태로 처리됩니다.
          귀하의 개인정보는 다음과 같이 개인정보의 수집목적 또는 제공받은 목적이 달성되면 파기하는 것을 원칙으로 합니다. 다만, 회사는 대회 개최 및 개최 이후 위급한 상황을 대비하기 위해, 이용계약 해지일로부터 1년간 입력된 주민등록번호를 보유할 수 있습니다.
          그리고 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.
          가)	계약 또는 청약철회 등에 관한 기록
          ①	보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제6조 및 시행령 제6조
          ②	보존기간 : 5년
          나)	대금결제 및 재화 등의 공급에 관한 기록
          ①	 보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제6조 및 시행령 제6조
          ②	 보존기간 : 5년
          다) 소비자의 불만 또는 분쟁처리에 관한 기록
          ①	보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제6조 및 시행령 제6조
          ②	보존기간 : 3년
          라) 신용정보의 수집, 처리 및 이용 등에 관한 기록
          ①	보존근거 : 신용정보의 이용 및 보호에 관한 법률
          ②	보존기간 : 3년
          마) 접속에 관한 기록보존
          ①	보존근거 : 통신비밀보호법 제15조의2 및 시행령 제41조
          ②	보존기간 : 3개월
          바) 회사는 귀중한 회원의 개인정보를 안전하게 처리하며, 유출의 방지를 위하여 다음과 같은 방법을 통하여 개인정보를 파기합니다.
          ①	종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.
          ②	전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.

          5. 수집한 개인정보의 공유 및 제공
          회사는 이용자들의 개인정보를 "2. 개인정보의 수집목적 및 이용목적"에서 고지한 범위 내에서 사용하며, 이용자의 사전 동의 없이는 동 범위를 초과하여 이용하거나 원칙적으로 이용자의 개인정보를 외부에 공개하지 않습니다. 다만, 회사는 다음과 같은 목적으로 개인정보를 제3자에게 제공 및 활용할 수 있습니다. 제공하는 정보는 당해 목적을 달성하기 위하여 필요한 최소한의 정보에 국한됩니다.
          가)	“SD몰” 회원제 서비스 이용 및 주문상품 배송, 광고 및 마케팅 활용에 필요한 경우
          나)	이용자들이 사전에 공개에 동의한 경우
          다)	서비스 제공에 따른 요금정산을 위하여 필요한 경우
          라)	홈페이지 및 모바일에 게시한 서비스 이용 약관 및 기타 회원 서비스 등의 이용약관 또는 운영원칙을 위반한 경우
          마)	자사 서비스를 이용하여 타인에게 정신적, 물질적 피해를 줌으로써 그에 대한 법적인 조치를 취하기 위하여
          바)	개인정보를 공개해야 한다고 판단되는 충분한 근거가 있는 경우
          사)	기타 법에 의해 요구된다고 선의로 판단되는 경우 (ex. 관련법에 의거 적법한 절차에 의한 정부/수사기관의 요청이 있는 경우 등)
          아)	통계작성, 학술연구나 시장조사를 위하여 특정 개인을 식별할 수 없는 형태로 광고주, 협력업체나 연구단체 등에 제공하는 경우
          자)	이용자의 서비스 이용에 따른 불만사항 및 문의사항(민원사항)의 처리를 위하여 고객센터를 위탁하는 경우
          차)	고객센터를 운영하는 전문 업체에 해당 민원사항의 처리에 필요한 개인 정보를 제공하는 경우
          카)	대회 참가신청에 대한 미성년자 보호자 동의여부를 확인 및 제공해야하는 경우

          6. 이용자 자신의 개인정보 관리(열람, 정정, 삭제 등)에 관한 사항
          가)	처리한 개인정보를 당사자가 원할 경우 언제라도 당사에서 개인정보를 확인요청 하실 수 있으며 보관된 필수 정보를 수정하실 수 있습니다.
          나)	또한 요구된 입력 정보는 언제나 수정, 삭제할 수 있습니다.
          다)	본인의 개인정보 변경 및 삭제는 스포츠다이어리 고객센터를 통하여 처리하실 수 있습니다.

          7. 쿠키(cookie)의 운영에 관한 사항
          당사는 회원인증을 위하여 Cookie 방식을 이용하고 있습니다. 이는 로그아웃(Logout)시 자동으로 컴퓨터에 저장되지 않고 삭제되도록 되어 있으므로 공공장소나 타인이 사용할 수 있는 컴퓨터를 사용 하 실 경우에는 로그인(Login)후 서비스 이용이 끝나시면 반드시 로그아웃(Logout)해 주시기 바랍니다.
          가)	쿠키 설정 거부 방법
          쿠키 설정을 거부하는 방법으로는 회원님이 사용하시는 웹 브라우저의 옵션을 선택함으로써 모든 쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의 저장을 거부할 수 있습니다.
          설정방법 예(인터넷 익스플로어의 경우) : 웹 브라우저 상단의 도구 &gt; 인터넷 옵션 &gt; 개인정보
          단, 귀하께서 쿠키 설치를 거부하였을 경우 서비스 제공에 어려움이 있을 수 있습니다.

          8. 개인정보관련 의견수렴 및 불만처리에 관한 사항
          당사는 개인정보보호와 관련하여 이용자 여러분들의 의견을 수렴하고 있으며 불만을 처리하기 위하여 모든 절차와 방법을 마련하고 있습니다. 이용자들은 하단에 명시한 "11. 개인정보관리책임자 및 담당자의 소속-성명 및 연락처"항을 참고하여 전화나 메일을 통하여 불만사항을 신고 할 수 있고, 회사는 이용자들의 신고사항에 대하여 신속하고도 충분한 답변을 해드릴 것입니다.

          9. 개인정보 관리책임자 및 담당자의 소속-성명 및 연락처
          당사는 귀하가 좋은 정보를 안전하게 이용할 수 있도록 최선을 다하고 있습니다. 개인정보를 보호하는데 있어 귀하께 고지한 사항들에 반하는 사고가 발생할 경우 개인정보관리책임자가 책임을 집니다.
          가)	이용자 개인정보와 관련한 아이디(ID)의 비밀번호에 대한 보안유지책임은 해당 이용자 자신에게 있습니다.
          나)	회사는 비밀번호에 대해 어떠한 방법으로도 이용자에게 직접적으로 질문하는 경우는 없으므로 타인에게 비밀번호가 유출되지 않도록 각별히 주의하시기 바랍니다.
          다)	특히 공공장소에서 온라인상에서 접속해 있을 경우에는 더욱 유의하셔야 합니다.
          라)	회사는 개인정보에 대한 의견수렴 및 불만처리를 담당하는 개인정보 관리책임자 및 담당자를 지정하고 있고, 연락처는 아래와 같습니다.
          개인정보관리 책임자
          이름 : 백승훈
          소속/직위 : 전산팀 / 소장
          E-MAIL : online@widline.co.kr
          전화번호 : 02-715-0282

          10. 고지의 의무
          본 개인정보처리방침은 정부의 정책 또는 보안기술의 변경에 따라 개인정보취급방침 내용 추가, 삭제 및 수정이 있을 시에는 개정 최소 7일전부터 개정 최소 7일전부터 홈페이지 또는 모바일을 통해 고지하도록 하겠습니다.
          가)	개인정보취급방침 버전번호 : SD-18.07
          나)	개인정보취급방침 시행일자 : 2018년 07월 20일

        </pre>
      </div>
    </div>

    <div class="m_bottomBtns">
      <button class="m_bottomBtns__btn s_gray" @click="guideAlert" v-if="!isValid">보호자 동의 확인</button>
      <button class="m_bottomBtns__btn" @click="confirm" v-else>보호자 동의 확인</button>
    </div>
  </div>

  <div class="m_reqLayer [ _overLayer _postLayer ]">
    <div class=" [ _overLayer__backdrop ]"></div>
    <div class="m_reqLayer__contWrap [ _overLayer__box ]">
      <div class="m_reqLayer__header">
        <h1 class="m_reqLayer__headerTitle [ _overLayer__title ]">우편번호찾기</h1>
        <button class="m_reqLayer__headerClose" @click="postLayer.el.close();">닫기</button>
      </div>
      <div class="m_reqLayer__content [ _overLayer__wrap ]" >
        <div id="wrap">
          <!-- 다음검색 주소  -->
        </div>
      </div>
    </div>
  </div>

</div>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
  var vm = new Vue({
    el: '#app',
    data: {
      qs: {},
      postLayer: {
        el:{}
      },
      memberInfo:{
        name: '',
        birth: '',
        gender: '',
      },
      moreInfo:{
        scrpGrade: '',
        scrpLevel: ''
      },
      parentInfo: {
        name: '',
        phoneNum: '',
        relationship: '',
        postcode: '',
        addr: '',
        addrDtl: '',
        birth: '',
        agree: false
      },
      titleInfo: {
        title: '',
        place: '',
        startDate: '',
        endDate: '',
      },

    },
    computed: {
      moreScrp: function(){
        return (this.moreInfo.scrpGrade && this.moreInfo.scrpLevel) ? this.moreInfo.scrpGrade + ' / ' + this.moreInfo.scrpLevel : '';
      },
      memberGender: function(){
        return (this.memberInfo.gender == 'Man') ? '남자' : '여자';
      },
      titleDuration: function(){
        let duration = this.titleInfo.startDate.replace(/-/g, '.');
        duration += ' ~ ';
        duration += (this.titleInfo.startDate.substr(0, 4) == this.titleInfo.endDate.substr(0, 4))
        ? this.titleInfo.endDate.substring(5).replace(/-/g, '.')
        : this.titleInfo.endDate.replace(/-/g, '.');
        return duration
      },
      isValid: function(){
        return !( !this.parentInfo.postcode || !this.parentInfo.addr || !this.isDateFormat(this.parentInfo.birth) || !this.parentInfo.agree );
      }
    },
    methods: {
      selectAddr: function(address){
        this.postLayer.el.close();
        this.parentInfo.postcode = address.postcode;
        this.parentInfo.addr = address.addr;
      },
      openLayer: function(){
        this.postLayer.el.open();

        // 우편번호 찾기 화면// 우편번호 찾기 화면
        var element_wrap = document.getElementById('wrap');
        (function execDaumPostcode(Callback){
          // 현재 scroll 위치 저장
          // let currentScroll=Math.max(document.body.scrollTop, document.documentElement.scrollTop);
          // document.body.scrollTop=document.documentElement.scrollTop=0;

          new daum.Postcode({
            oncomplete:function(data){
              // 검색결과 항목을 클릭했을 때 실행할 코드를 작성하는 부분

              // 각 주소의 노출 규칙에 따라 주소를 조합
              // 내려오는 변수가 값이 없는 경우엔 공백("")값을 가지므로, 이를 참고하기 분기
              let addr='',// 최종 주소
                  extraAddr='',
                  returnData= {}// 조합형 주소

              if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
              } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
              }

              // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
              if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                returnData.extraAddr = extraAddr
                // document.getElementById("sample6_extraAddress").value = extraAddr;

              } else {
                returnData.extraAddr = '';
                // document.getElementById("sample6_extraAddress").value = '';
              }

              // 우편번호와 주소 정보를 해당 필드에 넣음
              // document.getElementById('Postcode').value = data.zonecode;// 5자리 새 우편번호 사용
              // document.getElementById("Addr").value = addr;
              // document.getElementById("AddrDtl").focus();

              returnData.postcode = data.zonecode;
              returnData.addr = addr;

              // iframe을 넣은 element를 안보이게
              // autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않음
              Callback(returnData);

              // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치 되돌림
              // document.body.scrollTop=document.documentElement.scrollTop=currentScroll;
            },
            onresize:function(size){
              element_wrap.style.height=size.height+"px";
            },
            width:"100%",
            height:"100%"
          }).embed(element_wrap);
          // iframe을 넣은 element를 보이게 한다
          // element_wrap.style.display="block";
        })(this.selectAddr)
      },
      guideAlert: function(){
        if(!this.parentInfo.postcode || !this.parentInfo.addr){alert('주소를 입력해주세요'); return; }
        if(!this.isDateFormat(this.parentInfo.birth)){alert('생년월일을 확인해주세요'); return; }
        if(!this.parentInfo.agree){alert('안내사항에 동의해주세요.'); return; }
      },
      isDateFormat: function(date){
        if(!date) return false;

        var date = String(date);
        var y = parseInt(date.substr(0, 4), 10);
        var m = parseInt(date.substr(4, 2), 10);
        var d = parseInt(date.substr(6, 2), 10);
        var dt = new Date(y, m-1, d);
        if(dt.getDate() != d){ return false; }
        else if(dt.getMonth()+1 != m){ return false; }
        else if(dt.getFullYear() != y){ return false; }
        else { return true; }
      },
      confirm: function(){
        let params = {
          p: this.qs.p,
          pPhoneNum: this.parentInfo.phoneNum,
          pAddress: this.parentInfo.addr,
          pAddressDetail: this.parentInfo.addrDtl,
          pBirth: this.parentInfo.birth,
        }
        axios({
          url: '/bike/tsm_player/ajax/member/parent_agree_W.asp',
          method: 'get',
          params: params
        })
        .then(response=>{

          if(!response.data.return){
            alert(response.data.message+'\n대회요강 페이지로 이동합니다.');
          }
          else{
            alert('보호자 동의가 완료되었습니다.\n대회요강 페이지로 이동합니다.');
          }


          var form = document.createElement("form");
          form.setAttribute("charset", "UTF-8");
          form.setAttribute("method", "Post");
          form.setAttribute("action", "competitionInfo.asp");


          var hiddenField = document.createElement("input");
          hiddenField.setAttribute("type", "hidden");
          hiddenField.setAttribute("name", "p");
          hiddenField.setAttribute("value", this.qs.titleIdx2);

          form.appendChild(hiddenField);
          document.body.appendChild(form);
          form.submit();

          // let formData = new FormData(form)
          // formData.append('TitleIDX', this.qs.titleIdx2)


        })
      }
    },
    created() {
      this.qs.p = '<%=p%>';
      this.qs.titleIdx = <%=TitleIdx%>
      this.qs.memberIdx = <%=MemberIDX%>
      <%
        dim EncodedTitleIDX
        EncodedTitleIDX = encode("titleIdx="&TitleIdx, 0)
      %>
      this.qs.titleIdx2 = '<%=EncodedTitleIDX%>'

      console.log(this.qs.titleIdx)
      console.log(this.qs.titleIdx2)

      // 대회정보
      axios({
        url:'/bike/TSM_Player/ajax/title/detail_R.asp',
        method: 'post',
        params: {
          titleIdx: this.qs.titleIdx,
        }
      })
      .then(response=>{
        if(Object.keys(response.data).length === 0) return;

        this.titleInfo.title = response.data.title;
        this.titleInfo.place = response.data.place;
        this.titleInfo.startDate = response.data.startDate;
        this.titleInfo.endDate = response.data.endDate;
      })

      // 회원정보, 보호자 정보
      axios({
        url: '/bike/tsm_player/ajax/member/info_r.asp',
        method: 'get',
        params: {
          titleIdx: this.qs.titleIdx,
          memberIdx: this.qs.memberIdx,
        }
      })
      .then(response=>{
        if(response.data.memberInfo.length == 0){throw new Error('error')}

        memberInfo = response.data.memberInfo[0];
        this.memberInfo.name = memberInfo.name;
        this.memberInfo.birth = memberInfo.birth;
        this.memberInfo.gender = memberInfo.gender;

        if(response.data.moreInfo.length == 0){throw new Error('error')}
        moreInfo = response.data.moreInfo[0];
        this.moreInfo.scrpGrade = moreInfo.scrpGrade;
        this.moreInfo.scrpLevel = moreInfo.scrpLevel;


        if(response.data.parentInfo.length == 0){throw new Error('error')}
        parentInfo = response.data.parentInfo[0];
        this.parentInfo.name = parentInfo.name;
        this.parentInfo.phoneNum = parentInfo.phoneNum;
        this.parentInfo.relationship = parentInfo.relationship;
      })
    },
    mounted() {
      this.postLayer.el = new OverLayer({
        overLayer: $('._postLayer'),
        emptyHTML: '정보를 불러오고 있습니다.',
        errorHTML: '',
      });
      // this.postLayer.el.on('beforeOpen', function(){history.pushState('view', null, null);});
      // this.postLayer.el.on('beforeClose', function(){history.pushState('list', null, null);});
    }

  })



</script>

</body>
</html>
