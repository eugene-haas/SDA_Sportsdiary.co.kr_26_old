<%
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx= oJSONoutput.GBIDX
	End if	
	If hasown(oJSONoutput, "TEAMGB") = "ok" then
		teamgb= oJSONoutput.TEAMGB
	End if	
	If hasown(oJSONoutput, "ORDERTYPE") = "ok" then
		ordertype= oJSONoutput.ORDERTYPE
	End if	
	If hasown(oJSONoutput, "KGAME") = "ok" then
		kgame= oJSONoutput.KGAME
	End if	


	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"



	'화면 열고 바로 시작




%>
<div class="modal-dialog">
    <div class="modal-content">
      <!-- header -->
      <div class="modal-header">
        <!-- 닫기(x) 버튼 -->
        <!-- <button type="button" class="close" data-dismiss="modal" onclick="$('#recordInputModal').hide();">×</button> -->
		<button type="button" class="close" data-dismiss="modal" onclick="location.reload();">×</button>
        <!-- header title -->
        <h4 class="modal-title">포인트적용</h4>
      </div>
      <!-- body -->

	  <div class="modal-body"  id="showmsg" style="overflow-y:scroll;height:100px;">
            <!-- Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br>Body<br> -->
      </div>

    </div>
</div>