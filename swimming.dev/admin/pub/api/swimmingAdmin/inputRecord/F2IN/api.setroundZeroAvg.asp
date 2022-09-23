<%
'#############################################
' 심판재량으로 0점처리된것들을 나머지 점수준것들로 평균해서 넣어준다.
'#############################################
	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	roundno = oJSONoutput.Get("RNO") '라운드
	
  CDA = "F2" '다이빙

	Set db = new clsDBHelper


		'기본정보 호출
		booinfo = getBooInfo(lidx, db, ConStr, CDA)

		grouplevelidx = booinfo(0) 
		RoundCnt =  booinfo(1)
		judgeCnt =  7 '피겨
		lidxs = booinfo(3)
		cdc = booinfo(4)

		'예외처리
    '체점이 완료되었는지 확인한다.
		Call judgeExceptionRound(midx,roundno , db, ConStr, CDA) '체점완료여부

		'점수들 필드
    For i = 1 To judgeCnt
      If i = 1 then
        fld = " max(jumsu"&i&") as jumsu"&i&" "
      Else
        fld = fld & " , max(jumsu"&i&") as jumsu"&i&" "
      End If
    next

		SQL = "select "&fld &" from sd_gameMember_roundRecord where  midx  = "&midx&"  and gameround = "&roundno&" "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    
    total = 0
    nozeromembercnt = 0
    If Not rs.EOF Then
			arrR = rs.GetRows()
        for f = 0 to judgeCnt -1
          jumsu  = arrR(f, 0)

          if Cdbl(jumsu) > 0 then
            total = total + Cdbl(jumsu)
            nozeromembercnt = nozeromembercnt + 1
          else
            if zeromembernostr = "" then
              zeromembernostr = "jumsu" & Cdbl(f)+1 & "= "
            else
              zeromembernostr = zeromembernostr & ",jumsu" & Cdbl(f)+1 & "= "
            end if
          end if
        next
    end if 
    'Call oJSONoutput.Set("zeromembernostr", zeromembernostr )

    if Cdbl(nozeromembercnt) >= Cdbl(judgeCnt) then
          Call oJSONoutput.Set("result", 111 ) '서버에서 메시지 생성 전달
					Call oJSONoutput.Set("servermsg", "0점 채점이 없습니다." ) '서버에서 메시지 생성 전달
					strjson = JSON.stringify(oJSONoutput)
					Response.Write strjson
					Response.end    
    end if

    '평균
    zeroavg = FormatNumber(total / nozeromembercnt,0, 0,0,0)


    updatefld = replace(zeromembernostr,",", zeroavg  & "," )
    updatefld = updatefld & zeroavg

    SQL = "Update sd_gameMember_roundRecord set "&updatefld&" where  midx  = "&midx&"  and gameround = "&roundno&"  "
		Call db.execSQLRs(SQL , null, ConStr)
  	'Call oJSONoutput.Set("sql", sql )

	'결과체크및 결과반영 순위생성 totalscore 다시계산해서 넣는다.
	Call setGameResut(lidx, midx, roundno, db, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
