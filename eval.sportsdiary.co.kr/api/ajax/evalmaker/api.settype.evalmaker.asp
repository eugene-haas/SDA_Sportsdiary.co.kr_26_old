<%
'#############################################

'itemtype 저장    (tblEvalItemType)
'item group 저장 (tblEvalItemTypeGroup)

'#############################################
	'request
	idx = oJSONoutput.get("IDX") 'evalitem 3댑스 인덱스
	chkYN = oJSONoutput.get("CHK") '체크여부 YN

	typeno = oJSONoutput.get("TYPENO") 'tblpubcode.kindcd 1 평가타입(정성,정량)
	gunno = oJSONoutput.get("GUNNO") 	'tblpubcode,kindcd 2 평가군(가,나..)
	resetjudge = "N" '심판초기화


	Set db = new clsDBHelper 


	'3단계
	fld = " EvalItemIDX , EvalTableIDX,  EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,  RegYear, (select editmode from tblEvalTable where evaltableidx = a.evaltableidx ),orderno "
	SQL = "Select "&fld&" from tblEvalItem as a where  EvalItemIDX = " & idx
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
	editmode = rs(9)
	orderno = rs(10)

	'수정모드 확인
	Call chkEndMode(EvalTableIDX, oJSONoutput,db,ConStr)


	typestr = getCodeNm(1, typeno) '1인경우 모두 제거된 상태라면 평가자도 제거한다.
	gunstr = getCodeNm(2, gunno)	
	
	
	
	SQL = "select evalitemtypeidx from tblEvalItemType where delkey= 0 and evalitemidx = " & idx & " and evaltypecd = " & typeno
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	if rs.eof then '정량,정성,감점...아직생성된게 없다면 처음클릭인경우
		if chkYN = "Y" then
			insertfld = "EvalTableIDX,EvalItemIDX,EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,EvalTypeCD,EvalTypeNm,          CateOrderNo,SubCateOrderNo,itemorderno"
	
	
	
			sort1query = "select orderno from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&" and EvalSubCateCD = 0 and EvalCateCD = " & EvalCateCD
			sort2query = "select orderno from tblEvalItem where delkey = 0 and EvalTableIDX = "&EvalTableIDX&" and EvalCateCD = "&EvalCateCD&" and EvalSubCateCD = "&EvalSubCateCD&" and EvalItemCD = 0 "
			selectfld = "EvalTableIDX,EvalItemIDX,EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm,"&typeno&", '"&typestr&"',      ("&sort1query&"),("&sort2query&"), orderno "		
			
			SQL = "SET NOCOUNT ON "
			SQL = SQL & " insert into tblEvalItemType ("&insertfld&") (select "&selectfld&" from tblEvalItem where EvalItemIDX = " & idx & ")"
			SQL = SQL & "  SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			evalitemtypeidx = rs(0)
		else
			'이런경우는 없어야하고
		end if
	else
		evalitemtypeidx = rs(0)

		if chkYN = "Y" then '있음 머 그냥 다음꺼 하면됨...
		Else
		


			'실지 들어간 값들도 삭제한다.
				SQL = "update tblEvalValue Set delkey = 1 where EvalTableIDX = "&EvalTableIDX&" and  evalitemidx  = "&idx&"  and evalitemtypeidx = " & evalitemtypeidx  '모든 협회,단체 내용 삭제
				Call db.execSQLRs(SQL , null, ConStr)

				SQL = "update tblEvalDesc Set delkey = 1 where EvalTableIDX = "&EvalTableIDX&" and  evalitemidx  = "&idx&" and evalitemtypeidx = " & evalitemtypeidx  '모든 협회,단체 내용 삭제
				Call db.execSQLRs(SQL , null, ConStr)

				'Call oJSONoutput.Set("sql", sql )
			'실지 들어간 값들도 삭제한다.



			'그룹이 없는지 아래에서 판단하여 지우자.
			'SQL = "update tblEvalItemType set delkey= 1 where evalitemidx = " & idx & " and evaltypecd = " & typeno
			'Call db.execSQLRs(SQL , null, ConStr)
		end if
	end if

	
	

	SQL = "select EvalItemTypeGroupIDX from tblEvalItemTypeGroup where delkey= 0 and EvalItemTypeIDX = " & evalitemtypeidx & " and EvalGroupCD = " & gunno
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	if rs.eof then '타입에 그룹추엄생성.
		if chkYN = "Y" then
			insertfld = " EvalTableIDX,EvalItemIDX,EvalItemTypeIDX,EvalGroupCD,EvalGroupNm " 
			selectfld = "EvalTableIDX,EvalItemIDX,"&evalitemtypeidx&","&gunno&", '"&gunstr&"' "
			SQL = "insert into tblEvalItemTypeGroup ("&insertfld&") (select "&selectfld&" from tblEvalItem where EvalItemIDX = " & idx & ")	"
			Call db.execSQLRs(SQL , null, ConStr)
		end if
	
	else
		if chkYN = "Y" then
			'넣을려고 하는애가 있어 그럼 패스 (안와야함.)
		else
			'우선지우고 
			EvalItemTypeGroupIDX = rs(0)
			SQL = " update tblEvalItemTypeGroup set delkey= 1 where EvalItemTypeGroupIDX = " & EvalItemTypeGroupIDX
			Call db.execSQLRs(SQL , null, ConStr)
			
			'지울려고 하는데 만약에 가나다라마몽땅없다면
			SQL = "select EvalItemTypeIDX from tblEvalItemTypeGroup where delkey= 0 and EvalItemTypeIDX = " & evalitemtypeidx 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			
			if rs.eof then
				SQL = " update tblEvalItemType set delkey= 1 where EvalItemTypeIDX = " & EvalItemTypeIDX
				
				'정량이라면 설정된 심판도 제거
				i'f Cstr(typeno) = "1" then
					resetjudge = "Y" '심판초기화
					SQL = SQL & "update tblEvalMember set delkey = 1 where delkey = 0 and EvalItemTypeIDX = " & EvalItemTypeIDX	
				'end if
				Call db.execSQLRs(SQL , null, ConStr)

			end if
		end if
	end if

	
	
	Call oJSONoutput.Set("resetjudge", resetjudge )
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>