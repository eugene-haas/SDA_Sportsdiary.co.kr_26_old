<%
  '계정전환 모달페이지

  '======================================================================================================================='
  '가입된 계정 목록
  '======================================================================================================================='
  FUNCTION CHG_JoinUsList()
    dim txt_JoinUs

	If dbtype = "class" Then
   	Set LRs= db.ExecSQLReturnRS(INFO_QUERY_JOINACCOUNT("MODAL") , null, T_ConStr)
	Else
    SET LRs = DBCon3.Execute(INFO_QUERY_JOINACCOUNT("MODAL"))
	End if

    IF Not(LRs.Eof or LRs.bof) Then
        Do Until LRs.Eof

			IF cint(LRs("MemberIDX")) = cint(COOKIE_MEMBER_IDX()) Then
			  txt_JoinUs = txt_JoinUs & "<li class='tg on'>"
			Else
			  txt_JoinUs = txt_JoinUs & "<li class='tg'>"
			End IF

			txt_JoinUs = txt_JoinUs & " <div class='cont'>"
			txt_JoinUs = txt_JoinUs & "   <p>"&LRs("PlayerRelnNm")&"</p>"
			txt_JoinUs = txt_JoinUs & "   <span class='join_date'>가입일자 : "&LRs("SrtDate")&"</span>"
			txt_JoinUs = txt_JoinUs & " </div>"
			txt_JoinUs = txt_JoinUs & " <div class='ctr_btn'>"
			txt_JoinUs = txt_JoinUs & "   <label>"
			txt_JoinUs = txt_JoinUs & "     <input type='radio' id='ChangeUser' name='ChangeUser' value='"&LRs("MemberIDX")&"' />"
			txt_JoinUs = txt_JoinUs & "     <span class='sw_box'></span>"
			txt_JoinUs = txt_JoinUs & "   </label>"
			txt_JoinUs = txt_JoinUs & " </div>"
			txt_JoinUs = txt_JoinUs & "</li>"

			LRs.movenext
        Loop
    END IF
        LRs.Close
    SET LRs = Nothing

    CHG_JoinUsList = txt_JoinUs

    END FUNCTION
  '======================================================================================================================='
%>
<!-- S: change_account -->

<div class="modal fade change_account">
  <!-- S: modal-dialog -->
  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content">
      <!-- S: modal-header -->
      <div class="modal-header">
        <h2> <span class="ic_deco"> <i class="fa fa-refresh"></i> </span> <span class="txt">계정전환</span> </h2>
        <p> <span class="now">현재 계정</span> <span class="belong"><%
    IF txt_Name <> "" Then
      response.write txt_Name
    Else
      response.write "계정전환할 정보가 없습니다."
    End IF
    %></span> </p>
      </div>
      <!-- E: modal-header -->
      <!-- S: modal-body -->
      <div class="modal-body">
        <ul class="count_list">
          <%=CHG_JoinUsList()%>
        </ul>

        <!-- S: make_sub -->
        <div class="make_sub"> <a href="http://sdmain.sportsdiary.co.kr/sdmain/join_MemberTypeGb.asp"> <span class="ic_deco"> <i class="fa fa-plus-circle"></i> </span> <span class="txt">계정추가</span> <span class="img_deco"> <img src="http://img.sportsdiary.co.kr/sdapp/public/r_arr@3x.png" alt=""> </span> </a> </div>
        <!-- E: make_sub -->

      </div>
      <!-- E: modal-body -->
      <!-- S: modal-footer -->
      <div class="modal-footer">
        <ul class="modal-btn clearfix">
          <li> <a href="#" class="btn btn-cancel" data-dismiss="modal">취소</a> </li>
          <li> <a href="javascript:CHK_CHANGE_USER();" class="btn btn-ok">계정전환 적용</a> </li>
        </ul>
      </div>
      <!-- E: modal-footer -->
    </div>
    <!-- E: modal-content -->
  </div>
  <!-- E: modal-dialog -->
</div>
<!-- E: change_account -->
<script>
	//전환할 계정 선택
  function CHK_CHANGE_USER(){
    var strAjaxUrl = '../ajax/change_modal.asp';
    var ChangeUser = $('input:radio[name=ChangeUser]:checked').val();

    if(!$('input:radio[name=ChangeUser]').is(':checked')){
      alert('전환할 계정을 선택해주세요.');
      return;
    }

    if(confirm('계정전환을 진행하시겠습니까?')){
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          ChangeUser : ChangeUser
        },
        success: function(retDATA) {

          //console.log(retDATA);

          if(retDATA){

            var strcut = retDATA.split('|');

            if(strcut[0] == 'TRUE') {
              alert('계정전환이 완료되었습니다.');
              //$(location).attr('href', './user_account.asp');
              $(".change_account").modal("hide");
              $('.user_type').text(strcut[1]);        //player_gnb.asp
              $('.belong').text(strcut[1]);         //change_modal.asp
              $('.player_belong').text(strcut[1]);      //mypage.asp


              //프로필 이미지 변경
              //include/gnbType/player_gnb.asp
              $('#imgGnb').attr('src',strcut[2]);
              //mypage/mypage.asp
              $('#imgMypage').attr('src',strcut[2]);

            }
            else{ //FALSE
              alert('잘못된 접근입니다.\n확인 후 다시 이용하세요.');
              return;
            }
          }
        },
        error: function(xhr, status, error){
          if(error!=''){
            alert ('오류발생! - 시스템관리자에게 문의하십시오!');
            return;
          }
        }
      });
    }
    else{
      return;
    }
  }
</script>
