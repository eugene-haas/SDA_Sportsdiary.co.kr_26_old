<%
	'request
	strs1 = oJSONoutput.S1
	strs2 = oJSONoutput.S2
	strs3 = oJSONoutput.S3
	strs4 = oJSONoutput.S4

	title1 = oJSONoutput.T1
	title2 = oJSONoutput.T2
	title3 = oJSONoutput.T3


	If CMD = CMD_GAMEGRADEPERSONAPPEND then
		nextkey = Split(oJSONoutput.NKEY,"#$") '타이틀인덱스 #$ 다음검색인덱스
		nextgidx = nextkey(0)
		nextkey3 = nextkey(1)
	End if

	
	Set db = new clsDBHelper
	table1 = " sd_TennisRanking "
	table2 = " sd_TennisTitle "

	groupsort = " order by a.gameTitleIDX,key3, a.ranknum asc "
	fieldstr = " key3name,key3,ranknum,m1name as m1nm ,m1team1 as m1t1,m1team2 as m1t2, m2name as m2nm ,m2team1 as m2t1,m2team2 as m2t2,a.GameTitleIDX "
	fieldstr = fieldstr & " ,b.GameS, b.GameE,b.GameTitleName "

	If CMD = CMD_GAMEGRADEPERSON then
		If strs4 = "0" Then
			wherestr = " where b.GameYear = '" & strs1& "' "
		else
			wherestr = " where b.GameYear = '" & strs1& "' and key3 = " & strs4
		End If
	Else '다음 내용 불러오기 ####################################
		wherestr = " where b.GameYear = '" & strs1& "' and  a.GameTitleIDX = " & nextgidx & " and a.key3 = " & nextkey3
	End if

	'페이징
	SQL = "select top 5 " & fieldstr & "  from "&table1&" as a INNER JOIN "&table2&" as b ON a.GameTitleIDX = b.GameTitleIDX  " & wherestr & groupsort
	'aaa = sql
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if



	If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
		gidx = arrRS(9, ar) 
		key3 = arrRS(1, ar) 

		If ar = 0 then
			GameTitleName = arrRS(12, ar)
			sdate = arrRS(10, ar)
			edate = arrRS(11, ar)
		End if

		If ar > 0 And prekey3 <> key3 Then
			rowcnt = ar
			nextrowidx = gidx & "#$" & key3
			Exit for
		End if

	
	prekey3 = key3
	pregidx = gidx
	Next
	End If
	
	If nextrowidx = "" Then
		nextrowidx = "_end"
	End if
	

	If rowcnt = "" Then
		If IsArray(arrRS)  Then
			rowcnt = UBound(arrRS, 2) -1
		Else
			rowcnt = 0
		End if
	End if



'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("nextkey", nextrowidx )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"



  db.Dispose
  Set db = Nothing
%>
<%If CMD = CMD_GAMEGRADEPERSON Then%>

	<table class="table table-bordered table-striped solo-state-table" id="table-gradelist">
	  <caption id="DP_NowYear">
		<span><%=title1%></span>
		<span><%=title2%></span>
		<span><%=title3%></span>
	  </caption>
	  <thead id="list_title">
		<tr>
		  <th colspan="5">
			<span class="day">
			  <%=Replace(Mid(sdate,6,5),"-","/")%> ~ <%=Replace(Mid(edate,6,5),"-","/")%>
			</span>
			<span class="title">
			  <%=strs1%> <%=GameTitleName%>
			</span>
		  </th>
		</tr>
		<tr>
		  <th>소속구분</th>
		  <th>결과보기</th>
		  <th>입상결과</th>
		  <th>소속명</th>
		  <th>이름</th>
		</tr>
	  </thead>
	 
	  <tbody id="list_body">
		<!-- <tr>
		<td colspan='10'>조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
		</tr> -->
<%
i = 0
If IsArray(arrRS) Then
For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
	key3name = arrRS(0, ar) 
	key3 = arrRS(1, ar)
	ranknum =  arrRS(2, ar)

	m1nm =  arrRS(3, ar)
	m1t1 =  arrRS(4, ar)
	m1t2 =  arrRS(5, ar)

	m2nm =  arrRS(6, ar)
	m2t1 =  arrRS(7, ar)
	m2t2 =  arrRS(8, ar)

	sdate = arrRS(10, ar)
	edate = arrRS(11, ar)
%>

	<%If i = 0 or prename = key3name then%>

		<%If ranknum = "1" Then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="<%=rowcnt * 2%>"><%=key3name%></td>
		  <td rowspan="<%=rowcnt * 2%>">
			<a href="stat-tourney-result.asp" class="btn btn-show-result">보기</a>
		  </td>
		 
		  <td rowspan="2">1위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>

		<%If ranknum = "2" then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="2">2위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>

		<%If ranknum = "3" then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="2">3위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>

		<%If ranknum = "4" then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="2">3위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>
	<%
	Else
		prename = "끝이야"
	End if%>

	<%
i = i + 1
prekey3 = key3
prerank = ranknum
If prename <> "끝이야" then
	prename = key3name
End if
Next
End if
%>
	  </tbody>
	</table>




	<!-- S: more-box -->
	<div class="more-box">
	  <%If nextrowidx <> "_end" then%>
	  <a href="javascript:score.gradeSearch()" class="btn btn-more" id="_more">
		<span>더 보기</span>
		<span class="ic-deco"><i class="fa fa-plus"></i></span>
	  </a>
	  <%End if%>
	</div>
	<!-- E: more-box -->



<%else'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%>
<%
i = 0
If IsArray(arrRS) Then
For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
	key3name = arrRS(0, ar) 
	key3 = arrRS(1, ar)
	ranknum =  arrRS(2, ar)

	m1nm =  arrRS(3, ar)
	m1t1 =  arrRS(4, ar)
	m1t2 =  arrRS(5, ar)

	m2nm =  arrRS(6, ar)
	m2t1 =  arrRS(7, ar)
	m2t2 =  arrRS(8, ar)

	sdate = arrRS(10, ar)
	edate = arrRS(11, ar)
%>

<%If i = 0 or prename = key3name then%>

		<%If ranknum = "1" Then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="<%=rowcnt * 2%>"><%=key3name%></td>
		  <td rowspan="<%=rowcnt * 2%>">
			<a href="stat-tourney-result.asp" class="btn btn-show-result">보기</a>
		  </td>
		 
		  <td rowspan="2">1위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>

		<%If ranknum = "2" then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="2">2위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>

		<%If ranknum = "3" then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="2">3위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>

		<%If ranknum = "4" then '@@@@@@@@@@@@@@%>
		<tr>
		  <td rowspan="2">3위</td>
		  <td>
			<span class="belong"><%=m1t1%>,<%=m1t2%></span>
		  </td>
		  <td><%=m1nm%></td>
		</tr>
		<tr>
		  <td>
			<span class="belong"><%=m2t1%>,<%=m2t2%></span>
		  </td>
		  <td><%=m2nm%></td>
		</tr>
		<%End if%>
<%
Else
	prename = "끝이야"
End If
%>


<%
i = i + 1
prekey3 = key3
prerank = ranknum
If prename <> "끝이야" then
	prename = key3name
End if
Next
End if
%>

<%End if%>

