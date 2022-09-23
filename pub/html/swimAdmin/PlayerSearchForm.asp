<div class="form-group">

    <!-- <label class="col-sm-1 control-label"> -->
    <label for="fnd_Type" class="control-label col-sm-1">구분</label>
    <div class="col-sm-2">
      <select id="fnd_Type" class="form-control">
        <option value="s_name">선수명</option>
        <option value="s_team">팀명</option>
        <option value="s_phone">연락처</option>
        <option value="s_openrank">오픈부점수반영부</option>
    <%'                   <option value="s_grade">등급</option>               %>
    <%'                   <option value="s_birth">년도이상</option>               %>
    <%'                  <option value="s_point">포인트이상</option>              %>
      </select>

    </div>

    <label for="fnd_SEX" class="control-label col-sm-1">성별</label>
    <div class="col-sm-2">
      <select id="fnd_SEX" class="form-control">
        <option value="0">전체</option>
        <option value="Man">남자</option>
        <option value="WoMan">여자</option>
      </select>
    </div>

    <div class="col-sm-3">
      <div class="input-group">
        <input type="text" id="fnd_Str" onkeydown="if(event.keyCode == 13){mx.searchPlayer();}" class="form-control">
        <a href="javascript:mx.searchPlayer();" class="input-group-addon btn btn-primary" accesskey="s" >검색(S)</a>
        <input type="hidden" id="hiddensbtn" onclick = "mx.searchPlayer()">
      </div>
    </div>

    <div class=" col-sm-1">
      <label for="winner" class="control-label"><input type="checkbox" id = "winner" class="mgr4 checkbox-inline" value="W">우승자</label>
    </div>


</div>
