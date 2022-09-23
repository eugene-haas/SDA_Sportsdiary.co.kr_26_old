<!-- #include virtual = "/dev/config.asp"-->
<!-- #include virtual = "/classes/JSON_2.0.4.asp" -->
<!-- #include virtual = "/classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual = "/classes/json2.asp" -->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/fn.util.rule.asp" -->  
<!-- #include virtual = "/dbwork/sql.lettery.elit.reg.asp" -->

<% 
'   ===============================================================================     
'    Purpose : Elite 대진표 작성 - 대회 종별 선택시 선택된 종별에 참가신청한 신청자를 구한다. 
'    Make    : 2019.05.29
'    Author  :                                                       By Aramdry
'   ===============================================================================    

'   ===============================================================================     
'     GameTitleIdx, GameLevelIDX를 입력받아 경기에 참가 신청한 Player 정보를 구한다. 
'     사용유무, 시드 No, 연동대회 Ranking, 참가신청 GroupIdx, 참가신청 Player Idx, MemberIdx, MemberName, Team, TeamName, 연동대회 입상시 Team, 연동대회 입상시 TeamName
'     fUse, SeedNo, Ranking, GameRequestGroupIDX, GameRequestPlayerIDX, MemberIDX, MemberName, Team, TeamName, PrevTeam, PrevTeamName
'     fUse, SeedNo, Ranking, PrevTeam, PrevTeamName는 추후 클라이언트에서 채워질 정보다. 
'
'     ReqGamePlayer Info를 rsTojson_arr()이용하여 Json Data로 만든 후 클라이언트에 전송한다. 
'   ===============================================================================  

%>

<%     
    '' ' ' Call TraceLog(SPORTS_LOG1, "lotteryElite_GamePlayer.asp --. start")    

    Dim db, rs, strSql
    Set db = new clsDBHelper
%>

<%
'   ////////////명령어////////////
      CMD_ELITEGAMEKIND = 1       
      CMD_SEARCHGAMETITLE = 13
      CMD_ELITESEEDPLAYER = 20        ' Get Seed Player   - 연동 대회 우수 선수 조회 
      CMD_ELITEGAMEPLAYER = 21        ' Get Elite Player  - 대회 선수 조회 
'   ////////////명령어////////////


Dim strReq, oJSONoutput, reqCmd, strLog , aryGameKind, idx, ul
Dim hasError, reqGroupGameGb, cPlayType, IsDblGame
'############################################
   strReq = request("REQ")
    
   ' 사용예 ex) http://badmintonadmin.sportsdiary.co.kr/Ajax/GameTitleMenu/lotteryElite_GamePlayer.asp?test=t  
	If request("test") = "t" Then 
        strReq = "{""CMD"":21,""TIDX"":""1591"",""LVIDX"":""9058"",""PLAYTYPE"":""B0020001"",""GROUPGGB"":""B0030001""}"
   End if

	If strReq = "" Then	
       Response.End 
   End if

   If InStr(strReq, "CMD") >0 then
	    Set oJSONoutput = JSON.Parse(strReq)
		reqCmd = oJSONoutput.CMD
	Else
		reqCmd = strReq
	End if

   '   Json data 추출   
   If hasown(oJSONoutput, "TIDX") = "ok" Then       
      reqTitleIdx = oJSONoutput.TIDX
   End If	

   If hasown(oJSONoutput, "LVIDX") = "ok" Then       
      reqLvIdx = oJSONoutput.LVIDX
   End If

   If hasown(oJSONoutput, "GROUPGGB") = "ok" Then       
      reqGroupGameGb = oJSONoutput.GROUPGGB
   End If

	If hasown(oJSONoutput, "PLAYTYPE") = "ok" Then       
      cPlayType = oJSONoutput.PLAYTYPE
		IsDblGame = IsDoublePlay(cPlayType)
   End If
   
   Call oJSONoutput.Set("result", 100 )

	strLog = sprintf("GamePlayer.asp cPlayType = {0}, IsDblGame = {1}", Array(cPlayType, IsDblGame))
	' Call TraceLog(SPORTS_LOG1, strLog)

   Dim strJson 
   ' ***********************************************************************************************
   ' DB Work
   ' =============================================================================================== 
   If (reqCmd = CMD_ELITEGAMEPLAYER ) Then 
   '   ===============================================================================   
   '        GameTitleIdx, GameLevelIDX를 입력받아 경기에 참가 신청한 Player 정보를 구한다. 
   '   =============================================================================== 
      If(reqGroupGameGb = "B0030001") Then            ' 개인전 

			If(IsDblGame = 1) Then 						' 복식 
				strSql = getSqlReqPlayerDbl(reqTitleIdx, reqLvIdx)
				 ' Call TraceLog(SPORTS_LOG1, "getSqlReqPlayerDbl = " & strSql)
			Else 												' 단식 
				strSql = getSqlReqPlayer(reqTitleIdx, reqLvIdx)
				 ' Call TraceLog(SPORTS_LOG1, "getSqlReqPlayer = " & strSql)
			End If 
      ElseIf(reqGroupGameGb = "B0030002") Then         ' 단체전 
         strSql = getSqlReqTeam(reqTitleIdx, reqLvIdx)
			 ' Call TraceLog(SPORTS_LOG1, "getSqlReqTeam = " & strSql)
      End If 

	'	response.end 

      If( strSql <> "" ) Then 
         Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
          ' ' Call TraceLog(SPORTS_LOG1, "getSqlEliteReqPlayer = " & strSql)
         
         If Not (rs.Eof Or rs.Bof) Then 
            strJson = rsTojson_arr(rs)
            ' ' ' ' ' Call TraceLog(SPORTS_LOG1, strJson) 
            Call oJSONoutput.Set("result", 1 )
            Call oJSONoutput.Set("PLAYER", strJson )
         Else 
            Call oJSONoutput.Set("result", 100 )
         End If         
      End If 

      strjson = JSON.stringify(oJSONoutput)
      Response.Write strjson
   End If 

%>

<% 
   Set rs = Nothing
	Call db.Dispose 
   Set db = Nothing
    ' ' ' ' ' ' Call TraceLog(SAMALL_LOG1, "req.badmt.asp --. end")
%>