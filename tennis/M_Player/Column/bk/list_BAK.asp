<!-- #include file="../include/config.asp" -->
<script>
	//칼럼리스트
	function view_Columnist(){
	
		var strAjaxUrl="../ajax/Columnist_List.asp";
		
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',     
			data: { },
			success: function(retDATA) {
			
				console.log(retDATA);
				
				if(retDATA){
					
					var strcut = retDATA.split("|");
					
					//if(retDATA) $('#columnist_list').html(retDATA);
					$("#columnist_list").html(strcut[0]);              
					$(".mored_btn").html(strcut[1]);              
					$("#cnt_board").val(strcut[2]);              
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
	
	//더보기
	$(function(){
		$(document).on('click', '.more', function(){
			var strAjaxUrl="../ajax/Columnist_List.asp";
			var cnt_board = $('#cnt_board').val();
			var ID = $(this).attr("id");
			
			if(ID) {
				$.ajax({
				url: strAjaxUrl,
					type: 'POST',
					dataType: 'html',
					data: {
						fnd_LastID : ID
						,cnt_board : cnt_board
					},
					cache: false,
					success: function(retDATA) {
					
						//console.log(retDATA);
						if(retDATA){
								
							var strcut = retDATA.split("|");							
						
							$("#columnist_list").append(strcut[0]);              
							$(".mored_btn").html(strcut[1]);              
							$("#cnt_board").val(strcut[2]);              
							
							$("#more"+ID).remove(); // removing old more button
							
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
			return false;
		});
	});
	
	function view_Columnist_Dtl(valIDX){
		var valURL = './story.asp';
		
		$("#CIDX").val(valIDX);              
		
		$("#s_frm").attr("action", valURL);
		$('#s_frm').submit();
	}
	
	$(document).ready(function(){
		view_Columnist(); //목록조회	
	});
</script>
  <body>
  <form name="s_frm" id="s_frm" method="post">
  	<input type="hidden" name='cnt_board' id='cnt_board' />
    <input type="hidden" name='CIDX' id='CIDX' />
    
    <!-- S: container_body -->
    <div class="part_main tennis_part">
      <!-- S: header -->
      <!-- #include file = '../include/header_sub_left.asp' -->
      <h1>SD 칼럼</h1>
      <!-- #include file = '../include/header_sub_right.asp' -->
      <!-- E: header -->

      <!-- S: main -->
      <div class="main">
        <!-- S: include gnb -->
        <!--
        <span class="srch_box">
        <input type="text" class="search_box" placeholder="검색어를 입력해 주세요">
        </span>
        -->
        <!-- #include file = "../include/gnbType/player_gnb.asp" -->
        <!-- E: include gnb -->

        <!-- s: 칼럼리스트 시작 -->

    
        <div class="column_list_page" >
            <ul id="columnist_list">    
            	<!--        	
                <li>
                    <a href="story.asp">
                        <div class="img">
                            <img src="../images/media/list_img1.png" alt="" />
                        </div>
                        <div class="r_con">
                            <div class="txt">
                                <p class="name">이름이 들어갑니다</p>
                                <p class="title">제목이 들어갑니다.</p>
                            </div>
                            <i class="fa fa-angle-right" aria-hidden="true"></i>
                        </div>
                    </a>
                </li>
               
                <li>
                    <a href="story.asp">
                        <div class="img">
                            <img src="../images/media/list_img1.png" alt="" />
                        </div>
                        <div class="r_con">
                            <div class="txt">
                                <p class="name">이름이 들어갑니다</p>
                                <p class="title">제목이 들어갑니다.</p>
                            </div>
                            <i class="fa fa-angle-right" aria-hidden="true"></i>
                        </div>
                    </a>
                </li> 
                 -->               
            </ul>
            <div class="mored_btn">
            	<!--
                <a href="#">
                    <span class="txt">더보기</span>
                    <span class="icon_more"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
                </a>
                -->
            </div>
        
        </div>
        <!-- e: 칼럼리스트 시작 -->

      </div>
      <!-- E: main -->


      <!-- S: main_footer -->
      <!-- #include file = '../include/main_footer.asp' -->
      <!-- E: main_footer -->

    </div>
    <!-- E: container_body -->

    <!-- S: bot_config -->
    <!-- #include file = "../include/bot_config.asp" -->
    <!-- E: bot_config -->
    </form>
  </body>
</html>