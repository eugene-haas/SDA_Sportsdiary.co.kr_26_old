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
	Dim LSQL
	Dim LRs
	Dim strjson
	Dim strjson_sum

	Dim oJSONoutput_SUM
	Dim oJSONoutput

	Dim CMD  
	Dim GameTitleIDX 	

  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tGameTitleIDX"":""BF242F3A46C5952F1DF14D02620F1AB7"",""tGameDay"":""2018-05-10"",""tStadiumIDX"":""2C8A53B33C9D84DEB970F5A46AEF583C"",""tStadiumNumber"":"""",""tSearchName"":"""",""tPlayLevelType"":""""}"
  Set oJSONoutput = JSON.Parse(REQ)


  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
    DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  Else  
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
  End if	

	If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(crypt.DecryptStringENC(oJSONoutput.tGameDay))    
    End If
  Else  
    GameDay = ""
    DEC_GameDay = ""
	End if	

	If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))    
    End If
  Else  
    StadiumIDX = ""
    DEC_StadiumIDX = ""
	End if	

	If hasown(oJSONoutput, "tStadiumNumber") = "ok" then
    If ISNull(oJSONoutput.tStadiumNumber) Or oJSONoutput.tStadiumNumber = "" Then
      StadiumNumber = ""
      DEC_StadiumNumber = ""        
    Else
      StadiumNumber = fInject(oJSONoutput.tStadiumNumber)
      DEC_StadiumNumber = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumNumber))
    End If
  Else  
    StadiumNumber = ""
    DEC_StadiumNumber = ""
	End if	

  If hasown(oJSONoutput, "tPlayLevelType") = "ok" then
    If ISNull(oJSONoutput.tPlayLevelType) Or oJSONoutput.tPlayLevelType = "" Then
      PlayLevelType = ""
      DEC_PlayLevelType = ""        
    Else
      PlayLevelType = fInject(oJSONoutput.tPlayLevelType)
      DEC_PlayLevelType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayLevelType))
    End If
  Else  
    PlayLevelType = ""
    DEC_PlayLevelType = ""
	End if	

  If hasown(oJSONoutput, "tGroupGameGB") = "ok" then
    If ISNull(oJSONoutput.tGroupGameGB) Or oJSONoutput.tGroupGameGB = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""        
    Else
      GroupGameGb = fInject(oJSONoutput.tGroupGameGB)
      DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGB))
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
	End if	


  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
  <select id="selGameDay" name="selGameDay" onchange="OnSearchChanged();">
  <option value="">::경기일자 선택::</option>
  <%

    LSQL = " SELECT GameDay"
    LSQL = LSQL & " FROM "
    LSQL = LSQL & " ("
    LSQL = LSQL & " SELECT A.GameDay"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
    LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
    LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    LSQL = LSQL & " AND A.GameDay IS NOT NULL"
    LSQL = LSQL & " "
    LSQL = LSQL & " UNION ALL"
    LSQL = LSQL & " "
    LSQL = LSQL & " SELECT A.GameDay"
    LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
    LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
    LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
    LSQL = LSQL & " AND A.GameDay IS NOT NULL"
    LSQL = LSQL & " ) AS AA"
    LSQL = LSQL & " GROUP BY AA.GameDay"
    'Response.Write "LSQL" & LSQL & "<BR/>"
    Set LRs = Dbcon.Execute(LSQL)


    If Not (LRs.Eof Or LRs.Bof) Then

      Do Until LRs.Eof
    %>
        <option value="<%=LRs("GameDay") %>" <%If GameDay = LRs("GameDay") Then%>selected<%End If%>><%=LRs("GameDay") %></option>
    <%
        LRs.MoveNext
      Loop

    End If

    LRs.Close
  %>
  </select>
            <% 'Response.Write "<BR/><BR/><BR/><BR/>" & "LSQL" & LSQL & "<BR/><BR/><BR/><BR/>"%>
              
            <select id="selStadiumIDX" name="selStadiumIDX" onchange="OnSearchChanged();">
            <option value="">::경기장소 선택::</option>
              <%
                LSQL = " SELECT AA.StadiumIDX, AA.StadiumName"
                LSQL = LSQL & " FROM"
                LSQL = LSQL & " ("
                LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " FROM tblTourney A"
                LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N' "
                LSQL = LSQL & " AND B.DelYN = 'N'"
                LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
                IF GameDay <> "" Then
                LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
                END IF    
                LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
                LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " "
                LSQL = LSQL & " UNION ALL"
                LSQL = LSQL & " "
                LSQL = LSQL & " SELECT A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " FROM tblTourneyTeam A"
                LSQL = LSQL & " INNER JOIN tblStadium B ON B.StadiumIDX = A.StadiumIDX"
                LSQL = LSQL & " WHERE A.DelYN = 'N' "
                LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
                IF GameDay <> "" Then
                LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
                END IF
                LSQL = LSQL & " AND ISNULL(A.StadiumIDX,'') <> ''"
                LSQL = LSQL & " GROUP BY A.StadiumIDX, B.StadiumName"
                LSQL = LSQL & " ) AA"
                LSQL = LSQL & " GROUP BY AA.StadiumIDX, AA.StadiumName"
              
                Set LRs = Dbcon.Execute(LSQL)

                If Not (LRs.Eof Or LRs.Bof) Then

                    Set oJSONoutput = jsArray()

                  Do Until LRs.Eof

                %>
                    <option value="<%=crypt.EncryptStringENC(LRs("StadiumIDX"))%>" <%If DEC_StadiumIDX = LRs("StadiumIDX") Then%>selected<%End If%>><%=LRs("StadiumName")%></option>
                <%

                    LRs.MoveNext
                  Loop

                Else

                End If            

                LRs.Close    
              %>
            </select>
            <% 'Response.Write "<BR/><BR/><BR/><BR/>" & "LSQL" & LSQL & "<BR/><BR/><BR/><BR/>"%>
            <select id="selStadiumNumber" name="selStadiumNumber" onchange="OnSearchChanged();">
            <option value="">코트 선택</option>
              <%
              LSQL = " SELECT StadiumNum"
              LSQL = LSQL & " FROM"
              LSQL = LSQL & " ("
              LSQL = LSQL & " SELECT StadiumNum"
              LSQL = LSQL & " FROM tblTourney A "
              LSQL = LSQL & " WHERE A.DelYN = 'N' "
              LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
              IF GameDay <> "" Then
                LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
              END IF
              IF DEC_StadiumIDX <> "" Then
                LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
              END IF
              LSQL = LSQL & " AND ISNULL(StadiumNum,'') <> ''"
              LSQL = LSQL & " GROUP BY StadiumNum"
              LSQL = LSQL & " "
              LSQL = LSQL & " UNION ALL"
              LSQL = LSQL & " "
              LSQL = LSQL & " SELECT StadiumNum"
              LSQL = LSQL & " FROM tblTourneyTeam A "
              LSQL = LSQL & " WHERE A.DelYN = 'N' "
              LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
              IF GameDay <> "" Then
                LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
              END IF
              IF DEC_StadiumIDX <> "" Then
                LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
              END IF
              LSQL = LSQL & " AND ISNULL(StadiumNum,'') <> ''"
              LSQL = LSQL & " GROUP BY StadiumNum"
              LSQL = LSQL & " ) AS AA"
              LSQL = LSQL & " GROUP BY StadiumNum"
              LSQL = LSQL & " ORDER BY CONVERT(Bigint,StadiumNum)"

              Set LRs = Dbcon.Execute(LSQL)

              If Not (LRs.Eof Or LRs.Bof) Then

                Do Until LRs.Eof
              %>
                  <option value="<%=LRs("StadiumNum") %>" <%If StadiumNumber = LRs("StadiumNum") Then%>selected<%End If%>><%=LRs("StadiumNum") %>코트</option>
              <%
                  LRs.MoveNext
                Loop

              Else

              End If      

              LRs.Close        
              %>
            </select>


    <select id="selGroupGameGb" onChange='OnSearchChanged()'>
      <option value="">경기유형 선택</option>
        <%
        LSQL = "  SELECT GroupGameGb,GroupGameGbNM  "
        LSQL = LSQL & " FROM"
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT C.GroupGameGb, dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
        IF GameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
        END IF
        IF DEC_StadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
        END IF
        IF StadiumNumber <> "" Then
        LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
        End IF
        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT C.GroupGameGb, dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A  "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON A.GameLevelIdx = C.GameLevelidx AND C.DelYN ='N'  "
        LSQL = LSQL & " WHERE A.DelYN = 'N' "
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
        IF GameDay <> "" Then
          LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
        END IF
        IF DEC_StadiumIDX <> "" Then
          LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
        END IF
        IF StadiumNumber <> "" Then
        LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
        End IF
        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " GROUP BY AA.GroupGameGb,AA.GroupGameGbNM"
        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("GroupGameGb")) %>" 
            <%
            If DEC_GroupGameGb = LRs("GroupGameGb") Then
            %>
            selected
            <%End If%>>
            <%=LRs("GroupGameGbNM") %>
            </option>
        <%
            LRs.MoveNext
          Loop
        Else
        End If      
        LRs.Close        
        %>
    </select>

      <% 'Response.Write "<BR/><BR/><BR/><BR/>" & "LSQL" & LSQL & "<BR/><BR/><BR/><BR/>"%>
    <select id="selPlayLevelType" onChange='OnSearchChanged()'>
      <option value="">경기구분 선택</option>

        <%
      LSQL = " SELECT PlayLevelType,PlayLevelTypeNM "
      LSQL = LSQL & " FROM"
      LSQL = LSQL & " ("
      LSQL = LSQL & " SELECT  C.PlayLevelType, dbo.FN_NameSch(C.PlayLevelType, 'PubCode') AS PlayLevelTypeNM"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A "
      LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N'"
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF GameDay <> "" Then
        LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
      END IF
      IF DEC_StadiumIDX <> "" Then
        LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
      END IF
      IF StadiumNumber <> "" Then
      LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
      End IF
      IF DEC_GroupGameGb <> "" Then
       LSQL = LSQL & " AND E.GroupGameGb = '" & DEC_GroupGameGb & "'"
      End IF
      LSQL = LSQL & " "
      LSQL = LSQL & " UNION ALL"
      LSQL = LSQL & " "
      LSQL = LSQL & " SELECT C.PlayLevelType, dbo.FN_NameSch(C.PlayLevelType, 'PubCode') AS PlayLevelTypeNM"
      LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A  "
      LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
      LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel E ON A.GameLevelIdx = E.GameLevelidx AND E.DelYN ='N'  "
      LSQL = LSQL & " WHERE A.DelYN = 'N' "
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      IF GameDay <> "" Then
        LSQL = LSQL & " AND A.GameDay = '" & GameDay & "'"
      END IF
      IF DEC_StadiumIDX <> "" Then
        LSQL = LSQL & " AND A.StadiumIDX = '" & DEC_StadiumIDX & "'"
      END IF
      IF StadiumNumber <> "" Then
      LSQL = LSQL & " AND A.StadiumNum = '" & StadiumNumber & "'"
      End IF
      IF DEC_GroupGameGb <> "" Then
       LSQL = LSQL & " AND E.GroupGameGb = '" & DEC_GroupGameGb & "'"
      End IF
      LSQL = LSQL & " ) AS AA"
      LSQL = LSQL & " GROUP BY AA.PlayLevelType,AA.PlayLevelTypeNM"
      

      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
      %>
          <option value="<%=LRs("PlayLevelType") %>" 
          <%
          If PlayLevelType = LRs("PlayLevelType") Then
          %>
          selected
          <%End If%>>
          <%=LRs("PlayLevelTypeNM") %>
          </option>
      <%
          LRs.MoveNext
        Loop
      Else
      End If      
      LRs.Close        
      %>
    </select>
    <% 'Response.Write "<BR/><BR/><BR/><BR/>" & "LSQL" & LSQL & "<BR/><BR/><BR/><BR/>"%>
    <input type="text" id="txtSearchName" name="txtSearchName" placeholder="이름을 검색하세요">

    <a href="javascript:OnSearchClick();" class="gray_btn">검색</a>
<%

Set LRs = Nothing
DBClose()
  
%>