<%
	'request
	pageno = oJSONoutput.NKEY
	idx = oJSONoutput.IDX
	levelno  = oJSONoutput.LevelNo

	Set db = new clsDBHelper


	'대회에 참여가 결정된 맴버 아이디목록 추출
	SQL ="select userName,gameMemberIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gamekey3 = " & levelno & " and gubun in (0,1) and  delYN='N'  order by gameMemberIDX asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrM = rs.GetRows()
	End if



	strTableName = " sd_TennisTitle "
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,EnterType "

	SQL = "select top 1 "&strFieldName&" from " & strTableName & " where GameTitleIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	title = rs("gameTitleName")
	entertype = rs("EnterType") '유형 엘리트 아마추어 KATA

	titleidx = idx
	'######################

	intPageNum = pageno
	intPageSize = 1000

	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "
	strTableName = "  tblGameRequest as a "
	strFieldName = " RequestIDX,GameTitleIDX,level,"&lvlsql&",EnterType,WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX  "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint,UserPass  "

	strSort = "  ORDER By RequestIDX Desc"
	strSortR = "  ORDER By  RequestIDX Asc"	

	'search
	If chkBlank(search_word) Then
		strWhere = " GameTitleIDX = "&idx&"  and level = '"&levelno&"' and DelYN = 'N' "
	Else
		strWhere = " DelYN = 'N' and GameTitleIDX = " & idx
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

i = 0
If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

		idx = arrRS(0, ar) 
		level = arrRS(2, ar)

		If Left(level,3) = "201" Then
			boo = "개인전"
		Else
			boo = "단체전"
		End if
	
		p1nm = arrRS(7, ar)
		p1t1 = arrRS(8, ar)
		p1t2 = arrRS(9, ar)
		Sex1 = arrRS(12, ar)
		If Sex1 = "Man" Then
			Sex1 = "남"
		else
			Sex1 = "여"
		End if

		p2nm = arrRS(14, ar)
		p2t1 = arrRS(16, ar)
		p2t2 = arrRS(17, ar)
		Sex2 = arrRS(20, ar)

		If Sex2 = "Man" Then
			Sex2 = "남"
		else
			Sex2 = "여"
		End if

		p1 = "<span style='color:orange'>" & p1nm & "</span> (" & p1t1& ", " & p1t2 & ") " & sex1
		p2 = "<span style='color:orange'>" & p2nm & "</span> (" & p2t1& ", " & p2t2 & ") " & sex2

		player = p1 & "&nbsp;&nbsp;&nbsp;" & p2
		teamgbnm = arrRS(3, ar)

		p1rpoint = arrRS(21, ar)
		p2rpoint = arrRS(22, ar)

		p_UserPass = arrRS(23, ar)

		attmember = False
		playeridx = 0
		If IsArray(arrM) Then '플레이어 1로만 구분
			For arp = LBound(arrM, 2) To UBound(arrM, 2) 
				playerNM = arrM(0, arp)
				If playerNM = p1nm Then
					attmember = True
					playeridx = arrM(1,arp)
				End if
			Next
		End if

		If attmember = True Then
			gamemember = "<a href='javascript:mx.delPlayer("& idx &","& playeridx &")' class='btn_a' style='color:red'>예선 취소</a>"
		Else
			gamemember = "<a href='javascript:mx.setPlayer("& idx &")' class='btn_a'>예선 참가</a>"
		End if
	%>
	<!-- #include virtual = "/pub/html/riding/gameinfoPlayerList.asp" -->
	<%
	i = i + 1
	Next
End if
%>