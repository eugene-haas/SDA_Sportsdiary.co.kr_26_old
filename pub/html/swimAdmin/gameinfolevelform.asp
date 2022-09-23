
		<input type="hidden" id="idx" value="<%=updateidx%>" />
		<input type="hidden" id="TitleIDX" value="<%=idx%>" />
		<p>대회정보관리 기본정보</p>

			<!-- <span id="sel_GameTitle"><strong><%=title%></strong></span> -->


		<div id="level_form" class="form-horizontal">
			<!-- #include virtual = "/pub/html/swimAdmin/gameinfoLevelFormLine1.asp" -->
		</div>

		<div class="form-horizontal">

			<div class="form-group">
				<label class="control-label col-sm-1">경기일자</label>

				<div class="col-sm-2">
					<input type="hidden"  id="VersusGb"  value="sd043003">
					<div class='input-group date' id='GameDateWrap'>
            <input type='text' class="form-control text-center" id="GameDate" value="<%=gamedate%>"/>
            <span class="input-group-addon">
              <span class="glyphicon glyphicon-calendar"></span>
            </span>
          </div>
				</div>

				<div class="col-sm-2">
					<div class='input-group date' id='GameTimeWrap'>
            <input type='text' class="form-control text-center" id="GameTime" placeholder="경기시간" value="<%=gametime%>"/>
            <span class="input-group-addon">
              <span class="glyphicon glyphicon-time"></span>
            </span>
          </div>
				</div>

			</div>

			<div class="form-group" id="sel_VersusGb">
				<label class="control-label col-sm-1">예선조수</label>
				<div class="col-sm-2">
					<input type="number" id="joocnt" class="form-control text-center" value="<%=joocnt%>">
				</div>
			</div>


			<div class="form-group">
				<label class="control-label col-sm-1">잔여팀수/최종</label>
				<div class="col-sm-2">
					<select id="LastRnd" class="form-control" title="본선 진행할 표시 라운드 입니다.">
						<option value="2" <%If endround = "2" then%>selected<%End if%>>1</option>
						<option value="4" <%If endround = "4" then%>selected<%End if%>>2</option>
						<option value="8" <%If endround = "8" then%>selected<%End if%>>4</option>
						<option value="16" <%If endround = "16" then%>selected<%End if%>>8</option>
						<option value="32" <%If endround = "32" then%>selected<%End if%>>16</option>
					</select>
				</div>
				<div class="col-sm-2">
					<select id="LastRchk" class="form-control"  title="최종라운드에서 랭킹강수를 구하기 위해서 필요한 정보입니다.">
						<option value="0" <%If LastRchk = "0" then%>selected<%End if%>>1</option>
						<option value="2" <%If LastRchk = "2" then%>selected<%End if%>>2강</option>
						<option value="3" <%If LastRchk = "3" then%>selected<%End if%>>4강</option>
						<option value="4" <%If LastRchk = "4" then%>selected<%End if%>>8강</option>
					</select>
				</div>
			</div>
		</div>


      <div class="btn-group pull-right">
        <a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
        <a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
        <a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
      </div>


		<!-- <table class="navi-tp-table">
			<caption></caption>
			<colgroup>
				<col width="90px">
				<col width="400px">
				<col width="100px">
				<col width="270px">
				<col width="94px">
				<col width="*">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><label for="competition-name">대회명</label></th>
					<td id="sel_GameTitle" colspan="3"><strong><%=title%></strong></td>
				</tr> -->

				<!-- <tr id="level_form"> -->
					<%'<!-- #include virtual = "/pub/html/swimAdmin/gameinfoLevelFormLine1.asp" -->%>
				<!-- </tr> -->

				<!-- <tr>
					<th scope="row">경기일자</th>
					<td>
						<input type="hidden"  id="VersusGb"  value="sd043003">
						<input type="text" id="GameDate" style="width:150px;" value="<%=gamedate%>">&nbsp;<input type="text"  id="GameTime"  placeholder="경기시간" class='timepicker' style="width:150px;" value="<%=gametime%>">
					</td>


					<th scope="row">예선조수</th>
					<td id="sel_VersusGb">

					<input type="number" id="joocnt" style="width:75px;height:30px;margin-bottom:0px;text-align:right;" value="<%=joocnt%>">
					</td>

					<th scope="row">잔여팀수/최종</th>
					<td>
					<select id="LastRnd" style="width:50px;" title="본선 진행할 표시 라운드 입니다.">
						<option value="2" <%If endround = "2" then%>selected<%End if%>>1</option>
						<option value="4" <%If endround = "4" then%>selected<%End if%>>2</option>
						<option value="8" <%If endround = "8" then%>selected<%End if%>>4</option>
						<option value="16" <%If endround = "16" then%>selected<%End if%>>8</option>
						<option value="32" <%If endround = "32" then%>selected<%End if%>>16</option>
					</select>

					<select id="LastRchk" style="width:70px;" title="최종라운드에서 랭킹강수를 구하기 위해서 필요한 정보입니다.">
						<option value="0" <%If LastRchk = "0" then%>selected<%End if%>>1</option>
						<option value="2" <%If LastRchk = "2" then%>selected<%End if%>>2강</option>
						<option value="3" <%If LastRchk = "3" then%>selected<%End if%>>4강</option>
						<option value="4" <%If LastRchk = "4" then%>selected<%End if%>>8강</option>
					</select>
					</td>

			</tbody>
		</table> -->
