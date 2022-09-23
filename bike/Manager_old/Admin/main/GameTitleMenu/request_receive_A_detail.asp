<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
    <%
  dim fnd_currPage  : fnd_currPage    = fInject(request("fnd_currPage"))          
  dim fnd_RKeyWord  : fnd_RKeyWord    = fInject(request("fnd_RKeyWord"))            'page
  dim GameTitleIDX  : GameTitleIDX    = crypt.DecryptStringENC(fInject(request("CIDX")))  '대회정보 IDX   
  dim ReceptionistIDX : ReceptionistIDX   = crypt.DecryptStringENC(fInject(request("ReceptionistIDX")))

  dim fnd_EnterType : fnd_EnterType   = fInject(request("fnd_EnterType"))                  
  dim fnd_Year    : fnd_Year      = fInject(request("fnd_Year"))                   
  dim currPage      : currPage        = fInject(request("currPage"))     
  
  IF GameTitleIDX = "" Then 
    response.write "<script>alert('잘못된 접근입니다. 확인 후 이용하세요.1'); history.back();</script>"
    response.End
  End IF

  dim LRs, LSQL
  dim GameTitleName, GameDate, GroupPayment, PersonalPayment, TypeStateRQ
  dim SidoNm, SidoGuGunNm, Team, TeamNm, OwnerName   
  dim ReceptionistNm, PayStatus, PayStatusNm, PayGroupNum, PayOrderNum
  
  '클럽정보                          
  LSQL = "    SELECT [KoreaBadminton].[dbo].[FN_SidoName](Sido) SidoNm"
  LSQL = LSQL & "   ,[KoreaBadminton].[dbo].[FN_SidoGuGunName](Sido, SidoGuGun) SidoGuGunNm"
  LSQL = LSQL & "   ,Team"
  LSQL = LSQL & "   ,TeamNm"
  LSQL = LSQL & "   ,OwnerName"
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblTeamInfo]"  
  LSQL = LSQL & " WHERE DelYN = 'N'"
  LSQL = LSQL & "   AND EnterType = '"&fnd_EnterType&"'"
  LSQL = LSQL & "   AND Team IN ("
  LSQL = LSQL & "     SELECT Team"
  LSQL = LSQL & "     FROM [KoreaBadminton].[dbo].[tblMember]"
  LSQL = LSQL & "     WHERE MemberIDX = '"&ReceptionistIDX&"'"                               
  LSQL = LSQL & "   ) "
  
  SET LRs = DBCon.Execute(LSQL) 
  IF Not(LRs.Eof Or LRs.Bof) Then
    SidoNm = LRs("SidoNm")
      SidoGuGunNm = LRs("SidoGuGunNm")
      Team = LRs("Team")
      TeamNm = LRs("TeamNm")
      OwnerName = LRs("OwnerName")    '클럽장
  End IF
      LRs.Close
  SET LRs = Nothing
     
  '대회정보 및 참가신청 결제정보   
  LSQL = "    SELECT TOP 1 A.Status PayStatus"  
  LSQL = LSQL & "   ,A.PayGroupNum"         
  LSQL = LSQL & "   ,B.PubName PayStatusNm"
  LSQL = LSQL & "   ,A.PayOrderNum"
  LSQL = LSQL & "   ,C.UserName ReceptionistNm"   
  LSQL = LSQL & "   ,C.Email ReceptionistEmail"   
  LSQL = LSQL & "   ,D.GameTitleName"
  LSQL = LSQL & "   ,CONVERT(CHAR(10), CONVERT(DATE, D.GameS), 102) + ' ~ ' + CONVERT(CHAR(10), CONVERT(DATE, D.GameE), 102) GameDate"
  LSQL = LSQL & "   ,D.GroupPayment"
  LSQL = LSQL & "   ,D.PersonalPayment" 
  LSQL = LSQL & "     ,CASE WHEN DATEDIFF(D, GameRcvDateS, '"&DATE()&"')>=0 AND DATEDIFF(D, '"&DATE()&"', GameRcvDateE)>=0 THEN 'ON' ELSE 'OFF' END TypeStateRQ"
  LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblGameEnter] A"
  LSQL = LSQL & "   inner join [KoreaBadminton].[dbo].[tblGameTitle] D on A.GameTitleIDX = D.GameTitleIDX AND D.DelYN = 'N'"  
  LSQL = LSQL & "   inner join [KoreaBadminton].[dbo].[tblMember] C on A.ReceptionistIDX = C.MemberIDX AND C.DelYN = 'N' AND C.EnterType = '"&fnd_EnterType&"'" 
  LSQL = LSQL & "   left join [KoreaBadminton].[dbo].[tblPubCode] B on A.Status = B.PubCode AND B.DelYN = 'N'"  
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & "   AND A.EnterType = '"&fnd_EnterType&"'"    
  LSQL = LSQL & "   AND A.GameTitleIDX = '"&GameTitleIDX&"'"  
  LSQL = LSQL & "   AND A.ReceptionistIDX = '"&ReceptionistIDX&"'"
  LSQL = LSQL & " ORDER BY A.UserName"
  
' response.write LSQL
                                   
  SET LRs = DBCon.Execute(LSQL) 
  IF Not(LRs.Eof Or LRs.Bof) Then   
    GameTitleName = LRs("GameTitleName")
      GameDate = LRs("GameDate")                                     
      GroupPayment = LRs("GroupPayment")                                     
      PersonalPayment = LRs("PersonalPayment")                                     
    ReceptionistNm = LRs("ReceptionistNm")      '신청자 이름                                     
      ReceptionistEmail = LRs("ReceptionistEmail")  '신청자 이메일                                      
    PayStatus = LRs("PayStatus")          '신청상태값                       
      PayStatusNm = LRs("PayStatusNm")        '신청상태값 텍스트
    PayGroupNum = LRs("PayGroupNum")        '결제 그룹번호  
    PayOrderNum = LRs("PayOrderNum")        '결제 거래번호(결제 취소시 사용함)                     
    TypeStateRQ = LRs("TypeStateRQ")        '참가신청기간내이면 ON 아니면 OFF              
  End IF
      LRs.Close
  SET LRs = Nothing
  
             
  %>
  <script type="text/javascript">
  /**
   * left-menu 체크
   */
  var bigCate = 2; // 대회정보
  var midCate = 1; // 대회관리
  var lowCate = 2; // 참가신청관리
  /* left-menu 체크 */


                             
    function CHK_SUBMIT(valType){
      switch(valType){
        case "GLIST"  : $('form[name=s_frm]').attr('action','./request_MatchState.asp'); break;
        default     : $('form[name=s_frm]').attr('action','./request_receive_A.asp');
      }
      $('form[name=s_frm]').submit();
    }                            

    //참가신청 정보(개인전/단체전)
    function INFO_REQUEST(valType){
      var strAjaxUrl = '/Ajax/Request/request_receive_A_detail.asp';    
      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',     
        data: { 
          valType       : valType
          ,GameTitleIDX : '<%=fInject(request("CIDX"))%>'
          ,ReceptionistIDX: '<%=fInject(request("ReceptionistIDX"))%>'
          ,PayGroupNum  : '<%=crypt.EncryptStringENC(PayGroupNum)%>'  
          ,EnterType    : '<%=crypt.EncryptStringENC(fnd_EnterType)%>'    
            
        },    
        success: function(retDATA) {

          console.log(retDATA);
            
          if(retDATA){
            
            var strcut = retDATA.split('|');
            
            if(strcut[0]=='TRUE'){
              switch(valType){
                case 'B0030001' : $('#info_Personal').html(strcut[1]); break; //개인전
                case 'B0030002' : $('#info_Group').html(strcut[1]); break;    //단체전
                default : $('#info_Member').html(strcut[1]);          //신청자정보
              } 
            }
            else{
              alert('잘못된 접근입니다. 확인 후 이용하세요.2');   
              return;
            }
          } 
        }, 
        error: function(xhr, status, error){           
          if(error!=''){
            alert ('오류발생! - 시스템관리자에게 문의하십시오!');
            return;
          }    
        }
      });    
    }
        
    
    $(document).ready(function(){
      INFO_REQUEST('INFO');   //신청자정보
      INFO_REQUEST('B0030001'); //개인전 참가신청
      INFO_REQUEST('B0030002'); //단체전 참가신청
    });
</script> 
</head>

  <!-- S: content request_receive_a_detail -->
  <div id="content" class="request_receive_a_detail request-detail">
    
    <form name="s_frm" method="post">
      <input type="hidden" name="CIDX" id="CIDX" value="<%=fInject(request("CIDX"))%>" />
    <input type="hidden" name="fnd_RKeyWord" id="fnd_RKeyWord" value="<%=fnd_RKeyWord%>" />  
        <input type="hidden" name="fnd_currPage" id="fnd_currPage" value="<%=fnd_currPage%>" />
        <input type="hidden" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
        <input type="hidden" name="fnd_EnterType" id="fnd_EnterType" value="<%=fnd_EnterType%>" />
        <input type="hidden" name="fnd_Year" id="fnd_Year" value="<%=fnd_Year%>" />
    </form>

    <!-- S: page_title -->
    <div class="page_title clearfix">
    <h2>참가현황 조회</h2>
    <a href="./request_state_A.asp" class="btn btn-back">뒤로가기</a>

    <!-- S: 네비게이션 -->
    <div  class="navigation_box">
      <span class="ic_deco">
        <i class="fas fa-angle-right fa-border"></i>
      </span>
      <ul>
        <li>대회정보</li>
        <li>대회관리</li>
        <li><a href="./request_MatchState.asp">참가신청관리</a></li>
        <li><a href="./request_state_A.asp">참가현황 조회</a></li>
        <li><a href="./request_state_A_detail.asp">참가신청 상세보기</a></li>
      </ul>
    </div>
    <!-- E: 네비게이션 -->
  </div>
  <!-- E: page_title -->

  <!-- S: sub_main write_comp-->
  <div class="sub_main write_comp">
    <!-- S: title_header -->
    <!-- <div class="title_header">
      S: container
      <div class="container">
        S: row
        <div class="row">
          <h2>참가신청 상세내역</h2>
        </div>
        E: row
      </div>
      E: container
    </div> -->
    <!-- E: title_header -->

    <!-- S: content_area -->
    <div class="content_area">
      <!-- S: container -->
      <div class="container">
        <!-- S: row -->
        <div class="row">
          <h3 class="match_title_bar">
            <span class="title"><%=GameTitleName%></span>
            <span class="match_date"><%=GameDate%></span>
          </h3>

          <!-- S: loaded -->
          <div class="loaded">
            <!-- S: table -->
            <table class="table">
              <tbody>
                <tr>
                  <th>시/도</th>
                  <td><%=SidoNm%></td>
                  <th>시/군/구</th>
                  <td><%=SidoGuGunNm%></td>
                  <th>클럽명</th>
                  <td><%=TeamNm%></td>
                  <th>클럽코드</th>
                  <td><%=Team%></td>
                  <th>클럽장명</th>
                  <td><%=OwnerName%></td>
                </tr>
              </tbody>
            </table>
            <!-- E: table -->
          </div>
          <!-- E: loaded -->

          <!-- S: write_doc -->
          <div class="write_doc">
            <!-- S: sky_bg show_payment -->
            <div class="sky_bg show_payment">
            <%
             IF PayStatus = "ST_1" Then
              response.write "<p class='state pay_wait'>"&PayStatusNm&"</p><p class='txt'>결제 후 신청이 완료됩니다.</p>"
             Else
              response.write "<p class='state pay_comp'>"&PayStatusNm&"</p>"
             End IF
             %>
              
            </div>
            <!-- E: sky_bg show_payment -->

            <!-- S: table_section -->
            <section class="table_section first_table">
              <h3>신청자 정보</h3>

              <!-- S: table -->
              <table class="table ipt_table">
                <tbody id="info_Member">
                  <tr>
                    <th>신청자 이름</th>
                    <td>홍길동</td>
                    <th>휴대폰 번호</th>
                    <td>010-1234-5678</td>
                    <th>E-mail</th>
                    <td>badmin123@naver.com</td>
                  </tr>
                  <tr>
                    <th>대표자 이름</th>
                    <td>임지성</td>
                    <th>휴대폰 번호</th>
                    <td>010-1234-5678</td>
                    <th>E-mail</th>
                    <td>badmin123@naver.com</td>
                  </tr>
                </tbody>
              </table>
              <!-- E: table -->
            </section>
            <!-- E: table_section -->

            <!-- S: table_section -->
            <section class="table_section priv_req_table">
              <h3><span class="bluy">개인전</span> 참가신청 내역</h3>
              <!-- S: result_table -->
              <table class="table result_table">
                <thead>
                  <tr>
                    <th>종목</th>
                    <th>연령</th>
                    <th>급수</th>
                    <th>시/도</th>
                    <th>시/군/구</th> 
                    <th>참가자(클럽명)</th>
                    <th>참가자 연락처</th>
                    <th>파트너(클럽명)</th>
                    <th>파트너 연락처</th>
                  </tr>
                </thead>

                <tbody id="info_Personal">
                </tbody>
              </table>
              <!-- E: result_table -->
            </section>
            <!-- E: table_section -->

            <!-- S: table_section -->
            <section class="table_section group_req_table">
              <h3><span class="bluy">단체전</span> 참가신청 내역</h3>

              <!-- S: result_table -->
              <table class="table result_table">
                <thead>
                  <tr>
                    <th>종목</th>
                    <th>연령</th>
                    <th>그룹</th>
                    <th>시/도</th>
                    <th>시/군/구</th> 
                    <th>클럽명</th>
                    <th>클럽코드</th>
                    <!--<th>직책</th>-->
                    <th>선수명</th>
                    <th>동호인 번호</th>
                    <th>성별</th>
                    <th>핸드폰 번호</th>
                  </tr>
                </thead>

                <tbody id="info_Group">
          
                </tbody>
              </table>
              <!-- E: result_table -->
            </section>
            <!-- E: table_section -->
                       
            <!-- S: btn_list -->
            <div class="btn_list comp_list_btn">
              <a href="javascript:CHK_SUBMIT('GLIST');" class="btn btn-confirm">참가신청관리</a>
              <a href="javascript:CHK_SUBMIT('RLIST');" class="btn btn-gray">신청접수목록</a>
            </div>
            <!-- E: btn_list -->
            
          </div>
          <!-- E: write_doc -->

        </div>
        <!-- E: row -->
      </div>
      <!-- E: container -->
    </div>
    <!-- E: content_area -->
  </div>

  </div>
  <!-- E: content request_receive_a_detail -->


<!--#include file="../../include/footer.asp"-->