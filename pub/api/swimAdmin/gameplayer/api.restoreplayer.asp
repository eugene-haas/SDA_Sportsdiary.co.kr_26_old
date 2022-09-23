<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper
	strTableName = "  tblGameRequest as a "
	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "
	strFieldName = " RequestIDX,GameTitleIDX,level,"&lvlsql&",EnterType,WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX  "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint  "
	strWhere = " DelYN = 'Y' and RequestIDX = " & idx

	SQL = "Select "& strFieldName &" from "& strTableName &" where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If Not rs.eof Then
		titleidx =			rs("GameTitleIDX")
		levelno = 			rs("level")
		TeamGbNm	=		rs("TeamGbNm")
		
		p1idx =				rs("P1_PlayerIDX")
		p1nm = 			rs("P1_UserName")
		p1t1 = 				rs("P1_TeamNm")
		p1t2 = 				rs("P1_TeamNm2")
		p1phone = 		rs("P1_UserPhone")
		p1birth = 			rs("P1_Birthday")
		p1sex =			rs("P1_SEX")


		p2idx =				rs("P2_PlayerIDX")
		p2nm = 			rs("P2_UserName")
		p2t1 = 				rs("P2_TeamNm")
		p2t2 = 				rs("P2_TeamNm2")
		p2phone = 		rs("P2_UserPhone")
		p2birth = 			rs("P2_Birthday")
		p2sex = 			rs("P2_SEX")

		p1rpoint = 			rs("P1_rpoint")
		p2rpoint = 			rs("P2_rpoint")
	End if

	'#########################################################
	Select Case Left(levelno,3)
	Case "201","200"
		boo = "개인전"
		gamekey1 = "tn001001"
	Case "202"
		boo = "단체전"
		gamekey1 = "tn001002"
	End Select


	SQL = "update tblGameRequest set delYN = 'N' where RequestIDX = " & idx
	Call db.execSQLRs(SQL , null, ConStr)

	insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,requestIDX "
	insertvalue = " 0, "&titleidx&", "&p1idx&", '"&p1nm&"', '"&gamekey1&"',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&Split(teamgbnm,"(")(0)&"','"&p1t1&"','"&p1t2&"',"&p1rpoint&","&idx&" "
	SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"

	'계좌복구
    SQL = "	update  SD_RookieTennis.dbo.TB_RVAS_MAST set STAT_CD = '1' where VACCT_NO = (select  top 1 VACCT_NO from SD_RookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '"&Left(sitecode,2) & idx&"'  ) "
	Call db.execSQLRs(SQL , null, ConStr)
	
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	gamemidx = rs(0)	
'
'	insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
'	insertvalue = " "&gamemidx&", "&p2idx&", '"&p2nm&"','"&p2t1&"','"&p2t2&"',"&p2rpoint&"   "
'	SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
'	Call db.execSQLRs(SQL , null, ConStr)		


	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


  db.Dispose
  Set db = Nothing
%>

