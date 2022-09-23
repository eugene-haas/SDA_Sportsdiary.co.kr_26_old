<%
'#############################################
'대진표 리그 화면 준비 
'#############################################

'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = title & " " & teamnm & " (" & areanm & ")  예선 대진표"
resetflag = oJSONoutput.RESET 'ok를 받으면 sortNo를 0으로 업데이트 한다.


Set db = new clsDBHelper

'기본정보#####################################
	strtable = "sd_TennisMember"
	strtablesub =" sd_TennisMember_partner "
	strtablesub2 = " tblGameRequest "
	strresulttable = " sd_TennisResult "

	SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof then
		entrycnt = rs("entrycnt")					'참가제한인원수
		attmembercnt = rs("attmembercnt")		'참가신청자수
		courtcnt = rs("courtcnt")					'코트수
		levelno = rs("level")							'레벨
		lastjoono = rs("lastjoono")					'마지막에 편성된 max 조번호
		poptitle = poptitle & " <span style='color:red'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"

		If Left(levelno,3) = "200" Then
			joinstr = " left "
			singlegame =  true
		Else
			joinstr = " inner "
			singlegame = false
		End if
	End if
'#############################################


'부전 결과 자동라운드 생성 >  페이지 호출
reqstr = "?REQ={""CMD"":20000,""IDX"":"""&tidx&""",""S1"":""tn001001"",""S2"":"&Left(levelno,3)&",""S3"":"&levelno&",""TT"":1,""SIDX"":0}"
source = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/pub/ajax/reqtennis.asp"&reqstr) , "utf-8" )
'Response.write source


db.Dispose
Set db = Nothing
%>
