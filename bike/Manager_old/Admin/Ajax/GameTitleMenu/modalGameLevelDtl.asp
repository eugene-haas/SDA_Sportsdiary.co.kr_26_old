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
  tGameLevelIdx = oJSONoutput.tGameLevelIdx



  '경기룰 (토너먼트, 리그)
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B010'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayPlayType = LRs.getrows()
  End If

  '경기방식 (리그, 토너먼트, (리그+ 토너먼트))
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B004'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
     arrayGameType = LRs.getrows()
  End If

  '체급
  LSQL = " SELECT Level ,LevelNm   "
  LSQL = LSQL & " FROM  tblLevelInfo "
  'LSQL = LSQL & " Where DelYN='N' and TeamGb = ''"
  LSQL = LSQL & " Where DelYN='N'"
  LSQL = LSQL & " ORDER BY OrderBy "

  

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
     arrayLevelInfo = LRs.getrows()
  End If

  
  'Response.Write "LSQL = " & LSQL & "<br>"

  ' GameLevelDtl 리스트
  LSQL = " SELECT GameLevelDtlidx, b.PubName as PlayType, c.PubName as GameType, StadiumNumber, TotRound, GameDay, GameTime, A.EnterType, EntryCnt, Level, LevelDtlName "
  LSQL = LSQL & " FROM tblGameLevelDtl a "
  LSQL = LSQL & " LEFT JOIN tblPubcode b on a.PlayType = b.PubCode and b.DelYN = 'N' "
  LSQL = LSQL & " LEFT JOIN tblPubcode c on a.GameType = c.PubCode and c.DelYN = 'N' "
  LSQL = LSQL & " WHERE GameLevelidx = '"  & tGameLevelIdx & "'"
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameLevelDtl = LRs.getrows()
  End If
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.Write "GameTitleIdx = " & tidx & "<br>"
  'Response.Write "tEnterType = " & tEnterType & "<br>"
  'Response.Write "tGameTitleName = " & tGameTitleName & "<br>"
  'Response.Write "tGameLevelIdx = " & tGameLevelIdx & "<br>"
%>
  

  <span>종목</span>
  <div id ="formGameTitle">   
    <div class="top-navi-inner">
      <div class="top-navi-btm">
        <div class="navi-tp-table-wrap" id="gameinput_area">
          <table class="navi-tp-table">
            <caption>대회정보 기본정보</caption>
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
                <th scope="row">
                <label for="competition-name">경기구분</label></th>
                <td>
                   <select id="selPlayType">
                      <% If IsArray(arrayPlayType) Then
                          For ar = LBound(arrayPlayType, 2) To UBound(arrayPlayType, 2) 
                            gamePlayTypeCode		= arrayPlayType(0, ar) 
                            gamePlayTypeName	= arrayPlayType(1, ar) 
                      %>
                            <option value="<%=gamePlayTypeCode%>"><%=gamePlayTypeName%></option>
                      <%
                          Next
                        End If			
                      %>
                    </select>						
                </td>
                <th scope="row">
                  <label for="competition-name">룰</label>
                </th>
                <td>
                    <select id="selGameType">
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
              
              </tr>
              <tr>
                
                <th scope="row">경기장 번호</th>
                <td>
                  <div class="ymd-list">
                      <input type="text" id="txtStadiumNumber" value="" >
                  </div>
                </td>
                <th scope="row">총 라운드</th>
                <td>
                  <div class="ymd-list">
                      <input type="text" id="txtTotalRound" value="" >
                  </div>
                </td>
              </tr>
              <tr>
              

                <th scope="row"><label for="competition-place">종목구분</label></th>
                <td>
                     <select id="selLevelInfo">
                     
                      <% If IsArray(arrayLevelInfo) Then
                          For ar = LBound(arrayLevelInfo, 2) To UBound(arrayLevelInfo, 2) 
                            gameLevelInfoCode		= arrayLevelInfo(0, ar) 
                            gameLevelInfoName	= arrayLevelInfo(1, ar) 
                      %>
                            <option value="<%=gameLevelInfoCode%>"><%=gameLevelInfoName%></option>
                      <%
                          Next
                        End If			
                      %>
                    </select>		
                </td>

                <th scope="row">참여자 제한</th>
                <td>
                    <input type="text" id="GameLevelDtlEntryCnt">
                </td>
                </tr>
                <tr>
                  <th scope="row"><label for="competition-place">경기날짜</label></th>
                  <td>
                      <input type="text" id="GameLevelDtlD" value="<%=rGameDay%>" class="date_ipt">
                  </td>
                    <th scope="row"><label for="competition-place">시작시간</label></th>
                  <td>
                   <form>
                        <input type="text" id="GameLevelDtlT" class="timepicker" name="time"/>
                    </form>
                  </td>

                </tr>
              <tr>
              
                <th scope="row">노출여부</th>
                <td>
                  <select id="selViewYN">
                    <option value="N">미노출</option>
                    <option value="Y">노출</option>
                  </select>
                </td>
              </tr>
            </tbody>
          </table>
          <div class="btn-right-list">
            <a href="#" id="btnsave" class="btn" onclick='inputGameLevelDtl_frm(<%=strjson%>);' accesskey="i">등록(I)</a>
            <a href="#" id="btnupdate" class="btn" onclick="updateGameLevelDtl_frm();" accesskey="e">수정(E)</a>
            <a href="#" id="btndel" class="btn btn-delete" onclick="delGameLevelDtl_frm();" accesskey="r">삭제(R)</a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <table class="table-list">
          <thead>
            <tr>
              <th>번호</th>
              <th>경기구분</th>
              <th>룰</th>
              <th>총 라운드</th>
              <th>경기장번호</th>
              <th>날짜</th>
              <th>시간</th>
            </tr>
          </thead>
          <tbody id="gameTitleContest">
           <% If IsArray(arrayGameLevelDtl) Then
              For ar = LBound(arrayGameLevelDtl, 2) To UBound(arrayGameLevelDtl, 2) 
                rGameLevelDtlIdx		= arrayGameLevelDtl(0, ar)  
                rPlayType		= arrayGameLevelDtl(1, ar) 
                rGameType	= arrayGameLevelDtl(2, ar) 
                rStadiumNumber	= arrayGameLevelDtl(3, ar) 
                rTotRound	= arrayGameLevelDtl(4, ar) 
                rGameDay	= arrayGameLevelDtl(5, ar) 
                rGameTime	= arrayGameLevelDtl(6, ar) 
                rEnterType	= arrayGameLevelDtl(7, ar) 
                rLevel	= arrayGameLevelDtl(8, ar) 
                rLevelDtlName	= arrayGameLevelDtl(9, ar) 
          %>

            <tr>
              <td style="cursor:pointer">
                <%=rGameLevelDtlIdx%>
              </td>
              <td style="cursor:pointer">
                <%=rPlayType%>
              </td>
              <td style="cursor:pointer">
                  <%=rGameType%>
              </td>
              <td style="cursor:pointer">
                  <%=rTotRound%>
              </td>
              <td style="cursor:pointer">
                  <%=rStadiumNumber%>
              </td>
              <td style="cursor:pointer">
                  <%=rGameDay%>
              </td>
              <td style="cursor:pointer">
                  <%=rGameTime%>
              </td>
               
            </tr>
          <%
              Next
            ELSE
          %>

          <tr>
            <td colspan="7">데이터가 존재하지 않습니다.</td>
          </tr>

          <%
            End If			
          %>
          </tbody>
        </table>
<%
  DBClose()
%>
