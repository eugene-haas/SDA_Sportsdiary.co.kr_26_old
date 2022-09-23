<%
'//////////대회 상세 정보 json////////////'
'켈린더 팝업용
'cmd 23
'//////////대회 상세 정보 json////////////'

	If hasown(oJSONoutput, "EnterType") = "ok" then
		sitegubun = oJSONoutput.EnterType '  K kata S sd 랭킹전
	End if


    GameTitleIDX = request("GameTitleIDX")

    if GameTitleIDX="" Or gametitleidx = "0" then 
        GameTitleIDX = oJSONoutput.GameTitleIDX '게임인덱스
    end if 




	Set db = new clsDBHelper
	strSql = " select GameTitleIDX  " & _
            " , GameTitleName " & _
            " , SportsGb " & _
            " , stateNo " & _
            " , cast(GameS as date) as sdate " & _
            " , cast(GameE as date) as edate " & _
            " , DATEDIFF(day,GameS,GameE)+1 GameDif " & _
            " , DATEDIFF(day,GETDATE(),GameS) gameddays " & _ 
            " , DATEDIFF(day,GETDATE(),GameE) gameddaye " & _
            " , EnterType   " & _
            " , GameArea " & _
            " , SidoCode " & _
            " , cast(GameRcvDateS as date) as GameRcvDateS " & _
            " , cast(GameRcvDateE as date) as GameRcvDateE " & _
            " , DATEDIFF(day,GameRcvDateS,GameRcvDateE)+1 GameRcvDif " & _
            " , ViewYN " & _
            " , MatchYN " & _
            " , ViewState " & _
            " , (select max(gubun) from sd_TennisMember where GameTitleIDX=a.GameTitleIDX and SportsGb = a.SportsGb and DelYN='N') gubun " & _
           	" , (select count(*) as cnt  from sd_Tennis_Stadium_Sketch  where GameTitleIDX = '"&GameTitleIDX&"'  and delyn = 'N' ) as sketch_gb " & _

            " , titleCode " & _

			" from sd_TennisTitle  a" & _
            " where DelYN = 'N'  " & _
            " and viewState = 'Y' " 

			  ' ## titlecode 비랭킹 요강 때문에 추가 SD ##

    if GameTitleIDX <> "" then 
        strSql = strSql & " and GameTitleIDX = '"&GameTitleIDX&"' "
    end if



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
		rsarr("GameTitleIDX") = rs("GameTitleIDX")
		rsarr("GameTitleName") = rs("GameTitleName")
		rsarr("SportsGb") = rs("SportsGb")
		rsarr("stateNo") = rs("stateNo")
		rsarr("sdate") = rs("sdate")
		rsarr("edate") = rs("edate")
		rsarr("GameDif") = rs("GameDif")
		rsarr("gameddays") = rs("gameddays")
		rsarr("gameddaye") = rs("gameddaye")
		rsarr("EnterType") = rs("EnterType")
		rsarr("GameArea") =  rs("GameArea")
		rsarr("SidoCode") = rs("SidoCode")
		rsarr("GameRcvDateS") = rs("GameRcvDateS")
		rsarr("GameRcvDateE") = rs("GameRcvDateE") 
		rsarr("GameRcvDif") = rs("GameRcvDif") 
		rsarr("ViewYN") = rs("ViewYN") 
		rsarr("MatchYN") = rs("MatchYN") 
		rsarr("ViewState") = rs("ViewState") 
		rsarr("gubun") = rs("gubun") 
		rsarr("sketch_gb") = rs("sketch_gb") 
		rsarr("tcode") = rs("titlecode") 		
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