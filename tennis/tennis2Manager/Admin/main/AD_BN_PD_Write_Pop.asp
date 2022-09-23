<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head_Pop.asp"-->

<%
	
	viCateLocate1 = fInject(Request("piCateLocate1"))
	viCateLocate2 = fInject(Request("piCateLocate2"))
	viCateLocate3 = fInject(Request("piCateLocate3"))
	viCateLocate4 = fInject(Request("piCateLocate4"))

	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

  ihdPIDX = fInject(Request("ihdPIDX"))
  ihdPName = fInject(Request("ihdPName"))

	'response.Write "iCateLocate1 : "&viCateLocate1
	
	NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = "8"									' 한화면에 출력할 갯수
  BlockPage = "10"									' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴


	If Len(NowPage) = 0 Then
    NowPage = 1
  End If

	if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' 검색 구분자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
	if(Len(iSearchCol1) = 0) Then iSearchCol1 = "S2Y" ' WriteDate 순

	'if(Len(viCateLocate1) = 0) Then viCateLocate1 = ""
	'if(Len(viCateLocate2) = 0) Then viCateLocate2 = ""
	'if(Len(viCateLocate3) = 0) Then viCateLocate3 = ""
	'if(Len(viCateLocate4) = 0) Then viCateLocate4 = ""


  iType = "2"                      ' 1:조회, 2:총갯수

	iImageType = ihdPIDX
	iViewYN = "Y"
	iLocateGb = ""
	iSportsGb = "tennis"
	iDivision = "0"

  LSQL = "EXEC AD_tblADProductLocate_Sub_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iImageType & "','" & iLocateGb & "','" & viCateLocate1 & "','" & viCateLocate2 & "','" & viCateLocate3 & "','" & viCateLocate4 & "','" & iViewYN & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon6.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If
  LRs.close
%>

<link href="css/ad_banner_write_pop.css" rel="stylesheet" />
<link href="css/jquery-ui.min.css" rel="stylesheet" />
<script src="Js/jquery-ui.min.js"></script>

<style>
  .dropdown-box {
    position: relative;
    width: 280px;
  }

  .srch-inpt {
    dispaly: none;
    position: absolute;
    top: 31px;
    left: 0;
    border-bottom: 1px solid #ddd;
  }

  .srch-inpt li a {
    width: 178px !important;
    background: #fff !important;
    color: #333 !important;
    text-align: left !important;
    padding: 0 10px;
    border: 1px solid #ddd;
    border-bottom: 0;
  }
</style>
<script type="text/javascript">

  function fn_dbClick() {
    $(".srch-inpt li a").css("display", "none")
  }

</script>

<script type="text/javascript">

  var input_KeyWordYN = "0";

	var txtSearchValue = "<%=iSearchText%>";
	var selSearchValue = "<%=iSearchCol%>";

	var selSearchValue8 = "";
	var selSearchValue9 = "";
	var selSearchValue10 = "";
	var selSearchValue11 = "";

	function ViewPagingLink(v1) {

		var titpar = $('#tit_' + v1).html();
		var hdpar = $('#hd_' + v1).val();

		opener.document.getElementById("imgsel").innerText = titpar;
		opener.document.getElementById("hdimgselno").value = hdpar;

		window.close();

	}

  function PagingLink(i2) {

    var ihdPName = $('#fnd_KeyWord').val();

    if (ihdPName == "") {
      $('#hdPIDX').val("");
    }

    var ihdPIDX = $('#hdPIDX').val();

    //alert(ihdPIDX);

		selSearchValue8 = document.getElementById('piCateLocate1').value;
		selSearchValue9 = document.getElementById('piCateLocate2').value;
		selSearchValue10 = document.getElementById('piCateLocate3').value;
		selSearchValue11 = document.getElementById('piCateLocate4').value;

		post_to_url('./AD_BN_PD_Write_Pop.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'piCateLocate1': selSearchValue8, 'piCateLocate2': selSearchValue9, 'piCateLocate3': selSearchValue10, 'piCateLocate4': selSearchValue11, 'ihdPIDX': ihdPIDX, 'ihdPName': ihdPName  });
	}

	function fn_selSearch() {

    var ihdPName = $('#fnd_KeyWord').val();

    if (ihdPName == "") {
      $('#hdPIDX').val("");
    }

    var ihdPIDX = $('#hdPIDX').val();

    //alert(ihdPIDX);

		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;

		selSearchValue8 = document.getElementById('piCateLocate1').value;
		selSearchValue9 = document.getElementById('piCateLocate2').value;
		selSearchValue10 = document.getElementById('piCateLocate3').value;
		selSearchValue11 = document.getElementById('piCateLocate4').value;

		post_to_url('./AD_BN_PD_Write_Pop.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'piCateLocate1': selSearchValue8, 'piCateLocate2': selSearchValue9, 'piCateLocate3': selSearchValue10, 'piCateLocate4': selSearchValue11, 'ihdPIDX': ihdPIDX, 'ihdPName': ihdPName });
  }


  function input_KeyWord(iword, icode) {
    //alert(iword + ", " + icode);
    $("#fnd_KeyWord").val(iword);
    $('#hdPIDX').val(icode);
    fn_dbClick();
  }

  function view_keyword() {

      var fnd_KeyWord = $("#fnd_KeyWord").val();
      var itextno = fnd_KeyWord.length;

      var strAjaxUrl = "../main/Ajax/AD_BN_PD_Write_Pop.asp";

      if (itextno > 1) {

        $.ajax({
          url: strAjaxUrl,
          type: 'POST',
          dataType: 'html',
          data: {
            fnd_KeyWord: fnd_KeyWord
          },
          success: function (retDATA) {

            $("#group-list").html(retDATA);

          },  error: function(xhr, status, error){
            if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");
          return;
        }
          }
        });

      }
      else if (itextno == 0) {
        $("#group-list").html("");
      }

  }

</script>


<!-- S: board -->
<div class="board ad_bn_pd_write_pop">
	<div class="search_box">

    <div class="dropdown-box">
      <input type="text" name="fnd_KeyWord" id="fnd_KeyWord" placeholder="업체명(코드명)" class="has-sub" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" onKeyUp="view_keyword();" autocomplete="off" value="<%=ihdPName %>">
		  <ul class="srch-inpt dropdown-menu" role="menu" id="group-list"></ul>
    </div>

    <select id="selSearch" name="selSearch">
      <option value="T">전체</option>
      <option value="S">제목</option>
      <option value="F">파일명</option>
    </select>
		<input type="text" id="txtSearch" name="txtSearch" value="" placeholder="검색어를 입력해주세요">
    <a href="javascript:;" id="btnselSearch" name="btnselSearch" onclick="javascript:fn_selSearch();">검색</a>
	</div>
<div class="contents">
    <div class="board">
        <!-- s: 자유게시판 리스트 -->
        <div class="photogallery_list">
            <!-- S: list_box -->
            <div class="list_box">
                <!-- s: 목록 리스트 -->
                <ul>

									<%
									  ' 리스트 조회
									  iType = "1"

									  LSQL = "EXEC AD_tblADProductLocate_Sub_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iImageType & "','" & iLocateGb & "','" & viCateLocate1 & "','" & viCateLocate2 & "','" & viCateLocate3 & "','" & viCateLocate4 & "','" & iViewYN & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
										'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
									  'response.End
  
									  Set LRs = DBCon6.Execute(LSQL)
									          
									  If Not (LRs.Eof Or LRs.Bof) Then
									    Do Until LRs.Eof
									        LCnt = LCnt + 1
									%>
                   <li>
                       <a href="javascript:ViewPagingLink('<%=encode(LRs("ImageInfoIDX"),0) %>')">
                           <div><img src="<%=global_filepathUrl_ADIMG %><%=LRs("ImgFileNm") %>" alt="" /></div>
													 <div class="b-con">
														 <p class="tit" id="tit_<%=encode(LRs("ImageInfoIDX"),0) %>" name="hd_<%=encode(LRs("ImageInfoIDX"),0) %>"><%=LRs("Subject") %><% if LRs("ImgFileNm") <> "" then %>(<%=LRs("ImgFileNm") %>)<% end if %></p>
														 <p class="date" id=""><%=LRs("InsDateCv") %></p>
														<input type="hidden" id="hd_<%=encode(LRs("ImageInfoIDX"),0) %>" name="hd_<%=encode(LRs("ImageInfoIDX"),0) %>" value="<%=encode(LRs("ImageInfoIDX"),0) %>" />
													 </div>
                       </a>
                   </li>
									<%
									      LRs.MoveNext
									    Loop
									%>

									<%
									    Else
									%>
									  <!--게시판에 데이터가 없는 경우-->
									
										<div>등록된 게시물이 없습니다.</div>
									
									<%
									  End If
  
									  LRs.close
									%>
                    
                </ul>
                <!-- e: 목록 리스트 -->

            </div>
            <!-- E: list_box -->

						<input type="hidden" id="piCateLocate1" name="piCateLocate1" value="<%=viCateLocate1 %>" />
						<input type="hidden" id="piCateLocate2" name="piCateLocate2" value="<%=viCateLocate2 %>" />
						<input type="hidden" id="piCateLocate3" name="piCateLocate3" value="<%=viCateLocate3 %>" />
						<input type="hidden" id="piCateLocate4" name="piCateLocate4" value="<%=viCateLocate4 %>" />

            <input type="hidden" id="hdPIDX" name="hdPIDX" value="<%=ihdPIDX %>" />

            <!-- s: 페이징 -->
            <!-- 이전/다음 : 시작 -->

						<%
						  if LCnt > 0 then
						%>
						  <!--#include file="../dev/dist/Paging_Admin_Pop.asp"-->
						<%
						  End If
						%>

						<!--
						<ul class="pagination">
							<div class="paging">
								<a href="javascript:;" class=""><i class="fa fa-caret-left" aria-hidden="true"></i></a>
								<a href="javascript:;" class="on">1</a>
								<a href="javascript:;" class=""><i class="fa fa-caret-right" aria-hidden="true"></i></a>
							</div>
						</ul>
						-->
            
        </div>
    </div>
</div>
</div>

<script type="text/javascript">

	$("#txtSearch").val(txtSearchValue);
	$("#selSearch").val(selSearchValue);

</script>

<% AD_DBClose() %>
<!-- E: board -->