<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<!-- #include virtual = "/home/payment/include/signature.asp"-->
<!-- #include virtual = "/home/payment/include/function.asp"-->

<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
    <script src="/pub/js/swimming/gameatt.js?v=190820"></script>
	  <!-- 테스트 JS(샘플에 제공된 테스트 MID 전용) -->

	<script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
	<script language='javascript'>

	</script>
</head>


<%
leaderinfo = request.Cookies("leaderinfo")
If leaderinfo <> "" And session("chkrndno") = "" Then

	Set leader = JSON.Parse( join(array(leaderinfo)) )
	s_team =  leader.Get("a")
	s_username =  leader.Get("b")
	s_birthday = leader.Get("c")
	s_userphone =  leader.Get("d")
	s_tidx = leader.Get("e")
	s_idx = leader.Get("f")


'Session.Timeout= 40 '여긴 40분
'leaderinfo = session("leaderinfo") '시간되면 만료되니까
'If isArray(leaderinfo) = True And session("chkrndno") = "" Then
'
'	s_team =  leaderinfo(0)
'	s_username =  leaderinfo(1)
'	s_birthday =  leaderinfo(2)
'	s_userphone =  leaderinfo(3)
'	s_tidx = leaderinfo(4)
'	s_idx = leaderinfo(5)

	'session("leaderinfo") = "" '새로고침 막음용
Else
	Response.redirect "/home/page/list-pro.asp"
	Response.end
End If

	'$$$$$$$$$
		teamcd = F1 '팀코드
		Set db = new clsDBHelper


		'결제완료된게 있는지 확인한후 뒤로 가도록 조치
		SQL = "select  oOrderState from  tblSwwimingOrderTable where oOrderState = '01' and gubun = '1' and gametitleidx = '" & s_tidx & "' and  team = '"&s_team&"'  and leaderidx = '"&s_idx&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			Response.redirect "/home/page/list-pro.asp"
			Response.end
		End if




		'게임정보 (종목당 2명이상참가제한, 선수별 최대 참가종목 가능수)
		SQL = "select  gametitlename,games,gamee,teamLimit,attgameCnt,gamearea,attmoney from sd_gameTitle where delyn = 'N' and gametitleidx = '" & s_tidx & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			title = rs(0)
			games = Replace(Left(rs(1),10),"-",".")
			gamee = Replace(Left(rs(2),10),"-",".")
			gamearea = rs(5)
			attmoney = rs(6)
		End if


		'리더정보
		SQL = "Select team,teamnm  from tblReader where idx = '"&s_idx&"' "
		'Response.write SQL
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'여러팀의 리더일수 있다.

		If Not rs.EOF Then
			arrR = rs.GetRows()
			teamnm = arrR(1,0)
			SQL = "select team,teamnm,fileUrl from  sd_schoolConfirm  where gametitleidx = '"&s_tidx&"' and team = '"&teamcd&"'   and leaderidx = '"&s_idx&"'  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				furl = rs(2)
				fnm = LCase(Mid(furl, InStrRev(furl, "/") + 1))
				filestr = 	"<a href=""http://upload.sportsdiary.co.kr/sportsdiary"&furl&""" target=""_blank"">" & fnm & "</a>"
			End if
		End If



		'추가된 선수들
		fldboo = " ,(SELECT  STUFF(( select ','+ CDCNM from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM for XML path('') ),1,1, '' )) as cdcnm "
		fld = " a.playeridx,a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass,a.seq " & fldboo & ", a.payOK , (SELECT  STUFF(( select ','+ isnull(capno,'x')  from tblGameRequest_imsi_r where seq  = a.seq group by CDCNM,capno for XML path('') ),1,1, '' )) as capno "
		SQL = "Select "&fld&" from tblGameRequest_imsi as a  where a.team = '"&teamcd&"' and a.tidx = '"&s_tidx&"'  and a.leaderidx = '"&s_idx&"'  "

'################################################
'테스트 2021 5 26
'################################################
If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" Then
'	Response.write sql
'	Response.end
End if
'################################################



		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	  If Not rs.EOF Then
		arrP = rs.GetRows()
	  End If
	'$$$$$$$$$

'##############################################
' 소스 뷰 경계
'##############################################
%>
<body <%=CONST_BODY%>>
	<div id="printdiv" style="width:0px;height:0px;display:none;"><%'인쇄할내용여기로 불러와%></div>

	<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>


	<form id="SendPayForm_id"  method="POST" action="http://swimadmin.sportsdiary.co.kr/home/payment/INIStdPayReturn.asp">
    <!-- s 헤더 영역 -->
      <header class="l_header">
        <div class="l_header-wrap clear">
          <h1 class="l_header__con">
            참가신청서 작성
          </h1>
          <a href="http://sw.sportsdiary.co.kr/home/helpmenual.pdf" class="l_header__manual" target="_blank" >메뉴얼</a>
        </div>
      </header>
    <!-- e 헤더 영역 -->

    <!-- s 메인 영역 -->
      <div class="l_main">
        <section class="l_main__contents">


<div class="m_apply-parti t_pay">
  <div class="m_apply-parti__header">
	<h1 class="m_apply-parti__header__con"><%=title%></h1>
	<span><%=games%> ~ <%=gamee%> (<%=gamearea%>)</span>
<!--     <button class="m_apply-parti__header__btn-print t_pay" type="button" name="button" onclick="$('#printarea').printThis({importCSS: false,loadCSS: '/pub/js/print/print_swim.css',header: '<h1><%=title%></h1>'});">참가신청정보출력</button> -->
		  <button  class="m_apply-parti__header__btn-print t_pay" type="button"  name="button" onclick="javascript:mx.print(<%=s_tidx%>,'<%=teamcd%>');">참가신청정보출력</button>
  </div>

  <ul class="m_apply-parti__con">
    <li class="m_apply-parti__con__list">
      <h2 class="m_apply-parti__con__list__h2">팀(소속) 정보</h2>
      <ul class="m_apply-parti__con__list__ul clear">
        <li>
          <h3>팀명</h3>
          <span><%=teamnm%></span>
        </li>
        <li>
          <h3>팀코드</h3>
          <span><%=teamcd%></span>
        </li>
      </ul>
      <p class="m_apply-parti__con__list__noti t_pay">※ 대한체육회에 등록되어 있는 지도자 정보를 불러옵니다. 정보가 맞지 않을 경우 대한체육회에 접속하여 정보 수정 후 참가신청을 진행해주세요.</p>
    </li>
    <li class="m_apply-parti__con__list">
      <h2 class="m_apply-parti__con__list__h2">신청자 정보</h2>
      <ul class="m_apply-parti__con__list__ul clear">
        <li>
          <h3>이름</h3>
          <span><%=s_username%></span>
        </li>
        <li>
          <h3>연락처</h3>
          <span><%=s_userphone%></span>
        </li>
      </ul>
    </li>
    <li class="m_apply-parti__con__list t_pay">
      <h2 class="m_apply-parti__con__list__h2">학교장 확인서 첨부</h2>
      <div class="m_apply-parti__con__list__file clear">
        <span>첨부파일</span>
        <div class="m_apply-parti__con__list__file__inp-box">
          <input id="inpFileApply" type="file">
        </div>
        <label for="inpFileApply">파일첨부</label>
        <button id="btnInpFileDel" type="reset" name="button">삭제</button>
        <p class="m_apply-parti__con__list__file__noti">(업로드 파일형식 : pdf, jpg, png, hwp 등)</p>
      </div>
      <ul class="m_apply-parti__con__list__ul t_pay clear">
        <li>
          <h3>첨부파일</h3>
          <span><%=filestr%></span>
        </li>
      </ul>
    </li>

	<li class="m_apply-parti__con__list t_pay">
      <h2 class="m_apply-parti__con__list__h2">출전 정보</h2>
      <div class="m_apply-parti__con__list__tbl-box">

		<table class="m_apply-parti__con__list__tbl">
        </table>

        <table class="m_apply-parti__con__list__tbl t_pay" id="printarea">
          <caption>출전정보 확인 표</caption>
          <thead class="m_apply-parti__con__list__tbl__thead">
            <tr>
              <th scope="col">No</th>
              <th scope="col">이름</th>
              <th scope="col">생년월일</th>
              <th scope="col">성별</th>
              <th scope="col">종별</th>
              <th scope="col">학년</th>
			  <th scope="col">세부종목</th>
            </tr>
          </thead>
          <tbody class="m_apply-parti__con__list__tbl__tbody">
            <%
				mrr_count = 0
				If IsArray(arrP) Then
					For ari = LBound(arrP, 2) To UBound(arrP, 2)
					a_pidx = arrP(0, ari)
					a_nm = arrP(1, ari)
					a_birth = arrP(2, ari)
					a_sex = arrP(3, ari)
					If a_sex = "1" Then
						a_sexstr = "남"
					Else
						a_sexstr = "여"
					End if
					a_CDB = arrP(4, ari)
					a_CDBNM = arrP(5, ari)
					a_userclass = isnulldefault(arrP(6, ari),"")
					a_seq = arrP(7,ari)

					a_cdcnm = arrP(8,ari)
					a_payOk = arrP(9,ari)
					a_capno = arrP(10,ari)
					If a_payOk = "Y" Then
						paystr = "[결제]"
					Else
						paystr = ""
					End If

					If InStr(a_CDBNM,"초등") > 0 then
						If CDbl(a_userclass) < 5 Then
							a_CDBNM = Replace(a_CDBNM , "초등", "유년")
						End if
					End if

					%>
						<tr>
						  <td><%=ari+ 1%></td>
						  <td><%=a_nm%> <%=paystr%></td>
						  <td><%=a_birth%></td>
						  <td><%=a_sexstr%></td>
						  <td><%=a_CDBNM%></td>
						  <td><%=a_userclass%></td>
						  <td class = "t_multi t_left">
							<%If a_cdcnm <> "" Then
								a_cdcnmarr = Split(a_cdcnm,",")
							%>
							<ul>

							  <%
		  					  chkgrp = "grp" '계영만있는지 체크 (계영만있음기본)
							  for n = 0 To ubound(a_cdcnmarr)
							  If InStr(a_cdcnmarr(n),"계영") > 0 Then
							  Else
  								chkgrp =  "notgrp"
							  End if
							  %>

							  <li id='li_kind_<%=a_seq%>_<%=n%>'>
								<%If a_cdcnmarr(n) = "수구" then%>
									<%
									If  a_capno <> "" Then
									a_capnoarr = Split(a_capno,",")
									%>
									<span><%=a_cdcnmarr(n)%> no.<%=a_capnoarr(n)%></span>
									<%else%>
									<span><%=a_cdcnmarr(n)%></span>
									<%End if%>
								<%else%>
									<span><%=a_cdcnmarr(n)%></span>
								<%End if%>
							  </li>
							  <%next%>

							</ul>
							<%End if%>
						  </td>

						</tr>
					<%
					'결제자 제외 / 계영만참가자 제외
					'If a_payOK = "N" And chkgrp = "notgrp" then 'Y인경우가 있다 내용은 찾아봐야겠지만 일딴 여기까지 왔으면 결제 명수에는 포함되어야한다. 넣자...21.05.28
					If chkgrp = "notgrp" then
					mrr_count = mrr_count + 1
					End if
					Next

'################################################
'테스트 2021 5 26
'################################################
If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" Then
	'Response.write a_payOK & "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
End if
'################################################


				End if
			%>
          </tbody>
        </table>
      </div>
    </li>

	
	
	<li class="m_apply-parti__con__list-pay t_pay">
      <%
		'결제 수단 선택
		'ex) Card (계약 결제 수단이 존재하지 않을 경우 에러로 리턴)
		'사용 가능한 입력 값 :	Card,DirectBank,HPP,Vbank,kpay,Swallet,Paypin,EasyPay,PhoneBill,GiftCard,EWallet,onlypoint,onlyocb,onyocbplus,onlygspt,onlygsptplus,onlyupnt,onlyupntplus

		'<option value="DirectBank">실시간 계좌이체</option>
		%>
	  <div class="m_apply-parti__con__list__header">
        <h2>결제방식:</h2>
        <div class="m_selc-box">
            <select id="gopaymethod" name="gopaymethod">
      			<option value="">결제방식 선택</option>
      			<option value="Card">카드결제</option>
      			<option value="Vbank">실시간 계좌이체</option>
      			<option value="HPP">휴대폰결제</option>
      		</select>
        </div>

	  </div>
      <span class="m_apply-parti__con__list__span">1인 참가비 : <%=FormatNumber(attmoney,0)%> 원</span>
      <ul class="m_apply-parti__con__list__pay t_pay clear">
        <li>
          <span>결제 여부</span>결제 전
        </li>
        <li>
          <span>총 인원 수</span><%=mrr_count%>명
        </li>
        <li>
          <span>총 참가비</span><%=mrr_count%> X <%=FormatNumber(attmoney,0)%> = <em><%=FormatNumber(attmoney * mrr_count,0)%></em> 원
        </li>
        <li>
          <span>미 결제 금액</span><strong><em id="last_price"><%=FormatNumber(attmoney * mrr_count,0)%></em> 원</strong>
          <!--button id="btnPayment" type="button" name="button">참가비 결제</button-->
        </li>
      </ul>
    </li>
  </ul>

  <div class="m_apply-parti__footer t_pay clear">
    <div class="m_apply-parti__footer__left-group">
<!--     <button id="btnGoList" type="button" name="button" onclick="px.goSubmit({},'/home/page/list-pro.asp')">리스트 가기</button> -->
<!-- 	  <button id="btnApplyPrint" type="button" name="button"   onclick="$('#printarea').printThis({importCSS: false,loadCSS: '/pub/js/print/print_swim.css',header: '<h1><%=title%></h1>'});">참가신청정보출력</button> -->



	</div>
    <div class="m_apply-parti__footer__right-group">
      <button id="btnRetouchApply" type="button" name="button" onclick="px.goSubmit({},'/home/page/apply-parti.asp')">정보 수정</button>
      <button id="btnCompleteApplyPay" type="button" name="button" >신청 완료</button>
    </div>
  </div>
</div>
        </section>
      </div>
    <!-- e 메인 영역 -->


	<!-- s 팝업창 영역 -->
      <!-- div.s_show = 팝업창 보이게 -->
      <div class="l_modal-wrap" id="applyCompleteModal">
        <div class="l_modal">
          <section class="m_modal-apply-noti t_alert">
            <span class="m_modal-apply-noti__header">대회 참가신청 완료</span>
            <span class="m_modal-apply-noti__con">참가 신청이 완료되었습니다.</span>
            <div class="m_modal-apply-noti__btns clear">
              <button onclick="closeModal()" id="btnOk-ApplyCancelModal" type="button" name="button">확인</button>
            </div>
          </section>
        </div>
      </div>
    <!-- e 팝업창 영역 -->

	<%

	'*** 위변조 방지체크를 signature 생성 ***
	'* timestamp는 반드시 signature생성에 사용한 timestamp 값을 timestamp input에 그대로 사용하여야함
	'############################################
	' 1.전문 필드 값 설정(***가맹점 개발수정***)
	'############################################

	' 여기에 설정된 값은 Form 필드에 동일한 값으로 설정
		'maid						= "INIpayTest"										' 가맹점 ID(가맹점 수정후 고정)
		maid						="swsportsdi"
		'인증
		'signKey					= "SU5JTElURV9UUklQTEVERVNfS0VZU1RS"				' 가맹점에 제공된 웹 표준 사인키(가맹점 수정후 고정) test
		signKey					= "Z1NGZDJSd0M2T3RXVzdZayt0SDA1UT09"
		'timestamp				= time_stamp()
		correct 					= "09"								                ' 표준시와의 차이를 2자리 숫자로 입력 (예: 대한민국은 표준시와 9시간 차이이므로 09)
		timestamp				= time_stamp(correct)
		oid							= maid&"_"&timestamp								' 가맹점 주문번호(가맹점에서 직접 설정)

		price						= attmoney * mrr_count 							' 상품가격(특수기호 제외, 가맹점에서 직접 설정)
		'price						= 10


		cardQuotaBase		= "2:3:4:5:6:11:12:24:36"							' 가맹점에서 사용할 할부 개월수 설정

		'###############################################
		' 2. 가맹점 확인을 위한 signKey를 해시값으로 변경 (SHA-256방식 사용)
		'###############################################
		mKey = MakeSignature(signKey)

		'###############################################
		' 2.signature 생성
		'###############################################

		signParam = "oid="&oid
		signParam = signParam&"&price="&price
		signParam = signParam&"&timestamp="&timestamp

		' signature 데이터 생성 (모듈에서 자동으로 signParam을 알파벳 순으로 정렬후 NVP 방식으로 나열해 hash)
		signature = MakeSignature(signParam)


		' 페이지 URL에서 고정된 부분을 적는다.
		' Ex) returnURL이 http://test.inicis.com/INIpayStdSample/INIStdPayReturn.jsp 라면
		' http://test.inicis.com/INIpayStdSample 까지만 기입한다.

		siteDomain = "http://swimadmin.sportsdiary.co.kr/home/payment" '가맹점 도메인 입력

	%>
		<input type="hidden"  name="version" value="1.0" >
		<input type="hidden"  name="mid" value="<%=maid%>" >
		<input type="hidden"  name="goodname" value="<%=title%>" >
		<input type="hidden"  name="oid" value="<%=oid%>" >
		<input type="hidden"  name="currency" value="WON" >
		<input type="hidden"  name="buyername" value="<%=s_username%>" >
		<input type="hidden"  name="buyertel" value="<%=s_userphone%>" >
		<input type="hidden"  name="buyeremail" value="" >
		<input type="hidden"  name="timestamp" value="<%=timestamp%>" >
		<input type="hidden"  name="signature" value="<%=signature%>" >
		<input type="hidden"  name="returnUrl" value="<%=siteDomain%>/INIStdPayReturn.asp" >
		<input type="hidden"  name="mKey" value="<%=mKey%>" >

		<!--***** 기본 옵션 *****-->
		<input type="hidden"  name="offerPeriod" value="" ><!-- 20150101-20150331 제공기간-->
		<input type="hidden"  name="acceptmethod" value="CARDPOINT:HPP(2):no_receipt:va_receipt:vbanknoreg(0):below1000" >

		<!--***** 표시 옵션 *****-->
		<!--초기 표시 언어	[ko|en] (default:ko)-->
		<input type="hidden"  name="languageView" value="" >
		<!--charset : 리턴 인코딩 [UTF-8|EUC-KR] (default:UTF-8)-->
		<input type="hidden"  name="charset" value="UTF-8" >
		<!--payViewType : 결제창 표시방법 [overlay] (default:overlay) -->
		<input type="hidden"  name="payViewType" value="" >
		<input type="hidden"  name="closeUrl" value="<%=siteDomain%>/close.asp" >
		<input type="hidden"  name="popupUrl" value="<%=siteDomain%>/popup.asp" >


		<!-- 카드(간편결제도 사용)  -->
		<!--quotabase : 할부 개월 설정 ex) 2:3:4 -->
		<input type="hidden"  name="quotabase" value="<%=cardQuotaBase%>" >
		<!--nointerest : 무이자 개월 설정 ex) 11-2:3:,34-5:12,14-6:12:24,12-12:36,06-9:12,01-3:4 -->
		<input type="hidden"  name="nointerest" value="" >
		<!--ini_cardcode : 카드 코드 설정 ex) 11:12:14 -->
		<input type="hidden"  name="ini_only_cardcode" value="" >
		<!---- 가상계좌 ---->
		<!--INIregno : 주민번호 설정 기능 13자리(주민번호),10자리(사업자번호),미입력시(화면에서입력가능)-->
		<input type="hidden"  name="INIregno" value="" >
		<!--***** 추가 옵션 *****-->

		<!--merchantData : 가맹점 관리데이터(2000byte) **인증결과 리턴 시 함께 전달됨(한글 지원 안됨, 개인정보 암호화(권장)) -->

		<%
			encodedata = f_enc(s_tidx&s_team&"SW"&s_idx)
		%>

		<input type="hidden"  name="merchantData" value="<%=encodedata%>" ><%'=s_idx%>
		<input type="hidden"  name="price" id="price" value="<%=price%>" >
		<input type="hidden"  name="attmoney" id="attmoney" value="<%=attmoney%>" >
		
	</form>




	<script>
      // 버튼이벤트
        $('button').on('click',function(){
          console.log($(this).attr('id') + ' click!');
        });

		$('#btnCompleteApplyPay').on('click', function(){



		//참가금액이 0원 셋팅이라면 바로 신청완료 21.11.22 .
		if (document.getElementById("attmoney").value == '0'){
			document.getElementById("SendPayForm_id").action="http://swimadmin.sportsdiary.co.kr/home/payment/RegFree.asp";
			document.getElementById("SendPayForm_id").submit();
			return;
		}



		  // var last_price = document.getElementById("last_price").innerHTML.replace(/,/gi,'');
		  // document.getElementById('price').value = last_price;

		   var gopaymethod = document.getElementById("gopaymethod")

		   switch (gopaymethod)
		   {
		   case "Card": document.getElementById("acceptmethod").value = "BILLAUTH(card):FULLVERIFY"; break;
		   case "DirectBank": break;
		   case "HPP": document.getElementById("acceptmethod").value = "BILLAUTH(HPP):HPP(1)"; break;
		   }


		   var price	= document.getElementById("price")
		   if (gopaymethod.value =='')
		   {
			   alert('결제방식을 선택해 주시기 바랍니다');
			   gopaymethod.focus();
			   return false;
		   }


		//테스트 상태 바로 저장으로 가자...
		document.getElementById("SendPayForm_id").submit();



//          $('#applyCompleteModal').fadeIn(300);
//          $('body').addClass('s_no-scroll');
        });

		function closeModal(){
          $('.l_modal-wrap').fadeOut(300);
          $('body').removeClass('s_no-scroll');
        }
      </script>
  </body>
</html>
