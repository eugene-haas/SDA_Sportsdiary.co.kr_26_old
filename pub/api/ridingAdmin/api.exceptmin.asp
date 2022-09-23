<%
'#############################################
'기권 실격저장
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		r_tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		r_gbidx= oJSONoutput.GBIDX
	End If

	If hasown(oJSONoutput, "YN") = "ok" then
		r_YN= oJSONoutput.YN
	End If


	'지운거 혹 살릴까봐 delYN 된것도 모두 변경
	SQL = "Update tblRGameLevel Set minChk = '"& r_YN &"'   where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"' " 
	Call db.execSQLRs(SQL , null, ConStr)


	'선수들의 초저점을 찾아 모두 등록해 준다. '관찰총점은 구하기가 ..... (설정을 변경시 모두 초기화 쪽으로 가닥을 잡자...)
	SQL = "select judgecnt,judgemaxpt,judgesignYN,judgeshowYN,maxChk,minChk     ,  judgeB,judgeE,judgeM,judgeC,judgeH    from tblRGameLevel  where gametitleidx = '"&r_tidx&"' and Gbidx = '"&r_gbidx&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If
	rs.close

	If IsArray(arrC) Then 
		r_pYNarr = array(arrC(6, ar),arrC(7, ar),arrC(8, ar),arrC(9, ar),arrC(10, ar))
		r_pfnmarr = array("score_1","score_2","score_3","score_4","score_5")
		n= 1
		For i = 0 To ubound(r_pYNarr)
			If r_pYNarr(i) = "Y" then
				If n = 1 then
					scYNfield =  r_pfnmarr(i)
				Else
					scYNfield = scYNfield &","&  r_pfnmarr(i)
				End if
				n = n + 1
			End if
		next
	End if




	If r_YN = "Y" Then
	
		SQL = "update sd_TennisMember set minval = mintbl.minpt from  "
		SQL = SQL & "	( "
		SQL = SQL & "		select gameMemberIDX ,minval , "
			
		SQL = SQL & "		(Select MIN(A.cnt) as minVal From  "
		SQL = SQL & "			(select gameMemberIDX,region, cnt from (    select gameMemberIDX,"&scYNfield&" from sd_TennisMember where gameMemberIDX = m.gameMemberIDX) tbl unpivot "
		SQL = SQL & "			( cnt for region in ( "&scYNfield&" )) upvt) "
		SQL = SQL & "		 As A) as minpt "

		SQL = SQL & "		from sd_TennisMember as m where m.gametitleidx = "&r_tidx&" and m.gamekey3 = "&r_gbidx&" "
		SQL = SQL & "	) as mintbl "

		SQL = SQL & "	where sd_TennisMember.gameMemberIDX = mintbl.gameMemberIDX "
		Call db.execSQLRs(SQL , null, ConStr)

	Else
		SQL = " update sd_TennisMember set minval  = 0,minval2= 0  where gametitleidx = "&r_tidx&" and gamekey3 = "&r_gbidx&" "
		Call db.execSQLRs(SQL , null, ConStr)
	End if


  
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
