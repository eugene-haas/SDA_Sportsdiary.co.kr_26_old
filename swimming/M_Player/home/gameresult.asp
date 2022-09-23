<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->



<%
	Set db = new clsDBHelper

	tidx = request("tidx")
	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		If hasown(oJSONoutput, "TIDX") = "ok" then
			tidx = oJSONoutput.TIDX
		End If
		If hasown(oJSONoutput, "CDA") = "ok" then
			cda = oJSONoutput.CDA
		Else
			cda = "D2"
		End if
		If hasown(oJSONoutput, "CDB") = "ok" then
			cdb = oJSONoutput.CDB
		Else
			CDB = "S"
		End if
		If hasown(oJSONoutput, "CDC") = "ok" then
			cdc = oJSONoutput.CDC
		End if
	Else
		cda = "D2"
		CDB = "S"
	End if




	If isnumeric(tidx) Then
			'대회
			SQL = "select gametitlename , gameS,gameE,gamearea from sd_gameTitle where gametitleidx = '"&tidx&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				title = rs(0)
				gameS = rs(1)
				gameE = rs(2)
				gamearea = rs(3)
			End if


'			fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2, b.cd_booNm_short, b.orderby,resultopenAMYN,resultopenPMYN "
'			strSort = "  ORDER BY itgubun,cdc,b.orderby,sexno"
'			'예선이 있는것만 우선가져오자.and (gubunam = '1' or gubunpm = '1') 음
'			strWhere = " a.GameTitleIDX = "&tidx&" and  a.CDA = '"&CDA&"' and b.cd_type = 2 and a.delyn= 'N' "   'and a.DelYN = 'N'  " 'and  (gubunam = '1' or gubunpm = '1') "
'
'			SQL = "Select " & fld & " from tblRGameLevel as a inner join tblTeamGbInfo as b on a.cdb = b.cd_boo and b.delyn = 'N' where " & strWhere & strSort


			fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2    ,resultopenAMYN,resultopenPMYN "
			strSort = "  ORDER BY itgubun,cdc,sexno"
			'예선이 있는것만 우선가져오자.and (gubunam = '1' or gubunpm = '1') 음
			strWhere = " a.GameTitleIDX = "&tidx&" and  a.CDA = '"&CDA&"' and a.delyn= 'N' "   'and a.DelYN = 'N'  " 'and  (gubunam = '1' or gubunpm = '1') "

			SQL = "Select " & fld & " from tblRGameLevel as a  where " & strWhere & strSort





			Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)


			'Call rsdrow(rss)
			'Response.end


			If Not rss.EOF Then
				fr = rss.GetRows()

				If IsArray(fr) Then
					For ari = LBound(fr, 2) To UBound(fr, 2)
						l_CDA= fr(5, ari)
						If l_CDA= "D2" Then
							CDAD2 = "ok"
						End If
						If l_CDA= "E2" Then
							CDAE2 = "ok"
						End If
						If l_CDA= "F2" Then
							CDAF2 = "ok"
						End if
					Next

					'오전경기에서 예선찾기
					For ari = LBound(fr, 2) To UBound(fr, 2)
						gubunam = fr(12,ari)
						gubunpm = fr(13,ari)
						RGameLevelidx = fr(0,ari)

						If gubunam = "1" Then
							chkridx = RGameLevelidx
							joono = fr(14,ari)
							now_joo = 1
							CDB = fr(7,ari)
							CDC = fr(9,ari)
							CDBNM = fr(8,ari)
							CDCNM =  fr(10,ari)
							'CDCNMS = fr(16,ari)
							'openRC = fr(18, ari)
							CDCNMS = CDCNM
							openRC = fr(16, ari)
							ampm = "am"
							starttype = gubunam
							itgubun = fr(4,ari)
							Exit for
						End If
					Next

					'오후경기에서 예선찾기
					If chkridx = "" then
					For ari = LBound(fr, 2) To UBound(fr, 2)
						gubunam = fr(12,ari)
						gubunpm = fr(13,ari)
						RGameLevelidx = fr(0,ari)

						If gubunpm = "1" Then
							chkridx = RGameLevelidx
							now_joo = 1
							joono = fr(15,ari)
							CDB = fr(7,ari)
							CDC = fr(9,ari)
							'CDCNMS = fr(16,ari)
							'openRC = fr(18, ari)
							CDCNMS = fr(10, ari)
							openRC = fr(16, ari)
							ampm = "pm"
							starttype = gubunpm
							itgubun = fr(4,ari)
							Exit for
						End If
					Next
					End if


				End if
			End If

			'레벨번호 구하기
			If CDAD2 <> "" Then
				CDA = "D2"
			Else
				If CDAE2 <> "" Then
					CDA = "E2"
				Else
					If CDAF2 <> "" Then
						CDA = "F2"
					Else
						CDA = "D2"
					End if
				End if
			End if

			levelno = CDA & CDB & CDC
			'##################



	End if

	weekarr = array("-", "일","월","화","수","목","금","토")

	'생성된 종목만 보이게 (경영, 아티스틱,,)
	SQL = "select cda,cdanm from tblRGameLevel where gametitleidx = "&tidx&" group by CDA ,cdanm"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		arrMn = rs.GetRows()
	End if

'##############################################
' 소스 뷰 경계
'##############################################
%>

<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->

    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/default.css">
    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/Player_home.info.css">
	<link rel="stylesheet" href="/css/sw_home.style.min.css?9">
	<script src="/js/sw.home.js?1"></script>



	<link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>

	<script type="text/javascript">
	<!--
	mx.tablejsondata = "";
	mx.OnShowTourn =  function(cmd, packet, html, sender){

		 mx.tablejsondata = packet;


		  var tournament2 = new Tournament();

		  tournament2.setOption({
			blockBoardWidth: 200, // integer board 너비
			blockBranchWidth: 20, // integer 트리 너비
			blockHeight : 80, // integer 블럭 높이(board 간 간격 조절)
			branchWidth : 2, // integer 트리 두께
			branchColor : '#a9afbf', // string 트리 컬러
			roundOf_textSize : 20, // integer 배경 라운드 텍스트 크기
			scale : 'auto', // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
			board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
				el:document.getElementById('sw_gametable') // element must have id
			});

		  tournament2.setStyle('#sw_gametable');
		  tournament2.boardInner = function(data){
			var Lwincolor = "";
			var Rwincolor = "";

			var Lnm = data.teamnmL;
			var Rnm = data.teamnmR;
			//var Lteamnm = data.LteamAna;
			//var Rteamnm = data.RteamAna;

			if (data.LWL == 'W'){
				Lwincolor = "style='background:orange;'";
			}
			if (data.RWL == 'W'){
				Rwincolor = "style='background:orange;'";
			}


			if (Lnm == '--' || Lnm == null ){
				Lnm = "";
			}
			if (Rnm == '--' || Rnm == null ){
				Rnm = "";
			}



			//		if (Lnm == '' || Rnm == '' || Lnm == '부전' || Rnm == '부전'){
						var makebtn = '';
			//		}
			//		else{
			//			var makebtn = '<button type="button" class="btn btn-block btn-default" onclick="mx.soogooWindow('+data.idx+')">결과입력</button>';
			//		}

			var html = [
			  '<p class="ttMatch ttMatch_first"  '+Lwincolor+'>',
				'<span class="ttMatch__score">'+data.scoreL+'</span>',
				'<span class="ttMatch__playerWrap">',
				  '<span class="ttMatch__playerInner"  title="">',
					'<span class="ttMatch__player">'+Lnm+'</span>',
					'<span class="ttMatch__belong">'+makebtn+'</span>',
				  '</span>',
				'</span>',
			  '</p>',
			  '<p class="ttMatch ttMatch_second" '+Rwincolor+'>',
				'<span class="ttMatch__score">'+data.scoreR+'</span>',
				'<span class="ttMatch__playerWrap">',
				  '<span class="ttMatch__playerInner"   title="">',
					'<span class="ttMatch__player">'+Rnm+'</span>',
					'<span class="ttMatch__belong"></span>',
				  '</span>',
				'</span>',
			  '</p>'
			].join('');

				return html;
			}

			//    tournament3.draw({
			//      limitedStartRoundOf: 16, // integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
			//      limitedEndRoundOf: 8, // integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
			//      roundOf:16,
			//		data: mx.tablejsondata

		  tournament2.draw({
			roundOf:packet.TotalRound,
			data:  packet
		  });

	};
	//-->
	</script>
	<style>
		.slash {
		  background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><line x1="0" y1="100%" x2="100%" y2="0" stroke="gray" /></svg>');
		}
		.backslash {
		  background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg"><line x1="0" y1="0" x2="100%" y2="100%" stroke="gray" /></svg>');
		}
		.slash, .backslash { text-align: left; }
		.slash div, .backslash div { text-align: right; }
		table {
			border-collapse: collapse;
			border: 1px solid gray;
		}
		th, td {
			border: 1px solid gray;
			padding: 2px;
			text-align: center;
		}
	</style>
</head>


<body <%=CONST_BODY%>>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
<input type="hidden" id = "tidx" value="<%=tidx%>">


<div class="l_modal-wrap" id="NotiModal2" onclick="$('#NotiModal2').fadeOut(300); $('body').removeClass('s_no-scroll');">
  <div class="l_modal" id="popcontents" style="width:90%;">

	  <!-- <section class="m_modal-manual">

		<h1 class="m_modal-manual__header">신청자인증</h1>
		<ul class="m_modal-manual__con">
		  <li class="m_modal-manual__con__list">
			<h2 class="m_modal-manual__con__list__h2">공통사항</h2>
			<p class="m_modal-manual__con__list__p">
			<p>
		  </li>
		</ul>
		<button  id="btnCloseNotiModal" type="button" name="button" onclick="$('#NotiModal2').fadeOut(300); $('body').removeClass('s_no-scroll');">닫 기</button> -->

	  </section>


  </div>
</div>


	<%h1str = "경기결과"%>
	<!-- #include virtual = "/home/include/header.home.asp" -->

    <!-- s 메인 영역 -->
      <div class="l_main">

		<section class="l_main__contents">
          <div class="list-pro"style=" padding-top:20px;">


			<h2 class="drow_matchTit">
				<span class="drow_matchTit__con"><%=title%></span>&nbsp;<%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) | <%=gamearea%>
				 <button class="list-pro__search__btn" type="button" name="button" onclick="px.goSubmit( {} , 'gameresult.asp?tidx=<%=tidx%>');" style="float:right;">경기결과</button>
				 <button class="list-pro__search__btn" type="button" name="button" onclick="px.goSubmit( {} , 'gameorder.asp?tidx=<%=tidx%>');" style="float:right;">경기순서</button>
				 <button class="list-pro__search__btn" type="button" name="button" onclick="px.goSubmit( {} , 'match-sch.asp?tidx=<%=tidx%>');" style="float:right;">대진표보기</button>
			</h2>


			<nav class="match-result-con__nav clear">
			  <!-- s_on = 링크 강조 표시 -->
			  <a href="#a" id="linkMatchResult" class="match-result-con__nav__link s_on" style="width:100%;">
				대회결과
			  </a>
			  <!-- <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>},'gamesin.asp?tidx=<%=tidx%>');" id="linkNewRecord" class="match-result-con__nav__link">
				신기록
			  </a> -->
			</nav>




		<div class="list-pro__search clear" style="padding-top:0px;">

		  <div class="list-pro__search__selc-box" style="margin:0px;">


				<input type="hidden" id="showtype" value="result">
				<select id="CDA"  class="list-pro__search__selc-box__selc" onchange="mx.getMachList('<%=tidx%>',$(this).val())">
					<%
							If IsArray(arrMn) Then
								For ari = LBound(arrMn, 2) To UBound(arrMn, 2)
									m_CDA= arrMn(0, ari)
									m_CDANM = arrMn(1,ari)
									%>
									<option value="<%=m_CDA%>" <%If CDA = m_CDA then%>selected<%End if%>><%=m_CDANM%></option>
									<%
								Next
							End if
					%>
				</select>


				<span id="s_cdbc">
				<select id="cdbc" class="list-pro__search__selc-box__selc" onchange="mx.getMachTable('<%=tidx%>',$(this).val(),0,'')">
					<option value=""  selected>::종목::</option>
				<%
						If IsArray(fr) Then
							For ari = LBound(fr, 2) To UBound(fr, 2)

								l_idx = fr(0, ari) 'idx
								l_tidx = fr(1, ari)
								l_gbidx= fr(2, ari)
								l_ITgubun= fr(4, ari)
								l_CDA= fr(5, ari)
								l_CDANM= fr(6, ari)
								l_CDB= fr(7, ari)
								l_CDBNM= fr(8, ari)
								l_CDC= fr(9, ari)
								l_CDCNM= fr(10, ari)
								l_levelno= fr(11, ari)
								l_gubunam = fr(12,0)
								l_gubunpm = fr(13,0)
								%><option value="<%=l_idx%>_<%=l_levelno%>"><%=l_CDBNM&" " & l_CDCNM%></option><%
							Next
						End if
				%>
				</select>
				</span>

				<input type="text"  placeholder="선수명을 검색하세요" id="player_nm" value="" style="width:780px;" class="list-pro__search__selc-box__selc">



			  <div class="drow-con__search__box-input clear" id="sw_searchboo" style="width:100%;">

			  </div>
		  </div>

		</div>





		<%'##########################%>
        <span id="sw_gametable"></span>
		<%'##########################%>











          </div>
        </section>
      </div>
    <!-- e 메인 영역 -->



  <!-- 팝업 -->
  <!-- <div class="l_upLayer searchPopup [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox m_searching__area [ _overLayer__box ]">

      <div class="m_searchPopup__header">
        <button class="m_searchPopup__close [ _overLayer__close ]" onclick="mx.popClose()"><img src="http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png" alt="닫기"></button>
      </div>

      <div class="l_upLayer__wrapCont m_searchPopup__cont [ _overLayer__wrap ]" id="popcontents">

		<div class="m_searchPopup__control" >

        </div>

        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering" >

        </div>

      </div>
    </div>
  </div> -->
  <!-- // search popup -->



  </body>


<!-- #include virtual = "/pub/html/swimming/html.footer.home.asp" -->
</html>
