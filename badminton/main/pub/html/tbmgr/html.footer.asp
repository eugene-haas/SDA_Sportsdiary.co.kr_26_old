



<!-- S: modal fade alert_modal -->
<div class="modal hide fade in warn_modal" data-backdrop="false">
  <!-- S: modal-dialog -->
  <div class="modal-dialog modal-sm">
    <!-- S: modal-content -->
    <div class="modal-content">
      <!-- S: modal-body -->
      <div class="modal-body">
        <p><span class="ic-deco"><i class="fa fa-exclamation-circle"></i></span><span  id="w_msg">1초후 폭발 합니다.</span></p>
      </div>
      <!-- E: modal-body -->
    </div>
    <!-- E: modal-content -->
  </div>
  <!-- E: modal-dialog -->
</div>
<!-- E: modal fade alert_modal -->
<iframe name="hiddenFrame" style="display:none"></iframe>
<%
	Call db.Dispose
	Set db = Nothing
%>