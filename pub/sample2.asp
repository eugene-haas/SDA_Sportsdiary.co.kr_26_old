<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
  Set db = new clsDBHelper
GameTitleIDX = 41

		teamnm = " ,(select teamnm from tblPlayer where playerIDx = b.playerIDX) as teamnm "
	team2nm = " ,(select team2nm from tblPlayer where playerIDx = b.playerIDX)  as team2nm "
	fieldname = " a.GameTitleIDX,a.GameTitleName ,b.TeamGb,b.TeamGbName ,a.titleCode,a.titleGrade,a.GameYear " 
	fieldname = fieldname & " ,b.rankno,b.rankno,b.userName, b.PlayerIDX,b.getpoint,b.Gamedate " & teamnm & team2nm
	strwhere = "  a.DelYN='N' and a.ViewState='Y' and a.MatchYN='Y' and a.ViewYN='Y'"
    if GameTitleIDX <>"" then 
        strwhere = strwhere & "  AND a.GameTitleIDX = " & GameTitleIDX 
    end if 
	strsort = " order by b.idx desc , b.rankno asc "
	
	SQL = "Select "&fieldname &" from SD_Tennis.dbo.sd_TennisTitle a inner join SD_Tennis.dbo.sd_TennisRPoint_log as b on a.GameTitleIDX = b.titleIDX where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		If Not rs.EOF Then 
		arrRS = rs.getrows()
		End If
%>