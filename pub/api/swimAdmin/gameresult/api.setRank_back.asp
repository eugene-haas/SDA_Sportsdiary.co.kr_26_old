<%
'#############################################
'랭킹포인트 셋팅
'#############################################

'request
midx =oJSONoutput.MIDX
levelno = oJSONoutput.LEVELNO 
tidx = oJSONoutput.TIDX
sno = oJSONoutput.SNO

Set db = new clsDBHelper


Function selectpoint(ByVal pidx , ByVal strwhere, ByVal per)
	Dim SQL , rs, point
	'부의 15개 포인트를 가져온다. ( 신인부, 베테랑부인경우 오픈부의 값을 더할지 여부를 검색해본다.)
	SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y'  and  PlayerIDX = "&pidx&" and teamGb in "&strwhere&" order by getpoint desc )"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If isNull(rs(0)) = true Then
		point = 0
	Else
		point = rs(0)
	End If

	selectpoint = Fix(CDbl(point) / 100 * per)
End function	


Function setUserPoint(ByVal levelno, ByVal pidx)

	Dim point, pointA, strwhere
	Select Case CDbl(Left(levelno,5))
	Case 20109  '가족부 이벤트성 포인트인것
		point = 0

	Case 20108 '혼합복식    예2) 혼복작성시 : 오픈부 100%, 베테랑부 80%, 신인부 70%, 국화부 50%, 개나리부 30%

		'오픈부 100%
		strwhere  = " (20106,20105,20107)  or rnkboo in ( 'NNNYY', 'NNYYY' , 'NNNYN' ) "   'rnkboo > NNNNN 개나리, 국화, 신인 , 오픈, 베테랑(오픈 체크  NNNYY, NNYYY , NNNYN) 
		point = selectpoint(pidx,strwhere, 100)
		'베테랑 80%
		strwhere  = "(20103) or rnkboo in ( 'NNNYY', 'NNYYY' , 'NNYNY' ) "
		pointA = selectpoint(pidx,strwhere, 80)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End If
		'신인부 70%
		strwhere  ="(20104)   or rnkboo in ( 'NNYYN', 'NNYYY' , 'NNYNY' )  "
		pointA = selectpoint(pidx,strwhere, 70)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End if
	    '국화부 50%
		strwhere  = "(20102) or rnkboo in ( 'YYNNN') "
		pointA = selectpoint(pidx,strwhere, 50)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End if
	    '개나리 30%
		strwhere  = "(20101) or rnkboo in ( 'YYNNN') "
		pointA = selectpoint(pidx,strwhere, 30)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End if
	
	Case 20106,20105,20107 '오픈부, 왕중왕부 지도자부
		'오픈부 100%
		strwhere  = " (20106,20105,20107)  or rnkboo in ( 'NNNYY', 'NNYYY' , 'NNNYN' ) "   'rnkboo > NNNNN 개나리, 국화, 신인 , 오픈, 베테랑(오픈 체크  NNNYY, NNYYY , NNNYN) 
		point = selectpoint(pidx,strwhere, 100)
		'베테랑 80%
		strwhere  = "(20103) or rnkboo in ( 'NNNYY', 'NNYYY' , 'NNYNY' ) "
		pointA = selectpoint(pidx,strwhere, 80)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End If
		'신인부 70%
		strwhere  ="(20104)   or rnkboo in ( 'NNYYN', 'NNYYY' , 'NNYNY' )  "
		pointA = selectpoint(pidx,strwhere, 70)
		If CDbl(pointA) > CDbl(point) Then
			point = pointA
		End if

	Case 20103 '베테랑부
		strwhere  = "(" & Left(levelno,5)& ") or rnkboo in ( 'NNNYY', 'NNYYY' , 'NNYNY' ) "
		point = selectpoint(pidx,strwhere, 100)

	Case 20102 '국화부
		strwhere  = "(20102) or rnkboo in ( 'YYNNN') "
		point = selectpoint(pidx,strwhere, 100)

	Case Else '개나리, 신인부
		strwhere  ="("& Left(levelno,5) & ")"
		point = selectpoint(pidx,strwhere, 100)
	End Select 

	setUserPoint = point

End function




strtable = "sd_TennisMember"
strtablesub =" sd_TennisMember_partner "

strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.gubun in ( 0, 1) and a.DelYN = 'N' and a.playerIDX > 1 and a.gameMemberIDX > " & midx
strfield = " a.gameMemberIDX, a.PlayerIDX,b.PlayerIDX,a.userName,b.userName "
sortstr = " order by a.gameMemberIDX asc "
SQL = " Select top 1 " & strfield & " from  " & strtable & " as a LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX where " & strwhere & sortstr
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


If rs.eof Then
	'setrnkpt 업데이트
	SQL = "update tblRGameLevel Set  setrnkpt = 'Y' where GameTitleIDX = "&tidx&" and Level = '"&levelno&"'"
	Call db.execSQLRs(SQL , null, ConStr)
	nextmidx = 0 '끝
Else
	nextmidx = rs(0)
	p1idx = rs(1)
	p2idx = rs(2)
	p1name = rs(3)
	p2name = rs(4)

	p1point = setUserPoint(levelno, p1idx)
	p2point = setUserPoint(levelno, p2idx)

	If CDbl(p1point) > 0 then
		SQL = "update sd_TennisMember set rankpoint = "&p1point&"  where gameMemberIDX = " & nextmidx
		Call db.execSQLRs(SQL , null, ConStr)
	End If
	If CDbl(p2point) > 0 then	
		SQL = "update sd_TennisMember_partner set rankpoint = "&p2point&"  where gameMemberIDX = " & nextmidx
		Call db.execSQLRs(SQL , null, ConStr)	
	End if


	'랭킹포인트 로그에 반영 (화면 호출시 생성)
	point = CDbl(p1point) + CDbl(p2point)
	SQL = "update sd_TennisScore Set rankingpoint = '"&point&"' where PlayerIDX = "&p1idx&" and partnerIDX = "&p2idx&"  and key1 = "&tidx&" and key3 = " & Left(levelno,5) & " and delYN = 'N' "
	Call db.execSQLRs(SQL , null, ConStr)

End if



'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
oJSONoutput.MIDX = nextmidx
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


Response.write  p1idx  & "----------" & p1name & " : " & p1point & " --- " & p2name & " : " & p2point  & " <br>"

db.Dispose
Set db = Nothing
%>