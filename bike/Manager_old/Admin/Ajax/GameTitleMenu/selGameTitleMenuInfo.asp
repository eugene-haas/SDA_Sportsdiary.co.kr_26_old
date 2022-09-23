<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%

  REQ = Request("Req")
  
  'REQ = "{""CMD"":1,""tIDX"":""124"",""NowPage"":1}"
  Set oJSONoutput = JSON.Parse(REQ)
	tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIDX))
  crypt_tIDX =crypt.EncryptStringENC(tIDX)
  NowPage= fInject(oJSONoutput.NowPage)

  If(tIDX <> "") Then
    LSQL = "SELECT GameGb,GameTitleName,GameS,GameE,GamePlace,Sido,SidoDtl,EnterType,"
    LSQL = LSQL & " GameRcvDateS,GameRcvHourS,GameRcvMinuteS  ,GameRcvDateE  ,GameRcvHourE  ,GameRcvMinuteE, "
    LSQL = LSQL & " DelYN  ,ViewYN  ,HostCode ,EditDate ,WriteDate,GameTitleHost,TeamType,PersonalPayment, GroupPayment,EntryViewYN,GameTitleOldIDX,"
    LSQL = LSQL & " MaxPoint, RallyPoint, DeuceYN, MaxPoint_Ama, RallyPoint_Ama, DeuceYN_Ama"
    LSQL = LSQL & " FROM  tblGameTitle "
    LSQL = LSQL & " WHERE GameTitleIDX = "  & tIDX 
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        tGameGb = LRS("GameGb")
        tGameTitleName = LRS("GameTitleName")
        tGameS = LRS("GameS")
        tGameE = LRS("GameE")
        tGamePlace = LRS("GamePlace")
        tGameTitleSido = LRS("Sido")
        tGameTitleSidoDtl = LRS("SidoDtl")
        tGameTitleHost = LRS("GameTitleHost")
        tGameRcvDateS = LRS("GameRcvDateS")
        tGameRcvHourS = LRS("GameRcvHourS")
        tGameRcvMinuteS = LRS("GameRcvMinuteS")
        tGameRcvDateE = LRS("GameRcvDateE")
        tGameRcvHourE = LRS("GameRcvHourE")
        tViewYN = LRS("ViewYN")
        tEntryViewYN = LRS("EntryViewYN")
        tHostCode = LRS("HostCode")
        tEditDate = LRS("EditDate")
        tEnterType = LRS("EnterType")
        tTeamType = LRS("TeamType")
        tPersonalPayment= LRS("PersonalPayment")
        tGroupPayment= LRS("GroupPayment")
        tGameTitleOldIDX = LRS("GameTitleOldIDX")

        tMaxPoint = LRS("MaxPoint")
        tRallyPoint = LRS("RallyPoint")
        tDeuceYN = LRS("DeuceYN")
        tMaxPoint_Ama = LRS("MaxPoint_Ama")
        tRallyPoint_Ama = LRS("RallyPoint_Ama")
        tDeuceYN_Ama = LRS("DeuceYN_Ama")

        LRs.MoveNext
      Loop
    End If
  End IF

  ' 게임 타입 ( 국제, 국내 대회 )
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B001'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameTitleType = LRs.getrows()
  End If

  ' 모집 팀 타입
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B013'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayTeamType = LRs.getrows()
  End If

%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
  <input type="hidden" id="selGameTitleIdx" value="<%=crypt_tIDX%>">
  <table class="navi-tp-table">
    <!--<caption>대회정보 기본정보</caption>
    <colgroup>
      <col width="110px">
      <col width="*">
      <col width="110px">
      <col width="*">
      <col width="110px">
      <col width="*">
    </colgroup>
    -->
    <tbody>
      <tr>
        <th scope="row"><span class="l_con"></span>대회구분</th>
        <td>
          <select id="SelNationType">
            <% If IsArray(arrayGameTitleType) Then
                For ar = LBound(arrayGameTitleType, 2) To UBound(arrayGameTitleType, 2) 
                  GameTitleTypeCode		= arrayGameTitleType(0, ar) 
                  crypt_GameTitleTypeCode =  crypt.EncryptStringENC(GameTitleTypeCode)
                  GameTitleTypeName	= arrayGameTitleType(1, ar) 

                  if GameTitleTypeCode = tGameGb Then
                %>
                  <option value="<%=crypt_GameTitleTypeCode%>" selected><%=GameTitleTypeName%></option>
                <%else%>
                  <option value="<%=crypt_GameTitleTypeCode%>"><%=GameTitleTypeName%></option>
                <%
                  end if
                Next
              End If			
            %>
          </select>	
        </td>
        <th>
          <span class="l_con"></span>대회명
        </th>
        <td>
          <input type="text" id="txtGameTitleName" placeholder="대회명을 입력해주세요." value="<%=tGameTitleName%>">
        </td>
        
        <th>
          <span class="l_con"></span>대회장소
        </th>
        <td>
          <input type="text" id="txtGamePlace" placeholder="대회장소를 입력해주세요." value="<%=tGamePlace%>">
        </td>
      </tr>

      <tr>
        <th><span class="l_con"></span>대회시작일</th>
        <td>
          <div class="ymd-list">
            <span id="sel_GameSYear"><input type="text" id="GameS" value="<%=tGameS%>" class="date_ipt"></span>
          </div>
        </td>
        <th><span class="l_con"></span>대회종료일</th>
        <td>
          <div class="ymd-list">
            <span id="sel_GameEYear"><input type="text" id="GameE" value="<%=tGameE%>" class="date_ipt"></span>
        </div></td>

        <th><span class="l_con"></span>주최</th>
        <td>
          <div class="ymd-list">
            <span id="sel_GameTitleHost">
              <input type="text" id="txtGameTitleHost" value="<%=tGameTitleHost%>" class="date_ipt">
            </span>
          </div>
        </td>
      </tr>
      
      <tr>
        <th><span class="l_con"></span>접수시작일</th>
        <td>
          <div class="ymd-list">
            <span ><input type="text" id="GameRcvS"  class="date_ipt" value="<%=tGameRcvDateS%>"></span>
          </div>
        </td>

        <th><span class="l_con"></span>접수종료일</th>
        <td>
          <div class="ymd-list">
            <span ><input type="text" id="GameRcvE"  class="date_ipt" value="<%=tGameRcvDateE%>"></span>
        </div>
        </td>

        <th><span class="l_con"></span>선수구분</th>
        <td>
          <select id="selEntertype" style="width:70%;" onchange="selEntertypeChanged(this)">
            
            <option value="E" <%IF tEnterType = "E" THEN%>selected<%End If%>>엘리트</option>
            <option value="A" <%IF tEnterType = "A" THEN%>selected<%End If%>>생활체육</option>
            <option value="M" <%IF tEnterType = "M" THEN%>selected<%End If%>>엘리트+생활체육</option>            
          </select>											
        </td>

      </tr>
      <tr>
        
        <th><span class="l_con"></span>지역</th>
        <td>
          <select id="SelGameTitleLocation" style="width:150px;">
            <%
              LSQL = "SELECT Sido ,SidoNm "
              LSQL = LSQL & " FROM  tblSidoInfo"
              LSQL = LSQL & " WHERE DELYN = 'N' "
              LSQL = LSQL & " Order by OrderbyNum "
                                  
              Set LRs = DBCon.Execute(LSQL)
              If Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                    rSido= LRs("Sido")
                    rSidoNm = LRs("SidoNm")
                    if(rSido = tGameTitleSido ) Then
                    %>
                    <option value="<%=rSido%>" selected><%=rSidoNm%></option>
                    <%
                    Else
                    %>
                    <option value="<%=rSido%>" ><%=rSidoNm%></option>
                    <%
                    End if
                  LRs.MoveNext
                Loop
              End If
              LRs.close
            %>
          </select>
        </td>
        
        <th><span class="l_con"></span>대회 노출</th>
        <td>
          <select id="selViewYN">
          <%IF tViewYN = "Y" Then %>
          <option value="Y" selected>노출</option>
          <option value="N" >미노출</option>
          <%Else%>
          <option value="N" selected>미노출</option>
          <option value="Y" >노출</option>
          <%End IF%>
          </select>
        </td>

         <th>
          <span class="l_con"></span>참가신청 노출
          </th>
          <td>
            <select id="selEntryViewYN">
                <%IF tEntryViewYN = "Y" Then %>
                <option value="Y" selected>노출</option>
                <option value="N" >미노출</option>
                <%Else%>
                <option value="N" selected>미노출</option>
                <option value="Y" >노출</option>
                <%End IF%>
            </select>
          </td>

          <!--
          <th scope="row">대회달력노출</th>
          <td>
            <select id="ViewState">
              <option value="N">미노출</option>
              <option value="Y">노출</option>
            </select>
          </td>	
          -->		
      </tr>
       <tr>
          <th>
            <span class="l_con"></span>(구)Site Key
          </th>
          <td>
            <input type="text" id="txtGameTitleOldIDX" name="txtGameTitleOldIDX" value="<%=tGameTitleOldIDX%>">
          </td>
      </tr>
      <tr>
          <th id="GameSet_Name" <%IF tEnterType = "A" THEN%>style="display:none"<%End If%>>
            <span class="l_con"></span>엘리트경기 세팅
          </th>
          <td id="GameSet" <%IF tEnterType = "A" THEN%>style="display:none"<%End If%>>
            최대P:
            <input type="text" id="schMaxPoint" name="schMaxPoint" style="width:30px;" value="<%=tMaxPoint%>" length="2">
            랠리P:
            <input type="text" id="schRallyPoint" name="schRallyPoint" style="width:30px;"  value="<%=tRallyPoint%>" length="2">
            듀스여부:
            <select id="schDeuceYN" name="schDeuceYN" style="width:60px;">
              <option value="Y" <%If tDeuceYN = "Y" Then%>selected<%End If%>>사용</option>
              <option value="N" <%If tDeuceYN = "N" Then%>selected<%End If%>>미사용</option>
            </select>
          </td>
          <th id="GameSet_Name_Ama" <%IF tEnterType = "E" THEN%>style="display:none"<%End If%>>
            <span class="l_con"></span>생/체경기 세팅
          </th>
          <td id="GameSet_Ama" <%IF tEnterType = "E" THEN%>style="display:none"<%End If%>>
            최대P:
            <input type="text" id="schMaxPoint_Ama" name="schMaxPoint_Ama" style="width:30px;" value="<%=tMaxPoint_Ama%>" length="2">
            랠리P:
            <input type="text" id="schRallyPoint_Ama" name="schRallyPoint_Ama" style="width:30px;" value="<%=tRallyPoint_Ama%>" length="2">
            듀스여부:
            <select id="schDeuceYN_Ama" name="schDeuceYN_Ama" style="width:60px;">
              <option value="Y" <%If tDeuceYN_Ama = "Y" Then%>selected<%End If%>>사용</option>
              <option value="N" <%If tDeuceYN_Ama = "N" Then%>selected<%End If%>>미사용</option>
            </select>                
          </td>
          <th>
          </th>
          <td>
          </td>                            
      </tr>         
    </tbody>
  </table>
  <div class="table_btn btn-center-list">
    <a href="#" class="btn btn-gray" onclick='updateGameTitle_frm(<%=strjson%>);'>수정</a>
    <a href="#" class="btn btn-red" onclick="delGameTitle_frm();">삭제</a>
  </div>



<%
  DBClose()
%>