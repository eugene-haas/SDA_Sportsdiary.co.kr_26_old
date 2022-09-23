<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
  SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
  'SQL = "SELECT o.name , i.rows  FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
  'Response.write SQL & "</BR>"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
 
	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if
%>


 <%'View ####################################################################################################%>

<a href="javascript:mx.deleteForm(null, {'CMD':1});">경기기록 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':2});">참가신청 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':3});">대진표참가 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':4});">참여부 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':5});">유저 삭제</a><br><br>

<!--
<a href="javascript:alert('경기기록 삭제')">경기기록 삭제</a><br><br>
<a href="javascript:alert('참가신청 삭제')" >참가신청 삭제</a><br><br>
<a href="javascript:alert('대진표참가 삭제')" >대진표참가 삭제</a><br><br>
<a href="javascript:alert('참여부 삭제')" >참여부 삭제</a><br><br>
<a href="javascript:alert('유저 삭제')" >유저 삭제</a><br><br>
-->

<select id="selectTabelList" style="width:auto;"> 
<%
  if(IsArray(arr)) Then
  	For ar = LBound(arr, 2) To UBound(arr, 2) 
      Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
    NEXT
  End IF
%>
</select>

<a class="btn" href="javascript:mx.copyTable('selectTabelList')">복사</a>

<a class="btn" href="javascript:mx.deleteTable('selectTabelList')">삭제</a>

