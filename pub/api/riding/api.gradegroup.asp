<%
  'request
  strs1 = oJSONoutput.S1 '날짜
  strs2 = oJSONoutput.S2 '선수명, 소속
  strs3 = oJSONoutput.S3 '검색문자열

  pageno = oJSONoutput.PN

  

	Set db = new clsDBHelper
	intPageNum = pageno
	intPageSize = 10

	table1 = " sd_TennisRanking "
	table2 = " sd_TennisTitle "
	strTableName = table1&" as a INNER JOIN "&table2&" as b ON a.GameTitleIDX = b.GameTitleIDX  "

	fieldstr = " idx,key3name,key1,key2,key3,ranknum,m1name as m1nm ,m1team1 as m1t1,m1team2 as m1t2, m2name as m2nm ,m2team1 as m2t1,m2team2 as m2t2,a.GameTitleIDX "
	strFieldName = fieldstr & " ,b.GameS, b.GameE,b.GameTitleName "

	If strs2 = "A" Then '선수명
		strSort = " Order by idx Asc"
		strSortR = " Order by idx Desc "
		strWhere = " b.GameYear = '" & strs1& "' and (m1name = '"&strs3&"' or m2name = '"&strs3&"') and ranknum in ( 1,2,3,4) "
	Else '소속명
		strSort = " Order by  GameTitleIDX, key3, ranknum"
		strSortR = " Order by GameTitleIDX desc, key3 desc,ranknum desc"
		strWhere = " b.GameYear = '" & strs1& "' and (m1team1 = '"&strs3&"' or m1team2 = '"&strs3&"' or m2team1 = '"&strs3&"' or m2team2 = '"&strs3&"')  and ranknum in ( 1,2,3,4) "
	End If


	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )

If CDbl(pageno) > CDbl(intTotalPage) Then
	lastpage = "_end"
Else
	lastpage = "_ing"
End if

Call oJSONoutput.Set("pageno", pageno )
Call oJSONoutput.Set("lastchk", lastpage )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

%>

<%If CMD = CMD_GAMEGRADEGROUP Then%>

      <!-- S: grade-state 입상자선수명 조회 
        상단 검색조건에서 조회하면 같은 성명의 리스트가 팝업으로 뜨고 생년월일로 구분
        선택 후 테이블이 보여짐
      -->
<%If strs2 = "A" Then '선수명%>
	  
	  <div class="grade-state">
        <!-- S: table-grade-state  -->
        <table class="table table-bordered table-striped grade-state-table" id="table-gradelist">
          <caption>
            <span id="DP_NowYear" class="year"><%=strs1%>년</span>
            <span class="player"><%=strs3%><!-- (810203) --></span>
          </caption>
          <thead id="list_title">
            <tr>
              <th>대회 날짜</th>
              <th>대회명</th>
              <th>경기방식</th>
              <th>경기유형</th>
              <th>소속구분</th>
              <th>입상결과</th>
              <th>소속명</th>
              <th>이름</th>
            </tr>
          </thead>
          <tbody id="list_body">
            <!-- <tr>
              <td colspan="8">조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
            </tr> -->
		<%
			Do Until rs.eof

			key1 = rs("key1")
			If key1 = "tn001001" Then
				key1str = "개인전"
			Else
				key1str = "단체전"
			End If

			key2 = rs("key2")
			If key2 = "200" Then
				key2str = "단식"
			Else
				key2str = "복식"
			End If

			key3name = rs("key3name")

			sdate  =  rs("GameS")
			edate = rs("GameE")
			gametitle = rs("GameTitleName")
			ranknum = rs("ranknum")
			If ranknum = "4" Then
				ranknum = 3
			End If

			m1nm = rs("m1nm")
			m2nm = rs("m2nm")
			m1t1 = rs("m1t1")
			m2t1 = rs("m2t1")

			If m1nm = strs3 Then
				mname = m1nm
				mteam = m1t1
			Else
				mname = m2nm
				mteam = m2t1
			End if

			gamedate = Replace(Mid(sdate,6,5),"-","/") & " ~ " &  Replace(Mid(edate,6,5),"-","/")
			%>
						<tr>
						  <td><%=gamedate%></td>
						  <td><%=gametitle%></td>
						  <td><%=key1str%></td>
						  <td><%=key2str%></td>
						  <td><%=key3name%></td>
						  <td>
							<%=ranknum%>위
						  </td>
						  <td><%=mteam%></td>
						  <td><%=mname%></td>
						</tr>
			<%
			rs.movenext
			loop
			%>
          </tbody>
        </table>
        <!-- E: table-grade-state -->
        </div>
        <!-- E: grade-state 입상자선수명 조회 -->

<%Else '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%>


	  <!-- S: grade-state 소속명 조회 -->
      <div class="grade-state" style="display:block">
        <table class="table table-bordered table-striped solo-state-table">
          <caption><%=strs1%>년</caption>
          <thead>
            <tr>
              <th>대회 기간 날짜</th>
              <th>대회명</th>
              <th>소속구분</th>
              <th>경기방식</th>
              <th>입상결과</th>
              <th>소속명</th>
            </tr>
          </thead>
          <tbody>
            <!-- <tr>
              <td colspan="6">조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
            </tr> -->
		<%
			i = 0
			Do Until rs.eof

				key1 = rs("key1")
				If key1 = "tn001001" Then
					key1str = "개인전"
				Else
					key1str = "단체전"
				End If

				key2 = rs("key2")
				If key2 = "200" Then
					key2str = "단식"
				Else
					key2str = "복식"
				End If

				key3name = rs("key3name")

				sdate  =  rs("GameS")
				edate = rs("GameE")
				gametitle = rs("GameTitleName")
				ranknum = rs("ranknum")
				If ranknum = "4" Then
					ranknum = 3
				End If

				m1nm = rs("m1nm")
				m2nm = rs("m2nm")
				m1t1 = rs("m1t1")
				m2t1 = rs("m2t1")

				gidx = rs("GameTitleIDX")
				key3 = rs("key3")

				gamedate = Replace(Mid(sdate,6,5),"-","/") & " ~ " &  Replace(Mid(edate,6,5),"-","/")
			
				
			%>            
				
				<tr>
				  <td><%=gamedate%></td>
				  <td><%=gametitle%></td>
				  <td><%=key1str%></td>
				  <td><%=key2str%></td>
				  <td><%=key3name%>&nbsp;&nbsp;<%=ranknum%>위</td><td><%=strs3%></td>
				</tr>
			<%
				i = i + 1
				pregametitle = gametitle
				prekey3name = key3name
				rs.movenext
			loop
			%>

          

          </tbody>
        </table>
        </div>



<%
End if
%>
  
		<!-- E: grade-state 소속명 조회 -->



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



<%Else '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%>
		<%
		If strs2 = "A" Then '선수명

			Do Until rs.eof

			key1 = rs("key1")
			If key1 = "tn001001" Then
				key1str = "개인전"
			Else
				key1str = "단체전"
			End If

			key2 = rs("key2")
			If key2 = "200" Then
				key2str = "단식"
			Else
				key2str = "복식"
			End If

			key3name = rs("key3name")

			sdate  =  rs("GameS")
			edate = rs("GameE")
			gametitle = rs("GameTitleName")
			ranknum = rs("ranknum")
			If ranknum = "4" Then
				ranknum = 3
			End If

			m1nm = rs("m1nm")
			m2nm = rs("m2nm")
			m1t1 = rs("m1t1")
			m2t1 = rs("m2t1")

			If m1nm = strs3 Then
				mname = m1nm
				mteam = m1t1
			Else
				mname = m2nm
				mteam = m2t1
			End if

			gamedate = Replace(Mid(sdate,6,5),"-","/") & " ~ " &  Replace(Mid(edate,6,5),"-","/")
			%>
						<tr>
						  <td><%=gamedate%></td>
						  <td><%=gametitle%></td>
						  <td><%=key1str%></td>
						  <td><%=key2str%></td>
						  <td><%=key3name%></td>
						  <td>
							<%=ranknum%>위
						  </td>
						  <td><%=mteam%></td>
						  <td><%=mname%></td>
						</tr>
			<%
			rs.movenext
			loop
		Else '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$




		End if
		%>
<%End if%>

