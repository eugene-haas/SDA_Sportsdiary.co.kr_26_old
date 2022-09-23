<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":11,""tIDX"":""526FFDE5660B3F06ACFE218964EC6917"",""tGAMELEVELIDX"":167}"
  Set oJSONoutput = JSON.Parse(REQ)
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
	tGameLevelIDX = fInject(crypt.DecryptStringENC(oJSONoutput.TGAMELEVELIDX))
  crypt_tGameLevelIDX =crypt.EncryptStringENC(tGameLevelIDX)
   

  LSQL = " SELECT Top 1 EnterType, GameTitleName, GameS, GameE"
  LSQL = LSQL & " FROM  tblGameTitle a"
  LSQL = LSQL & " WHERE DELYN = 'N' and GameTitleIDX= '" & tidx & "'"
  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        tEnterType = LRs("EnterType")
        tGameTitleName = LRs("GameTitleName")
        tGameS = LRs("GameS")
        tGameE = LRs("GameE")
        %>
          <!--#include file="../../html/GameTitleMenu/GameTitleList.asp"-->
        <%
      LRs.MoveNext
    Loop
  End If
  LRs.close

  '경기타입 (단식,복식,혼합복식)
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B002'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameType = LRs.getrows()
  End If
  'RESPONSE.WRITE LSQL & "<BR>"

  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='Sex'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrSex = LRs.getrows()
  End If

  '구분 (개인전,단체전)
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B003'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrDivision = LRs.getrows()
  End If
  'RESPONSE.WRITE LSQL & "<BR>"

  LSQL = "SELECT TeamGb ,TeamGbNm  "
  LSQL = LSQL & "FROM  tblTeamGbInfo "
  LSQL = LSQL & "Where EnterType = '" & tEnterType & "' And DelYN = 'N'"
  LSQL = LSQL & "ORDER BY Orderby DESC"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrTeamGb = LRs.getrows()
  End If

    
	LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B011'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayJoo = LRs.getrows()
  End If

	LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B012'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayJooNum = LRs.getrows()
  End If
%>

<%
  LSQL = " SELECT Top 1 GameLevelidx, GameTitleIDX, PlayType, GameType, TeamGb,Level, Sex, GroupGameGb, GameDay, GameTime,ViewYN, LevelJooName, LevelJooNum, JooDivision, EnterType"
  LSQL = LSQL & " FROM  tblGameLevel "
  LSQL = LSQL & " WHERE GameLevelidx = '"  & tGameLevelIDX  & "'"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tPlayType = LRS("PlayType")
      tTeamGb = LRS("TeamGb")
      tLevel = LRS("Level")
      tSex = LRS("Sex")
      tGroupGameGb = LRS("GroupGameGb")
      tGameDay = LRS("GameDay")
      tViewYN = LRS("ViewYN")
      tLevelJooName = LRS("LevelJooName")
      tLevelJooNum = LRS("LevelJooNum")
      tJooDivision = LRS("JooDivision")
      tEnterType = LRS("EnterType") 
      LRs.MoveNext
    Loop
  End IF

  LSQL = "SELECT Level,LevelNm,LevelDtl   "
  LSQL = LSQL & " FROM  tblLevelInfo  "
  LSQL = LSQL & " where TeamGb =  '" & tTeamGb & "'"
  LSQL = LSQL & " ORDER BY Orderby "
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrLevelInfo = LRs.getrows()
  End If
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.write "LSQL : " & LSQL
%>

<input type="hidden" id="selGameLevelIdx" value="<%=crypt_tGameLevelIDX%>">
 <h3 class="top-navi-tit">
<table  class="navi-tp-table">
  <caption>대회 종별 생성</caption>
  <colgroup>
    <col width="110px">
    <col width="*">
    <col width="110px">
    <col width="*">
    <col width="110px">
    <col width="*">
  </colgroup>
  <tbody>

   <tr>
      <th scope="row">번호</th>
      <td>
       <input type="text" value="<%=tGameLevelIDX%>">
    </td>

    <tr>
     <th scope="row">대회구분</th>
      <td>
        <select id="selEntertype" style="width:40%;" onchange="OnEnterTypeChanged(this.value)">
          <%if tEnterType = "A" Then%>
          <option value="A" selected>아마추어</option>
          <option value="E">엘리트</option>
          <%else%>
          <option value="A" >아마추어</option>
          <option value="E" selected>엘리트</option>
          <%end if%>
        </select>											
      </td>
    </tr>


    <tr>
    <th scope="row">종목</th>
      <td>
        <select id="selTeamGB"  onchange="onTeamGBChanged(this.value)">
            <% If IsArray(arrTeamGb) Then
              For ar = LBound(arrTeamGb, 2) To UBound(arrTeamGb, 2) 
                gameTeamGBCode		= arrTeamGb(0, ar) 
                crypt_gameTeamGBCode = crypt.EncryptStringENC(gameTeamGBCode)
                gameTeamGBName	= arrTeamGb(1, ar) 
                 IF gameTeamGBCode = tTeamGb Then
                %>
                <option value="<%=crypt_gameTeamGBCode%>" Selected><%=gameTeamGBName%></option>
                <%ELSE%>
                <option value="<%=crypt_gameTeamGBCode%>"><%=gameTeamGBName%></option>
                <%
              End If		
              Next
            End If			
          %>
        </select>	
      </td>

      <th scope="row" >종목레벨</th>
      <td id="divTeamGbLevel">
        <select id="selTeamGBLevel" >
            <% If IsArray(arrLevelInfo) Then
              For ar = LBound(arrLevelInfo, 2) To UBound(arrLevelInfo, 2) 
                levelInfoCode		= arrLevelInfo(0, ar) 
                crypt_levelInfoCode = crypt.EncryptStringENC(levelInfoCode)
                levelInfoName	= arrLevelInfo(1, ar) 
                levelInfoDtl	= arrLevelInfo(2, ar) 

                IF levelInfoCode = tLevel Then
          %>
                <option value="<%=crypt_levelInfoCode%>" selected><%=levelInfoName%></option>
                <%ELSE%>
                <option value="<%=crypt_levelInfoCode%>"><%=levelInfoName%></option>
          <%
                End If		
              Next
            End If			
          %>
        </select>	
      </td>

    

    </tr>
    <tr>
      <th scope="row">경기구분</th>
      <td>
          <select id="selGroupGameGb"  onchange="OnGroupGameGbChanged(this.value)">
          <% If IsArray(arrDivision) Then
              For ar = LBound(arrDivision, 2) To UBound(arrDivision, 2) 
                gameDivisionCode		= arrDivision(0, ar) 
                crypt_gameDivisionCode = crypt.EncryptStringENC(gameDivisionCode)
                gameDivisionName	= arrDivision(1, ar) 

              IF gameDivisionCode = tGroupGameGb Then
          %>
          <option value="<%=crypt_gameDivisionCode%>" Selected><%=gameDivisionName%></option>
          <%ELSE%>
          <option value="<%=crypt_gameDivisionCode%>"><%=gameDivisionName%></option>
          <%
              End If		
              Next
            End If			
          %>
        </select>	
      </td>
      
        <th scope="row" id="thGroupGameGb" <% if tGroupGameGb = "B0030002" Then%> style="visibility:hidden;" <% End IF %>>경기타입<label for="competition-name" ></label></th>
        <td id="tdGroupGameGb" <% if tGroupGameGb = "B0030002" Then%> style="visibility:hidden;" <% End IF %>  >
          <select id="selPlayType">
            <% If IsArray(arrayGameType) Then
                For ar = LBound(arrayGameType, 2) To UBound(arrayGameType, 2) 
                  gameTypeCode		= arrayGameType(0, ar) 
                  crypt_gameTypeCode = crypt.EncryptStringENC(gameTypeCode)
                  gameTypeName	= arrayGameType(1, ar) 

                IF gameTypeCode = tPlayType Then
            %>
                  <option value="<%=crypt_gameTypeCode%>" selected><%=gameTypeName%></option>
            <%
                Else
            %>
                  <option value="<%=crypt_gameTypeCode%>"><%=gameTypeName%></option>
            <%
                END IF
                Next
              End If			
            %>
          </select>											
        </td>
    </tr>
  
    <tr>
      <th scope="row">조</th>
        <td id="sel_selLevelJoo">
          <select id="selLevelJoo">
            <% If IsArray(arrayJoo) Then
                For ar = LBound(arrayJoo, 2) To UBound(arrayJoo, 2) 
                  arrayLevelJooCode		= arrayJoo(0, ar) 
                  crypt_arrayLevelJooCode = crypt.EncryptStringENC(arrayLevelJooCode)
                  arrayLevelJooName	= arrayJoo(1, ar) 
                IF arrayLevelJooCode = tLevelJooName Then
            %>
              <option value="<%=crypt_arrayLevelJooCode%>" selected><%=arrayLevelJooName%></option>
                <%ELSE%>
              <option value="<%=crypt_arrayLevelJooCode%>"><%=arrayLevelJooName%></option>
            <%
                End IF
                Next
              End If			
            %>
          </select>	
      </td>
      
      <th scope="row">조 번호 </th>
      <td id="sel_LevelJooNum">
        <select id="selLevelJooNum">
          <% if  tLevelJooNum = "" Then %>
          <option value="" selected>미선택</option>
          <%else%>
          <option value="" >미선택</option>
          <%End IF%>
          <% For i = 1 To 5
            if(tLevelJooNum <> "" ) Then
              if cdbl(i) = cdbl(tLevelJooNum) Then %>
              <option value="<%=i%>" selected><%=i%></option>
              <%else%>
              <option value="<%=i%>"><%=i%></option>
              <% End IF%>
            <%Else%>
            <option value="<%=i%>"><%=i%></option>
            <% End IF
            Next
          %>
        </select>	
      </td>
     
    </tr>
    

    <tr>
      <th scope="row">경기날짜</th>
      <td>
          <input type="text" id="GameS" value="<%=tGameDay%>" class="date_ipt">
      </td>
      <th scope="row">성별</th>
      <td>
        <select id="selSex">
         <% 
            If IsArray(arrSex) Then
            For ar = LBound(arrSex, 2) To UBound(arrSex, 2) 
              SexCode		= arrSex(0, ar) 
              crypt_SexCode = crypt.EncryptStringENC(SexCode)
              SexName	= arrSex(1, ar) 

                 IF SexCode = tSex Then
        %>
              <option value="<%=crypt_SexCode%>" selected><%=SexName%></option>
              <%ELSE%>
              <option value="<%=crypt_SexCode%>" ><%=SexName%></option>
        <%
              End IF
            Next
          End If			
        %>
      
           
      </select>	
      </td>
   
 
      <th scope="row">노출여부</th>
      <td>
        <select id="selViewYN">
        <%if tViewYN = "Y" Then%>
          <option value="Y" Selected>노출</option>
          <option value="N" >미노출</option>
        <%ELSE%>
          <option value="Y">노출</option>
          <option value="N" Selected>미노출</option>
        <%END IF%> 
        </select>	
      </td>
    </tr>
  </tbody>
  </table>