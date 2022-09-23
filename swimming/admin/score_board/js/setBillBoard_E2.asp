<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<%

'#############################################
'오늘 대회찾기 및 설정
'#############################################
	'request
	bb = request("bb")
  CDA = "E2"

	Set db = new clsDBHelper

				'오늘 대회
				strWhere = " DelYN = 'N' and GameTitleIDX = (select top 1 GameTitleIDX from tblRgameLevel where DelYN='N' and cda = '"&CDA&"' "
				strWhere = strWhere & " and (tryoutgamedate = '"&date&"' or finalgamedate = '"&date&"') ) "
				SQL = "select top 1 a.gametitleidx,a.gametitlename from  sd_gameTitle as a where "  & strWhere
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				
				If rs.eof Then
          response.write "금일 다이빙 대회가 없습니다."
					Response.Write strjson
					Response.end

				else
					game_idx = rs("gametitleidx")
					game_title = rs("gametitlename")
				End If
			
				'쿠키생성	대회정보 
        Set mobj =  JSON.Parse("{}")
        Call mobj.Set("C_CDA", CDA  )
        Call mobj.Set("C_CDANM", "다이빙"  )
        Call mobj.Set("C_TIDX", game_idx  )
        Call mobj.Set("C_TNAME", game_title  )

        strmemberjson = JSON.stringify(mobj)
        strmemberjson = f_enc(strmemberjson)

        Response.Cookies("BBE2") = strmemberjson
        Response.Cookies("BBE2").domain = CHKDOMAIN
        Set mobj = Nothing	

select case Cdbl(bb)
case 3
  'response.redirect "/game_manager/pages/gametotalinfo.asp"
	response.redirect "/score_board/pages/total.asp"
case 2
  'response.redirect "/game_manager/pages/gameroundinfo.asp"
	response.redirect "/score_board/pages/info.asp"
case 1
	'response.redirect "/game_manager/pages/gameorderinfo.asp"
	response.redirect "/score_board/pages/info.asp"  
end select 

db.Dispose
Set db = Nothing
%>