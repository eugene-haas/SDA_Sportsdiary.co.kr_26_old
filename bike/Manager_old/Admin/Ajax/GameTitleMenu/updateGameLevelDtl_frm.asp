

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
  REQ = Request("REQ")
  'REQ = "{""tPGameLevelIdx"":""A9DCA2E87B121CA8CEF6B07D880ACE16"",""tIdx"":""4AC9519B3F35C40A5D496D69A6B07B65"",""tGameLevelIdx"":""A9DCA2E87B121CA8CEF6B07D880ACE16"",""beforeNowPage"":""1"",""NowPage"":""1"",""i2"":1,""pType"":""level"",""iSearchText"":"""",""iSearchCol"":""T"",""CMD"":4,""tGameLevelDtlIdx"":""A327F210BC95C0AD77E9C05F7781572E"",""tGameLevelDtlIDX"":""A327F210BC95C0AD77E9C05F7781572E"",""tStadium"":""040F9E5C3294000D22467CC44F74AAFB"",""tPlayLevelType"":""D096EC5BB8B02F96118B096392C18758"",""tGameType"":""143222846ECFA17ECBDF9B9DE506DCBD"",""tTotalRound"":""512"",""tEntryCnt"":""0"",""tGameTime"":""8:00 AM"",""tViewYN"":""N"",""tGameDay"":""2018-04-18"",""tLevelJooNum"":""1"",""tJooDivision"":""0""}"

  Set oJSONoutput = JSON.Parse(REQ)
  CMD = fInject(oJSONoutput.CMD)
  
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))

  tPlayLevelType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayLevelType))
  tGameType = fInject(crypt.DecryptStringENC(oJSONoutput.tGameType))
  tStadium = fInject(crypt.DecryptStringENC(oJSONoutput.tStadium))
  
  tEntryCnt = fInject(oJSONoutput.tEntryCnt)
  tGameDay = fInject(oJSONoutput.tGameDay)
  tGameTime = fInject(oJSONoutput.tGameTime)
  tViewYN = fInject(oJSONoutput.tViewYN)
  tLevelJooNum = fInject(oJSONoutput.tLevelJooNum)
  tFullGameYN = fInject(oJSONoutput.tFullGameYN)

  
  If hasown(oJSONoutput, "tJooRank") = "ok" then
    tJooRank= fInject(oJSONoutput.tJooRank)
  ELSE
    tJooRank= ""
  End if	
  
  'tLevelJoo = oJSONoutput.tLevelJoo
  'tLevelJooNum = oJSONoutput.tLevelJooNum
  'tPlayLevelType2 ="B0100002"
  'tPlayLevelGroup = ""
  'tLevelDtlName = ""
  'tLevel =""

  IF( cdbl(tGameLevelDtlIDX) > 0 ) Then
    IF tGameType = "B0040001" Then
      tTotalRound  ="0"
    Else
      tTotalRound = fInject(oJSONoutput.tTotalRound)
    END IF 
  END IF 

  ''------------Level 정보 가져오기--------------
  LSQL = " SELECT Top 1 a.GroupGameGb, a.EnterType"
  LSQL = LSQL & " FROM  tblGameLevel  a "
  LSQL = LSQL & " WHERE a.GameLevelidx = '"  & tGameLevelIdx  & "' and a.DelYn ='N' "
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      GroupGameGb = LRS("GroupGameGb")
      tEnterType = LRS("EnterType")
      LRs.MoveNext
    Loop
  End IF

  LSQL = " Update tblGameLevelDtl " 
  LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "' , LevelJooNum= '" & tLevelJooNum & "', StadiumNum = '" & tStadium & "', FullGameYN = '" & tFullGameYN & "', JooRank = '" & tJooRank & "'"
  LSQL = LSQL & " Where GameLevelDtlidx = '" & tGameLevelDtlIDX & "'"
  'Response.Write LSQL
  Set LRs = DBCon.Execute(LSQL)
  'End IF

  Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%
  DBClose()
%>



