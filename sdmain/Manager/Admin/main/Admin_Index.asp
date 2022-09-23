
<!--#include file="../dev/dist/config.asp"-->

<!-- S: head -->
<!-- #include file="../include/head.asp" -->
<!-- E: head -->

<div class="content">
  <!-- S: left-gnb -->
  <!-- #include file="../include/left-gnb.asp" -->
  <!-- E: left-gnb -->


  <!-- S: right-content -->
  <div class="right-content">
    <!-- S: navigation -->
    <div class="navigation">
      <i class="fas fa-home"></i>
      <i class="fas fa-chevron-right"></i>
      <span>SD 통합 어드민</span>
      <!--<i class="fas fa-chevron-right"></i>
      <span>어드민관리</span>-->
    </div>
    <!-- E: navigation -->

    <div>
      <div>첫 시작 페이지<div>
    </div>
    
  </div>
  <!-- E: right-content -->




</div>

<script type="text/javascript">

  $("#txtSearch").val(txtSearchValue);
  $("#selSearch").val(selSearchValue);

</script>

<!-- S: 환불모달 -->
<!-- #include file="../include/modal/refund_modal.asp" -->
<!-- E: 환불모달 -->
<!-- S: footer -->
<!-- #include file="../include/footer.asp" -->
<!-- E: footer -->
<% ADADMIN_DBClose() %>