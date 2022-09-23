<%
 'Controller ################################################################################################

	'request 처리##############
	page = chkInt(chkReqMethod("page", "GET"), 1)
	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>

		<div class="top-navi-inner">

			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>2017카타랭킹 xls자료</strong>
				</h3>
			</div>

		</div>

<div style="width:95%;margin:auto;height:25px;margin-top:1px;padding-left:5px;;border: 1px solid #73AD21;">2017년 카타랭킹 
<!-- <a href="javascript:mx.SetSheet(0,'2017rnk.xlsx')" class="btn_a">1번 쉬트 내용 선택</a> --><!-- 카타랭킹 -->
<!-- <a href="javascript:mx.copySheet(0,'랭킹샘플.xlsx')" class="btn_a">테이블에 복사</a> -->
<!-- <a href="javascript:mx.SetKata2017Rank(0)" class="btn_a">랭킹 디비에 저장</a> -->

<a href="javascript:mx.SetKata2017Rank(0)" class="btn_a">선수 부 정리</a>

</div>





<div id="updatelog" style="width:95%;margin:auto;height:300px;overflow-x:hidden;border: 1px solid #73AD21;"></div><!-- 쉬트뷰 -->


<span id="sheetview"></span><!-- 쉬트뷰 -->


