<%
Dim currentUrl
currentUrl = Request.ServerVariables("URL")
' response.write currentUrl
%>

<aside>
  <nav class="nav" role="navigation">
    <div id="accordion">
      <div class="card">
        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#group-1" aria-expanded="false" aria-controls="group-1">
          관리자<span class="glyphicon glyphicon-menu-right"></span>
        </button>
        <div id="group-1" class="collapse" data-parent="#accordion">
          <div class="card-body">
            <a href="">어드민 메뉴관리</a>
            <a href="">어드민계정관리</a>
            <a href="">DB주석관리</a>
          </div>
        </div>
      </div>

      <div class="card">
        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#group-2" aria-expanded="false" aria-controls="group-2">
          대회관리<span class="glyphicon glyphicon-menu-right"></span>
        </button>
        <div id="group-2" class="collapse" data-parent="#accordion">
          <div class="card-body">
            <a href="/contest/info.asp">대회정보</a>
          </div>
          <div class="card-body">
            <a href="/contest/player/info.asp">선수관리</a>
          </div>
        </div>
      </div>

      <div class="card">
        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#group-3" aria-expanded="false" aria-controls="group-3">
          대회신청관리<span class="glyphicon glyphicon-menu-right"></span>
        </button>
        <div id="group-3" class="collapse" data-parent="#accordion">
          <div class="card-body">
            <a href="/apply/info.asp">전체내역</a>
          </div>
          <div class="card-body">
            <a href="/apply/member/info.asp">참가선수정보</a>
          </div>
          <div class="card-body">
            <a href="/apply/pay/info.asp">결제신청정보</a>
          </div>
          <div class="card-body">
            <a href="/apply/refund/info.asp">환불요청정보</a>
          </div>
          <div class="card-body">
            <a href="/apply/parent/info.asp">부모동의</a>
          </div>
        </div>
      </div>

      <div class="card">
        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#group-4" aria-expanded="false" aria-controls="group-3">
          버스이용<span class="glyphicon glyphicon-menu-right"></span>
        </button>
        <div id="group-4" class="collapse" data-parent="#accordion">
          <div class="card-body">
            <a href="/bus/info.asp">버스관리</a>
          </div>
          <div class="card-body">
            <a href="/bus/apply/info.asp">버스신청내역</a>
          </div>
          <div class="card-body">
            <a href="/bus/cancel/info.asp">버스신청취소</a>
          </div>
        </div>
      </div>


      <div class="card">
        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#group-5" aria-expanded="false" aria-controls="group-4">
          게시물관리
          <span class="glyphicon glyphicon-menu-right"></span>
        </button>
        <div id="group-5" class="collapse" data-parent="#accordion">
          <div class="card-body">
            <a href="/board/video/info.asp" target="_self">대회영상</a>
          </div>
          <div class="card-body">
            <a href="/board/image/info.asp" target="_self">대회이미지</a>
          </div>
        </div>
      </div>


      <div class="card">
        <button class="btn btn-link collapsed" data-toggle="collapse" data-target="#group-6" aria-expanded="false" aria-controls="group-5">
          통계관리
          <span class="glyphicon glyphicon-menu-right"></span>
        </button>
        <div id="group-6" class="collapse" data-parent="#accordion">
          <div class="card-body">
            <a href="">일별통홥회원가입자</a>
          </div>
          <div class="card-body">
            <a href="">일별자전거계정가입자</a>
          </div>
        </div>
      </div>

    </div>
  </nav>
</aside>
