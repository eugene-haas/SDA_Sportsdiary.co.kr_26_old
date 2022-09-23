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

		'0국제, 1체전, 2장소, 3주최 , 4주관, 5후원, 6협찬, 7대회명, 8요강, 9규모, 10레인수 ,11대회코드, 12참가비 , 13대회기간 , 14신청기간 , 15대회구분 , 16구분, 17개인, 18팀, 19시도신청, 20시도승인, 21팀당2명이내제한, 22종목수
		updatefield = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt"
		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨두에 별도값으로가져오고

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(i)&" = '"&reqArr.Get(i)&"' "
			Case 13 '대회기간
						'2019/12/06 - 2019/12/06
					gameDate = Split(reqArr.Get(i),"-")
					gameS = CDate(gameDate(0))
					gameE = CDate(gameDate(1))
					updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&gameS&"' " & ", "&upfieldarr(i+1)&" =  '"&gameE&"' "
			Case 14 '신청기간
						'2019/12/06 12:00 AM - 2019/12/06 11:59 PM
					'If isdate(reqArr.Get(i)) = True then
					gameDate = Split(reqArr.Get(i),"-")

'Response.write gameDate(1) & "<br>"
'Response.write  Left(Trim(gameDate(1)),"10") '& " " &Mid(gameDate(1),11)
'
'For x = 1 To 10
'	Response.write Mid(gamedate(1) , x ,1) & "<br>"
'next
'Response.end

					gameS = CDate(Left(Trim(gameDate(0)),10)) & " "  & FormatDateTime(CDate(Left(Trim(gameDate(0)),"10") & " " &Mid(Trim(gameDate(0)),11) ),4) & ":00"
					gameE = CDate(Left(Trim(gameDate(1)),10)) & " "  & FormatDateTime(CDate(Left(Trim(gameDate(1)),"10") & " " &Mid(Trim(gameDate(1)),11) ),4) & ":00"
					updatefield	= updatefield & ", "&upfieldarr(i+1)&" =  '"&gameS&"' " & ", "&upfieldarr(i+2)&" =  '"&gameE&"' "
					'end if
			Case oJSONoutput.PARR.length-1
				e_idx = reqArr.Get(i)
			Case Else

				If i < 13 then
					updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&reqArr.Get(i)&"' "
				Else
					updatefield	= updatefield & ", "&upfieldarr(i+2)&" = '"&reqArr.Get(i)&"' "
				End if
			End Select 
		next

		strSql = "update  sd_gameTitle Set   " & updatefield & " where GameTitleIDX = " & e_idx
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




