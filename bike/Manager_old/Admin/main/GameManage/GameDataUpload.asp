<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  '1. REQ
  REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)

  '2. JAVASCIPRT
%>
<style>
  input[type="file"] {
      display: none;
  }
  .custom-file-upload {
      border: 1px solid #ccc;
      display: inline-block;
      padding: 6px 12px;
      cursor: pointer;
  }

</style>

<script type="text/javascript" src="../../js/GameManage/GameDataUpload.js"></script>

<script type="text/javascript">
  /**
   * left-menu 체크
   */
  var bigCate = 2; // 대회정보
  var midCate = 0; // 대회운영
  var lowCate = 0; // 대회
  /* left-menu 체크 */
</script>

<%
  '1. 대회 정보 가져오기
  LSQL = " SELECT GameTitleIDX ,GameTitleName, GameS, GameE"
  LSQL = LSQL & " FROM  tblGameTitle "
  LSQL = LSQL & " WHERE DelYN = 'N' "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameTitles = LRs.getrows()
  End If


  

  
%>
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
      <h2>엑셀 선수 입력</h2>
      <!--<a href="./index.asp" class="btn btn-back">뒤로가기</a>-->

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>대회정보</li>
          <li>대회관리</li>
          <li><a href="./GameDataUpload.asp">데이터 업로드</a></li>
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
                <caption class="sr-only">참가자 입력</caption>
                <tbody>
                  <tr>
                    <th><span class="l_con"></span>대회</th>
                    <td>
                    <%
                      Dim GameTitleCnt : GameTitleCnt = 0
                      Dim SelGameTitleIdx : SelGameTitleIdx = 0
                      
                    %>
                      <select id="selGameTitle" name="selGameTitle">
                       <% If IsArray(arrayGameTitles) Then
                          For ar = LBound(arrayGameTitles, 2) To UBound(arrayGameTitles, 2) 
                            GameTitleCnt = GameTitleCnt + 1
                            GameTitleIDX   = arrayGameTitles(0, ar) 
                            crypt_GameTitleIDX = crypt.EncryptStringENC(GameTitleIDX)
                            GameTitleName= arrayGameTitles(1, ar) 

                            If cdbl(GameTitleCnt) = 1 Then
                              SelGameTitleIdx = GameTitleIDX
                            End IF
                            
                      %>
                            <option value="<%=crypt_GameTitleIDX%>"><%=GameTitleName%></option>
                      <%
                          Next
                        End If      
                      %>
                      </select>
                    </td>
                  </tr>

                
                  </tr>
                </tbody>
              </table>

              <!-- S: table_btn btn-right-list -->
              <!--
              <div class="table_btn btn-center-list">
                  <a href="#" id="btnsave" class="btn" onclick="inputGameLevel_frm(<%=NowPage%>);" accesskey="i">등록(I)</a>
                  <a href="#" id="btnupdate" class="btn btn-gray" onclick="updateGameLevel_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
                  <a href="#" id="btndel" class="btn btn-red" onclick="delGameLevel_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
              </div>
              -->
              <!-- E: table_btn btn-right-list -->
              
            </div>
            <!-- E: registration_box, gamelevelinput_area -->

          <!-- S: registration_btn -->
          <!--
          <div class="registration_btn">
            <a href="#" class="btn btn-add">등록하기</a>
            <a href="javascript:href_back(1);" class="btn btn-gray">목록보기</a>
            <a href="#" class="btn btn-open">펼치기 <span class="ic_deco"><i class="fas fa-caret-down"></i></span></a>
            <a href="#" class="btn btn-fold">접기<span class="ic_deco"><i class="fas fa-caret-up"></i></span></a>
          </div>
          -->
          <!-- E: registration_btn -->
          
        </div>
        <!-- E: tp-table-wrap -->

      

     
      <div class="play-order btn-list-left">
        <form id="form1" name="form1" action="/ajax/GameManage/GameDataUploadAjax.asp" method="post" ENCTYPE="multipart/form-data" style="width:500px">
        <label for="file-upload" class="custom-file-upload">
          <i class="fa fa-cloud-upload"></i>Upload
        </label>
        <input type="file" name="uploadfile"  id="file-upload"/>
        </form>
        <span id="fileName"></span>
        
      </div>
      <a href="#" id="btnsave" class="btn btn-blue" onclick="updateFile('PersonGame');" accesskey="i">개인전 업로드</a>
        <a href="#" id="btnsave" class="btn btn-blue" onclick="updateFile('GroupGame');" accesskey="i">단체전 업로드</a>
      <div class="play-order btn-list-right">
        <a class="btn btn-gray" href="http://badmintonadmin.sportsdiary.co.kr/xls/개인전 양식.xlsx" download>개인전 양식</a>
        <a class="btn btn-gray" href="http://badmintonadmin.sportsdiary.co.kr/xls/단체전 양식.xlsx" download>단체전 양식</a>
        
        
      </div>
     
        <table class="table-list">
          <thead>
            <tr>
              <th>번호</th>
              <th>파일명</th>
              <th>게임타입</th>
              <th>삭제</th>
            </tr>
          </thead>
          <colgroup>
            <col width="40px">
            <col width="80%">
            <col width="100px">
            <col width="100px">
          </colgroup>
          <tbody id="tbodyExcelFileList">
            <%
            
              PersonGameCode =crypt.EncryptStringENC("B0030001")
              GroupGameCode =crypt.EncryptStringENC("B0030002")

              Dim strPath : strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\PersonGame"
              Dim FSO, Folder, Files, FilePath,filecolor
              '1.FileObject 생성
              Set FSO = Server.CreateObject( "Scripting.FileSystemObject" )
              '2. FolderObject 생성
              Set Folder = FSO.GetFolder(strPath) 
              '3. Files 가져오기
              Set Files = Folder.Files

              For Each file In Files
                If CDate(File.dateCreated) > Date - 300  then 
                iTotalCount = iTotalCount + 1 
                %>
                <tr>
                  <td >
                    <%=iTotalCount%>
                  </td>
                  <td >
                    <a href="javascript:SelFileSheet('<%=File.Name%>','<%=PersonGameCode%>')" class="btn"><%=File.Name%></a>
                  </td>
                  <td>
                    개인전
                  </td>
                 
                  <td>
                    <a href="javascript:RemoveFile('<%=File.Name%>', '<%=PersonGameCode%>')" class="btn btn-red">파일삭제</a>
                  </td>
                </tr>

                <%
                End if
              Next
              Set Files = Nothing
              Set Folder = Nothing
              Set FSO = Nothing

              strPath = "D:\badminton.sportsdiary.co.kr\badmintonAdmin\FileDown\xls\GroupGame"
              '1.FileObject 생성
              Set FSO = Server.CreateObject( "Scripting.FileSystemObject" )
              '2. FolderObject 생성
              Set Folder = FSO.GetFolder(strPath) 
              '3. Files 가져오기
              Set Files = Folder.Files

              For Each file In Files
                If CDate(File.dateCreated) > Date - 300  then 
                iTotalCount = iTotalCount + 1 
                %>
                <tr>
                  <td >
                    <%=iTotalCount%>
                  </td>
                  <td >
                     <a href="javascript:SelFileSheet('<%=File.Name%>', '<%=GroupGameCode%>')" class="btn"><%=File.Name%></a>
                  </td>
                  <td>
                    단체전
                  </td>
              
                  <td>
                    <a href="javascript:RemoveFile('<%=File.Name%>', '<%=GroupGameCode%>')"class="btn btn-red">파일삭제</a>
                  </td>
                </tr>

                <%
                End if
              Next
              Set Files = Nothing
              Set Folder = Nothing
              Set FSO = Nothing


            %>
          </tbody>
        </table>
        <%
        if cdbl(iTotalCount) = 0 then
        %>
        <div class="board-bullet Non-pagination" >
            파일이 존재하지 않습니다.
        </div>
        <%
        End If
        %>
        <div id="divExcelDataList" name="divExcelDataList">

      <!-- S: btn-list btn-center-list -->
      <div class="text-left" style="margin-top: 30px;margin-bottom: 10px;">
        <a href="javascript:UploadData('');"  class="btn btn-red"> 참가팀 넣기 </a>
      </div>
      <!-- E: btn-list btn-center-list -->

        <table class="table-list"  id="tableExcelDataList" name="tableExcelDataList" >
          <thead>
            <tr>
              <th>번호</th>
              <th>게임번호</th>
              <th>종별</th>
              <th>플레이어1 </th>
              <th> 시도</th>
              <th> 구군</th>
              <th> 팀</th>
              <th> 생일</th>
              <th> 성별</th>
              <th> 핸드폰</th>
              <th> 비고</th>
              <th>플레이어2 </th>
              <th> 시도</th>
              <th> 구군</th>
              <th> 팀</th>
              <th> 생일</th>
              <th> 성별</th>
              <th> 핸드폰</th>
              <th> 비고</th>
            </tr>
          </thead>
          
          <tbody id="tbodyExcelDataList">
          </tbody>
        </table>  

        
        <div class="board-bullet Non-pagination" >
            데이터가 존재하지 않습니다.
        </div>
        

        </div>
      <div>
    </div>
  </div>

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>