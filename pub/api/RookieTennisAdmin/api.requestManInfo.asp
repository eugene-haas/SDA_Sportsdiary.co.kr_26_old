
<%
	Response.write "<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button><h3 id='myModalLabel'>"&poptitle&"</h3></div>"
	Response.write "<div class='modal-body'>"
%>

<%
	'request
	idx = oJSONoutput.IDX
	PaymentTitle ="미입금"

	Set db = new clsDBHelper

  strtable = " tblGameRequest "
	strfield = " UserName ,UserPhone ,txtMemo ,PaymentDt ,PaymentNm ,PaymentType"
  strSql = " SELECT " & strfield & " FROM " & strtable
  strSql = strSql & " WHERE RequestIDX = '" & idx & "'"
 
	Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)
	
	IF Not rs.eof Then
		rUserName = rs("UserName")
		rUserPhone = rs("UserPhone")
		rtxtMemo = rs("txtMemo")
		rPaymentDt = rs("PaymentDt")
		rPaymentNm = rs("PaymentNm")
		rPaymentType = rs("PaymentType")
	End IF

	IF(rPaymentType ="Y") Then
		PaymentTitle	="입금완료"
	End IF

  db.Dispose
  Set db = Nothing
  'Response.Write strSql

	'Call oJSONoutput.Set("resout", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson
%>

<table class="table-Profile">
	<thead>
		<tr>
			<th colspan="2" class="title">신청자 정보</th>
			
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="title">이름</td> 
			<td><%=rUserName%></td>
		</tr>
		<tr>
			<td class="title">핸드폰</td> 
			<td><%=rUserPhone%></td>
		</tr>
		<tr>
			<td class="title">메모</td> 
			<td><%=rtxtMemo%></td>
		</tr>
		<tr>
			<td class="title">입금자명</td> 
			<td><%=rPaymentDt%></td>
		</tr>
		<tr>
			<td class="title">입금계좌</td> 
			<td><%=rPaymentNm%></td>
		</tr>
		<tr>
			<td class="title">입금상태</td> 
			<td><%=PaymentTitle%></td>
		</tr>
	</tbody>
</table>

<%		
	Response.write "</div>"
	Response.write "</div>"
%>
