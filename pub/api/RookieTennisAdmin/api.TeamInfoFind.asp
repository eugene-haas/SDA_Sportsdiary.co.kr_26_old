<%
	'request
	pageno = oJSONoutput.NKEY
	findTYPE = oJSONoutput.findTYPE
	findSido = oJSONoutput.findSido
	fndSTR = oJSONoutput.fndSTR

	Set db = new clsDBHelper

	intPageNum = pageno
	intPageSize = 10
	strTableName = " tblTeamInfo "
	strFieldName = " TeamIDX,Team,TeamNm,sido,TeamTel,ZipCode,Address,AddrDtl,TeamLoginPwd "

	strSort = "  order by TeamIDX desc "
	strSortR = "  order by TeamIDX "

	'search
	Select Case findTYPE
	Case "s_team"	'팀명
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and TeamNm like '%"&fndSTR&"%' "	
	Case "s_phone"	'연락처
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and TeamTel like '%"&fndSTR&"%'"	
	End Select
    
    if findSido <> "" then
        strWhere = strWhere&" and sido = '"&findSido&"' "
    end if 

	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )

If CDbl(pageno) >= CDbl(intTotalPage) Then
	lastpage = "_end"
Else
	lastpage = "_ing"
End if

'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("lastchk", lastpage )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

  db.Dispose
  Set db = Nothing

i = 0
If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

        TeamIDX = arrRS(0, ar) 
		Team = arrRS(1, ar) 
		TeamNm = arrRS(2, ar) 
		sido = arrRS(3, ar) 
		TeamTel = arrRS(4, ar) 
		ZipCode = arrRS(5, ar) 
		Address = arrRS(6, ar) 
		AddrDtl = arrRS(7, ar) 
		TeamLoginPwd = arrRS(8, ar)  
	%>
	<!-- #include virtual = "/pub/html/RookietennisAdmin/Teaminfolist.asp" -->
	<%
	i = i + 1
	Next
End if
%>