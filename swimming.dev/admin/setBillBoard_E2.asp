<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
'request
	bb = request("bb")
	




response.write bb
response.end







	Set db = new clsDBHelper

	fieldStr  = " UserID,UserPass,AdminName,Authority,KIND_CODE "
	SQL = "select top 1 "&fieldStr&"  from tblAdminMember where UserID = '"&req_id&"' and delYN = 'N'  and useYN = 'Y' "
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	If rs.eof Then
		Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
		Call oJSONoutput.Set("servermsg", "아이디가 존재하지 않습니다." ) '서버에서 메시지 생성 전달
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	Else
		user_id			= rs("UserID")
		If InStr(user_id, "_") > 0 then
		user_no			= Split(user_id,"_")(1)
		Else
		user_no			= 1
		End if
		user_nm			= rs("AdminName")
		user_auth		= rs("Authority")
		user_kindcode = rs("KIND_CODE") '심판 심사종목코드
		If user_kindcode = "E2" Then
			user_kindcodenm = "DIVING(다이빙)"
		Else
			user_kindcodenm = "ARTISTIC(아티스틱)"
		End if
		
		If rs("UserPass") = req_pwd Then

				'대회날짜는 (오늘을 기준으로 완료된것들은 
				'로그인시 대회날짜(오늘) 로그인한 (심판이 포함된 것이 있나 검사. 신경쓰는건 리스트에서 , 일딴 대회명과 대회 인덱스만 폼함하도록 하자.)
				
				
				'test 
				' If IS_DEV then

				' 	If user_kindcode = "E2" then
				' 	SQL = "select a.gametitleidx,a.gametitlename from  sd_gameTitle as a Where gametitleidx = 137"
				' 	Else
				' 	SQL = "select a.gametitleidx,a.gametitlename from  sd_gameTitle as a Where gametitleidx = 143"
				' 	End if
				
				' else
					strWhere = " DelYN = 'N' and GameTitleIDX = (select top 1 GameTitleIDX from tblRgameLevel where DelYN='N' and cda = '"&user_kindcode&"' "
					strWhere = strWhere & " and (tryoutgamedate = '"&date&"' or finalgamedate = '"&date&"') ) "
					SQL = "select top 1 a.gametitleidx,a.gametitlename from  sd_gameTitle as a where "  & strWhere
				'End If
				
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				
				If rs.eof Then
					Call oJSONoutput.Set("sql", sql ) 
					Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "당일 대회가 없습니다." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end

				else
					game_idx = rs("gametitleidx")
					game_title = rs("gametitlename")
				End If
				

				
				'쿠키생성
				'로그인정보
				'대회정보 

				Set mobj =  JSON.Parse("{}")
				Call mobj.Set("C_ID", user_id )
				Call mobj.Set("C_NM", user_nm )	
				Call mobj.Set("C_AUTH", user_auth )
				Call mobj.Set("C_CDA", user_kindcode  )
				Call mobj.Set("C_CDANM", user_kindcodenm  )
				Call mobj.Set("C_POSITIONNUM", user_no  )
				Call mobj.Set("C_TIDX", game_idx  )
				Call mobj.Set("C_TNAME", game_title  )

				strmemberjson = JSON.stringify(mobj)
				strmemberjson = f_enc(strmemberjson)

				Response.Cookies(COOKIENM) = strmemberjson
				Response.Cookies(COOKIENM).domain = CHKDOMAIN

				
				
				
				
				Set mobj = Nothing	





				Call oJSONoutput.Set("result", "0" ) '정상
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end

		Else
				Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
				Call oJSONoutput.Set("servermsg", "패스워드를 정확히 기입해 주십시오." ) '서버에서 메시지 생성 전달
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
		End if
	End if



db.Dispose
Set db = Nothing
%>