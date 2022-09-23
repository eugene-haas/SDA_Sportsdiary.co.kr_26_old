

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":15,""NowPage"":1,""tIDX"":""9832C70CDBBB6F8FB311345EF2AD1F2E"",""tGameLevelIDX"":""E80CB108C155AF181F42CE659C455E19"",""JOODIVISION"":""3""}"

  Set oJSONoutput = JSON.Parse(REQ)
	CMD = fInject(oJSONoutput.CMD)
  tPGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tPGameLevelIdx))
  crypt_tPGameLevelidx =crypt.EncryptStringENC(tPGameLevelIdx)
  JooDivision = fInject(oJSONoutput.JOODIVISION)

  'Response.Write "tPGameLevelIdx : " & tPGameLevelIdx & "<br>"
  'Response.Write "crypt_tGameLevelidx : " & crypt_tGameLevelidx& "<br>"
  'Response.Write "JooDivision : " & JooDivision & "<br>"
  'Response.End

  Dim PGameLevelidxs
  Dim Del_GameLevelidxs
  Dim IsGameLevelCnt : IsGameLevelCnt = 0  'Level이 있는지 확인하는 Cnt
  Dim IsChildGameLevelCnt : IsChildGameLevelCnt = 0  'Level에 자식들이 있는지 확인하는 Cnt
  Redim JooIdArr(JooDivision)

  'Response.Write "조 변경 : " & JOODIVISION & "<BR><BR><BR><BR><BR>"

  '중요! 1. 레벨 IDX와 JOODIVISION 이 0보다 커야한다.
  IF  cdbl(tPGameLevelIdx) > 0 Then
    IF(cdbl(JOODIVISION) > 0 ) Then
      LSQL = " SELECT Top 1 GameLevelidx  ,GameTitleIDX, Isnull(PGameLevelidx,'') as PGameLevelidx, JooDivision, GroupGameGb, b.PubName "
      LSQL = LSQL & " FROM  tblGameLevel  a "
      LSQL = LSQL & " LEFT JOIN tblPubcode b on a.GroupGameGb = b.PubCode and b.DelYN = 'N' "
      LSQL = LSQL & " WHERE a.GameLevelidx = '"  & tPGameLevelIdx  & "' and a.DelYn ='N' "
      'Response.Write "LSQL" & LSQL & "<BR><BR><BR><BR><BR>"
      '1. 설명 :LEVEL 자신이 있는지 확인
      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          IsGameLevelCnt = IsGameLevelCnt + 1
          tJooDivision = LRS("JooDivision")
          GroupGameGb = LRS("GroupGameGb")
          GroupGameGbName = LRS("PubName")
          LRs.MoveNext
        Loop
      End IF
      'Response.End
      'Response.Write "IsGameLevelCnt" & IsGameLevelCnt & "<br>"
      'Response.Write "tJooDivision" & tJooDivision & "<br>"
      'Response.Write "GroupGameGb" & GroupGameGb & "<br>"
      'Response.Write "GroupGameGbName" & GroupGameGbName & "<br><br><br><br>"

        '중요! 2. 현재 Division개수와 레벨이 있을 경우
        if cdbl(IsGameLevelCnt) > CDBL(0) and (GroupGameGb = "B0030001" or GroupGameGb =  "B0030002") Then

          '자식이 레벨 데이터가 있는지 확인
          ' 자식 데이터 삭제 로직
          LSQL = " SELECT GameLevelidx , GameTitleIDX, Isnull(PGameLevelidx,'') as PGameLevelidx "
          LSQL = LSQL & "   FROM  tblGameLevel  "
          LSQL = LSQL & " WHERE PGameLevelidx = '"  & tPGameLevelIdx  & "' and DelYn ='N' "
          'Response.Write " 설명 : 자식 데이터 삭제 로직, 레벨에 자식이 있는지 여부 " & "<br>"
          'Response.Write "LSQL : " & LSQL & "<BR><BR><BR><BR><BR>"
          'Response.End

          Set LRs = DBCon.Execute(LSQL)
          IF NOT (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
              IsChildGameLevelCnt =  IsChildGameLevelCnt + 1
              GameLevelidx = LRS("GameLevelidx")
              PGameLevelidx = LRS("PGameLevelidx")
              Del_GameLevelidxs = Del_GameLevelidxs & GameLevelidx & "_"
              LRs.MoveNext
            Loop
          End IF

          'Response.Write "지울 LevelIdx" &  GameLevelidx & "<br>"
          Split_Del_GameLevelidxs = Split(Del_GameLevelidxs,"_")
        
          '중요! 3. 부모레벨에 있는 자식들을 찾아서 Level과 Group, Player를 삭제하는 로직 
          for each x in Split_Del_GameLevelidxs
            if(x <> "") Then
              'response.write(x & "<br />")
              LSQL = " Update tblGameRequestPlayer Set DelYN = 'Y' " 
              LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  x & "'"
              'Response.Write "SQL :" & LSQL & "<BR>"
              Set LRs = DBCon.Execute(LSQL)

              LSQL = " Update tblGameRequestGroup Set DelYN = 'Y' " 
              LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  x & "'"
              'Response.Write "SQL :" & LSQL & "<BR>"
              Set LRs = DBCon.Execute(LSQL)
              
              LSQL = " Update tblGameLevel Set DelYN = 'Y' " 
              LSQL = LSQL & "   WHERE GameLevelidx = '" &  X & "'" 
              'Response.Write "SQL :" & LSQL & "<BR>"
              Set LRs = DBCon.Execute(LSQL)

              LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
              LSQL = LSQL & "   WHERE GameLevelidx = '" &  X & "'" 
              'Response.Write "SQL :" & LSQL & "<BR>"
              Set LRs = DBCon.Execute(LSQL)
            End if
          next

          ' 자식 데이터 생성 로직 개인전
          IF GroupGameGb = "B0030001" Then
            '중요! 4.  부모 LEVEL의 그룹 카운트를 가져온다.
            LSQL = " SELECT COUNT(*) as GroupCnt "
            LSQL = LSQL & "FROM  tblGameRequestGroup   "
            LSQL = LSQL & " WHERE GameLevelIDX = '"  & tPGameLevelIdx  & "' and DelYn ='N' "
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
              
            'Response.WRite "JooGroup : " & JooGroup & "<br><br><br>"
            '조를 여러개 만ㄷ느는 로직
            '중요! 5.  부모 LEVEL의 그룹 카운트만큼 반복문을 하면서  새로 만든 Level에 넣어준다.
            For i = 1 To cdbl(JOODIVISION)
              'Response.Write "SQL :" & LSQL & "<BR>"
              'Response.Write "i" & i  & "<BR>"
              LSQL = " SET NOCOUNT ON insert into tblGameLevel " 
              LSQL = LSQL & " ( GameTitleIDX , PGameLevelidx , PlayType , GameType , TeamGb , Level , Sex , GroupGameGb , GameDay , GameTime , LevelJooName , LevelJooNum , SeedCnt , JooDivision , JooRank , OrderbyNum, StadiumNum) "
              LSQL = LSQL & " SELECT GameTitleIDX , " &  tPGameLevelIdx &  " , PlayType , GameType , TeamGb , Level , Sex , GroupGameGb , GameDay , GameTime , LevelJooName , " &  i & " , SeedCnt , JooDivision , JooRank , OrderbyNum, StadiumNum FROM  tblGameLevel " 
              LSQL = LSQL & " where GameLevelidx = " & tPGameLevelIdx
              LSQL = LSQL & " SELECT @@IDENTITY as IDX "
            
              Set LRs = DBCon.Execute(LSQL)
              IF NOT (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                  PGameLevelidx = LRs("IDX")
                  PGameLevelidxs = PGameLevelidxs & PGameLevelidx & "_"
                LRs.MoveNext
                Loop
              End If  
            Next
            Split_PGameLevelidxs = Split(PGameLevelidxs,"_")
            splitCnt = 0
            '새로 만든 LevelDtl          
            for each x in Split_PGameLevelidxs
              if(x <> "" )Then
                JooIdArr(splitCnt) = x
                splitCnt = splitCnt + 1
                'response.write("Split_PGameLevelidxs : " &  x & "<br />")
              End if
            next
            
            'Response.Write PGameLevelidxs & "<br>"
            'Level에 참여된 인원
            '중요! 6.  부모 LEVEL의 그룹을 전체를 복사해서 넣는다.
            LSQL = " SELECT GameRequestGroupIDX  "
            LSQL = LSQL & " FROM  tblGameRequestGroup "
            LSQL = LSQL & " where GameLevelIDX = '" & tPGameLevelIdx & "' and DelYN='N' "
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
              GameRequestGroupArray = LRs.getrows()
            End If

            RequestGroupArrayCnt = 0 

        
            If IsArray(GameRequestGroupArray) Then
                For ar = LBound(GameRequestGroupArray, 2) To UBound(GameRequestGroupArray, 2) 
                  tGameRequestGroupIDX		= GameRequestGroupArray(0, ar) 
                  RequestGroupArrayCnt = RequestGroupArrayCnt + 1
                  currentArrayJoo =  (RequestGroupArrayCnt Mod JOODIVISION) - 1
                  
                  if(currentArrayJoo < 0) Then
                    currentArrayJoo = JOODIVISION - 1
                  End IF

                  LSQL = "EXEC tblGameRequestGroup_Copy '" & tGameRequestGroupIDX & "','" & JooIdArr(currentArrayJoo) & "'"
                  Set LRs = DBCon.Execute(LSQL)
                  'Response.WRite "LSQL : "  & LSQL & "<br>"
                  'Response.WRite "RequestGroupArrayCnt : "  & RequestGroupArrayCnt & "<br>"
                  'Response.WRite "currentJoo : "  & currentArrayJoo & "<br>"
                  'Response.WRite "Jooid : "  & JooIdArr(currentArrayJoo) & "<br>"
                  'Response.WRite "tGameRequestGroupIDX : "  & tGameRequestGroupIDX & "<br>"
                Next
            End If			
            'RESPONSE.WRITE LSQL & "<BR>"
          END IF

          '  자식 데이터 생성 로직 단체전
          IF GroupGameGb = "B0030002" Then
            '중요! 7.  부모 LEVEL의 그룹 카운트를 가져온다.
            LSQL = " SELECT COUNT(*) as TeamCnt "
            LSQL = LSQL & "FROM  tblGameRequestTeam   "
            LSQL = LSQL & " WHERE GameLevelIDX = '"  & tPGameLevelIdx  & "' and DelYn ='N' "
            'Response.Write "단체전 : 참여 팀 수 " & "<br>"
            
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                TeamCnt = LRS("TeamCnt")
                'Response.WRite "총 팀 개수 : " & TeamCnt & "<br><br><br>"
                LRs.MoveNext
              Loop
            End IF
              
            'Response.WRite "JooGroup : " & JooGroup & "<br><br><br>"
            '조를 여러개 만ㄷ느는 로직
            '중요! 8.  부모 LEVEL의 그룹을 전체를 복사해서 넣는다.
            For i = 1 To cdbl(JOODIVISION)
              'Response.Write "SQL :" & LSQL & "<BR>"
              'Response.Write "i" & i  & "<BR>"
              LSQL = " SET NOCOUNT ON insert into tblGameLevel " 
              LSQL = LSQL & " ( GameTitleIDX , PGameLevelidx , PlayType , GameType , TeamGb , Level , Sex , GroupGameGb , GameDay , GameTime , LevelJooName , LevelJooNum , SeedCnt , JooDivision , JooRank , OrderbyNum, StadiumNum) "
              LSQL = LSQL & " SELECT GameTitleIDX , " &  tPGameLevelIdx &  " , PlayType , GameType , TeamGb , Level , Sex , GroupGameGb , GameDay , GameTime , LevelJooName , " &  i & " , SeedCnt , JooDivision , JooRank , OrderbyNum, StadiumNum FROM  tblGameLevel " 
              LSQL = LSQL & " where GameLevelidx = " & tPGameLevelIdx
              LSQL = LSQL & " SELECT @@IDENTITY as IDX "
            
              Set LRs = DBCon.Execute(LSQL)
              IF NOT (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                  PGameLevelidx = LRs("IDX")
                  PGameLevelidxs = PGameLevelidxs & PGameLevelidx & "_"
                LRs.MoveNext
                Loop
              End If  
            Next
            Split_PGameLevelidxs = Split(PGameLevelidxs,"_")
            splitCnt = 0
            '새로 만든 LevelDtl          
            for each x in Split_PGameLevelidxs
              if(x <> "" )Then
                JooIdArr(splitCnt) = x
                splitCnt = splitCnt + 1
                'response.write("Split_PGameLevelidxs : " &  x & "<br />")
              End if
            next

            'Response.Write PGameLevelidxs & "<br>"
            ' Level에 참여된 인원
            '중요! 9.  부모 LEVEL의 팀 카운트만큼 반복문을 하면서  새로 만든 Level에 넣어준다.
            LSQL = " SELECT GameRequestTeamIDX  "
            LSQL = LSQL & " FROM  tblGameRequestTeam "
            LSQL = LSQL & " where GameLevelIDX = '" & tPGameLevelIdx & "' and DelYN='N' "
            Set LRs = DBCon.Execute(LSQL)
            IF NOT (LRs.Eof Or LRs.Bof) Then
              GameRequestTeamArray = LRs.getrows()
            End If
            
            'Response.write "LSQL : " & LSQL & "<BR><BR><BR><BR><BR>"
            'Response.End

            RequestTeamArrayCnt = 0 

            If IsArray(GameRequestTeamArray) Then
                For ar = LBound(GameRequestTeamArray, 2) To UBound(GameRequestTeamArray, 2) 
                  tGameRequestTeamIDX		= GameRequestTeamArray(0, ar) 
                  RequestTeamArrayCnt = RequestTeamArrayCnt + 1
                  currentArrayJoo =  (RequestTeamArrayCnt Mod JOODIVISION) - 1
                  
                  if(currentArrayJoo < 0) Then
                    currentArrayJoo = JOODIVISION - 1
                  End IF

                  LSQL = "EXEC tblGameRequestTeam_Copy '" & tGameRequestTeamIDX & "','" & JooIdArr(currentArrayJoo) & "'"
                  Set LRs = DBCon.Execute(LSQL)
                  'Response.WRite "LSQL : "  & LSQL & "<br>"
                  'Response.WRite "RequestGroupArrayCnt : "  & RequestGroupArrayCnt & "<br>"
                  'Response.WRite "currentJoo : "  & currentArrayJoo & "<br>"
                  'Response.WRite "Jooid : "  & JooIdArr(currentArrayJoo) & "<br>"
                  'Response.WRite "tGameRequestGroupIDX : "  & tGameRequestGroupIDX & "<br>"
                Next
            End If			
          END IF

          ' 자식 데이터 생성 로직 
          LSQL = " UPDATE  tblGameLevel " 
          'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
          LSQL = LSQL & " SET JooDivision = '" & JooDivision & "', UseYN = 'N' "
          LSQL = LSQL & " Where GameLevelidx = '" & tPGameLevelIdx & "'"
          'Response.Write LSQL
          Set LRs = DBCon.Execute(LSQL)
        END IF ' 현재 레벨이 있는지 확인 division이 갖고 부모의 division 과 다른지 확인 

      Else

        ' 자식 데이터 삭제 로직
        LSQL = " SELECT GameLevelidx , GameTitleIDX, Isnull(PGameLevelidx,'') as PGameLevelidx "
        LSQL = LSQL & "   FROM  tblGameLevel  "
        LSQL = LSQL & " WHERE PGameLevelidx = '"  & tPGameLevelIdx  & "' and DelYn ='N' "
        'Response.Write " 설명 : 자식 데이터 삭제 로직, 레벨에 자식이 있는지 여부 " & "<br>"
        'Response.Write "LSQL : " & LSQL & "<BR><BR><BR><BR><BR>"
        'Response.End

        Set LRs = DBCon.Execute(LSQL)
        IF NOT (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
            IsChildGameLevelCnt =  IsChildGameLevelCnt + 1
            GameLevelidx = LRS("GameLevelidx")
            PGameLevelidx = LRS("PGameLevelidx")
            Del_GameLevelidxs = Del_GameLevelidxs & GameLevelidx & "_"
            LRs.MoveNext
          Loop
        End IF

        'Response.Write "지울 LevelIdx" &  GameLevelidx & "<br>"
        Split_Del_GameLevelidxs = Split(Del_GameLevelidxs,"_")
      
        '중요! 3. 부모레벨에 있는 자식들을 찾아서 Level과 Group, Player를 삭제하는 로직 
        for each x in Split_Del_GameLevelidxs
          if(x <> "") Then
            'response.write(x & "<br />")
            LSQL = " Update tblGameRequestPlayer Set DelYN = 'Y' " 
            LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  x & "'"
            'Response.Write "SQL :" & LSQL & "<BR>"
            Set LRs = DBCon.Execute(LSQL)

            LSQL = " Update tblGameRequestGroup Set DelYN = 'Y' " 
            LSQL = LSQL & "   WHERE GameRequestGroupIDX = '" &  x & "'"
            'Response.Write "SQL :" & LSQL & "<BR>"
            Set LRs = DBCon.Execute(LSQL)
            
            LSQL = " Update tblGameLevel Set DelYN = 'Y' " 
            LSQL = LSQL & "   WHERE GameLevelidx = '" &  X & "'" 
            'Response.Write "SQL :" & LSQL & "<BR>"
            Set LRs = DBCon.Execute(LSQL)

            LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
            LSQL = LSQL & "   WHERE GameLevelidx = '" &  X & "'" 
            Set LRs = DBCon.Execute(LSQL)
          End if
        next

        LSQL = " Update tblGameLevelDtl Set DelYN = 'Y' " 
        LSQL = LSQL & "   WHERE GameLevelidx = '" &  tPGameLevelIdx & "'" 
        Set LRs = DBCon.Execute(LSQL)

        ' 자식 데이터 생성 로직 
        LSQL = " UPDATE  tblGameLevel " 
        'LSQL = LSQL & " SET EntryCnt = '" & tEntryCnt & "', PlayLevelType  =  '" & tPlayLevelType & "',  GameType  =  '" & tGameType & "', StadiumNumber  = '" & tStadiumNumber &"'  , TotRound  = '" & tTotalRound & "'  , GameDay  = '"  & tGameDay & "'  , GameTime  = '" & tGameTime & "', ViewYN = '" & ViewYN & "', LevelJooName = '" & tLevelJoo & "',LevelJooNum = '" & tLevelJooNum & "'" 
        LSQL = LSQL & " SET JooDivision = '" & JooDivision & "', UseYN = 'Y' "
        LSQL = LSQL & " Where GameLevelidx = '" & tPGameLevelIdx & "'"
        'Response.Write LSQL
        Set LRs = DBCon.Execute(LSQL)
    End IF
  End IF
  'Call oJSONoutput.Set("result", 0 )
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

  LSQL = "SELECT JooDivision "
  LSQL = LSQL & " FROM  tblGameLevel"
  LSQL = LSQL & " WHERE GameLevelidx = " &  tPGameLevelIdx
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


