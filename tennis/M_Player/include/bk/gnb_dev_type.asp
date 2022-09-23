<%
    Check_Login()
  	
	dim obj_val 	: obj_val 		= Request("obj_val")
	dim active_val 	: active_val 	= Request("active_val")
	
	'회원구분에 따른 메뉴 Class 처리
	SELECT CASE decode(request.Cookies("PlayerReln"), 0)
		CASE "D" 			: Type_Class = "mono-type"		'일반회원 gnb Class
		CASE "A", "B", "Z" 	: Type_Class = "parents-type"	'선수보호자회원 gnb Class
	END SELECt	
	
	
	IF obj_val = "" and active_val = "" Then
		obj_val = 0
		active_val = ""
	Else 
		IF active_val <> "" Then 
			obj_val = 1 
		Else
			obj_val = 0
		End IF  
	End IF
%>
<script type="text/javascript"> 
	function chk_logout(){
		var expdate = new Date();
		
		if(confirm("로그아웃 하시겠습니까?")){
			expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
			setCookie("sd_saveid", "", expdate);
			setCookie("sd_savepass", "", expdate);
			
			var strAjaxUrl = "/M_Player/Ajax/logout.asp";
			
			$.ajax({
				url: strAjaxUrl,
				type: 'POST',
				dataType: 'html',     
				data: { 
						},    
				success: function(retDATA) {
					if(retDATA){
						if (retDATA=="TRUE") {
							alert("정상적으로 로그아웃 되었습니다.\n로그인 후 서비스를 이용하세요");
							
							//$(location).attr('replace','/M_Player/Main/login.asp');   //a href            
							window.location.replace("/M_Player/Main/login.asp");
							
						}else{
							alert('로그아웃중에 오류가 발생하였습니다.');      
							return;
						}
					}
				}, error: function(xhr, status, error){           
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
					return;
				}
			});
		}
		else{
			return; 
		}
	
	}
  
  	//쿠키정보 저장	
	function setCookie(name, value, expiredays){
		var todayDate = new Date();

		todayDate.setDate (todayDate.getDate() + expiredays);
		document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";";
	}
  
  	function getCookie(cName) {
        cName = cName + '=';
        
		var cookieData = document.cookie;
        var start = cookieData.indexOf(cName);
        var cValue = '';
        
		if(start != -1){
            start += cName.length;
        
			var end = cookieData.indexOf(';', start);
            
			if(end == -1)end = cookieData.length;
            
			cValue = cookieData.substring(start, end);
        }
        return unescape(cValue);
    }
  

  
	//소속 팀매니저 가입체크
	function chk_TeamNotice(){
		var strAjaxUrl="/M_Player/ajax/Main_ChkTeamManager.asp";
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',   
			data: {},
			success: function(retDATA) {
				if(retDATA=="FALSE"){ 
				//팀매니저 미가입시 Modal OPEN   
				/*
				if (getCookie("TNOTICE") != "done"){
				$("#not-medal-list").modal();           
				}
				*/ 
				//$("#not-medal-list").modal();     
				
					alert("팀공지사항은 팀매니저가 관리시 확인하실 수 있습니다.");
					return;
					
				
				}
				else{
					$('form[name=frm]').attr('action',"/M_Player/board/team-notice-list.asp");
					$('form[name=frm]').submit(); 
					
					$(location).attr('href', "/M_Player/board/team-notice-list.asp");
				}
			}, error: function(xhr, status, error){
				alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
			}
		});            
	}
  
  //메뉴 신규데이터 new Icon 표시체크(24시간)
  function CHK_NEWDATA(valTYPE, valTYPESUB){
    var strAjaxUrl="/M_Player/ajax/check_NewData.asp";
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',   
      data: { 
          TypeMenu  : valTYPE 
      ,TypeMenuSub : valTYPESUB
        },
      success: function(retDATA) {
        
    if(retDATA=="TRUE"){ 
      $("#GNB"+valTYPE+valTYPESUB).show();   
      $("#SUB"+valTYPE+valTYPESUB).show();          
    }
    else{
      $("#GNB"+valTYPE+valTYPESUB).hide();    
      $("#SUB"+valTYPE+valTYPESUB).hide();           
    }

    }, error: function(xhr, status, error){
        alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        return;
      }
    }); 
  }
  
  /**
   * 기간선택, 기간조회 index 넘기기
   */
  var objDlId; // 기간선택 0(selected), 1
  var objActiveId; // 기간조회 0(SDate), 2(EDate), 3(SDate, Edate)
  
  function loadTermSel(objDlId, objActiveId){

    // 첫 로드시 선택
    if (objDlId == undefined || objDlId == "" || objDlId == 0){
      objDlId = 0;
      $(".sel-list").find('dl').eq(objDlId).addClass('on');
    }
    else{
      $(".sel-list").find('dl').eq(objDlId).removeClass('on');
      objDlId = 1;
    }

    if (objActiveId == undefined) {
      $(".sel-list").find('dl').eq(objDlId).find('dd').find('input').removeClass('on');  
      return;
    } 
    else if (objDlId == 1) {
      $(".sel-list").find('dl').eq(objDlId).addClass('on');
      $(".sel-list").find('dl').eq(objDlId).find('dd').eq(objActiveId).find('input').addClass('active');
      if (objActiveId == 3) {
        // 둘다 선택시
        // $(".sel-list").find('dl').eq(objDlId).find('dd').find('input').addClass('active');
        $(".sel-list").find('dl').eq(objDlId).find('dd input').addClass('active');
      }
    } 
    else {
    $(".sel-list").find('dl').eq(objDlId).find('dd input').removeClass('active');   
      return;
    }
    // 첫 로드시 선택
  
//  console.log(objDlId);
//  console.log(objActiveId);
  
    if(objDlId!="") $("#obj_val").val(objDlId);
    if(objActiveId!="") $("#active_val").val(objActiveId);
  
  } 
    

  $(document).ready(function(){
    
    CHK_NEWDATA("TNOTICE","");          //팀공지사항
    CHK_NEWDATA("NOTICE","");           //커뮤니티[공지사항]
    CHK_NEWDATA("TRAIN","");            //훈련일지
    CHK_NEWDATA("GAME","");           //대회일지
    CHK_NEWDATA("STRENGTH","");         //체력측정    
    CHK_NEWDATA("COUNCEL","");          //지도자상담모아보기    
  	CHK_NEWDATA("COUNCELRE","");          //지도자상담모아보기 답변
    CHK_NEWDATA("COUNCEL","TRAIN");     //지도자상담[훈련일지]    
    CHK_NEWDATA("COUNCEL","GAME");      //지도자상담[대회일지]      

  
  
   
   
//  alert("objDlId="+objDlId+" objActiveId:"+objActiveId);
  
    $('.obj_val').val(objDlId);
    $('.active_val').val(objActiveId);
  
//  console.log('objDlId='+objActiveId+', objActiveId='+objActiveId);
//  console.log('obj_val=<%=request("obj_val")%>, active_val=<%=request("active_val")%>');
  
    loadTermSel('<%=obj_val%>', '<%=active_val%>');
  
  
  });
  
  
  $(function() {
    // on 위치 넘기기 - input hidden 방식 (input 태그 추가 필요)
    function onPosVal(){
      var $iptOnVal = $('input.on_val');
      var $selList = $('form[name="s_frm"] .sel-list dl').filter('.on');
      var selListN = $selList.index();
      $iptOnVal.value = selListN;
 //     console.log('input value = ',$iptOnVal.value);
    }
    
    $("#iyear").on('click', function(){
      fupdate($(this));
    });
    $("#iMatchTitle").on('click, change', function(){
      fupdate($(this));
    });
    $("#SDate").on('click, change', function() {
      fupdate($(this));
      
//      console.log(objDlId);
//      console.log(objActiveId);
      
      $("#on_val").val(objDlId);
      $("#active_val").val(objActiveId);
    
    });
      
    $("#EDate").on('click, change', function() {
      fupdate($(this));
//      console.log(objDlId);
//      console.log(objActiveId);
      
      $("#on_val").val(objDlId);
      $("#active_val").val(objActiveId);
    });
    
    $("#search_date_id").on('click', function() {
      fupdate($(this));
//      console.log(objDlId);
//      console.log(objActiveId);
      
      $("#on_val").val(objDlId);
      $("#active_val").val("");
    });
  });
  

  //검색조건 날짜 CSS컨트롤  
  var fupdate = function (obj){
//    objDlId;
//    objActiveId;

    if (obj.attr("id") == "iyear" || obj.attr("id") == "iMatchTitle") {
      $(obj).parents('dl').addClass('on');
      $(obj).parents('dl').siblings('dl').removeClass('on');
      console.log('iyear');
    }

    if(obj.attr("id") != "search_date_id"){
    
      
      // $("#"+obj).css("background-color","#777");
      // $("#"+obj).css("color","#fff").parents('dl').addClass('on'); 
      // $("#search_date_id").css("background-color","#FFF");
      // $("#search_date_id").css("color","#000").parents('dl').removeClass('on');
      $(obj).addClass("active").parents('dl').addClass('on');
      
    objActiveId = ($('#SDate').addClass("active").parents('dd').index() - 1);
    objActiveId = ($('#EDate').addClass("active").parents('dd').index() - 1);
      
    $("#search_date_id").parents('dl').removeClass('on');
      
    if (obj.attr('id') == "SDate") {
       /*
     if ($("#EDate").hasClass("active")) {
          objActiveId = 3;
        }
    */
    objActiveId = 3;
      }
      
    if (obj.attr('id') == "EDate") {
        /*
    if ($("#SDate").hasClass("active")) {
          objActiveId = 3;
        }
    */
    objActiveId = 3;
      }
    }
    else {
     
      $(obj).parents('dl').addClass('on');
      // $("#SDate").css("background-color","#FFF");
      // $("#EDate").css("background-color","#FFF");
      // $("#SDate").css("color","#000");
      // $("#EDate").css("color","#000").parents('dl').removeClass('on');
      $("#SDate").removeClass("active").parents('dl').removeClass('on');
      $("#EDate").removeClass("active").parents('dl').removeClass('on');
    }
  
  $('#active_val').val(objActiveId);
  
    objDlId = $(obj).parents('dl').index();
    // console.log(objDlId);
    // console.log(objActiveId);

    // return objDlId;
  }

 
  // label 밑의 input 실행
  function inputExc($this){
    var ipt = $this.find('input');
  
  //console.log("ipt="+ipt);
  
    if ($this.hasClass('on')) {
      ipt.prop('checked', false);
    } else {
      ipt.prop('checked', true);
    }
  }
  

  //하루동안 보지않기
  function closePop(valCook){
    if ($('input:checkbox[id="chk_day_'+valCook+'"]').is(":checked") == true){      
      setCookie(valCook, "done", 1);
    }
  }
</script>

<div class="gnb <%=Type_Class%>">
  <!-- <div class="gnb-box"> -->
    <!-- S: gnb-header -->
    <div class="gnb-header clearfix">
      <!-- S: profile 사진 -->
      <div class="profile">
        <img id="imgGnb" src="<%=decode(Request.Cookies("PhotoPath"), 0)%>" alt="프로필 사진">
      </div>
      <!-- E: profile 사진 -->
      <!-- S: 환영, 로그아웃 -->
      <div class="welcome">     
        <h2><span><%=Request.Cookies("UserName")%></span> 님 환영합니다.</h2>
        <a href="javascript:chk_logout();" class="login">로그아웃</a>
      </div>
      <!-- E: 환영, 로그아웃 -->
      <!-- S: gnb icon -->
      <div class="gnb-icon clearfix">
        <a href="../Main/index.asp">
          <img src="../images/include/gnb/home@3x.png" alt="홈으로 이동">
        </a>
        <a href="#" class="close-btn">
          <img src="../images/include/gnb/X@3x.png" alt="닫기">
        </a>
      </div>
      <!-- E: gnb icon -->
    </div>
    <!-- E: gnb-header -->
    <!-- S: navi-list 1-->
    <ul class="navi-list type1 non flex">
      <li>
        <a href="../Train/train.asp"><span class="img-box"><img src="../images/include/gnb/icon_pract_off@3x.png" alt></span><span class="menu-txt">훈련일지<span id="GNBTRAIN" style="display:none" class="ic-new">N</span></span></a>
      </li>
      <li>
        <a href="../MatchDiary/match-diary.asp"><span class="img-box"><img src="../images/include/gnb/icon_match_off@3x.png" alt></span><span class="menu-txt">대회일지<span id="GNBGAME" style="display:none" class="ic-new">N</span></span></a>
      </li>
    </ul>
    <!-- E: navi-list 1 -->
    <!-- S: navi-list 2 -->
    <ul class="navi-list type1 non flex">
      <li>
        <a href="../Strength/index.asp"><span class="img-box"><img src="../images/include/gnb/icon_physi_off@3x.png" alt></span><span class="menu-txt">체력측정<span id="GNBSTRENGTH" style="display:none" class="ic-new">N</span></span></a>
      </li>
      <li>
        <!-- 팀 매니저 미가입시 <a href="#" data-toggle="modal" data-target="#now-ready"><span><img src="../images/include/gnb/icon_plan_off@3x.png" alt></span><span>팀 공지사항</span></a> -->
        <a href="javascript:chk_TeamNotice();"><span class="img-box"><img src="../images/include/gnb/icon_plan_off@3x.png" alt></span><span class="menu-txt">팀 공지사항<span id="GNBTNOTICE" style="display:none" class="ic-new">N</span></span></a>
      </li>
    </ul>
    <!-- E: navi-list 2 -->
    <ul class="navi-list type2 flex">
      <!-- <li>
        <a href="../Board/team-notice-list.asp">
        //<a href="" data-toggle="modal" data-target="#now-ready">
          <span><img src="../images/include/gnb/ic-notice@3x.png" alt></span>
          <span>팀 공지사항</span>
        </a>
      </li> -->
      <!-- <li>
        <a href="#">
          <span><img src="../images/include/gnb/ic-video@3x.png" alt></span>
          <span>대회 영상 모음</span>
        </a>
      </li> -->
      <li class="">
        <a href="../Counsel/req_counsel.asp?typeMenu=req_counsel">
          <span class="img-box"><img src="../images/include/gnb/ic-coach@3x.png" alt></span>
          <span class="menu-txt">지도자 상담</span>
        </a>
      </li>
    </ul>
    <ul class="navi-list type3 flex">
      <li>
        <a href="#">
          <span class="img-box"><img src="../images/include/gnb/icon_myinfo_whity@3x.png" alt></span>
          <span class="menu-txt">마이페이지</span>
        </a>
      </li>
    </ul>
    <!-- S: cate-list -->
    <div class="cate-list">
      <!-- S: 나의 정보 -->
      <dl class="non-type3 clearfix">
        <!--상위메뉴-->
        <dt>나의 정보</dt>
        <!--상위메뉴-->
        <dd><a href="../Mypage/mypage.asp">마이페이지</a></dd>
        <dd class="non-type2"><a href="../Schedule/sche-calendar.asp">나의 훈련 일정</a></dd>
        <dd class="non-type2"><a href="../Stats/stat-training-attand.asp">나의 통계</a></dd>
        <dd class="non clearfix"><a href="../Memory/memory-estimate.asp"><span class="menu-txt">메모리</span></a><span class="ic-wrap clearfix"><span id="GNBCOUNCEL" style="display:none" class="ic-new">N</span><span id="GNBCOUNCELRE" style="display:none" class="ic-re">Re</span></span></dd>
      </dl>
      <!-- E: 나의 정보 -->
      <!-- S: 대회 정보 -->
      <dl class="clearfix">
        <!--상위메뉴-->
        <dt>대회 정보</dt>
        <!--상위메뉴-->
        <dd><a href="../Result/institute-search.asp">대회일정/결과</a></dd>
        <dd><a href="../Record/record-srch-win.asp">경기 기록실</a></dd>
        <dd><a href="../Analysis/analysis-match-result.asp">선수분석</a></dd>
        <!--//<dd><a href="../Enter/application.asp">대회 참가 신청 내역</a></dd>-->
        <dd><a href="../Analysis/analysis-film.asp">대회영상모음</a></dd>
      </dl>
      <!-- E: 대회 정보 -->
      <!-- S: 대회참가신청 -->
      <!--
      <dl class="clearfix">
        <dt><a href="#">대회참가신청</a></dt>
        <dd><a href="#">참가신청</a></dd>
        <dd><a href="#">신청 내역 확인</a></dd>
      </dl>
      -->
      <!-- E: 대회참가신청 -->
      <!-- S: 게시판 -->
      <!--
      <dl class="clearfix">
        <dt><a href="#">게시판</a></dt>
        <dd><a href="#">공지사항</a></dd>
        <dd><a href="#">기타일정</a></dd>
      </dl>
      -->
      <!-- E: 게시판 -->
      <!-- S: 커뮤니티 -->
      <dl class="clearfix">
        <dt>커뮤니티</dt>
        <dd><a href="../Board/notice-list.asp"><span class="menu-txt">공지사항<span id="GNBNOTICE" style="display:none;" class="ic-new">N</span></span></a></dd>
        <dd><a href="../Board/qa_board.asp">Q&amp;A 게시판</a></dd>
        <!-- <dd><a href="#">기술전수 칼럼</a></dd> -->
        <!-- <dd><a href="#">유도 소식</a></dd> -->
        <!-- <dd><a href="#">SD 사용후기</a></dd> -->
        <!-- <dd><a href="#">생활체육 소식</a></dd> -->
      </dl>
      <!-- E: 커뮤니티 -->
    </div>
    <!-- E: cate-list -->
    <div class="gnb-footer">
      <ul class="clearfix">
        <li class="r-bar">
          <a href="../Map/company.asp">사업자정보</a>
        </li>
        <li class="r-bar">
          <a href="../Board/faq.asp">자주하는 질문</a>
        </li>
        <li>
          <a href="../Map/info-map.asp">단체정보조회</a>
        </li>
      </ul>
      <h3><img src="../images/include/footer/bottom-logo_judo@3x.png" alt="스포츠다이어리 유도"></h3>
    </div>
  <!-- </div> -->
  <!-- E: gnb-box -->
</div>
<!-- S: tops top-btn -->
<div class="tops btn-div">
  <a href="#" class="top_btn">TOP</a>
</div>
<!-- E: tops top-btn -->
<!-- S: modal now-ready -->
<div class="modal fade in confirm-modal record-notice" id="not-medal-list" tabindex="-1" role="dialog" aria-hidden="true" style="display:none;">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="../images/public/close-x@3x.png" alt="닫기"></span></button>
        <h4 class="modal-title" id="myModalLabel">알림</h4>
      </div>
      <div class="modal-body">
        <p class="pop-guide">지도자가 팀매니저 관리 시<br>확인하실 수 있습니다.</p>
      </div>
      
      <div class="modal-footer clearfix">
          <!--
          <label class="img-replace" onClick="inputExc($(this));"><input type="checkbox"><span>오늘 하루 보지 않기</span></label>
          -->
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="closePop('TNOTICE');">닫기</button>
        </div>
      <!--  
      <div class="modal-footer">
          <label class="img-replace" onClick="inputExc($(this));">
            <input id="chk_day_TNOTICE" type="checkbox" />
            <span>오늘 하루 보지 않기</span> </label>
          <button type="button" class="btn btn-default" data-dismiss="modal" onClick="closePop('TNOTICE');">닫기</button>
        </div>
        -->
    </div>
  </div>
</div>
<!-- E: modal now-ready -->

<script>
  $(document).ready(function(){
    // 선수분석 select on/off
    function anaSelOnOff(){
      var $selList = $('.analysis-menu + form[name="s_frm"] .sel-list');
      var $selDl = $selList.find('dl').not(':last-child');
      var $yearBtn = $selList.find('dl').eq(0).find('select');
      var $matchBtn = $selList.find('dl').eq(1).find('dd');
      $selDl.eq(0).addClass('on');
      $yearBtn.on('click', function(){
        $(this).parents('dl').addClass('on');
        $matchBtn.parents('dl').removeClass('on');
        onValChkClass();
      });
      $matchBtn.on('click', function(){
       $(this).parents('dl').addClass('on');
       $yearBtn.parents('dl').removeClass('on');
       onValChkClass();
       console.log($yearBtn);
      });
    }

    anaSelOnOff();

  })
</script>