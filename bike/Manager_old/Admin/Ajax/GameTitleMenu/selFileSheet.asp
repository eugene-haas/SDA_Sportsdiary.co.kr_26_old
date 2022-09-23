<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
'쉬트목록가져오기
Function getSheetName(conn)
	Dim i
	Set oADOX = CreateObject("ADOX.Catalog")
	oADOX.ActiveConnection = conn
	ReDim sheetarr(oADOX.Tables.count)
	i = 0
	For Each oTable in oADOX.Tables
		sheetarr(i) = oTable.Name
	i = i + 1
	Next 
	getSheetName = sheetarr
End function
%>

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":1,""filName"":""2018 생활체육대축전대회_참가신청명단(배드민턴)_18.5.3 변경 - 복사본.xlsx"",""GameType"":""B4E57B7A4F9D60AE9C71424182BA33FE""}"
  Set oJSONoutput = JSON.Parse(REQ)
  filName = fInject(oJSONoutput.filName)
  gameType = fInject(crypt.DecryptStringENC(oJSONoutput.GameType))
  'Response.Write "filName : " & filName & " <br> "
  sheetno = 0
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  crypt_PersonGame =crypt.EncryptStringENC(PersonGame )
  crypt_GroupGame =crypt.EncryptStringENC(GroupGame )

  Dim strPath
  Dim arrRowCount : arrRowCount = 0

  Set adbCon = Server.CreateObject("ADODB.connection")
  IF gameType = GroupGame Then
    strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\GroupGame\"  & filName
  Else
    strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\PersonGame\"  & filName
  End IF
  
  connString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & strPath & "; Extended Properties=Excel 12.0;"
  
  'Response.Write "connString : " & connString & "<br>"
  sheetname = getSheetName(connString)
  'Response.Write "sheetname(0) : " & sheetname(sheetno) & "<br>"
  
  adbCon.Open connString  
  Sql = "Select  * From ["&sheetname(sheetno)&"] "

   Set Rs = adbCon.Execute(Sql)
   If NOT rs.EOF Then
    arrResultSet = rs.GetRows()
    arrRowCount = UBound(arrResultSet,2) + 1
  End If
 
  Rs.close
  adbCon.close
  Set Rs=Nothing
  Set adbCon=Nothing
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.write "RecordCount : " & arrRowCount & "<br>"
%>

<%
  IF gameType = PersonGame Then
%>
<a href="javascript:UploadData('<%=filName%>','<%=crypt_PersonGame%>');"  class="btn btn-red"> 참가팀 넣기 </a> 
번호 개수 : <%=arrRowCount%>
<input type="hidden" id="totalRowCnt" name="totalRowCnt" value="<%=arrRowCount%>">
<table class="table-list" id="tableExcelDataList" name="tableExcelDataList" >
  <thead>
    <tr>
      <th>번호</th>
      <th>게임번호</th>
      <th>종별</th>
      <th>플레이어1 </th>
      <th> 시도</th>
      <th> 구군</th>
      <th> 팀</th>
      <th> 생일</th>
      <th> 성별</th>
      <th> 핸드폰</th>
      <th> 비고</th>
      <th>플레이어2 </th>
      <th> 시도</th>
      <th> 구군</th>
      <th> 팀</th>
      <th> 생일</th>
      <th> 성별</th>
      <th> 핸드폰</th>
      <th> 비고</th>
    </tr>
  </thead>
  <tbody id="tbodyExcelDataList" name="tbodyExcelDataList">
     <% If IsArray(arrResultSet) Then
          For ar = LBound(arrResultSet, 2) To UBound(arrResultSet, 2) 
            '1. 팀정보  
            number = arrResultSet(0, ar)
            gameNumber = arrResultSet(1, ar)
            level = arrResultSet(2, ar)
            levelAge = arrResultSet(3, ar)
            levelJoo = arrResultSet(4, ar)
        
            '2. 플레이어1 정보
            player1_sido = arrResultSet(5, ar)
            player1_gugun = arrResultSet(6, ar)
            player1_team = arrResultSet(7, ar)
            player1_name = arrResultSet(8, ar)
            palyer1_birthday = arrResultSet(9, ar)
            palyer1_sex= arrResultSet(10, ar)
            palyer1_phone= arrResultSet(11, ar)
            palyer1_Other= arrResultSet(12, ar)

            remove1_Trim = TRIM(player1_team)

            isTeam1 = (remove1_Trim="")
            if( isTeam1 = False) Then
              player1_team = player1_team 
            ELSE
              player1_team = player1_sido
            END IF

            'if(Len(remove1_Trim) = 0) Then
            '  if (Len(player1_sido) = 0) Then
            '    player1_team = player1_gugun
            '  ELSE
            '    player1_team = player1_sido
            '  END IF
            'ENd if

            '3. 플레이어2 정보
            player2_sido = arrResultSet(13, ar)
            player2_gugun = arrResultSet(14, ar)
            player2_team = arrResultSet(15, ar)
            player2_name = arrResultSet(16, ar)
            palyer2_birthday = arrResultSet(17, ar)
            palyer2_sex= arrResultSet(18, ar)
            palyer2_phone= arrResultSet(19, ar)
            palyer2_Other= arrResultSet(20, ar)

            remove2_Trim = TRIM(player2_team)

            isTeam2 = (remove2_Trim="")
            if( isTeam2 = False) Then
                player2_team = player2_team 
            ELSE
              player2_team = player2_sido
            END IF

            'remove2_Trim = TRIM(player2_team)
            'if(Len(remove2_Trim) = 0) Then
            '  if (Len(player2_sido) = 0) Then
            '    player2_team = player2_gugun
            '  ELSE
            '    player2_team = player2_sido
            '  END IF
            'ENd if


    %>
    <tr>
      <td>
        <%=number%>
      </td>
      <td>
        <%=gameNumber%>
      </td>
      <td>
        <%=level%>-<%=levelAge%>-<%=levelJoo%>
      </td>
      <td>
        <%=player1_name%>
      </td>
      <td>
        <%=player1_sido%>
      </td>
      <td>
        <%=player1_gugun%>
      </td>
      <td>
      <%=player1_team%>
      </td>
      <td>
        <%=palyer1_birthday%>
      </td>
      <td>
        <%=palyer1_sex%>
      </td>
      <td>
        <%=palyer1_phone%>
      </td>
      <td>
        <%=palyer1_Other%>
      </td>
      <td>
        <%=player2_name%>
      </td>
      <td>
        <%=player2_sido%>
      </td>
      <td>
        <%=player2_gugun%>
      </td>
      <td>
        <%=player2_team%>
      </td>
      <td>
        <%=palyer2_birthday%>
      </td>
      <td>
        <%=palyer2_sex%>
      </td>
      <td>
        <%=palyer2_phone%>
      </td>
      <td>
        <%=palyer2_Other%>
      </td>
    </tr>   
    <%
        Next
      End If      
      'Response.Write "player1_sido : " & player1_sido  & ":"
    'Response.Write "player1_gugun : " & player1_gugun  &  ":"
    'Response.Write "player1_team : " & player1_team  & ":"
    'Response.Write "player1_name : " & player1_name  &  ":"
    'Response.Write "palyer1_birthday : " & palyer1_birthday  &  ":"
    'Response.Write "palyer1_sex : " & palyer1_sex  & ":"
    'Response.Write "palyer1_phone : " & palyer1_phone  & ":"
    'Response.Write "palyer1_Other : " & palyer1_Other  & ":"
    'Response.Write "<br/>"
    'Response.Write "player2_sido : " & player2_sido  & ":"
    'Response.Write "player2_gugun : " & player2_gugun  &  ":"
    'Response.Write "player2_team : " & player2_team  & ":"
    'Response.Write "player2_name : " & player2_name  &  ":"
    'Response.Write "palyer2_birthday : " & palyer2_birthday  &  ":"
    'Response.Write "palyer2_sex : " & palyer2_sex  & ":"
    'Response.Write "palyer2_phone : " & palyer2_phone  & ":"
    'Response.Write "palyer2_Other : " & palyer2_Other  & ":"
    'Response.Write "<br/><br/><br/><br/>"
    %>
    
  </tbody>
</table>
<%
if cdbl(arrRowCount) = 0 then
%>
<div class="board-bullet Non-pagination" >
    데이터가 존재하지 않습니다.
</div>
<%
End If
%>

<% ELSE %>

<a href="javascript:UploadData('<%=filName%>','<%=crypt_GroupGame%>');"  class="btn btn-red"> 참가팀 넣기 </a> 
번호 개수 : <%=arrRowCount%>
<input type="hidden" id="totalRowCnt" name="totalRowCnt" value="<%=arrRowCount%>">
<table class="table-list" id="tableExcelDataList" name="tableExcelDataList" >
  <thead>
    <tr>
      <th>번호</th>
      <th>종목</th>
      <th>시도</th>
      <th>임원여부</th>
      <th>선수여부</th>
      <th>세부종목</th>
      <th>연령</th>
      <th>그룹여부</th>
      <th>성별</th>
      <th>이름</th>
      <th>생년월일</th>
    </tr>
  </thead>
  <tbody id="tbodyExcelDataList" name="tbodyExcelDataList">

  <% If IsArray(arrResultSet) Then
      For ar = LBound(arrResultSet, 2) To UBound(arrResultSet, 2) 
        '1. 팀정보  
        number = arrResultSet(0, ar)
        gameName = arrResultSet(1, ar)
        sido = arrResultSet(2, ar)
        leader = arrResultSet(3, ar)
        isPlayer = arrResultSet(4, ar)
        teamGb = arrResultSet(5, ar)
        level = arrResultSet(6, ar)
        isGroup = arrResultSet(7, ar)
        '2. 플레이어1 정보
        player1_sex= arrResultSet(8, ar)
        player1_name = arrResultSet(9, ar)
        player1_birthday = arrResultSet(10, ar)

        'Response.Write "number : " & number & "<br/>"
        'Response.Write "gameName : " & gameName & "<br/>"
        'Response.Write "sido : " & sido & "<br/>"
        'Response.Write "leader : " & leader & "<br/>"
        'Response.Write "isPlayer : " & isPlayer & "<br/>"
        'Response.Write "teamGb : " & teamGb & "<br/>"
        'Response.Write "level : " & level & "<br/>"
        'Response.Write "isGroup : " & isGroup & "<br/>"
        'Response.Write "player1_sex : " & player1_sex & "<br/>"
        'Response.Write "player1_name : " & player1_name & "<br/>"


    %>
    <tr>
      <td>
        <%=number%>
      </td>
      <td>
        <%=gameName%>
      </td>
      <td>
        <%=sido%>
      </td>
      <td>
        <%=leader%>
      </td>
      <td>
        <%=isPlayer%>
      </td>
      <td>
        <%=teamGb%>
      </td>
      <td>
      <%=level%>
      </td>
      <td>
        <%=isGroup%>
      </td>
      <td>
        <%=player1_sex%>
      </td>
      <td>
        <%=player1_name%>
      </td>
      <td>
        <%=player1_birthday%>
      </td>
    </tr>   
    <%
        Next
      End If      
      'Response.Write "player1_sido : " & player1_sido  & ":"
    'Response.Write "player1_gugun : " & player1_gugun  &  ":"
    'Response.Write "player1_team : " & player1_team  & ":"
    'Response.Write "player1_name : " & player1_name  &  ":"
    'Response.Write "palyer1_birthday : " & palyer1_birthday  &  ":"
    'Response.Write "palyer1_sex : " & palyer1_sex  & ":"
    'Response.Write "palyer1_phone : " & palyer1_phone  & ":"
    'Response.Write "palyer1_Other : " & palyer1_Other  & ":"
    'Response.Write "<br/>"
    'Response.Write "player2_sido : " & player2_sido  & ":"
    'Response.Write "player2_gugun : " & player2_gugun  &  ":"
    'Response.Write "player2_team : " & player2_team  & ":"
    'Response.Write "player2_name : " & player2_name  &  ":"
    'Response.Write "palyer2_birthday : " & palyer2_birthday  &  ":"
    'Response.Write "palyer2_sex : " & palyer2_sex  & ":"
    'Response.Write "palyer2_phone : " & palyer2_phone  & ":"
    'Response.Write "palyer2_Other : " & palyer2_Other  & ":"
    'Response.Write "<br/><br/><br/><br/>"
    %>
    
  </tbody>
</table>
  <% if cdbl(arrRowCount) = 0 then %>
  <div class="board-bullet Non-pagination" >
      데이터가 존재하지 않습니다.
  </div>
  <% End If %>
<%END IF%>