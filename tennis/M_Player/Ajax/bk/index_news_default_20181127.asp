<!--#include file="../Library/ajax_config.asp"-->
<%
    '==================================================================================================
  '메인페이지 일반뉴스
  '==================================================================================================
  dim NowPage   : NowPage     = "1"
  dim PagePerData : PagePerData   = "10"
  dim BlockPage   : BlockPage   = "10"
  dim iType     : iType     = "1"
  dim iDivision   : iDivision   = "200"   'iDivision -  1 : 전체 - 일반뉴스+영상뉴스, 2 : 일반뉴스, 3 : 영상뉴스, 200:일반뉴스(메인), 300:영상뉴스(메인)
  dim iSubType  : iSubType    = ""
  dim iSearchCol  : iSearchCol  = "T"
  dim iSearchText : iSearchText   = ""
  dim iYear     : iYear     = ""
  dim iNoticeYN   : iNoticeYN   = ""
  dim iSearchCol1   : iSearchCol1 = "S2Y"
  dim ieSearchCol2  : ieSearchCol2 = "" ' ColumnistIDX
  dim iSearchCol2 : iSearchCol2 = decode(ieSearchCol2,0)
  dim iLoginID  : iLoginID    = fInject(Request.cookies("SD")("UserID"))
  dim iLoginIDX  : iLoginIDX    = fInject(Request.cookies(SportsGb)("MemberIDX"))

  dim LCnt    : LCnt      = 0
  dim LRs, LSQL
%>
<script type="text/javascript">
	function MainMediaViewLink(valParam, i1, i2) {
		var selSearchValue1 = "<%=iSubType%>";
		var selSearchValue2 = "<%=iNoticeYN%>";
		var selSearchValue = "<%=iSearchCol%>";
		var txtSearchValue = "<%=iSearchText%>";

		var selSearchValue3 = "1"; // iDivision -  1 : 전체 - 일반뉴스+영상뉴스
		var selSearchValue4 = "<%=iSearchCol1%>";
		var selSearchValue5 = "<%=ieSearchCol2%>";

		/*
		//회원제 서비스 전환업데이트 20180726
		//회원제 서빔스 미적용으로 업데이트 20180813
		//현재계정 로그인 및 회원가입 여부에 따른 페이지 이동처리
		var CHK_VALUE = CHK_JOINMEMBER();

		switch(valParam){
			case '1001'	:
				if(CHK_VALUE==1001){
					if(confirm('회원정보가 필요한 서비스입니다. 로그인 또는 회원가입을 해주세요.\n\n로그인페이지로 이동하시겠습니까?')){
						$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/login.asp');
					}
					else{
						return;
					}
				}
				else{
					post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
				}
				break;
			case '1002'	:
				if(CHK_VALUE==1001){
					if(confirm('회원정보가 필요한 서비스입니다. 로그인 또는 회원가입을 해주세요.\n\n로그인페이지로 이동하시겠습니까?')){
						$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/login.asp');
					}
					else{
						return;
					}
				}
				else if(CHK_VALUE==1002){
					if(confirm('계정정보가 필요한 서비스입니다. 로그인 또는 계정추가를 해주세요.\n\n계정추가페이지로 이동하시겠습니까?')){
						$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/join_MemberTypeGb.asp');
					}
					else{
						return;
					}
				}
				else{
					post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
				}
				break;
			default :
				post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	   	}
		*/


		/*
		1. 회원제 서비스 전환업데잍트 20180726
			20180813 : 원복처리함
		- SD뉴스, 대회일정/결과(본선)
		*/

		post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
		//post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });

	}
</script>
<%


  LSQL = "EXEC SD_Tennis.dbo.Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainCLCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iSearchCol2 & "','" & iSearchCol1 & "','','','','',''"

  'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  SET LRs = DBCon3.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      LCnt = LCnt + 1
      %>
      <li>
        <!--<span class="l_icon">ㆍ</span>-->
        <a href="javascript:;" onclick="javascript:MainMediaViewLink('1001','<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>');">
					<span class="l-txt">· <%=LRs("Subject")%></span>
					<% if LRs("NewYN") = "Y" then %>
					<span class="ic-new-bg"></span><span class="ic-new">N</span>
					<% end if %>
        </a>
      </li>
      <%
      LRs.MoveNext
    Loop
  End If
    LRs.close
  SET LRs = Nothing

  DBClose3()
%>
