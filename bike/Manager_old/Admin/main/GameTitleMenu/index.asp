<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"--> 
  <!-- #include file="../../classes/JSON_2.0.4.asp" --> 
  <!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" --> 
  <!-- #include file="../../classes/json2.asp" --> 
  
  <script language="Javascript" runat="server">

function hasown(obj,  prop){
  if (obj.hasOwnProperty(prop) == true){
    return "ok";
  }
  else{
    return "notok";
  }
}

</script>


<%
  iLoginID = fInject(crypt.DecryptStringENC(Request.cookies(global_HP)("UserID")))
%>

<%
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
  NowPage = fInject(Request("i2"))  ' 현재페이지

  PagePerData = 15 
  BlockPage = 15 

  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

  iGameNationType = fInject(crypt.DecryptStringENC(Request("iGameNationType")))
  iSido = fInject(crypt.DecryptStringENC(Request("iSido")))

  crypt_iSido = crypt.EncryptStringENC(iSido)
  crypt_iGameNationType = crypt.EncryptStringENC(iGameNationType)

  


   If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어


%>
    <script type="text/javascript" src="../../js/GameTitleMenu/index.js"></script> 
    <script type="text/javascript">
  var locationStr = "";

  var searchObj =  searchObj || {};
  searchObj.tGameNationType = "<%=crypt_iGameNationType%>";
  searchObj.tSido = "<%=crypt_iSido%>";
  searchObj.tSearchText = "<%=iSearchText%>";
  searchObj.NowPage = "<%=NowPage%>"

  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./index.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./index.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
    post_to_url('./index.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iGameNationType' : searchObj.tGameNationType ,'iSido' : searchObj.tSido});
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./index.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

</script>
    <%
  

  ' 전체 가져오기
  iType = "2"                      ' 1:조회, 2:총갯수

  LSQL = "EXEC tblGameTitle_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','"  & iNationType & "','"  & iSido & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
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
    
    <!-- S: content -->
    <div id="content" class="gameTitle index"> 
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>대회</h2>
        
        <!-- S: 네비게이션 -->
        <div  class="navigation_box"> <span class="ic_deco"> <i class="fas fa-angle-right fa-border"></i> </span>
          <ul>
            <li>대회정보</li>
            <li>대회운영</li>
            <li><a href="./index.asp">대회</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 --> 
        
      </div>
      <!-- E: page_title --> 
      
      <!-- s: 등록하기 접기/펼치기 -->
      <div class="registration_box fold_box" id="formGameTitle">
        <table cellspacing="0" cellpadding="0">
          <tr>
            <th> <span class="l_con"></span>대회구분 </th>
            <td><select id="SelNationType">
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
              </select></td>
            <th> <span class="l_con"></span>대회명 </th>
            <td><input type="text" id="txtGameTitleName" placeholder="대회명을 입력해주세요." value=""></td>
            <th> <span class="l_con"></span>대회장소 </th>
            <td><input type="text" id="txtGamePlace" placeholder="대회장소를 입력해주세요." value=""></td>
          </tr>
          <tr>
            <th> <span class="l_con"></span>대회시작일 </th>
            <td><span id="sel_GameSYear">
              <input type="text" id="GameS" value="" class="date_ipt">
              </span></td>
            <th> <span class="l_con"></span>대회종료일 </th>
            <td><span id="sel_GameEYear">
              <input type="text" id="GameE" value="" class="date_ipt">
              </span></td>
            <th> <span class="l_con"></span>주최 </th>
            <td><div class="ymd-list"> <span id="sel_GameTitleHost">
                <input type="text" id="txtGameTitleHost" value=""  >
                </span> </div></td>
          </tr>
          <tr>
            <th> <span class="l_con"></span>접수시작일 </th>
            <td><span>
              <input type="text" id="GameRcvS" value="" class="date_ipt">
              </span></td>
            <th> <span class="l_con"></span>접수종료일 </th>
            <td><span>
              <input type="text" id="GameRcvE" value="" class="date_ipt">
              </span></td>
            <th> <span class="l_con"></span>선수구분 </th>
            <td><select id="selEntertype" style="width:70%;" onchange="selEntertypeChanged(this)">
                <option value="E" >엘리트</option>
                <option value="A" >생활체육</option>
                <option value="M" >엘리트+생활체육</option>  
              </select></td>
          </tr>
          <tr>
            <th> <span class="l_con"></span>지역 </th>
            <td><select id="SelGameTitleLocation" style="width:150px;">
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
              </select></td>
            <th> <span class="l_con"></span>대회 노출 </th>
            <td><select id="selViewYN">
                <option value="N">미노출</option>
                <option value="Y">노출</option>
              </select></td>
            <th> <span class="l_con"></span>참가신청 노출 </th>
            <td><select id="selEntryViewYN">
                <option value="N">미노출</option>
                <option value="Y">노출</option>
              </select></td>
          </tr>
          <tr>
              <th>
                <span class="l_con"></span>(구)Site Key
              </th>
              <td>
                <input type="text" id="txtGameTitleOldIDX" name="txtGameTitleOldIDX" value="">
              </td>
          </tr>
          <tr>
              <th id="GameSet_Name" >
                <span class="l_con"></span>엘리트경기 세팅
              </th>
              <td id="GameSet">
                최대P:
                <input type="text" id="schMaxPoint" name="schMaxPoint" style="width:30px;"  value="" length="2">
                랠리P:
                <input type="text" id="schRallyPoint" name="schRallyPoint" style="width:30px;"  value="" length="2">
                듀스여부:
                <select id="schDeuceYN" name="schDeuceYN" style="width:60px;">
                  <option value="Y">사용</option>
                  <option value="N">미사용</option>
                </select>
              </td>
              <th id="GameSet_Name_Ama" style="display:none">
                <span class="l_con"></span>생/체경기 세팅
              </th>
              <td id="GameSet_Ama" style="display:none">
                최대P:
                <input type="text" id="schMaxPoint_Ama" name="schMaxPoint_Ama" style="width:30px;" value="" length="2">
                랠리P:
                <input type="text" id="schRallyPoint_Ama" name="schRallyPoint_Ama" style="width:30px;" value="" length="2">
                듀스여부:
                <select id="schDeuceYN_Ama" name="schDeuceYN_Ama" style="width:60px;">
                  <option value="Y">사용</option>
                  <option value="N">미사용</option>
                </select>                
              </td>
              <th>
              </th>
              <td>
              </td>                            
          </tr>          
        </table>
        <div class="table_btn btn-center-list"> <a href="#" class="btn btn-gray" onclick="updateGameTitle_frm('<%=NowPage%>');">수정</a> <a href="#" class="btn btn-red" onclick="delGameTitle_frm(<%=NowPage%>);">삭제</a> </div>
      </div>
      <!-- S: registration_btn -->
      <div class="registration_btn"> 
        <!--<a href="/Main/GameTitleMenu/GameTitleDtl_write.asp" class="btn btn-add">추가정보 등록</a>--> 
        <!--<a href="/Main/GameTitleMenu/GameTitleMenu_write.asp" class="btn btn-add">등록하기</a> --> 
        <a href='javascript:inputGameTitle_frm(<%=NowPage%>);' class="btn btn-add">등록하기</a> <a href="#" class="btn btn-open">펼치기 <span class="ic_deco"> <i class="fas fa-caret-down"></i> </span> </a> <a href="#" class="btn btn-fold">접기<span class="ic_deco"><i class="fas fa-caret-up"></i></span></a> </div>
      <!-- E: registration_btn --> 
      <script>
        $(document).ready (function(){
          var $registration_box = $(".registration_box");
          var $open_btn = $(".btn-open");
          var $esc_btn = $(".btn-fold");
          $open_btn.click(function(){
            $registration_box.css('display','block');
            $open_btn.css('display','none');
            $esc_btn.css('display','inline-block');
          });
          $esc_btn.click(function(){
            $esc_btn.css('display','none');
            $registration_box.css('display','none');
            $open_btn.css('display','inline-block');
          });

        });
      </script> 
      <!-- e: 등록하기 접기/펼치기 --> 
      <!-- s: 서브 검색 -->
      <div class="sub_search clearfix">
        <div class="l_con">
          <ul class="clearfix">
            <li> <span class="l_txt">대회구분</span>
              <select id="schSelGameNationType" name="schSelGameNationType">
                <option>전체</option>
                <% If IsArray(arrayGameTitleType) Then
                    For ar = LBound(arrayGameTitleType, 2) To UBound(arrayGameTitleType, 2) 
                      GameTitleTypeCode   = arrayGameTitleType(0, ar) 
                      crypt_GameTitleTypeCode =  crypt.EncryptStringENC(GameTitleTypeCode)
                      GameTitleTypeName = arrayGameTitleType(1, ar) 

                      IF(crypt_iGameNationType = crypt_GameTitleTypeCode) Then
                    %>
                <option value="<%=crypt_GameTitleTypeCode%>" selected><%=GameTitleTypeName%></option>
                <%ELSE%>
                <option value="<%=crypt_GameTitleTypeCode%>" ><%=GameTitleTypeName%></option>
                <% END IF%>
                <%
                    Next
                  End If      
                %>
              </select>
            </li>
            <li> <span class="l_txt">지역</span>
              <select name="schSelSido" id="schSelSido">
                <option value="">전체</option>
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

                          IF crypt_rSido =  crypt_iSido Then
                          %>
                <option value="<%=crypt_rSido%>" selected><%=rSidoNm%></option>
                <%Else%>
                <option value="<%=crypt_rSido%>"><%=rSidoNm%></option>
                <%End IF%>
                <%
                        LRs.MoveNext
                      Loop
                    End If
                    LRs.close
                %>
              </select>
            </li>
            <li> <span class="l_txt">대회명</span>
              <input type="text" id="schtxtGameTitleName" class="ipt-word" placeholder="대회명을 입력해주세요." value="<%=iSearchText%>">
            </li>
          </ul>
        </div>
        <div class="r_search_btn">
          <%
            Call oJSONoutput.Set("NowPage", NowPage )
            Call oJSONoutput.Set("PagePerData", PagePerData )
            Call oJSONoutput.Set("BlockPage", BlockPage )
            Call oJSONoutput.Set("iSearchCol", iSearchCol )
            Call oJSONoutput.Set("iSearchText", iSearchText )

            strjson = JSON.stringify(oJSONoutput)  
        %>
          <a class="btn btn-search" href='javascript:searchGameTitle(<%=strjson%>, "true");'>검색</a> </div>
      </div>
      <!-- e: 서브 검색 -->
      <div id="schDivResult">
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
              <th>추가정보</th>
              <th>심판</th>
              <th>종별</th>
            </tr>
          </thead>
          <tbody id="contest">
            <%
              iType = 1
              LSQL = "EXEC tblGameTitle_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','"  & iNationType & "','"  & iSido & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"

              'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
			   
              'LSQL = LSQL & " FROM  tblGameTitle a "
              'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
              'LSQL = LSQL & " WHERE a.DELYN = 'N' "
              'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
              'response.End
              
              Set LRs = DBCon.Execute(LSQL)
              If Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                    LCnt = LCnt + 1
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
                    AddInfoCount = LRS("AddInfoCount")
			 		RefereeInfoCount = LRS("RefereeInfoCount")
                    %>
            <tr> 
              <!-- 번호-->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%=RGameTitleIDX%></td>
              <!-- 날짜 -->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%if RGameS = "" and RGameE = ""  Then %>
                <%Response.Write  "-"%>
                <%else%>
                <%=RGameS%> ~ <%=RGameE%>
                <%end if%></td>
              <!-- 대회구분 -->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%=RGameGbNm%></td>
              <!-- 대회 이름-->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer" class="name"><%=RGameTitleName%></td>
              
              <!-- 단체전-->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%=REnterType%></td>
              
              <!-- 주관 -->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%
                                if(cdbl(Len(rGameTitleHost)) > 10) Then
                                  response.write LEFT(rGameTitleHost, 10) & "..."
                                else
                                  response.write rGameTitleHost
                                end if
                            %></td>
              <!-- 지역-->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%=RSidoNm%></td>
              <!-- 단체전-->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%=RViewYN%></td>
              <td><%  IF CDBL(RLevelCount) = CDBL(0) Then %>
                <a href="javascript:href_level('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-blue">종별등록 </a>
                <%ELSE%>
                <a href="javascript:href_level('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-blue-empty" >종별관리<span class="txt">(<%=RLevelCount%>)</span></a>
                <%END IF%></td>
              <td><%  IF CDBL(RStadiumCount) = CDBL(0) Then %>
                <a href="javascript:href_stadium('<%=crypt_RGameTitleIDX%>');" class="btn list-btn btn-red" >장소등록</a>
                <%ELSE%>
                <a href="javascript:href_stadium('<%=crypt_RGameTitleIDX%>');" class="btn list-btn btn-red-empty" >장소관리<span class="txt">(<%=RStadiumCount%>)</span></a>
                <%END IF%></td>
              <td title="대회요강, 연습일정표, 숙박/주변관광 정보를 등록관리합니다."><%  IF CDBL(AddInfoCount) = CDBL(0) Then %>
                <a href="javascript:href_addinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-red" >등록</a>
                <%ELSE%>
                <a href="javascript:href_addinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-red-empty" >수정</a>
                <%END IF%></td>
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%  IF CDBL(RefereeInfoCount) = CDBL(0) Then %>
                <a href="javascript:href_refereeinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>', 'WRITE');" class="btn list-btn btn-red" >등록</a>
                <%ELSE%>
                <a href="javascript:href_refereeinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>', 'MOD');" class="btn list-btn btn-red-empty" >수정</a>
                <%END IF%></td>
              <!-- 종목 리스트-->
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%=RlevelGrooupNm%></td>
            </tr>
            <%
                  LRs.MoveNext
                Loop
              End If
              LRs.close
            %>
          </tbody>
        </table>
      
      <%
        if cdbl(iTotalCount) > 0 then
        %>
      <!-- S: page_index -->
      <div class="page_index"> 
        <!--#include file="../../dev/dist/CommonPaging_Admin.asp"--> 
      </div>
      <!-- E: page_index -->
      <%
          End If
        %>
      </div>
    </div>
  </div>
  <!-- E: content --> 
</div>
<!-- E: main --> 

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>