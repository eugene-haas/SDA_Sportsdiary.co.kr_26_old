<%
	'request
	pageno = oJSONoutput.NKEY

	Set db = new clsDBHelper

	intPageNum = pageno
	intPageSize = 20

	strTableName = " tblGameHost "
	strFieldName = " idx,hostname,hostimg,makegamecnt,writedate,SportsGb "

	strSort = "  ORDER By idx Desc"
	strSortR = "  ORDER By  idx Asc"
	strWhere = " SportsGb = 'tennis' and  DelYN = 'N' "

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
'	idx,hostname,hostimg,makegamecnt,writedate,SportsGb
If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
		idx = arrRS(0, ar) 
		hostname = arrRS(1, ar) 
		hostimg =	 arrRS(2, ar) 
		makegamecnt = arrRS(3, ar) 
		writeday =	 Left(arrRS(4, ar) ,10)
	%>
	<!-- #include virtual = "/pub/html/swimAdmin/gamehost/html.GameHostList.asp" -->
	<%
	i = i + 1
	Next
End if
%>