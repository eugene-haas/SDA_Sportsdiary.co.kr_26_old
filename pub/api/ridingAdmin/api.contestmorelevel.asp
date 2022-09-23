<%
	'request
	pageno = oJSONoutput.NKEY
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper

	strTableName = " sd_TennisTitle "
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,EnterType "

	SQL = "select top 1 "&strFieldName&" from " & strTableName & " where GameTitleIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	title = rs("gameTitleName")
	entertype = rs("EnterType") '유형 엘리트 아마추어 KATA

	titleidx = idx
	'######################

	intPageNum = pageno
	intPageSize = 20

	attcnt = " (select count(*) from tblGameRequest where gametitleIDx = "&idx&" and level = a.level and delYN = 'N' ) as attcnt "
	titlegrade = " (select titleGrade from sd_TennisTitle where gametitleIDx = "&idx&" and delYN = 'N' ) as titlegrade "	

	strTableName = "  tblRGameLevel as a left join tblLevelInfo as b  ON a. level = b.level "
	strFieldName = " RGameLevelIdx,a.Level,a.TeamGbNm,GameTime,attmembercnt,a.gametype,b.LevelNm,a.TeamGb,a.teamGbSort,GameDay,EntryCntGame,courtcnt,a.chkJooRull,EndRound,cfg,joocnt,setrnkpt, " & attcnt & "," & titlegrade


	strSort = "  ORDER BY gameday ,level, RGameLevelidx Desc"
	strSortR = "  ORDER BY gameday desc, level desc,RGameLevelidx Asc"


	'search
	If chkBlank(search_word) Then
		strWhere = " a.GameTitleIDX = "&idx&" and a.DelYN = 'N' "
	Else
		strWhere = " DelYN = 'N' and GameTitleIDX = " & idx
		page_params = "&search_word="&search_word
	End if

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
		level = arrRS(1, ar)
		levelgb = level
		If Left(level,3) = "201" Then
			boo = "개인전"
		Else
			boo = "단체전"
		End if
		teamgbnm = arrRS(2, ar)
		attcnt = arrRS(3, ar)
		gametype = arrRS(4, ar)
		If gametype = "sd043003" Then
			gametypestr = "리그&gt;토너먼트"
		Else
			gametypestr = "토너먼트"
		End If
		LevelNm = arrRS(5, ar)
		entrycnt = arrRS(10, ar)
		courtcnt = arrRS(11, ar)
		rChkJooRull = arrRS(12, ar)
		endround = arrRS(13, ar)
		joocnt = arrRS(14,ar)
	
	%>
	<!-- #include virtual = "/pub/html/riding/gameinfolevellist.asp" -->
	<%
	i = i + 1
	Next
End if
%>