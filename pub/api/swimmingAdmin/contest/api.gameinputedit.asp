<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		reqidx = oJSONoutput.IDX
	End if


	Set db = new clsDBHelper

	strFieldName = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt "

	strSql = "SELECT top 1  " & strFieldName
	strSql = strSql &  "  FROM sd_gameTitle  "
	strSql = strSql &  " WHERE GameTitleIDX = " & reqidx
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		

	If Not rs.eof Then

		e_gubun = rs(0)
		e_kgame = rs(1)
		e_GameArea = rs(2)
		e_hostname = rs(3)
		e_subjectnm = rs(4)
		e_afternm = rs(5)
		e_sponnm = rs(6)
		e_GameTitleName = rs(7)
		e_summaryURL = rs(8)
		e_gameSize = rs(9) '규모
		e_ranecnt = rs(10)
		e_titleCode = rs(11)
		e_attmoney = rs(12)
		e_GameS = Replace(rs(13),"-","/") & " - "
		e_GameE = Replace(rs(14),"-","/")

		e_atts = Replace(Left(rs(15),11),"-","/") & " " &  setTimeFormat(CDate(rs(15)))  & " - "
		e_atte = Replace(Left(rs(16),11),"-","/") & " " & setTimeFormat(CDate(rs(16)))
		e_GameType = rs(17)
		e_EnterType = rs(18)
		e_attTypeA = rs(19)
		e_attTypeB = rs(20)
		e_attTypeC = rs(21)
		e_attTypeD = rs(22)
		e_teamLimit = rs(23)
		e_attgameCnt = rs(24)
		e_idx = reqidx
	End if

	%><!-- #include virtual = "/pub/html/swimming/gameinfoform.asp" --><%

	db.Dispose
	Set db = Nothing
%>
