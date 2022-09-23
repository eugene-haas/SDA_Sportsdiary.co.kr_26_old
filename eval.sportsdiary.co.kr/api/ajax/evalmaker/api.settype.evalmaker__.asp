<%
'#############################################

'itemtype 저장    (tblEvalItemType)
'item group 저장 (tblEvalItemTypeGroup)

'#############################################
	'request
	idx = oJSONoutput.get("IDX") 'evalitem 3댑스 인덱스
	chk = oJSONoutput.get("CHK") '체크여부 YN

	typeno = oJSONoutput.get("TYPENO") 'tblpubcode.kindcd 1 평가타입
	gunno = oJSONoutput.get("GUNNO") 	'tblpubcode,kindcd 2 평가군

	Set db = new clsDBHelper 

	'평가

	'3단계
	fld = " EvalItemIDX , EvalTableIDX,  EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,  RegYear "
	SQL = "Select "&fld&" from EvalItemIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	EvalItemIDX = rs(0)
	EvalTableIDX = rs(1)
	EvalCateCD = rs(2)
	EvalCateNm = rs(3)
	EvalSubCateCD = rs(4)
	EvalSubCateNm = rs(5)
	EvalItemCD = rs(6)
	EvalItemNm = rs(7)
	RegYear = rs(8)

	SQL = ""
	SQL = SQL & " if not exists ( "
	SQL = SQL & " (select evalitemtypeidx from tblEvalItemType where evalitemidx = " & idx & " and evaltypecd = " & typeno & ") "




		' '1 #######################
		' infld = " EvalTableIDX,  EvalCateCD,EvalCateNm,  RegYear "
		' inSQL = "Select top 1 "&EvalTableIDX&", EvalCateCD,EvalCateNm,"&RegYear&" from tblEvalCode "
		' inSQL = inSQL & " where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = "&EvalItemCD&" "

		' SQL = " if not exists ( Select EvalItemIDX from tblEvalItem where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = 0 ) "
		' SQL = SQL & " begin Insert into tblEvalItem ("&infld&") ("&inSQL&") end "		

		' '2 #######################
		' infld = " EvalTableIDX,  EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,  RegYear "
		' inSQL = "Select top 1 "&EvalTableIDX&", EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,"&RegYear&" from tblEvalCode "
		' inSQL = inSQL & " where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = "&EvalItemCD&" "

		' SQL = SQL & " if not exists ( Select EvalItemIDX from tblEvalItem where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = 0 ) "
		' SQL = SQL & " begin Insert into tblEvalItem ("&infld&") ("&inSQL&") end "

		' '3 #######################
		' infld = " EvalTableIDX,  EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,  RegYear "
		' inSQL = "Select top 1 "&EvalTableIDX&", EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,"&RegYear&" from tblEvalCode "
		' inSQL = inSQL & " where delkey = 0 and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = "&EvalItemCD&" "

		' SQL = SQL & "Insert into tblEvalItem ("&infld&") ("&inSQL&")"
	
		' Call db.execSQLRs(SQL , null, ConStr)

'response.write "--------------------"

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>