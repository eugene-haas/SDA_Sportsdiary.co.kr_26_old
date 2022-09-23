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



<div id="app" class="l matchSch" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->
  <div class="l_header">
     <div class="m_header s_sub">
        <a href="../main/index.asp" class="m_header__backBtn">이전</a>
        <h1 class="m_header__tit">신기록</h1>
        <!-- #include file="../include/header_gnb.asp" -->
     </div>
  </div>
  <div class="l_content m_scroll [ _content _scroll ]">
     <div class="match-result">
        <div class="match-result-con">
           <div class="match-result-con__search clear" id="NewMatch">
             <div class="match-result-con__search__box-selc">
               <label class="hide" for="">범위 선택</label>
               <select class="match-result-con__search__box-selc__selc" onchange="mx.getRC(<%=tidx%>,$('#rctype').val(),$('#boono').val())">
            		<option value="">자유형</option>
               </select>
             </div>
             <div class="match-result-con__search__box-selc">
               <label class="hide" for="">종목 선택</label>
               <select class="match-result-con__search__box-selc__selc" onchange="mx.getRC(<%=tidx%>,$('#rctype').val(),$('#boono').val())">
      				<option value="">대회기록</option>
               </select>
             </div>
           </div>

           <div class="match-result-con__tab-box" id="sw_gametable">
              <h3 class="hide">신기록 표</h3>
              <table class="match-new-result1-con__tab-box__con">
                 <tr>
                    <th scope="rowgroup" rowspan="2">60m</th>
                    <td>남</td>
                    <td>
                       <strong>홍길동(강원도청)</strong>
                       2020광주세계수영선수권대회
                       <span>00:22:30</span>
                    </td>
                 </tr>
              </table>
           </div>
        </div>
     </div>
  </div>
  <!-- #include file= "../include/bot_config.asp" -->

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
