<%
   	'비회원서비스
	'Check_Login()

	dim obj_val   	: obj_val     = Request("obj_val")
	dim active_val  : active_val  = Request("active_val")

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
<div>


<script type="text/javascript">
	/*
	function chk_logout(){
	  var expdate = new Date();

	  if(confirm("로그아웃 하시겠습니까?")){
	    expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
	    setCookie("sd_saveid", "", expdate, ".sportsdiary.co.kr");
	    setCookie("sd_savepass", "", expdate, ".sportsdiary.co.kr");

	    var strAjaxUrl = "../Ajax/logout.asp";

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

	            //$(location).attr('replace','../Main/login.asp');   //a href
	            window.location.replace("../Main/login.asp");

	          }else{
	            alert('로그아웃중에 오류가 발생하였습니다.');
	            return;
	          }
	        }
	      }, error: function(xhr, status, error){
	        if(error!=""){
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");
				return;
			}
	      }
	    });
	  }
	  else{
	    return;
	  }

	}


	//쿠키정보 저장
	function setCookie(name, value, expiredays, domain){
		var todayDate = new Date();

		todayDate.setDate (todayDate.getDate() + expiredays);
		document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + "; domain="+domain+";";
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
	  */


  //소속 팀매니저 가입체크
  function chk_TeamNotice(){
    var strAjaxUrl="../ajax/Main_ChkTeamManager.asp";
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
          $('form[name=frm]').attr('action',"../board/team-notice-list.asp");
          $('form[name=frm]').submit();
          $(location).attr('href', "../board/team-notice-list.asp");
        }
      },
			error: function(xhr, status, error){
        if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");
					return;
				}
      }
    });
  }

  /*
  ========================================================================================================================
  20170802 회원구분별 메뉴접근 권한 변경요청 - 최보라팀장
  메뉴구성[gnb]은 회원구분 선수[R]를 기본으로 보여주고 기타 회원구분은 메뉴접근권한을 체크하여 alert(접근권한 없음) 출력
  회원구분별 접근 권한 메뉴체크
  ========================================================================================================================
  */
  function chk_LogMenuProc(valMENU, valType){

	  var TXT_PARENTS = "TEAM_NOTICE";
	  var TXT_PLAYER = "COUNSEL";
	  var TXT_MONO = "MATCH_DIARY, TEAM_NOTICE, COUNSEL";
	  var CHK_AUTH = false;

	  //선수보호자
	  if(valType=="PARENTS"){
			if(TXT_PARENTS.match(valMENU)){ CHK_AUTH = true; }
	  }
	  //일반
	  else if(valType=="MONO"){
		 if(TXT_MONO.match(valMENU)){ CHK_AUTH = true; }
	  }
	   //선수, 관원, 비등록선수
	  else if(valType=="PLAYER"){
		 if(TXT_PLAYER.match(valMENU)){ CHK_AUTH = true; }
	  }
	  else{ CHK_AUTH = false; }

	  //계정체크
	  if (CHK_AUTH == true){
		  alert("현재 계정은 권한이 없습니다.");
		  return;
	  }
  }

  //메뉴 신규데이터 new Icon 표시체크(24시간)
  function CHK_NEWDATA(valTYPE, valTYPESUB){
    var strAjaxUrl="../ajax/check_NewData.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        TypeMenu  : valTYPE,
				TypeMenuSub : valTYPESUB
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

		  },
			error: function(xhr, status, error){
		  	if(error!=""){
					alert ("오류발생! - 시스템관리자에게 문의하십시오!");
					return;
				}
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
 		//console.log('input value = ',$iptOnVal.value);
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
      setCookie(valCook, "done", 1, ".sportsdiary.co.kr");
    }
  }

</script>

	<!-- #include file = "./gnbType/player_gnb.asp" -->

	<!-- S: modal now-ready -->
	<div class="modal fade in confirm-modal record-notice" id="not-medal-list" tabindex="-1" role="dialog" aria-hidden="true" style="display:none;">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="http://img.sportsdiary.co.kr/sdapp/public/close-x@3x.png" alt="닫기"></span></button>
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
</div>
