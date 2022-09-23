<%
flag = request("flag")

viewContents = null
modGameTitleIDX = ""
URIINFO = "/photoWrite.asp"
if flag = "mod" Then
  idx = request("idx")
  sketch_idx = request("sketch_idx")

  sql = "select GameTitleIDX "_
  &" from "_
  &" (select "_
  &"	STT.GameTitleIDX, "_
  &" 	STSS.Idx "_
  &"	from sd_TennisTitle STT inner join sd_Tennis_Stadium_Sketch STSS on STT.GameTitleIDX = STSS.GameTitleIDX and STSS.Delyn = 'N' "_
  &"	where STT.DelYN = 'N' ) A "_
  &" where GameTitleIDX = '"& idx &"' and idx = '"& sketch_idx &"'"

  Set rs = db.ExecSQLReturnRS(sql , null, ConStr)
  if not rs.eof then
    viewContents = rs.GetRows()
  end if
  set rs = Nothing
  modGameTitleIDX = viewContents(0,0)

  URIINFO = "/photoView.asp"
end if

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

  function OK_Link(){
	  if (document.getElementById('Search_GameTitleIDX').value =='')
	  {
		  alert('대회를 선택해 주시기 바랍니다');
		  return;
	  }
	  if (document.getElementById('iFile_1').value =='')
	  {
		  alert('이미지를 1개이상 선택해 주시기 바랍니다.');
		  return;
	  }
	  document.form1.submit();
  }
  function OK_update(){
	  if (document.getElementById('Search_GameTitleIDX').value =='')
	  {
		  alert('대회를 선택해 주시기 바랍니다');
		  return;
	  }
	  document.form1.submit();
  }
</script>







  <form id="form1" name="form1" action="/pub/up/imgUpload.riding.asp" method="post" ENCTYPE="multipart/form-data">
  <input type="hidden" name="ReturnURI" value="<%=URIINFO%>">
  <input type="hidden" name="flag" value="<%=flag%>">
  <input type="hidden" name="sketch_idx" value="<%=sketch_idx%>">


		<div class="admin_content">
			<div class="page_title"><h1>현장스케치 > 등록</h1></div>

			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">

		<div class="form-group">

			<label class="col-sm-1 control-label">대회명</label>
			<div class="col-sm-2">
				<select id="Search_Year" name="Search_Year" class="form-control" onchange="on_select_year(this)">
				  <%For fny =year(date) To year(date)-4 Step -1%>
				  <option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
				  <%Next%>
				</select>
			</div>


			<div class="col-sm-2">
            <span id="Search_GameTitleIDX_div">
            <select id="Search_GameTitleIDX" name="Search_GameTitleIDX" class="form-control" style="width:250pt;">
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
			</div>


			<label class="col-sm-1 control-label" style="margin-left:100px;">워터마크</label>
			<div class="col-sm-2">
				<div class="input-group">
					<label class="control-label"><input type="checkbox" id="watermark_yn" name="watermark_yn"  value="Y">&nbsp;포함</label>
				</div>
			</div>


		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">이미지등록</label>
			<div class="col-sm-2">
				<div class="input-group">
				<label class="control-label" ><input multiple="multiple"  type="file" name="iFile" id="iFile_1"/>  </label>(다중파일 선택가능)
				</div>
			</div>
		</div>




		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" id="btnsave" class="btn btn-primary" onclick="<%if flag = "mod" then%>OK_update()<%else%>OK_Link()<%end if%>;" accesskey="i">저장</a>
			<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./photo.asp'" accesskey="i">목록</a>
		</div>




			</div>
			<!-- e: 정보 검색 -->
		</div>

  </form>


<!-- ///아래는 이전 소스/////////////////////////////////////////////////////////////////////////////////////////////// -->
<%If aaaaddddd= "fdsafkds" then%>
	<div class="admin_content">
	  <a name="contenttop"></a>

	  <div class="btn-group pull-right">
		<a href="#" id="btnsave" class="btn btn-primary" onclick="<%if flag = "mod" then%>OK_update()<%else%>OK_Link()<%end if%>;" accesskey="i">저장</a>
		<a href="#" id="btnsave" class="btn btn-primary" onclick="location.href='./photo.asp'" accesskey="i">목록</a>
	  </div>

	  <div class="page_title"><h1>현장스케치 > 등록</h1></div>
	  <form id="form1" name="form1" action="/pub/up/imgUpload.riding.asp" method="post" ENCTYPE="multipart/form-data">
	  <input type="hidden" name="ReturnURI" value="<%=URIINFO%>">
	  <input type="hidden" name="flag" value="<%=flag%>">
	  <input type="hidden" name="sketch_idx" value="<%=sketch_idx%>">
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
				<select id="Search_GameTitleIDX" name="Search_GameTitleIDX" class="form-control form-control-half" style="width:250pt;">
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
		  <label class="control-label col-sm-1">워터마크</label>
		  <div class="col-sm-2">
					<div class="input-group">
			  <label class="control-label" style="float:left;"><input type="checkbox" id="watermark_yn" name="watermark_yn"  value="Y">&nbsp;포함</label></label>
			</div>
		  </div>
		</div>
		<div class="form-group">
		  <label class="control-label col-sm-1">이미지등록</label>
		  <div class="col-sm-2">
			<div class="input-group">
			  <label class="control-label" style="float:left;"><input multiple="multiple"  type="file" name="iFile" id="iFile_1"/>(다중파일 선택가능)</label>
			</div>
		  </div>
		</div>
	  </div>
	  </form>

	</div>
<%End if%>
