<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
  Set db = new clsDBHelper
	seq = request("seq")
  idx = request("idx")
%>
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<%
	Response.Expires = 0
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Cache-Control","no-cache,must-revalidate"

  sql_delete = "update sd_RidingBoard_c set seq = 0 where idx = '"& idx &"'"
  Call db.execSQLRs(sql_delete , null, ConStr)

  viewContents_photo = null
  sql_photo = "select filename,idx from sd_RidingBoard_c where seq = '"& seq &"' order by idx asc"
  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
  if not rs_photo.eof then
    viewContents_photo = rs_photo.GetRows()
  end if
  set rs = Nothing

  if isnull(viewContents_photo) = false Then
    for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
      response.write "https://www.youtube.com/watch?v="& viewContents_photo(0,i) &" <input type='button' value='미리보기' onclick='previewVideo(""https://www.youtube.com/watch?v="& viewContents_photo(0,i) &""")'> <input type='button' value='삭제' onclick='Video_Result("& seq &","& viewContents_photo(1,i) &")'><br/><br/>"
    Next
  end if
%>
