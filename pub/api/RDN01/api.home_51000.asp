<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "LEVELIDX") = "ok" then
		levelidx = oJSONoutput.get("LEVELIDX")
	End if

	attpidx = oJSONoutput.Get("PIDX")
	if attpidx = "" Then
		attpidx = session_pidx
	end if


	'Set db = new clsDBHelper

	'db.Dispose
	'Set db = Nothing
%>
<input type="hidden" id="selectidx">
<input type="hidden" id="selectnm">
<input type="hidden" id="selectpp">
<input type="hidden" id="selectlidx">
<div class="l_modal">
  <section class="m_search-horse">
	<h1 class="m_search-horse__header">마명 검색</h1>
	<div class="m_search-horse__con">
	  <div class="m_search-horse__con__search-box">
		<input type="text" id="inputfindhorse" value="" placeholder="마명을 검색해주세요." onkeyup = "mx.findHorse($('#inputfindhorse').val(),<%=levelidx%>,'<%=attpidx%>')">
		<%'api.home_51001.asp 말조건 검색%>
	  </div>

	  <div>
	  <table class="m_search-horse__con__tbl tbl">
		<thead>
		  <tr>
			<th>마명</th>
			<th>여권번호</th>
		  </tr>
		</thead>

		<tbody id="findhorselist" class="t_t2">
			<%'api.home_51001.asp%>
		</tbody>
	  </table>
  	</div>


	  <span class="m_search-horse__con__noti s_hide">마명을 검색하시고 선택한 후 확인 버튼을 눌러주세요.</span>
	</div>
	<div class="m_search-horse__btn-box clear">
	  <button class="m_search-horse__btn" type="button" name="button" onclick="mx.inputHorseInfo()">확인</button>
	  <button class="m_search-horse__btn t_cancel" type="button" name="button" onclick="$('#modalsearchHorse').hide ()">취소</button>
	</div>
  </section>
</div>
