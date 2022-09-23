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
  'REQ = "{""CMD"":1,""filName"":""제37회 대한배드민턴 협회장기대회 생활체육 전국배드민턴대회 신청현황.xlsx""}"
  Set oJSONoutput = JSON.Parse(REQ)
  filName = fInject(oJSONoutput.filName)
  'Response.Write "filName : " & filName & " <br> "
  sheetno = 0
  Dim strPath : strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\"  & filName

  Set adbCon = Server.CreateObject("ADODB.connection")
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

<a href='javascript:SetParticipate(<%=filName%>);'  class="btn list-btn btn-red"> 참가팀 넣기 </a>

<table class="table-list">
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
  
  <tbody id="tbodyExcelFileList">
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
        
            '3. 플레이어2 정보
            player2_sido = arrResultSet(13, ar)
            player2_gugun = arrResultSet(14, ar)
            player2_team = arrResultSet(15, ar)
            player2_name = arrResultSet(16, ar)
            palyer2_birthday = arrResultSet(17, ar)
            palyer2_sex= arrResultSet(18, ar)
            palyer2_phone= arrResultSet(19, ar)
            palyer2_Other= arrResultSet(20, ar)
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