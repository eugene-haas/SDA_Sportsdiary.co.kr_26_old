<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%

	REQ = Request("Req")
	'REQ = "{""CMD"":5,""tIdx"":""9832C70CDBBB6F8FB311345EF2AD1F2E"",""tGameLevelIdx"":""8AA0D4536ED0294111F91E3943162F17"",""tGameLevelDtlIdx"":""C569C99DA05E245A90DF9D382414B11B"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""iSearchText"":"""",""NowPage"":1}"
	Set oJSONoutput = JSON.Parse(REQ)
	NowPage = fInject(oJSONoutput.NowPage)  ' 현재페이지

	PagePerData = 30  ' 한화면에 출력할 갯수
	BlockPage = 5      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
	LCnt = 0

	'Request Data
	iSearchText = fInject(oJSONoutput.iSearchText)
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
LSQL = "EXEC tblGameLevelEntry_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & tIDX & "','" & tGameLevelIdx & "','" & tGroupGameGb & "','" & iTemp & "','" & iLoginID & "'"
'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
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
%>
		
<table class="table-list game-ctr">
<thead>
	<tr>
		<th>번호</th>
		<th>선택</th>
		<th>종별 참가 신청팀</th>
		<th><a class="btn list-btn btn-blue">선택참가</a></th>
	</tr>
</thead>
<tbody id="DP_LevelDtlList">
	<%

		' 전체 가져오기
		iType = "1"                      ' 1:조회, 2:총갯수
		LSQL = "EXEC tblGameLevelEntry_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & tIDX & "','" & tGameLevelIdx & "','" & tGroupGameGb & "','" & iTemp & "','" & iLoginID & "'"
		'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"

		Set LRs = DBCon.Execute(LSQL)
		If Not (LRs.Eof Or LRs.Bof) Then
			Do Until LRs.Eof
					LCnt = LCnt + 1
						tTeamTitleNames = LRs("TeamTitleNames")
						tTeamIDX = LRs("TeamIDX")
						crypt_tTeamIDX =crypt.EncryptStringENC(tTeamIDX)
					%>
				<tr>
					<td>
					</td>
					<td>
						<input type="checkbox" >
					</td>
					<td>
						<%=tTeamTitleNames%> 
					</td>
					<td>
						<a onclick="insert_RequestLevelDtl('<%=crypt_tTeamIDX%>')" class="btn list-btn btn-blue-empty">참가하기</a>
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

