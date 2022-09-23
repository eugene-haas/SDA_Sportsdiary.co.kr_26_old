<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
'단체전 경기결과 입력
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  REQ = Request("Req")
  'REQ = "{""tGameTitleIdx"":""35D5B51E5025C785305E687C2F2EE95E"",""CMD"":7,""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tTeamGb"":""2F9A5AB5A680D3EDDEE944350E247FCB|Mix"",""tPlayTypeSex"":""9313C11726C4F47D4859E9CC91CA6DAA|704C5971F9D17ABC8687A215715ABCE6"",""tLevel"":""FE25E609214EB0FC01BC8651577120A1|4CFCCA7CADE085509F5F57C764AE5723|"",""tRankingValue"":"""",""tDataReulst"":""1482^1541^6577^BA00002^^1^7717%1482^1541^6579^BA00018^^2^7721%1482^1541^6578^BA00022^^^7719%1482^1541^6580^BA00071^^^7723%1482^1542^6582^BA00004^^3^7718%1482^1542^6583^BA00006^^4^7720%1482^1542^6584^BA00050^^^7722%1482^1542^6585^BA00032^^^7724%""}"

  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    reqGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
    crypt_reqGroupGameGb =crypt.EncryptStringENC(reqGroupGameGb)
  Else
    reqGroupGameGb = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
  End if	

  If hasown(oJSONoutput, "tTeamGb") = "ok" then
    reqTeamGb = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGb))
    crypt_reqTeamGb =crypt.EncryptStringENC(reqTeamGb)
  End if	

  If hasown(oJSONoutput, "tPlayTypeSex") = "ok" then
    reqPlayTypeSex= fInject(oJSONoutput.tPlayTypeSex)
    If InStr(reqPlayTypeSex,"|") > 1 Then
      arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
      reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
      reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
    End if
  End if	

  If hasown(oJSONoutput, "tLevel") = "ok" then
    reqLevel= fInject(oJSONoutput.tLevel)
    'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
    If InStr(reqLevel,"|") > 1 Then
      arr_reqLevel = Split(reqLevel,"|")
      reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
      reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
      reqLevelJooNum = arr_reqLevel(2)
    End if
  End if	

  If hasown(oJSONoutput, "tDataReulst") = "ok" then
    DataReulst= fInject(oJSONoutput.tDataReulst)
  End if	

  arr_DataReulst = Split(DataReulst,"%")

  IF IsArray(arr_DataReulst) Then
    for each percentInDataReulst in arr_DataReulst 
      if percentInDataReulst <> "" Then
        'Response.Write "percentInDataReulst" & percentInDataReulst & "<br/>"
        Values = Split(percentInDataReulst,"^")
        GameLevelIdx = Values(0)
        GameLevelDtlIdx = Values(1)
        TourneyGroupIDX = Values(2)
        Team  = Values(3)
        TeamDtl = Values(4)
        Grade = Values(5)
        RequestIdx = Values(6)

        'Response.Write "GameLevelIdx" & GameLevelIdx & "<br/>"
        'Response.Write "GameLevelDtlIdx" & GameLevelDtlIdx & "<br/>"
        'Response.Write "TourneyGroupIDX" & TourneyGroupIDX & "<br/>"
        'Response.Write "Team" & Team & "<br/>"
        'Response.Write "TeamDtl" & TeamDtl & "<br/>"
        'Response.Write "Grade" & Grade & "<br/>"
        'Response.Write "RequestIdx" & RequestIdx & "<br/>"
        IF Grade <> "" Then
          LSQL = "SELECT A.GameTitleIDX, A.GameLevelDtlIDX, B.TeamGb, B.Level, A.LevelDtlName, A.TotRound, B.GroupGameGb "
          LSQL = LSQL & " FROM tblGameLevelDtl A"
          LSQL = LSQL & " INNER JOIN tblGameLevel B ON B.GameLevelIDX = A.GameLevelIDX"
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND B.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameLevelidx = '" & GameLevelIdx & "'"
          LSQL = LSQL & " AND A.PlayLevelType = 'B0100002'"
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
              bon_GameTitleIDX = LRs("GameTitleIDX")
              bon_GameLevelDtlIDX = LRs("GameLevelDtlIDX")
              bon_TeamGb = LRs("TeamGb")
              bon_Level = LRs("Level")
              bon_LevelDtlName = LRs("LevelDtlName")
              bon_TotRound = LRs("TotRound")
              bon_GroupGameGb = LRs("GroupGameGb")
              
          End If
          LRs.Close
          
          IF GroupGame = bon_GroupGameGb Then

            MSQL = "SELECT CASE WHEN MAX(TourneyTeamNum) IS NULL THEN '101' ELSE MAX(TourneyTeamNum) + 1 END AS TourneyTeamNum"
            MSQL = MSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam"
            MSQL = MSQL & " WHERE DelYN = 'N'"
            MSQL = MSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
            'Response.Write "MSQL : " & MSQL & "<BR/>"
            Set MRs = Dbcon.Execute(MSQL)
            If Not (MRs.Eof Or MRs.Bof) Then
                bon_TourneyTeamNum = MRs("TourneyTeamNum")
            End If
            MRs.Close							      

            MSQL = "SELECT AreaNum "
            MSQL = MSQL & " FROM dbo.tblGameRule"
            MSQL = MSQL & " WHERE DelYN = 'N'"
            MSQL = MSQL & " AND Gang = '" & bon_TotRound & "'"
            MSQL = MSQL & " AND JoNum = '" & Grade & "'"

            'Response.Write "MSQL : " & MSQL & "<BR/>"
            Set MRs = Dbcon.Execute(MSQL)
            If Not (MRs.Eof Or MRs.Bof) Then
                Do Until MRs.Eof
                    CSQL = "UPDATE tblTourneyTeam SET Team = '" & Team & "',"
                    CSQL = CSQL & " TeamDtl = '" & TeamDtl & "',"
                    CSQL = CSQL & " RequestIdx = '" & RequestIdx & "'"
                    CSQL = CSQL & " WHERE DelYN = 'N'"
                    CSQL = CSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
                    CSQL = CSQL & " AND ORDERBY = '" & MRs("AreaNum") & "'"     
                    Dbcon.Execute(CSQL)        
                    MRs.MoveNext    
                Loop
            End If
            MRs.Close

          ELSEIF PersonGame = bon_GroupGameGb Then

            

            MSQL = "SELECT CASE WHEN MAX(TourneyGroupNum) IS NULL THEN '101' ELSE MAX(TourneyGroupNum) + 1 END AS TourneyGroupNum"
            MSQL = MSQL & " FROM KoreaBadminton.dbo.tblTourneyGroup"
            MSQL = MSQL & " WHERE DelYN = 'N'"
            MSQL = MSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
            Set MRs = Dbcon.Execute(MSQL)
            If Not (MRs.Eof Or MRs.Bof) Then
              bon_TourneyGroupNum = MRs("TourneyGroupNum")
            End If
            MRs.Close

            MSQL = "SET NOCOUNT ON"
            MSQL = MSQL & " INSERT INTO dbo.tblTourneyGroup ("
            MSQL = MSQL & " GameTitleIDX, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Team, TeamDtl, TourneyGroupNum"
            MSQL = MSQL & " )"
            MSQL = MSQL & " VALUES ("
            MSQL = MSQL & " '" & bon_GameTitleIDX & "'"
            MSQL = MSQL & " ,'" & bon_TeamGb & "'"
            MSQL = MSQL & " ,'" & bon_GameLevelDtlIDX & "'"
            MSQL = MSQL & " ,'" & bon_Level & "'"
            MSQL = MSQL & " ,'" & bon_LevelDtlName & "'"
            MSQL = MSQL & " ,NULL"
            MSQL = MSQL & " ,'0'"
            MSQL = MSQL & " ,'" & bon_TourneyGroupNum  & "'"
            MSQL = MSQL & " );"
            MSQL = MSQL & " SELECT @@IDENTITY AS IDX"
            'Response.Write "MSQL : " & MSQL  & "<BR/>"
            Set MRs = Dbcon.Execute(MSQL)
            If Not (MRs.Eof Or MRs.Bof) Then
              Do Until MRs.Eof
                    bon_TourneyGroupIDX =  MRs("IDX")
                    MRs.MoveNext            
                Loop
            Else
                bon_TourneyGroupIDX = "0" 
            End If
            MRs.Close

            '해당 대진에 선수 INSERT
            MSQL = "SET NOCOUNT ON"
            MSQL = MSQL & " INSERT INTO dbo.tblTourneyPlayer"
            MSQL = MSQL & " ("
            MSQL = MSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb"
            MSQL = MSQL & " , GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum"
            MSQL = MSQL & " , CourtPosition, Team, TeamDtl"
            MSQL = MSQL & " )"
            MSQL = MSQL & " SELECT '" & bon_TourneyGroupIDX & "', A.MemberIDX, '" & bon_GameTitleIDX & "', A.UserName, '" & bon_TeamGb & "'"
            MSQL = MSQL & " , '" & bon_GameLevelDtlIDX & "', '" & bon_Level & "', '" & bon_LevelDtlName & "', A.Sex, 0"
            MSQL = MSQL & " , NULL, A.Team, A.TeamDtl"
            MSQL = MSQL & " FROM dbo.tblTourneyPlayer A"
            MSQL = MSQL & " WHERE A.DelYN = 'N'"
            MSQL = MSQL & " AND A.GameLevelDtlIDX = '" & GameLevelDtlIdx & "'"
            MSQL = MSQL & " AND A.TourneyGroupIDX = '" & TourneyGroupIDX & "'"
            'Response.Write "MSQL : " & MSQL  & "<BR/>"
            Dbcon.Execute(MSQL)

            MSQL = "SELECT AreaNum "
            MSQL = MSQL & " FROM dbo.tblGameRule"
            MSQL = MSQL & " WHERE DelYN = 'N'"
            MSQL = MSQL & " AND Gang = '" & bon_TotRound & "'"
            MSQL = MSQL & " AND JoNum = '" & Grade & "'"

            'Response.Write "MSQL : " & MSQL & "<BR/>"
            Set MRs = Dbcon.Execute(MSQL)
            If Not (MRs.Eof Or MRs.Bof) Then
                Do Until MRs.Eof
                    CSQL = "UPDATE tblTourney SET TourneyGroupIDX = '" & bon_TourneyGroupIDX & "',"
                    CSQL = CSQL & " RequestIdx = '" & RequestIdx & "'"
                    CSQL = CSQL & " WHERE DelYN = 'N'"
                    CSQL = CSQL & " AND GameLevelDtlidx = '" & bon_GameLevelDtlIDX & "'"
                    CSQL = CSQL & " AND ORDERBY = '" & MRs("AreaNum") & "'"     
                    'Response.Write "CSQL : " & CSQL & "<BR/>"
                    Dbcon.Execute(CSQL)        
                    MRs.MoveNext    
                Loop
            End If
            MRs.Close

            KSQL = "UPDATE_BYE '" & bon_GameLevelDtlIDX & "'"
            Dbcon.Execute(KSQL)

          End IF
          'Response.Write "bon_GameTitleIDX" & bon_GameTitleIDX & "<br/>"
          'Response.Write "bon_GameLevelDtlIDX" & bon_GameLevelDtlIDX & "<br/>"
          'Response.Write "bon_TeamGb" & bon_TeamGb & "<br/>"
          'Response.Write "bon_Level" & bon_Level & "<br/>"
          'Response.Write "bon_LevelDtlName" & bon_LevelDtlName & "<br/>"
          'Response.Write "bon_TotRound" & bon_TotRound & "<br/>"
          'Response.Write "bon_GroupGameGb" & bon_GroupGameGb & "<br/>"
        End IF
      End IF
    Next
  End IF
Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>