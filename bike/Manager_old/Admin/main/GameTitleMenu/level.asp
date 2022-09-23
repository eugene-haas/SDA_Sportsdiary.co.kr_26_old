<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
  tIDX = fInject(crypt.DecryptStringENC(Request("tIDX")))
  crypt_tIDX = crypt.EncryptStringENC(tIDX)
  '잘못된 경로로 이동한 경우
  if tIDX = "" then
    Response.Write "<script>alert('잘못된 경로로 이동하셨습니다.')</script>"
    Response.Write "<script>location.href='./index.asp'</script>"
    Response.End
  End if

  if cdbl(tIDX) = 0  then
    Response.Write "<script>alert('잘못된 경로로 이동하셨습니다.a')</script>"
    Response.Write "<script>location.href='./index.asp'</script>"
    Response.End
  end if

%>
<script type="text/javascript" src="../../js/GameTitleMenu/level.js"></script>

<script type="text/javascript">
  /**
   * left-menu 체크
   */
  var locationStr = "GameTitleMenu/index"; // 대회
  /* left-menu 체크 */


  var selSearchValue = "<%=iSearchCol%>";
  var txtSearchValue = "<%=iSearchText%>";

  function WriteLink(i2) {
    post_to_url('./level.asp', { 'i2': i2, 'iType': '1' });
  }

  function ReadLink(i1, i2) {
    post_to_url('./level.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
  }

  function PagingLink(i2) {
   
    post_to_url('./level.asp', { 'i2': i2,'tIDX' : '<%=crypt_tIDX%>','iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

  function fn_selSearch() {
    selSearchValue = document.getElementById('selSearch').value;
    txtSearchValue = document.getElementById('txtSearch').value;
    post_to_url('./level.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  }

</script>

<%

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = 30  ' 한화면에 출력할 갯수
  BlockPage = 5      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0
  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))


   If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  LSQL = "SELECT GameTitleIDX ,GameTitleName,GameS,GameE ,EnterType,PersonalPayment, GroupPayment"
  LSQL = LSQL & " FROM  tblGameTitle"
  LSQL = LSQL & " WHERE GameTitleIDX = " &  tIDX
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

  ' 전체 가져오기
  iType = "2"                      ' 1:조회, 2:총갯수
  LSQL = "EXEC tblGameLevel_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & tIDX & "','" & tGameTitleEnterType & "','" & iLoginID & "'"
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

  if(cdbl(iTotalPage) < cdbl(NowPage)) then
    NowPage  = iTotalPage
  end if
 

%>

<%
  '경기타입 (단식,복식,혼합복식)
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B002'"
  LSQL = LSQL & " ORDER BY OrderBy desc"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameType = LRs.getrows()
  End If
    
  'RESPONSE.WRITE LSQL & "<BR>"

  '구분 (개인전,단체전)
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B003'"
  LSQL = LSQL & " ORDER BY OrderBy "
  'RESPONSE.WRITE "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL "& LSQL&  "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrDivision = LRs.getrows()
  End If
  'RESPONSE.WRITE LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL & "<BR>"

  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='Sex'"
  LSQL = LSQL & " ORDER BY OrderBy desc"
  'RESPONSE.WRITE "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL "& LSQL&  "<BR>"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrSex = LRs.getrows()
  End If

  LSQL = "SELECT TeamGb ,TeamGbNm  "
  LSQL = LSQL & "FROM  tblTeamGbInfo "
  LSQL = LSQL & "Where EnterType = '" & tEnterType & "' And DelYN = 'N'"
  LSQL = LSQL & "ORDER BY Orderby DESC"
  
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrTeamGb = LRs.getrows()
  End If

  
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "

  if tEnterType = "E" Then
  LSQL = LSQL & " WHERE DelYN = 'N' and PubCode ='B0120007'"
  ELSE
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B011'"
  END IF
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayJoo = LRs.getrows()
  End If

  LSQL = "SELECT StadiumIDX, StadiumName, StadiumCourt   "
  LSQL = LSQL & "FROM  tblStadium " 
  LSQL = LSQL & "Where GameTitleIDX = '" & tIdx & "' And DelYN = 'N'"
  LSQL = LSQL & "ORDER BY WriteDate  DESC"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayStadiums = LRs.getrows()
  End If
  Call oJSONoutput.Set("NowPage", NowPage )
  Call oJSONoutput.Set("tIdx", crypt_tIDX )
  Call oJSONoutput.Set("tEnterType", tEnterType )
  Call oJSONoutput.Set("tGameTitleName", tGameTitleName )
  strjson = JSON.stringify(oJSONoutput)  
%>

  <!-- 넘어온 셋팅 값-->
  <input type="hidden" id="selGameTitleIdx" value="<%=crypt_tIDX%>">
  <input type="hidden" id="selGameTitleEnterType" value="<%=tEnterType%>">
  <input type="hidden" id="selGameTitleName" value="<%=tGameTitleName%>">

  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-body" id="myModelContent">
          <p>데이터가 없습니다.</p>
        </div>
      </div>
    </div>
  </div>

   <!-- Modal -->
  <div class="modal fade" id="levelDtlModal" role="dialog" style="z-index:1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-body" style="z-index:10;" >
          <div id="mylevelDtlModalContent">
            <p>데이터가 없습니다.</p>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- S: content gameTitle level -->
  <div id="content" class="gameTitle level">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>대회 종별 등록</h2>
      <a href="./index.asp" class="btn btn-back">뒤로가기</a>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>대회정보</li>
          <li>대회운영</li>
          <li><a href="./index.asp">대회</a></li>
          <li><a href="./level.asp">대회 종별 등록</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->

    </div>
    <!-- E: page_title -->

    <!-- S : 내용 시작 -->
    <div class="contents">
      <strong id="Depth_GameTitle"><%=tGameTitleName%></strong>
      <div class="tp-table-wrap">
            <!-- S: registration_box, gamelevelinput_area -->
            <div id="gamelevelinput_area" class="registration_box"> 
              <table  class="navi-tp-table">
                <caption class="sr-only">대회 종별 생성</caption>
                <tbody>
                    <tr>
                      <th><span class="l_con"></span>대회구분</th>
                        <td>
                          <select id="selEntertype" onchange='OnEnterTypeChanged(<%=strjson%>)'>
                            <option value="A">아마추어</option>
                            <option value="E">엘리트</option>
                          </select>
                        </td>
                        <th><span class="l_con"></span>성별</th>
                        <td>
                          <select id="selSex">
                            <% 
                                If IsArray(arrSex) Then
                                For ar = LBound(arrSex, 2) To UBound(arrSex, 2) 
                                  SexCode   = arrSex(0, ar) 
                                  crypt_SexCode = crypt.EncryptStringENC(SexCode)
                                  SexName = arrSex(1, ar) 
                            %>
                                  <option value="<%=crypt_SexCode%>"><%=SexName%></option>
                            <%
                                Next
                              End If      
                            %>
                          </select> 
                        </td>

                        
                    <th><span class="l_con"></span>경기날짜</th>
                    <td>
                      <input type="text" id="GameS" value="" class="date_ipt">
                    </td>

                  
                    </tr>

                    <tr>

                          <th><span class="l_con"></span>종목</th>
                    <td>
                      <select id="selTeamGB" onchange="onTeamGBChanged(this.value)">
                        <% 
                        gameTeamGBCnt = 0
                          If IsArray(arrTeamGb) Then
                            For ar = LBound(arrTeamGb, 2) To UBound(arrTeamGb, 2) 
                              gameTeamGBCnt = gameTeamGBCnt + 1
                              gameTeamGBCode    = arrTeamGb(0, ar) 
                              crypt_gameTeamGBCode = crypt.EncryptStringENC(gameTeamGBCode)
                              gameTeamGBName  = arrTeamGb(1, ar) 

                              if(Cdbl(gameTeamGBCnt) = 1) Then
                                selGameTeamGBCode = gameTeamGBCode
                                selGameTeamGBName = gameTeamGBName
                              end if
                        %>
                              <option value="<%=crypt_gameTeamGBCode%>"><%=gameTeamGBName%></option>
                        <%
                            Next
                          End If      
                        %>
                      </select> 
                    </td>

                    <%
                        LSQL = "SELECT Level,LevelNm,LevelDtl   "
                        LSQL = LSQL & " FROM  tblLevelInfo  "
                        LSQL = LSQL & " where TeamGb =  '" & selGameTeamGBCode & "'"
                        LSQL = LSQL & " ORDER BY Orderby "
                        'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL

                        Set LRs = DBCon.Execute(LSQL)
                        IF NOT (LRs.Eof Or LRs.Bof) Then
                          arrLevelInfo = LRs.getrows()
                        End If
                    %>
                    
                    <th ><span class="l_con"></span>종목레벨</th>
                    <td id="divTeamGbLevel">
                      <select id="selTeamGBLevel" >
                        <option value="" >미선택</option>
                        <% If IsArray(arrLevelInfo) Then
                            For ar = LBound(arrLevelInfo, 2) To UBound(arrLevelInfo, 2) 
                              levelInfoCode   = arrLevelInfo(0, ar) 
                              crypt_levelInfoCode = crypt.EncryptStringENC(levelInfoCode)
                              levelInfoName = arrLevelInfo(1, ar) 
                              levelInfoDtl  = arrLevelInfo(2, ar) 
                        %>
                              <option value="<%=crypt_levelInfoCode%>"><%=levelInfoName%></option>
                        <%
                            Next
                          End If      
                        %>
                      </select> 
                    </td>

                    <th><span class="l_con"></span>경기장</th> 
                    <td>
                      <select id="selStadiums" name="selStadiums">
                      <option value="0">==선택==</option>
                      <%
                        If IsArray(arrayStadiums) Then
                          For ar = LBound(arrayStadiums, 2) To UBound(arrayStadiums, 2) 
                            arrayStadiumCode    = arrayStadiums(0, ar) 
                            crypt_arrayStadiumCode = crypt.EncryptStringENC(arrayStadiumCode)
                            arrayStadiumName  = arrayStadiums(1, ar) 
                            arrayCourts = arrayStadiums(2, ar) 
                      %>
                        <option value="<%=crypt_arrayStadiumCode%>"><%=arrayStadiumName%> 코트 : <%=arrayCourts%></option>
                      <%
                        Next
                        End If    
                      %>
                      </select> 
                    </td>
                  </tr>
                  <tr>
                    <th>
                      <span class="l_con"></span>경기구분
                    </th>
                    <td>
                      <select id="selGroupGameGb"  onchange="OnGroupGameGbChanged(this.value)">
                        <% If IsArray(arrDivision) Then
                            For ar = LBound(arrDivision, 2) To UBound(arrDivision, 2) 
                              gameDivisionCode    = arrDivision(0, ar) 
                              crypt_gameDivisionCode = crypt.EncryptStringENC(gameDivisionCode)
                              gameDivisionName  = arrDivision(1, ar) 
                        %>
                              <option value="<%=crypt_gameDivisionCode%>"><%=gameDivisionName%></option>
                        <%
                            Next
                          End If      
                        %>
                      </select> 
                    </td>

                      
                    <th id="thGroupGameGb"><span class="l_con"></span>경기타입<label for="competition-name"></label></th>
                    <td id="tdGroupGameGb" >
                      <select id="selPlayType">
                        <% If IsArray(arrayGameType) Then
                            For ar = LBound(arrayGameType, 2) To UBound(arrayGameType, 2) 
                              gameTypeCode    = arrayGameType(0, ar) 
                              crypt_gameTypeCode = crypt.EncryptStringENC(gameTypeCode)
                              gameTypeName  = arrayGameType(1, ar) 
                        %>
                              <option value="<%=crypt_gameTypeCode%>"><%=gameTypeName%></option>
                        <%
                            Next
                          End If      
                        %>
                      </select>
                    </td>

                    <th><span class="l_con"></span>금액</th> 
                    <td>
                      <div>
                        <input type="text" id="txtPayment" value="0" >
                      </div>
                    </td>

                  </tr>

                  <tr>
                    <th><span class="l_con"></span>조</th>
                    <td id="sel_selLevelJoo">
                        <select id="selLevelJoo">
                          <% If IsArray(arrayJoo) Then
                              For ar = LBound(arrayJoo, 2) To UBound(arrayJoo, 2) 
                                arrayLevelJooCode   = arrayJoo(0, ar) 
                                crypt_arrayLevelJooCode = crypt.EncryptStringENC(arrayLevelJooCode)
                                arrayLevelJooName = arrayJoo(1, ar) 
                                if arrayLevelJooName = "" Then arrayLevelJooName ="미선택" End if
                          %>
                                
                                <option value="<%=crypt_arrayLevelJooCode%>"><%=arrayLevelJooName%></option>
                          <%
                              Next
                            End If      
                          %>
                        </select> 
                    </td>

                      <th><span class="l_con"></span>조 번호 </th>
                      <td id="sel_LevelJooNum">
                        <select id="selLevelJooNum">
                          <option value="" >미선택</option>
                          <% For i = 1 To 5 %>
                              <option value="<%=i%>"><%=i%></option>
                          <%
                            Next
                          %>
                        </select> 
                      </td>
                    <!--
                    <th><span class="l_con"></span>노출여부</th>
                    <td>
                      <select id="selViewYN">
                        <option value="Y">노출</option>
                        <option value="N" Selected>미노출</option>
                      </select> 
                    </td>
                    -->
                  </tr>
                  <tr>
                    
                    
                  </tr>
                </tbody>
              </table>

              <!-- S: table_btn btn-right-list -->
              <div class="table_btn btn-center-list">
                  <a href="#" id="btnsave" class="btn" onclick="inputGameLevel_frm(<%=NowPage%>);" accesskey="i">등록(I)</a>
                  <a href="#" id="btnupdate" class="btn btn-gray" onclick="updateGameLevel_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
                  <a href="#" id="btndel" class="btn btn-red" onclick="delGameLevel_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
              </div>

              <input type="hidden" id="selGameLevelIdx" value="">
              <!-- E: table_btn btn-right-list -->
            </div>
            <!-- E: registration_box, gamelevelinput_area -->

          <!-- S: registration_btn -->
          <div class="registration_btn">
            <a href="#" class="btn btn-add">등록하기</a>
            <a href="javascript:href_back(1);" class="btn btn-gray">목록보기</a>
            <a href="#" class="btn btn-open">펼치기 <span class="ic_deco"><i class="fas fa-caret-down"></i></span></a>
            <a href="#" class="btn btn-fold">접기<span class="ic_deco"><i class="fas fa-caret-up"></i></span></a>
          </div>
          <!-- E: registration_btn -->
          
        </div>
        <!-- E: tp-table-wrap -->

      
      <div class="sub_search">
  
        <div class="l_con">
         <ul>
         
            <li>
              <span class="l_txt">대회구분</span>

                <label for="radio0" class="radio_btn1">
                <input type="radio" id="radio0" name="radioLevelBtn" value=""  >
                 <span>전체</span> 
                </label>

                <%
                  Dim LoopTypeSexCnt : LoopTypeSexCnt = 0 
                  If IsArray(arrayGameType) Then
                    For ar = LBound(arrayGameType, 2) To UBound(arrayGameType, 2) 
                      gameTypeCode    = arrayGameType(0, ar) 
                      crypt_gameTypeCode = crypt.EncryptStringENC(gameTypeCode)
                      gameTypeName  = Left(arrayGameType(1, ar) ,1)
                      
                      If IsArray(arrSex) Then
                        For ar2 = LBound(arrSex, 2) To UBound(arrSex, 2) 
                          LoopTypeSexCnt = LoopTypeSexCnt + 1
                          SexCode   = arrSex(0, ar2) 
                          crypt_SexCode = crypt.EncryptStringENC(SexCode)
                          SexName = Left(arrSex(1, ar2),1)

                          IF(gameTypeCode = "B0020001" and SexCode = "Mix") Then IsContinue = True
                          
                          IF IsContinue = False Then
                          %>
                             <label for="radio1_<%=LoopTypeSexCnt%>" class="radio_btn1">
                                <input type="radio" id="radio1_<%=LoopTypeSexCnt%>" name="radioLevelBtn" value="" >
                                <span><%=SexName%><%=gameTypeName%></span> 
                              </label>
                          <%
                          End if
                          IsContinue = False
                        Next
                      End If  
                    Next
                  End IF                  
                %>
            </li>
          </ul>

          <ul>
           
            <li>
              <span class="l_txt">대회목록</span>
                <label for="radio0" class="radio_btn">
                <input type="radio" id="radio0" name="radioBtn" value=""  >
                 <span>전체</span> 
                </label>
               <% If IsArray(arrayJoo) Then
                    For ar = LBound(arrayJoo, 2) To UBound(arrayJoo, 2) 
                     JooCnt = JooCnt + 1 
                      arrayLevelJooCode   = arrayJoo(0, ar) 
                      crypt_arrayLevelJooCode = crypt.EncryptStringENC(arrayLevelJooCode)
                      arrayLevelJooName = arrayJoo(1, ar) 
                      IF("B0110007" <> arrayLevelJooCode) Then
                %>
                      <label for="radio<%=JooCnt%>" class="radio_btn">
                        <input type="radio" id="radio<%=JooCnt%>" name="radioBtn" value="<%=crypt_arrayLevelJooCode%>" >
                        <span><%=arrayLevelJooName%></span> 
                      </label>
                <%
                    End IF
                    Next
                  End If      
                %>
               
              
            </li>
          </ul>
        </div>
        <div class="r_search_btn">
          <a href="#" class="btn btn-search">검색</a>
        </div>
      </div>
      <div class="play-order btn-list-right">
        <a href="#" id="btnsave" class="btn btn-red" onclick="href_GameNumber('<%=crypt_tIDX%>');" accesskey="i">경기진행순서 설정</a>
      </div>
      
      

      <!-- S: total_count -->
      <div class="total_count">
        <span>전체 : <%=iTotalCount%>,</span>&nbsp;&nbsp;&nbsp;<span><%=NowPage%> page / <%=iTotalPage%> pages</span>
      </div>
      <!-- E: total_count -->
        <table class="table-list">
          <thead>
            <tr>
              <th>번호</th>
              <th>대회구분</th>
              <th>경기구분</th>
              <th>종목</th> 
              <th>대진표</th> 
              <th>대회신청정보</th>
              <th>신청 인원</th> 
              <th>종목 조 나누기</th>
              <th>경기 날짜</th>
              <th>노출 여부</th>
            </tr>
          </thead>
          <colgroup>
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
            <col width="100px">
            <col width="80px">
            <col width="80px">
            <col width="80px">
          </colgroup>
          <tbody id="levelContest">
            <%
                If(cdbl(tIdx) > 0) Then
                iType = 1
                LSQL = "EXEC tblGameLevel_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & tIDX & "','" & tGameTitleEnterType & "','" & iLoginID & "'"
                'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
                'LSQL = LSQL & " FROM  tblGameTitle a "
                'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
                'LSQL = LSQL & " WHERE a.DELYN = 'N' "
                'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
                Set LRs = DBCon.Execute(LSQL)
                If Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                      LCnt = LCnt + 1
                      tGameLevelidx = LRS("GameLevelidx")
                      crypt_tGameLevelidx =crypt.EncryptStringENC(tGameLevelidx)
                      tPlayType = LRS("PlayTypeNm")
                      tGameType = LRS("GameTypeNm")
                      tTeamGb = LRS("TeamGbNm")
                      tLevel = LRS("LevelNm")
                      tLevelDtl = LRS("LevelDtl")
                      tSex = LRS("SexNm")
                      tEnterType = LRS("EnterType")
                      tEnterTypeNm = LRS("EnterTypeNm")
                      tPGameMatchCnt= LRS("PGameMatchCnt")
                      tGroupGameGbNm = LRS("GroupGameGbNm")
                      tGroupGameGb = LRS("GroupGameGb")
                      tGameDay = LRS("GameDay")
                      tPGameLevelidx = LRS("PGameLevelidx")
                      tGameTime = LRS("GameTime")
                      tOrderbyNum = LRS("OrderbyNum")
                      tLevelJooNum = LRS("LevelJooNum")
                      tLevelJooNumNm = LRS("LevelJooNumNm")
                      tLevelJooName = LRS("LevelJooName")
                      tLevelJooNameNm = LRS("LevelJooNameNm")
                      tJooDivision = LRS("JooDivision")
                      tSeedCnt = LRS("SeedCnt")
                      tJooRank = LRS("JooRank")
                      tDelYN = LRS("DelYN")
                      tEditDate = LRS("EditDate")
                      tUseYN = LRS("UseYN")
                      tWriteDate = LRS("WriteDate")
                      tGameLevelDtlCount = LRS("GameLevelDtlCount")
                      tRequestPlayerCnt = LRS("RequestPlayerCnt")
                      tRequestGroupCnt = LRS("RequestGroupCnt")
                      tRequestTeamCnt = LRS("RequestTeamCnt")
                      tViewYN = LRS("ViewYN")
                      Call oJSONoutput.Set("tIdx", crypt_tIDX )
                      Call oJSONoutput.Set("tGameLevelIdx", crypt_tGameLevelidx )
                      Call oJSONoutput.Set("NowPage", NowPage )
                      Call oJSONoutput.Set("iSearchText", iSearchText )
                      Call oJSONoutput.Set("iSearchCol", iSearchCol )
                      strjson = JSON.stringify(oJSONoutput)  


                      %>
                     <tr>
                        <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                            <%=tGameLevelidx%>
                        </td>
                        <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                          <%=tEnterTypeNm%>
                        </td>
                        <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                            <%=tTeamGb%>&nbsp;<%=tGroupGameGbNm%>
                        </td>
                        <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                          <% IF tEnterType = "E" Then %>
                          <%=tSex%><%=tTeamGb%><% if tGroupGameGb <> "B0030002" Then %>&nbsp;<%=tPlayType%><% end if%>
                                <% IF tGroupGameGb <> "B0030002" Then %>
                                  (<%=tLevel%>)
                                  <%Else%>
                                  <%IF tTeamGb = tLevel Then%>
                                    (<%=tGroupGameGbNm%>)
                                  <%Else%>&nbsp;<%=tLevel%> (<%=tGroupGameGbNm%>)
                                  <% End if %>
                                <% End IF %>
                          <% End IF  %>

                          <% IF tEnterType = "A" Then %>
                              <% IF tGroupGameGb <> "B0030002" Then %>
                                <%=LEFT(tSex, 1) %> <%=LEFT(tPlayType, 1)%>-<%=tLevel%>
                              <% ELSE %>
                                <%=tSex%>
                                <% IF tLevel <> "" Then %>
                                  -<%=tLevel%>
                                <%END IF%>
                                  
                              <%END IF%>
                            <% IF tLevelJooName <> "B0110007" and tLevelJooName <> "" Then %>-<%=tLevelJooNameNm%><%IF(tLevelJooNum <> "") Then%>-<%=tLevelJooNum %><%End If%>
                            <% End IF  %>
                          <% End IF  %>
                        </td>
                        
                        <%' 대진표%>
                        <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                        <%IF CDBL(tPGameMatchCnt) > 0 And tUseYN = "N" Then %>
                          <a href="javascript:href_PLevel('<%=crypt_tIDX%>','<%=crypt_tGameLevelidx%>','<%=NowPage%>');"  class="btn list-btn btn-blue-empty"> 조별 대진표 <%=tPGameMatchCnt%><i><img src="../images/icon_more_right.png" alt=""></i></a>
                        <%ELSE%>
                          <% IF CDBL(tGameLevelDtlCount) = 0 Then%>
                            <a href='javascript:href_LevelDtl(<%=strjson%>);'  class="btn list-btn btn-blue"> 대진표 등록<i><img src="../images/icon_more_right.png" alt=""></i></a>
                          <% ELSE %>
                            <a href='javascript:href_LevelDtl(<%=strjson%>);'  class="btn list-btn btn-blue-empty"> 대진표 <%=tGameLevelDtlCount%><i><img src="../images/icon_more_right.png" alt=""></i></a>
                          <%END IF%>
                        <%END IF%>
                        </td>

                        <%'대회 신청정보 %>
                        <td>
                          <% if(tGroupGameGb <> "B0030002") Then %>
                            <% if(cdbl(tRequestGroupCnt) > 0 ) Then %>
                              <a href='javascript:href_Participate(<%=strjson%>);'  class="btn list-btn btn-red-empty"> 대회 신청팀 <%=tRequestGroupCnt%> <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%Else%>  
                              <a href='javascript:href_Participate(<%=strjson%>);'  class="btn list-btn btn-red"> 대회 신청팀 <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%End If%>
                          <%Else%>
                            <% if(cdbl(tRequestTeamCnt) > 0 ) Then %>
                              <a href="javascript:href_ParticipateTeam('<%=crypt_tIDX%>','<%=crypt_tGameLevelidx%>');"  class=" btn list-btn btn-red-empty"> 대회 신청팀 <%=tRequestTeamCnt%> <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%Else%>  
                              <a href="javascript:href_ParticipateTeam('<%=crypt_tIDX%>','<%=crypt_tGameLevelidx%>');"  class="btn list-btn btn-red-empty"> 대회 신청팀 <i><img src="../images/icon_more_right.png" alt=""></i></a>
                            <%End If%>

                            
                          <%End If%>
                        </td>

                        <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                          <%=tRequestPlayerCnt%>명
                        </td>


                        <td style="cursor:pointer" class="divn-group" >
                          <% if cdbl(tPGameLevelidx) = 0 Then %>
                          <div id="divSeedCnt_<%=crypt_tGameLevelidx%>">
                            <label for="txtSeedCnt_<%=crypt_tGameLevelidx%>">시드개수</label>
                            <input class="ipt-value" type="text" id="txtSeedCnt_<%=crypt_tGameLevelidx%>" name="txtSeedCnt_<%=crypt_tGameLevelidx%>" value="<%=tSeedCnt%>">
                            <input type="Button" class="ipt-assign" id="btnLevelSeed" name="btnLevelSeed" value="적용" onclick="javascript:ApplyLevelSeed('<%=crypt_tGameLevelidx%>')">
                          </div>
                          <div id="divJooDivision_<%=crypt_tGameLevelidx%>">
                            <label for="txtJooDivision_<%=crypt_tGameLevelidx%>">조 분배</label>
                            <input class="ipt-value" type="text" id="txtJooDivision_<%=crypt_tGameLevelidx%>" name="txtJooDivision_<%=crypt_tGameLevelidx%>" value="<%=tJooDivision%>">
                            <input type="Button" class="ipt-assign" id="btnLeveJoolDivision" name="btnLeveJoolDivision" value="적용" onclick="javascript:ApplyLevelJooDIvision('<%=crypt_tGameLevelidx%>',<%=NowPage%>)">
                          </div>
                          <div id="divGoUpRank_<%=crypt_tGameLevelidx%>">
                            <label for="txtGoUpRank_<%=crypt_tGameLevelidx%>">본선 순위</label>
                            <input class="ipt-value" type="text" id="txtGoUpRank_<%=crypt_tGameLevelidx%>" name="txtGoUpRank_<%=crypt_tGameLevelidx%>"  value="<%=tJooRank%>">
                            <input type="Button" class="ipt-assign" id="btnLevelRank" name="btnLevelRank" value="적용" onclick="javascript:ApplyLevelRank('<%=crypt_tGameLevelidx%>')">
                          </div>
                          <% End If %>
                        </td>

                        <td  style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                          <%=tGameDay%>
                        </td>

                        <td  style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>','<%=NowPage%>')">
                          <%=tViewYN%>
                        </td>
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


          <%


          if cdbl(iTotalCount) > 0 then
          %>
          <!-- S: page_index -->
          <div class="page_index">
            <!--#include file="../../dev/dist/CommonPaging_Admin.asp"-->
          </div>
          <!-- E: page_index -->
          <%
          ELSE
          %>
          <div class="board-bullet Non-pagination" >
              데이터가 존재하지 않습니다.
          </div>
          <%
          End If
          %>

      <div>
    </div>
  </div>

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>