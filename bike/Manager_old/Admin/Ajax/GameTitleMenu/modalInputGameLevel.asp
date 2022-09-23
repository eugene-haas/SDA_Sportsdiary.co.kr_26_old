<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->



<%

  REQ = Request("REQ")
  Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD
  tidx = oJSONoutput.TIDX
  tEnterType = oJSONoutput.tEnterType
  tGameTitleName = oJSONoutput.tGameTitleName


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
  
  '경기방식 (리그, 토너먼트, (리그+ 토너먼트))
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B004'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameMethod = LRs.getrows()
  End If

  'RESPONSE.WRITE LSQL & "<BR>"

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

  LSQL = "SELECT PTeamGbNm,TeamGb ,TeamGbNm  "
  LSQL = LSQL & "FROM  tblTeamGbInfo "
  LSQL = LSQL & "Where EnterType = '" & tEnterType & "' And DelYN = 'N'"
  LSQL = LSQL & "ORDER BY Orderby DESC"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrTeamGb = LRs.getrows()
  End If

%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
  <input type="hidden" id="txtTIDX" value="<%=tidx%>">
  <span> 대회명 : <%=tGameTitleName%> , 모집구분 : <%IF tEnterType = "E" THEN Response.Write("엘리트") ELSE Response.Write("아마추어") END IF%></span>
   <form id="form1" name="form1" action="./insert_GameTitleMenuInfo.asp" method="post" >
      <div class="top-navi-inner">
        <div class="top-navi-btm">
          <div class="navi-tp-table-wrap" id="gameinput_area">
            <table class="navi-tp-table">
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
                  <th scope="row">경기타입<label for="competition-name"></label></th>
                  <td>
                    <select id="selPlayType">
                      <% If IsArray(arrayGameType) Then
                          For ar = LBound(arrayGameType, 2) To UBound(arrayGameType, 2) 
                            gameTypeCode		= arrayGameType(0, ar) 
                            gameTypeName	= arrayGameType(1, ar) 
                      %>
                            <option value="<%=gameTypeCode%>"><%=gameTypeName%></option>
                      <%
                          Next
                        End If			
                      %>
                    </select>											
                  </td>
                  <th scope="row">
                    <label for="competition-name">경기방식</label>
                  </th>
                  <td>
                    <select id="selGameType">
                    <% If IsArray(arrayGameMethod) Then
                        For ar = LBound(arrayGameMethod, 2) To UBound(arrayGameMethod, 2) 
                          gameMethodCode		= arrayGameMethod(0, ar) 
                          gameMethodName	= arrayGameMethod(1, ar) 
                    %>
                          <option value="<%=gameMethodCode%>"><%=gameMethodName%></option>
                    <%
                        Next
                      End If			
                    %>
                    </select>	
                  </td>
                  
                </tr>
                <tr>
                  
                  <th scope="row">경기구분</th>
                  <td>
                     <select id="selGroupGameGb">
                      <% If IsArray(arrDivision) Then
                          For ar = LBound(arrDivision, 2) To UBound(arrDivision, 2) 
                            gameDivisionCode		= arrDivision(0, ar) 
                            gameDivisionName	= arrDivision(1, ar) 
                      %>
                            <option value="<%=gameDivisionCode%>"><%=gameDivisionName%></option>
                      <%
                          Next
                        End If			
                      %>
                    </select>	
                  </td>
                  <th scope="row">종별</th>
                  <td>
                    <select id="selTeamGB">
                       <% If IsArray(arrTeamGb) Then
                          For ar = LBound(arrTeamGb, 2) To UBound(arrTeamGb, 2) 
                            gameTeamGBCode		= arrTeamGb(1, ar) 
                            gameTeamGBName	= arrTeamGb(2, ar) 
                      %>
                            <option value="<%=gameTeamGBCode%>"><%=gameTeamGBName%></option>
                      <%
                          Next
                        End If			
                      %>
                    </select>	
                  </td>
                </tr>

                <tr>
                  <th scope="row">경기날짜</th>
                  <td>
                     <input type="text" id="GameS" value="" class="date_ipt">
                  </td>
                  <th scope="row">성별</th>
                  <td>
                    <select id="selSex">
                      <option value="man">남자</option>
                      <option value="woman">여자</option>
                    </select>	
                  </td>
                </tr>

                <tr>
                  <th scope="row">노출여부</th>
                  <td>
                    <select id="selViewYN">
                      <option value="Y">노출</option>
                      <option value="N" Selected>미노출</option>
                    </select>	
                  </td>
                </tr>

              </tbody>
            </table>
            <div class="btn-center-list">
              <a href="#" id="btnsave" class="btn" onclick="inputGameTitleLevel_frm(<%=tidx%>);" accesskey="i">등록</a>
              <button type="button" class="btn" data-dismiss="modal">취소</button>
            </div>
          </div>
        </div>
      </div>
    </form>

    
<%
  DBClose()
%>