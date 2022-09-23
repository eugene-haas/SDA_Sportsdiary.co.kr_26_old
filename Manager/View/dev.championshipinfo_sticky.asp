<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script src="../js/jquery.easing.1.3.min.js"></script>
<script language="javascript">
$(document).ready(function(){
  init();
});


//입력폼 체크 S
function input_frm(){   
  var f = document.frm;
  if(f.GameGb.value==""){
    alert("대회구분을 선택해 주세요");
    f.GameGb.focus();
    return false;
  }
  if(f.SportsGb.value==""){
    alert("종목을 선택해 주세요.");
    f.SportsGb.focus();
    return false;
  }
  if(f.GameYear.value==""){
    alert("대회년도를 선택해 주세요");
    f.GameYear.focus();
    return false;
  }
  if(f.GameTitleName.value==""){
    alert("대회명을 입력해 주세요");
    f.GameTitleName.focus();
    return false;
  }
  if(f.GameLocation.value==""){
    alert("대회개최 지역을 선택해 주세요");
    f.GameLocation.focus();
    return false;
  }
  if(f.GameLocationDetl.value==""){
    alert("대회개최 상세지역을 입력해 주세요");
    f.GameLocationDetl.focus();
    return false;
  }
  if(f.GameS_Year.value==""){
    alert("대회 시작년도를 선택해 주세요");
    f.GameS_Year.focus();
    return false;
  }
  if(f.GameS_Month.value==""){
    alert("대회 시작월을 선택해 주세요");
    f.GameS_Month.focus();
    return false;
  }
  if(f.GameS_Day.value==""){
    alert("대회 시작일을 선택해 주세요");
    f.GameS_Day.focus();
    return false;
  }
  if(f.GameE_Year.value==""){
    alert("대회종료 년도를 선택해 주세요");
    f.GameE_Year.focus();
    return false;
  }
  if(f.GameE_Month.value==""){
    alert("대회종료 월을 선택해 주세요");
    f.GameE_Month.focus();
    return false;
  }
  if(f.GameE_Day.value==""){
    alert("대회종료 일을 선택해 주세요");
    f.GameE_Day.focus();
    return false;
  } 
  if(f.GameArea.value==""){
    alert("대회 개최 장소를 입력해 주세요");
    f.GameArea.focus();
    return false;
  }


  if(confirm("대회정보 입력을 진행하시겠습니까?")){
    var strAjaxUrl = "/Manager/Ajax/ChampionshipInfo_Insert.asp";
    var SportsGb         = f.SportsGb.value;
    var GameGb           = f.GameGb.value;
    var GameYear         = f.GameYear.value;
    var GameTitleName    = f.GameTitleName.value;
    var GameLocation     = f.GameLocation.value;
    var GameLocationDetl = f.GameLocationDetl.value;
    var GameS_Year       = f.GameS_Year.value;
    var GameS_Month      = f.GameS_Month.value;
    var GameS_Day        = f.GameS_Day.value;
    var GameE_Year       = f.GameE_Year.value;
    var GameE_Month      = f.GameE_Month.value;
    var GameE_Day        = f.GameE_Day.value;
    var GameArea         = f.GameArea.value;


    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { 
        SportsGb         : SportsGb ,
        GameGb           : GameGb  ,
        GameYear        : GameYear ,
        GameTitleName    : GameTitleName ,
        GameLocation     : GameLocation ,
        GameLocationDetl : GameLocationDetl ,
        GameS_Year       : GameS_Year ,
        GameS_Month      : GameS_Month ,
        GameS_Day        : GameS_Day ,
        GameE_Year       : GameE_Year ,
        GameE_Month      : GameE_Month ,
        GameE_Day        : GameE_Day ,
        GameArea         : GameArea     
      },    
      success: function(retDATA) {
        //document.write(retDATA);
        if(retDATA){
          //parent.fBottom.popupClose("btnsave","btnsave","");
          if (retDATA=='TRUE') {
            alert('입력이 완료되었습니다!');    
            view_frm("F");            
          } else if(retDATA=='SAME'){
            alert('이미 등록된 대회명 입니다.!');                
          } else {
            alert('예외가 발생하여 입력이 실패하였습니다!');               
          }
        }
      }, error: function(xhr, status, error){           
        //parent.fBottom.popupClose("btnsave","btnsave","");
        alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
      }
    });   
  }
}


//수정폼 체크 S
function update_frm(){    
  var f = document.frm;
  var seq = document.getElementById('setseq').value;
  
  if (seq==''){
    alert ("수정 대상을 선택하십시오!");
    return false;
  }
  if(f.GameGb.value==""){
    alert("대회구분을 선택해 주세요");
    f.GameGb.focus();
    return false;
  }
  if(f.SportsGb.value==""){
    alert("종목을 선택해 주세요.");
    f.SportsGb.focus();
    return false;
  }
  if(f.GameYear.value==""){
    alert("대회년도를 선택해 주세요");
    f.GameYear.focus();
    return false;
  }
  if(f.GameTitleName.value==""){
    alert("대회명을 입력해 주세요");
    f.GameTitleName.focus();
    return false;
  }
  if(f.GameLocation.value==""){
    alert("대회개최 지역을 선택해 주세요");
    f.GameLocation.focus();
    return false;
  }
  if(f.GameLocationDetl.value==""){
    alert("대회개최 상세지역을 입력해 주세요");
    f.GameLocationDetl.focus();
    return false;
  }
  if(f.GameS_Year.value==""){
    alert("대회 시작년도를 선택해 주세요");
    f.GameS_Year.focus();
    return false;
  }
  if(f.GameS_Month.value==""){
    alert("대회 시작월을 선택해 주세요");
    f.GameS_Month.focus();
    return false;
  }
  if(f.GameS_Day.value==""){
    alert("대회 시작일을 선택해 주세요");
    f.GameS_Day.focus();
    return false;
  }
  if(f.GameE_Year.value==""){
    alert("대회종료 년도를 선택해 주세요");
    f.GameE_Year.focus();
    return false;
  }
  if(f.GameE_Month.value==""){
    alert("대회종료 월을 선택해 주세요");
    f.GameE_Month.focus();
    return false;
  }
  if(f.GameE_Day.value==""){
    alert("대회종료 일을 선택해 주세요");
    f.GameE_Day.focus();
    return false;
  } 
  if(f.GameArea.value==""){
    alert("대회 개최 장소를 입력해 주세요");
    f.GameArea.focus();
    return false;
  }


  if(confirm("대회정보 수정을 진행하시겠습니까?")){
    var strAjaxUrl = "/Manager/Ajax/ChampionshipInfo_Update.asp";
    var SportsGb         = f.SportsGb.value;
    var GameGb           = f.GameGb.value;
    var GameYear         = f.GameYear.value;
    var GameTitleName    = f.GameTitleName.value;
    var GameLocation     = f.GameLocation.value;
    var GameLocationDetl = f.GameLocationDetl.value;
    var GameS_Year       = f.GameS_Year.value;
    var GameS_Month      = f.GameS_Month.value;
    var GameS_Day        = f.GameS_Day.value;
    var GameE_Year       = f.GameE_Year.value;
    var GameE_Month      = f.GameE_Month.value;
    var GameE_Day        = f.GameE_Day.value;
    var GameArea         = f.GameArea.value;


    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { 
        seq              : seq,
        SportsGb         : SportsGb ,
        GameGb           : GameGb  ,
        GameYear         : GameYear ,
        GameTitleName    : GameTitleName ,
        GameLocation     : GameLocation ,
        GameLocationDetl : GameLocationDetl ,
        GameS_Year       : GameS_Year ,
        GameS_Month      : GameS_Month ,
        GameS_Day        : GameS_Day ,
        GameE_Year       : GameE_Year ,
        GameE_Month      : GameE_Month ,
        GameE_Day        : GameE_Day ,
        GameArea         : GameArea     
      },    
      success: function(retDATA) {
        //document.write(retDATA);
        if(retDATA){
          //parent.fBottom.popupClose("btnsave","btnsave","");
          if (retDATA=='TRUE') {
            alert('수정이 완료되었습니다!');    
            view_frm("F");            
          } else {
            alert('예외가 발생하여 입력이 실패하였습니다!');               
          }
        }
      }, error: function(xhr, status, error){           
        //parent.fBottom.popupClose("btnsave","btnsave","");
        alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
      }
    });   
  }
}

//리스트
function view_frm(tp){

  //조회종료 효과는 이벤트가 종료되는 각 시점에서 처리한다.
  //이유는 일괄처리시 웹 특성(이벤트 wait 불가)으로 정확한 효과 처리가 불가능함.

  var list   = document.getElementById("list");
  var settp  = document.getElementById("settp").value;      
  var setkey = document.getElementById("setkey").value;     
  var totcnt = document.getElementById("totcnt");     
  var nowcnt = document.getElementById("nowcnt");     
  

  var sf = document.search_frm;
  var Search_GameYear      = sf.Search_GameYear.value
  var Search_GameTitleName = sf.Search_GameTitleName.value
  var Search_Location      = sf.Search_Location.value
  var Search_LocationDetl  = sf.Search_LocationDetl.value
  var lih = $(list);
  console.log(lih);



  //다음조회를 조회보다 먼저 눌렀을 경우 막는다
  if (tp=="N" && settp=="") {
    alert ("조회 데이타가 없습니다!");

  }

  //조회를 누르면 무조건 처음부터 조회한다
  if (tp=="F" && settp=="F") {
    setkey = "";    
    nowcnt.innerText=0;
    lih = $(list).html('');
  }

  //다음조회 후 조회를 누르면 처음부터 조회한다
  if (tp=="F" && settp=="N") {
    setkey = "";
    nowcnt.innerText=0;
    lih = $(list).html('');
  }
    
  //조회시작 효과
  //parent.fBottom.popupOpen("btnview","btnnext","조회중입니다!");

  //tp : F-조회, N-다음조회
  //setkey : 다음조회를 위하여 키를 던진다 전 조회 마지막 데이타를 키로 만든다
  var strAjaxUrl="/Manager/ajax/ChampionshioInfo_View.asp";
  $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        tp                   : tp,
        key                  : setkey,
        Search_GameYear      : Search_GameYear , 
        Search_GameTitleName : Search_GameTitleName ,
        Search_Location      : Search_Location ,
        Search_LocationDetl  : Search_LocationDetl 

      },
      success: function(retDATA) {
        if(retDATA){      
          retDATA = trim(retDATA);  
          
          var strcut = retDATA.split("ㅹ");        
        
          //다음조회가 있는 경우에만 데이터를 출력한다
          if (strcut[0] != "null") {                
            document.getElementById("settp").value = strcut[2]
            document.getElementById("setkey").value = strcut[1]
            totcnt.innerText = strcut[3]
            nowcnt.innerText = Number(nowcnt.innerText) + Number(strcut[4])
          
            lih = lih + strcut[0];
            var style_lih;
            var style_lih = $(style_lih).html('<link rel="stylesheet" href="../css/style.css">')
            $('head').append(style_lih);
            console.log(style_lih);
            $('.table-list').append(lih);

            //조회종료 효과
            //parent.fBottom.popupClose("btnview","btnnext","");
          }

          if (strcut[0] == "null") {
            //조회종료 효과
            //parent.fBottom.popupClose("btnview","btnnext","");
            alert ("조회 데이타가 없습니다!");
          }
        }
      }, error: function(xhr, status, error){
        //조회종료 효과
        //parent.fBottom.popupClose("btnview","btnnext","");
        alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
      }
    });
  } 



function input_data(seq){ 
  //parent.fBottom.popupOpen("","","CONTENTS 조회중입니다!");
  var strAjaxUrl="/Manager/Ajax/Championship_DataView.asp";
  
  $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { seq: seq},
      success: function(retDATA) {
        //document.write(retDATA);
        if(retDATA){  
          
          var strcut = retDATA.split("|>");     
          var f = document.frm;
          f.GameGb.value            = strcut[0];
          f.SportsGb.value          = strcut[1];
          f.GameYear.value          = strcut[2];
          f.GameTitleName.value     = strcut[3];
          f.GameLocation.value      = strcut[4];
          f.GameLocationDetl.value  = strcut[5];
          f.GameS_Year.value        = strcut[6];
          f.GameS_Month.value       = strcut[7];
          f.GameS_Day.value         = strcut[8];
          f.GameE_Year.value        = strcut[9];
          f.GameE_Month.value       = strcut[10];
          f.GameE_Day.value         = strcut[11];
          f.GameArea.value          = strcut[12];

          //parent.fBottom.popupClose("","","");  
          document.getElementById("setseq").value = seq;        
        }     
        
        if (retDATA == null) {
          //조회종료 효과
          //parent.fBottom.popupClose("","","");
          alert ("조회 데이타가 없습니다!");
          document.getElementById("setseq").value = "";
        }
      }, error: function(xhr, status, error){
        //조회종료 효과
        //parent.fBottom.popupClose("","","");
        alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
        setseq = "";
      }
    });
}


function del_frm () {   
  var seq = document.getElementById('setseq').value;  
  if (seq=='') {
    alert ("삭제 대상을 선택하십시오!");
    return false;
  }
  
  if(confirm("대회정보를 삭제하시겠습니까?")){

        
    //parent.fBottom.popupOpen("btndel","btndel","삭제중입니다!");
    var strAjaxUrl = "/Manager/Ajax/Championship_Del.asp";
    var retDATA="";
     
     $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',       
      data: { seq: seq },   
      success: function(retDATA) {
        if(retDATA){
          //parent.fBottom.popupClose("btndel","btndel","");
          if (retDATA=='TRUE') {
            alert('삭제가 완료되었습니다!');    
            view_frm("F");            
          }
          else {
          alert('예외가 발생하여 삭제가 실패하였습니다!');               
          }
        }
      }, error: function(xhr, status, error){           
        //parent.fBottom.popupClose("btndel","btndel","");
        alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
      }
    }); 
  }
}




/*대회정보관리 열고닫기S*/
function input_view(){
  if(document.getElementById("input_area").offsetHeight>0){
    document.getElementById("input_area").style.display="none";
    document.getElementById("input_button_type").className = "btn-top-sdr open";
  }else{
    document.getElementById("input_area").style.display="block";
    document.getElementById("input_button_type").className = "btn-top-sdr close";
  }           
}
/*대회정보관리 열고닫기E*/

/* 개인전 단체전 체급 등록현황S */
function view_level(gametitleidx,gametitlename,group_type){
  location.href="/Manager/View/ChampionshipLevel.asp?gametitleidx="+gametitleidx+"&gametitlename="+gametitlename+"&group_type="+group_type;
}
/* 개인전 단체전 체급 등록현황S */
</script>
<script>
  make_box("sel_Year2","Search_GameYear","","Year")
  make_box("sel_Location2","Search_Location","","Area_Small")
  make_box("sel_GameGb","GameGb","","GameGb")
  make_box("sel_SportsGb","SportsGb","","SportsGb")
  make_box("sel_Year","GameYear","","Year")
  make_box("sel_Location","GameLocation","","Area")
  make_box("sel_GameSYear","GameS_Year","","Year")
  make_box("sel_GameSMonth","GameS_Month","","Month")
  make_box("sel_GameSDay","GameS_Day","","Day")
  make_box("sel_GameEYear","GameE_Year","","Year")
  make_box("sel_GameEMonth","GameE_Month","","Month")
  make_box("sel_GameEDay","GameE_Day","","Day")
  
</script>
<body onload="view_frm('F')">
  <!-- S : content -->
  <section>
    <div id="content">
      <div class="loaction">
        <strong>대회정보관리</strong> &gt; 대회정보관리
      </div>
      <!-- S : top-navi -->
      <div class="top-navi" >
        <div class="top-navi-inner">
          <!-- S : top-navi-tp 접혔을 때-->
          <div class="top-navi-tp">
            <h3 class="top-navi-tit" style="height: 50px;">
              <!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
              <strong>대회정보</strong>
            </h3>
            <!--<a href="#" id="input_button_type" class="btn-top-sdr open" title="더보기" onclick="input_view();"></a>-->
            <a href="#" id="input_button_type" class="btn-top-sdr close" title="닫기" onclick="input_view();"></a>
            <!--<a href="#" class="btn-top-sdr" title="더보기"><i class="fa fa-sort-desc" aria-hidden="true"></i></a>
            <a href="#" class="btn-top-sdr" title="닫기"><i class="fa fa-minus" aria-hidden="true"></i></a>-->
          </div>
          <!-- E : top-navi-tp 접혔을 때 -->
          <!-- S : top-navi-btm 펼쳤을 때 보이는 부분 -->
          <form name="frm" method="post">
          <!--종목-->
          <div class="top-navi-btm" id="input_area">
            <div class="navi-tp-table-wrap">
              <table class="navi-tp-table">
                <caption>대회정보 기본정보</caption>
                <colgroup>
                  <col width="64px" />
                  <col width="*" />
                  <col width="64px" />
                  <col width="*" />
                  <col width="94px" />
                  <col width="*" />
                </colgroup>
                <tbody>
                  <tr>
                    <th scope="row">종목/년도</th>
                    <td>
                      <div class="ymd-list">
                        <span id="sel_GameGb"><select name="GameGb"></select></span>
                        <span id="sel_SportsGb"><select name="SportsGb"></select></span>
                        <span id="sel_Year"><select name="GameYear"></select></span>
                      </div>
                    </td>
                    <th scope="row"><label for="competition-name">대회명</label></th>
                    <td><input type="text" name="GameTitleName" id="GameTitleName" placeholder="대회명을 입력해주세요." /></td>
                    <th scope="row">지역</th>
                    <td>
                      <span id="sel_Location"><select name="GameLocation"></select></span>
                      <input type="text" name="GameLocationDetl" id="GameLocationDetl" placeholder="지역상세를 입력해주세요" class="input-small" />
                    </td>
                  </tr>
                  <tr>
                    <th scope="row">시작일</th>
                    <td>
                      <div class="ymd-list">
                        <span id="sel_GameSYear"><select name="GameS_Year"></select></span>
                        <span id="sel_GameSMonth"><select name="GameS_Month"></select></span>
                        <span id="sel_GameSDay"><select name="GameS_Day"></select></span>
                      </div>
                    </td>
                    <th scope="row">종료일</th>
                    <td>
                      <div class="ymd-list">
                        <span id="sel_GameEYear"><select name="GameE_Year"></select></span>
                        <span id="sel_GameEMonth"><select name="GameE_Month"></select></span>
                        <span id="sel_GameEDay"><select name="GameE_Day"></select></span>
                    </td>
                    <th scope="row"><label for="competition-place">장소</label></th>
                    <td>
                      <input type="text" name="GameArea" id="GameArea" class="input-small" placeholder="경기장소를 입력해주세요." />
                      <!--<a href="#" class="btn-sch-pop">조회</a>-->
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <!-- S : btn-right-list 버튼 -->
            <div class="btn-right-list">
              <a href="#" id="btnsave" class="btn" onclick="input_frm();">등록</a>
              <a href="#" id="btnupdate" class="btn" onclick="update_frm();">수정</a>
              <a href="#" id="btndel" class="btn btn-delete" onclick="del_frm();">삭제</a>
              <!--<a href="#" class="btn">목록보기</a>-->
            </div>
            <!-- E : btn-right-list 버튼 -->
          </div>
          </form>
          <!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->
        </div>
      </div>
      <!-- E : top-navi -->
      <!-- S : sch 검색조건 선택 및 입력 -->
      <form name="search_frm" method="post">
      <div class="sch">
          <table class="sch-table">
            <caption>검색조건 선택 및 입력</caption>
            <colgroup>
              <col width="50px" />
              <col width="*" />
              <col width="50px" />
              <col width="*" />
              <col width="50px" />
              <col width="*" />
            </colgroup>
            <tbody>
              <tr>
                <th scope="row">연도</th>
                <td id="sel_Year2"><select name="Search_GameYear"></select></td>

                <th scope="row"><label for="competition-name-2">대회명</label></th>
                <td>
                  <input type="text" name="Search_GameTitleName" id="Search_GameTitleName" class="txt-bold"  />
                </td>
                <th scope="row">지역</th>
                <td>
                  <span id="sel_Location2"><select name="Search_Location"></select></span>
                  <input type="text" name="Search_LocationDetl" id="Search_LocationDetl" class="input-small" />
                </td>
              </tr>
            </tbody>
          </table>
      </div>
      <div class="btn-right-list">
        <a href="javascript:view_frm('F');" class="btn" id="btnview">검색</a>
      </div>
      </form>
      <!-- E : sch 검색조건 선택 및 입력 -->
      <!-- S : 리스트형 20개씩 노출 -->
      <div class="sch-result">
        <a href="javascript:view_frm('N');" class="btn-more-result">
          전체 (<strong id="totcnt">0</strong>)건 / <strong class="current" >현재(<span id="nowcnt">0</span>)</strong>
          <!--//<i class="fa fa-plus" aria-hidden="true"></i>-->          
        </a>
      </div>
      <div class="table-list-wrap">
        <!-- S : table-list -->
        <table class="table-list">
          <caption>대회정보관리 리스트</caption>
          <colgroup>
            <col width="44px" />
            <col width="*" />
            <col width="*" />
            <col width="*" />
            <col width="*" />
            <col width="*" />
            <col width="250px" />
          </colgroup>
          <thead>
            <tr>
              <th scope="col">번호</th>
              <th scope="col">년도</th>
              <th scope="col">기간(시작-종료)</th>
              <th scope="col">대회명</th>
              <th scope="col">지역</th>
              <th scope="col">장소</th>
              <th scope="col">체급관리</th>
            </tr>
          </thead>
          <input type="hidden" id="settp" value="" />        
          <input type="hidden" id="setkey" value="" />        
          <input type="hidden" id="setseq" value="" />        
          <tbody id="list">
                                
          </tbody>
        </table>
        <!-- E : table-list -->
        <a href="javascript:view_frm('N');" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
      </div>
      <!-- E : 리스트형 20개씩 노출 -->
    </div>
  </section>
  <!-- E : content -->
</div>
<!-- E : container -->
</body>
<script src="../js/js.js"></script>