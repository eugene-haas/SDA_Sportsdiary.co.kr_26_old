<!-- #include virtual = "/dev/config.asp"-->

<!-- #include virtual = "/pub/hdr.inc.bm.min.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.pubcode.asp" -->  
<!-- #include virtual = "/pub/fn/badmt/res/res.teamGB.asp" -->  
<!-- #include virtual = "/dbwork/sql.lettery.elit.reg.asp" -->

<% 
'   ===============================================================================     
'    Purpose : Elite 대진표 작성 - 대회 선택시 선택된 대회에 들어 있는 종별을 구한다. 
'    Make    : 2019.05.29
'    Author  :                                                       By Aramdry
'   ===============================================================================    

'   ===============================================================================     
'     GameTitleIdx를 입력받아 GameLevel Info를 구한다. 
'     GameLevelidx, Sex, TeamGb, PlayType, GroupGameGb
'     playType = 단식, TeamGb = 일반부, Level = 30, Sex = 남자, GroupGameGb = 개인전, LevelJooName = A
'
'     종별 정보를 구한다음에 GetShortKindName()를 이용하여 축약 정보를 만든다. 
'     축약 정보를 <option></option>에 넣는다.  
'   ===============================================================================  

%>


<%     
   '  ' ' Call TraceLog(SPORTS_LOG1, "lotteryElite_GameKind.asp --. start")    

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
Dim hasError
'############################################
   strReq = request("REQ")
    
   ' 사용예 ex) http://badmintonadmin.sportsdiary.co.kr/Ajax/GameTitleMenu/lotteryElite_GameKind.asp?test=t  
	If request("test") = "t" Then 
        strReq = "{""CMD"":1,""ENCTIDX"":""805DE93DF45223778DDDD6E84AE81213""}"
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
   If hasown(oJSONoutput, "ENCTIDX") = "ok" Then       
      reqTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.ENCTIDX))
   End If	
   
   ' ''  ' ' Call TraceLog(SAMALL_LOG1, "reqTitleIdx = " & reqTitleIdx)   

  Call oJSONoutput.Set("result", 100 )
  


   Dim gTitleIdx, gLevelIdx, strSex, strTeamGB, strPlayType, strGroupGameGB, strShort, strOption
   Dim cSex, cTeamGB, cPlayType, cGroupGameGB
   ' ***********************************************************************************************
   ' DB Work
   ' =============================================================================================== 
   If (reqCmd = CMD_ELITEGAMEKIND ) Then 
   '   ===============================================================================   
   '        GameTitleIdx를 입력받아 GameLevel을 구한다. 
   '   =============================================================================== 
      strSql = getSqlEliteGameLevel(reqTitleIdx)

      If(strSql <> "" ) Then 
         Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)    
        '  ' ' Call TraceLog(SPORTS_LOG1, "getSqlEliteGameLevel = " & strSql)
         
         If Not (rs.Eof Or rs.Bof) Then 
            aryGameKind = rs.GetRows()  
            Call oJSONoutput.Set("result", 1 ) 
         Else 
            Call oJSONoutput.Set("result", 100 )
         End If

         strjson = JSON.stringify(oJSONoutput)
         Response.Write strjson
         
         If( IsArray(aryGameKind) ) Then 
            ul = UBound(aryGameKind, 2)  
            Response.write "`##`"       
            response.write "<option value='0'>:: 종별을 선택하세요 ::</option>"
            
            For idx = 0 To ul 
               gTitleIdx         = aryGameKind(0, idx)
               gLevelIdx         = aryGameKind(1, idx)
               cSex              = aryGameKind(2, idx)
               cTeamGB           = aryGameKind(3, idx)
               cPlayType         = aryGameKind(4, idx)
               cGroupGameGB      = aryGameKind(5, idx)
					strLevelName		= aryGameKind(6, idx)

               strSex            = pubGetName(cSex)
               strTeamGB         = rxTeamGBGetName(cTeamGB)
               strPlayType       = pubGetName(cPlayType)
               strGroupGameGB    = pubGetName(cGroupGameGB)

               strShort = GetShortKindName(strSex, strTeamGB, strPlayType, strGroupGameGB)  
					If(strLevelName <> "") Then strShort = strPrintf("{0} ({1})", Array(strShort, strLevelName)) End If 

               strOption = strPrintf("<option value='{0},{1},{2},{3},{4},{5}'>{6}</option>", _
                           Array(gTitleIdx,gLevelIdx, cSex, cTeamGB, cPlayType, cGroupGameGB, strShort ))                                         
               response.write strOption

               strLog = strPrintf("gTitleIdx = {0}, gLevelIdx = {1}, strSex = {2}, strTeamGB = {3}, strPlayType = {4}, strGroupGameGB = {5}", _ 
                              Array(gTitleIdx, gLevelIdx, strSex, strTeamGB, strPlayType, strGroupGameGB))
               ' ''  ' ' Call TraceLog(SPORTS_LOG1, strOption)
               ' ''  ' ' Call TraceLog(SPORTS_LOG1, strLog)
            Next  
         End If 
      Else 
         strjson = JSON.stringify(oJSONoutput)
         Response.Write strjson
      End If 

   End If 

   If (reqCmd = CMD_ASSOCIATE_ELITEGAMEKIND ) Then 
   '   ===============================================================================   
   '        GameTitleIdx를 입력받아 GameLevel을 구한다. 
   '   =============================================================================== 

   End If 

%>

<% 
   '   ===============================================================================   
   '       Sub Function 
   '   ===============================================================================  

   '   ===============================================================================   
   '       게임 구분에 필요한 단어들을 입력받아 축약어를 만든다. 
   '       여대복 (개인전)
   '   ===============================================================================    
   Function GetShortKindName(strSex, strTeamGB, strPlayType, strGroupGameGB)
      Dim shSex, shTeamGb, shPlayType, strShort
      If(strSex <> "") Then shSex = Mid(strSex, 1, 1) End If 
      If(strTeamGB <> "") Then shTeamGb = Mid(strTeamGB, 1, 1) End If 
      If(strPlayType <> "") Then shPlayType = Mid(strPlayType, 1, 1) End If 

      If(strGroupGameGB <> "") Then
         strShort = strPrintf("{0}{1}{2} ({3})", Array(shSex, shTeamGb, shPlayType,strGroupGameGB))
      Else 
         strShort = strPrintf("{0}{1}{2}", Array(shSex, shTeamGb, shPlayType))
      End If 
      GetShortKindName = strShort
   End Function    
%>

<% 
   Set rs = Nothing
	Call db.Dispose
   Set db = Nothing
    ' ' ''  ' ' Call TraceLog(SAMALL_LOG1, "req.badmt.asp --. end")
%>