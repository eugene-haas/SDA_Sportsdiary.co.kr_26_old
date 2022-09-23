<%
	If hasown(oJSONoutput, "NM") = "ok" Then  '테이블 명
		TN = chkStrRpl(oJSONoutput.NM,"")
	End If	

	If hasown(oJSONoutput, "CN") = "ok" Then  '컬럼 명
		CN = chkStrRpl(oJSONoutput.CN,"")
	End If	

	If hasown(oJSONoutput, "CMT") = "ok" Then  '주석
		CMT = oJSONoutput.CMT
	Else
		CMT = ""
	End If	

	If hasown(oJSONoutput, "MD") = "ok" Then  '이전다음  : 0 첫장 :  1 이전 : 2 다음
		MD = chkInt(oJSONoutput.MD,0)
	Else
		MD = 3
	End If	


	Set db = new clsDBHelper

%>


        <div class="sub-content" id="bbslist">


			<!-- s: 정보 검색 -->
				<div class="info_serch box-shadow" id="gameinput_area">

					<div class="search-box">
						<ul id="ul_1">
							<li>

							<select id="selectTabelList" style="width:auto;"> 
							<%
							  if(IsArray(arr)) Then
								For ar = LBound(arr, 2) To UBound(arr, 2) 
								  Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
								NEXT
							  End IF
							%>
							</select>
							<a class="blue-btn" href="javascript:mx.copyTable('selectTabelList')" style="width:100px;">테이블 복사</a>
							</li>
						</ul>
					</div>

				</div>
			<!-- e: 정보 검색 -->



            <!-- S: competition_management -->
            <div class="competition_management">

    			<!-- s: 리스트 버튼 -->
    				<div class="t-btn-box">
						<a href='javascript:mx.goPage(mx.CMD_W,<%=reqjson%>,<%=page%>);' class="navy-btn" id="btnsave"  accesskey="i">글쓰기<span>(I)</span></a>
    					<!-- <a href="#" class="navy-btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
    					<a href="#" class="white-btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a> -->
    				</div>
    			<!-- e: 리스트 버튼 -->


    			<!-- s: 테이블 리스트 -->
    				<div class="table-box basic-table-box">
							<textarea id="bikeeditor"></textarea>
							<script>CKEDITOR.replace( 'bikeeditor' );</script>
    				</div>
    			<!-- e: 테이블 리스트 -->

    			<!-- s: 더보기 버튼 -->
				<div class="paging">

    			</div>
    			<!-- e: 더보기 버튼 -->

            </div>
            <!-- E: competition_management -->
		</div>

<%
	db.Dispose
	Set db = Nothing
%>