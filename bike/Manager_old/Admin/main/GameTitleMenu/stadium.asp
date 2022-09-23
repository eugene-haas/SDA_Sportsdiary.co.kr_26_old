<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<%
	tIdx = fInject(crypt.DecryptStringENC(Request("tIDX")))
	crypt_tidx =crypt.EncryptStringENC(tidx)
   
	NowPage = fInject(Request("i2"))  ' 현재페이지
	PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
	BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	'Request Data
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

	If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어


	LSQL = "		SELECT GameTitleIDX ,GameTitleName,GameS,GameE ,EnterType,PersonalPayment, GroupPayment"
	LSQL = LSQL & " FROM  tblGameTitle"
	LSQL = LSQL & " WHERE GameTitleIDX = " &  tidx
	
   	'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL

	Set LRs = DBCon.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
			tGameTitleIDX = LRs("GameTitleIDX")
			tGameTitleEnterType = LRs("EnterType")
			tGameTitleName = LRs("GameTitleName")
			tGameS = LRs("GameS")
			tGameE = LRs("GameE")
			tEnterType = LRS("EnterType") 
			tPersonalPayment= LRS("PersonalPayment")
			tGroupPayment= LRS("GroupPayment")
	 
			LRs.MoveNext
		Loop
	End If
		LRs.close
%>
<script type="text/javascript" src="../../js/GameTitleMenu/stadium.js"></script> 
<script type="text/javascript">
	/**
	* left-menu 체크
	*/
	var locationStr = "GameTitleMenu/index"; // 대회
	/* left-menu 체크 */


	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	function WriteLink(i2) {
		post_to_url('./stadium.asp', { 'i2': i2, 'iType': '1' });
	}

	function ReadLink(i1, i2) {
		post_to_url('./stadium.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
	}

	function PagingLink(i2) {
		post_to_url('./stadium.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function fn_selSearch() {
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;
		post_to_url('./stadium.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

</script>
<!--S: 다음 주소찾기 API-->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    function execDaumPostCode() {
		var themeObj = {
			bgColor: "", //바탕 배경색
			searchBgColor: "#0B65C8", //검색창 배경색
			contentBgColor: "#fefefe", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
			pageBgColor: "#dedede", //페이지 배경색
			textColor: "#000", //기본 글자색
			queryTextColor: "#FFFFFF", //검색창 글자색
			//postcodeTextColor: "#000", //우편번호 글자색
			//emphTextColor: "", //강조 글자색
			//outlineColor: "" //테두리
		};

		var width = 500;
		var height = 600;

        new daum.Postcode({
			width: width,
    		height: height,
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                //document.getElementById('ZipCode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('Addr').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('AddrDtl').focus();
            },
			theme: themeObj	
        }).open({
			popupName: 'postcodePopup', //팝업 이름을 설정(영문,한글,숫자 모두 가능, 영문 추천)
			left: (window.screenLeft) + (document.body.clientWidth / 2) - (width / 2),
			top: (window.screen.height / 2) - (height / 2)
		});
    }
</script>	
<!--E: 다음 주소찾기 API-->	
<input type="hidden" id="selGameTitleIdx" value="<%=crypt_tidx%>">
<!-- S: content stadium -->
<div id="content" class="stadium">
<!-- S : 내용 시작 -->
<div class="contents"> 
  <!-- S: page_title -->
  <div class="page_title clearfix">
    <h2>장소 등록/관리</h2>
    <a href="./index.asp" class="btn btn-back">뒤로가기</a> 
    
    <!-- S: 네비게이션 -->
    <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
      <ul>
        <li>대회정보</li>
        <li>대회운영</li>
        <li><a href="./index.asp">대회</a></li>
        <li><a href="./stadium.asp">장소 등록/관리</a></li>
      </ul>
    </div>
    <!-- E: 네비게이션 --> 
    
  </div>
  <!-- E: page_title --> 
	<div class="game_title">
		<strong id="Depth_GameTitle"><%=tGameTitleName%></strong> 
	</div>
  <!-- S: fromGameTitle -->
  <div id ="formGameTitle"> 
    <!-- S: stdatiuminput_area -->
    <div id="stdatiuminput_area"> 
      <!-- left-head view-table -->
      <table class="left-head view-table">
        <!-- <caption class="sr-only">대회정보 기본정보</caption> -->
        <colgroup>
        <col width="110px">
        <col width="*">
        <col width="110px">
        <col width="*">
        <col width="110px">
        <col width="*">
        </colgroup>
        <tbody>
          <tr>
            <th scope="row">경기 장소</th>
            <td><div> <span class="con">
                <input type="text" id="txtStadiumName" value="">
                </span> </div></td>
          </tr>
          <tr>
            <th scope="row">주소</th>
            <td>
							<div>
               <!-- <input type="hidden" readonly name="ZipCode" id="ZipCode"/>-->
                <span class="con">
									<input type="text" readonly name="Addr" id="Addr" onClick="execDaumPostCode();" />
								</span>
                <span class="con">
									<input type="text" name="AddrDtl" id="AddrDtl" placeholder="나머지 주소 입력" />
								</span>
								<a href="javascript:execDaumPostCode();" class="btn btn-confirm">주소검색</a>
								</div>
								</td>
          </tr>
          <tr>
            <th scope="row">코트수</th>
            <td><div> <span class="con">
                <input type="text" id="txtCourtCnt" value="">
                </span> </div></td>
          </tr>
        </tbody>
      </table>
      
      <!-- S: btn-list-left -->
      <div class="btn-list-left"> <a href="#" id="btnsave" class="btn btn-confirm" onclick="inputStadium_frm();" accesskey="i">등록(I)</a> <a href="#" id="btnupdate" class="btn btn-add" onclick="updateStadium_frm(<%=NowPage%>);" accesskey="e">수정(E)</a> <a href="#" id="btndel" class="btn btn-red" onclick="delStadium_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a> </div>
      <!-- E: btn-list-left --> 
    </div>
    <table class="table-list push-top">
      <thead>
        <tr>
          <th>번호</th>
          <th>경기 장소</th>
		  <th>코트 수 </th>												
		  <th>주소</th>									
          <th>상세주소</th>									
          <th>등록 날짜</th>
        </tr>
      </thead>
      <colgroup>
      <col width="30px">
      <col width="100px">
      <col width="30px">
      <col width="200px">
      <col width="150px">
      <col width="100px">
      </colgroup>
      <tbody id="levelContest">
        <%
		If(cdbl(tIdx) > 0) Then
			LSQL = "		SELECT StadiumIDX, GameTitleIDX, StadiumName, StadiumCourt, WriteDate, StadiumAddr, StadiumAddrDtl"
			LSQL = LSQL & " FROM  tblStadium"
			LSQL = LSQL & " WHERE DelYN ='N' and GameTitleIDX = '" & tidx & "'"
			
			'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
			
   			Set LRs = DBCon.Execute(LSQL)
			If Not (LRs.Eof Or LRs.Bof) Then
				Do Until LRs.Eof
					tStadiumIDX = LRs("StadiumIDX")
					crypt_tStadiumIDX =crypt.EncryptStringENC(tStadiumIDX)
					tGameTitleIDX = LRs("GameTitleIDX")
					tStadiumName = LRs("StadiumName")
					tStadiumCourt = LRs("StadiumCourt")
					tWriteDate = LRs("WriteDate")
					tAddr = LRs("StadiumAddr")
					tAddrDtl = LRs("StadiumAddrDtl")
					%>
					<tr style="cursor:pointer" onclick="javascript:SelStadium('<%=crypt_tStadiumIDX%>')">
					  <td><%=tStadiumIDX%></td>
					  <td><%=tStadiumName%></td>
					  <td><%=tStadiumCourt%></td>
					  <td><%=tAddr%></td>	  
					  <td><%=tAddrDtl%></td>	  
					  <td><%=tWriteDate%></td>
					</tr>
					<%
					LRs.MoveNext
				Loop
			End If
				LRs.close
		End IF
        %>
      </tbody>
    </table>
  </div>
</div>
<!-- E: contents -->
<div>
<!-- E: content stadium --> 

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>