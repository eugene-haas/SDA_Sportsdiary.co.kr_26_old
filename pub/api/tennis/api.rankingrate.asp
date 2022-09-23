<%
  'request
  strs1 = oJSONoutput.S1 '년도
  strs2 = oJSONoutput.S2 '개인, 단체
  strs3 = oJSONoutput.S3 '단,복
  strs4 = oJSONoutput.S4 '상세 부서

	title1 = oJSONoutput.T1
	title2 = oJSONoutput.T2
	title3 = oJSONoutput.T3
  
  pageno = oJSONoutput.PN
	
  Set db = new clsDBHelper

  
  	intPageNum = pageno
	intPageSize = 10

	'개인전테이블 + 개인 년도별스코어  tblPlayer + sd_TennisScore 
	'단체전테이블 + 단체 년도별스코어  tblTeamInfo + sd_TennisTeamScore

	If strs2 = "tn001001" Then '개인전

		table1 = " tblPlayer "
		table2 = " sd_TennisScore "
		strTableName = table1&" as a INNER JOIN "&table2&" as b ON a.PlayerIDX = b.PlayerIDX  "	

		If strs4 = "0" Then '전체
			fieldstr = " max(userName) as unm , max(TeamNm) as t1nm ,max(Team2Nm) as t2nm "
			strFieldName = fieldstr & " ,sum(win) as ws ,sum(lose) as ls "

			strSort = "  Order by ws Desc, ls asc"
			strSortR = "  Order by ws asc, ls desc "
			strWhere = " b.GameYear = " & strs1 & " group by a.PlayerIDX "
		Else
			fieldstr = " max(userName) as unm , max(TeamNm) as t1nm ,max(Team2Nm) as t2nm "
			strFieldName = fieldstr & " ,sum(win) as ws ,sum(lose) as ls "

			strSort = "  Order by ws Desc, ls asc"
			strSortR = "  Order by ws asc, ls desc "
			strWhere = " b.GameYear = " & strs1& " and b.key3 = " & strs4 & " group by a.PlayerIDX "
		End if

	Else '단체전############################

		table1 = " tblTeamInfo "
		table2 = " sd_TennisTeamScore "
		strTableName = table1&" as a INNER JOIN "&table2&" as b ON a.TeamNm = b.TeamNm  "	

		fieldstr = " a.TeamNm as tnm  "
		strFieldName = fieldstr & " ,win ,lose "

		strSort = "  Order by win Desc, lose asc"
		strSortR = "  Order by win asc, lose desc "
		strWhere = " b.GameYear = " & strs1 

	End If

	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )

If CDbl(pageno) > CDbl(intTotalPage) Then
	lastpage = "_end"
Else
	lastpage = "_ing"
End If


Call oJSONoutput.Set("pageno", pageno )
Call oJSONoutput.Set("lastchk", lastpage )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"
 
  
  
  db.Dispose
  Set db = Nothing
%>

<%If CMD = CMD_RANKINGRATE then%>

      <!-- S: winning-rate -->
      <div class="winning-rate">
        <!-- S: winning-rate-table --> 
        <table class="table table-striped table-bordered winning-rate-table state-table"  id="table-gradelist">

		  <caption id="DP_NowYear">
            <span><%=title1%></span>
            <span><%=title2%></span>
            <span><%=title3%></span>
          </caption>

          <thead id="list_title">

		<%If strs2 = "tn001001" Then '개인전%>
			<tr>
              <th>순위</th>
              <th>이름</th>
              <th>소속명</th>
              <th>경기수</th>
              <th>승(勝)</th>
              <th>패(敗)</th>
              <th>승률(%)</th>
            </tr>
          </thead>

		  <tbody id="list_body">
            <!-- <tr>
            <td colspan='8'>조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
            </tr> -->
		<%
			i = (intPageSize * (pageno -1)) + 1 
			Do Until rs.eof
			unm = rs("unm")
			t1nm = rs("t1nm")
			t2nm = rs("t2nm")
			ws = rs("ws")
			ls = rs("ls")
			totalgame = CDbl(ws) + CDbl(ls)

			winper = FormatPercent(ws/totalgame,0)
			%>
				<tr>
				  <td><%=i%></td>
				  <td><%=unm%></td>
				  <td><%=t1nm%>,<%=t2nm%></td>
				  <td><%=totalgame%></td>
				  <td><%=ws%></td>
				  <td><%=ls%></td>
				  <td><%=winper%></td>
				</tr>
			<%
			i = i + 1
			rs.movenext
			loop
			%>            
		<%Else ''단체전 ##############%>

			<tr>
              <th>순위</th>
              <th>팀명</th>
              <th>-</th>
              <th>경기수</th>
              <th>승(勝)</th>
              <th>패(敗)</th>
              <th>승률(%)</th>
            </tr>
          </thead>

		  <tbody id="list_body">
            <!-- <tr>
            <td colspan='8'>조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
            </tr> -->
		<%
			i = (intPageSize * (pageno -1)) + 1 
			Do Until rs.eof
			tnm = rs("tnm")
			ws = rs("win")
			ls = rs("lose")
			totalgame = CDbl(ws) + CDbl(ls)

			winper = FormatPercent(ws/totalgame,0)
			%>
				<tr>
				  <td><%=i%></td>
				  <td><%=tnm%></td>
				  <td>-</td>
				  <td><%=totalgame%></td>
				  <td><%=ws%></td>
				  <td><%=ls%></td>
				  <td><%=winper%></td>
				</tr>
			<%
			i = i + 1
			rs.movenext
			loop
			%> 

		<%End if%>
            
          </tbody>
        </table>
        <!-- E: winning-rate-table -->


  <!-- S: more-box -->
  <div class="more-box">
    <a href="javascript:score.gradeSearch()" class="btn btn-more">
    <span>더 보기</span>
    <span class="ic-deco">
      <i class="fa fa-plus"></i>
    </span>
    </a>
  </div>
  <!-- E: more-box -->
	  
	  
	  </div>
      <!-- E: winning-rate -->
<%else%>
		<%If strs2 = "tn001001" Then '개인전%>
		<%
			i = (intPageSize * (pageno -1)) + 1 
			Do Until rs.eof
			unm = rs("unm")
			t1nm = rs("t1nm")
			t2nm = rs("t2nm")
			ws = rs("ws")
			ls = rs("ls")
			totalgame = CDbl(ws) + CDbl(ls)

			winper = FormatPercent(ws/totalgame,0)
			%>
				<tr>
				  <td><%=i%></td>
				  <td><%=unm%></td>
				  <td><%=t1nm%>,<%=t2nm%></td>
				  <td><%=totalgame%></td>
				  <td><%=ws%></td>
				  <td><%=ls%></td>
				  <td><%=winper%></td>
				</tr>
			<%
			i = i + 1
			rs.movenext
			loop
			%>            
		<%Else ''단체전 ##############%>
		<%
			i = (intPageSize * (pageno -1)) + 1 
			Do Until rs.eof
			tnm = rs("tnm")
			ws = rs("win")
			ls = rs("lose")
			totalgame = CDbl(ws) + CDbl(ls)

			winper = FormatPercent(ws/totalgame,0)
			%>
				<tr>
				  <td><%=i%></td>
				  <td><%=tnm%></td>
				  <td>-</td>
				  <td><%=totalgame%></td>
				  <td><%=ws%></td>
				  <td><%=ls%></td>
				  <td><%=winper%></td>
				</tr>
			<%
			i = i + 1
			rs.movenext
			loop
			%> 
		<%End if%>
<%End if%>


