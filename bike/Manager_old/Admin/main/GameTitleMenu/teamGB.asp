<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->



<style>
.left-box {
  float: left;
  width: 40%;
 
}

.right-box {
  float: right;
  width: 56%;
}
</style>

<script type="text/javascript" src="../../js/GameTitleMenu/level.js"></script>

<section class="list_conten_box">

  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-body" id="myModelContent">
          <p>데이터가 없습니다.</p>
        </div>
        <!--<div class="modal-footer">
        </div>-->
      </div>
    </div>
  </div>

   <!-- Modal -->
  <div class="modal fade" id="levelDtlModal" role="dialog" style="z-index:1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-body" style="z-index:10;" >
          <div id="mylevelDtlModalContent">
            <p>데이터가 없습니다.</p>
          </div>
        </div>
        <!--<div class="modal-footer">
        </div>-->
      </div>
    </div>
  </div>



	<div id="content">
		<!-- S : 내용 시작 -->
		<div class="contents">
			<!-- S: 네비게이션 -->
			<div	class="navigation_box">
				대회관리 > 종목관리
			</div>
      TeamGb영역
    </div>
  </div>
</section>
<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>