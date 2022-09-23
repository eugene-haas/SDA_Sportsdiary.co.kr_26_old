<%
'######################
'환불취소요청
'######################

	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	End If	

	If hasown(oJSONoutput, "attmidx") = "ok" then
		attmidx = oJSONoutput.attmidx
	End If	

	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	End If	

	If hasown(oJSONoutput, "groupno") = "ok" then
		groupno = oJSONoutput.groupno
	End If	

	If hasown(oJSONoutput, "REFUNDBNK") = "ok" then
		refundbnk = htmlEncode(oJSONoutput.REFUNDBNK)
	End If	
	If hasown(oJSONoutput, "REFUNDNO") = "ok" then
		refundno = htmlEncode(oJSONoutput.REFUNDNO)
	End If	

	'##############################
	Set db = new clsDBHelper

	SQL = "select * from sd_bikeTitle where titleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	GameRcvDateE = rs("GameRcvDateE")

	If Cdate(GameRcvDateE) < Date() Then '지남 더이상 환불불가. 그냥 패스시키자.
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if


	strSort = "  order by b.groupno,a.gameday desc"
	If groupno = "0" then
	strWhere = "   a.DelYN = 'N' and b.PlayerIDX = " & cbike_pidx  & " and  a.titleIDX = "&tidx & " and c.requestIDX = " & ridx
	Else
	strWhere = "   a.DelYN = 'N' and b.PlayerIDX = " & cbike_pidx  & " and  a.titleIDX = "&tidx & " and b.groupno = " & groupno
	End if
	tablename = " sd_bikeLevel as a INNER JOIN v_bikeGame_attm as b ON a .titleIDX = b.titleIDX and a.levelIDX = b.levelno "
	tablename = tablename & " INNER JOIN sd_bikeRequest as c ON b.ridx = c.requestIDX "

	strFieldName = "a.titleIDX,a.levelIDX,a.detailtitle,a.gameday,a.booNM,b.gameidx,b.attmidx,b.playeridx,b.gubun,b.groupno,b.myagree,b.myadult,b.p_agree,b.teamtitle,b.pgrade "
	strFieldName = strFieldName & ",c.paymentstate,c.paymentname,c.attmoney,b.playeridx,c.playeridx as reqpidx,c.requestIDX "
	'strFieldName = "*"
	
	'SQL = "Select " & strFieldName & " from "&tablename&" where " & strWhere  & strSort
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	'Call rsdrow(rs)

	SQL = "Select " & strFieldName & " from "&tablename&" where " & strWhere  & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	i = 1
	Do Until rs.eof 

		do_ridx = rs("requestIDX")
		paymentname = rs("paymentname")
		levelIDX = rs("levelIDX")
		gameidx = rs("gameidx")
		groupno = rs("groupno")

		If groupno = "0" Then
			If i = 1 then
				SQL = "update sd_bikeRequest Set refundbnk = '" & refundbnk & "',refundno = '" & refundno & "',refundattdate=getdate() where RequestIDX = " & do_ridx 
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = "update sd_bikeGame Set gubun = 2 where gameidx = " & gameidx
				Call db.execSQLRs(SQL , null, ConStr)
			End if
		Else

			'이건 여러건일수 있으니
			SQL = "update sd_bikeRequest Set refundbnk = '"&refundbnk&"',refundno = '"&refundno&"',refundattdate=getdate()  where RequestIDX = " & do_ridx 
			Call db.execSQLRs(SQL , null, ConStr)		
			SQL = "update sd_bikeGame Set gubun = 2 where gameidx = " & gameidx
			Call db.execSQLRs(SQL , null, ConStr)
		End if

		If paymentname = "" Then
			Response.End
		End if

	i = i + 1
	rs.movenext
	loop






	If hasown(oJSONoutput, "groupno") = "ok" then
		oJSONoutput.groupno = groupno
	Else
		Call oJSONoutput.Set("groupno", groupno ) 
	End if

	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>						
