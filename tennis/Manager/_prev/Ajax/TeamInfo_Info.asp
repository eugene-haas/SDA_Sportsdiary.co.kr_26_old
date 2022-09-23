<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'조회조건 데이터
    Search_tp       = fInject(request("tp"))
    Search_SportsGb = fInject(request("Search_SportsGb"))
    Search_Area     = fInject(request("Search_Area"))
    Search_Entertype= fInject(request("Search_Entertype"))
    Search_PTeamGb   = fInject(request("Search_PTeamGb"))
    Search_TeamNm   = fInject(request("Search_TeamNm"))
    Search_NumF   = fInject(request("Search_NumF"))
    Search_NumT   = fInject(request("Search_NumT"))
    Search_Seq   = fInject(request("Search_Seq"))

    LSQL ="  select ROW_NUMBER()over(order by SportsGb,Sido,EnterType desc,PTeamGb,TeamNm) num" & _
        " 		,TeamIDX,SportsGb,PTeamGb,Team,TeamNm,Sex,Sido,ZipCode,Address,AddrDtl " & _
        " 		,TeamTel,TeamRegDt,TeamEdDt,EnterType,TeamLoginPwd,SvcStartDt,SvcEndDt,NowRegYN " & _
        " 		from tblTeamInfo a  " & _
        " 		where DelYN='N' and TeamIDX='"&Search_Seq&"' "
        
	Dbopen()
	Set LRs = Dbcon.Execute(LSQL)
	Dbclose()
	
	If LRs.Eof Or LRs.Bof Then 
		Response.Write "null"
	Else 
	    retext =  "["
		intCnt = 0
		Do Until LRs.Eof 

        retext = retext&"{"
		retext = retext&"""TeamIDX"": """&LRs("TeamIDX") &""","
        retext = retext&"""SportsGb"": """&LRs("SportsGb") &"""," 
		retext = retext&"""PTeamGb"": """&LRs("PTeamGb") &""","
        retext = retext&"""Team"": """&LRs("Team") &"""," 
		retext = retext&"""TeamNm"": """&LRs("TeamNm") &""","
        retext = retext&"""Sex"": """&LRs("Sex") &"""," 
		retext = retext&"""Sido"": """&LRs("Sido") &""","
        retext = retext&"""ZipCode"": """&LRs("ZipCode") &"""," 
		retext = retext&"""Address"": """&LRs("Address") &""","
        retext = retext&"""AddrDtl"": """&LRs("AddrDtl") &"""," 
		retext = retext&"""TeamTel"": """&LRs("TeamTel") &""","
        retext = retext&"""TeamRegDt"": """&LRs("TeamRegDt") &"""," 
		retext = retext&"""TeamEdDt"": """&LRs("TeamEdDt") &""","
        retext = retext&"""EnterType"": """&LRs("EnterType") &"""," 
        retext = retext&"""TeamLoginPwd"": """&LRs("TeamLoginPwd") &""","
        retext = retext&"""SvcStartDt"": """&LRs("SvcStartDt") &""","
        retext = retext&"""SvcEndDt"": """&LRs("SvcEndDt") &""","
        retext = retext&"""NowRegYN"": """&LRs("NowRegYN") &""","
        retext = retext&"},"

		LRs.MoveNext
		intCnt = intCnt + 1
		Loop 
	End If

	retext = Mid(retext, 1, len(retext) - 1)
	retext = retext&"]"
    Response.Write retext

    LRs.Close
   Set LRs = Nothing
%>
