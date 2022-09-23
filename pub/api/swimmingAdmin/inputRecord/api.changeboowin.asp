<%
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	midx = oJSONoutput.Get("MIDX")
	gamedate = oJSONoutput.Get("GAMEDATE")
	ampm = oJSONoutput.Get("AMPM")


	Set db = new clsDBHelper


	SQL = "select preinfo from sd_gameMember where gamememberidx = " & midx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	preinfo = rs(0)

	'변경가능한 부번호를 찾아보자... 오늘 날짜의 부번호만..가져와야한다.....아래꺼 변경해야할꺼같구만...



  '사유코드 가져오기#####################
  'SQL = "select teamgbidx,cd_boo,cd_boonm,preinfo from tblTeamGbInfo where cd_type=2 and delyn = 'N' order by orderby  asc"
  If ampm = "am" Then
	  '관련필드 gbidx,cdb,cdbnm,cdc,cdcnm,levelno,tryoutgamedate,finalgamedate,gubunam,gubunpm,gameno,joono,gameno2,joono2
	  SQL = "select cdb,cdbnm from tblRGameLevel where GameTitleIDX = "&tidx&" and tryoutgamedate = '"&gamedate&"'  group by cdb,cdbnm "
  Else
	  SQL = "select cdb,cdbnm from tblRGameLevel where GameTitleIDX = "&tidx&" and finalgamedate = '"&gamedate&"' group by cdb,cdbnm "
  End if
  
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.EOF Then
		arrC = rs.GetRows()
  End if
  '사유코드 가져오기#####################

%>

<div class="modal-dialog">
  <div class="modal-content">

    <div class='modal-header game-ctr'>
      <!-- <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button> -->
      <button type='button' class='close' onclick="$('#modalB').modal('hide')">×</button>
      <h4 class="modal-title" id="myModalLabel">부변경 부, 조, 레인 (정확히 변경하세요. 오류는 당신책임)</button></h4>
    </div>

    <div class="modal-body">

      <div id="Modaltestbody" style="overflow:hidden;height:100px;">


	<%'#######################################################%>
      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">
              

						<div class="row" >
							<div class="col-md-3" >
								  <div class="form-group" >
									<select class="form-control"> 
									<option value="">--부선택--</option>
									<%
										If IsArray(arrC) Then  '부전이니까 업데이트 할대상을 찾자.
											For x = LBound(arrC, 2) To UBound(arrC, 2)
												l_code  = arrC(0,x)
												l_codenm  = arrC(1,x)
												%><option value="<%=l_code%>" <%If l_sayoocode = l_code then%>selected<%End if%>><%=l_codenm%></option><%
											Next
										End if
									%>
									</select>
								  </div>
							</div>

							<div class="col-md-3">
								  <div class="form-group">
									  <input class="form-control" type="text" id="c_joo"  onkeyup="this.value=this.value.replace(/[^0-9]/g,'')"  value="" maxlength="6"  placeholder="조">
								  </div>
							</div>
							<div class="col-md-3">
								  <div class="form-group">
									  <input class="form-control" type="text" id="c_rane"   onkeyup="this.value=this.value.replace(/[^0-9]/g,'')"  value="" maxlength="1"  placeholder="레인">
								  </div>
							</div>
							<div class="col-md-3">
								  <div class="form-group" style="text-align:left;">
									<a href="javascript:mx.(<%=idx%>,<%=l_midxL%>,<%=l_midxR%>);" class="btn btn-primary" >부변경</a>
								  </div>
							</div>
						</div>			  

            </div>


  
          </div>
        </div>

	  </div>
	<%'#######################################################%>





      </div>
    </div>




  </div>
</div>

<%


	Call db.Dispose()
	Set rs = Nothing
	Set db = Nothing
%>
