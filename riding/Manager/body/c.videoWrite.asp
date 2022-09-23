<%
URIINFO = "/video.asp"
%>
<script type='text/javascript'>
  function on_select_year(this_is){
    var strAjaxUrl="/pub/ajax/riding/photoWriteTitle.asp?get_year="+this_is.value;
    var retDATA="";
     $.ajax({
       type: 'GET',
       url: strAjaxUrl,
       dataType: 'html',
       success: function(retDATA) {
        if(retDATA)
          {
            document.getElementById("Search_GameTitleIDX_div").innerHTML =retDATA;
          }
       }
     }); //close $.ajax(
  }

  function on_select_title(this_is){
    var strAjaxUrl="/pub/ajax/riding/videoWriteGB.asp?tidx="+this_is.value;
    var retDATA="";
     $.ajax({
       type: 'GET',
       url: strAjaxUrl,
       dataType: 'html',
       success: function(retDATA) {
        if(retDATA)
          {
            document.getElementById("Search_GameGB_div").innerHTML =retDATA;
          }
       }
     }); //close $.ajax(
  }

  function OK_Link(){
	  if (document.getElementById('Search_GameTitleIDX').value =='')
	  {
		  alert('대회를 선택해 주시기 바랍니다');
		  return;
	  }
	  if (document.getElementById('Search_GBIDX').value =='')
	  {
		  alert('종목을 선택해 주시기 바랍니다');
		  return;
	  }
	  document.form1.submit();
  }
</script>








  <form id="form1" name="form1" action="./videoInsert.asp" method="post">
  <input type="hidden" name="ReturnURI" value="<%=URIINFO%>">


		<div class="admin_content">
			<div class="page_title"><h1>경기영상 > 등록</h1></div>

			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">

		<div class="form-group">

			<label class="col-sm-1 control-label">년도</label>
			<div class="col-sm-2">
            <select id="Search_Year" name="Search_Year" class="form-control " onchange="on_select_year(this)">
              <%For fny =year(date) To year(date)-4 Step -1%>
              <option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
              <%Next%>
            </select>
			</div>

			<label class="col-sm-1 control-label">대회명/종목</label>
			<div class="col-sm-2">
            <select id="Search_GameTitleIDX" name="Search_GameTitleIDX" class="form-control form-control-half" style="width:250pt;" onchange="on_select_title(this)">
              <option value="">=대회선택=</option>
              <%
                If gameyear = "" Then
                  GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
                  GSQL = GSQL & " from sd_TennisTitle  "
                  GSQL = GSQL & " where   DelYN='N' "
                  GSQL = GSQL & " ORDER BY GameS DESC"
                Else
                  GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
                  GSQL = GSQL & " from sd_TennisTitle  "
                  GSQL = GSQL & " where   DelYN='N' and GameYear='"&gameyear&"'"
                  GSQL = GSQL & " ORDER BY GameS DESC"
                End If
                  'Response.write GSQL
                  Set GRs = db.ExecSQLReturnRS(GSQL , null, ConStr)
                  If Not(GRs.Eof Or GRs.Bof) Then
                    Do Until GRs.Eof
                      %>
                      <option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(modGameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
                      <%
                      GRs.MoveNext
                    Loop
                  End If
              %>
            </select>
			</div>



			<div class="col-sm-2">
				  <span id="Search_GameGB_div">
				  <select id="Search_GBIDX" name="Search_GBIDX" class="form-control form-control-half" style="width:250pt;">
					<option value="">=종목선택=</option>
				  </select>
				  </span>
			</div>
		</div>





		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" id="btnsave" class="btn btn-primary" onclick="OK_Link();" accesskey="i">저장</a>
			<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./video.asp'" accesskey="i">목록</a>
		</div>




			</div>
			<!-- e: 정보 검색 -->
		</div>

  </form>


	<div class="form-group" style="margin:15px;">
      <label class="control-label col-sm-1">경기영상</label>
      <div >
				<div class="input-group">※ 경기영상은 리스트 등록후에 리스트 뷰에서 진행 하세요.</div>
      </div>
    </div>













<%If fdsafdsfdsfsd = "막아두고" then%>

<div class="admin_content">
  <a name="contenttop"></a>

  <div class="btn-group pull-right">
    <a href="#" id="btnsave" class="btn btn-primary" onclick="OK_Link();" accesskey="i">저장</a>
    <a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./video.asp'" accesskey="i">목록</a>
  </div>

  <div class="page_title"><h1>현장스케치 > 등록</h1></div>
  <form id="form1" name="form1" action="./videoInsert.asp" method="post">
  <input type="hidden" name="ReturnURI" value="<%=URIINFO%>">
  <div class="form-horizontal">
    <div class="form-group">
      <label class="control-label col-sm-1">대회명</label>
      <div class="col-sm-2">
				<div class="input-group">
          <label class="control-label" style="float:left;">
            <select id="Search_Year" name="Search_Year" class="form-control form-control-half" onchange="on_select_year(this)">
              <%For fny =year(date) To year(date)-4 Step -1%>
              <option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
              <%Next%>
            </select>
            <span id="Search_GameTitleIDX_div">
            <select id="Search_GameTitleIDX" name="Search_GameTitleIDX" class="form-control form-control-half" style="width:250pt;" onchange="on_select_title(this)">
              <option value="">=대회선택=</option>
              <%
                If gameyear = "" Then
                  GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
                  GSQL = GSQL & " from sd_TennisTitle  "
                  GSQL = GSQL & " where   DelYN='N' "
                  GSQL = GSQL & " ORDER BY GameS DESC"
                Else
                  GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
                  GSQL = GSQL & " from sd_TennisTitle  "
                  GSQL = GSQL & " where   DelYN='N' and GameYear='"&gameyear&"'"
                  GSQL = GSQL & " ORDER BY GameS DESC"
                End If
                  'Response.write GSQL
                  Set GRs = db.ExecSQLReturnRS(GSQL , null, ConStr)
                  If Not(GRs.Eof Or GRs.Bof) Then
                    Do Until GRs.Eof
                      %>
                      <option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(modGameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
                      <%
                      GRs.MoveNext
                    Loop
                  End If
              %>
            </select>
            </span>
          </label>
        </div>
      </div>
      <label class="control-label col-sm-1">종목</label>
      <div class="col-sm-2">
				<div class="input-group">
          <span id="Search_GameGB_div">
          <select id="Search_GBIDX" name="Search_GBIDX" class="form-control form-control-half" style="width:250pt;">
            <option value="">=종목선택=</option>
          </select>
          </span>
        </div>
      </div>
    </div>

	<div class="form-group">
      <label class="control-label col-sm-1">경기영상</label>
      <div class="col-sm-2">
				<div class="input-group">※ 경기영상은 리스트 등록후에 리스트 뷰에서 진행 하세요.</div>
      </div>
    </div>
  </div>
  </form>

</div>
<%End if%>