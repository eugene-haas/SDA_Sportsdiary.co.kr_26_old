<%
 'Controller ################################################################################################

	'request 처리##############
	'page = chkInt(chkReqMethod("page", "GET"), 1)
	'search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	'search_first = chkInt(chkReqMethod("search_first", "POST"), 0)
	'page = iif(search_first = "1", 1, page)
	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

'	SQL = "select a.partnerIDX,a.gameMemberIDX,b.gameMemberIDX from sd_TennisMember_partner as a left outer join sd_TennisMember as b on a.gameMemberIDX = b.gameMemberIDX"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	rsptcnt = rs.RecordCount


	'row_number() over(order by userName ) as rowno ,
	SQL = "select userName,COUNT(*) as c from tblPlayer where delYN = 'N' group by UserName having count(*) > 1 order by 2 desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt = rs.RecordCount
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>

<div class="top-navi-inner">
	<div class="top-navi-tp">
		<h3 class="top-navi-tit" style="height: 50px;"><strong>중복선수 정리</strong></h3>
	</div>
</div>


<a href="javascript:mx.LASTRS= <%=rscnt%>;mx.setPlayer(0);" class="btn">중복처리시작</a>
<a href="javascript:mx.delPn(0);" class="btn">파트너만있는 아이삭제</a>
<a href="javascript:mx.LASTRS= <%=rscnt%>;mx.copyPhoneNo(0);" class="btn">폰번호복사</a>
<a href="javascript:mx.LASTRS= <%=rscnt%>;mx.mergeTable(0);" class="btn">대진표 중복아이디합치기</a>

<div id="updatelog" style="width:95%;margin:auto;height:200px;overflow:auto;border: 1px solid #73AD21;"></div><!-- 쉬트뷰 -->


<%=rscnt%>
<%Call rsDrow(rs)%>


