<%
'######################
' 단체추발 추가 팀원 
'######################



'
	If hasown(oJSONoutput, "levelidx") = "ok" then
		levelidx = oJSONoutput.levelidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "tabno") = "ok" then
		tabno = oJSONoutput.tabno
	End if

	'##############################
	'Set db = new clsDBHelper

	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

	'db.Dispose
	'Set db = Nothing
%>						
				<!-- S: team-list -->
				 <div class="team-list" id="list3_<%=levelidx%>">
				  <div class="p-name">
					<span class="txt">팀원4</span>
					<span class="icon" onclick="mx.removeDom('list3_<%=levelidx%>',<%=levelidx%>,<%=tabno%>)">
					  <i class="fas fa-minus"></i>
					</span>
				  </div>

				  <!-- S: search-box -->
				  <div class="search-box" >
					<div class="input-box">
					  <input type="text" placeholder="팀원 아이디를 조회하세요."  id="m3_<%=levelIDX%>"  onkeydown='if(event.keyCode == 13){mx.chkPlayer(<%=JSON.stringify(oJSONoutput)%>,<%=levelIDX%>,3,<%=tabno%>)}'>
					</div>
					<a href='javascript:mx.chkPlayer(<%=JSON.stringify(oJSONoutput)%>,<%=levelIDX%>,3,<%=tabno%>)' class="bgray-btn">조회</a>
				     <ul  id="p3_<%=levelIDX%>" style="display:none;"></ul>

				  </div> 
				  <!-- E: search-box -->


				</div>
				<!-- E: team-list -->