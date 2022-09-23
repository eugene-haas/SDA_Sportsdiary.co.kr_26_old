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
		If hasown(oJSONoutput, "DD") = "ok" then
			dd = oJSONoutput.DD
		End if
	End if



	If isnumeric(tidx) Then

			SQL = "select gametitlename , gameS,gameE,gamearea from sd_gameTitle where gametitleidx = '"&tidx&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				title = rs(0)
				gameS = rs(1)
				gameE = rs(2)
				gamearea = rs(3)
			End if

			'설정날짜
			SQL = "select idx,gamedate,am,pm,selectflag from sd_gameStartAMPM where tidx = "& tidx & " order by gamedate"
			Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rss.EOF Then
				tmarr = rss.GetRows()
				last_gamedate= tmarr(1, UBound(tmarr, 2))
			End If

			If IsArray(tmarr) Then
				For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
					tm_selectflag = tmarr(4, ari)

					If ari = 0 Then
						start_gamedate = isNullDefault(tmarr(1, ari), "")
						start_am = isNullDefault(tmarr(2, ari), "")
						start_pm = isNullDefault(tmarr(3, ari), "")
					End If

					If isNullDefault(tmarr(1, ari), "") = dd Then
						start_gamedate = isNullDefault(tmarr(1, ari), "")
						start_am = isNullDefault(tmarr(2, ari), "")
						start_pm = isNullDefault(tmarr(3, ari), "")
					End If

				Next
			End if


		  '++++++++++++++++++++++++
		  If start_gamedate = "" Then
			'날짜 생성전
		  else

			'오전
			fld = " min(RGameLevelidx),CDC,CDCNM,min(tryoutgamedate) ,min(tryoutgamestarttime) ,min(gameno) as gameno,gubunam "
			SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and CDA = 'D2' and tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0 "
			SQL = SQL & " group by cdc,cdcnm,gubunam order by gameno "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				arrR = rs.GetRows()
			End If

			fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2 "
			fld = " min(RGameLevelidx),CDC,CDCNM,min(finalgamedate) ,min(finalgamestarttime),min(gameno2) as gameno2,gubunpm "

			SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and CDA = 'D2' and finalgamedate = '"&start_gamedate&"' and finalgameingS > 0 "
			SQL = SQL & " group by cdc,cdcnm,gubunpm order by gameno2 "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				arrR2 = rs.GetRows()
			End If

		  End if



	End if


	weekarr = array("-", "일","월","화","수","목","금","토")


	'생성된 종목만 보이게 (경영, 아티스틱,,)
	SQL = "select cda,cdanm from tblRGameLevel where gametitleidx = "&tidx&" group by CDA ,cdanm"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		arrMn = rs.GetRows()

		If UBound(arrMn, 2)  = "0" Then
			m_CDA= arrMn(0, 0)
			m_CDANM = arrMn(1,0)
		Else
			m_CDA= "D2"
			m_CDANM = "경영"
		End if
		

	End if
%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
</head>
<body <%=CONST_BODY%>>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>




<div id="app" class="l contestInfo" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
	  <a href="/Result/institute-search.asp?reqdate=<%=gameS%>" class="m_header__backBtn">이전</a>
  		<h1 class="m_header__tit">대회일정</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

		<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->

	<div class="calender">
      <div class="l_content">
        <h2 class="m_resultTit">
          <span><%=title%></span><%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) <%=gamearea%>
        </h2>
        <div class="day_select_box">

		  <select class="day_select" id="gamedd" onchange="px.goSubmit({'TIDX':<%=tidx%>,'DD':$(this).val()},'contest_info.asp?tidx=<%=tidx%>');">
			<%
					If IsArray(tmarr) Then
						For ari = LBound(tmarr, 2) To UBound(tmarr, 2)

							tm_idx = tmarr(0, ari) 'idx
							tm_gamedate= Left(tmarr(1, ari),10)
							tm_am= tmarr(2, ari)
							tm_pm= tmarr(3, ari)
							tm_selectflag= tmarr(4, ari)

							tm_week = weekarr(weekday(tm_gamedate))

							If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) Then
								find_gbidx = l_gbidx
								find_cdc = l_CDC  '기준 배영200m
							End if

							%><option value="<%=tm_gamedate%>" <%If tm_gamedate = start_gamedate then%>selected<%End if%>><%= tm_gamedate%>&nbsp;&nbsp;<%=tm_week%></option><%
						Next
					End if
			%>
          </select>



        </div>
        <div class="contest_file">
          <ul class="table_box">
            <li><span><%=m_CDANM%></span>
              <table id="swtable">
                <thead>
                  <tr>
                    <th>오전경기 <%=start_am%> ~</th>
                  </tr>
                </thead>
                <tbody>
					<%
						If IsArray(arrR) Then  '오전
							For ari = LBound(arrR, 2) To UBound(arrR, 2)

								l_idx = arrR(0, ari)
								l_CDC = arrR(1, ari)
								l_CDCNM = arrR(2, ari)
								l_tryoutgamedate = arrR(3, ari)
								l_tryoutgamestarttime = arrR(4, ari)
								l_gubun = arrR(6, ari)
								If l_gubun = "1" Then
								gubunstr = "예선"
								Else
								gubunstr = "결승"
								End if
								l_week = weekarr(weekday(l_tryoutgamedate))


						%>
									  <tr>
										<td><%=l_CDCNM%></td>
									  </tr>
						<%
							Next
						End if
					%>

                </tbody>
              </table>
              <table id="swtable">
                <thead>
                  <tr>
                    <th>오후경기  <%=start_pm%> ~</th>
                  </tr>
                </thead>
                <tbody>
					<%
						If IsArray(arrR2) Then
							For ari = LBound(arrR2, 2) To UBound(arrR2, 2)

								l_idx = arrR2(0, ari)
								l_CDC = arrR2(1, ari)
								l_CDCNM = arrR2(2, ari)
								l_finalgamedate = arrR2(3, ari)
								l_finalgamestarttime = arrR2(4, ari)
								l_gubun = arrR2(6, ari)
								If l_gubun = "1" Then
								gubunstr = "예선"
								Else
								gubunstr = "결승"
								End if

						%>
									  <tr>
										<td><%=l_CDCNM%></td>
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
      </div>
    </div>



  <!-- E: main -->
  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>









<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  let app=new Vue({
    el:"#app",
    data:{
      // contestTitle:"농림축산식품부장관배 전국승마대회",
      contestTitle:"",
      addFile:false,// 첨부 파일이 있는지
      addFileView:false,// 첨부 파일 목록이 화면에 보이는지
      addFileList:[],//다운로드 파일들
      contest_info:"",// 대회 내용
      loading:false,// data불러왔는지 유무

      tidx:null,


      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      // 첨부파일 가져오기
      addFileData:function(url){
        axios.get(url).then(response=>{
          this.addFileList=response.data.jlist;
          this.addFile=true;

          // 첨부파일 위치
          this.$nextTick(function(){
            // let addfilebox=document.querySelector(".l_contest_file__list");
						let addfilebox=document.querySelector("._fileList");
            addfilebox.setAttribute("style", "margin-top:-"+addfilebox.clientHeight+"px");
          });
        });
      },

      // 첨부파일 보기
      addFileShow:function(){
        // let addfilebox=document.querySelector(".l_contest_file__list");
				let addfilebox=document.querySelector("._fileList");
        if(this.addFileView){
          this.addFileView=false;
          addfilebox.classList.remove("s_on");
          addfilebox.setAttribute("style", "margin-top:-"+addfilebox.clientHeight+"px");
        }else{
          this.addFileView=true;
          addfilebox.classList.add("s_on");
          addfilebox.setAttribute("style", "margin-top:0px");
        }
      },
      // 파일 전체 받기
      fileDownAll:function(){
        let alldown=document.createElement("a");
        alldown.setAttribute("download","download");
        alldown.style.display="none";
        document.body.appendChild(alldown);
        for(var i=0;i<this.addFileList.length;i++){
          alldown.setAttribute("href", this.addFileList[i].file);
          alldown.click();
        }
        document.body.removeChild(alldown);
      },

      // 대회명
      gameTitle:function(){
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63000","tidx":"'+this.tidx+'"}').then(response=>{
          this.contestTitle=response.data.jlist[0].title;
        },(error)=>{
          console.log("error. gameTitle");
          console.log(error);
        });
      },
      // 대회 내용
      gameInfo:function(){
        this.loading=true;
        // axios.get('testcontestinfo2.html').then(response=>{
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62100","tidx":"'+this.tidx+'"}').then(response=>{
          this.contest_info=response.data;
          this.setTarget();
          this.loading=false;
        },(error)=>{
          console.log("error. gameInfo");
          console.log(error);
        });
      },
      setTarget:function(){
        setTimeout(() => {
          if(this.contest_info!=""){
            document.querySelector(".contestFile").querySelectorAll("a").forEach((obj,index,ary)=>{
              let href=obj.getAttribute("href");
              console.log(href);
              obj.setAttribute("href", "javascript:alert('sportsdiary://urlblank=https://docs.google.com/viewer?url="+href+"');");
            });
          }else{
            this.setTarget();
          }
        },10);
      }
    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }

      if(window.matchMedia("(orientation:landscape)").matches){
        $("html").addClass("landscape");
      }else{
        $("html").removeClass("landscape");
      }
      window.addEventListener("orientationchange", function(){
        if(window.matchMedia("(orientation:portrait)").matches){
          $("html").addClass("landscape");
        }else{
          $("html").removeClass("landscape");
        }
      },false);


      // 위에서 tidx는 지정한 이유는, 이 파일을 바로 열었을 때의 확인용 값
      let urlparam_tidx=location.href.indexOf("tidx=");
      if(urlparam_tidx>0){
        let param_tidx=location.href.substr(urlparam_tidx+5);// +5는 t i d x = 다음의 위치
        this.tidx=param_tidx;
      }

      // 첨부파일 위치
      // let addfilebox=document.querySelector(".l_contest_file__list");
			// let addfilebox=document.querySelector("._fileList");
      // addfilebox.setAttribute("style", "margin-top:0");
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }
      // 첨부파일
      // this.addFileData("testContestinfo.html");// 확인용 json

      //this.gameTitle();// 대회명
      //this.gameInfo();// 내용
    },
  });
</script>
</body>
</html>
