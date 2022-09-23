<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	Set db = new clsDBHelper

	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		If hasown(oJSONoutput, "PIDX") = "ok" then
			pidx = oJSONoutput.PIDX

			SQL = "select username,teamnm,sex,birthday from tblPlayer where playeridx =  '"&pidx&"'"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
				unm = rs(0)
				tnm = rs(1)
				sexno = rs(2)
				bd = rs(3)

				if sexno = "1" Then
					sexstr = "남"
				Else
					sexstr = "여"
				End if
			End If


			'이력은 tblRecord 에서 찾아서 넣자.
			'종목은?
			wherestr = " delyn = 'N' and ( username = '"&unm&"' or username2= '"&unm&"' or username3 = '"&unm&"' or username4 = '"&unm&"' ) "
			SQL = "Select titlecode,titlename,   gamedate,cdcnm,roundstr,cdbnm,teamnm,gameresult,gameorder,UserName,gubun,UserName2,UserName3,UserName4,rctype from  tblrecord where  "&wherestr&"  order by titleCode,gameDate desc "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		  If Not rs.EOF Then
				arrR = rs.GetRows()
		  End If
		  Set rs = Nothing

		End if
	End if


Function RCSTR(rccode)
Select Case rccode
Case "R01": RCSTR =  "대회유년"
Case "R02": RCSTR =  "대회초등"
Case "R03": RCSTR =  "대회중등"
Case "R04": RCSTR =  "대회고등"
Case "R05": RCSTR =  "대회대학"
Case "R06": RCSTR =  "대회일반"
Case "R07": RCSTR =  "한국신"
Case "R08" : RCSTR =  ""
End Select
End Function
%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
</head>
<body <%=CONST_BODY%>>

<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>



<div id="app" class="l riding matchSch" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->
  <div class="l_header">
     <div class="m_header s_sub">
        <a href="../main/index.asp" class="m_header__backBtn">이전</a>
        <h1 class="m_header__tit">선수조회</h1>
        <!-- #include file="../include/header_gnb.asp" -->
     </div>
  </div>


  <div class="l_content m_scroll [ _content _scroll ]">

	   <div class="player-info">
			<div class="player-info__header">
				<h2>김수영</h2>
				<button @click="openSearching('.searchPopup')" class="player-info__header__btn-search" type="button">선수검색</button>
			</div>
			<ul class="player-info__list">
				<li>
					<dl>
						<dt>성별</dt>
						<dd>남</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>생년월일</dt>
						<dd>남</dd>
					</dl>
				</li>
				<li class="t_w100">
					<dl>
						<dt>소속</dt>
						<dd>서울체육고등학교</dd>
					</dl>
				</li>
			</ul>
	   </div>
		<div class="player-info__tab">
			<button class="s_on" type="button">이력</button>
			<button type="button">종목별 기록</button>
			<button type="button">최고기록</button>
			<button type="button">당해기록/순위</button>
		</div>
		<div class="player-info__option">
			<div class="player-info__option__box">
				<span>경영</span>
				<div>
					<select>
						<option value="">자유형</option>
					</select>
				</div>
			</div>
		</div>


		<div class="player-info__con">
			<h3 class="hide">이력</h3>
			<ul class="player-info__con__list">
				<li>
					<div class="player-info__con__list__header">
						<h4>50m</h4>
						<span>2020 경영 국가대표 선발대회</span>
					</div>
					<table class="player-info__con__list__table">
						<tbody>
							<tr>
								<th>
									<div>
										<span>2019.10.09</span>
										<span><em>자유형400m</em></span>
										<span>예선</span>
									</div>
									<span>남자일반부</span>
									<span>화성시청</span>
								</th>
								<td>
									<span>1위 <em>[대회신]</em></span>
									00:52:05
								</td>
							</tr>
						</tbody>
					</table>
				</li>
				<li>
					<div class="player-info__con__list__header">
						<h4>제 100회 대통령배 전국체육대회(경영)</h4>
						<span></span>
					</div>
					<table class="player-info__con__list__table">
						<tbody>
							<tr>
								<th>
									<div>
										<span>2019.10.09</span>
										<span><em>자유형400m</em></span>
										<span>예선</span>
									</div>
									<span>남자일반부</span>
									<span>화성시청</span>
								</th>
								<td>
									<span>1위 <em>[대회신]</em></span>
									00:52:05
								</td>
							</tr>
						</tbody>
					</table>
				</li>
			</ul>
		</div>
    <!-- 검색어 영역, 검색 버튼 -->
    <!-- <div class="m_searchTags">
      <div class="m_searchTags__infoBox">
        <p class="m_searchTags__infoTxt" v-if="search_txt!=''">{{search_txt}}</p>
        <button class="m_searchTags__btn" @click="openSearching('.searchPopup')"><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt=""></div></button>
      </div>
    </div> -->


    <!-- 경기가 있는 날짜들. 경기가 없는 날이면 맨 처음 날짜가 선택됨 -->


	<!-- <div class="player_ref">
	   <div class="l_content">

	      <div class="player_info">
	         <h2>선수정보</h2>
	         <table class="table_player_info">
	            <tbody>
	               <tr>
	                  <th>선수명</th>
	                  <td><%=unm%></td>
	               </tr>
	               <tr>
	                  <th>소속</th>
	                  <td><%=tnm%></td>
	               </tr>
	               <tr>
	                  <th>성별</th>
	                  <td><%=sexstr%></td>
	               </tr>
	               <tr>
	                  <th>생년월일</th>
	                  <td><%=Left(bd,2)%>.<%=mid(bd,3,2)%>.<%=right(bd,2)%></td>
	               </tr>
	            </tbody>
	         </table>
	      </div>
	      <div class="player_history" id="playerHistory">
	         <h2>선수이력</h2>
	      </div>
	   </div>
	</div> -->






<!-- ///////////////////////// -->





  <!-- search popup. 검색버튼 눌렀을 때 팝업 -->
  <div class="l_upLayer searchPopup t_test [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox m_searching__area [ _overLayer__box ]">

      <div class="m_searchPopup__header">
        <button class="m_searchPopup__close [ _overLayer__close ]" @click="closePopup('noname')"><img src="http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png" alt="닫기"></button>
      </div>

      <div class="l_upLayer__wrapCont m_searchPopup__cont [ _overLayer__wrap ]">
        <div class="m_searchPopup__control">

			<!-- 검색어 입력하면 -->
          <input type="text" v-bind:placeholder="placeholder" class="m_searchPopup__input s_only [ _searchingInput ]" v-model="keyword" v-on:input="keyword=$event.target.value" @keyup="inputKeyup">
        </div>

        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">
          <div class="m_searchPopup__panel [ _panelGamemovieList ]">
              <!-- 해당 검색어가 포한된 선수명 나오는 부분 -->
            <div v-if="keyword!='' && search_list!='nodata'">
              <button class="m_searchPopup__listname s_only [ _searchName ]" v-for="(stxt,key) in search_list" @click="popupSearchChoice(stxt.title,stxt.pidx)">{{stxt.title}}<span class="icon__search_add"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_add_@3x.png"></span></button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- // search popup -->







  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
    <!-- #include virtual = "/include/footer.asp" -->
</div>
<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  let app=new Vue({
    el:"#app",
    data:{
      reqURL : 'http://sw.sportsdiary.co.kr/pub/ajax/swimming/reqMobile.asp',
      game_title:"",// 대회명
      game_top_info:[],// 경기 현황판
      status_rotate_no:0,// 현황판 몇 번 돌렸나?
      status_rotate:null,// 현황판 돌리는 클래스

      game_delay_time:120000,// 현황판 없을 때 파일 불러와보는 시간
      game_delay_ori:60000,// 처음 현황판 갱신 시간
      game_delay:60000,// 현황판 갱신 시간
      game_now:null,//
      game_auto_refresh:undefined,// 경기 현황판 자동새로고침

      refresh_player_list:false,// 일정에서 경기 선택해서 나온 팝업에서 새로 고침

      game_day:[],// 경기 날짜들
      game_day_cur:null,// 오늘 날짜
      game_day_show:[],// 보여지는 날짜들
      game_schedule:[],// 경기 일정
      game_day_active_no:undefined,// 오늘 선택

      game_all_title2:"",// 체전일 때 2경기가 다음날 일 경우, 2경기 클릭하면 2경기 위치에서 보이려고

      search_list:[],// 검색되는 목록
      search_txt:"",// 검색하고 선택된 단어
      keyword:"",// 검색어
      nokeyword:true,// 검색어가 없을 때(true)
      layer:undefined,// 팝업
      layer2:undefined,// 팝업2
      placeholder:"선수명을 입력하세요.",

      player_list:[],// 경기에 참가하는 선수 목록
      showtableno:undefined,// 경기종료된 선수의 기록 목록 번호
      giveup_popinfo:[],// 기권 신청하는 선수 정보
      gnos:undefined,// 검색한 사람(들)의 경기날짜

      loading_days:false,
      loading_pop:false,

      yy:null,// 연
      mm:null,// 월
      dd:null,// 일
      tidx:136,//
      gnoval:[],// 일정에서 경기 선택해서 나온 팝업에서 새로 고침할 때 사용되는 값이 저장되는 곳
      fei_238_2_2:false,// 장애물 FEI 238.2.2 인지 확인
      sumriding:false,// 복합마술 여부
      orderlist:"match",// 출전순서(match) or 순위(rank)


      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      // 검색된 단어가 input에 placeholder로
      placeholderChange:function(txt){
        this.placeholder=txt;
      },

      // popup
      openSearching:function(popdiv,etc){
        this.orderlist="match";

        if(etc!=undefined){
          if(etc[0]=="playerlist"){
            this.gnoval=etc[1];
            this.game_all_title2=etc[2];//game_all_title2는 체전에서 2경기가 다음날로 넘어갈 때 2경기의 위치를 잡으려고
            this.loadPlayerList(this.reqURL + '?req={"CMD":"63400","tidx":"'+this.tidx+'","gno":"'+etc[1]+'"}');
          }
        }

        if(popdiv==".gameDetailPopup" || popdiv==".searchPopup"){
          this.layer=new OverLayer({
            overLayer:$(popdiv),
            emptyHTML:"정보를 불러오고 있습니다.",
            errorHTML:"",
          });
          this.layer.on("beforeOpen",function(){
            history.pushState("list2", null, null)
          });
          history.replaceState("list2", null, null);
          this.layer.open();
        }else if(popdiv==".giveupPopup"){
          this.layer2=new OverLayer({
            overLayer:$(popdiv),
            emptyHTML:"정보를 불러오고 있습니다.",
            errorHTML:"",
          });
          this.layer2.on("beforeOpen",function(){
            history.pushState("list3", null, null)
          });
          history.replaceState("list3", null, null);
          this.layer2.open();
        }
        // console.log("=========="+this.layer.status+"_   window.history.state : "+window.history.state);
      },
      // 팝업 닫을 때
      closePopup:function(txt){
        if(txt=="secondpop"){
          this.layer2.on("beforeClose",function(){
            history.pushState("list22", null, null)
          });
          history.replaceState("list2", null, null);
          this.layer2.close();
        }else{
          this.layer.close();
        }

        if(txt=="noname"){
          this.keyword="";
        }else{
          this.showtableno=undefined;// 팝업 닫을 때 경기 종료된 선수의 기록이 열려 있을 경우 닫히게
        }
      },

      //검색버튼 누를 때 선택된 내용이 화면에 보여지게
      popupSearchOption:function(){
        this.placeholderChange(this.keyword);

        if(this.nokeyword){
          this.keyword="";
          alert("입력한 선수명이 없습니다.");
        }else{
          if(this.keyword===""){
            // alert("선수명 또는 마명을 입력하세요.");
          }else{
            // 검색어에 맞는 경기가 여러개 일 때. 해당값을 "gno":"1,21,3,44"... 이렇게 보냄
            if(this.keyword.length<2){
              this.keyword="";
              alert("검색어는 최소 2글자 이상 입력해주세요.");
              return;
            }else{
            }
          }

          this.search_txt=this.keyword;
          this.layer.close();
          this.keyword="";// 검색 후 그대로 보이게 해달래서
        }
      },
      // 검색어 검색
      searchList:function(url){
        this.search_list=[];
        this.nokeyword=true;
        axios.get(url).then(response=>{
          this.search_list=response.data.jlist;
          if(this.search_list!="nodata"){
            this.nokeyword=false;
          }
        },(error)=>{
          console.log("error. searchList :")
          console.log(error);
        });
      },
      // 텍스트 입력
      inputKeyup:_.debounce(function(e){// 0.2초(200) 간격으로 검색
        // v-model="keyword" 대신 v-on:input="keyword==$event.target.value" 사용함. IME를 요구하는 언어가 제대로 업데이트 되기 위해서.
        if(e.keyCode===13){
          this.popupSearchOption();
          e.target.blur();
        }else if(e.keyCode!==13){
          // 검색어를 적다가 지워서 값이 없으면("") 전체가 보여지기 때문에
          if(this.keyword==" ") this.keyword="";
          if(this.keyword!=""){
            this.searchList(this.reqURL + '?req={"CMD":"63300","tidx":"'+this.tidx+'","searchtxt":"'+this.keyword+'"}');
          }
        }
      },200),
      // 미리보기 단어 선택
      popupSearchChoice:function(txt,pidx){
		   px.goSubmit({'PIDX':pidx},'./psearch_n.asp');
      },

      // 검색된 이름
      highlightTxt:function(name){
        if(name!=undefined){
          let txt=name.replace(/ \/ /g,''),
              stxt=this.search_txt.replace(/ : /g,''),
              cls=txt.match(stxt)!=null && this.search_txt!='' ? "s_searching" : "";
          return cls;
        }
      },


    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

    },
  });
</script>
</body>
</html>


<%
  set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
