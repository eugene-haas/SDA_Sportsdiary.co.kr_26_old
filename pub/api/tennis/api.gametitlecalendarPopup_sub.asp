<%
'//////////대회 상세 정보 json////////////'
'켈린더 팝업용
'cmd 24
'//////////대회 상세 정보 json////////////'

    GameTitleIDX = request("GameTitleIDX")

    if GameTitleIDX="" Or gametitleidx = "0" then 
		If hasown(oJSONoutput, "GameTitleIDX") = "ok" then
			GameTitleIDX = oJSONoutput.GameTitleIDX '게임인덱스
		End if


		If hasown(oJSONoutput, "EnterType") = "ok" then
			sitegubun = oJSONoutput.EnterType 'K S 카타 SD
		End if
	
	end if 


If request("t") = "t" Then
'Response.write GameTitleIDX 
End if


	Set db = new clsDBHelper
     strSql =" select RGameLevelidx,TeamGbNm,a.Level,b.LevelNm,GameDay,GameTime,EntryCnt,EntryCntGame,EndRound,courtcnt,lastjoono  " & _ 
            " from dbo.tblRGameLevel a" & _ 
            " inner join tblLevelInfo b " & _ 
            " on a.SportsGb = b.SportsGb " & _ 
            " and a.Level = b.Level " & _ 
            " and b.DelYN='N' " & _ 
            " where GameTitleIDX="&GameTitleIDX&" " & _ 
            " and a.DelYN ='N' order by GameDay asc ,GameTime asc "

	If sitegubun = "K" Or sitegubun = "" then
		Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)
	Else
		Set rs = db.ExecSQLReturnRS(strSQL , null, RT_ConStr)
	End If
	
	

	rscnt =  rs.RecordCount
	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
	Set rsarr = jsObject() 
		rsarr("RGameLevelidx") = rs("RGameLevelidx")
		rsarr("TeamGbNm") = rs("TeamGbNm")
		rsarr("Level") = rs("Level")
		rsarr("LevelNm") = rs("LevelNm")
		rsarr("GameDay") = rs("GameDay")
		rsarr("GameTime") = rs("GameTime")
		rsarr("EntryCnt") = rs("EntryCnt")
		rsarr("EntryCntGame") = rs("EntryCntGame")
		rsarr("EndRound") = rs("EndRound")
		rsarr("courtcnt") = rs("courtcnt")
		rsarr("lastjoono") =  rs("lastjoono") 
	Set JSONarr(i) = rsarr
	i = i + 1
	rs.movenext
	Loop
	datalen = Ubound(JSONarr) - 1
	jsonstr = toJSON(JSONarr)
	Response.Write CStr(jsonstr)
	db.Dispose
	Set db = Nothing
%>