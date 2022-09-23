
  <div class="form-group">

    <label class="control-label col-sm-1">구분</label>
    <div class="col-sm-2">

      <select id="F1" class="form-control">
        <option value="teamnm" <%If F1 = "teamnm" then%>selected<%End if%>>팀명칭</option>
        <option value="phone" <%If F1 = "phone" then%>selected<%End if%>>연락처</option>
      </select>

    </div>
    <div class="col-sm-3">
      <div class="input-group">
        <input type="text" id="F2" onkeyup="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'maketeam.asp')}" class="form-control" value="<%=F2%>">
        <a href="javascript:px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'maketeam.asp')" class="input-group-addon btn btn-primary" accesskey="s">검색(S)</a>
      </div>
    </div>

  </div>

