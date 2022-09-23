<!--#include virtual="/Manager/Library/config.asp"-->
<%
  If Request.Cookies("UserID") = "" Then
    Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
    Response.End
  End If 



	'엑셀다운로드
	fileNm = "태블릿신청 현황"	


	Response.Buffer = True
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "Content-disposition","attachment;filename="&fileNm&".xls"


	LSQL = "select "
	LSQL = LSQL&" CONVERT(varchar(10),writedate,102) AS 신청일자"
	LSQL = LSQL&", Case When Pricetype = '0' Then '2.5G' When Pricetype='1' Then '5G' End AS 요금제"
	LSQL = LSQL&"	,'유도' AS 종목"
	LSQL = LSQL&"	,SportsDiary.dbo.fn_TeamGbnm('judo',TeamGb) AS 소속"
	LSQL = LSQL&"	,Sportsdiary.dbo.FN_SidoName(Sido,'judo') AS 시도"
	LSQL = LSQL&"	,TeamNm AS 팀명"
	LSQL = LSQL&"	,Case When LeaderType = '2' Then '감독' When LeaderType = '3' Then '코치' When LeaderType = '7' Then '트레이너' End AS 지도자구분"
	LSQL = LSQL&"	,LeaderNm AS 지도자명"
	LSQL = LSQL&"	,Case When Sex='1' Then '남자' When Sex='2' Then '여자' When Sex='3' Then '혼성' End AS 관리팀성별"
	LSQL = LSQL&"	,Email AS 이메일"
	LSQL = LSQL&"	,PhoneNum AS 유선번호"
	LSQL = LSQL&"	,HPhone AS 휴대폰번호"
	LSQL = LSQL&"	,Case When AgreeYN = 'Y' Then '동의' Else '미동의' End AS 개인정보동의"
	LSQL = LSQL&"	,Receive_Number1 + Receive_Number2 + Receive_Number3 AS 연락받을전화번호 "
	LSQL = LSQL&"	,Hope_Number AS 희망번호"
	LSQL = LSQL&"	,Bill_Type AS 청구서종류"
	LSQL = LSQL&"	,Bill_Post AS 배송지주소"
	LSQL = LSQL&"	,Bank_Name AS 은행명"
	LSQL = LSQL&"	,Bank_Number AS 계좌번호"
	LSQL = LSQL&"	,Bank_User AS 입금자명"
	LSQL = LSQL&"	,User_Birth AS 생년월일"
	LSQL = LSQL&"	,User_Type AS 명의구분"
	LSQL = LSQL&"	,juridical AS 법인명"
	LSQL = LSQL&"	,juridical_number AS 법인번호"
	LSQL = LSQL&"	,Com_number AS 사업자번호"
	LSQL = LSQL&"	,person_name AS 이름"
	LSQL = LSQL&"	,person_number1 AS 주민번호앞자리"
	LSQL = LSQL&"	,person_number2 AS 주민번호뒷자리"
	LSQL = LSQL&"	,ISNULL(card_name,'') AS 카드사명"
	LSQL = LSQL&"	,card_num1 + card_num2 + card_num3 + card_num4 AS 카드번호"
	LSQL = LSQL&"	,card_month AS 유효기간월"
	LSQL = LSQL&"	,card_year AS 유효기간년"
	LSQL = LSQL&"	,card_pass AS 비밀번호앞자리"

	LSQL = LSQL&"	 FROM Sportsdiary.dbo.tblTabletRegist"
	LSQL = LSQL&"	 WHERE DelYN='N'"
'Response.Write LSQL
'Response.End
	Set LRs = Dbcon.Execute(LSQL)



%>
<table border="1">
	<tr>
		<td>신청일자</td>
		<td>요금제</td>
		<td>종목</td>
		<td>소속</td>
		<td>시도</td>
		<td>팀명</td>
		<td>지도자구분</td>
		<td>지도자명</td>
		<td>관리팀성별</td>
		<td>이메일</td>
		<td>유선번호</td>
		<td>휴대폰번호</td>
		<td>개인정보동의</td>
		<td>연락받을전화번호</td>
		<td>희망번호</td>
		<td>청구서종류</td>
		<td>배송지주소</td>
		<td>은행명</td>
		<td>계좌번호</td>
		<td>입금자명</td>
		<td>생년월일</td>
		<td>명의구분</td>
		<td>법인명</td>
		<td>법인번호</td>
		<td>사업자번호</td>
		<td>이름</td>
		<td>주민번호앞자리</td>
		<td>주민번호뒷자리</td>
		<td>카드사명</td>
		<td>카드번호</td>
		<td>유효기간월</td>
		<td>유효기간년</td>
		<td>비밀번호앞자리</td>

	</tr>
	<%
		If Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof 
	%>
	<tr>
		<td style="mso-number-format:\@"><%=LRs("신청일자")%></td>
		<td style="mso-number-format:\@"><%=LRs("요금제")%></td>
		<td style="mso-number-format:\@"><%=LRs("종목")%></td>
		<td style="mso-number-format:\@"><%=LRs("소속")%></td>
		<td style="mso-number-format:\@"><%=LRs("시도")%></td>
		<td style="mso-number-format:\@"><%=LRs("팀명")%></td>
		<td style="mso-number-format:\@"><%=LRs("지도자구분")%></td>
		<td style="mso-number-format:\@"><%=LRs("지도자명")%></td>
		<td style="mso-number-format:\@"><%=LRs("관리팀성별")%></td>
		<td style="mso-number-format:\@"><%=LRs("이메일")%></td>
		<td style="mso-number-format:\@"><%=LRs("유선번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("휴대폰번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("개인정보동의")%></td>
		<td style="mso-number-format:\@"><%=LRs("연락받을전화번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("희망번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("청구서종류")%></td>
		<td style="mso-number-format:\@"><%=LRs("배송지주소")%></td>
		<td style="mso-number-format:\@"><%=LRs("은행명")%></td>
		<td style="mso-number-format:\@"><%=LRs("계좌번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("입금자명")%></td>
		<td style="mso-number-format:\@"><%=LRs("생년월일")%></td>
		<td style="mso-number-format:\@"><%=LRs("명의구분")%></td>
		<td style="mso-number-format:\@"><%=LRs("법인명")%></td>
		<td style="mso-number-format:\@"><%=LRs("법인번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("사업자번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("이름")%></td>
		<td style="mso-number-format:\@"><%=LRs("주민번호앞자리")%></td>
		<td style="mso-number-format:\@"><%=LRs("주민번호뒷자리")%></td>
		<td style="mso-number-format:\@"><%=LRs("카드사명")%></td>
		<td style="mso-number-format:\@"><%=LRs("카드번호")%></td>
		<td style="mso-number-format:\@"><%=LRs("유효기간월")%></td>
		<td style="mso-number-format:\@"><%=LRs("유효기간년")%></td>
		<td style="mso-number-format:\@"><%=LRs("비밀번호앞자리")%></td>
	</tr>
	<%
				LRs.MoveNext
			Loop 
		End If 
	%>
</table>
