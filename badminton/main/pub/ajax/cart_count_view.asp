<!-- #include virtual = "/pub/header.mall.asp" -->
<%
	User_Session = Session.SessionID
	strqryc = " SELECT COUNT(*) AS cnt "
	strqryc = strqryc & " FROM ITEMCENTER.DBO.IC_T_ONLINE_CART "
	strqryc = strqryc & " WHERE DEL_YN = 'N' "

	If GetsLOGINID() <> "nomember" Then
		strqryc = strqryc & " AND USER_SEQ = '" & GetsCUSTSEQ() & "' "
	Else
		strqryc = strqryc & " AND USER_SESSION = '" & User_Session & "' "
	End If

	strqryc = strqryc & " AND ONLINE_CD = '" & GLOBAL_VAR_ONLINECD & "' "

'Response.write (strqryc)

	Dbopen()
		Set rsc = DBCon.execute(strqryc)
	Dbclose()
%>
<a href="/mobile/order/cart.asp" class="cart">
	<img src="/mobile/images/cart_icon_w.png" alt="" />
		<span class="number" /><%=rsc("cnt")%></span>
</a>
