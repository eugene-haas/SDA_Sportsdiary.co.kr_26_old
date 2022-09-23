<!--#include file="../dev/dist/config.asp"-->
<!--#include file="../include/head.asp"-->
<%
    Check_AdminLogin()
   
  dim currPage        : currPage      = fInject(Request("currPage"))
  dim fnd_KeyWord     : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
  dim fnd_RefereeGb   : fnd_RefereeGb = fInject(Request("fnd_RefereeGb"))
  dim CIDX      : CIDX      = crypt.DecryptStringENC(fInject(Request("CIDX")))
  
  dim LSQL, LRs
    
  IF CIDX <> "" Then
  
    dim LicenseNumber, RefereeGb, RefereeLvl, LicenseDt
    dim UserName, UserBirth 
   
      LSQL = "      SELECT A.LicenseIDX"
    LSQL = LSQL & "   ,B.PubName RefereeNm"
    LSQL = LSQL & "   ,A.RefereeGb"
    LSQL = LSQL & "   ,A.RefereeLevel RefereeLvl"
    LSQL = LSQL & "   ,A.LicenseNumber"
    LSQL = LSQL & "   ,A.LicenseDt"
    LSQL = LSQL & "   ,A.UserName"
    LSQL = LSQL & "   ,A.UserBirth"
    LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblLicenseInfo] A"
    LSQL = LSQL & "   left join [KoreaBadminton].[dbo].[tblPubcode] B on A.RefereeGb = B.PubCode"
    LSQL = LSQL & "     AND B.DelYN = 'N'"
    LSQL = LSQL & "     AND B.PPubCode = 'LICENSE'"
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
      LSQL = LSQL & "   AND A.LicenseIDX = '"&CIDX&"'"      

'   response.Write LSQL

    SET LRs = DBCon.Execute(LSQL)
    IF Not(LRs.Eof Or LRs.Bof) Then 
      RefereeGb = LRs("RefereeGb")
      LicenseNumber = LRs("LicenseNumber")    
      UserName = LRs("UserName")    
      UserBirth = LRs("UserBirth")    
      RefereeLvl = LRs("RefereeLvl")    
      LicenseDt = LRs("LicenseDt")

    End IF
      LRs.Close
    SET LRs = Nothing

  End IF
  
%>

<script language='javascript'>
  /**
   * left-menu 체크
   */
  var bigCate = 1; // 홈페이지 관리
  var midCate = 2; // 팀/선수/클럽/심판
  var lowCate = 0; // 경기지도자/심판 자격
	
	var locationStr = 'Referee_status';	
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
      $(location).attr('href', './Referee_status.asp');
    }
    else{
      history.back();   
    }
  }
  
  function on_Submit(valType){
    
    var strAjaxUrl = '../Ajax/Referee_Write.asp';
    
    if(valType=='MOD' || valType=='SAVE'){
      
      if(!$('#RefereeGb').val()){
        alert('구분을 선택해 주세요.');
        $('#RefereeGb').focus();
        return;
      }     
      
      if(!$('#RefereeLevel').val()){
        alert('급수를 입력해 주세요.');
        $('#RefereeLevel').focus();
        return;
      }     
      
      if(!$('#UserName').val()){
        alert('이름을 입력해 주세요.');
        $('#UserName').focus();
        return;
      }
      
      //생년월일체크
      if(!$('#UserBirth').val()){
        alert("생년월일을 입력해 주세요.");
        $('#UserBirth').focus();
        return; 
      }
      else{
        if($('#UserBirth').val().length<8){
          alert("생년월일을 정확히 입력해 주세요");
          $('#UserBirth').focus();
          return;
        }
        else{
          var data = $('#UserBirth').val();

          var y = parseInt(data.substr(0, 4), 10); 
          var m = parseInt(data.substr(4, 2), 10); 
          var d = parseInt(data.substr(6, 2), 10); 

          var dt = new Date(y, m-1, d); 

          if(dt.getDate() != d) { alert("생년월일 일이 유효하지 않습니다"); $('#UserBirth').focus(); return;} 
          else if(dt.getMonth()+1 != m) { alert("생년월일 월이 유효하지 않습니다."); $('#UserBirth').focus(); return;} 
          else if(dt.getFullYear() != y) { alert("생년월일 년도가 유효하지 않습니다."); $('#UserBirth').focus(); return;} 
          else { }    
        }
      }
      
      if(!$('#LicenseNumber').val()){
        alert('발급번호를 입력해 주세요.');
        $('#LicenseNumber').focus();
        return;
      }
      
      if(!$('#LicenseDt').val()){
        alert('자격취득일자를 입력해 주세요.');
        $('#LicenseDt').focus();
        return;
      }
    }
    
    var RefereeGb = $('#RefereeGb').val();
    var RefereeLevel = $('#RefereeLevel').val();
    var UserName = $('#UserName').val();
    var UserBirth = $('#UserBirth').val();
    var LicenseNumber = $('#LicenseNumber').val();
    var LicenseDt = $('#LicenseDt').val();
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: {
        valType     : valType
        ,RefereeGb    : RefereeGb
        ,RefereeLevel   : RefereeLevel
        ,UserName     : UserName
        ,UserBirth    : UserBirth
        ,LicenseNumber  : LicenseNumber
        ,LicenseDt    : LicenseDt
      }, 
      success: function(retDATA) {
        
        console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split('|');
          
          if (strcut[0] == 'TRUE') {
            
            switch (strcut[1]) { 
              case '80'   : msg = '정보를 수정완료하였습니다.'; break;
              case '70'   : msg = '정보를 삭제완료하였습니다.'; break;
              default   : msg = '정보를 등록완료하였습니다.'; //90
            }           
            alert(msg);
            
            $('form[name=s_frm]').attr('action','./Referee_status.asp');
            $('form[name=s_frm]').submit(); 
          }
          else{  //FALSE|
            
            switch (strcut[1]) { 
              case '66'   : msg = '후원사등록에 실패하였습니다.\n관리자에게 문의하세요.'; break;
              default   :  msg = '잘못된 접근입니다.\n확인 후 다시 이용하세요.'; //200
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
    
    var strAjaxUrl = '../ajax/Select_RefereeGb.asp'; 

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
  
  $(document).ready(function(){   
    fnd_SelectType('RefereeGb','<%=RefereeGb%>');
        
    });
</script>
<!-- S : content -->

  <!-- S: content referee_write -->
  <div id="content" class="referee_write">
    
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>경기지도자/심판 자격</h2>
      <a href="./Referee_status.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>홈페이지 관리</li>
          <li>팀/선수/클럽/심판</li>
          <li>경기지도자/심판 자격</li>          
        </ul>
      </div>
      <!-- E: 네비게이션 -->
      </div>
      <!-- E: page_title -->

    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">     
  <input type="hidden" name="CIDX" id="CIDX" value="<%=CIDX%>" />
     <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
     <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
   <input type="hidden" name="fnd_RefereeGb" id="fnd_RefereeGb" value="<%=fnd_RefereeGb%>" />
        
          <table class="left-head view-table">
            <tr>
              <th>구분</th>
              <td>
              <select name="RefereeGb" id="RefereeGb" class="title_select">
                <option value="">구분</option>
              </select>
            </td>
            </tr>
            <tr>
              <th>급수</th>
              <td><input type="text" name="RefereeLevel" id="RefereeLevel" class="in_1" value="<%=RefereeLvl%>" /></td>
            </tr>
            <tr>
              <th>이름</th>
              <td><input type="text" name="UserName" id="UserName" class="in_1" value="<%=UserName%>" /></td>
            </tr>
            <tr>
              <th>생년월일</th>
              <td><input type="text" name="UserBirth" id="UserBirth" class="in_1" value="<%=UserBirth%>" maxlength="8" onKeyPress="chk_Number();" oninput="maxLengthCheck(this)" />8자리 (예) 19830124</td>
            </tr>
            <tr>
              <th>발급번호</th>
              <td><input type="text" name="LicenseNumber" id="LicenseNumber" class="in_1" value="<%=LicenseNumber%>" /></td>
            </tr>
            <tr>
              <th>자격취득일자</th>
              <td><input type="date" name="LicenseDt" id="LicenseDt" class="date_ipt" value="<%=LicenseDt%>" /></td>
            </tr>
          </table>

        <%IF CIDX<>"" Then%>
        <div class="btn-list-center"> 
          <a href="javascript:chk_Submit('MOD');" class="btn btn-confirm">수정</a> 
          <a href="javascript:chk_Submit('DEL');" class="btn btn-red">삭제</a> 
          <a href="javascript:chk_Submit('CANCEL');" class="btn btn-cancel">취소</a> 
          <a href="javascript:chk_Submit('LIST');" class="btn btn-gray">목록</a> 
        </div>
        <%Else%>
        
        <div class="btn-list-center"> 
            <a href="javascript:chk_Submit('SAVE');" class="btn btn-confirm">등록</a> 
            <a href="javascript:chk_Submit('LIST');" class="btn btn-gray">목록</a> 
        </div>
        <%End IF%>

    </form>
    <!-- E : sch 검색조건 선택 및 입력 -->
  </div>
<!-- E : content referee_write -->
<!-- E : container -->
<!--#include file="../include/footer.asp"-->

