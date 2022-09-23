          <li>
            <span class="txt">장소(지역)</span>
            <input type="hidden" id="zipcode" value="<%=zipcode%>">
            <input type="hidden" id="sido" value="<%=sido%>">
			<input type="text" name="gameaddr" id="gameaddr" placeholder="주소"  class="in_txt"  value="<%=gameaddr%>" onfocus="Postcode()"><!-- 포커스시 주소검색창 -->
          </li>
          <li>
            <span class="txt">경기장명</span>
            <input type="text" name="stadium" id="stadium" placeholder="경기장명을 입력해주세요." value="<%=stadium%>" class="in_txt">
          </li>
          <li>
            <span class="txt">&nbsp;</span>
            &nbsp;    
          </li>