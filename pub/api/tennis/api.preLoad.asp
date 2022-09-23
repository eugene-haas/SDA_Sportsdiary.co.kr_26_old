<%
	idx = oJSONoutput.SCIDX

	'#################################
	Set db = new clsDBHelper

  '마지막 입력 정보 확인
  strTableName = " sd_TennisResult_record "
  strfield = " rcIDX, midx,name, skill1, skill2,skill3,servemidx,gameend,leftscore,rightscore,   setno,gameno,playsortno   "
  SQL = "Select top 1 "&strfield&"  from sd_TennisResult_record where resultIDX = " & idx & " order by rcIDX desc"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	
  If not rs.eof Then

		rcidx = rs("rcIDX")
		skill1=rs("skill1") '스킬1 득실
		skill2=rs("skill2") '스킬2 SHOT
		skill3=rs("skill3") '스킬3 COURSE
		gameend = rs("gameend")
		setno = rs("setno")
		leftscore = rs("leftscore")
		rightscore = rs("rightscore")


			If isNull(skill1) = true Then		
				SQL = "DELETE from " & strTableName &"  where rcIDX = " & rcidx
				Call db.execSQLRs(SQL , null, ConStr)

				'세트 종료 점수도 빼고
				If gameend = "1" Then
					If leftscore > rightscore Then
						SQL = "UPDATE sd_TennisResult Set  m1set"&setno&" = m1set"&setno&" - 1  where resultIDX = " & idx
						Call db.execSQLRs(SQL , null, ConStr)		
					Else
						SQL = "UPDATE sd_TennisResult Set  m2set"&setno&" = m2set"&setno&" - 1  where resultIDX = " & idx
						Call db.execSQLRs(SQL , null, ConStr)		
					End if
				End if
			Else
				If isNull(skill2) = true Then
					SQL = "UPDATE " & strTableName &" Set  skill1= null where rcIDX = " & rcidx
					Call db.execSQLRs(SQL , null, ConStr)		
				Else
					If isNull(skill3) = true Then
						SQL = "UPDATE " & strTableName &" Set  skill2= null where rcIDX = " & rcidx
						Call db.execSQLRs(SQL , null, ConStr)
					Else
						SQL = "UPDATE " & strTableName &" Set  skill3= null where rcIDX = " & rcidx
						Call db.execSQLRs(SQL , null, ConStr)
					End if
				End If

			End If

End if

'##############################
strTableName = " sd_TennisResult "
strField = " a.gameMemberIDX1, a.gameMemberIDX2, a.stateno, a.gubun,gamekey3,gamekeyname,GameTitleIDX " 'gubun 0 예선
strField = strField & " ,a.courtno,a.courtkind,a.recorderName,a.startserve,a.secondserve,a.courtmode,a.preresult,      b.setno,b.gameno,b.playsortno,b.gameend "
SQL = "Select top 1 " & strField & " from " & strTableName & " as a LEFT JOIN sd_TennisResult_record as b ON a.resultIDX = b.resultIDX where a.resultIDX = " & idx & " order by b.rcIDX desc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

courtno = rs("courtno")
courtkind = rs("courtkind")
recorderName = rs("recorderName")
serveno = rs("startserve")
serveno2 = rs("secondserve")
courtmode = rs("courtmode")
setno = rs("setno")
gameno = rs("gameno")
pointno = rs("playsortno")
gameend = rs("gameend")
preresult = rs("preresult")

If isNull(setno) = True Then
	setno = 1
End If
If isNull(gameno) = True Then
	gameno = 1
End If
If gameend = "1" Then
	gameno = CDbl(gameno) + 1
End if

If isNull(pointno) = True Then
	pointno = 0
End If


If courtno = "0" Then
	courtno = 1
	courtkind = 1
End If


Call oJSONoutput.Set("CMODE", courtmode ) '코트 모드 0 시작 1 저장완료 2 수정모드
Call oJSONoutput.Set("SERVE", serveno ) '서브위치 번호 1.2 위 3, 4 아래
Call oJSONoutput.Set("SERVE2", serveno2 ) '서브위치 번호 1.2 위 3, 4 아래
Call oJSONoutput.Set("RNM", recorderName ) '심판명칭
Call oJSONoutput.Set("CRTNO", courtno ) '코드번호
Call oJSONoutput.Set("CRTKND", courtkind ) '코트종류

Call oJSONoutput.Set("SETNO", setno ) '최종세트번호
Call oJSONoutput.Set("GAMENO", gameno ) '최종게임번호
Call oJSONoutput.Set("POINTNO", pointno ) '포인트 진행 번호
Call oJSONoutput.Set("PRERESULT", preresult ) '최종 결과 1종료 2타이브레이크
Call oJSONoutput.Set("result", "0" )


strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
db.Dispose
Set db = Nothing
%> 