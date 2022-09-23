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


strtable = "sd_TennisMember"
strtablesub =" sd_TennisMember_partner "

strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and a.gubun in ( 0, 1) and a.DelYN = 'N' and a.playerIDX > 1 and a.gameMemberIDX > " & midx
strfield = " a.gameMemberIDX, a.PlayerIDX,b.PlayerIDX,a.userName,b.userName "
sortstr = " order by a.gameMemberIDX asc "
SQL = " Select top 1 " & strfield & " from  " & strtable & " as a LEFT JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX where " & strwhere & sortstr
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

ss = sql

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

	'부명칭에 따라 포인트 부여하는작업 해야함...
	rankpointpass = false
	Select Case CDbl(Left(levelno,5))
	Case 20109,20108  '가족부,혼합복식 이벤트성 포인트인것
		rankpointpass = true
	Case 20106,20105,20107 '오픈부, 왕중왕부 지도자부
		Whereteamgb  = " (20106,20105,20107)  or rnkboo in ( 'NNNYY', 'NNYYY' , 'NNNYN' ) "   'rnkboo > NNNNN 개나리, 국화, 신인 , 오픈, 베테랑(오픈 체크  NNNYY, NNYYY , NNNYN)  
	Case 20103 '베테랑부
		Whereteamgb  = "(" & Left(levelno,5)& ") or rnkboo in ( 'NNNYY', 'NNYYY' , 'NNYNY' ) "
	Case 20102 '국화부
		Whereteamgb  = "(20102) or rnkboo in ( 'YYNNN') "
	Case Else '개나리, 신인부
		Whereteamgb  ="("& Left(levelno,5) & ")"
	End Select 


	If rankpointpass = False Then
		'부의 15개 포인트를 가져온다.
		SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y'  and  PlayerIDX = "&p1idx&" and teamGb in "&Whereteamgb&" order by getpoint desc )"
		Set rs1 = db.ExecSQLReturnRS(SQL , null, ConStr)

		If isNull(rs1(0)) = true Then
			p1point = 0
		Else
			p1point = rs1(0)
			SQL = "update sd_TennisMember set rankpoint = "&p1point&"  where gameMemberIDX = " & nextmidx
			csql = sql
			Call db.execSQLRs(SQL , null, ConStr)
		End if

		SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where ptuse= 'Y'  and PlayerIDX = "&p2idx&" and teamGb in "&Whereteamgb&" order by getpoint desc )"
		Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)

		If isNull(rs2(0)) = true Then
			p2point = 0
		Else
			p2point = rs2(0)
			SQL = "update sd_TennisMember_partner set rankpoint = "&p2point&"  where gameMemberIDX = " & nextmidx
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	Else
			
			'부의 15개 포인트를 가져온다.
			SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y'  and  PlayerIDX = "&p1idx&"  order by getpoint desc )"
			Set rs1 = db.ExecSQLReturnRS(SQL , null, ConStr)

			If isNull(rs1(0)) = true Then
				p1point = 0
			Else
				p1point = rs1(0)
				SQL = "update sd_TennisMember set rankpoint = "&p1point&"  where gameMemberIDX = " & nextmidx
				csql = sql
				Call db.execSQLRs(SQL , null, ConStr)
			End if

			SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where ptuse= 'Y'  and PlayerIDX = "&p2idx&" order by getpoint desc )"
			Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)

			If isNull(rs2(0)) = true Then
				p2point = 0
			Else
				p2point = rs2(0)
				SQL = "update sd_TennisMember_partner set rankpoint = "&p2point&"  where gameMemberIDX = " & nextmidx
				Call db.execSQLRs(SQL , null, ConStr)
			End If			

			'p1point = 0	
			'p2point = 0
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

If rankpointpass = False Then
	'Response.write  p1idx  & "----------" & p1name & " : " & p1point & " --- " & p2name & " : " & p2point  & " --- " & csql &  "<br>"
	Response.write  p1idx  & "----------" & p1name & " : " & p1point & " --- " & p2name & " : " & p2point  & "<br>"
Else
	Response.write  "이벤트 대회 > " & p1idx  & "----------" & p1name & " : " & p1point & " --- " & p2name & " : " & p2point  & "<br>"
	'Response.write  "이벤트 대회 <br>"
End if


db.Dispose
Set db = Nothing
%>