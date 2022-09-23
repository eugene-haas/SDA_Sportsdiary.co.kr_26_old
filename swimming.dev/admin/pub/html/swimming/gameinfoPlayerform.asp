<%
	If e_idx <> "" Then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>선수명</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									 <input type="text" name="mk_g0" id="mk_g0" class="form-control" placeholder="검색할 선수명을 입력해 주세요." value="<%=e_GameTitleName%>" >




<script type="text/javascript">
<!--
mx.idx = <%=idx%>;
mx.CMD_FINDPLAYER = 30008;

$(function(){
    $( "#mk_g0" ).autocomplete({
        source : function( request, response ) {

			 $.ajax({
                    type: mx.ajaxtype,
                    url: mx.ajaxurl,
                    dataType: "json",
                    data: { "REQ" : JSON.stringify({"CMD":mx.CMD_FINDPLAYER, "SVAL":request.term, "IDX":mx.idx})  },
                    success: function(data) {
                        //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
					    console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
						response(
                            $.map(data, function(item) {
                                return {
									label: item.username +'['+item.teamnm+']',
									value: item.username,
									team:item.teamnm,
									pidx:item.playeridx

                                }
                            })
                        );
                    }
               });
            },
        //조회를 위한 최소글자수
        minLength: 2,
        select: function( event, ui ) {
            // 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
			$('#mk_g1').val(ui.item.team);
			$('#mk_g2').val(ui.item.pidx);

        }
    });
})

//-->
</script>



								  </div>
							</div>
						</div>
				  </div>



            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
						<label>소속</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<input type="text" name="mk_g1" id="mk_g1" class="form-control" placeholder="검색된 소속명" value=""  readonly><%'팀명칭%>
									<input type="hidden" name="mk_g2" id="mk_g2" class="form-control"  value="" ><%'pidx%>									
									<input type="hidden" name="mk_g3" id="mk_g3" class="form-control"  value="<%=idx%>" ><%'level idx%>

								  </div>
							</div>
						</div>
				  </div>

			
			</div>

            <div class="col-md-6">
				  <div class="form-group">
						<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(4);" accesskey="i">등록<span>(I)</span></a>
								  </div>
							</div>
						</div>
				  </div>

            </div>

            <div class="col-md-6">

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

								  </div>
							</div>
						</div>
				  </div>

            </div>




</div>