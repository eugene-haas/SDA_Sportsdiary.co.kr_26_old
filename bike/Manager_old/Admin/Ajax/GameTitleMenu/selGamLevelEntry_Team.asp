<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
	
	REQ = Request("Req")
	'REQ = "{""CMD"":5,""tIdx"":""70848B6BA47E3010EF04E3E3929D83CF"",""tGameLevelIdx"":""380BDAD6457FA1C71597661FDA1280E5"",""tGameLevelDtlIdx"":""B697C11FCB8F0DC5DE76C4A374912AE4"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tSearchText"":"""",""tChkAllMember"":""A"",""tParticipateEntryType"":""A"",""NowPage"":1}"
	
	
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

	if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

	tIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))  ' 현재페이지
	tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))  ' 현재페이지
	tGameLevelDtlIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIdx))  ' 현재페이지

	tChkAllMember = fInject(oJSONoutput.tChkAllMember)
	tParticipateEntryType = fInject(oJSONoutput.tParticipateEntryType)

	
	
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


	'Response.Write "tIDX : " & tIDX  & "<br>"
	'Response.Write "tGameLevelIdx : " & tGameLevelIdx  & "<br>"
	'Response.Write "tGameLevelDtlIdx : " & tGameLevelDtlIdx  & "<br>"

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
LSQL = "EXEC tblGameLevelEntry_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & tIDX & "','" & tGameLevelIdx & "','" & tGroupGameGb & "','" & tChkAllMember & "','" & tParticipateEntryType & "','" & iTemp & "','" & iLoginID & "'"
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

'Response.write "tChkAllMember : " & tChkAllMember
'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
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
			<input type="checkbox" id="chkAllMember" class="chk-ipt" name="chkAllMember" <%IF tChkAllMember ="A" Then %> checked <%END IF%> onclick="javascript:findChkAllMember();">
			<label for="chkAllMember" >팀 전체</label>
			<input type="text" name="strMember" id="strMember" class="ipt-word" placeholder="팀명 및 선수명으로 검색하세요" value="<%=iSearchText%>"  <%IF tChkAllMember ="A" Then %> disabled="false" <%END IF%>>
			<a href="javascript:GameLevelEntry();"  class="btn btn-search">검색</a>
		</td>
	</tr>
	</tbody>
</table>
	
<table class="table-list game-ctr">
	<thead>
		<tr>
			<th>번호</th>
			<!--<th>선택</th>-->
			<th>종별 참가 신청팀 
				<select id="selParticipateEntryType" name="selParticipateEntryType" onchange="javascript:GameLevelEntry();">
					<option value="A" <%if tParticipateEntryType = "A" Then%>Selected <%End IF%> >전체</option>
					<option value="P" <%if tParticipateEntryType = "P" Then%>Selected <%End IF%> >참가</option>
					<option value="N" <%if tParticipateEntryType = "N" Then%>Selected <%End IF%>>미참가</option>
				</select>
			</th>
			<th><!--<a class="btn list-btn btn-blue">선택참가</a>--></th>
		</tr>
	</thead>
	<tbody id="DP_LevelDtlList">
		<%

			' 전체 가져오기
			iType = "1"                      ' 1:조회, 2:총갯수
			LSQL = "EXEC tblGameLevelEntry_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & tIDX & "','" & tGameLevelIdx & "','" & tGroupGameGb & "','" & tChkAllMember & "','" & tParticipateEntryType & "','" & iTemp & "','" & iLoginID & "'"
			response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"

			Set LRs = DBCon.Execute(LSQL)
			If Not (LRs.Eof Or LRs.Bof) Then
				Do Until LRs.Eof
						LCnt = LCnt + 1
						tRownum= LRs("rownum")
						tTeamTitleNames = LRs("TeamTitleNames")
						tTeamIDX = LRs("TeamIDX")
						tParticipateTouney= LRs("ParticipateTouney")
						crypt_tTeamIDX =crypt.EncryptStringENC(tTeamIDX)
					%>
					<tr>
						<td>
						<%=tRownum%>
						</td>
						<!--
						<td>
							<input type="checkbox" >
						</td>
						-->
						<td>
							<%=tTeamTitleNames%> 
						</td>
						<td>	
							<% IF Len(tParticipateTouney) > 0 Then %>
								<%=tParticipateTouney%>
							<% Else %>
								<a onclick="insert_RequestLevelDtl('<%=crypt_tTeamIDX%>')" class="btn list-btn btn-blue-empty">참가하기</a>
							<% End IF %>
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
