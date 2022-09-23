<%
'#############################################

'대회생성저장

'#############################################
	'request
	Set reqArr = oJSONoutput.get("PARR") 
	EvalTableIDX = oJSONoutput.get("TIDX") 'EvalTableIDX

	Set db = new clsDBHelper 

		'수정모드 확인
		Call chkEndMode(EvalTableIDX, oJSONoutput,db,ConStr)


		EvalCateCD 	= reqArr.Get(0)
		EvalSubCateCD = reqArr.Get(1)
		EvalItemCD = reqArr.Get(2)

		SQL = "Select RegYear from tblEvalTable where EvalTableIDX = " & EvalTableIDX
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		RegYear = rs(0)

	
		'3댑스 동일 항목 존재여부체크
		SQL = "Select EvalItemidx from tblEvalItem where "
		SQL = SQL & " delkey = 0 and EvalTableIDX = "&EvalTableIDX&" and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = "&EvalItemCD
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		if not rs.eof then
			Call oJSONoutput.Set("result", 111 )
			Call oJSONoutput.Set("servermsg", "동일한 지표항목이 존재합니다." ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.End			
		end if



		'1 #######################
		infld = " EvalTableIDX,  EvalCateCD,EvalCateNm,  RegYear ,orderno "
		
		orderno = "select isNull(max(orderno),0) + 1 from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&" and EvalSubCateCD = 0 "

		inSQL = "Select top 1 "&EvalTableIDX&", EvalCateCD,EvalCateNm,"&RegYear&", ("&orderno&") from tblEvalCode  "
		inSQL = inSQL & " where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = "&EvalItemCD&" "

		SQL = " if not exists ( Select EvalItemIDX from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&"  and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = 0 ) "
		SQL = SQL & " begin Insert into tblEvalItem ("&infld&") ("&inSQL&") end "

		'2 #######################
		infld = " EvalTableIDX,  EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,  RegYear, orderno "
		
		orderno = "select isNull(max(orderno),0) + 1 from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&" and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD > 0 and EvalItemCD = 0 "
		
		inSQL = "Select top 1 "&EvalTableIDX&", EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,"&RegYear&",("&orderno&") from tblEvalCode "
		inSQL = inSQL & " where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = "&EvalItemCD&" "

		SQL = SQL & " if not exists ( Select EvalItemIDX from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&"  and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = 0 ) "
		SQL = SQL & " begin Insert into tblEvalItem ("&infld&") ("&inSQL&") end "

		'3 #######################
		infld = " EvalTableIDX,  EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,  RegYear, orderno "
		
		orderno = "select isNull(max(orderno),0) + 1 from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&" and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and  EvalItemCD > 0 "
		
		inSQL = "Select top 1 "&EvalTableIDX&", EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,"&RegYear&",("&orderno&") from tblEvalCode "
		inSQL = inSQL & " where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = "&EvalItemCD&" "

		SQL = SQL & "Insert into tblEvalItem ("&infld&") ("&inSQL&")"
		'call oJSONoutput.Set("aaa", sql )
		Call db.execSQLRs(SQL , null, ConStr)



	'항목카운트 총합 저장
	call setItemsTotal(EvalTableIDX,db, Constr)

'response.write "--------------------"
		Call oJSONoutput.Set("EvalTableIDX", EvalTableIDX )		
		Call oJSONoutput.Set("F1", EvalCateCD )
		Call oJSONoutput.Set("F2", EvalSubCateCD )
		Call oJSONoutput.Set("F3", EvalItemCD )				
		Call oJSONoutput.Set("RegYear", RegYear )						

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>