<!--#include file="../include/config.asp"-->
<script type="text/javascript">
    //검색
	function chk_Submit(chkPage){
		
		var strAjaxUrl = '../Ajax/member_list.asp';    
		
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
        
        $('form[name=s_frm]').attr('action','./member_list_file.asp');
        $('form[name=s_frm]').submit();
        
        $('#info_Member').modal('hide');
    }
    
    $(document).ready(function(){
		
        $('#fnd_EnterType').hide();
        $('#fnd_PlayerReln').hide();
        
        chk_Submit(1);	

	});                              
</script>

<section>
  <div id="content">
    <div class="loaction"><strong>회원정보</strong><span id="Depth_GameTitle">회원정보 목록</span></div>
    <form method="post" name="s_frm" id="s_frm" >
      <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" >
      <div class="sch month-regis-sch">
        <table class="sch-table">
          <tbody>
            <tr>
              <td><select name="fnd_SportsGb" id="fnd_SportsGb">
                  <option value="SD">통합</option>
                  <option value="judo">유도</option>
                  <option value="tennis">테니스</option>
                  <option value="bike">자전거</option>
                </select></td>
              <td><select name="fnd_SEX" id="fnd_SEX">
                  <option value="" selected>===전체===</option>
                  <option value="Man">남자</option>
                  <option value="WoMan">여자</option>
                </select></td>
              <td><select name="fnd_PlayerReln" id="fnd_PlayerReln">
                  <option value="" selected>===전체===</option>
                  <option value="R">선수</option>
                  <option value="T">지도자</option>
                  <option value="P">선수보호자</option>
                  <option value="D">일반</option>
                </select></td>
              <td><select name="fnd_EnterType" id="fnd_EnterType">
                  <option value="" selected>===전체===</option>
                  <option value="E">엘리트</option>
                  <option value="A">생활체육</option>
                </select></td>
              <td><a href="javascript:chk_frm();" class="btn btn-prev btn-info" id="btnview" accesskey="F">파일저장(F)</a></td>
            </tr>
          </tbody>
        </table>
      </div>
      <!-- S: detail_modal -->
      <div class="modal fade detail_modal player_info" id="info_Member"> 
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
              <!-- S: team_info -->
              <div class="team_info">
                <table class="sch-table">
                  <tbody>
                    <tr>
                      <th>메시지 내용 *</th>
                      <td><input type="text" id="txt_Msg" name="txt_Msg" placeholder="메시지 내용을 입력하세요."></td>
                    </tr>
                    <tr>
                      <th>타이틀</th>
                      <td><input type="text" id="txt_Title" name="txt_Title" placeholder="발신제목을 입력하세요."></td>
                    </tr>  
                    <tr>
                      <th>이미지</th>
                      <td><input type="text" id="txt_Image" name="txt_Image" placeholder="전체 이미지 주소를 입력하세요. ex)http://www.sportsdiary.co.kr/images.JPG" ></td>
                    </tr>
                    <tr>
                      <th>웹링크</th>
                      <td><input type="text" id="txt_WebLink" name="txt_WebLink" placeholder="웹링크 ex)http://www.sportsdiary.co.kr/"></td>
                    </tr>
                  </tbody>
                </table>
                <div><a href="javascript:download_frm();" class="btn btn-prev btn-info">파일 다운로드</a> <a href="javascript:$('#info_Member').modal('hide');" class="btn btn-prev btn-info">취소</a></div>
              </div>
              <!-- E: team_info --> 
            </div>
            <!-- E: modal-body --> 
          </div>
          <!-- E: modal-content --> 
        </div>
        <!-- E: modal-dialog --> 
      </div>
      <!-- E: detail_modal -->
      
      <div class="table-list-wrap month-regist" id="member_list"> </div>
    </form>
  </div>
</section>
