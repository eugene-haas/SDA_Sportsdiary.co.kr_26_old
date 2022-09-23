<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
  Check_AdminLogin()

  dim currPage    : currPage      = fInject(Request("currPage"))
  dim fnd_Year    : fnd_Year    = fInject(Request("fnd_Year"))
    dim fnd_TeamGb  : fnd_TeamGb  = fInject(Request("fnd_TeamGb"))
    dim fnd_KeyWord : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
  dim CIDX    : CIDX        = crypt.DecryptStringENC(fInject(Request("CIDX")))

  dim LSQL, LRs

  IF CIDX <> "" Then
  
    dim TeamGb, UserName, UserEnName, Birthday, UserBirth, Sex, SexNm, PersonCode
    dim EnterType, Team, TeamNm, Photo, SubstituteYN 
    dim MemberIDX, PeriodDateS, PeriodDateE, txtMemo

    LSQL = "        SELECT A.TeamGb"
    LSQL = LSQL & "     ,A.MemberIDX"
    LSQL = LSQL & "     ,B.UserName"
    LSQL = LSQL & "     ,B.UserEnName"
    LSQL = LSQL & "     ,B.Birthday"
    LSQL = LSQL & "     ,CASE WHEN B.Birthday<>'' THEN SUBSTRING(B.Birthday, 1, 4)+'.'+SUBSTRING(B.Birthday, 5, 2)+'.'+SUBSTRING(B.Birthday, 7, 2) END UserBirth"
    LSQL = LSQL & "     ,A.Sex"   
    LSQL = LSQL & "     ,CASE A.Sex WHEN 'Man' THEN '남' ELSE '여' END SexNm"
    LSQL = LSQL & "     ,A.SubstituteYN"
    LSQL = LSQL & "     ,B.PersonCode"
    LSQL = LSQL & "     ,B.Team"      
    LSQL = LSQL & "     ,B.EnterType"
    LSQL = LSQL & "     ,ISNULL(B.Photo, '') Photo" 
    LSQL = LSQL & "     ,C.TeamNm"  
    LSQL = LSQL & "     ,A.PeriodDateS" 
    LSQL = LSQL & "     ,A.PeriodDateE" 
    LSQL = LSQL & "     ,A.txtMemo"
    LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblMemberKorea] A"
    LSQL = LSQL & "     inner join [KoreaBadminton].[dbo].[tblMemberHistory] B on A.MemberIDX = B.MemberIDX AND B.DelYN = 'N' AND B.RegYear = '"&fnd_Year&"'"
    LSQL = LSQL & "     inner join [KoreaBadminton].[dbo].[tblTeamInfoHistory] C on B.Team = C.Team AND C.DelYN = 'N' AND C.RegYear = '"&fnd_Year&"'"
    LSQL = LSQL & "     left join [KoreaBadminton].[dbo].[tblPubcode] D on A.TeamGb = D.PubCode AND D.DelYN = 'N' AND D.PPubCode = 'KOREATEAM'"
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & "     AND A.MemberKoreaIDX = '"&CIDX&"'"      

    'response.Write LSQL

    SET LRs = DBCon.Execute(LSQL)
    IF Not(LRs.Eof Or LRs.Bof) Then 
      MemberIDX = LRs("MemberIDX")
      TeamGb = LRs("TeamGb")
      UserName = LRs("UserName")    
      UserEnName = LRs("UserEnName")    
      Birthday = LRs("Birthday")    
      UserBirth = LRs("UserBirth")   
      Sex = LRs("Sex")    
      SexNm = LRs("SexNm") 
      PersonCode = LRs("PersonCode")
      SubstituteYN = LRs("SubstituteYN")
      Team = LRs("Team")
      TeamNm = LRs("TeamNm")
      Photo = LRs("Photo")  
      EnterType = LRs("EnterType")  
      PeriodDateS = LRs("PeriodDateS")    
      PeriodDateE = LRs("PeriodDateE")    
      txtMemo = ReHtmlSpecialChars(LRs("txtMemo"))
    End IF
      LRs.Close
    SET LRs = Nothing

  End IF  

  IF Photo = "" Then 
    Photo = "../images/profile@3x.png"
  Else
    Photo = global_filepathUrl&"Player/"&EnterType&"/"&Photo
  End IF
  
%>
<script language='javascript'>
  var locationStr = 'NationalTeam_Manage_Player';

  /**
  * left-menu 체크
  */
  var bigCate = 1; // 홈페이지 관리
  var midCate = 2; // 팀/선수/클럽/심판
  var lowCate = 0; // 경기지도자/심판 자격
  /* left-menu 체크 */

  function chk_Submit(valType){

    if(valType=='DEL'){
      if(confirm('선택한 정보를 삭제하시겠습니까?'))  {
        on_Submit(valType);
      }
      else{return;}
    }
    else if(valType=='MOD' || valType=='SAVE'){
      on_Submit(valType); 
    }
    else if(valType=='LIST'){
      //$(location).attr('href', './NationalTeam_Manage_Player.asp');
	  $('form[name=s_frm]').attr('action','./NationalTeam_Manage_Player.asp');
	  $('form[name=s_frm]').submit(); 	
    }
    else{
      history.back();   
    }
  }
  
  function on_Submit(valType){

    var strAjaxUrl = '../Ajax/NationalTeam_Write_PlayerReg.asp';
    
    
    if(valType=='MOD' || valType=='SAVE'){
      if(!$('#RegYear').val()){
        alert('등록년도를 선택해 주세요.');
        $('#RegYear').focus();
        return;
      }   
      
      if(!$('#TeamGb').val()){
        alert('대표팀 구분을 선택해 주세요.');
        $('#TeamGb').focus();
        return;
      }     

      if(!$('#MemberIDX').val()){
        alert('대표팀에 등록할 선수를 조회해 주세요.');
        $('#fnd_Member').focus();
        return;
      }

      if(!$('#PeriodDateS').val()){
        alert('대표팀 기간 시작일을 입력해주세요.');
        $('#PeriodDateS').focus();
        return;
      }
    }
    else{//삭제시(대표팀 종료)      
      if(!$('#PeriodDateE').val()){
        alert('대표팀 기간 종료일을 입력해주세요.');
        $('#PeriodDateE').focus();
        return;
      }
    }
    
    
    var SubstituteYN = '';
    var RegYear = $('#RegYear').val();
    var TeamGb = $('#TeamGb').val();  
    var PeriodDateS = $('#PeriodDateS').val();
    var PeriodDateE = $('#PeriodDateE').val();
    var txtMemo = $('#txtMemo').val();
    var Sex = $('#Sex').val();
    var MemberIDX = $('#MemberIDX').val();
    var CIDX = $('#CIDX').val();
    
    
    
    if($('input:checkbox[name=SubstituteYN]').is(':checked') == true) SubstituteYN = 'Y';
    else SubstituteYN = 'N';
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: {
        valType       : valType
        ,RegYear      : RegYear
        ,TeamGb       : TeamGb
        ,SubstituteYN   : SubstituteYN  
        ,Sex        : Sex
        ,PeriodDateS    : PeriodDateS
        ,PeriodDateE    : PeriodDateE
        ,txtMemo    : txtMemo
        ,MemberIDX    : MemberIDX
        ,CIDX     : CIDX
        
      }, 
      success: function(retDATA) {

        //console.log(retDATA);

        if(retDATA){

          var strcut = retDATA.split('|');

          if (strcut[0] == 'TRUE') {

            switch (strcut[1]) { 
              case '80'   : msg = '정보를 수정완료하였습니다.'; break;
              case '70'   : msg = '정보를 삭제완료하였습니다.'; break;
              default     : msg = '정보를 등록완료하였습니다.'; //90
            }                       
            alert(msg);

            $('form[name=s_frm]').attr('action','./NationalTeam_Manage_Player.asp');
            $('form[name=s_frm]').submit();             
          }         
          else{  //FALSE|

            switch (strcut[1]) { 
              case '99'   : msg = '이미 등록된 정보가 있습니다.\n관리자에게 문의하세요.'; break;  
              case '66'   : msg = '정보 등록에 실패하였습니다.\n관리자에게 문의하세요.'; break;
              default     : msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
            }           
            alert(msg);
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
  
  
  //SELECT BOX Option 리스트 조회      
  function fnd_SelectType(attname, code) {

    var strAjaxUrl = '../ajax/Select_NationalTeam_Manage.asp'; 

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      async: false, 
      data: {     
        code  : code 
      },
      success: function(retDATA) {

        //console.log(retDATA);

        $('#'+attname).empty().append();
        $('#'+attname).append(retDATA);
      },
      error: function(xhr, status, error){
        if(error != ''){
          alert ('오류발생! - 시스템관리자에게 문의하십시오!');
          return;
        }
      }
    });      
  }
  
  //선수조회
  function CHK_MEMBER(){
    
    if(!$('#fnd_UserName').val()){
      alert('조회할 선수이름을 입력해 주세요.');
      $('#fnd_UserName').focus();
      return;
    }   
    else{
      
      $('.detail_player').modal('show');
      
      var strAjaxUrl = '../ajax/NationalTeam_Write_Player.asp'; 
      var fnd_Year = $('#RegYear').val();
      var fnd_UserName = $('#fnd_UserName').val();
      
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        async: false, 
        data: {     
          fnd_Year      : fnd_Year 
          ,fnd_UserName   : fnd_UserName 
        },
        success: function(retDATA) {

          //console.log(retDATA);
          
          $('#player_contents').html(retDATA);
        },
        error: function(xhr, status, error){
          if(error != ''){
            alert ('오류발생! - 시스템관리자에게 문의하십시오!');
            return;
          }
        }
      }); 
    }        
  }

  
  function INPUT_PLAYERINFO(valMemberIDX, valUserName, valUserEnName, valBirthday, valPhoto){
    $('#MemberIDX').val(valMemberIDX);
    $('#UserName').val(valUserName);
    $('#fnd_UserName').val(valUserName);
    $('#UserEnName').val(valUserEnName);  
    $('#Birthday').val(valBirthday);
    $('#img_Member').attr('src', valPhoto);
    
    $('.detail_player').modal('hide');
  }
  
    $(document).ready(function(){   
      fnd_SelectType('TeamGb','<%=TeamGb%>');        
    });
</script> 
<!-- S : content --> 

<!-- S: content referee_write -->
<div id="content" class="referee_write"> 
  
  <!-- S: page_title -->
  <div class="page_title clearfix">
    <h2>대표팀 관리-선수</h2>
    <a href="javascript:chk_Submit('LIST');" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a> 
    
    <!-- S: 네비게이션 -->
    <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
      <ul>
        <li>홈페이지 관리</li>
        <li>팀/선수/클럽/심판</li>
        <li>대표팀 관리-선수</li>
      </ul>
    </div>
    <!-- E: 네비게이션 --> 
  </div>
  <!-- E: page_title --> 
  
  <!-- S : sch 검색조건 선택 및 입력 -->
  <form name="s_frm" method="post">
   
    <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="fnd_Year" id="fnd_Year" value="<%=fnd_Year%>" />
  <input type="hidden" name="fnd_TeamGb" id="fnd_TeamGb" value="<%=fnd_TeamGb%>" />
  <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
  <input type="hidden" name="MemberIDX" id="MemberIDX" value="<%=MemberIDX%>"  />    
  
    <table class="left-head view-table profile-table">
    
      <tr>
        <th rowspan="9" valign="top"><img src="<%=Photo%>" id="img_Member" width="80" alt=""></th>
        <th>등록년도</th>
        <td><select name="RegYear" id="RegYear" class="title_select">
            <option value="2018" <%IF fnd_Year = "2018" Then response.write "selected" End IF%>>2018 년</option>
            <option value="2019" <%IF fnd_Year = "2019" Then response.write "selected" End IF%>>2019 년</option>
            <option value="2020" <%IF fnd_Year = "2020" Then response.write "selected" End IF%>>2020 년</option>
          </select></td>
      </tr>
      <tr>
        <th>대표팀구분</th>
        <td><select name="TeamGb" id="TeamGb" class="">
            <option value="">대표팀구분</option>
          </select></td>
      </tr>
    <tr>
        <th>구분</th>
        <td><select name="Sex" id="Sex" class="">
            <option value="Man" <%IF Sex = "Man" Then response.write "selected" End IF%>>남자</option>
      <option value="WoMan" <%IF Sex = "WoMan" Then response.write "selected" End IF%>>여자</option>
          </select></td>
      </tr> 
    <tr class="ipt-txt">
        <th>대표팀 후보구분</th>
        <td>
          <label>
            <input type="checkbox" name="SubstituteYN" id="SubstituteYN" <%IF SubstituteYN = "Y" Then response.write "checked" End IF%>>후보팀일 경우 체크하세요
          </label>
        </td>
      </tr> 
    <tr class="term-line">
        <th>대표팀기간</th>
        <td><input type="text" name="PeriodDateS" id="PeriodDateS" value="<%=PeriodDateS%>" class="date_ipt"><span class="divn">~</span><input type="text" name="PeriodDateE" id="PeriodDateE" value="<%=PeriodDateE%>"  class="date_ipt"></td>
      </tr>
    <tr>
        <th>메모</th>
        <td><div class="con memo-con"><textarea type="text" name="txtMemo" id="txtMemo" placeholder="메모할 내용을 입력해 주세요." value="<%=txtMemo%>"></textarea></div></td>
      </tr> 
      <tr class="name-line">
        <th>이름</th>
        <td><input type="hidden" name="UserName" id="UserName" value="<%=UserName%>">
      <input type="text" name="fnd_UserName" id="fnd_UserName" value="<%=UserName%>">
      <a href="javascript:CHK_MEMBER();" id="fnd_Member" class="btn btn-confirm">조회</a></td>
      </tr>
    
      <tr>
        <th>영문이름</th>
        <td><div class="con"><input type="text" name="UserEnName" id="UserEnName" value="<%=UserEnName%>" readonly></div></td>
      </tr>
      <tr>
        <th>생년월일</th>
        <td><div class="con"><input type="text" name="Birthday" id="Birthday" value="<%=Birthday%>" readonly></div></td>
      </tr>

      <!-- <tr>
        <th>테스트</th>
        <td><div class="con"><input type="text" class="test_date"></div></td>
      </tr>  -->

    </table>
  
    <%IF CIDX<>"" Then%>
    <div class="btn-list-center"> <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> <a href="javascript:chk_Submit('DEL');" class="btn btn-red">삭제</a> <a href="javascript:chk_Submit('CANCEL');" class="btn btn-cancel">취소</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
    <%Else%>
    <div class="btn-list-center"> <a href="javascript:chk_Submit('SAVE');" class="btn btn-confirm">등록</a> <a href="javascript:chk_Submit('LIST');" class="btn btn-blue-empty">목록</a> </div>
    <%End IF%>
    
  </form>
  <!-- E : sch 검색조건 선택 및 입력 --> 
</div>
<!-- E : content referee_write --> 
<!-- E : container --> 
<!-- s: Modal등록동호인 목록 View Modal-->
<div class="modal fade detail_player srch_player" id="detail_player" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="btn btn-close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title" id="myModalLabel">조회 선수목록 보기</h3>
      </div>
      <div class="modal-body">              
        <div id="player_contents" class="table-list-wrap">                
        </div>

        <div class="btn_list">
          <a href="#" class="btn btn-confirm" data-dismiss="modal">닫기</a>
        </div>
      </div>
      
    </div>
  </div>
</div>
<!-- e: Modal등록동호인 목록 View Modal-->
<!--#include file="../include/footer.asp"-->
<script>

    $(".open_calendar").datepicker();

</script>