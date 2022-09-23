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
  Function GetGangSu2(ByVal Param_GameType, ByVal Param_MaxRound, ByVal Param_Round)

    CONST constLeague = "B0040001"
    CONST constTorunament = "B0040002" 
    Dim A_GameTypeNM : A_GameTypeNM = ""

    IF Param_GameType = constTorunament Then
      A_GameTypeNM= "토너먼트"
    ELSE
      A_GameTypeNM =  "리그"
    End IF

    IF Param_GameType = constTorunament Then
      'Response.Write "게임 타입 : " & A_GameTypeNM& "<br>"
      'Response.Write "최대 라운드 : " & A_MaxRound & "<br>"
      'Response.Write "현재 라운드: " & A_Round & "<br>"
      Max_Gang = 1
      for j = 1 to Param_MaxRound
        Max_Gang = Max_Gang * 2
      next
      Response.Write "최종 라운드 : " & Param_MaxRound & "<br>"
      Response.Write "현재 라운드 :" & Param_Round & "<br>"
      'Response.Write "현재 라운드 강수 : " & Max_Gang & "<br>"
      redim Arr(Param_MaxRound) 
      Result_Gang = 0
      for i = 1 to Ubound(Arr) 
        if i = cdbl(1) Then
          Arr(i) = Max_Gang
        ELSE
          Arr(i) = Arr(i - 1) / 2
        End IF

        if cdbl(Param_Round) = cdbl(i) Then
          'Response.Write "Arr(i)" & Arr(i) & "<br>"
          Result_Gang = Arr(i)
        Exit For
        END IF
      next
      If Result_Gang = 4 Then
        Result_RoundNM = "준결승"
      ElseIf Result_Gang = 2 then
        Result_RoundNM = "결승"
      Else
        Result_RoundNM = Cstr(Result_Gang) & "강"
      End If
      Response.Write "결과 : " & Result_RoundNM & "<br><br><br><br><br>"
    End IF

    GetGangSu2 = Result_RoundNM

  End Function
%>


<%


REQ = "{""CMD"":4,""tGameTitleIDX"":""BF242F3A46C5952F1DF14D02620F1AB7"",""tGameDay"":""2018-05-12"",""tStadiumIDX"":""2C8A53B33C9D84DEB970F5A46AEF583C"",""tStadiumNumber"":""1"",""tSearchName"":""""}"
Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
End if  

If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(crypt.DecryptStringENC(oJSONoutput.tGameDay))    
    End If
End if  

If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))    
    End If
End if  

If hasown(oJSONoutput, "tStadiumNumber") = "ok" then
    If ISNull(oJSONoutput.tStadiumNumber) Or oJSONoutput.tStadiumNumber = "" Then
      StadiumNumber = ""
      DEC_StadiumNumber = ""
    Else
      StadiumNumber = fInject(oJSONoutput.tStadiumNumber)
      DEC_StadiumNumber = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumNumber))    
    End If
End if  


If hasown(oJSONoutput, "PlayType") = "ok" then
    If ISNull(oJSONoutput.PlayType) Or oJSONoutput.PlayType = "" Then
      PlayType = ""
      DEC_PlayType = ""
    Else
      PlayType = fInject(oJSONoutput.PlayType)
      DEC_PlayType = fInject(crypt.DecryptStringENC(oJSONoutput.PlayType))    
    End If
End if  

If hasown(oJSONoutput, "IngType") = "ok" then
    If ISNull(oJSONoutput.IngType) Or oJSONoutput.IngType = "" Then
      IngType = ""
      DEC_IngType = ""
    Else
      IngType = fInject(oJSONoutput.IngType)
      DEC_IngType = fInject(crypt.DecryptStringENC(oJSONoutput.IngType))    
    End If
End if  

If hasown(oJSONoutput, "tSearchName") = "ok" then
    If ISNull(oJSONoutput.tSearchName) Or oJSONoutput.tSearchName = "" Then
      SchUserName = ""
      DEC_SchUserName = ""
    Else
      SchUserName = fInject(oJSONoutput.tSearchName)
      DEC_SchUserName = fInject(crypt.DecryptStringENC(oJSONoutput.tSearchName))    
    End If
End if  

GameDay = ""
DEC_StadiumIDX =""
StadiumNumber= ""

LSQL = " EXEC tblGameTourney_Searched_STR '" & DEC_GameTitleIDX & "', '" & GameDay & "', '" & DEC_StadiumIDX &"' ,'"  & StadiumNumber &"','" & "GameEnd" & "','" & PlayLevelType & "' ,'" & DEC_TempNum & "'  ,'" & DEC_Searchkey & "'  ,'"  & DEC_Searchkeyword & "','" & DEC_GroupGameGb & "'"
LSQL = " EXEC tblGameTourney_Searched_STR '177', '2018-05-13', '71' ,'','GameEnd','' ,'' ,'' ,'' ,''"
Response.WRite lsql & "<br/><br/><br/><br/><br/><br/>"
Set LRs = Dbcon.Execute(LSQL)

If Not(LRs.Eof Or LRs.Bof) Then 
 Do Until LRs.Eof
    A_TempNum=LRs("TempNum")
    A_GameType= LRs("GameType")
    A_MaxRound = LRs("MaxRound")
    A_Round = LRs("Round")

    Response.Write "A_TempNum" &A_TempNum  & "<br/>"
    Response.Write "A_GameType" &A_GameType  & "<br/>"
    Response.Write "A_MaxRound" &A_MaxRound  & "<br/>"
    Response.Write "A_Round" &A_Round  & "<br/>"
    Response.Write "A_Result" &A_Result  & "<br/>"
    call GetGangSu2(A_GameType, A_MaxRound,A_Round)

    
'
    'Response.Write "<br/><br/><br/><br/><br/><br/>"

   LRs.MoveNext
  Loop
End IF
%>
<%
Set LRs = Nothing
DBClose()
'Response.Write  "LSQL" & LSQL & "<BR/>"  
%>