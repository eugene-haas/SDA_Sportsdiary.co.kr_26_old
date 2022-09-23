<%
'request
	If hasown(oJSONoutput, "OIDX") = "ok" then
		oidx = oJSONoutput.Get("OIDX")
	End if	



	Set db = new clsDBHelper
	

	'********************************
	'결제정보
	'********************************	
	  SQL_Order_rs = "Select  "
	  SQL_Order_rs = SQL_Order_rs & "  OrderIDX " '텓이블의 id값
	  SQL_Order_rs = SQL_Order_rs & " ,OR_NUM " '주문번호
	  SQL_Order_rs = SQL_Order_rs & " ,case when OorderPayType = 'Card' then '카드결제' "
	  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'DirectBank' then '실시간계좌이체' "
	  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'Vbank' then '가상계좌' "
	  SQL_Order_rs = SQL_Order_rs & "		when OorderPayType = 'HPP' then '휴대폰결제' end as pay_type " '결제종류
	  SQL_Order_rs = SQL_Order_rs & "		,OorderPayType " '결제종류


	  SQL_Order_rs = SQL_Order_rs & " ,case when OorderState ='00' then '입금대기'  " ' 결제상태 미입금
	  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='01' then '결제완료' " ' 결제상태 입금
	  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='88' then '최소요청중' " 
	  SQL_Order_rs = SQL_Order_rs & "       when OorderState ='99' then '결제취소' end as order_state " ' 결제상태 취소
	  SQL_Order_rs = SQL_Order_rs & " ,OorderState As order_code	"
	  SQL_Order_rs = SQL_Order_rs & " ,isnull(OrderPrice,0)as OrderPrice	"
	  SQL_Order_rs = SQL_Order_rs & " ,Order_tid "
	  SQL_Order_rs = SQL_Order_rs & " ,Order_MOID "
	  SQL_Order_rs = SQL_Order_rs & " ,reg_date "

	  SQL_Order_rs = SQL_Order_rs & " ,vactbankname "
	  SQL_Order_rs = SQL_Order_rs & " ,vact_num "

	  SQL_Order_rs = SQL_Order_rs & " ,reg_date "

	  SQL_Order_rs = SQL_Order_rs & " From tblSwwimingOrderTable "
	  SQL_Order_rs = SQL_Order_rs & " Where del_yn = 'N'  "
	  SQL_Order_rs = SQL_Order_rs & " and OrderIDX = '"&oidx&"' "

	  Set rs = db.ExecSQLReturnRS(SQL_Order_rs , null, ConStr)



	If Not rs.eof Then
		arrB = rs.GetRows()
		paytype = arrB(2 , 0)
		pay_type = arrB(3,0)
		'Call getrowsdrow(arrb)
	End if

	db.Dispose
	Set db = Nothing
%>

		<input type="hidden" id = "check_seq" value="<%=seq%>">
		  

		  <section class="m_modal-player-selc-type">
            <div class="m_modal-player-selc-type__header">
              <h1 class="m_modal-player-selc-type__header__h1"><span><%=username%></span>결제취소요청 (<%=paytype%>)</h1>
            </div>
            <div class="m_modal-player-selc-type__con">

			  <table class="m_modal-player-selc-type__con__tbl">
                <caption>취소요청</caption>

<%If paytype = "가상계좌" then%>
				<thead class="m_modal-player-selc-type__con__tbl__thead">
                  <tr>
                    <th scope="col" style="width:150px;">예금주</th>
                    <th scope="col" style="width:150px;">은행명</th>
                    <th scope="col" style="width:300px;">계좌번호</th>
                  </tr>
                </thead>
                <tbody class="m_modal-player-selc-type__con__tbl__tbody">
                  <tr>
                    <td></td>
                  </tr>
<%
		If IsArray(arrB) Then 
			For ari = LBound(arrB, 2) To UBound(arrB, 2)
				'b_cda = arrB(0, ari) 
				%>
				  <tr class="s_showNum">
                    <td  style="width:150px;">
						<input type="text" id= "refundnm" value="" placeholder="성명" maxlength="12" style="width:100%;">
                    </td>
                    <td style="width:150px;min-width: 150px;">
						<input type="text" id= "refundbank" value="" placeholder="은행명"  style="width:100%;" maxlength="20">
					</td>
                    <td style="width:300px;">
						<input type="text" id= "refundno" value="" placeholder="-없이 숫자만"   onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"  style="width:100%;" maxlength="30">
					</td>
                  </tr>				
				<%				
			Next
		End if
%>

                </tbody>
<%End if%>



              </table>
            </div>
            <!-- span.s_show = 보이게 -->
            <!-- <span class="m_modal-player-selc-type__noti s_show">※ 관리자가<em>수모번호</em>를 <em>입력</em>해주세요</span> -->


			<div class="m_modal-player-list__btns clear">
              <button onclick="mx.setRefund(<%=OIDX%>,'<%=pay_type%>')" id="btnOkPlayerTypeModal" type="button" name="button">확인</button>
              <button onclick="closeModal()" id="btnCancelPlayerTypeModal" type="button" name="button">취소</button>
            </div>
          </section>