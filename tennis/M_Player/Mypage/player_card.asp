<!-- #include file="../include/config.asp" -->
<%
  dim MemberIDX   : MemberIDX = decode(request.Cookies("MemberIDX"),0)
  dim UserName  : UserName  = request.Cookies("UserName")

  dim CSQL, CRs
  dim TeamNm

  'SET 기본이미지
  dim ImgASSDefault : ImgASSDefault = "http://img.sportsdiary.co.kr/sdapp/mypage/player-profile@3x.png"

  CSQL = "    SELECT T.TeamNm "
  CSQL = CSQL & "   ,M.PhotoPlayerID "
  CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblMember] M"
  CSQL = CSQL & "   inner join [Sportsdiary].[dbo].[tblTeamInfo] T on M.Team = T.Team "
  CSQL = CSQL & "     AND T.DelYN = 'N' "
  CSQL = CSQL & "     AND T.SportsGb = '"&SportsGb&"'"
  CSQL = CSQL & " WHERE M.DelYN = 'N' "
  CSQL = CSQL & "   AND M.SportsType = '"&SportsGb&"'"
  CSQL = CSQL & "   AND M.MemberIDX = '"&MemberIDX&"'"

' response.Write CSQL

  SET CRs = Dbcon.Execute(CSQL)
  IF Not(CRs.eof or CRs.bof) Then
    TeamNm = CRs("TeamNm")
    PhotoPlayerID = CRs("PhotoPlayerID")
  End IF
    CRs.Close
  SET CRs = Nothing


%>
<script language="javascript">
  var isMobile = {
    Android: function () {  return navigator.userAgent.match(/Android/i);},
    BlackBerry: function () { return navigator.userAgent.match(/BlackBerry/i);},
    iOS: function () {  return navigator.userAgent.match(/iPhone|iPad|iPod/i);  },
    Opera: function () { return navigator.userAgent.match(/Opera Mini/i); },
    Windows: function () {  return navigator.userAgent.match(/IEMobile/i);  },
    any: function () {  return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows()); }
  };

  //PC 선수증 이미지 업로드
    function Chk_Write(){
    var strAjaxUrl    = "../Ajax/player_card_imgOK.asp";
    var formData = new FormData();

    formData.append("MemberIDX", $("#MemberIDX").val());
    formData.append("b_upFile", $("input[name=b_upFile]")[0].files[0]);

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(retDATA) {

        var strcut = retDATA.split("|");

        if(strcut[0]=="TRUE"){

          $("#imgPlayerID").attr("src", strcut[1]);
          $("#imgDel").show().addClass('on'); //삭제버튼 활성화
          $(".pic-add").addClass('rbd0'); // 사진등록 버튼 border radius 조절
          $("#b_upFile").val("");     //input[file] 최기화
          alert("사진을 등록하였습니다");
        }
        else{
          switch(strcut[1]) {
            case 1:
              alert("이미지파일만 업로드 가능합니다");
              return;
            case 2:
              alert("첨부할 이미지파일을 선택하세요");
              return;
            case 3:
              alert("일치하는 정보가 없습니다");
              return;
            default:
          }
        }
      },
      error: function (xhr, status, error) {
                if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");
          return;
        }
            }
    });
  }

  //모바일 선수증 이미지 업로드
  function profile_appreceive(str){
    if (str.match("/FALSE_")){
      alert("사진등록에 실패하였습니다.");
      return;
    }
    else{
      $("#imgPlayerID").attr("src","../upload/../upload/" + str);

      alert("사진이 등록되었습니다.");
      $("#imgDel").show().addClass('on');     //삭제버튼 활성화
      $(".pic-add").addClass('rbd0'); // 사진등록 버튼 border radius 조절
    }
  }

  //등록된 이미지 삭제 후 기본이미지로 변경
  function Chk_Del_Image(){

    if(confirm("사진을 삭제하시겠습니까?")){

      var strAjaxUrl = "../Ajax/player_card_imgDEL.asp";

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: { },
        success: function(retDATA) {
          var strcut = retDATA.split("|");

          if(strcut[0]=="TRUE"){
            alert("사진을 삭제하였습니다.");

            $("#imgDel").hide().removeClass('on');     //삭제버튼 비활성화
            $(".pic-add").removeClass('rbd0'); // 사진등록 버튼 border radius 조절
            $("#imgPlayerID").attr("src", "<%=ImgASSDefault%>"); //기본이미지로 초기화

            return;
          }
          else{
            $("#imgDel").show().addClass('on'); // 삭제버튼 활성화
            $(".pic-add").addClass('rbd0'); // 사진등록 버튼 border radius 조절

            switch(strcut[1]) {
              case 1:
                alert("일치하는 정보가 없습니다.");
                return;
              case 2:
                alert("잘못된 접근입니다.");
                return;
              default:
            }
          }
        },
        error: function (xhr, status, error) {
          if(error!=""){
            alert ("오류발생! - 시스템관리자에게 문의하십시오!");
            return;
          }
        }
      });
    }
    else{
      return;
    }
  }

  //PC첨부파일 선택
  function fnUpload(){
    $('#b_upFile').click();
  }

  //다이얼로그에서 이미지 선택시 바로 Save
  $('#b_upFile').live('change', function(){
    Chk_Write();
  });

  $(document).ready(function(){
    var PhotoPlayerID = "<%=PhotoPlayerID%>";

    //선수증 이미지 없으면 기본이미지
    if(PhotoPlayerID == "") {
      $("#imgDel").hide().removeClass('on');
      $(".pic-add").removeClass('rbd0');
      $("#imgPlayerID").attr("src", "<%=ImgASSDefault%>");
    }
    //선수증 등록된 이미지 출력
    else{
      $("#imgDel").show().addClass('on');
      $(".pic-add").addClass('rbd0'); // 사진등록 버튼 border radius 조절
      $("#imgPlayerID").attr("src", PhotoPlayerID);
    }

    //첨부이미지 미리보기
    function readURL(input) {
      if (input.files && input.files[0]) {
        //파일을 읽기 위한 FileReader객체 생성
        var reader = new FileReader();

        reader.onload = function (e) {

          //파일 읽어들이기를 성공했을때 호출되는 이벤트 핸들러
          $('#imgPlayerID').attr('src', e.target.result);
          //이미지 Tag의 SRC속성에 읽어들인 File내용을 지정
          //(아래 코드에서 읽어들인 dataURL형식)
        }

        reader.readAsDataURL(input.files[0]);
        //File내용을 읽어 dataURL형식의 문자열로 저장
      }
    }

    //file 양식으로 이미지를 선택(값이 변경) 되었을때 처리하는 코드
    $("#b_upFile").change(function() {
      //alert(this.value); //선택한 이미지 경로 표시
      readURL(this);
    });


    //사진등록 버튼 컨트롤
    if(isMobile.iOS()){
      $("#btn_Profile_iOS").show();
      $("#btn_Profile_Android").hide();
      $("#btn_Profile_PC").hide();
    }
    else if(isMobile.Android()){
      $("#btn_Profile_iOS").hide();
      $("#btn_Profile_Android").show();
      $("#btn_Profile_PC").hide();
    }
    else{
      $("#btn_Profile_iOS").hide();
      $("#btn_Profile_Android").hide();
      $("#btn_Profile_PC").show();
    }

    });

</script>
<body class="lack-bg">
  <style>
    .tops {display: none;}
  </style>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>내 선수증 관리</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <input type="file" name="b_upFile" id="b_upFile" style="display: none;" />
  <input type="hidden" name="MemberIDX" id="MemberIDX" value="<%=MemberIDX%>" />
  <!-- S: sub -->
  <div class="sub player-card">
    <!-- S: ctrl-btn -->
    <div class="ctrl-btn flex">
      <a id="imgDel" href="javascript:Chk_Del_Image();" class="pic-del">
        <span class="ic-deco"><i class="fa fa-trash" aria-hidde="true"></i></span>
        <span>사진삭제</span>
      </a>
      <!--PC버전 사진올리기-->
      <a href="javascript:fnUpload();" id="btn_Profile_PC" class="pic-add">
        <span class="ic-deco"><i class="fa fa-camera" aria-hidde="true"></i></span>
        <span>사진등록</span>
      </a>
      <!--안드로이드 사진올리기-->
      <a href="javascript:Android.profileUpload('<%=MemberIDX%>');" id="btn_Profile_Android" class="pic-add">
        <span class="ic-deco"><i class="fa fa-camera" aria-hidde="true"></i></span>
        <span>사진등록</span>
      </a>
      <!--IOS 사진올리기-->
      <a href="interface://widline.co.kr/?action=profile&memcode=<%=MemberIDX%>" id="btn_Profile_iOS" class="pic-add">
        <span class="ic-deco"><i class="fa fa-camera" aria-hidde="true"></i></span>
        <span>사진등록</span>
      </a>
    </div>
    <!-- E: ctrl-btn -->
    <!-- S: card-box -->
    <div class="card-box">
      <span class="card">
        <img src="http://img.sportsdiary.co.kr/sdapp/mypage/player-card-img@3x.png" alt>
          <p class="player-profile">
          <span class="profile-box">
            <img id="imgPlayerID" alt>
          </span>
        </p>
      </span>
      <!-- <p class="card-year">2017</p> -->
      <p class="card-tit">선수증</p>
      <p class="player-name"><%=UserName%></p>
      <p class="player-belong"><%=TeamNm%></p>
    </div>
    <!-- E: card-box -->
  </div>
  <!-- E: sub -->

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file="../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
