  <div class="form-group">

    <label class="control-label col-sm-1">구분</label>
    <div class="col-sm-2">

      <select id="F1" class="form-control">
        <%Select Case pagename%>
		<%Case "makeplayer.asp"%>
		<option value="username" <%If F1 = "username" then%>selected<%End if%>>선수명</option>
        <option value="userphone" <%If F1 = "userphone" then%>selected<%End if%>>연락처</option>
		<%Case "horse.asp"%>
		<option value="username" <%If F1 = "username" then%>selected<%End if%>>말명</option>
		<%Case "referee.asp"%>
		<option value="username" <%If F1 = "username" then%>selected<%End if%>>심판명</option>
		<%End Select%>
      </select>

    </div>
    <div class="col-sm-3">
      <div class="input-group">
        <input type="text" id="F2" onkeyup="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'<%=pagenmae%>')}" class="form-control" value="<%=F2%>">
        <a href="javascript:px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'<%=pagenmae%>')" class="input-group-addon btn btn-primary" accesskey="s">검색(S)</a>
      </div>
    </div>

  </div>

