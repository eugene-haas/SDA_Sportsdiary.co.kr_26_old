<%
	'request
	pageno = oJSONoutput.NKEY
	findTYPE = oJSONoutput.findTYPE
	findSido = oJSONoutput.findSido
	fndSTR = oJSONoutput.fndSTR

	Set db = new clsDBHelper

	intPageNum = pageno
	intPageSize = 100
	strTableName = " tblTeamInfo "
    strFieldName = " ROW_NUMBER() OVER(ORDER BY TeamIDX ) num ,TeamIDX,Team,TeamNm,dbo.FN_SidoName(sido,'judo')sido,TeamTel,ZipCode,Address,AddrDtl,TeamLoginPwd ,dbo.FN_TeamCnt(Team,SportsGb) TeamPlayerCnt"

	strSort = "  order by TeamNm asc"
	strSortR = "  order by TeamNm desc"
        

	'search
    strWhere = " SportsGb = 'tennis' and DelYN = 'N' "

    if fndSTR <> "" then
	    Select Case findTYPE
	    Case "s_team"	'팀명
		    strWhere = strWhere&" and TeamNm like '%"&fndSTR&"%' "	
	    Case "s_phone"	'연락처
		    strWhere = strWhere&" and TeamTel like '%"&fndSTR&"%'"	
	    End Select
    end if 

    if findSido <> "" then
        strWhere = strWhere&" and sido = '"&findSido&"' "
    end if 

	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if

'	If rowcnt = "" Then
'		If IsArray(arrRS)  Then
'			rowcnt = UBound(arrRS, 2) -1
'		Else
'			rowcnt = 0
'		End if
'	End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )

If CDbl(pageno) > CDbl(intTotalPage) Then
	lastpage = "_end"
Else
	lastpage = "_ing"
End if



'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("lastchk", lastpage )
Call oJSONoutput.Set("totalcnt", intTotalCnt )
Call oJSONoutput.Set("totalpage", intTotalPage )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

  db.Dispose
  Set db = Nothing
%>



<%
i = 0
If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
		num = arrRS(0, ar) 
		TeamIDX = arrRS(1, ar) 
		Team = arrRS(2, ar) 
		TeamNm = arrRS(3, ar) 
		sido = arrRS(4, ar) 
		TeamTel = arrRS(5, ar) 
		ZipCode = arrRS(6, ar) 
		Address = arrRS(7, ar) 
		AddrDtl = arrRS(8, ar) 
		TeamLoginPwd = arrRS(9, ar)  
		TeamPlayerCnt = arrRS(10, ar)  
	%>
	<!-- #include virtual = "/pub/html/swimAdmin/Teaminfolist.asp" -->
	<%
	i = i + 1
	Next
End if
%>