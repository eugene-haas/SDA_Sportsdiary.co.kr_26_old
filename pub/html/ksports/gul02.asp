<li>		
	<span class="txt">대회목록</span>
	<select id="gl_1" onchange="mx.selectGame()" style="width:240px;">
	<%			
		'첫화면 totalCount 기본값 -1 
		If  totalCount = -1 Then
		%><option value="">=대회없음=</option><%

		'수정모드
		 ElseIf rsGameCode <> "" And mode = "e" Then 
		%><option value="<%=rsGameCode%>" classCode = "<%=rsclassCD%>" eventName="<%=rsGameName%>" eventYear="<%=rseventYear%>"><%=rsGameName%></option><%

		'검색결과 대회없음
		ElseIf totalCount = 0 Then
		%>
			 <option value="t99999999" <% If mode= "t" Then%>selected<%End If%>>=검색된 대회없음=</option>
		<%	
		
		'검색결과가 20개(1page) 초과일때
		ElseIf  totalpage > 1 Then	
		%><option value="">=대회선택=</option><%
			For j = 1 To totalPage - 1
				result = resultArr(j)
				For i = 0 To 19												
					rsArr = eventInfo (result, i)
					rsclassCD	    = rsArr(0)
					rsGameCode	   	= rsArr(1)
					rsGameName  	= rsArr(2) 
					rseventYear	   	= rsArr(3)
					%><option value="<%=rsGameCode%>" classCode = "<%=rsclassCD%>" eventName="<%=rsGameName%>" eventYear="<%=rseventYear%>"><%=rsGameName%></option><%
				Next
				Set result = Nothing
			Next
				result = resultArr(totalPage)
				For i = 0 To lastPage - 1
					rsArr = eventInfo (result, i)
					rsclassCD	    = rsArr(0)
					rsGameCode	   	= rsArr(1)
					rsGameName  	= rsArr(2) 
					rseventYear	   	= rsArr(3)
					%><option value="<%=rsGameCode%>" classCode = "<%=rsclassCD%>" eventName="<%=rsGameName%>" eventYear="<%=rseventYear%>"><%=rsGameName%></option><%
				Next					
		'검색결과가 1개 이상일때(1page 이내)
		ElseIf totalCount > 0 And mode <> "t" Then
			%><option value="">=대회선택=</option><%
			For i = 0 To totalCount - 1						
				rsArr = eventInfo (result, i)
				rsclassCD	      	= rsArr(0)
				rsGameCode	 		= rsArr(1)
				rsGameName  		= rsArr(2) 
				rseventYear	   		= rsArr(3)
				%><option value="<%=rsGameCode%>" classCode = "<%=rsclassCD%>" eventName="<%=rsGameName%>" eventYear="<%=rseventYear%>"><%=rsGameName%></option><%
			Next
		End If  
	%>
	</select>
</li>

<% If totalCount = 0 And mode <> "e" OR mode = "t" Then %>
<li>
	<span class="txt" style="width:140px;">대회명 임시입력</span>
	<input type="text" id="tempGameName" value= <% If rsGameName = "" Then %>"[임시대회] 대회명입력" <% End If %> "<%=rsGameName%>"></input>
</li>
<% End If %>