<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c2d63644c815d3f9c28da9ab8c347311&libraries=services"></script>
<script type="text/javascript">
    //단체정보조회
  function view_match(CODE){
    var strAjaxUrl="../ajax/stadium_fnd.asp";
    var AreaGb   = $("#AreaGb").val();  
    var AreaGbDt   = $("#AreaGbDt").val();  
    var fnd_KeyWord   = $("#fnd_KeyWord").val();  
    var fnd_KeyType   = $("#fnd_KeyType").val();  
    
    if(fnd_KeyType && !fnd_KeyWord) {
      alert("검색어를 입력해주세요"); 
      $('#fnd_KeyWord').focus();
      return;
    }
    
    //초기화     
    $("#info_TxtGym").html("");  
    $("#addr_list").html("");
    $("#map").html(""); 
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        AreaGb        : AreaGb  
        ,AreaGbDt     : AreaGbDt
        ,fnd_KeyWord    : fnd_KeyWord
        ,fnd_KeyType  : fnd_KeyType
      },
      success: function(retDATA) {
        
        //console.log(retDATA);
        
        if(retDATA){
          
          var strcut = retDATA.split("|");

          if(strcut[0]=="TRUE"){
            $("#addr_list").html(strcut[1]);  
            $("#info_TxtGym").html("검색결과 총 <span>"+strcut[3]+"개</span> 유도장이 있습니다.");  
            
            //조회데이터 중 첫번째 주소를 지도영역에 출력
            view_InfoMap(strcut[2],1);
            
          }
          else{
            $("#fnd_KeyWord").val("");
            $("#info_TxtGym").html("일치하는 유도장이 없습니다.");  
            $("#addr_list").html("");
            $("#map").html("");
          }
          
        }
        else{
          alert ("잘못된 접근입니다.");
          return;
        }
        stadiumMapBtn();
      }, 
      error: function(xhr, status, error){
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");
          return;
        }
      }
    });     
  }
    
  //다음지도 영역
  function view_InfoMap(addr, val){
    
    console.log(addr);
    
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    
    mapOption = {
      center: new daum.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
      level: 3, // 지도의 확대 레벨
    };  
    
    // 지도를 생성합니다    
    var map = new daum.maps.Map(mapContainer, mapOption); 

    //console.log(map);
    
    // 주소-좌표 변환 객체를 생성합니다
    var geocoder = new daum.maps.services.Geocoder();
    
    
    
    geocoder.addressSearch(addr, function(result, status) {
      
    //  console.log(result);
      
      // 정상적으로 검색이 완료됐으면 
      if (status === daum.maps.services.Status.OK) {
        
        
        var coords = new daum.maps.LatLng(result[0].y, result[0].x);
        
        // 결과값으로 받은 위치를 마커로 표시합니다
        var marker = new daum.maps.Marker({
          map: map,
          position: coords
        });
    
        // 인포윈도우로 장소에 대한 설명을 표시합니다
        var infowindow = new daum.maps.InfoWindow({
          content: '<div style="width:100%; line-height:30px;  font-size: 13px; text-align:center; padding:3px;" class="abc">'+addr+'</div>'
        });
        infowindow.open(map, marker);
    
        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
        map.setCenter(coords);
      } 
    });               
  }
  
  
    //상세지역 조회 셀렉박스 생성
    function chk_AreaGbDt(){
      fnd_SelectArea('AreaGbDt', $('#AreaGb').val(),'AreaGbDt');     
    }
  
  //SELECT BOX Option 리스트 조회      
  function fnd_SelectArea(attname, code, action_type) {
    var strAjaxUrl;
    
    if(action_type == "AreaGb") { strAjaxUrl = "../ajax/Select_Stadium_AreaGb.asp"; }
    else if(action_type == "AreaGbDt") {strAjaxUrl = "../ajax/Select_Stadium_AreaGbDt.asp"; }
    else{}
    
    $.ajax({
      url: strAjaxUrl,
      type: "POST",
      dataType: "html",
      data: {     
        code  : code 
      },
      success: function(retDATA) {
        
        //console.log(retDATA);
        
        $('#'+attname).empty().append();
        $('#'+attname).append(retDATA);
      }, 
      error: function(xhr, status, error){
        if(error != ""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");
          return;
        }
      }
    });      
  }
  
    //select box option list
  //element,attname,code,action_type
  $(document).ready(function() {   
    //SELECT BOX Option              
    fnd_SelectArea('AreaGb','','AreaGb');     //지역
    view_match(''); //유도장정보 조회
  });
</script>
<section>
<div id="content">
  <!-- S: 네비게이션 -->
  <div  class="navigation_box"> 팀/선수정보 > 유도장정보 </div>
  <!-- E: 네비게이션 -->
  <!-- S: search_top community -->
  <div class="search_top community">
    <div class="search_box">
      <table class="sch-table">
        <tbody>
          <tr>
            <th scope="row">가입일</th>
            <td><input type="date" name="SDate" id="SDate" maxlength="10" value="" placeholder="2017-07-01">
              -
              <input type="date" name="EDate" id="EDate" maxlength="10" value="" placeholder="2017-07-01"></td>
            
            <th scope="row">인증방법</th>
            <td><select name="fnd_AuthType" id="fnd_AuthType">
              <option value="">=====전체=====</option>
                <option value="MOBILE">휴대폰 안심 본인인증</option>
                <option value="IPIN">아이핀(I-PIN) 인증</option>
                </select>
            </td>
            <th scope="row">회원구분</th>
            <td>
              <input type="checkbox" name="TypeRole" id="TypeRoleP" value="P">
                <label for="TypeRoleP" class="check_txet">엘리트선수</label>
                <input type="checkbox" name="TypeRole" id="TypeRoleL" value="L">
                <label for="TypeRoleL" class="check_txet">지도자(감독)</label>
                <input type="checkbox" name="TypeRole" id="TypeRoleD" value="D">
                <label for="TypeRoleD" class="check_txet">관장</label>
                <input type="checkbox" name="TypeRole" id="TypeRoleJ" value="J">
                <label for="TypeRoleJ" class="check_txet">심판</label>
                <input type="checkbox" name="TypeRole" id="TypeRoleU" value="U">
                <label for="TypeRoleU" class="check_txet">일반</label>
            </td>                
          </tr>
          <tr>
            <th>키워드</th>
            <td colspan="3"><input type="text" name="fnd_KeyWord" id="fnd_KeyWord" value="">
            <div id="div_InfoKeyWord">키워드 검색 [소속팀명, 회원명, 생년월일, 체육인번호, 아이디, 전화번호, 이메일]</div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="btn-right-list">
      <a href="javascript:chk_Submit();" class="btn" accesskey="s">검색(S)</a>
    </div>
  </div>
  <!-- E: search_top community -->

  <div id="board-contents" class="table-list-wrap">
    <div>
      <span>전체 : 9,</span>&nbsp;&nbsp;&nbsp;<span>1 page / 1 pages</span>
    </div>
    <table class="table-list">
      <thead>
        <tr>
          <th>번호</th>
          <th>이름</th>
          <th>아이디</th>
          <th>생년월일</th>
          <th>회원구분</th>
          <th>체육인번호</th>
          <th>팀코드</th>
          <th>Phone</th>
          <th>SMS수신</th>
          <th>이메일</th>
          <th>이메일수신</th>
          <th>인증방법</th>
          <th>인증YN</th>
          <th>가입일</th>
        </tr>
      </thead>
      <tbody>
        <tr onclick="chk_Submit('VIEW','17','1');">
          <td>9</td>
          <td>김민희</td>
          <td>jamie5840</td>
          <td>1983.12.09</td>
          <td>· 관장&nbsp;· 심판&nbsp;· 일반&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-4729-7112</td>
          <td>N</td>
          <td>normaljamie@naver.com</td>
          <td>N</td>
          <td>휴대폰 안심 본인인증</td>
          <td>Y</td>
          <td>2017-09-22 오후 6:38:37</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','16','1');">
          <td>8</td>
          <td>송근호</td>
          <td>hanei0415</td>
          <td>1990.04.15</td>
          <td>· 관장&nbsp;· 일반&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-4271-8120</td>
          <td>Y</td>
          <td>hanei0415@gmail.com</td>
          <td>Y</td>
          <td>휴대폰 안심 본인인증</td>
          <td>Y</td>
          <td>2017-09-22 오후 4:17:06</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','14','1');">
          <td>7</td>
          <td>헐크</td>
          <td>a21991662</td>
          <td>1988.04.01</td>
          <td>· 일반&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-1111-1111</td>
          <td>N</td>
          <td>11111@gmail.com</td>
          <td>N</td>
          <td></td>
          <td></td>
          <td>2017-08-21 오후 2:16:04</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','13','1');">
          <td>6</td>
          <td>토르</td>
          <td>a21991662</td>
          <td>1988.04.01</td>
          <td>· 일반&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-1111-1111</td>
          <td>N</td>
          <td>11111@gmail.com</td>  
          <td>N</td>  
          <td></td>
          <td></td>
          <td>2017-08-21 오후 2:16:04</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','12','1');">
          <td>5</td>  
          <td>엑스맨</td>  
          <td>test123</td>  
          <td>1989.04.28</td> <td>· 일반&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-4420-3320</td>  
          <td>Y</td>  
          <td>uda0@daum.net</td>  
          <td>N</td>  
          <td></td>
          <td></td>
          <td>2017-08-21 오전 9:28:44</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','8','1');"> <td>4</td>  
          <td>슈퍼맨</td>  
          <td>eeeeee</td>
          <td>1999.01.01</td>
          <td>· 관장&nbsp;· 일반&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-7290-7647</td>  
          <td>N</td>  
          <td>test@hanmail.net</td>
          <td>Y</td>  
          <td>휴대폰 안심 본인인증</td>  
          <td>Y</td>  
          <td>2017-08-10 오후 3:55:10</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','15','1');">
          <td>3</td>  
          <td>아이언맨</td>
          <td>aaaaaa</td>
          <td>1999.01.01</td>
          <td>· 관장&nbsp;· 일반&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-7290-7647</td>  
          <td>N</td>  
          <td>test@hanmail.net</td>
          <td>Y</td>  
          <td>휴대폰 안심 본인인증</td>  
          <td>Y</td>  
          <td>2017-08-10 오후 3:55:10</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','9','1');"> <td>2</td>  
          <td>앤트맨</td>  
          <td>ffffff</td>
          <td>1999.01.01</td>
          <td>· 선수&nbsp;· 관장&nbsp;· 심판&nbsp;</td>
          <td>201602000468</td>
          <td>JU90680</td>  
          <td>010-7290-7647</td>  
          <td>N</td>  
          <td>test@hanmail.net</td>
          <td>Y</td>  
          <td>아이핀(I-PIN) 인증</td>  
          <td>Y</td>  
          <td>2017-08-10 오후 3:55:10</td>
        </tr>
        <tr onclick="chk_Submit('VIEW','7','1');"> <td>1</td>  
          <td>임승현</td>  
          <td>dddddd</td>
          <td>1974.10.30</td>
          <td>· 관장&nbsp;· 심판&nbsp;</td>
          <td></td>
          <td></td>
          <td>010-7290-7647</td>  
          <td>N</td>  
          <td>test@hanmail.net</td>
          <td>Y</td>  
          <td>아이핀(I-PIN) 인증</td>  
          <td>Y</td>  
          <td>2017-08-10 오후 3:55:10</td>
        </tr>
      </tbody>
    </table>

    <ul class="pagination">
      <li class="prev">
        <a href="javascript:;" class="fa fa-angle-left"></a>
      </li>
      <li class="active">
        <a href="#">1</a>
      </li>
      <li class="next">
        <a href="javascript:;" class="fa fa-angle-right"></a>
      </li>
    </ul>
  </div>

</div>
<section>
<!--#include file="footer.asp"-->
