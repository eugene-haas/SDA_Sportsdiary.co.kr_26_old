<%
'#############################################
' 라운드 실격 처리
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	roundno = oJSONoutput.Get("RNO") '라운드
	btnstate = oJSONoutput.Get("BTNST") '보낼때 버튼상태
	CDA = "F2" '아티스틱

	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  booinfo(2)
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'예외처리
		'Call judgeExceptionEnd(tidx,judgeCnt,RoundCnt,lidxs,chkpass , db, ConStr, CDA) '체점여부

		'사용자가 보고 보낼당시 상황에 맞추어서 처리

		'a_totaldeduction = arrR(67, ari) '아티스틱 총점에서 감점
		'a_eletotaldeduction = arrR(68, ari) '엘리먼트총점에서 감점
		'a_elededuction  = arrR(69, ari)'각엘리먼트에서 감점

		If btnstate = "default" then
			SQL = "Update sd_gameMember_roundRecord set r_out = 1 , judgeendcnt = "&judgeCnt&"  where  midx  = "&midx&"  and gameround = "&roundno&"  "
		Else
			fld = "idx, isnull(jumsu1,0),isnull(jumsu2,0),isnull(jumsu3,0),isnull(jumsu4,0),isnull(jumsu5,0),isnull(jumsu6,0),isnull(jumsu7,0),isnull(jumsu8,0),isnull(jumsu9,0),isnull(jumsu10,0),isnull(jumsu11,0),isnull(jumsu12,0),isnull(jumsu13,0),isnull(jumsu14,0),isnull(jumsu15,0)"
			SQL = "Select "&fld&" from sd_gameMember_roundRecord where  midx  = "&midx&"  and gameround = "&roundno&"  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				jchkcnt = 0
				For j = 1 To judgeCnt
					If CDbl(rs(j)) > 0 Then
						jchkcnt = jchkcnt + 1
					End if
				Next
			End if
			SQL = "Update sd_gameMember_roundRecord set r_out = 0 , judgeendcnt = "&jchkcnt&"  where  midx  = "&midx&"  and gameround = "&roundno&"  "
		End If
		Call db.execSQLRs(SQL , null, ConStr)


		'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
		Call setGameResut(lidx, midx, roundno, db, ConStr)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
