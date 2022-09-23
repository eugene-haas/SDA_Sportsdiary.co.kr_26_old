<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
	Set db = new clsDBHelper
  seq = request("seq")

  updateSql = "update sd_RidingBoard set titleIDX = 0, levelNo =0 where seq = '"& seq &"'; "_
  &"update sd_RidingBoard_c set seq = 0 where seq = '"& seq &"' "
  Call db.execSQLRs(updateSql , null, ConStr)

  Response.write "<script type='text/javascript'>"
  Response.write "alert('삭제되었습니다.');"
  Response.write "location.href='/video.asp'"
  Response.write "</script>"
%>
