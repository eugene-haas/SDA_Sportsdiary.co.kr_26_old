<%

'######################
'######################

idx = oJSONoutput.IDX

Set db = new clsDBHelper

strfield = " PaymentName, refundno, refundbnk, refundattdate, refundstate, refundupdate"
strTable = " sd_bikeRequest "
strWhere = " requestIDX= "&idx&" "
SQL = " SELECT "&strfield&" FROM "&strTable&" WHERE "&strWhere&" "
set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

PaymentName = rs("PaymentName")
refundno = rs("refundno")
refundbnk = rs("refundbnk")
refundattdate = rs("refundattdate")
refundstate = rs("refundstate")
refundupdate = rs("refundupdate")

db.dispose()
set db = nothing

Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

%>

  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">환불정보</h4>
      </div>
      <div class="modal-body">
        <!-- S: list-tale -->
        <div class="list-table">
          <ul>
            <li>
              <span class="l-name">입금자</span>
              <span class="r-con"><%=PaymentName%></span>
            </li>
            <li>
              <span class="l-name">환불신청 날짜</span>
              <span class="r-con"><%=refundattdate%></span>
            </li>
            <li>
              <span class="l-name">환불신청 은행</span>
              <span class="r-con"><%=refundbnk%></span>
            </li>
            <li>
              <span class="l-name">환불신청 계좌번호</span>
              <span class="r-con"><%=refundno%></span>
            </li>
            <li>
              <span class="l-name">환불날짜</span>
              <span class="r-con"><%=refundupdate%></span>
            </li>
            <li>
              <span class="l-name">환불상태</span>
              <span class="r-con"><%=refundstate%></span>
            </li>
          </ul>
        </div>
        <!-- E: list-tale -->
      </div>
      <div class="modal-footer">
        <a href="#" class="white-btn" data-dismiss="modal">닫기</a>
        <a href="#" class="navy-btn" data-dismiss="modal">확인</a>
      </div>
    </div>
  </div>
