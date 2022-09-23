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


	'생성된 종목만 보이게 (경영, 아티스틱,,)
	SQL = "select cda,cdanm from tblRGameLevel where gametitleidx = "&tidx&" and delyn='N' group by CDA ,cdanm"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		arrMn = rs.GetRows()
		CDA = arrMn(0,0)
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

			fld =  " RGameLevelidx,GameTitleIDX,a.GbIDX,a.Sexno,a.ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,a.levelno, gubunam,gubunpm, joono, joono2,resultopenAMYN,resultopenPMYN "
			strSort = "  ORDER BY itgubun,cdc,sexno"
			'예선이 있는것만 우선가져오자.and (gubunam = '1' or gubunpm = '1') 음
			strWhere = " a.GameTitleIDX = "&tidx&" and  a.CDA = '"&CDA&"'  and a.delyn= 'N' "   'and a.DelYN = 'N'  " 'and  (gubunam = '1' or gubunpm = '1') "

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
							CDCNMS = fr(10,ari)
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
'							CDCNMS = fr(16,ari)
'							openRC = fr(18, ari)
							CDCNMS = fr(10,ari)
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






%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
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

<div id="app" class="l contestInfo">

  <!-- #include file = "../include/gnbapp.asp" -->
	<div class="l_header">
    <div class="m_header s_sub">
	  <a href="/Result/institute-search.asp?reqdate=<%=gameS%>" class="m_header__backBtn">이전</a>
  		<h1 class="m_header__tit">대회결과/신기록</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>
	<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>




    <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">
		<!-- 여기에 내용 넣어주세요 -->



	<div class="drow">
      <h2 class="m_resultTit"></span>
        <span><%=title%></span><%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) | <%=gamearea%>
      </h2>

        <nav class="match-result-nav clear">
          <!-- s_on = 링크 강조 표시 -->
          <a href="#a" id="linkMatchResult" class="match-result-nav__link s_on">
            대회결과
          </a>
          <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>},'gamesin.asp?tidx=<%=tidx%>');" id="linkNewRecord" class="match-result-nav__link">
            신기록
          </a>
        </nav>


      <div class="drow-con">
        <div class="drow-con__search clear">
          <div class="drow-con__search__box-selc">
					<input type="hidden" id="showtype" value="result">
					<select id="CDA"  class="drow-con__search__box-selc__selc" onchange="mx.getMachList('<%=tidx%>',$(this).val())">
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
          </div>

          <div class="drow-con__search__box-selc" id="s_cdbc">
					<select id="cdbc" class="drow-con__search__box-selc__selc" onchange="mx.getMachTable('<%=tidx%>',$(this).val(),0,'')">
						<option value=""  selected>::부또는 그룹을 선택해주십시오.::</option>
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
          </div>

		  <div class="drow-con__search__box-input clear">
            <input class="drow-con__search__box-input__input" type="text"  placeholder="선수명을 검색하세요" id="player_nm" value="">
            <span class="drow-con__search__box-input__button" id="btnSearchDrow" ><strong class="hide">선수 검색</strong></span>
          </div>


		  <div class="drow-con__search__box-input clear" id="sw_searchboo">

          </div>
		</div>


		<%'##########################%>
        <span id="sw_gametable"></span>
		<%'##########################%>





      </div>
    </div>
		<!-- 여기에 내용 넣어주세요 -->
  </div>
  <!-- E: main -->


  <!-- 팝업 -->
  <div class="l_upLayer searchPopup [ _overLayer _searchLayer ]"><!-- l_upLayer searchPopup [ _overLayer _searchLayer ] _s_on -->
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
  </div>
  <!-- // search popup -->




	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>




</body>
</html>

<%
  set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
