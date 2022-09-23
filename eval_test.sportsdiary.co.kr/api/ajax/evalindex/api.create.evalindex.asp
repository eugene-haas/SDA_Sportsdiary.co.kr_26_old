<%
'#############################################
'저장
'#############################################
	'request
		regyear = oJSONoutput.get("REGYEAR")

	Set db = new clsDBHelper 

		'년도의 tblEvalTable 최고값 +1 해서 tblEvalTable 인서트한다.
		SQL = "SET NOCOUNT ON "
		SQL = SQL & "insert into tblEvalTable (EvalTitle,YearOrder,RegYear) values ('"&regyear& " 혁신 평가" &"', (select isNull(max(YearOrder),0)+1 from tblEvalTable where regYear = "&regyear&" and delkey = 0),"&regyear&" )"
		SQL = SQL & "  SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		EvalTableIDX = rs(0)

		'종목단체sub 복사 (바로 이전 max(최상의 idx) )
		SQL = "select top 1 EvalTableIDX from tblAssociation_sub order by AssociationIDX desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
		if not rs.eof then
			infld = " AssociationIDX, "&EvalTableIDX&", AssociationNm,EvalGroupCD,EvalGroupNm,MemberGroupCD,MemberGroupNm,"&regyear&" "
			SQL = " insert into tblAssociation_sub (AssociationIDX, EvalTableIDX, AssociationNm,EvalGroupCD,EvalGroupNm,MemberGroupCD,MemberGroupNm,RegYear) "
			SQL = SQL & " (select "&infld&" from tblAssociation_sub where delkey = 0 and EvalTableIDX = (select max(EvalTableIDX) from tblAssociation_sub where delkey = 0 and EvalTableIDX < "&EvalTableIDX&")) " 
			Call db.execSQLRs(SQL , null, ConStr)
		
		else
			infld = " AssociationIDX, "&EvalTableIDX&", AssociationNm,1,'가',1,'정회원',"&regyear&" "
			SQL = " insert into tblAssociation_sub (AssociationIDX, EvalTableIDX, AssociationNm,EvalGroupCD,EvalGroupNm,MemberGroupCD,MemberGroupNm,RegYear) "
			SQL = SQL & " (select "&infld&" from tblAssociation where delkey = 0 ) " 
			Call db.execSQLRs(SQL , null, ConStr)		
		end if


' response.write Sql
' response.end

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


		Set rs = Nothing
		db.Dispose
		Set db = Nothing
%>