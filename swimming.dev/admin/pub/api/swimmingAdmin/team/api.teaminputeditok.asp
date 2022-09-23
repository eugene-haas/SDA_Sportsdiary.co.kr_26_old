<%
'#############################################

'대회 정보 수정

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
		'For intloop = 0 To oJSONoutput.PARR.length-1
		'   Response.write  reqArr.Get(intloop) & "<br>"
		'Next
		'Response.end
	End if

	Set db = new clsDBHelper 

		'구분, 1코드, 2팀명, 3국가 , 4시도, 5성별, 6그룹, 7등록, 8창단, 9단체장, 10지도자 ,11우편, 12주소 , 13전화 , 14해체일
		updatefield = " EnterType,Team,TeamNm,nation,sido,Sexno,groupnm,TeamRegDt,TeamMakeDt,jangname,readername,ZipCode,Address,TeamTel,SvcEndDt "
		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨두에 별도값으로가져오고

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(i)&" = '"&reqArr.Get(i)&"' "
			'Case 7,8,14 '등록, 창단, 해체
			Case 2 
			'같은등록년도의  팀명칭이 변경되면 관련 코치(와 팀의 명칭도 변경해주어야한다) 팀명칭도 변경해주어야한다.
				'If Cstr(reqArr.Get(7)) = Cstr(year(date)) then
					sql = "         update tblreader set teamnm = '"&reqArr.Get(2)&"' where team =  '"&reqArr.Get(1)&"' and startyear = '"&year(date)&"' "
					sql = sql & " update tblplayer set teamnm = '"&reqArr.Get(2)&"' where team =  '"&reqArr.Get(1)&"' and nowyear = '"&year(date)&"' "
					Call db.execSQLRs(SQL , null, ConStr)
				'End if

			
			Case 8,14 ' 창단, 해체
					'2019/12/06
					If isdate(reqArr.Get(i)) = True then
					fdate = Cdate(reqArr.Get(i))
					Else
					fdate = ""
					End if
					updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&fdate&"' " 
			Case oJSONoutput.PARR.length-1
					e_idx = reqArr.Get(i)
			Case Else
				updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&reqArr.Get(i)&"' "
			End Select 
		next

		strSql = "update  tblTeamInfo Set   " & updatefield & " where TeamIDX = " & e_idx
		'Response.write strsql
		'Response.end
		Call db.execSQLRs(strSQL , null, ConStr)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>




