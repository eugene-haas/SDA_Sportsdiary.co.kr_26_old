<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
    <script src="http://swimming.sportsdiary.co.kr/pub/js/swimming/gameatt.js?v=190820"></script>
</head>

<%
	Set db = new clsDBHelper
%>
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.sw.asp" -->

<%
 'Controller ################################################################################################

	
	
	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_gameTitle as a "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임

	'0국제, 1체전, 2장소, 3주최 , 4주관, 5후원, 6협찬, 7대회명, 8요강, 9규모, 10레인수 ,11대회코드, 12참가비 , 13대회기간 , 14신청기간 , 15대회구분 , 16구분, 17개인, 18팀, 19시도신청, 20시도승인, 21팀당2명이내제한, 22종목수
	
	resutchkfld = " ( select top 1 RGameLevelidx  from  tblRGameLevel where  resultopenAMYN  =  'Y' or resultopenPMYN = 'Y'  and gametitleidx  =  a.gametitleidx ) as chkrt "
	
	strFieldName = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt,GameTitleIDX    ,ViewState,ViewStateM,ViewYN,MatchYN,stateNo , " & resutchkfld	


	

	strSort = "  order by GameE desc"
	strSortR = "  order by GameE"


	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and ViewState = 'Y' and ( gameS >=  '"& year(date) & "-01-01" &"' and  gameS < '"& CDbl(year(date))+1 & "-01-01" &"' )  "
	Else
		strWhere = " DelYN = 'N' and ViewState = 'Y' and ( gameS >=  '"& F2 & "-01-01" &"' and  gameS < '"& CDbl(F2)+1 & "-01-01" &"' )  "
	End If
	

		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10




'Call rsdrow(rs)
'Response.write strWhere
'Response.end



'페이지 입력폼 상태 확인
'pageYN = getPageState( "MN0101", "대회정보관리" ,Cookies_aIDX , db)

'##############################################
' 소스 뷰 경계
'##############################################
%>


<body <%=CONST_BODY%>>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
<input type="hidden" id="tidx">

	<%h1str = "대회상세정보"%>
	<!-- #include virtual = "/home/include/header.home.asp" -->

    <!-- s 메인 영역 -->
      <div class="l_main">

		<section class="l_main__contents"> <!-- style="background:green;"> -->
          <div class="list-pro"style=" padding-top:20px;">
			<h2>대회상세정보</h2>
            <div class="list-pro__search clear" style="padding-top:10px;">
              
              <div class="list-pro__search__selc-box" style="margin:0px;">
                <select id="F2" class="list-pro__search__selc-box__selc">
					<%For fny =year(date)+1 To year(date)-3 Step -1%>
					<option value="<%=fny%>" <%If (F2 = "" And fny = year(date)) Or CStr(fny) = CStr(F2) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
					<%Next%>
                </select>
              </div>
              <button class="list-pro__search__btn" type="button" name="button" onclick="px.goSubmit( {'F2':$('#F2').val(),'F3':[]} , '<%=pagename%>');">조 회</button>
            </div>

			<div class="list-pro__tbl">
              <table class="list-pro__tbl__basic">
                <caption>대회 리스트 표</caption>
                <thead class="list-pro__tbl__basic__header">
                  <tr>
                    <th scope="col">상태</th>
                    <th scope="col">년도</th>
                    <th scope="col">대회명</th>
                    <th scope="col">구분</th>
                    <th scope="col">장소</th>
                    <th scope="col">대회기간</th>
                    <th scope="col">대진표</th>
                    <th scope="col">경기순서</th>
                    <th scope="col">경기결과</th>
                  </tr>
                </thead>
                <tbody class="list-pro__tbl__basic__body">
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
						Select Case l_gubun 
						Case "01" : l_gubun = "명칭"
						Case "02" : l_gubun = "승인"
						Case "09" : l_gubun = "기타"
						End Select 
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
						l_GameS = Replace(rs(13),"-","/") 
						l_GameE = Replace(rs(14),"-","/")

						l_atts = Replace(Left(rs(15),11),"-","/") & Left(setTimeFormat(CDate(rs(15))),5)  & " - "
						l_atte = Replace(Left(rs(16),11),"-","/") & Left(setTimeFormat(CDate(rs(16))),5)
						l_checkatte = CDate(rs(16))
						l_GameType = rs(17)
						l_EnterType = rs(18)


						Select Case l_EnterType 
						Case "03" : l_EnterType = "통합"
						Case "01" : l_EnterType = "전문"
						Case "02" : l_EnterType = "생활"
						End Select 


						l_attTypeA = rs(19)
						l_attTypeB = rs(20)
						l_attTypeC = rs(21)
						l_attTypeD = rs(22)
						l_teamLimit = rs(23)
						l_attgameCnt = rs(24)
						l_idx = rs(25)

						l_ViewState = rs(26)  '홈
						l_ViewStateM = rs(27) '모바일
						l_ViewYN = rs(28)  '신청
						l_MatchYN = rs(29)  '대진
						l_stateNo = rs(30)  '확인서

						l_chkrt = rs("chkrt")


				  '<!-- tr.s_expected = 예정 -->
                  '<!-- tr.s_recruiting = 모집중 -->
                  '<!-- tr.s_ready = 마감 -->


					If CDate(rs(15)) > date() Then
						attClass = "s_expected"
					ElseIf CDate(rs(15)) <= Date()  And CDate(rs(16)) > Date() then
						attClass = "s_recruiting"
					ElseIf CDate(rs(16)) < Date() Then
						attClass = "s_ready"					
					End if
					
					 %>
						  <tr class="<%=attClass%>">
							<%
							If CDate(l_GameE) < Date() Then
								ingcss = "t_none"
								ingtext = "종료"
								ingtype = "end"
							Else
								If CDate(l_GameS) > Date() then
									ingcss = "t_white-blue"
									ingtext = "D-" & CDate(l_GameS) - Date()
									ingtype = "pre"
								else
									ingcss = "t_blue-white"
									ingtext = "진행중"
									ingtype = "ing"
								End if
							End if
							%>
							<td><button type="button" name="button"  class="btn <%=ingcss%>" style="cursor:default;"><%=ingtext%></button></td>

							<td><%=Left(l_GameS,4)%></td>
							<td scope="row" class="t_title"><%=l_GameTitleName%></td>
							<td><%=l_EnterType%></td>
							<td><%=l_GameArea%></td>
							<td>﻿﻿<%=Mid(l_GameS,3)%>~<%=Mid(l_GameE,3)%></td>

							<%Select Case ingtype
							Case "end"
							%>
							<td><button type="button" name="button" onclick="px.goSubmit( {} , 'match-sch.asp?tidx=<%=l_idx%>');" class="btn t_blue-white">대진표보기</button></td>
							<td><button type="button" name="button" onclick="px.goSubmit( {} , 'gameorder.asp?tidx=<%=l_idx%>');" class="btn t_blue-white">경기순서</button></td>
							<td><button type="button" name="button" onclick = "px.goSubmit( {} , 'gameresult.asp?tidx=<%=l_idx%>');" class="btn t_blue-white">경기결과</button></td>
							<%Case "pre"%>
							<td><button type="button" name="button" class="btn t_display">대진표보기</button></td>
							<td><button type="button" name="button" class="btn t_display">경기순서</button></td>
							<td><button type="button" name="button" class="btn t_display">경기결과</button></td>
							<%Case "ing"%>
							<td><button type="button" name="button" onclick="px.goSubmit( {} , 'match-sch.asp?tidx=<%=l_idx%>');" class="btn t_blue-white">대진표보기</button></td>
							<td><button type="button" name="button" onclick="px.goSubmit( {} , 'gameorder.asp?tidx=<%=l_idx%>');" class="btn t_blue-white">경기순서</button></td>
							<%If isNull(l_chkrt) = True then%>
							<td><button type="button" name="button"  class="btn t_white-blue">경기결과</button></td>
							<%else%>
							<td><button type="button" name="button" onclick = "px.goSubmit( {} , 'gameresult.asp?tidx=<%=l_idx%>');" class="btn t_blue-white">경기결과</button></td>
							<%End if%>
							<%End Select %>
						  </tr>					 
					 <%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>


				</tbody>
              </table>
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





    <script>
//      $('#btnCloseNotiModal').on('click', function(){
//        $('#NotiModal').fadeOut(300);
//        console.log("btnCloseNoti click!");
//        $('body').removeClass('s_no-scroll');
//      });
//
//
//		//팝업로드
//		$('#NotiModal').fadeIn(300);
//		$('body').addClass('s_no-scroll');
    </script>
  </body>


<!-- #include virtual = "/pub/html/swimming/html.footer.home.asp" -->
</html>
