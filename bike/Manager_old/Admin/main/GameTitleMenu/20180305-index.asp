<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/GameTitleMenu/index.js"></script>


<script type="text/javascript">

  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./index.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./index.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./index.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./index.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

</script>
<%

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

  ' 전체 가져오기
  iType = "2"                      ' 1:조회, 2:총갯수

  LSQL = "EXEC tblGameTitle_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
  'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
  'response.End

  
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If

  'response.Write "NowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPageNowPage="&NowPage&"<br>"
  'response.Write "iTotalCountiTotalCountiTotalCountiTotalCountiTotalCountiTotalCount="&iTotalCount&"<br>"
  'response.Write "iTotalPageiTotalPageiTotalPageiTotalPageiTotalPageiTotalPage="&iTotalPage&"<br>" 
  'response.Write "PagePerDataPagePerDataPagePerDataPagePerDataPagePerDataPagePerData="&PagePerData&"<br>"  
  'response.Write "BlockPageBlockPageBlockPageBlockPageBlockPageBlockPageBlockPageBlockPage="&BlockPage&"<br>"  

  ' 게임 타입 ( 국제, 국내 대회 )
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B001'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameTitleType = LRs.getrows()
  End If

  ' 모집 팀 타입
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B013'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayTeamType = LRs.getrows()
  End If
%>
<section class="list_conten_box">
  <div id="content">
    <!-- S : 내용 시작 -->
    <div class="contents">
			<!-- s: 서브 네비게이션 -->
			<div class="page_title">
				<h3>대회</h3>
				<div class="r_navigation">
					<img src="../../images/sub_navi_icon.png" alt="" class="nav_icon">
					<span>어드민정보</span>
					<i class="fas fa-angle-right"></i>
					<span>대회운영</span>
					<i class="fas fa-angle-right"></i>
					<span>대회</span>
				</div>
			</div>
			<!-- s: 등록하기 접기/펼치기 -->
			<div class="registration_box">
				<table>
					<tr>
						<th>
							<span class="l_con"></span>대회구분
						</th>
						<td>
							<select id="SelNationType">
								<% If IsArray(arrayGameTitleType) Then
										For ar = LBound(arrayGameTitleType, 2) To UBound(arrayGameTitleType, 2) 
											GameTitleTypeCode   = arrayGameTitleType(0, ar) 
											crypt_GameTitleTypeCode =  crypt.EncryptStringENC(GameTitleTypeCode)
											GameTitleTypeName = arrayGameTitleType(1, ar) 
										%>
										<option value="<%=crypt_GameTitleTypeCode%>"><%=GameTitleTypeName%></option>
										<%
										Next
									End If      
								%>
							</select> 
						</td>
						<th>
							<span class="l_con"></span>대회명
						</th>
						<td>
							<input type="text" id="txtGameTitleName" placeholder="대회명을 입력해주세요." value="">
						</td>
						<th>
							<span class="l_con"></span>주최
						</th>
						<td>
							<span id="sel_GameTitleHost">
								<input type="text" id="txtGameTitleHost" value="" >
							</span>
						</td>
					</tr>
					<tr>
						<th>
							<span class="l_con"></span>대회시작일
						</th>
						<td>
							<span id="sel_GameSYear">
								<input type="text" id="GameS" value="" class="date_ipt">
							</span>
						</td>
						<th>
							<span class="l_con"></span>대회종료일
						</th>
						<td>
							<span id="sel_GameEYear">
								<input type="text" id="GameE" value="" class="date_ipt">
							</span>
						</td>
						<th>
							<span class="l_con"></span>지역
						</th>
						<td>
							<select id="SelGameTitleLocation">
								<option value="">==선택==</option>
								<%
										LSQL = "SELECT Sido ,SidoNm "
										LSQL = LSQL & " FROM  tblSidoInfo"
										LSQL = LSQL & " WHERE DELYN = 'N' "
										LSQL = LSQL & " Order by OrderbyNum "
																				
										Set LRs = DBCon.Execute(LSQL)
										If Not (LRs.Eof Or LRs.Bof) Then
											Do Until LRs.Eof
													rSido= LRs("Sido")
													rSidoNm = LRs("SidoNm")
													crypt_rSido = crypt.EncryptStringENC(rSido)
													%>
														<option value="<%=crypt_rSido%>"><%=rSidoNm%></option>
													<%
												LRs.MoveNext
											Loop
										End If
										LRs.close
								%>
							</select>
						</td>
					</tr>
					<tr>
						<th>
							<span class="l_con"></span>접수시작일
						</th>
						<td>
							<span><input type="text" id="GameRcvS" value="" class="date_ipt"></span>
						</td>
						<th>
							<span class="l_con"></span>접수종료일
						</th>
						<td>
							<span><input type="text" id="GameRcvE" value="" class="date_ipt"></span>
						</td>
						<th>
							<span class="l_con"></span>선수구분
						</th>
						<td>
							<select id="selEntertype">
								<option value="A">아마추어</option>
								<option value="E">엘리트</option>
							</select>                     
						</td>
					</tr>
					<tr>
						<th>
							<span class="l_con"></span>노출여부
						</th>
						<td>
							<select id="selViewYN" style="width: 260px">
								<option value="N">미노출</option>
								<option value="Y">노출</option>
							</select>
						</td>
						<th>
						</th>
						<td>
						</td>
						<th>
						</th>
						<td>
						</td>
					</tr>
				</table>
			</div>
			<!-- e: 등록하기 접기/펼치기 -->
			<!-- e: 서브 네비게이션 -->
      <div class="top-navi-inner item_sel_menu">
        <div class="top-navi-btm">
        <div class="navi-tp-table-wrap" >
         <div id ="formGameTitle">   
          <div id="gameinput_area">
            <table class="navi-tp-table">
              <caption>대회정보 기본정보</caption>
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
                  <th scope="row"><label for="competition-name">대회구분</label></th>
                  <td>
                   <select id="SelNationType">
                      <% If IsArray(arrayGameTitleType) Then
                          For ar = LBound(arrayGameTitleType, 2) To UBound(arrayGameTitleType, 2) 
                            GameTitleTypeCode   = arrayGameTitleType(0, ar) 
                            crypt_GameTitleTypeCode =  crypt.EncryptStringENC(GameTitleTypeCode)
                            GameTitleTypeName = arrayGameTitleType(1, ar) 
                          %>
                          <option value="<%=crypt_GameTitleTypeCode%>"><%=GameTitleTypeName%></option>
                          <%
                          Next
                        End If      
                      %>
                    </select> 
                                
                  </td>
                  <th scope="row">
                    <label for="competition-name">대회명</label>
                  </th>
                  <td>
                    <input type="text" id="txtGameTitleName" placeholder="대회명을 입력해주세요." value="">
                  </td>
                  <th scope="row">주최</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameTitleHost">
                        <input type="text" id="txtGameTitleHost" value="" >
                      </span>
                    </div>
                  </td>
                </tr>
                </tr>
                <tr>
                  
                <th scope="row">시작일</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameSYear">
                        <input type="text" id="GameS" value="" class="date_ipt">
                      </span>
                    </div>
                  </td>
                  <th scope="row">종료일</th>
                  <td>
                    <div class="ymd-list">
                      <span id="sel_GameEYear">
                        <input type="text" id="GameE" value="" class="date_ipt">
                      </span>
                    </div>
                  </td>
                  
                
                
                <tr>
                  <th scope="row">접수시작일</th>
                  <td>
                    <div class="ymd-list">
                      <span><input type="text" id="GameRcvS" value="" class="date_ipt"></span>
                    </div>
                  </td>
                  <th scope="row">접수종료일</th>
                  <td>
                    <div class="ymd-list">
                      <span><input type="text" id="GameRcvE" value="" class="date_ipt"></span>
                    </div>
                  </td>

        

                </tr>

                <tr>
                  <th scope="row"><label for="competition-place">지역</label></th>
                  <td>
                    <select id="SelGameTitleLocation">
                      <option value="">==선택==</option>
                      <%
                          LSQL = "SELECT Sido ,SidoNm "
                          LSQL = LSQL & " FROM  tblSidoInfo"
                          LSQL = LSQL & " WHERE DELYN = 'N' "
                          LSQL = LSQL & " Order by OrderbyNum "
                                              
                          Set LRs = DBCon.Execute(LSQL)
                          If Not (LRs.Eof Or LRs.Bof) Then
                            Do Until LRs.Eof
                                rSido= LRs("Sido")
                                rSidoNm = LRs("SidoNm")
                                crypt_rSido = crypt.EncryptStringENC(rSido)
                                %>
                                  <option value="<%=crypt_rSido%>"><%=rSidoNm%></option>
                                <%
                              LRs.MoveNext
                            Loop
                          End If
                          LRs.close
                      %>
                    </select>
                  </td>
                  <th scope="row">선수구분</th>
                  <td>
                    <select id="selEntertype">
                      <option value="A">아마추어</option>
                      <option value="E">엘리트</option>
                    </select>                     
                  </td>
               
                </tr>
                <tr>
                  <th scope="row">노출여부</th>
                  <td colspan="5">
                    <select id="selViewYN" style="width: 260px">
                      <option value="N">미노출</option>
                      <option value="Y">노출</option>
                    </select>
                  </td>
                    <!--
                  <th scope="row">대회달력노출</th>
                  <td>
                    <select id="ViewState">
                      <option value="N">미노출</option>
                      <option value="Y">노출</option>
                    </select>
                  </td> 
                  -->   
                </tr>
              </tbody>
            </table>
            
          </div>
          </div>
          <div class="btn-right-list">
              <a href="#" id="btnsave" class="btn" onclick="inputGameTitle_frm();" accesskey="i">등록(I)</a>
              <a href="#" id="btnupdate" class="btn" onclick="updateGameTitle_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
              <a href="#" id="btndel" class="btn btn-delete" onclick="delGameTitle_frm();" accesskey="r">삭제(R)</a>
            </div>
          </div>
        </div>
 
    </div>
		<!-- s: 서브 검색 -->
		<div class="sub_search">
			<div class="l_con">
				<ul>
					<li>
						<span class="l_txt">대회구분</span>
						<select name="" id="">
							<option value="">전체</option>
						</select>
					</li>
					<li>
						<span class="l_txt">대회명</span>
						<select name="" id="">
							<option value="">전체</option>
						</select>
					</li>
					<li>
						<span class="l_txt">지역</span>
						<select name="" id="">
							<option value="">전체</option>
						</select>
					</li>
					<li>
						<span class="l_txt">조직구분</span>
						<select name="" id="">
							<option value="">전체</option>
						</select>
					</li>
				</ul>
			</div>
			<div class="r_search_btn">
				<a href="#">검색</a>
			</div>
		</div>
		<!-- e: 서브 검색 -->
    <table class="table-list match_info">
      <thead>
        <tr>
          <th>번호</th>
          <th>기간(시작-종료)</th>
          <th>대회구분</th>
          <th>대회명</th>
          <th>선수구분</th>
          <th>주최</th>
          <th>지역</th>
          <th>노출</th>
          <th>종별관리</th>
          <th>장소관리</th>
          <th>종별</th>
          
        </tr>
      </thead>
      <colgroup>
        <col width="80px">
        <col width="170px">
        <col width="90px">
        <col width="200px">
        <col width="90px">
        <col width="100px">
        <col width="80px">
        <col width="80px">
        <col width="100px">
        <col width="100px">
        <col width="100px">
      </colgroup>
      <tbody id="contest">
        <%
          iType = 1
          LSQL = "EXEC tblGameTitle_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"

          'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
          'LSQL = LSQL & " FROM  tblGameTitle a "
          'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
          'LSQL = LSQL & " WHERE a.DELYN = 'N' "
          'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
          'response.End
          
          Set LRs = DBCon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                RGameTitleIDX = LRs("GameTitleIDX")
                crypt_RGameTitleIDX = crypt.EncryptStringENC(RGameTitleIDX)
                RGameGb = LRs("GameGb")
                RGameGbNm = LRs("GameGbNm")
                RGameTitleName = LRs("GameTitleName")
                RGameTitleHost = LRs("GameTitleHost")
                RGameS = LRs("GameS")
                RGameE = LRs("GameE")
                RGamePlace = LRs("GamePlace")
                RSido = LRs("Sido")
                RSidoNm = LRs("SidoNm")
                RSidoDtl = LRs("SidoDtl")
                REnterType = LRs("EnterType")
                RGameRcvDateS = LRs("GameRcvDateS")
                RGameRcvHourS = LRs("GameRcvHourS")
                RViewYN = LRs("ViewYN")
                RLevelCount = LRs("levelCount")
                RlevelGrooupNm = LRS("levelGrooupNm")
                RStadiumCount = LRS("StadiumCount")
                
                %>
                <tr>
                    <!-- 번호-->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                          <%=RGameTitleIDX%>
                      </td>
                      <!-- 날짜 -->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                      <%if RGameS = "" and RGameE = ""  Then %>
                        <%Response.Write  "-"%>
                      <%else%>
                        <%=RGameS%> ~ <br><%=RGameE%>
                      <%end if%>
                      </td>
                      <!-- 대회구분 -->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                          <%=RGameGbNm%> 
                      </td>
                      <!-- 대회 이름-->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                          <%=RGameTitleName%>
                      </td>

                      
                      <!-- 단체전-->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                          <%=REnterType%>
                      </td>

                        <!-- 주관 -->
                      <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                        <%
                            if(cdbl(Len(rGameTitleHost)) > 10) Then
                              response.write LEFT(rGameTitleHost, 10) & "..."
                            else
                              response.write rGameTitleHost
                            end if
                        %>
                      </td>
                      <!-- 지역-->
                      <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                        <%=RSidoNm%>
                      </td>
                      <!-- 단체전-->
                      <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                      <%=RViewYN%>
                      </td>
                      <td>
                      <%  IF CDBL(RLevelCount) = CDBL(0) Then %>
                        <a href="javascript:href_level('<%=crypt_RGameTitleIDX%>');" class="btn-primary" > 종별등록 </a>
                      <%ELSE%>
                        <a href="javascript:href_level('<%=crypt_RGameTitleIDX%>');" class="btn-success" > 종별관리 <%=RLevelCount%></a>
                      <%END IF%>
                      </td>
                      <td>
                      <%  IF CDBL(RStadiumCount) = CDBL(0) Then %>
                        <a href="javascript:href_stadium('<%=crypt_RGameTitleIDX%>');" class="btn-primary" > 장소등록 </a>
                      <%ELSE%>
                        <a href="javascript:href_stadium('<%=crypt_RGameTitleIDX%>');" class="btn-success" > 장소관리 <%=RStadiumCount%></a>
                      <%END IF%>
                      </td>
                      <!-- 종목 리스트-->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>')" style="cursor:pointer">
                        <%=RlevelGrooupNm%>
                      </td>
                  </tr>
                <%
              LRs.MoveNext
            Loop
          End If
          LRs.close
        %>
      </tbody>
      </div>
    </table>
       <%
      if cdbl(LCnt) > 0 then
      %>
        <!--#include file="../../dev/dist/CommonPaging_Admin.asp"-->
      <%
        End If
      %>
</section>
<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>