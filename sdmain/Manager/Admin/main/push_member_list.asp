<!--#include file="../dev/dist/config.asp"-->
<!-- S: head -->
<!-- #include file="../include/head.asp" --> 
<!-- E: head -->
<% 
    RoleType = "MEMPUSH"	    '앱 알림 수신동의 회원 조회                       
          
%>
<!--#include file="./CheckRole.asp"--> 
<script type="text/javascript">
    //검색
	function chk_Submit(chkPage){
		
		var strAjaxUrl = '../Ajax/push_member_list.asp';    
		
        var fnd_SportsGb = $('#fnd_SportsGb').val();
		var fnd_EnterType = $('#fnd_EnterType').val();
		var fnd_SEX = $('#fnd_SEX').val();		
		var fnd_PlayerReln = $('#fnd_PlayerReln').val();
		
		if(chkPage) $('#currPage').val(chkPage);
		
		var currPage = $('#currPage').val();
	
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',     
			data: { 
				currPage    	: currPage     
                ,fnd_SportsGb   : fnd_SportsGb
				,fnd_EnterType  : fnd_EnterType   
				,fnd_SEX     	: fnd_SEX        
				,fnd_PlayerReln	: fnd_PlayerReln
			},    
			success: function(retDATA) {
                
                console.log(retDATA);
                
                
				$('#member_list').html(retDATA);       
			}, 
			error: function(xhr, status, error){           
				if(error!=''){
					alert ('오류발생! - 시스템관리자에게 문의하십시오!');
					return;
				}
			}
		});     		
	}  
    
    $(document).on('change', '#fnd_SportsGb', function(){
        if($('#fnd_SportsGb').val()=='SD') {
            $('#fnd_EnterType').hide();
            $('#fnd_PlayerReln').hide();
        } 
        else {
            $('#fnd_EnterType').show();
            $('#fnd_PlayerReln').show();
        }
    });
    
    $(function(){
        $('select').on('change', function() {            
            chk_Submit(1);	
        });
    });
    
    
    function chk_frm(){
        $('#info_Member').modal('show');
    }
    
    function download_frm(){
        
        if(!$('#txt_Msg').val()){
			alert('발송할 메시지 내용을 입력하세요.');
			$('#txt_Msg').focus();
			return;
		}
        
        alert('앱 알림 수신동의 회원정보만 다운로드합니다.');
        
        $('form[name=s_frm]').attr('action','./push_member_list_file.asp');
        $('form[name=s_frm]').submit();
        
        $('#info_Member').modal('hide');
    }
    
    $(document).ready(function(){
		
        $('#fnd_EnterType').hide();
        $('#fnd_PlayerReln').hide();
        
        chk_Submit(1);	

	});                              
</script>
                           <form method="post" name="s_frm" id="s_frm" >
<div class="content"> 
  <!-- S: left-gnb --> 
  <!-- #include file="../include/left-gnb.asp" --> 
  <!-- E: left-gnb --> 
  
  <!-- S: right-content -->
  <div class="right-content"> 
    <!-- S: navigation -->
    <div class="navigation"> <i class="fas fa-home"></i> <i class="fas fa-chevron-right"></i> <span>회원관리</span> <i class="fas fa-chevron-right"></i> <span>통합회원</span> <i class="fas fa-chevron-right"></i> <span>앱 알림 회원정보</span> </div>
    <!-- E: navigation --> 
    <!-- S: pd-15 -->
    <div class="pd-30"> 
      <!-- S: sub-content -->
      <div class="sub-content">
        <div class="box-shadow">
          <div class="search-box-1">
            
              <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" >
              <select name="fnd_SportsGb" id="fnd_SportsGb">
                <option value="SD">통합</option>
                <option value="judo">유도</option>
                <option value="tennis">테니스</option>
                <option value="bike">자전거</option>
              </select>
              <select name="fnd_SEX" id="fnd_SEX">
                <option value="" selected>===전체===</option>
                <option value="Man">남자</option>
                <option value="WoMan">여자</option>
              </select>
              <select name="fnd_PlayerReln" id="fnd_PlayerReln">
                <option value="" selected>===전체===</option>
                <option value="R">선수</option>
                <option value="T">지도자</option>
                <option value="P">선수보호자</option>
                <option value="D">일반</option>
              </select>
              <select name="fnd_EnterType" id="fnd_EnterType">
                <option value="" selected>===전체===</option>
                <option value="E">엘리트</option>
                <option value="A">생활체육</option>
              </select>
              <a href="javascript:chk_frm();" class="btn btn-danger" id="btnview" accesskey="F">엑셀다운로드(F)</a>
            
          </div>
        </div>
        <div class="table-box basic-table-box">
          <div class="table-list-wrap month-regist" id="member_list"> </div>
        </div>
                           
                           
        <!-- S: detail_modal -->
        
<div class="modal fade basic-modal refund_modal" id="refund_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">환불정보</h4>
      </div>
      <div class="modal-body">
        <!-- S: list-tale -->
        <div class="list-table">
          <ul>
            <li>
              <span class="l-name">입금자</span>
              <span class="r-con">백승훈</span>
            </li>
            <li>
              <span class="l-name">환불신청 날짜</span>
              <span class="r-con">2018-07-31</span>
            </li>
            <li>
              <span class="l-name">환불신청 은행</span>
              <span class="r-con">진행중</span>
            </li>
            <li>
              <span class="l-name">환불신청 계좌번호</span>
              <span class="r-con">0000-0000-0000</span>
            </li>
            <li>
              <span class="l-name">환불날짜</span>
              <span class="r-con">백승훈</span>
            </li>
            <li>
              <span class="l-name">환불상태</span>
              <span class="r-con">없음</span>
            </li>
          </ul>
        </div>
        <!-- E: list-tale -->
      </div>
      <div class="modal-footer">
        <a href="#" class="white-btn" data-dismiss="modal">닫기</a>
        <a href="#" class="navy-btn">확인</a>
      </div>
    </div>
  </div>
</div>

                   
                           
        <div class="modal fade basic-modal" id="info_Member"> 
          <!-- S: modal-dialog -->
          <div class="modal-dialog"> 
            <!-- S: modal-content -->
            <div class="modal-content"> 
              <!-- S: modal-header -->
              <div class="modal-header">
                <h4>앱 알림 회원정보 파일 다운로드</h4>
              </div>
              <!-- E: modal-header --> 
              <!-- S: modal-body -->
              <div class="modal-body">
                <div class="table-box basic-write">           
                <table cellspacing="0" cellpadding="0">
                  <tbody>
                    <tr>
                      <th>메시지 내용 *</th>
                      <td><input type="text" class="in-style-1" id="txt_Msg" name="txt_Msg" placeholder="메시지 내용을 입력하세요."></td>
                    </tr>
                    <tr>
                      <th>타이틀</th>
                      <td><input type="text" class="in-style-1" id="txt_Title" name="txt_Title" placeholder="발신제목을 입력하세요."></td>
                    </tr>
                    <tr>
                      <th>이미지</th>
                      <td><input type="text" class="in-style-1" id="txt_Image" name="txt_Image" placeholder="전체 이미지 주소를 입력하세요. ex)http://www.sportsdiary.co.kr/images.JPG" ></td>
                    </tr>
                    <tr>
                      <th>웹링크</th>
                      <td><input type="text" class="in-style-1" id="txt_WebLink" name="txt_WebLink" placeholder="웹링크 ex)http://www.sportsdiary.co.kr/"></td>
                    </tr>
                  </tbody>
                </table>
                           </div>
                
              </div>
              <!-- E: modal-body --> 
                <div class="modal-footer"><a href="javascript:download_frm();" class="btn btn-primary">파일 다운로드</a> <a href="javascript:$('#info_Member').modal('hide');" class="btn btn-default">취소</a></div>                           
            </div>
            <!-- E: modal-content -->                                                                                                                               
                                                                                                                                          
          </div>
          <!-- E: modal-dialog --> 
        </div>
        <!-- E: detail_modal --> 
                                                                                                                                          
                                                                                                                                          
      </div>
      <!-- E: sub-content --> 
    </div>
    <!-- E: pd-15 --> 
  </div>
  <!-- S: right-content --> 
</div>
</form>
