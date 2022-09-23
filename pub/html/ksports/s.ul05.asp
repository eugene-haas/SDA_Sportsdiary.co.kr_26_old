          <li>
            <span class="txt"> 대회명</span>
            <input type="text" name="gametitle" id="gametitle" placeholder="대회명을 입력해주세요." value="<%=title%>" class="in_txt" maxlength="40" onkeydown="if(event.keyCode == 13){mx.searchPlayer(1);}">
          </li>

		  <li>
            <a href="javascript:mx.searchPlayer(1)" class="search_btn">검색</a>
          </li>

		  <%If REQ <> "" Then%>
		  <%If Not rs.eof Then%>
		  <li>
            <a href="javascript:mx.searchPlayer(1, 'findExcel.asp')" class="print_btn">검색내용 출력</a>
          </li>
		  <%End if%>
		  <%End if%>
		  <li></li>



