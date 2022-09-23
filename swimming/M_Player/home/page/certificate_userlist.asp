<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<!--#include virtual ="/home/payment/include/function.asp"-->
<!--#include virtual ="/home/payment/include/signature.asp"-->
<!--#include virtual ="/home/payment/include/aspJSON1.17.asp"-->
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
    <script src="/js/swimming/certificate.js?v=190820"></script>
	<script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
	<script type="text/javascript" src="/pub/js/print/printThis.js?v=1.1.2"></script>		
</head>


<%
'#####################################
'인쇄 요청페이지
'#####################################

'CHKNO: "6690"
'CMD: 200
'CTYPE: "1"
'NM: "백승훈"
'PNO: "01047093650"
'result: "0"


reqv = request("p")
playerinfo = request.Cookies("playerinfo")

If reqv <> "" Then
	If reqv = "1" Then
		title = "대회참가확인서"
		price = 100
	else
		Set reqobj = JSON.Parse( join(array(reqv)) )
		s_certificatetype = reqobj.Get("CTYPE") '출력물 타입 1,2
		If  s_certificatetype = "1" Then
			title = "대회참가확인서"
			price = 100
		Else
			title = "선수실적증명서"
			price = 200
		End If
	End if
End If



If playerinfo <> "" And session("chkrndno") = "" And title <> "" Then

	playerinfo = f_dec(playerinfo)
	Set playerobj = JSON.Parse( join(array(playerinfo)) )

	s_team =  playerobj.Get("a")
	s_username =  playerobj.Get("b")
	s_birthday = playerobj.Get("c")
	s_userphone =  playerobj.Get("d")
	s_pidx = playerobj.Get("e")
	s_skey = playerobj.Get("f")
	s_lastregyear = playerobj.Get("g")


Else
	Response.write  "잘못된 접속입니다."
	Response.end
End if




	Set db = new clsDBHelper
	'등록된 선수인지 확인 한다. (엘리트만)
	SQL = "Select teamnm,entertype,email,team,username,birthday,userphone,playeridx,kskey,nowyear from tblPlayer where playeridx = "&s_pidx&" "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		teamnm = rs(0)
		entertype = rs(1)
		uemail = rs(2)
	End if

	'참가확인서 발급요건 확인 기본 1로 온다. (경영만 넣어두었다 일딴 다른건 기록에 들어가면 하자)
	If s_pidx = "53865" then
	SQL = "select max(rcIDX), max(gametitleidx),max(titlecode), titlename, max(gamedate) "
	SQL = SQL & " from tblRecord  where delyn = 'N' and  ( playeridx = 48565 or playeridx2 = 48565 or playeridx3 = 48565 or playeridx4 = 48565 )  group by titlename order by 5 desc "
	Else
	SQL = "select max(rcIDX), max(gametitleidx),max(titlecode), titlename, max(gamedate) "
	SQL = SQL & " from tblRecord  where delyn = 'N' and  and ( playeridx = "&s_pidx&" or playeridx2 = "&s_pidx&" or playeridx3 = "&s_pidx&" or playeridx4 = "&s_pidx&" )  group by titlename order by 5 desc "
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	'일딴 올해 년도만 우선 보여주고..
	If Not rs.eof Then
		arrP = rs.GetRows()
		s_year = Left(arrP(4, 0 ),4)
		e_year = Left(arrP(4, ubound(arrP,2)) , 4)
	End if


	'결제정보체크
		SQL_Order = "Select info3 From tblSwwimingOrderTable "
		SQL_Order = SQL_Order & " Where del_yn = 'N'  "
		SQL_Order = SQL_Order & " and gametitleidx = '0'	"
		SQL_Order = SQL_Order & " and LeaderIDX = '"&s_pidx&"'  and gubun = '2'  and oorderstate in ( '01', '00') and  reg_date >= '"&date&"'  and reg_date < '"& date+1 &"' " '가상계좌이고 00 결제전이 있어도 결제되면 안됨
		Set rs = db.ExecSQLReturnRS(SQL_Order , null, ConStr)
		
		Do Until rs.eof 
			If rs(0) = "1" Then
				todaypay1 = "1" '오늘 참가신청 결제한 내역 있음
			End If
			If rs(0) = "2" Then
				todaypay2 = "1" '오늘 실적 결제한 내역 있음
			End if
		rs.movenext
		loop
		
'##############################################
' 소스 뷰 경계
'##############################################
%>
<body <%=CONST_BODY%>>
<%'=SQL_Order%>
	<div id="printdiv" style="display:none;"><%'인쇄할내용여기로 불러와%></div>
	<form method='post' name='sform'><input type='hidden' name='p'></form>
	<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>


	<form id="SendPayForm_id"  method="POST" >

    <!-- s 헤더 영역 -->
      <header class="l_header">
        <div class="l_header-wrap clear">
          <h1 class="l_header__con">
            증명서발급
          </h1>
          <button id="btnOpenManual" class="l_header__manual" type="button" name="button">메뉴얼</button>
        </div>
      </header>
    <!-- e 헤더 영역 -->




    <!-- s 메인 영역 -->
      <div class="l_main">
        <section class="l_main__contents">


			<div class="m_apply-parti">
			  <div class="m_apply-parti__header">
				<h1 class="m_apply-parti__header__con" id="ctitle"><%=title%></h1>

			  </div>


<form id="SendPayForm_id"  method="POST" >
<input type="hidden" id="todaypay1" value="<%=todaypay1%>">
<input type="hidden" id="todaypay2" value="<%=todaypay2%>">
<%
If IsArray(arrP) Then
	gubun2msg =  s_year & "년도부터 " & e_year & "년도 사이의실적이 있습니다."
	Response.write "<input type='hidden' id='gubun2check' vlaue='1'>"
Else
	gubun2msg =  "기록 된 실적을 찾을 수 없습니다."
	Response.write "<input type='hidden'  id='gubun2check' vlaue='2'>"
End if
%>



			  <ul class="m_apply-parti__con">
				<li class="m_apply-parti__con__list t_no-bb">
				  <h2 class="m_apply-parti__con__list__h2">신청자 정보</h2>

				  <ul class="m_apply-parti__con__list__ul clear">
					<li>
					  <h3>신청자이름</h3>
						  <div ><%=s_username%></div>
					</li>
					<li>
					  <h3>생년월일</h3>
					  <span ><%=s_birthday%></span>
					</li>

					<li>
					  <h3>팀명</h3>
						  <div ><%=teamnm%></div>
					</li>
					<li>
					  <h3>팀코드</h3>
					  <span ><%=s_team%></span>
					</li>
				  </ul>
				</li>





				<li class="m_apply-parti__con__list t_no-bb" id="gubun1">
				  <h2 class="m_apply-parti__con__list__h2">출력정보선택</h2>
				  <ul class="m_apply-parti__con__list__ul clear">
					<li>

						 <div class="m_multi-selc-box" id="gamey" onclick="mx.multiSelectBox($(this))">
						 <button class="m_multi-selc-box__result"  id="ytotal" type="button"><%=s_year%></button>
						 <ul>
							<%
							If IsArray(arrP) Then
								For yy = s_year To e_year Step -1 '높 > 낮
							%>
							<li class="m_multi-selc-box__list <%If CStr(yy) = CStr(s_year) then%>s_selected<%End if%>">
							   <button type="button" onclick="mx.SelectValue($(this), '<%=yy%>' ,<%=s_pidx%>, 1)"><%=yy%></button>
							</li>
							<%
								next
							End if
							%>
						 </ul>
						</div>

					</li>
			
					<li id="gametitlearea">
					 <div class="m_multi-selc-box t_w100per" id="gametitle" onclick="mx.multiSelectBox($(this))">
                     <button class="m_multi-selc-box__result"  id="selectgame" type="button">대회를 선택해주십시오.</button>
					 <ul>
						<%
						If IsArray(arrP) Then
							For aa = LBound(arrP, 2) To UBound(arrP, 2) 
 								m_key = arrP(0, aa)
 								m_title = arrP(3, aa)
 								m_date = arrP(4, aa)
							If CStr(s_year) = Left(m_date,4) then
						%>
						<li class="m_multi-selc-box__list">
                           <button type="button" onclick="mx.SelectValue($(this), '<%=m_key%>' ,<%=s_pidx%>, 2)"><%=m_title%></button>
                        </li>
						<%
							End if
							next
						End if
						%>
                     </ul>
					</div>
					</li>

				  </ul>
				</li>


				<li class="m_apply-parti__con__list t_no-bb" id="gubun2" style="display:none;">

				  <h2 class="m_apply-parti__con__list__h2">대회실적</h2>
				  <ul class="m_apply-parti__con__list__ul clear t_w100per">
					<li>
					<%=gubun2msg%>
					</li>
				  </ul>
				</li>



				<li class="m_apply-parti__con__list t_no-bb">
				  <h2 class="m_apply-parti__con__list__h2">발급정보</h2>
				  <ul class="m_apply-parti__con__list__ul clear">
					<li>
					  <h3>발급용도</h3>
					  <span><input id="c1"  type="text"  onblur="mx.setCInfo(<%=s_pidx%>)"></span>
					</li>
					<li>
					  <h3>제출처</h3>
					  <span><input id="c2"  type="text"  onblur="mx.setCInfo(<%=s_pidx%>)"></span>
					</li>
				  </ul>
				</li>




				<li class="m_apply-parti__con__list-pay t_pay">
<!-- 				  <span class="m_apply-parti__con__list__span">1인 참가비 : 100 원</span> -->
				  <ul class="m_apply-parti__con__list__pay t_pay clear">
					<li>
                  <div class="m_selc-box">
                     <select id="c3" name="c3" onchange="mx.setCInfo(<%=s_pidx%>)">
                        <option value="1" >대회참가확인서</option>
                        <option value="2" >선수실적증명서</option>
                     </select>
                  </div>
					</li>
					<li>
						<%
						'결제 수단 선택
						'ex) Card (계약 결제 수단이 존재하지 않을 경우 에러로 리턴)
						'사용 가능한 입력 값 :	Card,DirectBank,HPP,Vbank,kpay,Swallet,Paypin,EasyPay,PhoneBill,GiftCard,EWallet,onlypoint,onlyocb,onyocbplus,onlygspt,onlygsptplus,onlyupnt,onlyupntplus
						%>
	                  <div class="m_selc-box">
						<select id="gopaymethod" name="gopaymethod">
							<option value="">결제방식 선택</option>
							<option value="Card">카드결제</option>
							<option value="Vbank">가상계좌</option>
							<option value="HPP">휴대폰결제</option>
						</select>
						</div>
					</li>
					<li>
						 <span>결제 금액</span><strong><em id="last_price"><%=FormatNumber(price,0)%></em> 원</strong>
					</li>
					<li>
							<div class="m_apply-parti__footer__right-group">
							  <button class="t_preview" id="preprint" type="button" name="button"  onclick="javascript:mx.printpre(<%=s_pidx%>);">미리보기</button>
							  <button id="btnCompleteApplyPay" type="button" name="button" >결제하기</button>
							</div>
					</li>
				  </ul>
				</li>
			  </ul>


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

		price						= price					 							' 상품가격(특수기호 제외, 가맹점에서 직접 설정)


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

		siteDomain = "https://sw.sportsdiary.co.kr/home/payment" '가맹점 도메인 입력

	%>
		<input type="hidden"  name="version" value="1.0" >
		<input type="hidden"  name="mid" value="<%=maid%>" >
		<input type="hidden"  name="goodname" value="<%=title%>" >
		<input type="hidden"  name="oid" value="<%=oid%>" >
		<input type="hidden"  name="currency" value="WON" >
		<input type="hidden"  name="buyername" value="<%=s_username%>" >
		<input type="hidden"  name="buyertel" value="<%=s_userphone%>" >
		<input type="hidden"  name="buyeremail" value="<%=uemail%>" >
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
			encodedata = f_enc("-:-"& s_pidx)
		%>

		<input type="hidden"  name="merchantData" value="<%=encodedata%>" >
		<input type="hidden"  name="price" id="price" value="<%=price%>" >
</form>






			  <ul class="m_apply-parti__con">

			  <%
			  '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
				  SQL_Order_rs = "Select  "
				  SQL_Order_rs = SQL_Order_rs & "  OrderIDX " '텓이블의 id값
				  SQL_Order_rs = SQL_Order_rs & " ,OR_NUM " '주문번호
				  SQL_Order_rs = SQL_Order_rs & " ,case when OorderPayType = 'Card' then '카드' "
				  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'DirectBank' then '실시간계좌이체' "
				  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'VBank' then '가상' "
				  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'HPP' then '휴대폰' end as pay_type " '결제종류

				  SQL_Order_rs = SQL_Order_rs & " ,case when OorderState ='00' then '입금대기'  " ' 결제상태 미입금
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='01' then '결제완료' " ' 결제상태 입금
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='88' then '취소요청중' "
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='89' then '취소완료' "
				  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='99' then '결제취소' end as order_state " ' 결제상태 취소
				  SQL_Order_rs = SQL_Order_rs & " ,OorderState As order_code	"
				  SQL_Order_rs = SQL_Order_rs & " ,isnull(OrderPrice,0)as OrderPrice	"
				  SQL_Order_rs = SQL_Order_rs & " ,Order_tid "
				  SQL_Order_rs = SQL_Order_rs & " ,Order_MOID "
				  SQL_Order_rs = SQL_Order_rs & " ,reg_date "
				  SQL_Order_rs = SQL_Order_rs & " ,vactbankname "
				  SQL_Order_rs = SQL_Order_rs & " ,vact_num "

				  SQL_Order_rs = SQL_Order_rs & " ,info1,info2,info3,info4 "

				  SQL_Order_rs = SQL_Order_rs & " From tblSwwimingOrderTable "
				  SQL_Order_rs = SQL_Order_rs & " Where del_yn = 'N'  "
				  SQL_Order_rs = SQL_Order_rs & " and gubun = '2'	"
				  SQL_Order_rs = SQL_Order_rs & " and LeaderIDX = '"&s_pidx&"'"
				  Set rs = db.ExecSQLReturnRS(SQL_Order_rs , null, ConStr)
					If Not rs.EOF Then
					arrO = rs.GetRows()
					'Call getrowsdrow(arrO)
					End IF
				  %>
				<li class="m_apply-parti__con__list">
				  <h2 class="m_apply-parti__con__list__h2">결제 정보</h2>
				  <div class="m_apply-parti__con__list__tbl-box">
					<table class="">
					  <caption>결제 정보 표시</caption>
					  <thead class="m_apply-parti__con__list__tbl__thead">
						<tr>
						  <th scope="col" style="width:16%;">주문번호</th>
						  <th scope="col" style="width:16%;">증명서</th>
						  <th scope="col" style="width:16%;">주문형식</th>
						  <th scope="col" style="width:16%;">주문상태</th>
						  <th scope="col" style="width:16%;">날짜</th>
						  <th scope="col" style="width:16%;">인쇄</th>
						</tr>
					  </thead>
					  <tbody class="m_apply-parti__con__list__tbl__tbody">
						<!-- #applyPartiTbodyNone.s_hide = 첫줄 아무것도없음 숨기기 -->
						<%
							If IsArray(arrO) Then
								For ari = LBound(arrO, 2) To UBound(arrO, 2)
								p_orderidx = arrO(0, ari)
								p_orderno = arrO(1, ari)
								p_ordertype =arrO(2, ari)
								p_orderstate= arrO(3, ari)
								p_orderprice =arrO(5, ari)
								p_order_tid = arrO(6,ari)
								p_order_mid = arrO(7,ari)
								p_orderdate = arrO(8,ari)

								p_vact_bk = arrO(9,ari)
								p_vact_no = arrO(10,ari)

								p_info1 = arrO(11,ari) '발급용도
								p_info2 = arrO(12,ari) '제출처
								p_info3 = arrO(13,ari) '대회참가확인서, 선수실적증명서
								p_info4 = arrO(14,ari) '인쇄할 대회코드

								%>

								<tr class="s_selected">
								  <th scope="row"><%=p_orderno%></th>

								  <td>
								  <%'=FormatNumber(p_orderprice,0)%>
								  <%If p_info3 = "1" then%>
									대회참가확인서
								  <%else%>
									선수실적증명서
								  <%End if%>
								  </td>

								  <td><%=p_ordertype%>
								  <%
								  If p_ordertype = "가상계좌" then
								  Response.write  ":"&  p_vact_bk & " " & p_vact_no
								  End if
								  %>
								  </td>

								  <td><%=p_orderstate%></td>
								  <td><%
								  Response.write p_orderdate
								  %></td>
								  <td style="float:center;">
									 <div class="order_button">
										<%
										'1. 가상계좌이고 입금대기 중이라면
										'2. 취소하시겠습니까 (결제정보삭제, 	'tblgamereuqest  정보  delete _r  도삭제 다시돌아오기)
										'3. 결제가 완료된것이라면

										If p_orderstate = "취소요청중" Or p_orderstate = "취소완료"   Then
											%>-<%
										else
											If p_ordertype = "가상계좌" And p_orderstate = "입금대기" Then
											%>입금 후 새로고침<%
											else
											%>
											
												<%If CDate(p_orderdate) < date then%>
													종료
												<%else%>
												<input type="button" value="출력" onclick="javascript:mx.print(<%=p_orderidx%>);">
												<%End if%>

											<%End if%>
										<%End if%>
									 </div>
								  </td>
								</tr>

								<%
								Next
							End if
						%>

					  </tbody>
					</table>

				</li>

				</ul>





			</div>



        </section>
      </div>
    <!-- e 메인 영역 -->

    <!-- s 팝업창 영역 -->
      <div class="l_modal-wrap" id="paycancel">
        <div class="l_modal"  id="cancelbody">
			<!-- 부목록 -->
        </div>
      </div>



      <!-- div.s_show = 팝업창 보이게 -->
      <div class="l_modal-wrap" id="player-listModal">
        <div class="l_modal">
          <section class="m_modal-player-list">
            <div class="m_modal-player-list__header">
              <h1 class="m_modal-player-list__header__h1">참가 선수 추가/삭제</h1>
            </div>
            <div class="m_modal-player-list__con" id="playerlist">
				<!-- 내용 -->
			</div>

            <div class="m_modal-player-list__btns clear">
              <button id="btnOkPlayerModal" type="button" name="button" onclick="mx.setPlayer()">확인</button>
              <button onclick="closeModal()" id="btnCancelPlayerModal" type="button" name="button">취소</button>
            </div>
          </section>
        </div>
      </div>


      <div class="l_modal-wrap" id="player-selc-typeModal">
        <div class="l_modal"  id="boolist">
			<!-- 부목록 -->
        </div>
      </div>


	  <div class="l_modal-wrap" id="applyCancelModal">
        <div class="l_modal">
          <section class="m_modal-apply-noti">
            <span class="m_modal-apply-noti__header">작성을 취소하시겠습니까?</span>
            <span class="m_modal-apply-noti__con">작성을 취소하시면 리스트로 돌아갑니다.</span>
            <div class="m_modal-apply-noti__btns clear">
              <button onclick="closeModal()" id="btnOk-ApplyCancelModal" type="button" name="button">확인</button>
              <button onclick="closeModal()" id="btnCancel-ApplyCancelModal" type="button" name="button">취소</button>
            </div>
          </section>
        </div>
      </div>
    <!-- e 팝업창 영역 -->







	<script>
      // 버튼이벤트
        $('button').on('click',function(){
          console.log($(this).attr('id') + ' click!');
        });
        $('#btnCompleteApplyPay').on('click', function(){

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

		   if (document.getElementById("c1").value =='')
		   {
			   alert('발급용도를 기입해주십시오.');
			   document.getElementById("c1").focus();
			   return false;
		   }

//		   if (document.getElementById("c2").value =='')
//		   {
//			   alert('제출처를 기입해주십시오.');
//			   document.getElementById("c2").focus();
//			   return false;
//		   }

			if( $('#c3').val() == '1' ){
				if ( $('#todaypay1').val() == "1"){
					alert('오늘 결제한 내역이 있습니다.');
					return false;
				}
				
				if (mx.gameidx.length == 0){
					alert('참가확인서를 출력할 대회를 선택해 주십시오.');
					return false;
				}
			}
			else{
				if ( $('#todaypay2').val() == "1"){
					alert('오늘 결제한 내역이 있습니다..');
					return false;
				}

				if ($('#gubun2check').val() == "0"){
					alert('실적이 없습니다. 연맹에 문의해 주십시오.');
					return false;
				}
			}



		   if (gopaymethod.value =='')
		   {
			   alert('결제방식을 선택해 주시기 바랍니다');
			   gopaymethod.focus();
			   return false;
		   }

//		   if (price.value < 1000)
//		   {
//			   alert('결제는 1,000원 이상 가능합니다.');
//			   return;
//		   }

		   INIStdPay.pay('SendPayForm_id')
			return;

          $('#applyCompleteModal').fadeIn(300);
          $('body').addClass('s_no-scroll');
        });

		function closeModal(){
          $('.l_modal-wrap').fadeOut(300);
          $('body').removeClass('s_no-scroll');
        }
      </script>













	<script>
      function closeModal(){
//        $('.l_modal-wrap').fadeOut(300);
//        $('body').removeClass('s_no-scroll');
      }
    </script>
  </body>
</html>
