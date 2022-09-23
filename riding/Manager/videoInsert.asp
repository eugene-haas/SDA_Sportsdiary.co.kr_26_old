<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
	Set db = new clsDBHelper

  Search_GameTitleIDX = request("Search_GameTitleIDX")
  Search_GBIDX = request("Search_GBIDX")
  ReturnURI = request("ReturnURI")
  UserName    = Cookies_aNM
  UserID      = Cookies_aID

  if Search_GameTitleIDX <> "" then
    insertSql = "insert into sd_RidingBoard (titleIDX,levelNo,tid,pid,ip,readnum,writeday) values ('"& Search_GameTitleIDX &"','"& Search_GBIDX &"','1','"& UserID &"','"& UserName &"','0',getdate())"
    Call db.execSQLRs(insertSql , null, ConStr)
  end if

  Response.write "<script type='text/javascript'>"
	Response.write "alert('완료되었습니다. 리스트로 이동합니다.\n※확인 : 경기영상은 리스트 등록후에 리스트뷰에서 진행 하세요.');"
	Response.write "location.href='"& ReturnURI &"'"
	Response.write "</script>"
%>
