<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
	Set db = new clsDBHelper
	total_board_seq = request("total_board_seq")
	seq = request("seq")
%>
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<%
	Response.Expires = 0
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Cache-Control","no-cache,must-revalidate"

  sql_delete = "update tblTotalBoard_File set DelYN = 'Y' where seq = '"& seq &"'"
  Call db.execSQLRs(sql_delete , null, ConStr)

  viewContents_photo = null
  sql_photo = "select SEQ, TotalBoard_SEQ, FILENAME from tblTotalBoard_File where delyn = 'N' and TotalBoard_SEQ = '"& total_board_seq &"' order by seq asc"
  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
  if not rs_photo.eof then
    viewContents_photo = rs_photo.GetRows()
  end if
  set rs = Nothing

  if isnull(viewContents_photo) = false Then
    for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
      'response.write "<img src='http://Upload.sportsdiary.co.kr/sportsdiary"& viewContents_photo(2,i) & "'><input type='button' value='삭제' onclick='Image_Delete("& board_seq &","& viewContents_photo(0,i) &")'><br/>"
	  response.write "<img src='http://Upload.sportsdiary.co.kr/sportsdiary"& viewContents_photo(2,i) & "'> <a href='javascript:Image_Delete("& total_board_seq&","& viewContents_photo(0,i) &")' class='btn btn-primary'>이미지 삭제</a><br/>"

    Next
  end if
%>
