
  <div class="form-group">


    <label class="control-label col-sm-1">지역</label>
    <div class="col-sm-2">
      <select id="fnd_sido" class="form-control">
        <option value="">전체</option>
        <option value="01">서울</option>
        <option value="02">부산</option>
        <option value="03">대구</option>
        <option value="04">인천</option>
        <option value="05">광주</option>
        <option value="06">대전</option>
        <option value="07">울산</option>
        <option value="08">경기</option>
        <option value="09">강원</option>
        <option value="10">충북</option>
        <option value="11">충남</option>
        <option value="12">전북</option>
        <option value="13">전남</option>
        <option value="14">경북</option>
        <option value="15">경남</option>
        <option value="16">제주</option>
        <option value="50">세종</option>
        <option value="18">시도없음</option>
      </select>
    </div>


    <label class="control-label col-sm-1">구분</label>
    <div class="col-sm-2">

      <select id="fnd_Type" class="form-control">
        <option value="s_team">팀명칭</option>
        <option value="s_phone">연락처</option>
      </select>

    </div>
    <div class="col-sm-3">
      <div class="input-group">
        <input type="text" id="fnd_Str" onkeydown="if(event.keyCode == 13){mx.searchTeam();}" class="form-control">
        <a href="javascript:mx.searchTeam();" class="input-group-addon btn btn-primary" accesskey="s">검색(S)</a>
      </div>
    </div>

  </div>
        <!-- <table class="sch-table">
		    <colgroup>
                <col width="40px">
                <col width="80px">
                <col width="40px">
                <col width="80px">
                <col width="200">
                <col width="120px">
                <col width="*">
            </colgroup>
          <tbody>
            <tr>
              <th scope="row">지역</th>
              <td>
                  <select id="fnd_sido" style="width:80px;">
                      <option value="">전체</option>
                      <option value="01">서울</option>
                      <option value="02">부산</option>
                      <option value="03">대구</option>
                      <option value="04">인천</option>
                      <option value="05">광주</option>
                      <option value="06">대전</option>
                      <option value="07">울산</option>
                      <option value="08">경기</option>
                      <option value="09">강원</option>
                      <option value="10">충북</option>
                      <option value="11">충남</option>
                      <option value="12">전북</option>
                      <option value="13">전남</option>
                      <option value="14">경북</option>
                      <option value="15">경남</option>
                      <option value="16">제주</option>
                      <option value="50">세종</option>
                      <option value="18">시도없음</option>
                    </select>
                </td>

            <th scope="row">구분</th>
            <td><select id="fnd_Type">
                <option value="s_team">팀명칭</option>
                <option value="s_phone">연락처</option>
			</select>
			</td>
              <td><input type="text" id="fnd_Str" onkeydown="if(event.keyCode == 13){mx.searchTeam();}"></td>
			  <td><a href="javascript:mx.searchTeam();" class="btn" accesskey="s">검색(S)</a></td>
			  <td></td>

			</tr>
          </tbody>
        </table> -->
