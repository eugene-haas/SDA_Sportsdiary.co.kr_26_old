<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
	<script src="/pub/js/swimming/gameatt.js?v=190820"></script>
</head>

<%
	Set db = new clsDBHelper
%>
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.sw.asp" -->
<%

	'뒤에서 왔을때 체크되는값
	If hasown(oJSONoutput, "CDA") = "ok" then
		F1 =  oJSONoutput.CDA '대분류 코드 D2 경영
	End If
	If hasown(oJSONoutput, "YY") = "ok" then
		F2 =  oJSONoutput.YY
	End If
	'뒤에서 왔을때 체크되는값

	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_gameTitle as a "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	'0국제, 1체전, 2장소, 3주최 , 4주관, 5후원, 6협찬, 7대회명, 8요강, 9규모, 10레인수 ,11대회코드, 12참가비 , 13대회기간 , 14신청기간 , 15대회구분 , 16구분, 17개인, 18팀, 19시도신청, 20시도승인, 21팀당2명이내제한, 22종목수
	attcnt = " (select count(*) from tblGameRequest where delyn='N' and gametitleidx  = a.gametitleidx ) as attcnt "
	strFieldName = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt,GameTitleIDX    ,ViewState,ViewStateM,ViewYN,MatchYN,stateNo, "	 & attcnt

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and viewstate = 'Y'  and ( gameS >=  '"& year(date) & "-01-01" &"' and  gameS < '"& CDbl(year(date))+1 & "-01-01" &"' )  and GameTitleIDX = (select top 1 GameTitleIDX from tblRgameLevel where GameTitleIDX = a.GameTitleIDX and DelYN='N' and cda = 'D2')  "
		F1 = "D2"
	Else
		If IsArray(F1) = false Then
			'F1 경영, 다이빙/수구, 아티스틱스위밍(가 포함된 대회로 가져오자)
			strWhere = " DelYN = 'N' and viewstate = 'Y' and ( gameS >=  '"& F2 & "-01-01" &"' and  gameS < '"& CDbl(F2)+1 & "-01-01" &"' )  and GameTitleIDX = (select top 1 GameTitleIDX from tblRgameLevel where GameTitleIDX = a.GameTitleIDX and DelYN='N' and cda = '"&F1&"') "
		End if
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10


'Call rsdrow(rs)
'Response.end


'##############################################
' 소스 뷰 경계
'##############################################

'여기오면 쿠키값 싹다 지우자...
for each Item in request.cookies
	if item = "saveinfo" or IsNumeric(item) = true then 'popup info / login info
		'pass
	else
		Response.cookies(item).expires	= date - 1365
		Response.cookies(item).domain	= CHKDOMAIN
	end if
Next


%>





<body <%=CONST_BODY%>>

<%'=chkdomain%>


<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
<input type="hidden" id="tidx">

	<!-- #include virtual = "/home/include/header.asp" -->

    <!-- s 메인 영역 -->
      <div class="l_main">

		<section class="l_main__contents">
          <div class="list-pro">
            <div class="list-pro__search clear">
              <label class="list-pro__search__label" for="F1">종목</label>
              <div class="list-pro__search__selc-box">
                <select id="F1" class="list-pro__search__selc-box__selc">
					<option value="D2" <%If F1 = "" Or F1 = "D2" then%>selected<%End if%>>경영</option>
					<option value="E2" <%If F1 = "E2" then%>selected<%End if%>>다이빙/수구</option>
					<option value="F2" <%If F1 = "F2" then%>selected<%End if%>>아티스틱스위밍</option>
                </select>
              </div>
              <label class="list-pro__search__label" for="F2">개최년도</label>
              <div class="list-pro__search__selc-box">
                <select id="F2" class="list-pro__search__selc-box__selc">
					<%For fny =year(date)+1 To year(date)-3 Step -1%>
					<option value="<%=fny%>" <%If (F2 = "" And fny = year(date)) Or CStr(fny) = CStr(F2) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
					<%Next%>
                </select>
              </div>
              <button class="list-pro__search__btn" type="button" name="button" onclick="px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , '<%=pagename%>');">조 회</button>
            </div>

			<div class="list-pro__tbl">
              <table class="list-pro__tbl__con">
                <caption>대회 리스트 표</caption>
                <thead class="list-pro__tbl__con__header">
                  <tr>
                    <th scope="col">NO</th>
                    <th scope="col">년도</th>
                    <th scope="col">대회명</th>
                    <th scope="col">구분</th>
                    <th scope="col">장소</th>
                    <th scope="col">신청기간</th>
                    <th scope="col">모집상태</th>
                    <th scope="col">신청/내역조회</th>
                    <th scope="col">대회요강</th>
                  </tr>
                </thead>
                <tbody class="list-pro__tbl__con__body">

				  <%If user_ip = "112.187.195.132" then%>
<!-- 						  <tr class="s_recruiting"> -->
<!-- 							<td>78</td> -->
<!-- 							<td>test</td> -->
<!-- 							<th scope="row">test</th> -->
<!-- 							<td>--</td> -->
<!-- 							<td>--</td> -->
<!-- 							<td>﻿--</td> -->
<!-- 							<td></td> -->
<!-- 							<td><button type="button" name="button" onclick="$('#tidx').val(78);$('#NotiModal2').fadeIn(300);"></button></td> -->
<!-- 							<td><button type="button" name="button" onclick = "px.goTargetSubmit({}, '1','_blank');">보기</button></td> -->
<!-- 						  </tr> -->
				<%End if%>


				  <!-- tr.s_expected = 예정 -->
                  <!-- tr.s_recruiting = 모집중 -->
                  <!-- tr.s_ready = 신청됨 -->
					<%
					Do Until rs.eof

					If ci = "" Then
					ci = 1
					End if
					list_no = (intPageSize * (intPageNum-1)) + ci
					'############################


						l_gubun = rs(0)
						l_kgame = rs(1)
						Select Case l_kgame
						Case "03" : l_kgame = "통합"
						Case "01" : l_kgame = "전문"
						Case "02" : l_kgame = "생활"
						End Select
						l_GameArea = rs(2)
						l_hostname = rs(3)
						l_subjectnm = rs(4)
						l_afternm = rs(5)
						l_sponnm = rs(6)
						l_GameTitleName = rs(7)
						l_summaryURL = rs(8)
						l_gameSize = rs(9) '규모
						l_ranecnt = rs(10)
						l_titleCode = rs(11)
						l_attmoney = rs(12)
						l_chkdates = CDate(rs(13))
						l_chkdatee = CDate(rs(14))
						l_GameS = Replace(rs(13),"-","/") & " - "
						l_GameE = Replace(rs(14),"-","/")

						l_atts = Replace(Left(rs(15),11),"-",".") & " - " '& Left(setTimeFormat(CDate(rs(15))),5)  & " - "
						l_atte = Replace(Left(rs(16),11),"-",".") '& Left(setTimeFormat(CDate(rs(16))),5)
						l_checkatte = CDate(rs(16))
						l_GameType = rs(17)
						Select Case l_GameType
						Case "01" : l_GameType = "명칭"
						Case "02" : l_GameType = "승인"
						Case "09" : l_GameType = "기타"
						End Select

						l_EnterType = rs(18)
						l_attTypeA = rs(19)
						l_attTypeB = rs(20)
						l_attTypeC = rs(21)
						l_attTypeD = rs(22)
						l_teamLimit = rs(23)
						l_attgameCnt = rs(24)
						l_idx = rs(25)

						l_ViewState = rs(26)
						l_ViewStateM = rs(27)
						l_ViewYN = rs(28)
						l_MatchYN = rs(29)
						l_stateNo = rs(30)
						l_attcnt = rs(31)



				  '<!-- tr.s_expected = 예정 -->
                  '<!-- tr.s_recruiting = 모집중 -->
                  '<!-- tr.s_ready = 마감 -->

					If user_ip = "112.187.195.132"  then
						attClass = "s_recruiting" '모집중'
					Else
						If CDate(rs(15)) > now() Then
							attClass = "s_expected" '예정'
						ElseIf CDate(rs(15)) <= now()  And CDate(rs(16)) > now() then
							attClass = "s_recruiting" '모집중'
						ElseIf CDate(rs(16)) < now() Then
							attClass = "s_ready" '마감
						End If
					End if

					 %>
						  <tr class="<%=attClass%>">
							<td><%=l_idx%></td>
							<td><%=Left(l_GameS,4)%></td>
							<th scope="row"><%=l_GameTitleName%></th>
							<td><%=l_kgame%></td>
							<td><%=l_GameArea%></td>
							<td>﻿﻿<%=Mid(l_atts,3)%>~<%=Mid(l_atte,3)%></td>
							<td></td>
							<td><button type="button" name="button" onclick="$('#tidx').val(<%=l_idx%>);$('#NotiModal2').fadeIn(300);"></button></td>
							<td><button type="button" name="button" onclick = "px.goTargetSubmit({}, '<%=l_summaryURL%>','_blank');">보기</button></td>
						  </tr>
					 <%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>


				</tbody>
              </table>
				  <span class="list-pro__tbl__noti">※ 본 사이트는 Chrome, Micro Soft Edge에 최적화 되어 있습니다. </span>
            </div>
			<nav class="list-pro__nav clear">
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingSW (intTotalPage, 10, PN, "px.goPN", jsonstr )
			%>
            </nav>

          </div>
        </section>
      </div>
    <!-- e 메인 영역 -->


	<!-- s 팝업창 영역 -->
      <!-- div.s_show = 팝업창 보이게 -->
      <div class="l_modal-wrap" id="NotiModal">
        <div class="l_modal">
          <!--#include file="../include/m_modal-manual.asp"-->
        </div>
      </div>

      <div class="l_modal-wrap" id="NotiModal2">
        <div class="l_modal">

			<section class="m_modal-manual">
			  <h1 class="m_modal-manual__header">신청자인증</h1>
			  <span class="m_modal-manual__noti">※ 당해년도 지도자(감독, 코치, 주무 등)로 대한체육회 체육정보시스템에 등록되어 있어야 참가신청 인증이 가능합니다.</span>
			  <ul class="m_modal-manual__con">
				<li class="m_modal-manual__con__list">
				  <h2 class="m_modal-manual__con__list__h2">공통사항</h2>
				  <div class="m_modal-manual__con__list__row">
					  <input type="text" id="nm" maxlength="30" style="width:30%" placeholder="이름">
					  <input type="text" id="pno" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="11"  style="width:30%" placeholder="핸드폰">
					  <button  type="button" name="button" onclick="mx.SMS()" style="width:30%">문자전송</button>
				  </div>
				  <span class="m_modal-manual__con__list__noti">※ 인증문자 발송에 20초 정도 소요될 수 있습니다. </span>

					<div class="m_modal-manual__con__list__row">
					  <input type="text" id="chkno" onkeyup="this.value=this.value.replace(/[^0-9]/g,'')" maxlength="4"  style="width:30%" placeholder="인증번호">
					  <button   type="button" name="button" onclick="mx.chkSMS()" style="width:30%">인증확인</button>
				  </div>
				  <span class="m_modal-manual__con__list__noti">※ 인증문자 발송번호는 02-420-4236 이며, 미수신 시 차단메세지함을 확인해주세요.</span>
				</li>
			  </ul>
			  <button  id="btnCloseNotiModal" type="button" name="button" onclick="$('#NotiModal2').fadeOut(300); $('body').removeClass('s_no-scroll');">닫 기</button>
			</section>

        </div>
      </div>
    <!-- e 팝업창 영역 -->


    <script>
      $('#btnCloseNotiModal').on('click', function(){
        $('#NotiModal').fadeOut(300);
        console.log("btnCloseNoti click!");
        $('body').removeClass('s_no-scroll');
      });


		//팝업로드
		$('#NotiModal').fadeIn(300);
		$('body').addClass('s_no-scroll');
    </script>
  </body>


<!-- #include virtual = "/pub/html/swimming/html.footer.home.asp" -->
</html>
