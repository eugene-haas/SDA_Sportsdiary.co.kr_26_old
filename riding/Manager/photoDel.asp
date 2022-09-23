<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
	Set db = new clsDBHelper
  sketch_idx = request("sketch_idx")

  updateSql = "update sd_Tennis_Stadium_Sketch_Photo set delyn = 'Y' where Sketch_idx = '"& sketch_idx &"'; "_
  &"update sd_Tennis_Stadium_Sketch set delyn = 'Y' where idx = '"& sketch_idx &"' "
  Call db.execSQLRs(updateSql , null, ConStr)

  Response.write "<script type='text/javascript'>"
  Response.write "alert('삭제되었습니다.');"
  Response.write "location.href='/photo.asp'"
  Response.write "</script>"
%>
