<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
  Set db = new clsDBHelper
	title = request("title")
  videoid = request("videoid")
  video_idx = request("video_idx")
  UserName    = Cookies_aNM
  UserID      = Cookies_aID

  if video_idx <> "" and videoid <> "" then
    insertSql = "insert into sd_RidingBoard_c (seq,tid,pid,filename,Thumbnail,title,writeday,readnum) values ('"& video_idx &"','1','"& UserID &"','"& videoid &"','https://img.youtube.com/vi/"& videoid &"/mqdefault.jpg','"& title &"',getdate(),0)"
    Call db.execSQLRs(insertSql , null, ConStr)
  end If

  viewContents_photo = null
  sql_photo = "select filename,idx from sd_RidingBoard_c where seq = '"& video_idx &"' order by idx asc"
  Set rs_photo = db.ExecSQLReturnRS(sql_photo , null, ConStr)
  if not rs_photo.eof then
    viewContents_photo = rs_photo.GetRows()
  end if
  set rs = Nothing

  if isnull(viewContents_photo) = false Then
    for i = LBound(viewContents_photo,2) to ubound(viewContents_photo,2)
      response.write "https://www.youtube.com/watch?v="& viewContents_photo(0,i) &" <input type='button' value='미리보기' onclick='previewVideo(""https://www.youtube.com/watch?v="& viewContents_photo(0,i) &""")'> <input type='button' value='삭제' onclick='Video_Result("& video_idx &","& viewContents_photo(1,i) &")'><br/><br/>"
    Next
  end if
%>
