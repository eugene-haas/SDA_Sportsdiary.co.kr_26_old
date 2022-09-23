<%
'request
	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "PAYNM") = "ok" then
		paynm = oJSONoutput.PAYNM
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	
'request


	Set db = new clsDBHelper


	fieldstr = " attmoney,groupno "
	SQL = "Select "&fieldstr&" from sd_bikeRequest where requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		attmoney = rs("attmoney")
		groupno = rs("groupno")
	End if


	If Groupno = "0" Then'단체
		SQL = "Update sd_bikeRequest set paymentName = '"&paynm&"' where requestIDX = " & ridx
	else
		SQL = "Update sd_bikeRequest set paymentName = '"&paynm&"' where requestIDX = " & ridx & " or groupno = " & groupno
	End if
		Call db.execSQLRs(SQL , null, ConStr)
	
	db.Dispose
	Set db = Nothing
%>


	<div class="c-ment">
	  <ul>
		<li>
		  <span class="l-icon">※</span>
		  <span class="r-con">입력하신 입금자명과 실제입금자명이 동일해야 입금처리가 완료됩니다.</span>
		</li>
		<li>
		  <span class="l-icon">※</span>
		  <span class="r-con">실제 입금자명이 다른 경우, 반드시 고객센터로 연락을 주셔야 정상적인 입금처리가 가능합니 다.</span>
		</li>
	  </ul>
	</div>
	<div class="condition">
	  <ul>
		<li>
		  <span class="l-icon"><i class="fas fa-caret-right"></i></span>
		  <span class="r-con">입금확인시 참가신청이 최종완료 됩니다.</span>
		</li>
		<li>
		  <span class="l-icon"><i class="fas fa-caret-right"></i></span>
		  <span class="r-con">팀대표가 입금완료시 참가신청이 최종완료 됩니다.</span>
		</li>
	  </ul>
	</div>
	<div class="payment-user-info">
	  <ul>
		<li>
		  <span class="l-name">입금계좌</span>
		  <span class="r-con">기업 22004597701048<br>(예금주 : 위드라인)</span>
		</li>
		<li>
		  <span class="l-name">입금액</span>
		  <span class="r-con"><%=FormatNumber(attmoney,0)%> 원</span>
		</li>
		<li>
		  <span class="l-name">입금자명</span>
		  <span class="r-con"><%=paynm%></span>
		</li>
	  </ul>
	</div>
