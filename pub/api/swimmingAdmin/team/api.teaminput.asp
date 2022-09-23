<%
'#############################################

'대회생성저장

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


		'동일 팀명칭 체크



		'구분, 1코드, 2팀명, 3국가 , 4시도, 5성별, 6그룹, 7등록, 8창단, 9단체장, 10지도자 ,11우편, 12주소 , 13전화 , 14해체일
		insertfield = " EnterType,Team,TeamNm,nation,sido,Sexno,groupnm,TeamRegDt,TeamMakeDt,jangname,readername,ZipCode,Address,TeamTel,SvcEndDt "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case 8,14 '등록, 창단, 해체
						'2019/12/06
					If reqArr.Get(i) <> "" and isnull(reqArr.Get(i)) = false then
					fdate = Cdate(reqArr.Get(i))
					Else
					fdate = ""
					End if
					insertvalue	= insertvalue & ",'"&fdate&"' " 
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>