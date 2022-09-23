<!-- #include virtual = "/admin/inc/header.admin.asp" -->
<%

	'코드 문자열 찾기
	function getCodeNm (kindcd,codecd)
		Dim SQL , rs
		SQL = "select codenm from tblpubcode where delkey = 0 and kindcd = "&kindcd&" and codecd = "&codecd&" "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		if rs.eof then
			getcodenm = "-"
		else
			getcodenm = rs(0)
		end if
	end function

	'범주,항목,지표수 업데이트
	sub setItemsTotal(tidx,db, Constr)
		Dim SQL,dep1,dep2,dep3
		dep1 = "(select count(evalitemidx) from tblEvalItem where delkey = 0 and EvalTableIDX = "&tidx&" and EvalCateCD > 0 and EvalSubCateCD =0 and EvalItemCD = 0)"
		dep2 = "(select count(evalitemidx) from tblEvalItem where delkey = 0 and EvalTableIDX = "&tidx&" and EvalSubCateCD > 0 and EvalItemCD = 0) "		
		dep3 = "(select count(evalitemidx) from tblEvalItem where delkey = 0 and EvalTableIDX = "&tidx&" and EvalItemCD > 0)"
		SQL = "update tblEvalTable Set EvalCateCnt ="&dep1&", EvalSubCateCnt ="&dep2&" , EvalItemCnt="&dep3&" where EvalTableidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)
	end sub


	'배점합계 업데이트
	sub setPointTotal(tidx,db, Constr)
		Dim SQL 
		'EvalGroupCD 1 가군을 기본대상으로 한다.   tblEvalItemType.EvalTypeCD < 100
		SQL = "update tblEvalTable Set TotalPoint = (Select Sum(StandardPoint) As sum_point From tblEvalItemTypeGroup Where DelKey = 0 And EvalTableIDX = "&tidx&" And EvalGroupCD=1 and EvalItemTypeIDX in ( select EvalItemTypeIDX from tblEvalItemType where DelKey = 0 And EvalTableIDX ="&tidx&" and EvalTypeCD < 100)) "
		SQL = SQL & " where EvalTableidx = " & tidx
		Call db.execSQLRs(SQL , null, ConStr)
	end sub





	If request("test") = "t" Then
		REQ ="{""CMD"":301,""PARR"":[""E"",""SW70011"",""어쩌다"",""대한민국"",""서울"",""2"",""3"",""2019/12/19"",""2019/12/11"",""짱님"",""지도자님"",""10544"",""경기 고양시 덕양구 가양대로 110 (덕은동) 여기는어디"",""07011111111"",""2019/12/11""]}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	CMD_CREATE = 100
	CMD_READ = 20000
	CMD_UPDATE = 300
	CMD_DELETE = 400
	
	CMD_EVALCODECREATE = 110
	CMD_GETITEMLIST = 21000
	
	CMD_SETTYPE = 500 '정량정성타입체크
	CMD_SETPOINT = 510 '기준점수설정
	CMD_EVALMEMBERWINDOW = 50000
	CMD_SETMEMBER = 51000
	CMD_DELMEMBER = 52000	
	CMD_DELMITEM = 410	
	CMD_SETORDER = 310
	CMD_SETORDER1 = 320
	CMD_SETORDER2 = 330	
	CMD_GRPTOTAL = 220
	CMD_ITEMNMUPDATE = 340

	Select Case CDbl(CMD)

	'#################etc
		Case CMD_SETTYPE
			%><!-- #include virtual = "/api/ajax/evalmaker/api.settype.evalmaker.asp" --><%
			Response.end	
		Case CMD_SETPOINT
			%><!-- #include virtual = "/api/ajax/evalmaker/api.setpoint.evalmaker.asp" --><%
			Response.end	
		Case CMD_EVALMEMBERWINDOW
			%><!-- #include virtual = "/api/ajax/evalmaker/api.evalmemberwindow.evalmaker.asp" --><%
			Response.end			
		Case CMD_SETMEMBER
			%><!-- #include virtual = "/api/ajax/evalmaker/api.setmember.evalmaker.asp" --><%
			Response.end
		Case CMD_DELMEMBER
			%><!-- #include virtual = "/api/ajax/evalmaker/api.delmember.evalmaker.asp" --><%
			Response.end			

	'#################delete
		Case CMD_DELMITEM
			%><!-- #include virtual = "/api/ajax/evalmaker/api.delitem.evalmaker.asp" --><%
			Response.end			



	'#################create
		Case CMD_EVALCODECREATE
			%><!-- #include virtual = "/api/ajax/evalmaker/api.codecreate.evalmaker.asp" --><%
			Response.end	
		
		Case CMD_CREATE
			%><!-- #include virtual = "/api/ajax/evalmaker/api.create.evalmaker.asp" --><%
			Response.end

	'#################read
		Case CMD_GRPTOTAL
			%><!-- #include virtual = "/api/ajax/evalmaker/api.grptotal.evalmaker.asp" --><%
			Response.end

		Case CMD_READ
			%><!-- #include virtual = "/api/ajax/evalmaker/api.read.evalmaker.asp" --><%
			Response.end

		Case CMD_GETITEMLIST
			%><!-- #include virtual = "/api/ajax/evalmaker/api.itemread.evalmaker.asp" --><%
			Response.end

		Case CMD_SETORDER
			%><!-- #include virtual = "/api/ajax/evalmaker/api.setorder.evalmaker.asp" --><%
			Response.end
		Case CMD_SETORDER1
			%><!-- #include virtual = "/api/ajax/evalmaker/api.setorder1.evalmaker.asp" --><%
			Response.end
		Case CMD_SETORDER2
			%><!-- #include virtual = "/api/ajax/evalmaker/api.setorder2.evalmaker.asp" --><%
			Response.end						

		Case CMD_ITEMNMUPDATE
			%><!-- #include virtual = "/api/ajax/evalmaker/api.itemupdate.evalmaker.asp" --><%
			Response.end	

CMD_SETORDER

	End Select
%>
