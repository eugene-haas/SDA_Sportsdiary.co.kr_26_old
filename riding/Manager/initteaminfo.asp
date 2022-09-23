<!-- #include virtual = "/pub/header.radingAdmin.asp" -->

<%
Set db = new clsDBHelper

If Cookies_aIDX  = "" Then
Response.End
End if


yy = year(date)
wdate =  yy & "-01-01"

SQL = ""
SQL = SQL & " insert Into tblResetTeaminfo (resetyear) values ('"&year(date)&"')"

SQL = SQL & " update tblWebRegLog set delyn = 'Y' where delyn = 'N' and gubun = 3 and writedate >= '"&wdate&"'  " '해가 바뀌어서 
SQL = SQL & " update tblwebmember set apply_yn = 'N' where delyn = 'N' "
SQL = SQL & "	update tblteaminfo set leader_key = ''  where  delyn = 'N' "
SQL = SQL & "	update tblplayer set owner_id = '',  apply_yn = 'N'  where delyn = 'N' and usertype = 'P'   "
SQL = SQL & " update tblleader set apply_yn = 'N',owner_id='' where delyn = 'N'  and apply_yn = 'Y' "
Call db.execSQLRs(SQL , null, ConStr)



db.Dispose
Set db = Nothing


Response.redirect "./maketeam.asp"
%>