<%
'#########################
'결제 완료자라면 환불정보를 받기
'#########################

	If hasown(oJSONoutput, "RIDX") = "ok" then
		ridx = oJSONoutput.RIDX 'tblgamerequest
	End if 

	If hasown(oJSONoutput, "MIDX") = "ok" then
		midx = oJSONoutput.MIDX 'sd_tennisMember
	End if 

'    Set db = new clsDBHelper
'	db.Dispose
'    Set db = Nothing
%>
<input type="hidden" id="req_idx" value="<%=ridx%>">
<input type="hidden" id="m_idx" value="<%=midx%>">


  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'>환불정보 입력</h3>
  </div>

	  <div class="modal-body" id="Modaltestbody">
			<table class="sch-table">
				<tbody>
				  <tr>
			  <colgroup>
				<col width="*">
			  </colgroup>              
				<td id = "player1">
						<li>
                        <div class="text_box">
                            <p class="red_font"><i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                                <span>환불 계좌 정보를 입력해 주십시오. <br><br></span>
                            </p> 
                        </div>
                        </li> 

						<li>
                            <span class="l_name">취소이름</span>
                            <span class="r_con">
                                <input type="text" class="ipt input_1" style="width:80%;" id="inbankname" name="inbankname" value=""  onkeyup="fnkeyup(this);" maxlength="10"   placeholder=":: 계좌소유주 ::"  autocomplete="off">
                            </span>
						</li>
						<li>
                            <span class="l_name">환불은행</span>
                            <span class="r_con">
                                <input type="text" class="ipt input_1" style="width:80%;" id="inbank" name="inbank" value=""  onkeyup="fnkeyup(this);"   placeholder=":: 은행명 ::"  maxlength="8" autocomplete="off">
                            </span>
						</li>
						<li>
							<span class="l_name">환불계좌</span>
							<span class="r_con">
                                <input type="text" class="ipt input_1" style="width:80%;" id="inbankacc" name="inbankacc" value=""  onkeyup="fnkeyup(this);"   placeholder=":: 계좌 숫자만::" maxlength="20"  autocomplete="off">
                            </span>
                        </li>
				</td>
				</tbody>
			  </table>
	  </div>

	  <div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true" onclick="mx.chek_form_pass_data()">저장</button>
	  </div>





