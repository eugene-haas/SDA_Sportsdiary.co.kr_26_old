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
  REQ = Request("Req")
  'REQ = "{""tGameTitleIdx"":""78660146D434CFADE660EA07CF4BDCA2"",""CMD"":2,""tTeamGb"":"""",""tPlayTypeSex"":"""",""tLevel"":"""",""tRankingValue"":""""}"
  'REQ = "{""tGameTitleIdx"":""A0B63180CC3215B403232E31C8E393B4"",""CMD"":2,""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tTeamGb"":""2F9A5AB5A680D3EDDEE944350E247FCB|Mix"",""tPlayTypeSex"":"""",""tLevel"":"""",""tRankingValue"":""""}"
  
  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    reqGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
    crypt_reqGroupGameGb =crypt.EncryptStringENC(reqGroupGameGb)
  Else
    reqGroupGameGb = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = ""
  End if	

  If hasown(oJSONoutput, "tTeamGb") = "ok" then
    reqTeamGb= fInject(oJSONoutput.tTeamGb)
    If InStr(reqTeamGb,"|") > 1 Then
      arr_reqTeamGb = Split(reqTeamGb,"|")
      reqTeamGb = fInject(crypt.DecryptStringENC(arr_reqTeamGb(0)))
      crypt_reqTeamGb =crypt.EncryptStringENC(reqTeamGb)
      reqTeamGbSex = fInject(arr_reqTeamGb(1))
    End IF
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

  If hasown(oJSONoutput, "tRankingValue") = "ok" then
    reqRankingValue= fInject(oJSONoutput.tRankingValue)
  End if	


  '예선 본선 값 설정
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B003'"
  LSQL = LSQL & " ORDER BY OrderBy "
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arryGroupGameGb = LRs.getrows()
  End If


  
  
LSQL = " SELECT GameLevelDtlIDX,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
LSQL = LSQL & " B.PlayLevelType,"
LSQL = LSQL & " A.GameType"
LSQL = LSQL & " FROM tblGameLevel A"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
LSQL = LSQL & " INNER JOIN tblTeamGbInfo C ON C.TeamGb = A.TeamGb AND C.DelYN='N'"

If reqTeamGbSex <> "" AND reqSex = "" Then
  LSQL = LSQL & " AND A.Sex = '" & reqTeamGbSex & "' "
End If

LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND B.PlayLevelType = 'B0100001'"

If reqGameTitleIdx <> "" Then
    LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "' "
End If

If reqGroupGameGb <> "" Then
    LSQL = LSQL & " AND A.GroupGameGb = '" & reqGroupGameGb & "' "
End If

If reqTeamGb <> "" AND reqTeamGb <> "0" Then
    LSQL = LSQL & " AND A.TeamGb = '" & reqTeamGb & "' "
End If

If reqSex <> "" AND reqSex <> "0" Then
    LSQL = LSQL & " AND A.Sex = '" & reqSex & "' "
End If

If reqPlayType <> "" AND reqPlayType <> "0" Then
    LSQL = LSQL & " AND A.PlayType = '" & reqPlayType & "' "
End If

If reqLevel <> "" AND reqLevel <> "0" Then
    LSQL = LSQL & " AND A.Level = '" & reqLevel & "' "
End If

If reqLevelJooName <> "" AND reqLevelJooName <> "0" Then
    LSQL = LSQL & " AND A.LevelJooName = '" & reqLevelJooName & "' "
End If

If reqLevelJooNum <> "" AND reqLevelJooNum <> "0" Then
    LSQL = LSQL & " AND A.LevelJooNum = '" & reqLevelJooNum & "' "
End If  



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
  Arr_Info = LRs.getrows()
End If

IF IsArray(Arr_Info) Then
  Arr_InfoLength = UBOUND(Arr_Info,2)
ELSE 
  Arr_InfoLength = 0
End IF

IF IsArray(Arr_Info) Then
  For i = 0 To Arr_InfoLength
    If i = 0 Then
      LevelDtlLSQL = LevelDtlLSQL & " ( A.GameLevelDtlidx = ''" & Arr_Info(0,i) & "''"
    Else
      LevelDtlLSQL  = LevelDtlLSQL  & " OR A.GameLevelDtlidx = ''" & Arr_Info(0,i) & "''"
    End If
  NEXT
END IF

IF cdbl(Arr_InfoLength) > 0 And Cdbl(Len(LevelDtlLSQL)) > 0  Then
  LevelDtlLSQL  = LevelDtlLSQL  & " ) "
End IF



 ' Request 값 확인 영역
  'Response.WrIte "reqGameTitleIdx : " & reqGameTitleIdx  & "<br/>"
  'Response.WrIte "reqGroupGameGb : " & reqGroupGameGb  & "<br/>"
  'Response.WrIte "reqPlayTypeSex : " & reqPlayTypeSex  & "<br/>"
  'Response.WrIte "reqSex  : " & reqSex   & "<br/>"
  'Response.WrIte "reqPlayType : " & reqPlayType   & "<br/>"
  'Response.WrIte "reqLevel : " & reqLevel & "<br/>"
  'Response.WrIte "reqLevelJooName : " & reqLevelJooName   & "<br/>"
  'Response.WrIte "reqLevelJooNum : " & reqLevelJooNum   & "<br/>"
  %>

  <%
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.write "`##`"
    'Response.Write "reqTeamGbSex :" & reqTeamGbSex & "<bR><bR><bR><bR><bR>"
  %>

    <label>
      <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 
            if(tGroupGameGbName = "개인전") Then
      %>
            <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>"  onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
            <span>개인전</span>
      <%
            END IF
          Next
        End If      
      %>
    </label>

    <label>
         <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 

            if(tGroupGameGbName = "단체전") Then
              %>
                <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>" onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
                <span>단체전</span>
              <%
            END IF
          Next
        End If      
      %>
    </label>

    <select id="selPlayTypeSex" name="selPlayTypeSex"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
      <%
          LSQL = " SELECT  Sex, PlayType, SexName = (case Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  ), KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
          LSQL = LSQL & " FROM tblGameLevel"
          LSQL = LSQL & " WHERE DelYN = 'N'"
          LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
            IF reqGroupGameGb <> "" Then
            LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
          End IF
          LSQL = LSQL & " GROUP BY Sex, PlayType"
          
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
              tSex = LRs("Sex")
              crypt_tSex = crypt.EncryptStringENC(tSex)
              tSexName= LRs("SexName")
              tPlayType = LRs("PlayType")
              crypt_tPlayType= crypt.EncryptStringENC(tPlayType)
              tPlayTypeName= LRs("PlayTypeName")

              IF (reqSex = tSex) and  (reqPlayType = tPlayType) Then %>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" selected><%=tSexName & tPlayTypeName%></option>
              <%Else%>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" ><%=tSexName & tPlayTypeName%></option>
              <%End IF
              LRs.MoveNext()
              Loop
            End If   
          LRs.Close        
          %>
    </select>


    <% 'Response.Write " LSQL : " & LSQL & "<BR/>"  %>
    <select id="selTeamGb" name="selTeamGb"  onChange='OnGameLevelChanged(<%=strjson%>)'>
        <option value="">::부서 선택::</option>
      <%
        LSQL = " SELECT a.TeamGb, KoreaBadminton.dbo.FN_NameSch(a.TeamGb,'TeamGb') AS TeamGbNm,a.Sex,"
        LSQL = LSQL & " SexNm = (case a.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  )"
        LSQL = LSQL & " FROM tblGameLevel a"
        LSQL = LSQL & " inner Join tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN = 'N'"
        LSQL = LSQL & " WHERE a.DelYN = 'N'"
        LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
        IF reqGroupGameGb <> "" Then
          LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
        End IF
        IF ReqSex <> "" Then
          LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
        End IF
        IF ReqPlayType <> "" Then
          LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
        End IF
        LSQL = LSQL & " GROUP BY a.TeamGb, Sex"
        Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            tTeamGb = LRs("TeamGb")
            crypt_tTeamGb = crypt.EncryptStringENC(tTeamGb)
            tSexNm = LRs("SexNm")
            tSex = LRs("Sex")
            IF (reqTeamGb = tTeamGb And reqTeamGbSex = tSex) Then
            %>
            <option value="<%=crypt_tTeamGb%>|<%=tSex%>" selected ><%=LRs("TeamGbNM")%>-<%=tSexNm%></option>
            <% ELSE  %>
            <option value="<%=crypt_tTeamGb%>|<%=tSex%>" <%If TeamGb =  crypt.EncryptStringENC(LRs("TeamGb")) Then%>selected<%End If %>><%=LRs("TeamGbNM")%>-<%=tSexNm%></option>
            <% END IF
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         
        %>
        
    </select>

    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
   <select  id="selLevel" name="selLevel"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
        <% 
            LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNm , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNameNm, LevelJooName,LevelJooNum "
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND UseYN = 'Y' "
            LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "' "
            IF reqGroupGameGb <> "" Then
              LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
            End IF
            IF ReqSex <> "" Then
              LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
            End IF
            IF ReqPlayType <> "" Then
              LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
            End IF
            IF reqTeamGb <> "" Then
              LSQL = LSQL & " AND TeamGb = '" & reqTeamGb & "'"
            End IF
            LSQL = LSQL & " AND Level <> '' "
            LSQL = LSQL & " And (LevelJooName <> '' or LevelJooName <> 'B0120007')  "
            LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"
            
             Set LRs = Dbcon.Execute(LSQL)
                IF Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                  tLevel = LRs("Level")
                  crypt_tLevel = crypt.EncryptStringENC(tLevel)
                  tLevelNM = LRs("LevelNm")

                  tLevelJooName = LRs("LevelJooName")
                  crypt_tLevelJooName = crypt.EncryptStringENC(tLevelJooName)

                  tLevelJooNameNm= LRs("LevelJooNameNm")

                  IF(tLevelJooNameNm = "미선택") Then
                    tLevelJooNameNm = ""
                  End IF

                  tLevelJooNum = LRs("LevelJooNum") 
                  IF (reqLevel = tLevel) AND (reqLevelJooName = tLevelJooName) And (reqLevelJooNum = tLevelJooNum) Then%>      
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>" selected> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%ELSE%>
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>"> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%
                  END IF
                    LRs.MoveNext()
                  Loop
                End If   
              LRs.Close %>
    </select>
<%
  IF reqRankingValue = "" Then
      reqRankingValue = 0
  end if

%>
    <select id="selRanking" name="selRanking" onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::랭킹 선택::</option>
        <% 
            LSQL = " tblGameLevelDtlRanking_Searched_STR   '" & reqGameTitleIdx & "', '" &LevelDtlLSQL &"','" &reqGroupGameGb &"' "

            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof  
                tRanking = LRs("TRanking")
                IF cdbl(tRanking) = cdbl(reqRankingValue) Then
                    %>
                    <option value="<%=tRanking%>" selected> <%=tRanking%> 위</option>
                  <%
                ELSE
                %>
                    <option value="<%=tRanking%>"> <%=tRanking%> 위</option>
                  <%
                End IF
                LRs.MoveNext()
              Loop
            End If   
            LRs.Close 
      %>
    </select>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>


    <a href='javascript:OnRankingResultClick(<%=strjson%>)'>조회</a>
    <a href='javascript:OnRankingResultExcelClick(<%=strjson%>);'>출력</a>
    <a href='javascript:OnFinalTournamentClick(<%=strjson%>)'>본선진출</a>