<!--#include file="./include/config.asp"-->
<!--#include file="./include/head.asp"-->
<%
	Dim AppType : AppType = Request("AppType")
	Dim eventtype : eventtype = Request("eventtype")
	Dim eventcode : eventcode = Request("eventcode")
	Dim eventetc : eventetc = Request("eventetc")

	Response.Cookies("a") = "a"
	Response.Cookies("a").domain = ".sportsdiary.co.kr"
	Response.cookies("a").expires = Date() + 365


'	If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" Then
'		Response.write "여기"
'		Response.end
'	End if



	'If eventtype = "1111" And eventcode = "2222" AND eventetc = "3333" Then
	'	Response.Redirect("http://sdmain.sportsdiary.co.kr/sdmain/apptest.asp?AppType=" & AppType & "&eventtype=" & eventtype & "&eventcode=" & eventcode & "&eventetc=" & eventetc)
	'End If

	CSQL = 	"	SELECT eventUrl, PopupYN"
	CSQL = CSQL & "	FROM tblAppEvent"
	CSQL = CSQL & "	WHERE DelYN = 'N'"
	CSQL = CSQL & "	AND ISNULL(eventtype,'') = '" & eventtype & "'"
	CSQL = CSQL & "	AND ISNULL(eventcode,'') = '" & eventcode & "'"
	CSQL = CSQL & "	AND ISNULL(eventetc,'') = '" & eventetc & "'"

	SET CRs = DBcon3.Execute(CSQL)
	IF Not(CRs.Eof Or CRs.Bof) Then
		eventUrl = CRs("eventUrl")
		PopupYN = CRs("PopupYN")
	Else
		eventUrl = ""
		PopupYN = ""
	End If

	If eventUrl <> "" Then
		'Response.Redirect(eventUrl)
		Response.Write "<script>"
		Response.Write "location.href='" & eventUrl & "';"
		Response.Write "</script>"
		Response.End

	End If

	If AppType <> "android" Then
		Response.Redirect("http://sdmain.sportsdiary.co.kr/sdmain/index.asp?AppType=" & AppType)
	End If
%>
<head>
  <script src="js/library/jquery-3.1.1.min.js"></script>
	<script type="text/javascript">

		var IsFirstAccYN = "";
		function beginInstall(str){
      //alert("beginInstall(str)호출완료. 파라메터value:" + str);
      if (str == "Y") {
        //$('#DP_AuthPopup').addClass('_s_on');
        $('#DP_AuthPopup').attr('style', "display:block;");
      }
      else {
        location.href = "http://sdmain.sportsdiary.co.kr/sdmain/index.asp?AppType=<%=Request("AppType")%>"
      }
			//else{ alert("beginInstall(Y/N) <- javascript 파라메터 없음"); }
		}
		$(document).ready(function(){
			//location.href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp?AppType=<%=Request("AppType")%>&IsFirstAccYN=" + IsFirstAccYN;
		});
	</script>
	<style>
		.layer_popup{position:relative;width:100vw;height:100vh;left:0;}

		.backdrop{position:absolute;top:0;background-color:rgba(0,0,0,0.4);}
		.backdrop{width:100%;height:100%;}

		.content_box{position:absolute;width:260px;height:300px;margin:auto;line-height:100%;left:0;right:0;top:0;bottom:0;margin:auto;}

		.title_wrap{height:45px;background-color:#535353;text-align:center;}
		.title_wrap>.title{padding:14px 0;font-size:16px;font-weight:500;color:#fff;}

		.content_wrap{background-color:#fff;padding:10px 0 0 0;}
		.content_wrap>.title{font-size:15px;color:#535353;margin:0 15px 5px 15px;}
		.content_wrap>.content_use{padding-left:50px;margin:10px 15px;}
		.content_wrap>.content_use.camera{background: url('http://img.sportsdiary.co.kr/sdapp/etc/ic-photo-camera.png') no-repeat left 1.5px center/34px;}
		.content_wrap>.content_use.storage{background: url('http://img.sportsdiary.co.kr/sdapp/etc/ic-sd-card.png') no-repeat left center/37px;}
		.content_wrap>.content_use>.sub_title{font-size:15px;}
		.content_wrap>.content_use>.content{font-size:10px;}
		.content_wrap>.info{font-size:10px;color:#939090;text-align:center;margin:8px 15px;}
		.content_wrap>.content_setting{font-size:10px;color:#b1b1b1;margin:0 15px;}
		.confirm_wrap{border-top:1px solid #ddd;height:35px;text-align:center;color:#b1b1b1;margin-top:7px;font-size:0;}
		.confirm_wrap>.btn_next{display:inline-block;width:50%;height:100%;padding-top:8px;color:#535353;border-top:1px solid #535353;border-left:1px solid #535353;border-bottom:1px solid #535353;line-height:100%;font-size:16px;vertical-align:top;}
		.confirm_wrap>.btn_confirm{display:inline-block;width:50%;height:100%;padding-top:7px;color:#fff;border:1px solid #535353;line-height:100%;background-color:#535353;font-size:16px;vertical-align:top;}
	</style>
</head>
<body>
	<div class="layer_popup" id="DP_AuthPopup" style="display:none;">
    <div class="backdrop"></div>
    <div class="content_box">
      <div class="title_wrap">
        <h1 class="title">스포츠다이어리 앱 사용 접근 권한</h1>
      </div>
      <div class="content_wrap">
        <h2 class="title">선택적 접근 권한</h2>
        <div class="content_use camera">
          <h3 class="sub_title">카메라</h3>
          <p class="content">
            개인 프로필 사진 촬영에 이용
          </p>
        </div>

        <div class="content_use storage">
          <h3 class="sub_title">저장공간</h3>
          <p class="content">
            현장스케치 다운로드, 파일 업로드<br />(프로필사진)대회 참가 확인서에 이용
          </p>
        </div>

        <p class="info">
          '선택접근권한'은 해당 기능을 사용할 때 허용이 필요하며,
          비호용시에도 해당 기능 외 서비스 이용이 가능합니다.
        </p>

        <h2 class="title">접근 권한 변경 방법</h2>
        <p class="content_setting">
          휴대폰 설정>앱 또는 어플리케이션 관리
        </p>

        <div class="confirm_wrap">
					<a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="btn_next">다음에 하기</a>
					<a class="btn_confirm [ _overLayer__close ]" onclick="alert('sportsdiary://AccAuthPopupYN=Y'); location.href='http://sdmain.sportsdiary.co.kr/sdmain/index.asp';">확인</a>
				</div>
      </div>
    </div>
  </div>
</body>
