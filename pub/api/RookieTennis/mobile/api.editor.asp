<%
'#############################################
'대진표 리그 화면 준비
'#############################################

'request
tidx = oJSONoutput.TIDX
title = oJSONoutput.TITLE

Set db = new clsDBHelper

SQL = "Select summary from sd_tennisTitle where gametitleidx = " & tidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

 If Not rs.eof Then
	contents = htmlDecode(rs(0))
 End if
%>

<%=contents%>


<!-- <input type= "text" value="aa" onclick="location.href='<%=contents%>';" target="_blank" style="display:none;" id="yoyo"> -->
<%
db.Dispose
Set db = Nothing
%>
