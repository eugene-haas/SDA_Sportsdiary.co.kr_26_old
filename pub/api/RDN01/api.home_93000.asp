<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'수정
'#############################################
	'request
	findstr = oJSONoutput.Get("FINDSTR")
	If CStr(Len(findstr)) < 1 Then
		Response.end
	End if

	Set db = new clsDBHelper

	tablename = "tblteaminfo"
	strFieldName = " team,teamnm,LEADER_KEY,teamidx "

	'동일 문구 있는지 검색
	Sql = "SELECT top 1  " & strFieldName
	Sql = Sql & "  from " & tablename
	Sql = Sql &  " WHERE   delyn = 'N' and teamnm = '"&findstr&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		samenm = "ok"
		findresult = "'이미 사용중인 이름 입니다."
	End if


	Sql = "SELECT top 20  " & strFieldName
	Sql = Sql & "  from " & tablename
	Sql = Sql &  " WHERE  (LEADER_KEY = ''  or  isnull(nowyear ,'0') < "&year(date)&" ) and delyn = 'N' and teamnm like '"&findstr&"%' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>
<%If rs.eof then%>
 	<tr onclick="mx.settr(this.id, '0','<%=findstr%>')" id="t_0" tabindex="0">
	 	<td >검색어로 신청하기</td>
 	</tr>
<%else%>
	<%Do Until rs.eof%>
		<%If samenm <> "ok" then%>
		<tr onclick="mx.settr(this.id, '','<%=findstr%>')" id="t_0" tabindex="0">
			<td >검색어로 신청하기</td>
		</tr>
		<%End if%>
		<tr onclick="mx.settr(this.id, '<%=rs("teamidx")%>', '<%=rs("teamnm")%>')" id="t_<%=rs("teamidx")%>" tabindex="0">
			<td><%=rs("teamnm")%></td>
		</tr>
	<%
	rs.movenext
	loop
End if


db.Dispose
Set db = Nothing
%>

