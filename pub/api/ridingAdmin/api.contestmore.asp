<%
	'request
	pageno = oJSONoutput.NKEY

	Set db = new clsDBHelper

	intPageNum = pageno
	intPageSize = 20
	strTableName = " sd_TennisTitle "
	strFieldName = " GameTitleIDX,gameTitleName, GameS,GameE,GameYear,cfg, GameRcvDateS,GameRcvDateE, ViewYN,MatchYN,viewState, stateNo,titlecode,titlegrade,vacReturnYN "
	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"

	strWhere = " DelYN = 'N' "
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10

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
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("lastchk", lastpage )
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

		idx = arrRS(0, ar) 
		title = arrRS(1, ar) 
		sdate = arrRS(2, ar) 
		edate = arrRS(3, ar) 
		gameyear = arrRS(4, ar)  
		gamecfg = arrRS(5, ar) 
		rcvs = arrRS(6, ar) 
		rcve = arrRS(7, ar) 

		ViewYN = arrRS(8, ar) 
		MatchYN = arrRS(9, ar) 
		viewState = arrRS(10, ar) 

		titleCode = arrRS(12, ar) 
		titleGrade = findGrade(arrRS(13, ar))
		vacReturnYN = arrRS(14, ar)

		Select Case MatchYN '게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
		Case "0" : MatchYN = "<span style='color:blue'>미노출</span>"
		Case "3" : MatchYN = "<span style='color:orange'>예선노출</span>"
		Case "4" : MatchYN = "예선마감"
		Case "5" : MatchYN = "본선노출"
		Case "6" : MatchYN = "본선마감"
		Case "7" : MatchYN = "결과노출"
		End Select
	%>
	<!-- #include virtual = "/pub/html/riding/gameinfolist.asp" -->
	<%
	i = i + 1
	Next
End if
%>