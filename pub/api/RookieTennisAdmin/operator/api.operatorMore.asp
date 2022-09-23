<%
	'request
	pageno = oJSONoutput.NKEY

	Set db = new clsDBHelper

	intPageNum = pageno
	intPageSize = 20

	strTableName = " tblGameManager "
	strFieldName = " idx,SportsGb,HostCode,ManagerName,ManagerID,WritePwd,Gubun,WriteDate "

	strSort = "  ORDER By idx Desc"
	strSortR = "  ORDER By  idx Asc"
	'strWhere = " SportsGb = 'tennis' and  DelYN = 'N' "
	strWhere = "  DelYN = 'N' "

	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )


	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )

If CDbl(pageno) > CDbl(intTotalPage) Then
	lastpage = "_end"
Else
	lastpage = "_ing"
End if

'타입 석어서 보내기
Call oJSONoutput.Set("debug", intPageNum  & intTotalPage)

Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("lastchk", lastpage )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

  db.Dispose
  Set db = Nothing

i = 0
	passstar = "*******************************************"
'	strFieldName = " idx,SportsGb,HostCode,ManagerName,ManagerID,WritePwd,Gubun,WriteDate "
If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
		idx = arrRS(0, ar) 
		admin_title = arrRS(3, ar) 
		admin_id =	 arrRS(4, ar) 
		admin_pwd = arrRS(5, ar) 
		writeday =	 Left(arrRS(7, ar) ,10)
	%>
		<!-- #include virtual = "/pub/html/RookietennisAdmin/operator/html.operatorList.asp" -->
	<%
	i = i + 1
	Next
End if
%>