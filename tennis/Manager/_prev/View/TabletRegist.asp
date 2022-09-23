<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
WriteDate    = fInject(Request("WriteDate"))
Search_Type  = fInject(Request("Search_Type"))
Search_Text  = fInject(Request("Search_Text")) 

LSQL = " SELECT "
LSQL = LSQL&"  Case When Pricetype = '0' Then '2.5G' When Pricetype='1' Then '5G' End AS 요금제 "
LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(SportsGb) AS 종목 "
LSQL = LSQL&",SportsDiary.dbo.fn_TeamGbnm('judo',TeamGb) AS 소속 "
LSQL = LSQL&" ,Sportsdiary.dbo.FN_SidoName(Sido,'judo') AS 시도"
LSQL = LSQL&",TeamNm AS 팀명 "
LSQL = LSQL&",Case When LeaderType = '2' Then '감독' When LeaderType = '3' Then '코치' When LeaderType = '7' Then '트레이너' End AS 지도자구분 "
LSQL = LSQL&" ,LeaderNm AS 지도자명"
LSQL = LSQL&",Case When Sex='1' Then '남자' When Sex='2' Then '여자' When Sex='3' Then '혼성' End AS 관리팀성별"
LSQL = LSQL&",Email AS 이메일 "
LSQL = LSQL&",PhoneNum AS 유선번호"
LSQL = LSQL&",HPhone AS 휴대폰번호"
LSQL = LSQL&",AgreeYN AS 개인정보동의"
LSQL = LSQL&",Receive_Number1 + Receive_Number2 + Receive_Number3 AS 연락반을전호번호 "
LSQL = LSQL&",Hope_Number AS 희방번호"
LSQL = LSQL&",Bill_Type AS 청구서종류"
LSQL = LSQL&",Bill_Post AS 배송지주소"
LSQL = LSQL&",Bank_Name AS 은행명 "
LSQL = LSQL&",Bank_Number AS 계좌번호 "
LSQL = LSQL&",Bank_User AS 은행명 "
LSQL = LSQL&",User_Birth AS 생년월일 "
LSQL = LSQL&",User_Type AS 명의구분 "
LSQL = LSQL&",juridical AS 법인명 "
LSQL = LSQL&",juridical_number AS 법인번호 "
LSQL = LSQL&",Com_number AS 사업자번호 "
LSQL = LSQL&",person_name AS 이름 "
LSQL = LSQL&",person_number1 AS 주민번호앞자리 "
LSQL = LSQL&",person_number2 AS 주민번호뒷자리 "
LSQL = LSQL&",card_num1 + card_num2 + card_num3 + card_num4 AS 카드번호 "
LSQL = LSQL&",card_month AS 유효기간월 "
LSQL = LSQL&",card_year AS 유효기간년 "
LSQL = LSQL&",card_pass AS 비밀번호앞자리 "
LSQL = LSQL&",CONVERT(varchar(10),writedate,102) AS 신청일자"
LSQL = LSQL&",IDX"
LSQL = LSQL&" FROM Sportsdiary.dbo.tblTabletRegist "
LSQL = LSQL&" WHERE DelYN='N' "

If WriteDate <> "" Then 
	Search_WriteDate = Replace(WriteDate,"-","")
LSQL = LSQL&" AND  CONVERT(varchar(10),writedate,112)='"&Search_WriteDate&"' "
End If 

If Search_Type <> "" And Search_Text <> "" Then 
	If Search_Type = "1" Then 
		LSQL = LSQL&" AND  LeaderNm like '%"&Search_Text&"%' "
	ElseIf Search_Type = "2" Then 
		LSQL = LSQL&" AND  TeamNm like '%"&Search_Text&"%' "
	ElseIf Search_Type = "3" Then 
		LSQL = LSQL&" AND  HPhone like '%"&Search_Text&"%' "
	End If 
End If 

LSQL = LSQL&" Order By WriteDate DESC "
'Response.Write LSQL
Set LRs = Dbcon.Execute(LSQL)
%>
<script type="text/javascript">
function chk_frm(){
	var sf = document.search_frm;

	if(sf.Search_Type.value=="" && sf.Search_Text.value!=""){
		alert("검색 유형을 선택해 주세요.");
		sf.Search_Type.focus();
		return false;
	}
	if(sf.Search_Type.value!="" && sf.Search_Text.value==""){
		alert("검색어를 입력해 주세요.");
		sf.Search_Type.focus();
		return false;
	}
	sf.submit();
}

//엑셀다운로드
function chk_excel(){	
	location.href="/Manager/View/TabletRegist_Excel.asp"
}

function chk_del(obj){
	if(confirm("해당 신청서를 삭제하시겠습니까?")){
		
	}
}
</script>
<section>
		<div id="content">
		<form method="post" name="search_frm" id="search_frm" action="TabletRegist.asp"> 
		<div class="loaction">
				<strong>태블릿신청</strong> &gt; 태블릿신청
			</div>
		<div class="sch">
			<table class="sch-table">
				<caption>검색조건 선택 및 입력</caption>
				<colgroup>
					<col width="80px" />
					<col width="80px" />
					<col width="80px" />
					<col width="*" />
				</colgroup>				 
				<tbody>
					<tr>
						<th scope="row"><label for="competition-name-2">신청일자</label></th>
						<td><input type="date" name="WriteDate" id="WriteDate" value="<%=WriteDate%>"></td>						
						<th scope="row">
							<select name="Search_Type" id="Search_Type">
								<option value="">=선택=</option>
								<option value="1" <%If Search_Type = "1" Then %>selected<%End If %>>신청자명</option>
								<option value="2" <%If Search_Type = "2" Then %>selected<%End If %>>소속명</option>
								<option value="3" <%If Search_Type = "3" Then %>selected<%End If %>>휴대폰번호</option>
							</select>
						</th>
						<td><input type="text" name="Search_Text" id="Search_Text" value="<%=Search_Text%>"/></td>						
				</tbody>
			</table>
		</div>
		</form>
		<div class="btn-right-list">
			<a href="javascript:chk_excel();" class="btn" id="btnview" accesskey="e">엑셀다운로드(E)</a>
			<a href="javascript:chk_frm();" class="btn" id="btnview" accesskey="s">검색(S)</a>
		</div>
		<!-- S : 리스트 -->
		<table class="table-list">
			<caption>대회 리스트</caption>
			<colgroup>
				<col width="70px" />
				<col width="80px" />
				<col width="50px" />
				<col width="50px" />
				<col width="50px" />				
				<col width="*" />
				<col width="80px" />
				<col width="80px" />
				<col width="80px" />
				<col width="120px" />
				<col width="120px" />
				<!--<col width="80px" />-->
			</colgroup>
			<thead>
				<tr>
				  <th scope="col">일련번호</th>
					<th scope="col">신청일자</th>
					<th scope="col">명의구분</th>
					<th scope="col">종목</th>					
					<th scope="col">시도</th>
					<th scope="col">팀명</th>
					<th scope="col">관리팀성별</th>
					<th scope="col">지도자구분</th>
					<th scope="col">신청자명</th>
					<th scope="col">유선번호</th>
					<th scope="col">휴대폰번호</th>
					<!--<th scope="col">삭제</th>					-->
				</tr>
			</thead>
			<tbody>
				<%
					If Not(LRs.Eof Or LRs.Bof) Then 
					i = 1
						Do Until LRs.Eof 
				%>
				<tr>
					<td><%=i%></td>
					<td><%=LRs("신청일자")%></td>
					<td><%=LRs("명의구분")%></td>
					<td><%=LRs("종목")%></td>
					<td><%=LRs("시도")%></td>
					<td><%=LRs("팀명")%></td>
					<td><%=LRs("관리팀성별")%></td>
					<td><%=LRs("지도자구분")%></td>
					<td><%=LRs("지도자명")%></td>
					<td><%=LRs("유선번호")%></td>
					<td><%=LRs("휴대폰번호")%></td>
					<!--<td><a href="#" onclick="chk_del('<%=LRs("IDX")%>')" class="btn">삭제</a></td>-->
				</tr>				
				<%
							i = i + 1
							LRs.MoveNext
						Loop 
					End If 
				%>
			</tbody>
		</table>
		<!-- E : 리스트 -->
		</div>
	<section>
