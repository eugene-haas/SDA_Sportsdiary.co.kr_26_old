<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<script>
  //검색창 닫기
  function click_close(){
	   $("#sbox").slideToggle( "slow", function() {
		   $('#click_close').hide();
		   $('#click_open').show();

      // Animation complete.
    });
  }

  //검색창 열기
  function click_open(){
    $("#sbox").slideDown( "slow", function() {
		  $('#click_close').show();
		  $('#click_open').hide();
      // Animation complete.
    });
  }
  
  //조회
  function fnd_BoardInfo(){
    var strAjaxUrl 		= "../Ajax/fnd_Notice_List.asp";
	var SDate    		= $('#SDate').val();			//기간조회 시작일
	var EDate  			= $('#EDate').val();			//기간조회 마지막일
	var search_user 	= $('#search_user').val();		//작성자 검색
	
	$.ajax({
		url: strAjaxUrl,
		type: 'POST',
		dataType: 'html',			
		data: { 
			SDate    	: SDate,
			EDate  		: EDate,
			search_user : search_user	
		},		
		success: function(retDATA) {
			if(retDATA){	
				$('#boardList').html(retDATA);			
			}
			else{
				alert("잘못된 접근입니다");	
			}
		}, error: function(xhr, status, error){						
			alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
		}
	});	
  }
  
  
  
  //조회날짜 체크
  function chk_Date(){
	  	
  }
</script>
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>공지사항</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->

  <!-- S: sub sub-main -->
  <div class="sub sub-main board">
    <!-- S: search 
    <div class="search">
      <label>
        <span class="label-title">작성자 검색</span>
        <select name="">
          <option value="">::전체::</option>
          <option value="">::전체::</option>
          <option value="">::전체::</option>
        </select>
        <input type="submit" value="검색">
      </label>
    </div>
    <!-- E: search -->
    <!-- S: board-list -->
    <div class="board-list">
			<!-- S: board-search-input 상단검색 -->
			<form name="s_frm" method="post">
				<div class="board-search-input" id="sbox">
					<!-- S: sel-list -->
					<div class="sel-list">
						<!-- S: 기간 선택 -->
						<dl class="clearfix term-sel">
							<dt>기간선택</dt>
							<!--<dd class="on">-->
							<dd id="search_date">
                           		<select name="search_date" id="search_date_id">
									<option value="date" selected>기간 조회</option>
                                    <option value="week">최근 1주일</option>
									<option value="month">최근 1달</option>
									<option value="year">최근 1년</option>                                    
								</select>
							</dd>
						</dl>
						<!-- E: 기간 선택 -->
						<!-- S: 기간 조회 -->
						<dl class="clearfix term-srch">
							<dt>기간조회</dt>
							<!--<dd class="on">-->
							<dd>				
								<span><input type="date" name="SDate" id="SDate" maxlength="10" /></span>
							</dd>
							<dd class="flow">
								<span>~</span>
							</dd>
							<!--<dd class="on">-->
							<dd>
								<span><input type="date" name="EDate" id="EDate" maxlength="10" /></span>
							</dd>
						</dl>
						<!-- E: 기간 조회 -->
						<!-- S: 작성자 검색 -->
						<dl class="clearfix term-user">
							<dt>작성자 검색</td>
							<!--<dd class="on">-->
							<dd id="search_user">
								<select name="search_user" id="search_user">
									<option value="user01">전체</option>
								</select>
								
								<a href="javascript:fnd_BoardInfo();" class="btn-gray">검색</a>
							</dd>
						</dl>
					</div>
					<!-- E: sel-list -->
				</div>
				<!-- E: board-search-input 상단검색 -->
			</form>
			<!-- S: tail -->
			<div class="tail">
				<a href="javascript:click_open();"><img src="../images/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
				<a href="javascript:click_close();"><img src="../images/record/open-tail@3x.png" id="click_close" alt="닫기"></a>    
			</div>
			<!-- E: tail -->
      <!-- S: 게시판 리스트 -->
      <ul id="boardList">
        <!-- S: 리스트 -->
        <li class="require">
          <h4>[필독] 스포츠다이어리 신규결제 안내</h4>
          <p class="write-info clearfix">
            <span>관리자</span>
            <span>2016.12.26</span>
            <span class="seen">조회수</span>
            <span>4,221</span>
          </p>
        </li>
        <!-- E: 리스트 -->
        <!-- S: 리스트 -->
        <li>
          <h4>스포츠다이어리 공지사항입니다.</h4>
          <p class="write-info clearfix">
            <span>관리자</span>
            <span>2016.12.26</span>
            <span class="seen">조회수</span>
            <span>4,221</span>
          </p>
        </li>
        <!-- E: 리스트 -->
        <!-- S: 리스트 -->
        <li>
          <h4>스포츠다이어리 공지사항입니다.</h4>
          <p class="write-info clearfix">
            <span>관리자</span>
            <span>2016.12.26</span>
            <span class="seen">조회수</span>
            <span>4,221</span>
          </p>
        </li>
        <!-- E: 리스트 -->
        <!-- S: 리스트 -->
        <li>
          <h4>스포츠다이어리 공지사항입니다.</h4>
          <p class="write-info clearfix">
            <span>관리자</span>
            <span>2016.12.26</span>
            <span class="seen">조회수</span>
            <span>4,221</span>
          </p>
        </li>
        <!-- E: 리스트 -->
        
      </ul>
      <!-- E: 게시판 리스트 -->
    </div>
    <!-- E: board-list -->
    <!-- S: board-bullet -->

    <div id="boardPage" class="board-bullet">
          <a href="#" class="prev"><img src="../images/board/board-l-arrow@3x.png" alt="이전페이지"></a>
          <a href="#" class="on">1</a>
          <a href="#">2</a>
          <a href="#">3</a>
          <a href="#" class="next"><img src="../images/board/board-r-arrow@3x.png" alt="이전페이지"></a>
    </div>
    <!-- E: board-bullet -->
  </div>
  <!-- E: sub sub-main board -->
  
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>