<%
'#############################################
'수정
'#############################################
	'request
	newcodenmstr = oJSONoutput.Get("DEPNM")
	n_menuno = oJSONoutput.Get("MENUNO")

	Set reqArr = oJSONoutput.get("PARR") 
	n_EvalCateCD 	= reqArr.Get(0)
	n_EvalSubCateCD = reqArr.Get(1)
	n_p_EvalItemCD = reqArr.Get(2)

	Set db = new clsDBHelper

	'이름이 같은게 있는지 검사
	select case n_menuno 
	case "1" 
		SQL = "Select EvalCateNm from tblEvalCode where delkey = 0 and EvalCateNm = '"&newcodenmstr&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	case "2"
		SQL = "Select EvalCateNm from tblEvalCode where delkey = 0 and EvalCateCD = "&n_EvalCateCD&" and EvalSubCateNm = '"&newcodenmstr&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	case "3"
		SQL = "Select EvalCateNm from tblEvalCode where delkey = 0 and EvalCateCD = "&n_EvalCateCD&" and EvalSubCateCD = "&n_EvalSubCateCD&" and EvalSubCateNm = '"&newcodenmstr&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	end select	
	
	if not rs.eof then
		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", "동일한 지표항목이 존재합니다." ) '중복
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End			
	end if

	select case n_menuno 
	case "1" 
		SQL = "Insert into tblEvalCode (EvalCateCD,EvalCateNm ) "
		SQL = SQL & " (Select isnull(max(EvalCateCD),0) + 1,'"&newcodenmstr&"' from tblEvalCode where delkey = 0 and EvalSubCateCD = 0) "

	case "2"
		fld = "top 1 EvalCateCD, EvalCateNm,EvalSubCateCD + 1,'"&newcodenmstr&"'"
		SQL = " Select "&fld&" from tblEvalCode where delkey = 0 and EvalCateCD = "&n_EvalCateCD&" and EvalItemCD = 0 order by EvalSubCateCD desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		SQL = " Insert into tblEvalCode (EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm ) values ("&rs(0)&",'"&rs(1)&"',"&rs(2)&",'"&rs(3)&"') "

	case "3"
		fld = "top 1 EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm, EvalItemCD + 1,'"&newcodenmstr&"'"
		SQL = " Select "&fld&" from tblEvalCode where delkey = 0 and  EvalCateCD = "&n_EvalCateCD&" and EvalSubCateCD = "&n_EvalSubCateCD&" order by EvalItemCD desc"
		
		' response.write SQL
		' response.end		
		
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)			

		SQL = "Insert into tblEvalCode (EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm ) values ("&rs(0)&",'"&rs(1)&"',"&rs(2)&",'"&rs(3)&"',"&rs(4)&",'"&rs(5)&"')"
		' response.write SQL
		' response.end

	end select	
	Call db.execSQLRs(SQL , null, ConStr)

	if n_menuno = "1" then
		oJSONoutput.MENUNO = ""
	else
		oJSONoutput.MENUNO = n_menuno - 1
	end if
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
