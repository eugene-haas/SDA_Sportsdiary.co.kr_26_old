<%
	DN = oJSONoutput.value("DN")
	If  DN <> "" Then
		DN = chkStrRpl(oJSONoutput.value("DN"), "") '디비명
		ConStr = Replace(ConStr, "ITEMCENTER", DN)
	Else
		DN = "ITEMCENTER"
	End if

	'IC_T_AuthCode 약정회원 검색
	usetable = array("IC_T_AGENT","IC_T_RETAIL","IC_T_AuthCode","IC_T_ORDER_CUST")

	Set oClsDBHelper = new clsDBHelper

	SQL = "SELECT o.name , i.rows,  (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY  i.rows DESC"
	Set rs = oClsDBHelper.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		jstr = "{""result"":""1""}"
		Response.write jstr
		Set rs = Nothing
		Set oClsDBHelper = Nothing
		Response.end
	Else
		
		Response.write "<table class=""type09"">"
		Response.write "<thead><th>tablename</th><th>rows</th><th>comment</th><th>column</th></thead>"

		Do Until rs.eof 
			Response.write "<tr>" 
			For n = 0 To ubound(usetable)
				If usetable(n) = rs(0) then
					tablestyle = "style='color:red;'"
					Exit for
				Else
					tablestyle = ""				
				End if
			Next

			Response.write "<td "&tablestyle&">" & rs(0) & "</td><td>" &  rs(1) & "</td>"
			

			If rs(2) = "" Or Len(rs(2)) >= 1 Then
				MD = 2 'update
			Else 
				MD = 1 'insert
			End if
			'EXEC   sp_updateextendedproperty 'MS_Description', '주석', 'user', dbo, 'table', 테이블명     ' 업데이트쿼리

			If DN = "ITEMCENTER"  Or DN = "Sportsdiary" then
				Response.write "<td><input type='text' value='" &  rs(2) & "'  onblur=""if(this.value !=''){mx.SendPacket(this,{'CMD':mx.CMD_TABLECMT,'NM':'"&rs(0)&"','DN':'"&DN&"','CMT':this.value, 'MD':"&MD&"})}""></td>"
			else
				Response.write "<td>" &  rs(2) & "</td>"
			End if

			Response.write "<td><a href=""javascript:mx.SendPacket(this, {'CMD':mx.CMD_TABLECLUMN,'NM':'"&rs(0)&"','DN':'"&DN&"' })"">컬럼 샘플 확인</a></td>"
			Response.write "</tr>"
		rs.movenext
		loop
		Response.write "</table>"
	End If


	Call oClsDBHelper.Dispose()
	Set rs = Nothing
	Set oClsDBHelper = Nothing
%>