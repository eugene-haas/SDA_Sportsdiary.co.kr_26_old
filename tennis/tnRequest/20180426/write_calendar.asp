<!--#include file = "./include/config_top.asp" -->
<title>KATA Tennis 대회 참가신청</title>
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%  
  '==============================================================================
  '작성 및 상세정보 조회페이지
  '==============================================================================
  dim act               : act               = fInject(Request("act"))
  dim currPage          : currPage          = fInject(Request("currPage"))
  dim Fnd_KeyWord       : Fnd_KeyWord       = fInject(Request("Fnd_KeyWord"))
  
  
  '대회참가신청 페이지 ./list_repair.asp
  '  dim RequestIDX       : RequestIDX        = fInject(decode(Request("RequestIDX"), 0)) '참가신청IDX
  dim Fnd_GameTitle     : Fnd_GameTitle     = fInject(Request("Fnd_GameTitle"))     '대회IDX
  dim RequestGroupNum   : RequestGroupNum   = fInject(decode(Request("RequestGroupNum"), 0))   '참가신청 그룹번호  
  dim GameTitle         : GameTitle         = fInject(Request("GameTitle"))
  dim TeamGb            : TeamGb            = fInject(Request("TeamGb"))
  
  '==============================================================================
  dim SportsGb          : SportsGb          = "tennis"
  
  dim CSQL, CRs
  
  
  '대회정보
  dim GameTitleName, GameS, GameE, GameArea, Sido, GameRcvDateS, GameRcvDateE
  '대회참가신청정보
  dim UserPass, UserName, UserPhone, txtMemo, PaymentDt, PaymentNm
  dim strUserPhone, UserPhone1, UserPhone2, UserPhone3
  
    response.Write "act="&act&"<br>"
    response.Write "currPage="&currPage&"<br>"
    response.Write "Fnd_KeyWord="&Fnd_KeyWord&"<br>"
    response.Write "Fnd_GameTitle="&Fnd_GameTitle&"<br>"
    response.Write "RequestGroupNum="&RequestGroupNum&"<br>"
    response.Write "GameTitle="&GameTitle&"<br>"
    response.Write "TeamGb="&TeamGb&"<br>"
  
  
  'IF act = "" OR Fnd_GameTitle = "" Then
  '  response.Write "<script>"
  '  response.Write "  alert('잘못된 접근입니다. 확인 후 이용하세요.');"
  '  response.Write "  history.back();"
  '  response.Write "</script>"
  '  response.End()
  'Else
  
 ''   IF act = "MOD" Then
 ''     '대회참가신청정보 조회
 ''     CSQL =      "   SELECT TOP 1 * " 
 ''     CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
 ''     CSQL = CSQL & " WHERE DelYN = 'N' " 
 ''     CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"'"
 ''     CSQL = CSQL & "   AND GameTitleIDX = '"&Fnd_GameTitle&"'"
 ''     CSQL = CSQL & "   AND RequestGroupNum = &RequestGroupNum&"'"
      
  ''    SET CRs = Dbcon.Execute(CSQL)
  ''    IF Not(CRs.Eof Or CRs.Bof) Then 
  ''      Level     = CRs("Level")    '참가신청 종목 상세
  ''      UserPass    = CRs("UserPass")
  ''      UserName    = CRs("UserName")
  ''      UserPhone   = CRs("UserPhone")
  ''      txtMemo     = CRs("txtMemo")
  ''      PaymentDt   = CRs("PaymentDt")
  ''      PaymentNm   = CRs("PaymentNm")
      
   ''   IF UserPhone <> "" Then
   ''     strUserPhone = Split(UserPhone, "-")  
   ''     UserPhone1 = strUserPhone(0)
   ''     UserPhone2 = strUserPhone(1)
   ''     UserPhone3 = strUserPhone(2)            
   ''   End IF
   '' Else
  ''    response.Write "<script>"
  ''    response.Write "  alert('일치하는 정보가 없습니다. 확인 후 이용하세요.');"
  ''    response.Write "  history.back();"
  ''    response.Write "</script>"
  ''    response.End()
  ''  End IF
  ''    CRs.Close
  ''  SET CRs = Nothing
    
  '' END IF
  
 'End IF
  
%>
<script>
  //maxlength 체크
  function maxLengthCheck(obj){
    var $this = $(obj);
    
    if(obj.value.length > obj.maxLength){
      obj.value = obj.value.slice(0, obj.maxLength);
      
      $this.next().focus();
    }  
  }
  
  //create Select box 대회조회 및 대회참가종목 조회
  function FND_SELECTOR(element){
    var strAjaxUrl = "./ajax/Request_Select.asp";  
    var Fnd_GameTitle = $("#Fnd_GameTitle").val();
    var Level = $("#Level").val();    
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { 
        element         : element
        ,Level      : Level
        ,Fnd_GameTitle  : Fnd_GameTitle
      },
      success: function(retDATA) {
      
        //console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split("|");
          
          if(strcut[0]=="TRUE") $('#'+element).append(strcut[1]);
        }       
      }, 
      error: function(xhr, status, error){
        if(error!=""){ 
          alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
          return; 
        }     
      }
    });
  }
  
  //대회정보 조회(상단 대회정보 출력)
  function FND_GameTitleInfo(element){
    var strAjaxUrl = "./ajax/write_GameTitle_Info.asp";  
    var Fnd_GameTitle = $("#Fnd_GameTitle").val();
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { 
        Fnd_GameTitle  : Fnd_GameTitle
      },
      success: function(retDATA) {
      
      //console.log(retDATA);
      
      if(retDATA){
      
        var strcut = retDATA.split("|");
        
        if(strcut[0]=="TRUE"){
          //상단 대회정보 출력
          
          $('#txt_GameTitleName').text(strcut[1]);
          $('#txt_Term').text(strcut[2]);
          //  $('#txt_AreaDtl').text(strcut[3]);
          //  $('#txt_TermRcv').text(strcut[4]);
          
          $('#SMS_GameTitleNm').val(strcut[1]);
          
          }
        }       
      }, 
      error: function(xhr, status, error){
        if(error!=""){ 
          alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
          return; 
        }     
      }
    });
  }
    
  
  
  function CHK_OnSubmit(valType){
    
    switch (valType) { 
      case 'GLIST':   //대회정보 목록
        $('form[name=s_frm]').attr('action',"./list.asp");
        $('form[name=s_frm]').submit();
        break;
      
      case 'RLIST':   //대회참가신청 목록
        $('form[name=s_frm]').attr('action',"./list_repair.asp");
        $('form[name=s_frm]').submit();
        break;  
      
      case 'DEL':   //참가신청 정보 삭제
        if(!$('#UserPass').val()){
          alert("비밀번호를 입력해 주세요.");
          $('#UserPass').focus();
          return;
        }
        else{
          if(confirm("대회참가신청정보를 삭제하시겠습니까?")){
            Info_Request_Del('<%=Fnd_GameTitle%>', '<%=RequestGroupNum%>');
          }
          else{
            return; 
          }      
        }
        break;
      
      default:    //참가신청 정보 작성/수정
        
        if(valType == "MOD") {
          if(confirm("참가신청 정보를 수정하시겠습니까?")){
            ON_Air(valType);  
          }
          else{
            return; 
          }
        }
        else{ //WRITE
          ON_Air(valType);  
        }
        
        break;        
    }
  }
  
  
  function ON_Air(val_Type){
    var msg = "";
    
    msg += "아래의 정보가 기입누락 되었습니다.\n";
    msg += "--------------------------------------------------------------------------\n";
    
    var num = 0;    //유효성검사 카운트
    var i;  
    var cnt = $('.entry').length;  //참가팀 카운트
    
    if(!$('#UserPass').val()){ msg += "비밀번호\n";  num = 1; }
    if(!$('#TeamGb').val()){ msg += "참가종목\n";  num = 1; }      
    if(!$('#UserName').val()){ msg += "신청자 이름\n";  num = 1; }
    if(!$('#UserPhone2').val()){ msg += "신청자 전화번호 가운데자리 입력\n";  num = 1; }
    if(!$('#UserPhone3').val()){ msg += "신청자 전화번호 뒷자리 입력\n";  num = 1; }
    
    
    msg += "\n";
    
    
    //P1_Player 첫번째 참가자 정보
    $("input[name='P1_UserName']").each(function (i) {
      if(!$("input[name='P1_UserName']").eq(i).val()){ msg += "참가자 이름["+(i+1)+"]\n"; num = 1; }
    });
    $("input[name='P1_UserPhone2']").each(function (i) {
      if(!$("input[name='P1_UserPhone2']").eq(i).val()){ msg += "참가자 전화번호 가운데자리 입력["+(i+1)+"]\n"; num = 1; }
    });
    $("input[name='P1_UserPhone3']").each(function (i) {
      if(!$("input[name='P1_UserPhone3']").eq(i).val()){ msg += "참가자 전화번호 뒷자리 입력["+(i+1)+"]\n"; num = 1; }
    });
    $("input[name='P1_Birthday']").each(function (i) {
      if(!$("input[name='P1_Birthday']").eq(i).val()){ msg += "참가자 생년월일["+(i+1)+"]\n"; num = 1; }
    });
    
    //소속은 최소 1개 이상 입력
    for(i=1; i<=cnt; i++){if(!$('#P1_TeamNmOne_'+i).val()){ msg += "참가자 소속["+i+"]\n";  num = 1; }}
    //for(i=1; i<=cnt; i++){if(!$('#P1_TeamNmTwo_'+i).val()){ msg += "참가자 소속2["+i+"]\n";  num = 1; }}
    
    msg += "\n";
    
    //P2_Player 파트너 정보
    $("input[name='P2_UserName']").each(function (i) {
      if(!$("input[name='P2_UserName']").eq(i).val()){ msg += "파트너 이름["+(i+1)+"]\n"; num = 1; }
    });
    $("input[name='P2_UserPhone2']").each(function (i) {
      if(!$("input[name='P2_UserPhone2']").eq(i).val()){ msg += "파트너 전화번호 가운데자리 입력["+(i+1)+"]\n"; num = 1; }
    });
    $("input[name='P2_UserPhone3']").each(function (i) {
      if(!$("input[name='P2_UserPhone3']").eq(i).val()){ msg += "파트너 전화번호 뒷자리 입력["+(i+1)+"]\n"; num = 1; }
    });
    $("input[name='P2_Birthday']").each(function (i) {
      if(!$("input[name='P2_Birthday']").eq(i).val()){ msg += "파트너 생년월일["+(i+1)+"]\n"; num = 1; }
    });
    
    //소속은 최소 1개 이상 입력
    for(i=1; i<=cnt; i++){ if(!$('#P2_TeamNmOne_'+i).val()){ msg += "파트너 소속["+i+"]\n";  num = 1; }} 
    //for(i=1; i<=cnt; i++){if(!$('#P2_TeamNmTwo_'+i).val()){ msg += "파트너 소속2["+i+"]\n";  num = 1; }}
    
    msg += "\n";
    
    
    
    //참가신청 중복 신청 데이터 체크
    if (num != 0) { 
      alert(msg); 
      return; 
    }
    else{
      
      var val_P1_Player = "";
      var val_P2_Player = "";
      var val_P1_Birthday = "";
      var val_P2_Birthday = "";
      var val_RequestIDX = "";
      
      
      //P1_Player Info
      $("input[name='P1_UserName']").each(function (i) {
        val_P1_Player += "|" + $("input[name='P1_UserName']").eq(i).val();
      }); 
      $("input[name='P1_Birthday']").each(function (i) {
        val_P1_Birthday += "|" + $("input[name='P1_Birthday']").eq(i).val();
      }); 
      
      //P2_Player Info
      $("input[name='P2_UserName']").each(function (i) {
        val_P2_Player += "|" + $("input[name='P2_UserName']").eq(i).val();
      }); 
      $("input[name='P2_Birthday']").each(function (i) {
        val_P2_Birthday += "|" + $("input[name='P2_Birthday']").eq(i).val();
      });
      
      
      $("input[name='val_RequestIDX']").each(function (i) {
        val_RequestIDX += "|" + $("input[name='val_RequestIDX']").eq(i).val();
      }); 
      
      var strAjaxUrl = "./ajax/write_Validity_Info.asp";  
      var GameTitle = $('#Fnd_GameTitle').val();
      var TeamGb = $('#TeamGb').val();

      
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: { 
          GameTitle     : GameTitle
          ,TeamGb       : TeamGb
          ,val_P1_Player    : val_P1_Player
          ,val_P1_Birthday    : val_P1_Birthday
          ,val_P2_Player    : val_P2_Player
          ,val_P2_Birthday    : val_P2_Birthday
          ,val_RequestIDX   : val_RequestIDX
          ,val_Cnt      : cnt
          ,val_Type     : val_Type
        },
        success: function(retDATA) {
        
          console.log(retDATA);
          
          if(retDATA){
          
            var strcut = retDATA.split("|");
            
            if(strcut[0]=="TRUE"){
              $('#Cnt_Entry').val(cnt);
              $('form[name=s_frm]').attr('action',"./write_ok.asp");
              $('form[name=s_frm]').submit();
            //  alert(strcut[0]);
            }   
            else{
              switch (strcut[1]) { 
                case '99' : msg = "이미 참가신청한 정보가 존재합니다. 입력하신 정보를 확인해주세요."; break;  
                default   : msg = "잘못된 접근입니다. 확인 후 이용하세요."; break;
              }
              alert(msg);
              return;
            }
          }
          else{
            alert("잘못된 접근입니다. 확인 후 이용하세요."); 
            return;
          }
        }, 
        error: function(xhr, status, error){
          if(error!=""){ 
            alert ("시스템관리자에게 문의하십시오!"); 
            return; 
          }     
        }
      });
    } 
  }
  
  //대회참가신청 정보 삭제
  function Info_Request_Del(valTitle, valGroupNum){
    var txtErr = "";
    var strAjaxUrl = "./ajax/write_Request_del.asp";      
    var valPass = $('#UserPass').val();
    var valLevel = $('#Level').val();
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { 
        valTitle      : valTitle
        ,valGroupNum  : valGroupNum
        ,valPass      : valPass
        ,valLevel     : valLevel
      },
      success: function(retDATA) {
      
        console.log(retDATA);
        
        if(retDATA){
        
          var strcut = retDATA.split("|");
          
          if(strcut[0]=="TRUE"){
            alert("참가신청 정보를 삭제하였습니다.");
            $('form[name=s_frm]').attr('action',"./list_repair.asp");
            $('form[name=s_frm]').submit();           
          }
          else{
            switch (strcut[1]) { 
              case '200'  : txtErr = "잘못된 접근입니다. 확인 후 이용하세요."; break;
              case '99'   : txtErr = "일치하는 정보가 없습니다. 확인 후 이용하세요"; break;
              case '66'   : txtErr = "참가신청정보를 삭제하지 못하였습니다. 확인 후 이용하세요"; break;
              default : break;             
            }
          
          alert(txtErr);  
          return; 
          }
        }     
      }, 
      error: function(xhr, status, error){
        if(error!=""){ 
          alert ("시스템관리자에게 문의하십시오!"); 
          return; 
        }     
      }
    }); 
  }
  
  //소속정보 입력 자동완성 기능
  function FND_TeamInfo(val, obj, sObj, keycode){
  
    var strAjaxUrl = "./ajax/write_Team_Info.asp";  
    var Fnd_KeyWord = val.replace(/ /g, '');    //공백제거
    
    //console.log(Fnd_KeyWord);
    
    var cnt = $("input[name='P1_UserName']").length;
    var id = obj.id;
    var valCnt = '';
    
    
    if(cnt < 10){
      valCnt = id.slice(-1);
    }
    else{
      valCnt = id.slice(-2);
    }
    
    //console.log(sObj);
    
    //방향키 keydown/keyup시 조회안되게(키포커스 이동 막음)
    if(keycode==37||keycode==38||keycode==39||keycode==40){
    }
    else{
    
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: { 
          Fnd_KeyWord : Fnd_KeyWord
        },
        success: function(retDATA) {
        
          //console.log(retDATA);
          //console.log($('#'+sObj+'_'+valCnt));

          $('#'+sObj+'_'+valCnt).children().remove();
          $('#'+sObj+'_'+valCnt).append(retDATA);
          
          //console.log($('#'+sObj+'_'+valCnt).children().length);
          
          if ($('#'+sObj+'_'+valCnt).children().length > 0) {
            $('#'+sObj+'_'+valCnt).addClass('on');
            $('.entry_list').autoSrchMove();
          } 
          else {
            $('#'+sObj+'_'+valCnt).removeClass('on');
          }       
        }, 
        error: function(xhr, status, error){
          if(error!=""){ 
            alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
            return; 
          }     
        }
      });   
    }
  }
  
  //신청자 정보와 동일 체크
  $(document).on('click','#CHK_INFO_SAME',function(){ 
    if($('#CHK_INFO_SAME').prop("checked")){    
      $('#P1_UserName').val($('#UserName').val());
      $('#P1_UserPhone1').val($('#UserPhone1').val());
      $('#P1_UserPhone2').val($('#UserPhone2').val());
      $('#P1_UserPhone3').val($('#UserPhone3').val());      
    }
    else{   
      $('#P1_UserName').val('');
      $('#P1_UserPhone1 option:eq(0)').attr('selected','selected');
      $('#P1_UserPhone2').val('');
      $('#P1_UserPhone3').val('');    
    }
  });
  
  $(document).ready(function(){
  //참가종목 조회
    $('#TeamGb').children('option').remove();
    
    FND_SELECTOR('TeamGb');
    
    //상단 대회정보 조회 출력
    FND_GameTitleInfo();
    
    // .gender label 이 on 이면 input 체크 되도록
    $('.entry .gender label').each(function(idx, el) {
      if ($(this).hasClass('on')) {
        $(this).find('input').prop('checked','checked');
      }
    });
  }); // ready end
</script>
</head>
<body class="lack_bg">
<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main -->
<div class="main">
  <!-- S: cont_box -->
  <div class="cont_box">
    <!-- S: form_header -->
    <div class="form_header">
      <h2 id="txt_GameTitleName" class="title">
        <!--[C그룹] 2017 Flex Power 용인클레이배 테니스대회-->
      </h2>
      <p id="txt_Term" class="term">
        <!--2017.08.11(금) ~ 2017.08.15(화)-->
      </p>
    </div>
    <!-- E: form_header -->
    <!-- S: form_cont -->
    <div class="form_cont">
      <!-- S: form -->
      <form name="s_frm" method="post">
        <input type="hidden" id="act" name="act" value="<%=act%>" />
        <input type="hidden" id="currPage" name="currPage" value="<%=currPage%>" />
        <input type="hidden" id="Fnd_KeyWord" name="Fnd_KeyWord" value="<%=Fnd_KeyWord%>" /><!--./list.asp, ./list_repair.asp KeyWord 검색조건-->
        <input type="hidden" id="GameTitle" name="GameTitle" value="<%=GameTitle%>" /><!--./list_repair.asp GameTitle 검색조건-->
        <input type="hidden" id="Fnd_TeamGb" name="Fnd_TeamGb" value="<%=TeamGb%>" /><!--./list_repair.asp TeamGb 검색조건-->
        <input type="hidden" id="Fnd_GameTitle" name="Fnd_GameTitle" value="<%=Fnd_GameTitle%>" />
        <input type="hidden" id="SMS_GameTitleNm" name="SMS_GameTitleNm" /><!--SMS 발송위한 정보[대회명]-->
        <input type="hidden" id="Cnt_Entry" name="Cnt_Entry" /><!--참가팀 카운트-->
        <!--수정시-->
        <input type="hidden" id="Level" name="Level" value="<%=Level%>" />
        <input type="hidden" id="RequestGroupNum" name="RequestGroupNum" value="<%=Request("RequestGroupNum")%>" />
        <fieldset>
          <!-- legend 안 보임 -->
          <legend>참가신청 작성</legend>
          <!-- legend 안 보임 -->
          <!-- S: form_list -->
          <ul class="form_list">
            <!-- S: 비밀번호 -->
            <li class="el_1">
              <label> <span class="title">비밀번호</span>
                <input type="password" id="UserPass" name="UserPass" maxlength="20" class="ipt"  value="<%=UserPass%>" />
              </label>
            </li>
            <!-- E: 비밀번호 -->
            <!-- S: 대회명 -->
            <!--
              <li class="el_1">
                <label>
                  <span class="title">대회명</span>
                  <select class="ipt" id="GameTitle" name="GameTitle" >
                    <option value="">:: 대회선택 ::</option>
                    <option>[B그룹]2017 프렌드쉽오픈</option>
                    <option>[SA그룹]2017 엔프라니배</option>
                    <option>[C그룹]2017 Flex Power 용인클레이배</option>
                    <option>[B그룹]2017 안양한우리 OPEN</option>
                    <option>[SA그룹]2017 나사라배</option>
                  </select>
                </label>
              </li>
              -->
            <!-- E: 대회명 -->
            <!-- S: 출전종목 -->
            <li class="el_1">
              <label> <span class="title">출전종목</span>
                <select class="ipt" id="TeamGb" name="TeamGb">
                  <option value="">:: 참가종목선택 ::</option>
                  <!--                    
                    <option>국화부</option>
                    <option>개나리부(부천)</option>
                    <option>개나리부(구리)</option>
                    <option>오픈부</option>
                    <option>신인부B(부천)</option>
                    <option>신인부B(구리)</option>
                    -->
                </select>
              </label>
            </li>
            <!-- E: 출전종목 -->
            <!-- S: 신청자 이름 -->
            <li class="reqer el_2">
              <label class="col_1"> <span class="title">신청자 이름</span>
                <input type="text" class="ipt" id="UserName" name="UserName" placeholder=":: 이름을 입력하세요 ::" value="<%=UserName%>" />
              </label>
              <span class="col_1 el_3 phone_line">
              <label> <span class="title">휴대폰 번호</span>
                <select class="ipt col_1" id="UserPhone1" name="UserPhone1">
                  <option value="010" <%IF UserPhone1 = "010" Then response.Write "selected" End IF%>>010</option>
                  <option value="011" <%IF UserPhone1 = "011" Then response.Write "selected" End IF%>>011</option>
                  <option value="016" <%IF UserPhone1 = "016" Then response.Write "selected" End IF%>>016</option>
                  <option value="017" <%IF UserPhone1 = "017" Then response.Write "selected" End IF%>>017</option>
                  <option value="018" <%IF UserPhone1 = "018" Then response.Write "selected" End IF%>>018</option>
                  <option value="019" <%IF UserPhone1 = "019" Then response.Write "selected" End IF%>>019</option>
                </select>
              </label>
              <span class="divn">-</span>
              <input type="number" class="ipt col_1 phone_line" id="UserPhone2" name="UserPhone2" maxlength="4" oninput="maxLengthCheck(this)" value="<%=UserPhone2%>" />
              <span class="divn">-</span>
              <input type="number" class="ipt col_1 phone_line" id="UserPhone3" name="UserPhone3" maxlength="4" oninput="maxLengthCheck(this)"  value="<%=UserPhone3%>" />
              </span> </li>
            <!-- E: 신청자 이름 -->
            <li class="no_bdb">
              <ul class="entry_list">
                <!-- S: 참가자 정보 -->
                <%
                dim i, j
              
                SELECT CASE act 
                  CASE "MOD" 
                
                      dim strPhone_P1, Phone1_P1, Phone2_P1, Phone3_P1
                      dim strPhone_P2, Phone1_P2, Phone2_P2, Phone3_P2
                    
            CSQL =        " SELECT * " 
            CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
            CSQL = CSQL & " WHERE DelYN = 'N' " 
            CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"'"
            CSQL = CSQL & "   AND GameTitleIDX = '"&Fnd_GameTitle&"'"
            CSQL = CSQL & "   AND RequestGroupNum = '"&RequestGroupNum&"'"
        
            
            SET CRs = Dbcon.Execute(CSQL)
            IF Not(CRs.Eof Or CRs.Bof) Then 
              Do Until CRs.Eof
              i = i + 1       
              
              IF CRs("P1_UserPhone") <> "" Then
                strPhone_P1 = Split(CRs("P1_UserPhone"), "-") 
                Phone1_P1 = strPhone_P1(0)
                Phone2_P1 = strPhone_P1(1)
                Phone3_P1 = strPhone_P1(2)            
              End IF  
              
              IF CRs("P2_UserPhone") <> "" Then
                strPhone_P2 = Split(CRs("P2_UserPhone"), "-") 
                Phone1_P2 = strPhone_P2(0)
                Phone2_P2 = strPhone_P2(1)
                Phone3_P2 = strPhone_P2(2)            
              End IF  
                %>
                
                <li id="div_Entry<%=cnt%>" class="entry el_2">
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header"> <a href="#" class="btn btn_party_del"> <span class="ic_deco"> <i class="fa fa-times-circle"></i> </span>
                      <!-- <span>참가자 삭제</span> -->
                      </a> <span class="num-box"><%=i%></span>
                      <h3>참가자1 정보</h3>
                      <%IF i = 1 Then%>
                      <label>
                        <input type="checkbox" id="CHK_INFO_SAME" name="CHK_INFO_SAME">
                        <span class="txt">신청자 정보와 동일</span> </label>
                      <%End IF%>
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                        <input type="text" class="ipt" id="P1_UserName" name="P1_UserName" value="<%=CRs("P1_UserName")%>" />
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P1_UserLevel" name="P1_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" <%IF CRs("P1_UserLevel") = "A" Then response.Write "selected" End IF%>>A</option>
                          <option value="B" <%IF CRs("P1_UserLevel") = "B" Then response.Write "selected" End IF%>>B</option>
                          <option value="C" <%IF CRs("P1_UserLevel") = "C" Then response.Write "selected" End IF%>>C</option>
                          <option value="D" <%IF CRs("P1_UserLevel") = "D" Then response.Write "selected" End IF%>>D</option>
                          <option value="E" <%IF CRs("P1_UserLevel") = "E" Then response.Write "selected" End IF%>>E</option>
                          <option value="F" <%IF CRs("P1_UserLevel") = "F" Then response.Write "selected" End IF%>>F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> <span class="show_srch col_1 ipt">
                      <input type="text" id="P1_TeamNmOne" name="P1_TeamNmOne" value="<%=CRs("P1_TeamNm")%>"  autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P1_ASOne', event.keyCode);" />
                      <ul class="auto_srch" id="P1_ASOne">
                        <!--
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                        -->
                      </ul>
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P1_TeamNmTwo" name="P1_TeamNmTwo" value="<%=CRs("P1_TeamNm2")%>" autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P1_ASTwo', event.keyCode);" />
                      <ul class="auto_srch" id="P1_ASTwo">
                        <!--
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                        -->
                      </ul>
                      </label>
                    </li>
                    <!-- E: 소속 -->
                    <!-- S: 성별 -->
                    <li class="gender el_2"> <span class="title">성별</span> <span class="type radio_list">
                      <label class="col_1 btn <%IF CRs("P1_SEX") = "Man" Then response.Write "on" End IF%>"> <span class="ic_deco"> <i class="fa fa-male"></i> </span>
                        <input type="radio" id="P1_Gender" name="P1_Gender" value="Man" >
                        <span>남자</span> </label>
                      <label class="col_1 btn <%IF CRs("P1_SEX") = "WoMan" Then response.Write "on" End IF%>"> <span class="ic_deco"> <i class="fa fa-female"></i> </span>
                        <input type="radio" id="P1_Gender" name="P1_Gender" value="WoMan" <%IF CRs("P1_SEX") = "WoMan" Then response.Write "checked" End IF%>>
                        <span>여자</span> </label>
                      </span> </li>
                    <!-- E: 성별 -->
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">휴대폰</span>
                        <select class="ipt col_1" id="P1_UserPhone1" name="P1_UserPhone1">
                          <option value="010" <%IF Phone1_P1 = "010" Then response.write "selected" End IF%>>010</option>
                          <option value="011" <%IF Phone1_P1 = "011" Then response.write "selected" End IF%>>011</option>
                          <option value="016" <%IF Phone1_P1 = "016" Then response.write "selected" End IF%>>016</option>
                          <option value="017" <%IF Phone1_P1 = "017" Then response.write "selected" End IF%>>017</option>
                          <option value="018" <%IF Phone1_P1 = "018" Then response.write "selected" End IF%>>018</option>
                          <option value="019" <%IF Phone1_P1 = "019" Then response.write "selected" End IF%>>019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone2" name="P1_UserPhone2" maxlength="4" value="<%=Phone2_P1%>" oninput="maxLengthCheck(this)" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone3" name="P1_UserPhone3" maxlength="4" value="<%=Phone3_P1%>" oninput="maxLengthCheck(this)" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <input type="number" class="ipt col_1" id="P1_Birthday" name="P1_Birthday" maxlength="8" placeholder="ex)19880725" value="<%=CRs("P1_Birthday")%>" oninput="maxLengthCheck(this)" >
                      </label>
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header">
                      <h3>참가자2 정보</h3>
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                        <input type="text" class="ipt" id="P2_UserName" name="P2_UserName" value="<%=CRs("P2_UserName")%>" />
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P2_UserLevel" name="P2_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" <%IF CRs("P2_UserLevel") = "A" Then response.Write "selected" End IF%>>A</option>
                          <option value="B" <%IF CRs("P2_UserLevel") = "B" Then response.Write "selected" End IF%>>B</option>
                          <option value="C" <%IF CRs("P2_UserLevel") = "C" Then response.Write "selected" End IF%>>C</option>
                          <option value="D" <%IF CRs("P2_UserLevel") = "D" Then response.Write "selected" End IF%>>D</option>
                          <option value="E" <%IF CRs("P2_UserLevel") = "E" Then response.Write "selected" End IF%>>E</option>
                          <option value="F" <%IF CRs("P2_UserLevel") = "F" Then response.Write "selected" End IF%>>F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> 
                      <span class="show_srch col_1 ipt">
                      <input type="text" id="P2_TeamNmOne" name="P2_TeamNmOne" value="<%=CRs("P2_TeamNm")%>" autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P2_ASOne', event.keyCode);" />
                      <ul class="auto_srch" id="P2_ASOne">
                        <!--
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                        -->
                      </ul>
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P2_TeamNmTwo" name="P2_TeamNmTwo" value="<%=CRs("P2_TeamNm2")%>" autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P2_ASTwo', event.keyCode);" />
                      <ul class="auto_srch" id="P2_ASTwo">
                        <!--
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                        -->
                      </ul>
                      </label>
                    </li>
                    <!-- E: 소속 -->
                    <!-- S: 성별 -->
                    <li class="gender el_2"> <span class="title">성별</span> <span class="type radio_list">
                      <label class="col_1 btn <%IF CRs("P2_SEX") = "Man" Then response.Write "on" End IF%>"> <span class="ic_deco"> <i class="fa fa-male"></i> </span>
                        <input type="radio" id="P2_Gender" name="P2_Gender" value="Man" <%IF CRs("P2_SEX") = "Man" Then response.Write "checked" End IF%>>
                        <span>남자</span> </label>
                      <label class="col_1 btn <%IF CRs("P2_SEX") = "WoMan" Then response.Write "on" End IF%>"> <span class="ic_deco"> <i class="fa fa-female"></i> </span>
                        <input type="radio" id="P2_Gender" name="P2_Gender" value="WoMan" <%IF CRs("P2_SEX") = "WoMan" Then response.Write "checked" End IF%>>
                        <span>여자</span> </label>
                      </span> </li>
                    <!-- E: 성별 -->
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">휴대폰</span>
                        <select class="ipt col_1" id="P2_UserPhone1" name="P2_UserPhone1">
                          <option value="010" <%IF Phone1_P2 = "010" Then response.write "selected" End IF%>>010</option>
                          <option value="011" <%IF Phone1_P2 = "011" Then response.write "selected" End IF%>>011</option>
                          <option value="016" <%IF Phone1_P2 = "016" Then response.write "selected" End IF%>>016</option>
                          <option value="017" <%IF Phone1_P2 = "017" Then response.write "selected" End IF%>>017</option>
                          <option value="018" <%IF Phone1_P2 = "018" Then response.write "selected" End IF%>>018</option>
                          <option value="019" <%IF Phone1_P2 = "019" Then response.write "selected" End IF%>>019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone2" name="P2_UserPhone2" maxlength="4" value="<%=Phone2_P2%>" oninput="maxLengthCheck(this)" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone3" name="P2_UserPhone3" maxlength="4" value="<%=Phone3_P2%>" oninput="maxLengthCheck(this)" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <input type="number" class="ipt col_1" id="P2_Birthday" name="P2_Birthday" maxlength="8" placeholder="ex)19880725" value="<%=CRs("P2_Birthday")%>" oninput="maxLengthCheck(this)" />
                      </label>
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                  <input type="hidden" id="val_RequestIDX" name="val_RequestIDX" value="<%=CRs("RequestIDX")%>" />
                </li>
                <%
              CRs.Movenext
            Loop
          End IF
            CRs.Close
          SET CRs = Nothing
          
          
        'WRITE            
        CASE ELSE
        %>
                <li class="entry el_2">
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header"> <a href="#" class="btn btn_party_del"> <span class="ic_deco"> <i class="fa fa-times-circle"></i> </span>
                      <!-- <span>참가자 삭제</span> -->
                      </a> <span class="num-box">1</span>
                      <h3>참가자1 정보</h3>
                      <label>
                        <input type="checkbox" id="CHK_INFO_SAME" name="CHK_INFO_SAME">
                        <span class="txt">신청자 정보와 동일</span> </label>
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                        <input type="text" class="ipt" id="P1_UserName" name="P1_UserName">
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P1_UserLevel" name="P1_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" selected>A</option>
                          <option value="B">B</option>
                          <option value="C">C</option>
                          <option value="D">D</option>
                          <option value="E">E</option>
                          <option value="F">F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 구버전 -->
                    <!-- <li class="el_1">
                        <label>
                          <span class="title">소속</span>
                          <select class="ipt" id="P_ReqClub2" name="P_ReqClub2">
                            <option>:: 소속을 선택하세요 ::</option>
                            <option>무궁화, 삼천리</option>
                            <option>백두산, 한라산</option>
                            <option>직접 입력</option>
                          </select>
                        </label>
                        <ul class="dir_ipt el_2 clearfix">
                          <li>
                            <input type="text">
                          </li>
                          <li class="divn">,</li>
                          <li>
                            <input type="text">
                          </li>
                        </ul>
                      </li> -->
                    <!-- E: 소속 구버전 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> <span class="show_srch col_1 ipt">
                      <input type="text" id="P1_TeamNmOne" name="P1_TeamNmOne" autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P1_ASOne', event.keyCode);" />
                      <ul class="auto_srch" id="P1_ASOne">
                        <!--
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                      -->
                      </ul>
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P1_TeamNmTwo" name="P1_TeamNmTwo" autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P1_ASTwo', event.keyCode);" />
                      <ul class="auto_srch" id="P1_ASTwo">
                        <!--
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                        -->
                      </ul>
                      </label>
                    </li>
                    <!-- E: 소속 -->
                    <!-- S: 성별 -->
                    <li class="gender el_2"> <span class="title">성별</span> <span class="type radio_list">
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-male"></i> </span>
                        <input type="radio" id="P1_Gender" name="P1_Gender" value="Man" />
                        <span>남자</span> </label>
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-female"></i> </span>
                        <input type="radio" id="P1_Gender" name="P1_Gender" value="WoMan" />
                        <span>여자</span> </label>
                      </span> </li>
                    <!-- E: 성별 -->
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">핸드폰</span>
                        <select class="ipt col_1" id="P1_UserPhone1" name="P1_UserPhone1">
                          <option value="010">010</option>
                          <option value="011">011</option>
                          <option value="016">016</option>
                          <option value="017">017</option>
                          <option value="018">018</option>
                          <option value="019">019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone2" name="P1_UserPhone2" maxlength="4" oninput="maxLengthCheck(this)" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P1_UserPhone3" name="P1_UserPhone3" maxlength="4" oninput="maxLengthCheck(this)" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <!-- <select class="ipt col_1" id="P1_BirthdayY" name="P1_BirthdayY">
                            <option value="">생년</option>
                            <option value="">1940</option>
                            <option value="">1941</option>
                            <option value="">1942</option>
                            <option value="">1943</option>
                            <option value="">1944</option>
                            <option value="">1945</option>
                            <option value="">1946</option>
                            <option value="">1947</option>
                            <option value="">1948</option>
                            <option value="">1949</option>
                            <option value="">1950</option>
                          </select> -->
                        <input type="number" class="ipt col_1" id="P1_Birthday" name="P1_Birthday" maxlength="8" placeholder="ex)19880725" oninput="maxLengthCheck(this)" />
                      </label>
                      <!-- <span class="divn">-</span>
                        <select class="ipt col_1" id="P1_BirthdayM" name="P1_BirthdayM">
                          <option value="">월</option>
                          <option value="">01</option>
                          <option value="">02</option>
                          <option value="">03</option>
                          <option value="">04</option>
                          <option value="">05</option>
                          <option value="">06</option>
                          <option value="">07</option>
                          <option value="">08</option>
                          <option value="">09</option>
                          <option value="">10</option>
                          <option value="">11</option>
                          <option value="">12</option>
                        </select> 
                        <span class="divn">-</span>-->
                      <!-- <select class="ipt col_1" id="P1_BirthdayD" name="P1_BirthdayD">
                          <option value="">일</option>
                          <option value="">1</option>
                          <option value="">2</option>
                          <option value="">3</option>
                          <option value="">4</option>
                        </select> -->
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                  <!-- S: party -->
                  <ul class="party col_1">
                    <!-- S: header -->
                    <li class="header">
                      <h3>참가자2 정보</h3>
                    </li>
                    <!-- E: header -->
                    <!-- S: 이름 -->
                    <li class="el_2 name">
                      <label class="col_1"> <span class="title">이름</span>
                        <input type="text" class="ipt" id="P2_UserName" name="P2_UserName" />
                      </label>
                      <label class="col_1"> <span class="title">등급</span>
                        <select class="ipt" id="P2_UserLevel" name="P2_UserLevel">
                          <!--<option value="">선택</option>-->
                          <option value="A" selected>A</option>
                          <option value="B">B</option>
                          <option value="C">C</option>
                          <option value="D">D</option>
                          <option value="E">E</option>
                          <option value="F">F</option>
                        </select>
                      </label>
                    </li>
                    <!-- E: 이름 -->
                    <!-- S: 소속 -->
                    <li class="club el_2 clearfix">
                      <label>
                      <span class="title">소속</span> <span class="show_srch col_1 ipt">
                      <input type="text" id="P2_TeamNmOne" name="P2_TeamNmOne" autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P2_ASOne', event.keyCode);" />
                      <ul class="auto_srch" id="P2_ASOne">
                        <!--
                         <li><a href="#">강서어택</a></li>
                              <li><a href="#">강북멋쟁이</a></li>
                              <li><a href="#">강남스타일</a></li>
                              <li><a href="#">강서뚜쟁이</a></li>
                              <li><a href="#">강동막둥이</a></li>
                              <li><a href="#">마포막난이</a></li> 
                              -->
                      </ul>
                      </span>
                      </label>
                      <span class="divn">,</span>
                      <label class="col_1 ipt">
                      <input type="text" id="P2_TeamNmTwo" name="P2_TeamNmTwo" autocomplete="off" onKeyUp="FND_TeamInfo(this.value, this, 'P2_ASTwo', event.keyCode);" />
                      <ul class="auto_srch" id="P2_ASTwo">
                        <li><a href="#">강서어택</a></li>
                        <li><a href="#">강북멋쟁이</a></li>
                        <li><a href="#">강남스타일</a></li>
                        <li><a href="#">강서뚜쟁이</a></li>
                        <li><a href="#">강동막둥이</a></li>
                        <li><a href="#">마포막난이</a></li>
                      </ul>
                      </label>
                    </li>
                    <!-- E: 소속 -->
                    <!-- S: 성별 -->
                    <li class="gender el_2"> <span class="title">성별</span> <span class="type radio_list">
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-male"></i> </span>
                        <input type="radio" id="P2_Gender" name="P2_Gender" value="Man" />
                        <span>남자</span> </label>
                      <label class="col_1 btn"> <span class="ic_deco"> <i class="fa fa-female"></i> </span>
                        <input type="radio" id="P2_Gender" name="P2_Gender" value="WoMan" />
                        <span>여자</span> </label>
                      </span> </li>
                    <!-- E: 성별 -->
                    <!-- S: 핸드폰 -->
                    <li class="phone_line el_3">
                      <label> <span class="title">핸드폰</span>
                        <select class="ipt col_1" id="P2_UserPhone1" name="P2_UserPhone1">
                          <option value="010">010</option>
                          <option value="011">011</option>
                          <option value="016">016</option>
                          <option value="017">017</option>
                          <option value="018">018</option>
                          <option value="019">019</option>
                        </select>
                      </label>
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone2" name="P2_UserPhone2" maxlength="4" oninput="maxLengthCheck(this)" />
                      <span class="divn">-</span>
                      <input type="number" class="ipt col_1" id="P2_UserPhone3" name="P2_UserPhone3" maxlength="4" oninput="maxLengthCheck(this)" />
                    </li>
                    <!-- E: 핸드폰 -->
                    <!-- S: 생년월일 -->
                    <li class="birth el_1">
                      <label> <span class="title">생년월일</span>
                        <!-- <select class="ipt col_1" id="P_ReqBirthdayY2" name="P_ReqBirthdayY2">
                            <option value="">생년</option>
                            <option value="">1940</option>
                            <option value="">1941</option>
                            <option value="">1942</option>
                            <option value="">1943</option>
                            <option value="">1944</option>
                            <option value="">1945</option>
                            <option value="">1946</option>
                            <option value="">1947</option>
                            <option value="">1948</option>
                            <option value="">1949</option>
                            <option value="">1950</option>
                          </select> -->
                        <input type="number" class="ipt col_1" id="P2_Birthday" name="P2_Birthday" maxlength="8" placeholder="ex)19880725" oninput="maxLengthCheck(this)" />
                      </label>
                      <!-- <span class="divn">-</span>
                        <select class="ipt col_1"id="P_ReqBirthdayM2" name="P_ReqBirthdayM2">
                          <option value="">월</option>
                          <option value="">01</option>
                          <option value="">02</option>
                          <option value="">03</option>
                          <option value="">04</option>
                          <option value="">05</option>
                          <option value="">06</option>
                          <option value="">07</option>
                          <option value="">08</option>
                          <option value="">09</option>
                          <option value="">10</option>
                          <option value="">11</option>
                          <option value="">12</option>
                        </select>
                        <span class="divn">-</span>
                        <select class="ipt col_1"id="P_ReqBirthdayD2" name="P_ReqBirthdayD2">
                          <option value="">일</option>
                          <option value="">1</option>
                          <option value="">2</option>
                          <option value="">3</option>
                          <option value="">4</option>
                        </select> -->
                    </li>
                    <!-- E: 생년월일 -->
                  </ul>
                  <!-- E: party -->
                </li>
                <%
        END SELECT  
          %>
                <!-- E: 참가자 정보 -->
              </ul>
            </li>
            <!-- S: 소속 입력 안내 -->
            <li class="guide_txt club_guide">
              <p>※신규 대회출전자, 혹은 소속명 자동조회가 안 될 경우, "직접입력"하셔서 등록 하시기 바랍니다.</p>
            </li>
            <!-- E: 소속 입력 안내 -->
            <!-- S: 생년월일 입력 안내 -->
            <!-- <li class="guide_txt birth_guide">
              <p>※생년월일의 정보를 입력하게되면 향후 스포츠다이어리 어플리케이션에서 파트너(Pair)찾기 등의 다양한 서비스이용시 용이하며, 그 외의 이벤트 기간에 많은 혜택의 기회가 주어집니다. </p>
            </li> -->
            <!-- E: 생년월일 입력 안내 -->
            <!-- 
                S: 참가팀 추가등록 
                버튼 클릭시 
                entry_list 아래 li.entry 가 추가 되도록 구성
              -->
            <li class="btn_full no_bdb"> <a href="#" class="btn add_party"> <span class="ic_deco"><i class="fa fa-plus"></i></span> <span>참가팀 추가등록</span> </a> </li>
            <!-- E: 참가팀 추가등록 -->
            <!-- S: 입금일자 -->
            <li class="title_list"> <span class="big_title">대회참가비 입금정보</span>
              <label> <span class="title">입금일자</span>
                <input type="text" class="ipt" placeholder="ex) 2017.01.01" id="PaymentDt" name="PaymentDt" value="<%=PaymentDt%>" />
              </label>
              <label> <span class="title">입금자명</span>
                <input type="text" class="ipt" id="PaymentNm" name="PaymentNm" value="<%=PaymentNm%>" />
              </label>
            </li>
            <!-- E: 입금일자 -->
            <!-- S: 기타 건의내용 -->
            <li class="title_list user_suggest"> <span class="big_title">기타 건의내용</span>
              <label> <span class="ipt">
                <textarea id="txtMemo" name="txtMemo"><%=txtMemo%></textarea>
                </span> </label>
            </li>
            <!-- E: 기타 건의내용 -->
            <!-- S: guide_txt -->
            <!-- <li class="guide_txt agree_warn clearfix"> <span class="ic_deco"> <i class="fa fa-exclamation-circle"></i> </span>
              <div class="txt">
                <p>입력하신 참가자(파트너 포함) 휴대폰 번호를 통해 참가선수 본인 확인절차가 진행됩니다.<br>
                  반드시 대회 참가자의 휴대폰 번호를 정확하게 입력하시기 바랍니다.</p>
              </div>
            </li>
            <li class="guide_txt down_way">
              <h3 class="tit">스포츠다이어리 앱 다운로드 방법</h3>
              <span class="way_img"> <img src="imgs/write/down_way.png" alt="구글플레이, 앱스토어에서 스포츠다이어리 다운 후 어플리케이션 회원가입하여 이용하세요!"> </span>
              <p class="txt">※ 앞으로 KATA동호인테니스 대회의 모든 <span class="redy">경기결과 및 선수조회는 스포츠다이어리 어플리케이션을 통해 실시간 제공</span>해 드립니다.<br>
                스포츠다이어리로 대회정보 외에도 다양한 컨텐츠를 이용바랍니다.</p>
            </li> -->
            <!-- E: guide_txt -->
          </ul>
          <!-- E: form_list -->
        </fieldset>
        <%IF act = "WR" Then%>
        <!-- S: cta_btn -->
        <div class="cta_btn"> <a href="javascript:CHK_OnSubmit('GLIST');" class="btn_gray">대회목록보기</a> <a href="javascript:CHK_OnSubmit('RLIST');" class="btn_dark_gray">참가신청목록보기</a> <a href="javascript:CHK_OnSubmit('SAVE');" class="btn_green">참가신청 완료</a> </div>
        <!-- E: cta_btn -->
        <%Else%>
        <!-- 
            조회 후 보이는 버튼 목록
            신청 삭제 : 내용 삭제 및 취소 (confirm 창으로 재확인)
            수정하기 -> write 상태로 변경
            목록보기 -> 이전 list.asp로 이동
           -->
        <!-- S: cta_btn -->
        <div class="cta_btn"> <a href="javascript:CHK_OnSubmit('GLIST');" class="btn_gray">대회목록보기</a> <a href="javascript:CHK_OnSubmit('RLIST');" class="btn_dark_gray">참가신청목록보기</a> <a href="javascript:CHK_OnSubmit('DEL');" class="btn_redy">신청 삭제</a> <a href="javascript:CHK_OnSubmit('MOD');" class="btn_green">수정하기</a> </div>
        <!-- E: cta_btn -->
        <%End IF%>
      </form>
      <!-- E: form -->
    </div>
    <!-- E: form_cont -->
  </div>
  <!-- E: cont_box -->
</div>
<!-- E: main -->
<script src="js/main.js"></script>
<script>
 /**
  * calendar 필요시 ajax 호출 이후에도 호출 필요.
  */
  $(function(){
    $('.birth label input').datepicker({
      'changeYear' : true,
      'changeMonth' : true,
      'yearRange' : '1900:'
    });
  })
</script>
</body>
</html>