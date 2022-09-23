<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
	Set db = new clsDBHelper
  seq = request("seq")

  updateSql = "update tblTotalBoard_File set delyn = 'Y' where TotalBoard_SEQ = '"& seq &"'; "_
  &"update tblTotalBoard set delyn = 'Y' where seq = '"& seq &"' "
  Call db.execSQLRs(updateSql , null, ConStr)

  Response.write "<script type='text/javascript'>"
  Response.write "alert('삭제되었습니다.');"
  Response.write "location.href='/home/homephoto.asp'"
  Response.write "</script>"
%>
