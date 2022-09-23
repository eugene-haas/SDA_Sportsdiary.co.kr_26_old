<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":2,""tIdx"":""70848B6BA47E3010EF04E3E3929D83CF"",""tGameLevelIdx"":""380BDAD6457FA1C71597661FDA1280E5"",""tGameLevelDtlIdx"":"""",""tChkAllMember"":""S"",""tSearchText"":"""",""NowPage"":1}"

  Set oJSONoutput = JSON.Parse(REQ)

  NowPage = fInject(oJSONoutput.NowPage)  ' 현재페이지

  PagePerData = 30  ' 한화면에 출력할 갯수
  BlockPage = 5      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0

  'Request Data
  iSearchText = fInject(oJSONoutput.tSearchText)
  'iSearchCol = fInject(oJSONoutput.iSearchCol)
  iSearchCol =""

  If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  tChkAllMember =  fInject(oJSONoutput.tChkAllMember)

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))  ' 현재페이지
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))  ' 현재페이지
  tGameLevelDtlIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIdx))  ' 현재페이지

  'Response.Write "tIDX : " & tIDX  & "<br>"
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx  & "<br>"
  

  
  if Len(tGameLevelDtlIdx) = 0 Then
    LSQL = " Select Top 1 GameLevelDtlidx,a.LevelJooNum,PlayLevelType, b.PubName as PlayLevelTypeNm  "
    LSQL = LSQL & " FROM tblGameLevelDtl a "
    LSQL = LSQL & " Left Join tblPubcode  b on a.PlayLevelType = b.PubCode and b.DelYN = 'N' "
    LSQL = LSQL & " where GameLevelidx = '" & tGameLevelIdx &"' and a.DelYN ='N'   "
    LSQL = LSQL & " Order by LevelJooNum asc "
    'Response.Write "LSQL" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          tGameLevelDtlIdx = LRs("GameLevelDtlidx")
        LRs.MoveNext
      Loop
    End If
    LRs.close
  End IF

  
  

  LSQL = " SELECT Top 1 a.GroupGameGb "
  LSQL = LSQL & " FROM  tblGameLevel a "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = " & tidx & " and  a.GameLevelidx = " & tGameLevelIdx
  'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGroupGameGb = LRS("GroupGameGb")
      LRs.MoveNext
    Loop
  End IF

' 전체 가져오기
iType = "2"                      ' 1:조회, 2:총갯수
LSQL = "EXEC tblGameLevelTouneryEntry_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & tGameLevelDtlIdx &  "','" & tGroupGameGb &  "','" & tChkAllMember & "','" & iTemp & "','" & iLoginID & "'"

'response.End

Set LRs = DBCon.Execute(LSQL)
If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
      iTotalCount = LRs("TOTALCNT")
      iTotalPage = LRs("TOTALPAGE")
    LRs.MoveNext
  Loop
End If 

if(cdbl(iTotalPage) < cdbl(NowPage)) then
  NowPage  = iTotalPage
end if

    

strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
'Response.Write "tGameLevelDtlIdx : " & tGameLevelDtlIdx  & "<br>"
'Response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
%>

<table class="sch-table">
  <colgroup>
    <col width="64px">
    <col width="*">
    <col width="64px">
    <col width="*">
    <col width="94px">
    <col width="*">
    <col width="94px">
    <col width="*">
  </colgroup>
  <tbody>
    <tr>
      <td>
        <input type="checkbox" id="chkAllTouneryEntryMember" class="chk-ipt" name="chkAllTouneryEntryMember" <%IF tChkAllMember ="A" Then %> checked <%END IF%> onClick="javascript:findChkAllMemberTouneyEntry();">
        <label for="chkAllMember">팀 전체</label>
        <input type="text" name="strTouneryEntryMember" id="strTouneryEntryMember" class="ipt-word" placeholder="팀명 및 선수명으로 검색하세요" value="<%=iSearchText%>">
        <a onClick="javascript:selLevelDtlChanged();" class="btn btn-search">검색</a>
      </td>
    </tr>
  </tbody>
</table>
    
<table class="table-list game-ctr" >
    <thead>
      <tr>
        <th>번호</th>
        <th>
          <span>참여중인 팀</span>
          <select id="selGameLevelDtl" name="selGameLevelDtl" onchange="javascript:selLevelDtlChanged();" style="width:100px">
          <%
              LSQL = " Select GameLevelDtlidx,a.LevelJooNum,PlayLevelType, b.PubName as PlayLevelTypeNm  "
              LSQL = LSQL & " FROM tblGameLevelDtl a "
              LSQL = LSQL & " Left Join tblPubcode  b on a.PlayLevelType = b.PubCode and b.DelYN = 'N' "
              LSQL = LSQL & " where GameLevelidx = '" & tGameLevelIdx &"' and a.DelYN ='N'   "
             
              
              Set LRs = DBCon.Execute(LSQL)
              If Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                    LCnt = LCnt + 1
                    
                    tGameLevelDtlIdx2 = LRs("GameLevelDtlidx")
                    crypt_tGameLevelDtlIdx2 =crypt.EncryptStringENC(tGameLevelDtlIdx2)
                    tLevelJooNum = LRs("LevelJooNum")
                    tPlayLevelTypeNm = LRs("PlayLevelTypeNm")
                    IF cdbl(tGameLevelDtlIdx) = cdbl(tGameLevelDtlIdx2) Then 
                    %>
                    <option value="<%=crypt_tGameLevelDtlIdx2%>" selected><%=tPlayLevelTypeNm%>-<%=tLevelJooNum%></option>
                    <% ELSE%>
                    <option value="<%=crypt_tGameLevelDtlIdx2%>"><%=tPlayLevelTypeNm%>-<%=tLevelJooNum%></option>
                  <%
                    END IF
                  LRs.MoveNext
                Loop
              End If
              LRs.close
            %>
            </select>
          </th>
          <th>
            <a class="btn list-btn btn-blue">전체취소</a>
          </th>
      </tr>
    </thead>
    <tbody>
        <%
            iType = "1"                      ' 1:조회, 2:총갯수
            LSQL = "EXEC tblGameLevelTouneryEntry_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & tGameLevelDtlIdx &  "','" & tGroupGameGb &  "','" & tChkAllMember & "','" & iTemp & "','" & iLoginID & "'"
            'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
            'LSQL = LSQL & " FROM  tblGameTitle a "
            'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
            'LSQL = LSQL & " WHERE a.DELYN = 'N' "
            'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&""

            Set LRs = DBCon.Execute(LSQL)
            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                  LCnt = LCnt + 1
                    tRownum= LRs("rownum")
                    tTeamTitleNames = LRs("TeamTitleNames")
                    tRequestDtlIDX = LRs("RequestDtlIDX")
                    crypt_tRequestDtlIDX =crypt.EncryptStringENC(tRequestDtlIDX)
                  %>
                <tr>
                  <td>
                  <%=tRownum%>
                  </td>
                  <td>
                    <%=tTeamTitleNames%> 
                  </td>
                  <td>
                    <a class="btn list-btn btn-blue-empty" onclick="cancel_RequestLevelDtl('<%=crypt_tRequestDtlIDX%>')">취소</a>
                  </td>
                </tr>
                <%
                LRs.MoveNext
              Loop
            End If
            LRs.close
        %>
    </tbody>
</table>
<%
  if cdbl(iTotalCount) > 0 then
  %>
  <!-- S: page_index -->
  <div class="page_index">
    <!--#include file="../../dev/dist/CommonPaging_Admin.asp"-->
  </div>
  <!-- E: page_index -->
  <%
  ELSE
  %>
  <div class="board-bullet Non-pagination" >
      데이터가 존재하지 않습니다.
  </div>
  <%
  End If
%>

