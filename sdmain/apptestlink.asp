<!doctype html>
<%
  dim UserID : UserID = request.Cookies("SD")("UserID")
  If UserID = "csg3268" OR UserID = "jaehongtest" OR UserID = "mujerk" Or UserID = "sjh123" Or UserID = "song0123" Or UserID = "player11" Or InStr(UserID, "sdtest") > 0 Then
%>
<meta charset="utf-8" />
<style>
ul{font-size:16px;}
li{margin-bottom:10px;}
label{width:30%;}
a{width:70%;}
</style>
<ul>
  <li>
    <label>badminton gamevideo</label>
    <a href="http://badminton.sportsdiary.co.kr/badminton/tsm_player/Page/gamevideo.asp"  class="btn-right" >이동</a>
  </li>

  <li>
    <label>iphone pdf </label>
    <a href="http://riding.sportsdiary.co.kr/m_player/Result/contest_info_dev.asp?tidx=40"  class="btn-right" >이동</a>
  </li>

  <li>
    <label>자전거 tsm</label>
    <a href="http://bike.sportsdiary.co.kr/bike/Tsm_player/request/applicant.asp"  class="btn-right" >이동</a>
  </li>

  <li>
    <label>vue test</label>
    <a href="http://bike.sportsdiary.co.kr/bike/Tsm_player/main/test.asp"  class="btn-right" >이동</a>
  </li>

  <li>
    <label>스다몰 데일리 이벤트</label>
    <a href="http://sdmain.sportsdiary.co.kr/sdmain/event/daily.asp"  class="btn-right" >이동</a>
  </li>
  <li>
    <label >앱 알림 수신 설정</label>
    <a href="./pushSetting_dev.asp"  class="btn-right" >이동</a>
  </li>
  <li>
    <label >종목선택</label>
    <a href="./interested_category.asp"  class="btn-right" >이동</a>
  </li>
  <!-- <li>
    <label >front-test 승마</label>
    <a href="http://riding.sportsdiary.co.kr/M_Player/Main/index.asp"  class="btn-right" >이동</a>
  </li> -->
  <li>
    <label >front-test 유도</label>
    <a href="http://judo.sportsdiary.co.kr/TSM_Player/Main/index.asp"  class="btn-right" >이동</a>
  </li>
  <li>
    <label >front-test 테니스</label>
    <a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/main/index.asp"  class="btn-right" >이동</a>
  </li>
  <li>
    <label >front-test 배드민턴</label>
    <a href="http://badminton.sportsdiary.co.kr/badminton/TSM_player/page/institute-schedule.asp"  class="btn-right" >이동</a>
  </li>
  <li>
    <label >수영 앱 참가신청</label>
    <a href="http://sw.sportsdiary.co.kr/list.asp?ver=12" class="btn-right">바로가기</a>
  </li>
  <li>
    <label >테니스 앱 참가신청</label>
    <a href="http://rt.sportsdiary.co.kr/tnrequest/list.asp?ver=12" class="btn-right">바로가기</a>
  </li>
  <li>
    <label >춘천</label>
    <a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/AD/chuncheon.asp?path=1" class="btn-right">바로가기</a>
  </li>
  <li>
    <label >송도 이벤트</label>
    <a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/Ad/songdo.asp" class="btn-right">바로가기</a>
  </li>
  <li>
    <label >index_test</label>
    <a href="http://sdmain.sportsdiary.co.kr/sdmain/index_test.asp" class="btn-right">바로가기</a>
  </li>
  <li>
    <label >ios&안드 새창(소스볼것)
      <!--
        <a onclick="alert('sportsdiary://urlblank=http://sportsdiary.co.kr/')" class="btn-right" target="_blank">ios새창</a>
      -->
      <a href="http://sportsdiary.co.kr/" onclick="alert('sportsdiary://urlblank=http://sportsdiary.co.kr/')" class="btn-right" target="_blank">ios&안드 새창</a>
    </li>
    <li>
      <label >작동없음</label>
      <a onclick="alert('sportsdiary://')" class="btn-right" target="_blank">작동없음</a>
    </li>
    <li>
      <label >riding main</label>
      <a href="http://riding.sportsdiary.co.kr/m_player/main/index.asp" class="btn-right">바로가기</a>
    </li>
</ul>

<%
  Else
    Response.Redirect "./index.asp"
  End If
%>
