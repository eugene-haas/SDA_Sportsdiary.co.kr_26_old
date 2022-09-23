<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	Set db = new clsDBHelper

	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		If hasown(oJSONoutput, "PIDX") = "ok" then
			pidx = oJSONoutput.get("PIDX")
			tabno = oJSONoutput.get("TABNO") '탭번호
			if tabno = "" Then
				tabno = "1"
			end if
			findcdc = oJSONoutput.get("FINDCDC") '찾을종목
			if findcdc = "" Then
				findcdc = "자유형50m"
			end if


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
			fld = "gametitleidx,titlename,   gamedate,cdcnm,roundstr,cdbnm,teamnm,gameresult,gameorder,UserName,gubun,UserName2,UserName3,UserName4,rctype "
			select case tabno
			case "1"
			'playeridx, playeridx2 , playeridx3, playeridx4
				wherestr = " delyn = 'N' and ( playeridx = '"&pidx&"' or playeridx2= '"&pidx&"' or playeridx3 = '"&pidx&"' or playeridx4 = '"&pidx&"' ) "
				SQL = "Select "&fld&" from  tblrecord where  "&wherestr&"  order by gameDate desc "
			case "2"

				SQL = "select teamgb,teamgbnm from tblTeamGbInfo where pteamgb='D2' and cd_type= 1 and delyn = 'N' and (teamgb < 30 or teamgb in (64,65 ,85,86,87)) order by orderby"
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrG = rs.GetRows()
				End If


				wherestr = " delyn = 'N' and ( playeridx = '"&pidx&"' or playeridx2= '"&pidx&"' or playeridx3 = '"&pidx&"' or playeridx4 = '"&pidx&"' ) and cdcnm like '%"&findcdc&"%' "
				SQL = "Select "&fld&" from  tblrecord where  "&wherestr&"  order by gameDate desc "
			case "3"

				wherestr = " delyn = 'N' and ( playeridx = '"&pidx&"' or playeridx2= '"&pidx&"' or playeridx3 = '"&pidx&"' or playeridx4 = '"&pidx&"' ) and cdcnm like '%"&findcdc&"%' "
				SQL = ";with tblrc as "
				SQL = SQL & "(Select ROW_NUMBER() Over(Partition By cdc Order By gameresult) as rcorder , "&fld&" from  tblrecord where " & wherestr & ")"
				SQL = SQL & "select "&fld&" from tblrc where rcorder = 1 "

			case "4"
			'playeridx, playeridx2 , playeridx3, playeridx4
				wherestr = " delyn = 'N' and ( playeridx = '"&pidx&"' or playeridx2= '"&pidx&"' or playeridx3 = '"&pidx&"' or playeridx4 = '"&pidx&"' ) and gamedate >= '"&year(date)& "-01-01" &"' "
				SQL = "Select "&fld&" from  tblrecord where  "&wherestr&"  order by gameDate desc "

			end select

			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




'response.write sql

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
        <a href="/main/index.asp" class="m_header__backBtn">이전</a>
        <h1 class="m_header__tit">선수조회</h1>
        <!-- #include file="../include/header_gnb.asp" -->
     </div>
  </div>


  <div class="l_content m_scroll [ _content _scroll ]">

	   <div class="player-info">
			<div class="player-info__header">
				<h2><%=unm%></h2>
				<button @click="openSearching('.searchPopup')" class="player-info__header__btn-search" type="button">선수검색</button>
			</div>
			<ul class="player-info__list">
				<li>
					<dl>
						<dt>성별</dt>
						<dd><%=sexstr%></dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt>생년월일</dt>
						<dd><%=Left(bd,2)%>.<%=mid(bd,3,2)%>.<%=right(bd,2)%></dd>
					</dl>
				</li>
				<li class="t_w100">
					<dl>
						<dt>소속</dt>
						<dd><%=tnm%></dd>
					</dl>
				</li>
			</ul>
	   </div>

		<div class="player-info__tab">
			<button <%if tabno ="1" then%>class="s_on"<%end if%> type="button" onclick="px.goSubmit({'PIDX':<%=pidx%>,'TABNO':'1'},'./psearch.asp');">이력</button>
			<button <%if tabno ="2" then%>class="s_on"<%end if%> type="button" onclick="px.goSubmit({'PIDX':<%=pidx%>,'TABNO':'2'},'./psearch.asp');">종목별 기록</button>
			<button <%if tabno ="3" then%>class="s_on"<%end if%> type="button" onclick="px.goSubmit({'PIDX':<%=pidx%>,'TABNO':'3'},'./psearch.asp');">최고기록</button>
			<button <%if tabno ="4" then%>class="s_on"<%end if%> type="button" onclick="px.goSubmit({'PIDX':<%=pidx%>,'TABNO':'4'},'./psearch.asp');">당해기록/순위</button>
		</div>


		<%if tabno = "2" or tabno = "3" then%>
		<div class="player-info__option">
			<div class="player-info__option__box">
				<span>경영</span>
				<div>
					<select id="cdc" onchange="px.goSubmit({'PIDX':<%=pidx%>,'TABNO':'<%=tabno%>','FINDCDC':this.value},'./psearch.asp');">
				<%
				If IsArray(arrG) Then
					For a = LBound(arrG, 2) To UBound(arrG, 2)
						b_temgb  = arrG(0, a)
						b_temgbnm  = arrG(1, a)
				%>				
						<option value="<%=b_temgbnm%>" <%if findcdc =b_temgbnm then%>selected<%end if%>><%=b_temgbnm%></option>
				<%
					Next
				End if
				%>
<!-- 						<option value="배영" <%if findcdc ="배영" then%>selected<%end if%>>배영</option> -->
<!-- 						<option value="평영" <%if findcdc ="평영" then%>selected<%end if%>>평영</option> -->
<!-- 						<option value="접영" <%if findcdc ="접영" then%>selected<%end if%>>접영</option> -->
<!-- 						<option value="계영" <%if findcdc ="계영" then%>selected<%end if%>>계영</option> -->
<!-- 						<option value="혼영" <%if findcdc ="혼영" then%>selected<%end if%>>혼영</option> -->
					</select>
				</div>
			</div>
		</div>
		<%end if%>


		<div class="player-info__con">
			<h3 class="hide">이력</h3>
			<ul class="player-info__con__list">

			<%
				If IsArray(arrR) Then
					For ari = LBound(arrR, 2) To UBound(arrR, 2)
						l_titlecode  = arrR(0, ari)
						l_titlename = arrR(1, ari)
						l_gamedate = Replace(Left(arrR(2, ari),10),"-",".")
						l_cdcnm = arrR(3, ari)
						l_roundstr = isnulldefault(arrR(4, ari),"--")
						l_cdbnm = arrR(5, ari)
						l_teamnm = arrR(6, ari)
						l_gameresult = arrR(7, ari)
						l_gameorder = arrR(8, ari)
						l_UserName = arrR(9, ari)
						l_gubun = arrR(10, ari)
						l_UserName2 = arrR(11, ari)
						l_UserName3 = arrR(12, ari)
						l_UserName4 = arrR(13, ari)
						l_rctype = RCSTR(arrR(14,ari))
			'###############################################
			select case TABNO
			case "1","2","4"
			%>
			<%If ari = 0 then%>
				<li>
					<div class="player-info__con__list__header">
						<h4><%=l_titlename%></h4>
						<span></span>
					</div>
					<table class="player-info__con__list__table">
						<tbody>

			<%'elseIf ari > 0 And l_titlename <> pre_title then%>
			<%elseIf ari > 0 And l_titlecode <> pre_titlecode then%>
						</tbody>
					</table>
				</li>
				<li>
					<div class="player-info__con__list__header">
						<h4><%=l_titlename%></h4>
						<span></span>
					</div>
					<table class="player-info__con__list__table">
						<tbody>
			<%End if%>
						<tr>
							<th>
								<div>
									<span><%=l_gamedate%></span>
									<span><em><%=l_cdcnm%></em></span>
									<span><%=l_roundstr%></span>
								</div>
								<span><%=l_cdbnm%></span>
								<span><%=l_teamnm%></span>
							</th>
							<td>
								<span><%=l_gameorder%>위 <em><%If l_rctype <> "" then%>[<%=l_rctype%>]<%End if%></em></span>
								<%Call SetRC(l_gameresult)%>
							</td>
						</tr>
			<%
			case "3"
			%>
				<li>
					<div class="player-info__con__list__header">
						<h4><%=l_cdcnm%></h4>
						<span><%=l_titlename%></span>
					</div>
					<table class="player-info__con__list__table">
						<tbody>
							<tr>
								<th>
									<div>
										<span><%=l_gamedate%></span>
										<span><em><%=l_cdcnm%></em></span>
										<span><%=l_roundstr%></span>
									</div>
									<span><%=l_cdbnm%></span>
									<span><%=l_teamnm%></span>
								</th>
								<td>
									<span><%=l_gameorder%>위 <em><%If l_rctype <> "" then%>[<%=l_rctype%>]<%End if%></em></span>
									<%Call SetRC(l_gameresult)%>
								</td>
							</tr>
						</tbody>
					</table>
				</li>
			<%
			end select
			'###############################################
				pre_title = l_titlename
				pre_titlecode = l_titlecode
				Next
			Else
			end if
			%>
					</tbody>
				</table>
			</li>


			</ul>
		</div>




















<%if aaa = "원본" then%>
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
<%end if%>









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
		   px.goSubmit({'PIDX':pidx},'./psearch.asp');
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
