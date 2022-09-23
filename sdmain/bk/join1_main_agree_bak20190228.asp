﻿<!-- #include file='./include/config.asp' -->
<%
   '통합회원 가입 약관동의 페이지

	dim UserName  	: UserName  = fInject(Request("UserName"))
	dim UserBirth   : UserBirth = encode(fInject(Request("UserBirth")), 0)

%>
<script>
  function chk_Submit(){
    if(!($('#sd_terms').is(':checked'))){
      alert('스포츠다이어리 이용약관에 동의해 주세요.');
      $('#sd_term').focus();
      return;
    }

    if(!($('#privacy_terms').is(':checked'))){
      alert('개인정보 처리방침에 동의해 주세요.');
      $('#privacy_terms').focus();
      return;
    }

    if(!($('#data_terms').is(':checked'))){
      alert('개인훈련 데이터 정보열람 활용에 동의해 주세요');
      $('#data_terms').focus();
      return;
    }

    if(!($('#market_terms').is(':checked'))){
      alert('마케팅 정보 수신 동의에 동의해 주세요');
      $('#market_terms').focus();
      return;
    }

    $('#frm').attr('action', './join2_main_userInfo.asp');
    $('#frm').submit();
  }
</script>
</head>
<body>
<div class="l">


<!-- S: sub-header -->
<div class="sd-header sd-header-sub">
  <!-- #include file="./include/sub_header_arrow.asp" -->
  <h1>개인정보 보호 및 약관</h1>
  <!-- #include file="./include/sub_header_gnb.asp" -->
</div>
<!-- E: sub-header -->

<form name="frm" id="frm" method="post">
  <input type="hidden" id="UserName" name="UserName" value="<%=UserName%>" />
  <input type="hidden" id="UserBirth" name="UserBirth" value="<%=UserBirth%>" />
  <!-- S: main -->
  <div class="main agree pack">
    <!-- S: list-group -->
    <section class="list-group">
      <h2>
        <label class="whole_btn ic_check act_btn">
          <input type="checkbox" id="agree_all">
          <span class="txt">아래 약관에 모두 동의합니다.</span>
          <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
            <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
          </svg>
        </label>
      </h2>
      <dl class="panel">
        <dt class="panel-heading clearfix">
          <label class="panel-title bind_whole ic_check act_btn">
            <input type="checkbox" name="sd_terms" id="sd_terms" />
            <span class="txt">스포츠 다이어리 이용약관 (필수)</span>
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
          </label>
          <a href="#target_1" data-toggle="collapse" class="target_btn"> <i class="fa fa-sort-desc" aria-hidden="true"></i> </a> </dt>
        <dd id="target_1" class="collapse">
          <pre class="panel-body">
제1장 총칙

제1조 (목적)
이 약관은 (주)스다(이하 "회사"라고 합니다)이 운영하는 앱 또는 웹사이트에서 제공하는 서비스(이하 "서비스"라 한다)를 이용함에 있어 이용자의 권리·의무 및 책임사항, 이용함에 따른 이용조건 및 절차 등 기본적인 사항을 규정함을 목적으로 합니다.

제2조 (약관의 효력 및 변경)
1.  회사는 본 약관의 내용을 회원이 열람할 수 있는 메뉴항목을 각 서비스 사이트의 초기 서비스 화면에 게시합니다.
2.  회사는 합리적인 사유가 있을 경우 개인정보보호법, 약관의 규제에 관한 법률, 전자거래기본법, 전자서명법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 전자상거래 등에서의 소비자보호에 관한 법률, 방문판매 등에 관한 법률, 소비자보호법 등 관련 법령에 위배되지 않는 범위 안에서 이 약관을 변경할 수 있습니다.
3.  회사가 약관을 변경하는 경우에는 적용일자 및 개정사유를 명시하여 그 적용일자 7일 이전부터 공지합니다. 다만, 이용자에게 불리한 약관의 변경의 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 회사는 개정 전 내용과 개정 후 내용을 명확하게 비교하여 회원이 알기 쉽도록 표시합니다.
4.  약관을 개정하는 경우에는 사이트 내 게시판, 팝업공지 또는 E-mail 통보 등 1가지 이상의 방법을 통해 고지하며 개정 이전에 가입한 기존회원은 개정 이후 7일 이내에 별도의 이의표시를 하지 아니하면 약관의 개정사항에 동의한 것으로 간주합니다.
5.  변경된 약관에 대한 정보를 알지 못해 발생하는 회원의 피해는 회사가 책임지지 않습니다.

제3조 (약관 외 준칙)
이 약관에 명시되지 않은 사항에 대해서는 정보통신법 등 관계법령 및 회사가 정한 서비스의 세부이용지침 등의 규정에 의합니다.

제4조 (용어의 정의)
1.  이 약관에서 사용하는 용어의 정의는 다음과 같습니다.
가)  회원: 서비스에 접속하여 이 약관에 동의하고, 개인정보를 제공하여 ID(고유번호)와 PASSWORD(비밀번호)를 발급 받아 회원등록을 한 고객으로, 서비스의 정보를 지속적으로 제공받으며 이용할 수 있는 자를 말하며, 회원의 자격 및 권한 등은 사이트 별로 별도 관리합니다.
나)  이용자: 본 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.
다)  ID(아이디): 회원 식별과 회원의 서비스 이용을 위하여 회원이 선정하고 회사가 승인하는 영문자와 숫자의 조합을 말합니다.
라)  PASSWORD(비밀번호): 회원이 통신상 자신의 비밀을 보호하기 위하여 선정한 문자와 숫자의 조합을 말합니다.
마)  운영자: 서비스의 전반적인 관리와 원활한 운영을 위하여 회사가 선정한 자를 말합니다.
바)  서비스 중지: 정상 이용 중 회사가 정한 일정한 요건에 따라 일정 기간 동안 서비스의 제공을 중지하는 것을 말합니다.
사)  전자우편(E-mail): 인터넷을 통한 우편입니다.
아)  해지: 회사 또는 회원이 서비스 이용 이후 그 이용계약을 종료시키는 의사표시를 말합니다.
2.  이 약관에서 사용하는 용어의 정의는 제1항에서 정하는 것을 제외하고는 관계 법령 및 서비스 별 안내에서 정하는 바에 의합니다.

제2장 서비스 이용 계약

제5조 (이용 계약의 성립)
1.  회원가입 시 이용약관에 동의 버튼을 누르면 약관에 동의하는 것으로 간주됩니다.
2.  이용 계약은 고객의 이용 신청에 대하여 회사가 승낙함으로써 성립됩니다.

제6조 (이용 신청)
이용 신청은 서비스의 이용자 등록 화면에서 고객이 다음 사항을 가입 신청 양식에 기록하는 방식으로 행합니다.
1.  필수항목 : 이름(한글/영문), 종목, 아이디, 비밀번호, 성별, 생년월일, 전화번호(휴대폰번호), E-mail, 주소, 이메일/SMS 수신동의여부, 본인인증정보 또는 중복가입확인정보 등
2.  선택항목 : 소속사/학교정보, 신체정보, 운동/훈련정보, 선수정보, 키, 체중, 혈액형 등

제7조 (이용신청의 승낙)
회사는 제6조에서 정한 사항을 정확히 기재하여 이용 신청한 고객에 대하여 서비스 이용 신청을 승낙합니다.

제8조 (이용신청에 대한 승낙의 제한)
회사는 다음 각 호에 해당하는 신청에 대하여는 승낙을 하지 않을 수 있습니다.
1.  기술상 서비스 제공이 불가능한 경우
2.  실명이 아니거나, 다른 사람의 명의 사용 등 이용자 등록 시 허위로 신청하는 경우
3.  이용자 등록 사항을 누락하거나 오기하여 신청하는 경우
4.  사회의 안녕질서 또는 미풍양속을 저해하거나, 저해할 목적으로 신청한 경우
5.  제24조 제2항에 의하여 이전에 회원 자격을 상실한 적이 있는 경우. 다만, 동 자격 상실 이후 1년 이상 경과한 자로 회사의 회원 재가입 승낙을 받은 경우는 예외로 합니다. 이를 확인하기 위하여 회사는 회원의 부정이용기록을 1년간 보유합니다.
6.  기타 회사가 정한 이용신청 요건이 만족되지 않았을 경우



제9조 (계약 사항의 변경)
회원은 이용 신청 시 기재한 사항이 변경되었을 경우 회사가 정한 별도의 이용 방법으로 정해진 양식 및 방법에 의하여 수정하여야 합니다.
1.  "회원"은 개인정보 관리화면을 통하여 언제든지 본인의 개인정보를 열람하고 수정할 수 있습니다. 다만, 서비스 관리를 위해 필요한 실명, 아이디 등은 수정이 불가능합니다.
2.  "회원"은 회원가입 신청시 기재한 사항이 변경되었을 경우, 온라인으로 수정을 하거나 전자우편 및 기타 방법으로 그 변경사항을 알려야 합니다.
3.  제 2항의 변경사항을 회사에 알리지 않아 발생한 불이익에 대하여 회사는 책임지지 않습니다.

제 3 장 서비스의 이용

제10조 (서비스의 이용 개시)
1.  회사는 회원의 이용 신청을 승낙한 때부터 서비스를 개시합니다. 단, 일부 서비스의 경우에는 지정된 일자부터 서비스를 개시합니다.
2.  회사의 업무상 또는 기술상의 장애로 인하여 서비스를 개시하지 못하는 경우에는 사이트에 공시하거나 회원에게 이를 통지합니다.
3.  본 스포츠다이어리의 모든 어플리케이션 프로그램 사용은 무료서비스로 제공됩니다. 다만 회사의 사정상, 혹은 서비스 기준에 따라 유료화로 변경될 수 있음을 알려드립니다.
4.  스포츠다이어리 보호자용 어플리케이션의 경우, 본인 자녀의 훈련 및 대회정보의 일부를 함께 열람할 수 있는 서비스를 제공하고 있으며 열람권한은 본인 자녀로부터 반드시 승인절차를 걸쳐야 하는 조건으로 진행됩니다.

제11조 (회원의 이용 범위)
회사가 운영하는 여러 종류의 서비스 중 어느 한 곳에 가입한 회원은 동일한 ID(아이디)와 PASSWORD(비밀번호)로 회사가 운영하는 모든 인터넷 홈페이지를 이용할 수 있습니다.

제12조 (서비스의 이용 시간)
1.  서비스의 이용은 연중무휴 1일 24시간을 원칙으로 합니다. 다만, 회사의 업무상이나 기술상의 이유로 서비스가 일시 중지될 수 있습니다. 이러한 경우 회사는 사전 또는 사후에 이를 공지합니다.
2.  회사는 서비스를 일정범위로 분할하여 각 범위 별로 이용 가능한 시간을 별도로 정할 수 있으며 이 경우 그 내용을 공지합니다.

제13조 (서비스의 변경 및 중지)
1.  회사는 변경될 서비스의 내용 및 제공일자를 제20조 제2항에서 정한 방법으로 회원에게 통지하고 서비스를 변경하여 제공할 수 있습니다.
2.  회사는 다음 각 호에 해당하는 경우 서비스의 전부 또는 일부를 제한하거나 중지할 수 있습니다.
가)  서비스용 설비의 보수 등 공사로 인한 부득이한 경우
나)  회원이 회사의 영업활동을 방해하는 경우
다)  정전, 제반 설비의 장애 또는 이용량의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 경우
라)  서비스 제공업자와의 계약 종료 등과 같은 회사의 제반 사정으로 서비스를 유지할 수 없는 경우
마)  기타 천재지변, 국가비상사태 등 불가항력적 사유가 있는 경우
3.  제2항에 의한 서비스 중단의 경우에는 회사가 제20조 제2항에서 정한 방법으로 이용자에게 통지합니다. 다만, 회사가 통제할 수 없는 사유로 인한 서비스의 중단(운영자의 고의, 과실이 없는 디스크 장애, 시스템 다운 등)으로 인하여 사전 통지가 불가능한 경우에는 그러지 아니합니다.
4.  회사는 서비스의 변경, 중지로 발생하는 문제에 대해서는 어떠한 책임도 지지 않습니다.

제14조 (정보의 제공 및 광고의 게재)
1.  회사는 서비스를 운영함에 있어 각종 정보를 서비스 화면에 개재하거나 e-mail 및 서신우편 등의 방법으로 회원에게 제공할 수 있습니다. 다만, 회원은 관련법에 따른 거래관련 정보 및 고객문의 등에 대한 답변 등을 제외하고는 언제든지 전자우편에 대해서 수신 거절을 할 수 있습니다.
2.  제 1항의 정보를 전화 및 모사전송기기에 의하여 전송하려고 하는 경우에는 “회원”의 사전 동의를 받아서 전송합니다. 다만, 회원의 거래관련 정보 및 고객문의 등에 대한 회신에 있어서는 제외됩니다.
3.   회사는 서비스의 운영과 관련하여 홈페이지, 서비스 화면, SMS, e-mail 등에 광고 등을 게재할 수 있습니다. 광고가 게재된 전자우편을 수신한 회원은 수신거절을 할 수 있습니다.
4.  회원이 서비스상에 게재되어 있는 광고를 이용하거나 서비스를 통한 광고주의 판촉활동에 참여하는 등의 방법으로 교신 또는 거래를 하는 것은 전적으로 회원과 광고주 간의 문제입니다. 만약 회원과 광고주간에 문제가 발생할 경우에도 회원과 광고주가 직접 해결하여야 하며, 이와 관련하여 회사는 어떠한 책임도 지지 않습니다.
5.  회원은 회사가 제공하는 “서비스”와 관련하여 게시물 또는 기타 정보를 변경, 수정, 제한하는 등의 조치를 취하지 않습니다.

제15조 (게시물 또는 내용물의 삭제)
1.  회사는 회원이 게시하거나 전달하는 서비스 내의 모든 내용물(회원간 전달 포함)이 다음 각 호에 해당한다고 판단되는 경우 사전통지 없이 삭제할 수 있으며, 이에 대해 회사는 어떠한 책임도 지지 않습니다.
가)  회사, 다른 회원 또는 제3자를 비방하거나 중상모략으로 명예를 손상시키는 내용인 경우
나)  공공질서 및 미풍양속에 위반되는 내용의 정보, 문형, 도형 등의 유포에 해당하는 경우
다)  범죄적 행위에 결부된다고 인정되는 내용인 경우
라)  회사의 저작권, 제3자의 저작권 등 기타 권리를 침해하는 내용인 경우
마)  제2항의 소정의 세부이용지침을 통하여 회사에서 규정한 게시기간을 초과한 경우
바)  회사에서 제공하는 서비스와 관련 없는 내용인 경우
사)  사. 불필요하거나 승인되지 않은 광고, 판촉물을 게재하는 경우
아)  기타 관계 범령 및 회사의 지침 등에 위반된다고 판단되는 경우
2.  회사는 게시물에 관련된 세부이용지침을 별도로 정하여 시행할 수 있으며, 회원은 그 지침에 따라 각종 게시물(회원간 전달 포함)을 등록하거나 삭제하여야 합니다.

제16조 (게시물의 저작권)
1.  회원이 서비스 내에 게시한 게시물(회원간 전달 포함)의 저작권은 회원이 소유하며 회사는 서비스 내에 게시할 수 있는 권리를 갖습니다.
2.  회사는 게시한 회원의 동의 없이 게시물을 다른 목적으로 사용할 수 없습니다.
3.  회사는 회원이 서비스 내에 게시한 게시물이 타인의 저작권, 프로그램 저작권 등을 침해하더라도 이에 대한 민, 형사상의 책임을 부담하지 않습니다. 만일 회원이 타인의 저작권, 프로그램 저작권 등을 침해하였음을 이유로 회사가 타인으로부터 손해배상청구 등 이의 제기를 받은 경우회원은 그로 인해 회사에 발생한 모든 손해를 부담하여야 합니다.
4.  회사는 회원이 해지하거나 적법한 사유로 해지된 경우 해당 회원이 게시하였던 게시물을 삭제할 수 있습니다.
5.  회사가 작성한 저작물에 대한 저작권은 회사에 귀속합니다.
6.  회원은 서비스를 이용하여 얻은 정보를 가공, 판매하는 행위 등 서비스에 게재된 자료를 영리 목적으로 이용하거나 제3자에게 이용하게 할 수 없으며, 게시물에 대한 저작권 침해는 관계 법령의 적용을 받습니다.
7.  관련 협회와 협의된 공식스포츠대회의 경기영상 및 관련정보는 회사서비스 내에 게시할 수 있는 권리를 갖습니다.

제 4 장 계약 당사자의 의무

제17조 (회사의 의무)
1.  회사는 서비스 제공과 관련하여 알고 있는 회원의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 단, 관계법령에 의한 수사상의 목적으로 관계기관으로부터 요구 받은 경우나 정보통신윤리위원회의 요청이 있는 경우 등 법률의 규정에 따른 적법한 절차에 의한 경우는 그러하지 않습니다.
2.  제1항의 범위 내에서, 회사는 업무와 관련하여 회원의 사전 동의 없이 회원 전체 또는 일부의 개인정보에 관한 통계자료를 작성하여 이를 사용할 수 있고, 이를 위하여 회원의 컴퓨터에 쿠키를 전송할 수 있습니다. 이 경우 회원은 쿠키의 수신을 거부하거나 쿠키의 수신에 대하여 경고하도록 사용하는 컴퓨터의 브라우저의 설정을 변경할 수 있으며, 쿠키의 설정 변경에 의해 서비스 이용이 변경되는 것은 회원의 책임입니다.
3.  회사는 서비스와 관련한 회원의 불만사항이 접수되는 경우 이를 신속하게 처리하여야 합니다.
4.  회사가 제공하는 서비스로 인하여 회원에게 손해가 발생한 경우 그러한 손해가 회사의 고의나 중과실에 기해 발생한 경우에 한하여 회사에서 책임을 부담하며, 그 책임의 범위는 통상손해에 한합니다.
5.  회사는 정보통신망 이용촉진 및 정보보호에 관한 법률, 통신비밀보호법, 전기통신사업법 등 서비스의 운영, 유지와 관련 있는 법규를 준수합니다.

제18조 (회원의 의무)
1.  회원은 서비스를 이용할 때 다음 각 호의 행위를 하여서는 아니 됩니다.
가)  이용 신청 또는 변경 시 허위 사실을 기재하거나, 다른 회원의 ID 및 PASSWORD를 도용, 부정하게 사용하는 행위
나)  회사의 서비스 정보를 이용하여 얻은 정보를 회사의 사전 승낙 없이 복제 또는 유통시키거나 상업적으로 이용하는 행위
다)  타인의 명예를 손상시키거나 불이익을 주는 행위
라)  게시판 등에 음란물을 게재하거나 음란사이트를 연결(링크)하는 행위
마)  회사의 저작권, 제3자의 저작권 등 기타 권리를 침해하는 행위
바)  공공질서 및 미풍양속에 위반되는 내용의 정보, 문장, 도형, 음성 등을 타인에게 유포하는 행위
사)  서비스와 관련된 설비의 오 동작이나, 정보 등의 파괴 및 혼란을 유발시키는 컴퓨터 바이러스 감염 자료를 등록 또는 유포하는 행위
아)  서비스 운영을 고의로 방해하거나 서비스의 안정적 운영을 방해할 수 있는 정보 및 수신자의 명시적인 수신거부의사에 반하여 광고성 정보를 전송하는 행위
자)  타인으로 가장하는 행위 및 타인과의 관계를 허위로 명시하는 행위
차)  다른 회원의 개인정보를 수집, 저장, 공개하는 행위
카)  자기 또는 타인에게 재산상의 이익을 주거나 타인에게 손해를 가할 목적으로 허위의 정보를 유통시키는 행위
타)  재물을 걸고 도박하거나 사행행위를 하는 행위
파)  윤락행위를 알선하거나 음행을 매개하는 내용의 정보를 유통시키는 행위
하)  수치심이나 혐오감 또는 공포심을 일으키는 말이나 음향, 글이나 화상 또는 영상을 계속하여 상대방에게 도달하게 하여 상대방의 일상적 생활을 방해하는 행위
가)  서비스에 게시된 정보를 변경하는 행위
나)  관련 법령에 의하여 그 전송 또는 게시가 금지되는 정보(컴퓨터 프로그램 포함)의 전송 또는 게시 행위
다)  회사의 직원이나 운영자를 가장하거나 사칭하여 또는 타인의 명의를 도용하여 글을 게시하거나 메일을 발송하는 행위
라)  컴퓨터 소프트웨어, 하드웨어, 전기통신 장비의 정상적인 가동을 방해, 파괴할 목적으로 고안된 소프트웨어 바이러스, 기타 다른 컴퓨터 코드, 파일, 프로그램을 포함하고 있는 자료를 게시하거나 e-mail로 발송하는 행위
마)  스토킹(stalking) 등 다른 회원을 괴롭히는 행위
바)  기타 불법적이거나 부당한 행위
2.  회원은 관계 법령, 본 약관의 규정, 이용안내 및 서비스상에 공지한 주의사항, 회사가 통지하는 사항 등을 준수하여야 하며, 기타 회사의 업무에 방해 되는 행위를 하여서는 아니 됩니다.
3.  회원은 회사에서 공식적으로 인정한 경우를 제외하고는 서비스를 이용하여 상품을 판매하는 영업 활동을 할 수 없으며 특히 해킹, 광고를 통한 수익, 음란사이트를 통한 상업행위, 상용소프트웨어 불법배포 등을 할 수 없습니다. 이를 위반하여 발생한 영업 활동을 결과 및 손실, 관계기관에 의한 구속 등 법적 조치 등에 관해서는 회사가 책임을 지지 않으며, 회원은 이와 같은 행위와 관련하여 회사에 대하여 손해배상 의무를 집니다.
4.  회원은 서비스 이용을 위해 등록할 경우 현재의 사실과 일치하는 완전한 정보(이하 “등록정보”)를 제공하여야 합니다.
5.  회원은 등록정보에 변경사항이 발생할 경우 즉시 갱신하여야 합니다. 회원이 제공한 등록정보 및 갱신한 등록정보가 부정확할 경우, 기타 회원이 본 조 제1항에 명시된 행위를 한 경우에 회사는 본 서비스 약관 제24조에 의해 회원의 서비스 이용을 제한 또는 중지할 수 있습니다.

제19조 (회원 ID와 PASSWORD 관리에 대한 의무와 책임)
1.  회원 ID(아이디)와 PASSWORD(비밀번호)의 관리 소홀, 부정 사용에 의하여 발생하는 모든 결과에 대한 책임은 회원 본인에게 있습니다.
2.  회원은 본인의 회원 ID(아이디)와 PASSWORD(비밀번호)를 제3자에게 이용하게 해서는 아니 되며, 회원 본인의 회원 ID(아이디)와 PASSWORD(비밀번호)를 도난 당하거나 제3자가 사용하고 있음을 인지하는 경우에는 바로 회사에 통보하고 회사의 안내가 있는 경우 그에 따라야 합니다.
3.  회원 ID(고유번호)는 회사의 사전 동의 없이 변경할 수 없습니다.

제20조 (회원에 대한 통지)
1.  회사가 회원에 대한 통지를 하는 경우, 회원이 회사와 미리 약정하여 지정한 전자우편주소, 전자쪽지 등으로 할 수 있습니다.
2.  회사는 불특정 다수 회원에 대한 통지의 경우 1주일이상 게시판에 게시함으로써 개별 통지에 갈음할 수 있습니다. 다만, 회원 본인의 거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 개별통지를 합니다.
3.  회사는 회원이 서비스 이용 중 필요하다고 인정되는 다양한 정보에 대해서 전자메일이나 서신우편 등의 방법으로 회원에게 제공할 수 있으며, 회원은 원하지 않을 경우 가입신청 메뉴와 회원정보수정 메뉴에서 정보수신거부를 할 수 있습니다. 단, 서비스의 종료•중단, 기타 서비스 내용에 중대한 변경 등의 사유가 있을 경우에는 회원의 수신거부의사에도 불구하고 해당 내용을 제공할 수 있습니다.

제21조 (이용자의 개인정보보호)
회사는 관련법령이 정하는 바에 따라서 회원 등록정보를 포함한 회원의 개인정보를 보호하기 위하여 노력합니다. 회원의 개인정보보호에 관해서는 관련법령 및 회사가 정하는 “개인정보보호정책”에 정한 바에 의합니다. 다만, 회사가 운영하는 사이트 이외의 링크된 사이트에서는 회사의 개인정보처리방침이 적용되지 않습니다.

제22조 (개인정보 수집 및 이용)
회사는 수집된 개인정보의 취급 및 관리 등의 업무(이하 “업무”)를 스스로 수행함을 원칙으로 하나, 필요한 경우 업무의 일부 또는 전부를 회사가 선정한 회사에 위탁할 수 있으며, 회원제 서비스 이용에 따른 이용자 식별 및 마케팅, 광고에 활용할 수 있다.
1.

제23조 (스포츠다이어리 어플리케이션과 연결 웹사이트간의 관계)
1.  스포츠다이어리 어플리케이션과 하위 웹사이트가 하이퍼링크 (예: 하이퍼링크의 대상에는 문자, 그림 및 동화상 등이 포함 됨) 방식 등으로 연결된 경우, 하위 웹사이트를 연결 웹사이트라고 합니다.
2.  회사는 연결 웹사이트가 독자적으로 제공하는 재화 등에 의해 이용자와 행하는 거래에 대해서는 그 거래에 대한 보증책임을 지지 않습니다.

제 5 장 계약해지 및 이용제한

제24조 (계약해지 및 이용제한)
1.  회원이 서비스 이용계약을 해지하고자 할 경우에는 서비스 화면의 마이페이지 등을 통하여 또는 회사가 정한 별도의 이용방법으로 회사에 해지신청을 하여야 하며, 회사는 관련법 등이 정하는 바에 따라 이를 즉시 처리하여야 합니다.
2.  회원이 계약을 해지할 경우, 관련법 및 개인정보처리방침에 따라 회사가 회원정보를 보유하는 경우를 제외하고는 해지 즉시 회원의 데이터는 소멸됩니다.
3.  회사는 회원이 제18조에 규정한 회원의 의무를 이행하지 않을 경우 사전 통지 없이 즉시 이용계약을 해지하거나 또는 서비스 이용을 중지할 수 있습니다.
4.  회사는 회원이 이용계약을 체결하여 회원 ID(아이디)와 PASSWORD(비밀번호)를 부여 받은 후에라도 회원의 자격에 따른 서비스 이용을 제한할 수 있습니다.
5.  본 조 제3항 및 제4항의 회사 조치에 대하여 회원은 회사가 정한 절차에 따라 이의신청을 할 수 있습니다.
6.  본 조 제5항의 이의가 정당하다고 회사가 인정하는 경우, 회사는 즉시 서비스의 이용을 재개합니다.

제25조 (양도 금지)
회원은 서비스의 이용권한, 기타 이용 계약상 지위를 타인에게 양도, 증여할 수 없으며 게시물에 대한 저작권을 포함한 모든 권리 및 책임은 이를 게시한 회원에게 있습니다.

제 6 장 손해배상 등

제26조 (손해배상)
1.  회원이 본 약관의 규정을 위반함으로 인하여 회사에 손해가 발생하게 되는 경우, 이 약관을 위반한 회원은 회사에 발생하는 모든 손해를 배상하여야 합니다.
2.  회원이 서비스를 이용함에 있어 행한 불법행위나 본 약관 위반행위로 인하여 회사가 당해 회원 이외의 제3자로부터 손해배상 청구 또는 소송을 비롯한 각종 이의제기를 받는 경우 당해 회원은 자신의 책임과 비용으로 회사를 면책시켜야 하며, 회사가 면책되지 못한 경우 당해 회원은 그로 인하여 발생한 모든 손해를 배상하여야 합니다.

제27조 (면책사항)
1.  회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.
2.  회사는 회원의 귀책사유로 인한 서비스의 이용장애에 대하여 책임을 지지 않습니다.
3.  회사는 회원이 서비스를 이용하여 기대하는 수익을 상실한 것에 대하여 책임을 지지 않으며 그 밖에 서비스를 통하여 얻은 자료로 인한 손해 등에 대하여도 책임을 지지 않습니다. 회사는 회원이 사이트에 게재한 정보•자료•사실의 신뢰도 및 정확성 등 내용에 대하여는 책임을 지지 않습니다.
4.  회사는 회원 상호간 또는 회원과 제3자 상호간에 서비스를 매개로 발생한 분쟁에 대해서는 개입할 의무가 없으며 이로 인한 손해를 배상할 책임도 없습니다.

제28조 (관할법원)
1.  서비스 이용과 관련하여 회사와 회원 사이에 분쟁이 발생한 경우, 회사와 회원은 분쟁의 해결을 위해 성실히 협의합니다.
2.  본 조 제1항의 협의에서도 분쟁이 해결되지 않을 경우 소송은 회사의 본점 소재지를 관할하는 법원의 관할로 합니다.

부칙
1.  공고일자 : 2017-11-01
2016년 12월 1일부터 시행되던 종전의 약관은 본 약관으로 대체합니다.

2.  시행일자 : 2011-11-01
이 약관은 2017년 11월 1일부터 적용됩니다.

          </pre>
        </dd>
      </dl>
      <dl class="panel">
        <dt class="panel-heading clearfix">
          <label class="panel-title bind_whole ic_check act_btn">
            <input type="checkbox" id="privacy_terms" name="privacy_terms" />
            <span class="txt">개인정보 처리 방침 (필수)</span>
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
          </label>
          <a href="#target_2" data-toggle="collapse" class="target_btn"> <i class="fa fa-sort-desc" aria-hidden="true"></i> </a> </dt>
        <dd id="target_2" class="collapse">
          <pre class="panel-body">
㈜위드라인(이하 “회사”라고 합니다)은 이용자들의 개인정보보호를 매우 중요시하며, 이용자는 회사가 운영하고 있는 인터넷관련 서비스(스포츠다이어리)의 서비스를 이용함과 동시에 온라인상에서 회사에 제공한 개인정보가 보호 받을 수 있도록 최선을 다하고 있습니다.이에 회사는 통신비밀보호법, 전기통신사업법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 정보통신서비스제공자가 준수하여야 할 관련 법규상의 개인정보보호 규정 및 정보통신부가 제정한 개인정보보호지침을 준수하고 있습니다.
회사는 개인정보처리방침을 통하여 이용자들이 제공하는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려 드리고 있으며 개인정보처리방침을 홈페이지 첫 화면에 공개함으로써 이용자들이 언제나 용이하게 보실 수 있도록 조치하고 있습니다.
회사의 개인정보처리방침은 정부의 법률 및 지침 변경이나 회사의 내부 방침 변경 등으로 인하여 수시로 변경될 수 있고, 이에 따른 개인정보처리방침의 지속적인 개선을 위하여 필요한 절차를 정하고 있습니다. 그리고 개인정보처리방침을 개정하는 경우나 개인정보처리방침 변경될 경우 홈페이지 및 앱의 게시판 공지를 통해 고지하고 있습니다.
회사의 개인정보처리방침은 다음과 같은 내용을 담고 있습니다.

1. 개인정보 수집에 대한 동의
2. 개인정보의 수집목적 및 이용목적
3. 수집하는 개인정보 항목 및 수집방법
4. 수집하는 개인정보의 보유 및 이용기간
5. 수집한 개인정보의 공유 및 제공
6. 이용자 자신의 개인정보 관리(열람,정정,삭제 등)에 관한 사항
7. 쿠키(cookie)의 운영에 관한 사항
8. 비회원 고객의 개인정보 관리
9. 개인정보관련 의견수렴 및 불만처리에 관한 사항
10. 개인정보 관리책임자 및 담당자의 소속-성명 및 연락처
11. 고지의 의무

1. 개인정보 수집에 대한 동의
스포츠다이어리 이용자들이 회사의 개인정보처리방침 또는 이용약관의 내용에 대하여 「동의」버튼 또는「취소」버튼을 클릭할 수 있는 절차를 마련하여, 「동의」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.

2. 개인정보의 수집목적 및 이용목적
"개인정보"라 함은 생존하는 개인에 관한 정보로서 당해 정보에 포함되어 있는 성명, 주민등록번호 등의 사항에 의하여 당해 개인을 식별할 수 있는 정보(당해 정보만으로는 특정 개인을 식별할 수 없더라도 다른 정보와 용이하게 결합하여 식별할 수 있는 것을 포함)를 말합니다.
회사는 회원서비스를 통하여 이용자들에게 맞춤식 서비스를 비롯한 보다 더 향상된 양질의 서비스를 제공하기 위하여 공식MOU를 체결한 각 스포츠종목 단체별 사전에 합의된 해당 단체 회원 및 이용자 개인의 정보를 수집하고 있습니다. 회사는 이용자의 사전 동의 없이는 이용자의 개인 정보를 공개하지 않으며, 종목간의 회원정보 보완에 있어서도 공개되지 않습니다. 수집된 정보는 공식 MOU를 체결한 각 스포츠종목 단체와 함께 공유 및 서비스활용에 상호 적극 활용되고 있습니다. 자세한 내용은 아래와 같이 이용하고 있습니다.

가)  첫째, 이용자들이 제공한 개인정보를 바탕으로 보다 더 유용한 서비스를 개발할 수 있습니다.
회사는 신규 서비스개발이나 컨텐츠의 확충 시에 기존 이용자들이 회사에 제공한 개인정보를 바탕으로 개발해야 할 서비스의 우선 순위를 보다 더 효율적으로 정하고, 이용자들이 필요로 할 컨텐츠를 합리적으로 선택하여 제공할 수 있습니다.
나)  둘째, 수집하는 개인정보 항목과 수집 및 이용목적은 다음과 같습니다.
① 성명, 생년월일, 아이디, 비밀번호, 종목, 소속명 : 회원제 서비스 이용에 따른 이용자 식별 및 “ㅋㅋ몰” 회원제 서비스 제공, , 새로운 서비스 및 이벤트 정보 등의 안내 및 마케팅, 광고에의 활용
② 이메일주소, 전화번호(휴대폰번호), 주소 : 고지사항 전달, 불만처리 등을 위한 원활한 의사소통 경로의 확보, “ㅋㅋ몰” 회원제 서비스 제공, 새로운 서비스 및 이벤트 정보 등의 안내 및 마케팅, 광고에의 활용
③ 운동정보 : 개인맞춤 통계자료제공을 위한 회원의 기초정보, 훈련데이터, 공식경기영상으로 이용
④ IP Address, 쿠키, 방문일시, 서비스 이용 기록 : 서비스 이용과정이나 불량회원의 부정 이용 방지와 비인가 사용 방지
⑤ 유료 회원제 컨텐츠 서비스 및 “ㅋㅋ몰” 이용 시 이용 정보
A.  신용카드 결제시 : 카드사명, 암호회된 카드번호 등
B.  무통장 입금시 : 은행명, 암호화된 계좌번호 등
⑥ App 이용시 카메라 권한
A.  스포츠다이어리는 프로필사진을 교체를 위해 카메라를 사용합니다.
⑦ App 이용시 사진/영상/파일
A.  스포츠다이어리는 프로필사진 교체를 위해 사진/영상/파일을 사용합니다.

3. 수집하는 개인정보 항목 및 수집방법
회사는 이용자들이 회원서비스를 이용하기 위해 회원으로 가입하실 때 서비스 제공을 위한 필수적인 정보들을 온라인상에서 입력 받고 있습니다. 회원 가입 시에 받는 필수적인 정보는 이름, 연락처, 이메일, 소속 등입니다. 또한 양질의 서비스 제공을 위하여 이용자들이 선택적으로 입력할 수 있는 사항으로서 상대선수의 정보 등을 입력 받고 있습니다.
또한 게시판(홈페이지 또는 모바일) 혹은 개별공지(이메일 또는 SMS문자발송)를 통해 설문조사나 이벤트 행사 시 통계분석이나 경품제공 등을 위해 선별적으로 개인정보 입력을 요청할 수 있습니다.
그러나, 이용자의 기본적 인권 침해의 우려가 있는 민감한 개인정보(인종 및 민족, 사상 및 신조, 출신지 및 본적지, 정치적 성향 및 범죄기록, 건강상태 및 성생활 등)는 수집하지 않으며 부득이하게 수집해야 할 경우 이용자들의 사전동의를 반드시 구할 것입니다. 그리고, 어떤 경우에라도 입력하신 정보를 이용자들에게 사전에 밝힌 목적 이외에 다른 목적으로는 사용하지 않으며 외부로 유출하지 않습니다.

4. 수집하는 개인정보의 보유 및 이용기간
이용자가 스포츠다이어리 회원으로서 회사에 제공하는 서비스를 이용하는 동안 회사는 이용자들의 개인정보를 계속적으로 보유하며 서비스 제공 등을 위해 이용합니다. 다만, 아래의 "6. 이용자 자신의 개인정보관리(열람, 정정, 삭제 등)에 관한 사항" 에서 설명한 절차와 방법에 따라 회원 본인이 직접 삭제하거나 수정한 정보, 가입 해지를 요청한 경우에는 재생할 수 없는 방법에 의하여 디스크에서 완전히 삭제하며 추후 열람이나 이용이 불가능한 상태로 처리됩니다.
그리고 "3. 수집하는 개인정보 항목 및 수집방법"에서와 같이 일시적인 목적 (설문조사, 이벤트, 본인확인 등)으로 입력 받은 개인정보는 그 목적이 달성된 이후에는 동일한 방법으로 사후 재생이 불가능한 상태로 처리됩니다.
귀하의 개인정보는 다음과 같이 개인정보의 수집목적 또는 제공받은 목적이 달성되면 파기하는 것을 원칙으로 합니다. 다만, 회사는 불량 회원의 부정한 이용의 재발을 방지하기 위해, 이용계약 해지일로부터 1년간 해당 회원의 주민등록번호를 보유할 수 있습니다.
그리고 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.

가)  계약 또는 청약철회 등에 관한 기록
① 보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제6조 및 시행령 제6조
② 보존기간 : 5년
나)  대금결제 및 재화 등의 공급에 관한 기록
①  보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제6조 및 시행령 제6조
②  보존기간 : 5년
다) 소비자의 불만 또는 분쟁처리에 관한 기록
① 보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제6조 및 시행령 제6조
② 보존기간 : 3년
라) 신용정보의 수집, 처리 및 이용 등에 관한 기록
① 보존근거 : 신용정보의 이용 및 보호에 관한 법률
② 보존기간 : 3년
마) 접속에 관한 기록보존
① 보존근거 : 통신비밀보호법 제15조의2 및 시행령 제41조
② 보존기간 : 3개월
바) 회사는 귀중한 회원의 개인정보를 안전하게 처리하며, 유출의 방지를 위하여 다음과 같은 방법을 통하여 개인정보를 파기합니다.
① 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.
② 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.

5. 수집한 개인정보의 공유 및 제공
회사는 이용자들의 개인정보를 "2. 개인정보의 수집목적 및 이용목적"에서 고지한 범위 내에서 사용하며, 이용자의 사전 동의 없이는 동 범위를 초과하여 이용하거나 원칙적으로 이용자의 개인정보를 외부에 공개하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.

가)  이용자들이 사전에 공개에 동의한 경우
나)  서비스 제공에 따른 요금정산을 위하여 필요한 경우
다)  홈페이지 및 모바일에 게시한 서비스 이용 약관 및 기타 회원 서비스 등의 이용약관 또는 운영원칙을 위반한 경우
라)  자사 서비스를 이용하여 타인에게 정신적, 물질적 피해를 줌으로써 그에 대한 법적인 조치를 취하기 위하여 개인
정보를 공개해야 한다고 판단되는 충분한 근거가 있는 경우
마)  기타 법에 의해 요구된다고 선의로 판단되는 경우 (ex. 관련법에 의거 적법한 절차에 의한 정부/수사기관의 요청이 있는 경우 등)
바)  통계작성, 학술연구나 시장조사를 위하여 특정 개인을 식별할 수 없는 형태로 광고주, 협력업체나 연구단체 등에 제공하는 경우
사)  이용자의 서비스 이용에 따른 불만사항 및 문의사항(민원사항)의 처리를 위하여 고객센터를 위탁하는 경우
아)  고객센터를 운영하는 전문업체에 해당 민원사항의 처리에 필요한 개인 정보를 제공하는 경우
자)  대한유도회의 선수정보 관리, 대회 운영 및 관리에 필요한 정보를 제공하는 경우

6. 이용자 자신의 개인정보 관리(열람, 정정, 삭제 등)에 관한 사항
가)  회원님이 원하 실 경우 언제라도 당사에서 개인정보를 열람하실 수 있으며 보관된 필수 정보를 수정하실 수 있습니다.
나)  또한 회원 가입 시 요구된 필수 정보 외의 추가 정보는 언제나 열람, 수정, 삭제할 수 있습니다.
다)  회원님의 개인정보 변경 및 삭제와 회원탈퇴는 당사의 고객센터에서 로그인(Login) 후 이용하실 수 있습니다.

7. 쿠키(cookie)의 운영에 관한 사항
당사는 회원인증을 위하여 Cookie 방식을 이용하고 있습니다. 이는 로그아웃(Logout)시 자동으로 컴퓨터에 저장되지 않고 삭제되도록 되어 있으므로 공공장소나 타인이 사용할 수 있는 컴퓨터를 사용 하 실 경우에는 로그인(Login)후 서비스 이용이 끝나시면 반드시 로그아웃(Logout)해 주시기 바랍니다.

가)  쿠키 설정 거부 방법
쿠키 설정을 거부하는 방법으로는 회원님이 사용하시는 웹 브라우저의 옵션을 선택함으로써 모든 쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의 저장을 거부할 수 있습니다.
설정방법 예(인터넷 익스플로어의 경우) : 웹 브라우저 상단의 도구 > 인터넷 옵션 > 개인정보
단, 귀하께서 쿠키 설치를 거부하였을 경우 서비스 제공에 어려움이 있을 수 있습니다.

8. 개인정보관련 의견수렴 및 불만처리에 관한 사항
당사는 개인정보보호와 관련하여 이용자 여러분들의 의견을 수렴하고 있으며 불만을 처리하기 위하여 모든 절차와 방법을 마련하고 있습니다. 이용자들은 하단에 명시한 "11. 개인정보관리책임자 및 담당자의 소속-성명 및 연락처"항을 참고하여 전화나 메일을 통하여 불만사항을 신고 할 수 있고, 회사는 이용자들의 신고사항에 대하여 신속하고도 충분한 답변을 해드릴 것입니다.

9. 개인정보 관리책임자 및 담당자의 소속-성명 및 연락처
당사는 귀하가 좋은 정보를 안전하게 이용할 수 있도록 최선을 다하고 있습니다. 개인정보를 보호하는데 있어 귀하께 고지한 사항들에 반하는 사고가 발생할 경우 개인정보관리책임자가 책임을 집니다.

가)  이용자 개인정보와 관련한 아이디(ID)의 비밀번호에 대한 보안유지책임은 해당 이용자 자신에게 있습니다.
나)  회사는 비밀번호에 대해 어떠한 방법으로도 이용자에게 직접적으로 질문하는 경우는 없으므로 타인에게 비밀번호가 유출되지 않도록 각별히 주의하시기 바랍니다.
다)  특히 공공장소에서 온라인상에서 접속해 있을 경우에는 더욱 유의하셔야 합니다.
라)  회사는 개인정보에 대한 의견수렴 및 불만처리를 담당하는 개인정보 관리책임자 및 담당자를 지정하고 있고, 연락처는 아래와 같습니다.

개인정보관리 책임자
이름 : 유종갑
소속/직위 : 전산팀 / 이사
E-MAIL : jk.yoo@widline.co.kr
전화번호 : 02-715-0282

10. 고지의 의무
본 개인정보처리방침은 정부의 정책 또는 보안기술의 변경에 따라 개인정보취급방침 내용 추가,삭제 및 수정이 있을 시에는 개정 최소 7일전부터 개정 최소 7일전부터 홈페이지 또는 모바일을 통해 고지하도록 하겠습니다.

가)  개인정보취급방침 버전번호 : SD-16.12
나)  개인정보취급방침 시행일자 : 2017년 11월 01일

2016년 12월 01일부터 시행되던 종전의 약관은 본 약관으로 대체합니다.
          </pre>
        </dd>
      </dl>
      <dl class="panel">
        <dt class="panel-heading clearfix">
          <label class="panel-title bind_whole ic_check act_btn">
            <input type="checkbox" id="data_terms" name="data_terms" />
            <span class="txt">개인훈련 데이터 정보열람 활용 (필수)</span>
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
          </label>
          <a href="#target_3" data-toggle="collapse" class="target_btn"> <i class="fa fa-sort-desc" aria-hidden="true"></i> </a> </dt>
        <dd id="target_3" class="collapse">
          <pre class="panel-body">
선수의 개인 훈련데이터 열람조회 권한은 스포츠다이어리 서비스 가입에 등록한 선수본인, 소속팀 지도자, 가족 혹은 친척 보호자에게 함께 제공 되며, 선수가 입력한 훈련정보의 경우 선수 본인이 아닌 지도자 또는 보호자는 일부정보만 열람조회 가능합니다.

보호자는 스포츠다이어리의 데이터 열람조회 서비스를 받기 위해서 선수 본인에게 데이터 열람조회 권한 승인을 받아야 하며, 선수는 보호자로부터 받는 승인 요청문자의 승인번호를 알려줄 의무가 있습니다.

선수가 본인의 훈련데이터 정보열람 활용 내용에 대하여 “동의”버튼을 클릭하면 선수본인, 소속팀 지도자, 가족 혹은 친척 보호자에게 개인훈련데이터 정보를 열람조회 하는 것에 동의한 것으로 봅니다.

[열람조회 서비스 제공이 불가한 정보]
• 나의 일기 (지도자와 보호자 모두 열람조회 불가)
• 지도자 상담 (지도자는 별도 비밀번호 입력절차 후 열람가능)

[승인 인증절차 순서]
① 보호자로부터 선수 휴대폰에 승인번호 문자수신
② 문자의 승인번호를 보호자에게 알림
③ 승인번호를 입력하면 인증절차 완료

승인번호를 입력한 시기부터 보호자는 선수 데이터 열람서비스 이용이 가능합니다. (열람불가 정보 제외)

시행일자 : 이 약관은 2016년 12월 01일부터 적용됩니다.
          </pre>
        </dd>
      </dl>
      <dl class="panel">
        <dt class="panel-heading clearfix">
          <label class="panel-title bind_whole ic_check act_btn">
            <input type="checkbox" id="market_terms" name="market_terms" />
            <span class="txt">마케팅 정보 수신 동의 (필수)</span>
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
          </label>
          <a href="#target_4" data-toggle="collapse" class="target_btn"> <i class="fa fa-sort-desc" aria-hidden="true"></i> </a> </dt>
        <dd id="target_4" class="collapse">
          <pre class="panel-body">
<strong>수집 목적</strong>
대회정보, 선수정보, 신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 인구통계학적 특성에 따른 서비스 제공 및 광고 게재, 서비스의 유효성 확인, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계, 이벤트 참여 기회 제공, app push 발송

<strong>수집 항목</strong>
성명, 생년월일, 배송주소, 이메일, 휴대폰번호, 앱단말ID

<strong>보유 기간</strong>
별도 동의 철회 시까지 또는 약관 철회 후 1주일 까지

*선택적 정보 수집에 대한 동의를 거부하실 수 있으며, 거부하시더라도 회원가입, 스포츠 다이어리 이용, 상품 구매 등 기본 서비스 이용에는 제한을 받지 않습니다.
단, 부가서비스 이용은 제한 될 수 있습니다.

※ 본 약관내에는 영리목적 광고성 정보 수신동의에 관한 사항이 포함되어있습니다.


          </pre>
        </dd>
      </dl>
    </section>
    <!-- E: list-group -->

    <div class="cta"> <a href="javascript:chk_Submit();" class="btn btn-ok btn-block">다음</a> </div>
  </div>
  <!-- E: main -->
</form>
<!-- #include file='./include/footer.asp' -->

</div>
</body>
</html>
