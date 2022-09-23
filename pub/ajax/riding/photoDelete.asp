<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
  Set db = new clsDBHelper
	sketch_idx = request("sketch_idx")
  idx = request("idx")
%>
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<%
	Response.Expires = 0
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Cache-Control","no-cache,must-revalidate"

  sql_delete = "update sd_Tennis_Stadium_Sketch_Photo set delyn = 'Y' where idx = '"& idx &"'"
  Call db.execSQLRs(sql_delete , null, ConStr)

  viewContents_photo = null
  sql_photo = "select Photo,idx from sd_Tennis_Stadium_Sketch_Photo where delyn = 'N' and Sketch_idx = '"& sketch_idx &"' order by idx asc"
  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
  if not rs_photo.eof then
    viewContents_photo = rs_photo.GetRows()
  end if
  set rs = Nothing

  if isnull(viewContents_photo) = false Then
    for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
      response.write "<img src='http://Upload.sportsdiary.co.kr/sportsdiary"& viewContents_photo(0,i) & "'><input type='button' value='삭제' onclick='Sketch_Result("& sketch_idx &","& viewContents_photo(1,i) &")'><br/>"
    Next
  end if
%>
