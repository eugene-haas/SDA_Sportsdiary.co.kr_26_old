<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Set db = new clsDBHelper
p = request("p")
titleIdx = Split(decode(p, 0), "=")(1)

SQL = " SELECT Summary FROM tblBikeTitle WHERE TitleIdx = '"& titleIdx &"' "
Set rs = db.ExecSQLReturnRs(SQL, Null, B_ConStr)
If Not rs.eof Then
  summary = rs(0)
Else
  Response.end
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../tsm_player/include/head.asp" -->

  <style>
    body{font-family:'NotoKR', sans-serif;}
    .competitionInfo .applyBtn{position:fixed;bottom:0;width:100%;max-width:54.79rem;border:none;height:2.86rem;font-size:1.14rem;letter-spacing:0.05em;line-height:2.86rem;color:#fff;background-color:#264862;text-align:center;z-index:100;}
    .competitionInfo .imgWrap img{width:100%;}

  </style>
</head>
<body>
<div id="app" class="l competitionInfo">

  <div class="l_header">
    <div class="m_header s_sub">
      <h1 class="m_header__tit">대회요강</h1>
    </div>
  </div>
  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="imgWrap">


      <img src="<%=summary%>" />


    </div>

  </div>
  <a class="applyBtn" onclick="startApp()" >참가신청</a>
</div>
  <script>
    var vm = new Vue({})
  </script>
  <script>
    var mobilecheck = function() {
      var check = false;
      (function(a){
        if(
          /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))
        ) check = true;

      })(navigator.userAgent||navigator.vendor||window.opera);

      return check;
    };

    // eventtype, eventcode 변경해주세요.
    var _APP_SCHEME = "sdapp://appopen?eventtype=A&eventcode=BK000002&eventetc=#";
    var _APP_SCHEME_INTENT = "Intent://appopen?eventtype=A&eventcode=BK000001&eventetc=#Intent;scheme=sdapp;package=com.sportsdiary.player.sportsdiaryplayer;end";
    var _APP_INSTALL_URL_IOS = "https://itunes.apple.com/kr/app/%EC%8A%A4%ED%8F%AC%EC%B8%A0%EB%8B%A4%EC%9D%B4%EC%96%B4%EB%A6%AC/id1218138494?mt=8";
    var _APP_INSTALL_URL_ANDROID = "market://details?id=com.sportsdiary.player.sportsdiaryplayer";

    var isIPHONE = (navigator.userAgent.match('iPhone') != null || navigator.userAgent.match('iPod') != null);
    var isIPAD = (navigator.userAgent.match('iPad') != null);
    var isANDROID = (navigator.userAgent.match('Android') != null);

    function startApp(){
      if(!mobilecheck()) alert('핸드폰에서 진행가능합니다.')

      var clickedAt = +new Date;
      if(isANDROID){
        if(navigator.userAgent.match(/Chrome/)){
          if(confirm('스포츠다이어리 앱 실행 또는 설치 페이지로 이동')) location.href = _APP_SCHEME_INTENT;
        }
        else{
          setTimeout(function(){
            if(+new Date - clickedAt < 2000){
              if(confirm('설치 페이지로 이동')) $iframe.attr('src', _APP_INSTALL_URL_ANDROID);
            }
          }, 1500);

          var iframe = document.createElement('iframe');
          iframe.style.visibility = 'hidden';
          iframe.src = _APP_SCHEME;
          document.body.appendChild(iframe);
          document.body.removeChild(iframe);
        }
      }
      else if(isIPHONE){
        setTimeout(function(){
          if(+ new Date() - clickedAt < 2000){
            location.href = _APP_INSTALL_URL_IOS;
            // $iframe.attr('src', _APP_INSTALL_URL_IOS);
          }
        }, 1500);

        location.href = _APP_SCHEME

      }
    }
  </script>
</body>
</html>
