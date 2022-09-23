
        <table class="sch-table">
          <tbody>
            <tr>
			  <colgroup><col width="40px"><col width="200px"><col width="40px"><col width="60px"><col width="200"><col width="120px"><col width="*"></colgroup>              
			  <th scope="row">구분</th>
              <td><select id="fnd_Type">
                  <option value="s_name">선수명</option>
                  <option value="s_team">팀명</option>
                  <option value="s_phone">연락처</option>
                  <option value="s_grade">등급</option>              
                  <option value="s_birth">년도이상</option>              
                  <option value="s_point">포인트이상</option>              
				</select>
			  </td>
              <th scope="row">성별</th>
              <td><select id="fnd_SEX" style="width:60px;">
                  <option value="0">전체</option>
                  <option value="Man">남자</option>
                  <option value="WoMan">여자</option>
                </select></td>
              <td><input type="text" id="fnd_Str"></td>

			  <td><a href="javascript:mx.searchPlayer();" class="btn" accesskey="s">검색(S)</a></td>
			  <td></td>
			
			</tr>
          </tbody>
        </table>
	