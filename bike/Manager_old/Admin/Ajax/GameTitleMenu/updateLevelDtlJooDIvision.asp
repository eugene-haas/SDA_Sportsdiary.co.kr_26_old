

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":5,""tGameLevelIdx"":""357E87C6F94F8BF6ED32548D760214DF"",""tDivisionNum"":""2"",""tRequestGameType"":""143222846ECFA17ECBDF9B9DE506DCBD"",""tIdx"":""47E0533CF10C4690F617881B06E75784""}"
  'REQ = "{""CMD"":5,""tGameLevelIdx"":""93542DD1745E4E108341FB2E946CEB0B"",""tDivisionNum"":""3"",""tRequestGameType"":""143222846ECFA17ECBDF9B9DE506DCBD"",""tIdx"":""47E0533CF10C4690F617881B06E75784"",""NowPage"":1}"
  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIDX))
  crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelIDX)
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  DivisionNum = fInject(oJSONoutput.tDivisionNum)
  tGameType = fInject(crypt.DecryptStringENC(oJSONoutput.tRequestGameType))

  
  '예선전으로 만들기
  tPlayLevelGroup = ""
  tPlayLevelType = "B0100001"
  tPlayLevelType2 ="B0100002"

  tGameDay = FormatDateTime(Now(), 2)
  tStadiumNumber = 1
  tGameTime = "08:00 AM"
  tTotalRound = ""
  tLevelDtlName =""

  Dim PGameLevelidxs
  Dim Del_GameLevelidxs
  Dim IsGameLevelCnt : IsGameLevelCnt = 0  'Level이 있는지 확인하는 Cnt
  Dim IsChildGameLevelCnt : IsChildGameLevelCnt = 0  'Level에 자식들이 있는지 확인하는 Cnt
  Redim LevelDTLIdArr(DivisionNum)

  'Response.Write "조 변경 : " & JOODIVISION & "<BR><BR><BR><BR><BR>"  

  IF( cdbl(tGameLevelIDX) > 0 and  cdbl(DivisionNum) > 0 ) Then
    'Level을 체크한다  가 0보다 크면서 JOODIVISION이 0보다 클 때
    LSQL = " SELECT Top 1 Level, GameLevelidx, GameTitleIDX, Isnull(PGameLevelidx,'') as PGameLevelidx, JooDivision, GroupGameGb, b.PubName, a.EnterType "
    LSQL = LSQL & " FROM  tblGameLevel  a "
    LSQL = LSQL & " LEFT JOIN tblPubcode b on a.GroupGameGb = b.PubCode and b.DelYN = 'N' "
    LSQL = LSQL & " WHERE a.GameLevelidx = '"  & tGameLevelIDX  & "' and a.DelYn ='N' "

    'Response.Write "설명 : LEVEL 자신이 있는지 확인" & "<br>"
    'Response.Write "LSQL" & LSQL & "<BR><BR><BR><BR><BR>"
    '1. LEVEL 자신이 있는지 확인
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        IsGameLevelCnt = IsGameLevelCnt + 1
        tJooDivision = LRS("JooDivision")
        GroupGameGb = LRS("GroupGameGb")
        GroupGameGbName = LRS("PubName")
        tLevel = LRS("Level")
        tEnterType = LRS("EnterType")
        LRs.MoveNext
      Loop
    End IF

    'Response.Write "tIdx : " & tIdx & "<br>"
    'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br>"
    'Response.Write "tPlayLevelType : " & tPlayLevelType & "<br>"
    'Response.Write "tPlayLevelGroup : " & tPlayLevelGroup & "<br>"
    'Response.Write "tGameType : " & tGameType & "<br>"
    'Response.Write "tStadiumNumber" & tStadiumNumber & "<br>"
    'Response.Write "tTotalRound" & tTotalRound & "<br>"
    'Response.Write "tGameDay" & tGameDay & "<br>"
    'Response.Write "tGameTime" & tGameTime & "<br>"
    'Response.Write "tEnterType" & tEnterType & "<br>"
    'Response.Write "tLevel" & tLevel & "<br>"
    'Response.Write "GroupGameGb" & GroupGameGb & "<br>"
    'Response.Write "tLevelDtlName" & tLevelDtlName & "<br><br><br>"
    
    
    'Response.End
    if cdbl(IsGameLevelCnt) = CDBL(1) and (GroupGameGb = "B0030001" or GroupGameGb =  "B0030002")  Then
      IsGameLevelDtlCnt = 0
      ' 자식이 레벨 데이터가 있는지 확인
      ' 자식 데이터 삭제 로직
      LSQL = " SELECT GameLevelDtlidx "
      LSQL = LSQL & "   FROM  tblGameLevelDtl  "
      LSQL = LSQL & " WHERE GameLevelidx = '"  & tGameLevelIDX  & "' and DelYn ='N' "
      'Response.Write " 설명 : 자식 데이터 삭제 로직, 레벨에 자식이 있는지 여부 " & "<br>"
      'Response.Write "LSQL : " & LSQL & "<BR><BR><BR><BR><BR>"
      'Response.End

      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          IsGameLevelDtlCnt =  IsGameLevelDtlCnt + 1
          GameLevelDtlidx = LRS("GameLevelDtlidx")
          Del_GameLevelDtlidxs = Del_GameLevelDtlidxs & GameLevelDtlidx & "_"
          LRs.MoveNext
        Loop
      End IF

      'Response.Write "지울 LevelIdx" &  GameLevelidx & "<br>"
      Split_Del_GameLevelDtlidxs = Split(Del_GameLevelDtlidxs,"_")

      for each x in Split_Del_GameLevelDtlidxs
        if(x <> "") Then
          LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
          LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  X & "'" 
          'Response.Write "SQL :" & LSQL & "<BR>"
          Set LRs = DBCon.Execute(LSQL)


          LSQL = " Update tblGameRequestTouney Set DelYN = 'Y' " 
          LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  X & "'" 
          'Response.Write "SQL :" & LSQL & "<BR>"
          Set LRs = DBCon.Execute(LSQL)

        End if
      next

      '예선 만드는 로직
      For i = 1 To cdbl(DivisionNum)
        LSQL = " SET NOCOUNT ON insert into tblGameLevelDtl " 
        LSQL = LSQL & " (GameTitleIDX, GameLevelidx, PlayLevelType, PlayLevelGroup, GameType, StadiumNumber, TotRound, GameDay, GameTime, EnterType, EntryCnt, Level, LevelDtlName, LevelJooNum ) "
        LSQL = LSQL & " values ('"&tidx & "','"&tGameLevelIdx & "','" & tPlayLevelType & "', '" & tPlayLevelGroup & "' ,'" & tGameType & "','" & tStadiumNumber & "','" & tTotalRound & "','" & tGameDay & "', '" & tGameTime &"','" & tEnterType &"','" & tEntryCnt &"','" & tLevel &"','" & tLevelDtlName &"', '" & i & "')" 
        LSQL = LSQL & " SELECT @@IDENTITY as IDX "

        'Response.Write "LSQLLSQLLSQLLSQLLSQL : "& LSQL &  "<br>"

        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            GameLevelDtlidx = LRs("IDX")
            GameLevelDtlidxs = GameLevelDtlidxs & GameLevelDtlidx & "_"
          LRs.MoveNext
          Loop
        End If  
      Next

      '본선 만드는 로직
      if Len(GameLevelDtlidxs) > 0 Then
        LSQL = " SET NOCOUNT ON insert into tblGameLevelDtl " 
        LSQL = LSQL & " (GameTitleIDX, GameLevelidx, PlayLevelType, PlayLevelGroup, GameType, StadiumNumber, TotRound, GameDay, GameTime, EnterType, EntryCnt, Level, LevelDtlName, LevelJooNum ) "
        LSQL = LSQL & " values ('"&tidx & "','"&tGameLevelIdx & "','" & tPlayLevelType2 & "', '" & tPlayLevelGroup & "' ,'" & tGameType & "','" & tStadiumNumber & "','" & tTotalRound & "','" & tGameDay & "', '" & tGameTime &"','" & tEnterType &"','" & tEntryCnt &"','" & tLevel &"','" & tLevelDtlName &"', '" & i & "')" 
        LSQL = LSQL & " SELECT @@IDENTITY as IDX "
        'Response.Write "LSQLLSQLLSQLLSQLLSQL : "& LSQL &  "<br>"
        Set LRs = DBCon.Execute(LSQL)
      End IF

      Split_GameLevelDtlidxs = Split(GameLevelDtlidxs,"_")

       splitCnt = 0
        '새로 만든 LevelDtl          
        for each x in Split_GameLevelDtlidxs
          if(x <> "" )Then
            LevelDTLIdArr(splitCnt) = x
            splitCnt = splitCnt + 1
            'response.write("Split_PGameLevelidxs : " &  x & "<br />")
          End if
        next
        

      'Response.write "Split_GameLevelDtlidxs" & GameLevelDtlidxs & "<br>"

      ' 자식 데이터 생성 로직 개인전
      IF GroupGameGb = "B0030001" Then

        LSQL = " SELECT COUNT(*) as GroupCnt "
        LSQL = LSQL & "FROM  tblGameRequestGroup   "
        LSQL = LSQL & " WHERE GameLevelIDX = '"  & tGameLevelIDX  & "' and DelYn ='N' "
        'Response.Write "개인전 : 참여 그룹 수 " & "<br>"
        'Response.write "LSQL : " & LSQL & "<BR><BR><BR><BR><BR>"
        'Response.End

        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            GroupCnt = LRS("GroupCnt")
            'Response.WRite "총 그룹 개수 : " & GroupCnt & "<br><br><br>"
            LRs.MoveNext
          Loop
        End IF

        splitCnt = 0
        for each x in Split_GameLevelDtlidxs
        if (x <> "" )Then
          LevelDTLIdArr(splitCnt) = x
          splitCnt = splitCnt + 1
          'response.write("Split_PGameLevelidxs : " &  x & "<br />")
        End if
        next

        
        'Response.Write PGameLevelidxs & "<br>"
        'Level에 참여된 인원
        LSQL = " SELECT GameRequestGroupIDX  "
        LSQL = LSQL & " FROM  tblGameRequestGroup "
        LSQL = LSQL & " where GameLevelIDX = '" & tGameLevelIDX & "' and DelYN='N' "
        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          GameRequestGroupArray = LRs.getrows()
        End If

        RequestGroupArrayCnt = 0 

        If IsArray(GameRequestGroupArray) Then
            For ar = LBound(GameRequestGroupArray, 2) To UBound(GameRequestGroupArray, 2) 
              tGameRequestGroupIDX		= GameRequestGroupArray(0, ar) 
              RequestGroupArrayCnt = RequestGroupArrayCnt + 1
              currentArrayJoo =  (RequestGroupArrayCnt Mod DivisionNum) - 1
              
              if(currentArrayJoo < 0) Then
                currentArrayJoo = DivisionNum - 1
              End IF
                
              LSQL = " SET NOCOUNT ON insert into tblGameRequestTouney " 
              LSQL = LSQL & " ( RequestIDX, GroupGameGb, GameLevelDtlIDX) "
              LSQL = LSQL & " values ('"&tGameRequestGroupIDX & "','" &  GroupGameGb & "','"&  LevelDTLIdArr(currentArrayJoo) & "')" 
              LSQL = LSQL & " SELECT @@IDENTITY as IDX "
              'Response.Write "SQL :" & LSQL & "<BR>"
              
              Set LRs = DBCon.Execute(LSQL)
              IF NOT (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                  GroupRequestGroupIdx = LRs("IDX")
                LRs.MoveNext
                Loop
              End If  
            
              'Response.WRite "RequestGroupArrayCnt : "  & RequestGroupArrayCnt & "<br>"
              'Response.WRite "currentJoo : "  & currentArrayJoo & "<br>"
              'Response.WRite "LevelDtlID : "  & LevelDTLIdArr(currentArrayJoo) & "<br>"
              'Response.WRite "tGameRequestGroupIDX : "  & tGameRequestGroupIDX & "<br>"
            Next

            if tGameType = "B0040002" Then
              'Response.Write "여기" & "<br>"
              for each x in Split_GameLevelDtlidxs
                if(x <> "" )Then

                  LSQL = " SELECT Count(*) as TouneyCnt " 
                  LSQL = LSQL & "  FROM  tblGameRequestTouney  "
                  LSQL = LSQL & "  where DelYN = 'N' and GameLevelDtlIDX = '" & x & "'"
                  'Response.Write "LSQL" & LSQL & "<br>"
                  
                  Set LRs_sub = DBCon.Execute(LSQL)
                  IF NOT (LRs_sub.Eof Or LRs_sub.Bof) Then
                    Do Until LRs_sub.Eof
                      TouneyCnt = LRs_sub("TouneyCnt")
                      LRs_sub.MoveNext
                    Loop
                  End IF

                  LRs_sub.close

                  '강수 계산##############
                  drowCnt = GetDrowCnt(TouneyCnt)

                  LSQL = " Update tblGameLevelDtl Set TotRound = '"  & drowCnt & "' " 
                  LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  x & "'" 
                  'Response.Write "SQL :" & LSQL & "<BR>"
                  Set LRs = DBCon.Execute(LSQL)
                End if
              next
            End if
        End If			
    END IF ' 현재 레벨이 있는지 확인 division이 갖고 부모의 division 과 다른지 확인 


        ' 자식 데이터 생성 로직 개인전
      IF GroupGameGb = "B0030002" Then

        LSQL = " SELECT COUNT(*) as TeamCnt "
        LSQL = LSQL & "FROM  tblGameRequestTeam   "
        LSQL = LSQL & " WHERE GameLevelIDX = '"  & tGameLevelIDX  & "' and DelYn ='N' "
        'Response.Write "단체전 : 참여 팀 수 " & "<br>"
        

        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            TeamCnt = LRS("TeamCnt")
            'Response.WRite "총 팀 개수 : " & TeamCnt & "<br><br><br>"
            LRs.MoveNext
          Loop
        End IF

        splitCnt = 0
        for each x in Split_GameLevelDtlidxs
        if(x <> "" )Then
          LevelDTLIdArr(splitCnt) = x
          splitCnt = splitCnt + 1
          'response.write("Split_PGameLevelidxs : " &  x & "<br />")
        End if
        next

        
        'Response.Write PGameLevelidxs & "<br>"
        'Level에 참여된 인원
         LSQL = " SELECT GameRequestTeamIDX  "
        LSQL = LSQL & " FROM  tblGameRequestTeam "
        LSQL = LSQL & " where GameLevelIDX = '" & tGameLevelIDX & "' and DelYN='N' "
        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          GameRequestTeamArray = LRs.getrows()
        End If

        RequestGroupArrayCnt = 0 
          
        If IsArray(GameRequestTeamArray) Then
            For ar = LBound(GameRequestTeamArray, 2) To UBound(GameRequestTeamArray, 2) 
              tGameRequestTeamIDX		= GameRequestTeamArray(0, ar) 
              RequestTeamArrayCnt = RequestTeamArrayCnt + 1
              currentArrayJoo =  (RequestTeamArrayCnt Mod DivisionNum) - 1
              
              if(currentArrayJoo < 0) Then
                currentArrayJoo = DivisionNum - 1
              End IF
                
              LSQL = " SET NOCOUNT ON insert into tblGameRequestTouney " 
              LSQL = LSQL & " ( RequestIDX, GroupGameGb, GameLevelDtlIDX) "
              LSQL = LSQL & " values ('"&tGameRequestTeamIDX & "','" &  GroupGameGb & "','"&  LevelDTLIdArr(currentArrayJoo) & "')" 
              LSQL = LSQL & " SELECT @@IDENTITY as IDX "
              'Response.Write "SQL :" & LSQL & "<BR>"
              
              Set LRs = DBCon.Execute(LSQL)
              IF NOT (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                  GroupRequestGroupIdx = LRs("IDX")
                LRs.MoveNext
                Loop
              End If  

              'Response.WRite "RequestTeamArrayCnt : "  & RequestTeamArrayCnt & "<br>"
              'Response.WRite "currentJoo : "  & currentArrayJoo & "<br>"
              'Response.WRite "LevelDtlID : "  & LevelDTLIdArr(currentArrayJoo) & "<br>"
              'Response.WRite "tGameRequestTeamIDX : "  & tGameRequestTeamIDX & "<br>"
            Next

            'Response.Write "여기" & "<br>"


            if tGameType = "B0040002" Then
              for each x in Split_GameLevelDtlidxs
                if(x <> "" )Then
                  LSQL = " SELECT Count(*) as TouneyCnt " 
                  LSQL = LSQL & "  FROM  tblGameRequestTouney  "
                  LSQL = LSQL & "  where DelYN = 'N' and GameLevelDtlIDX = '" & x & "'"
                  'Response.Write "LSQL" & LSQL & "<br>"
                  
                  Set LRs_sub = DBCon.Execute(LSQL)
                  IF NOT (LRs_sub.Eof Or LRs_sub.Bof) Then
                    Do Until LRs_sub.Eof
                      TouneyCnt = LRs_sub("TouneyCnt")
                      LRs_sub.MoveNext
                    Loop
                  End IF

                  LRs_sub.close
                  
                  '강수 계산##############
                  drowCnt = GetDrowCnt(TouneyCnt)

                  LSQL = " Update tblGameLevelDtl Set TotRound = '"  & drowCnt & "' " 
                  LSQL = LSQL & "   WHERE GameLevelDtlidx = '" &  x & "'" 
                  'Response.Write "SQL :" & LSQL & "<BR>"
                  Set LRs = DBCon.Execute(LSQL)
                End if
              next
            End If		
        End If			
    END IF ' 현재 레벨이 있는지 확인 division이 갖고 부모의 division 과 다른지 확인 
  End IF '레벨 idx가 0보다 큰지 확인, division 0보다 큰지 확인
End IF '
  'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

  LSQL = "SELECT JooDivision "
  LSQL = LSQL & " FROM  tblGameLevel"
  LSQL = LSQL & " WHERE GameLevelidx = " &  tGameLevelIDX
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tJooDivision = LRs("JooDivision")
      LRs.MoveNext
    Loop
  End If
  LRs.close

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

  
<%
  DBClose()
%>

