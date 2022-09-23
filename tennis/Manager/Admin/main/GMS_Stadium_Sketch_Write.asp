<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

	'Name = fInject(Request.cookies("UserName"))
	iUserID = fInject(Request.cookies("UserID"))
	iLoginID = decode(iUserID,0)

  ' 뷰 관련
  Dim LCnt, iAUSeq, AUSeq, InsDateCv, LoginIDYN
  LCnt = 0

	Dim sType 
	sType = iType

	' iType은 읽기와 쓰기를 같이 쓰게 됌으로 2로 고정
  If iType = "2" Then

    iAdminMenuListIDX = fInject(Request("i1"))
    iiAdminMenuListIDX = decode(iAdminMenuListIDX,0)


    LSQL = "EXEC AdminMenu_Read_S '" & iType & "','" & NowPage & "','" & iiAdminMenuListIDX & "','" & iLoginID & "','','','','',''"
	  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon5.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

		  Do Until LRs.Eof
      
          LCnt = LCnt + 1
					'AdminMenuListIDX = LRs("AdminMenuListIDX")
          RoleDetail = LRs("RoleDetail")
          RoleDetailNm = LRs("RoleDetailNm")
					RoleDetailGroup1 = LRs("RoleDetailGroup1")
          RoleDetailGroup1Nm = LRs("RoleDetailGroup1Nm")
					RoleDetailGroup2 = LRs("RoleDetailGroup2")
          RoleDetailGroup2Nm = LRs("RoleDetailGroup2Nm")
          Link = LRs("Link")
					WriteDateCv = LRs("WriteDateCv")
					LoginIDYN = LRs("LoginIDYN")
					UseYN = LRs("UseYN")

        LRs.MoveNext
		  Loop

    End If
  
    LRs.close

    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    If LoginIDYN = "N" Then

      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
      response.End

    End If


		'LCnt1 = 0
		'
		'iiType = "4"
		'
		'LSQL = "EXEC AdminMember_Menu_S '" & iiType & "','','','" & sUserID & "','','','','',''"
		''response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
		''response.End
		'
		'Set LRs = DBCon5.Execute(LSQL)
		'
		'If Not (LRs.Eof Or LRs.Bof) Then
		'
		'	Do Until LRs.Eof
		'
		'			LCnt1 = LCnt1 + 1
		'			iRoleDetail1 = iRoleDetail1&"^"&LRs("RoleDetail")&""
		'		
		'			LRs.MoveNext
		'	Loop
		'
		'End If
		'
		'LRs.close
		
    Tennis_DBClose()
  
  End If
  

    
   if Search_Years="" then 
        YNSQL = "SELECT LEFT(CONVERT(NVARCHAR,GETDATE(),112),4) Years"
        Set YNRs = Dbcon.Execute(YNSQL)
    
        If Not(YNRs.Eof Or YNRs.Bof) Then 
	        Search_Years =YNRs("Years")
        End If 
    End If 

	'공지사항 상세페이지
	
	dim SportsGb		: SportsGb			= "tennis"
	dim currPage   		: currPage    		= fInject(Request("currPage"))
	dim IDX 			: IDX   			= fInject(Request("IDX"))	
	dim Search_GameTitleIDX 	: Search_GameTitleIDX     = fInject(Request("Search_GameTitleIDX"))
    dim Search_TeamGbIDX 		: Search_TeamGbIDX		= fInject(Request("Search_TeamGbIDX"))

	ControlSql ="  SELECT			  C.gameyear									 "		
	ControlSql = ControlSql & "	     , A.Idx								 "		
	ControlSql = ControlSql & "		 ,C.GAMETITLENAME					 " 
	ControlSql = ControlSql & "		 ,B.TeamGbNm	 					 " 
	ControlSql = ControlSql & "		 ,A.Delyn				 			 " 
	ControlSql = ControlSql & "		 ,A.userid				 			 " 
	ControlSql = ControlSql & "		 ,A.username			 			 " 
	ControlSql = ControlSql & "		 ,A.Writeday			 			 " 
	ControlSql = ControlSql & "		 ,A.viewcnt			 				 " 
	ControlSql = ControlSql & "		 ,A.GameTitleIDX			 				 " 
	ControlSql = ControlSql & "		 ,A.TeamGbIDX			 				 " 
	ControlSql = ControlSql & "	  FROM dbo.sd_Tennis_Stadium_Sketch  a   " 
	ControlSql = ControlSql & "	  left outer join (select * from tblTeamGbInfo where SportsGb = 'tennis' ) B  			 " 
	ControlSql = ControlSql & "	  On A.TeamGbIDX =B.TeamGbIDX   		 " 
	ControlSql = ControlSql & "	  INNER Join sd_TennisTitle C 			 " 
	ControlSql = ControlSql & "	  On A.GameTitleIDX =C.GameTitleIDX 	 " 
	ControlSql = ControlSql & "	  WHERE C.DelYN='N' 						 " 
	ControlSql = ControlSql & "	  and C.stateNo>=5 						 " 
	ControlSql = ControlSql & "	  and C.MatchYN='Y' 					 " 
	ControlSql = ControlSql & "	  and C.ViewState='Y'					 "
	ControlSql = ControlSql & "	  and a.idx = '"&IDX&"'				 "
'Response.write ControlSql
	SET CRs = DBCon5.Execute(ControlSql)	
	IF NOT(CRs.Bof OR CRs.Eof) Then		
		gameyear	  = CRs("gameyear")
		Idx			  = CRs("Idx")
		GAMETITLENAME = CRs("GAMETITLENAME")
		TeamGbNm	  = CRs("TeamGbNm")
		Delyn		  = CRs("Delyn")
		userid		  = CRs("userid")
		username	  = CRs("username")
		Writeday	  = CRs("Writeday")		
		viewcnt		  = CRs("viewcnt")
		GameTitleIDX  = CRs("GameTitleIDX")
		TeamGbIDX	  = CRs("TeamGbIDX")
	End IF
		CRs.Close
	SET CRs = Nothing
'Response.write ControlSql
%>


<script type="text/javascript">

 
  var selSearchValue1 = "<%=iSubType%>"
  var txtSearchValue = "<%=iSearchText%>"
  var selSearchValue = "<%=iSearchCol%>"
  var selSearchValue2 = "<%=iNoticeYN%>"

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  var iFileNum = 1;
  var iFileLimitDf = 10; // 첨부파일 가능 갯수

  var iFileLimitNum = iFileLimitDf; // 수정시 파일 갯수에 따라 동적으로 변하는 값
  var iFileLimitNum1 = iFileLimitDf; // 변하지 않는 기본초기값.iFileLimitNum 과 같은 숫자를 적으면 됌.



  function FN_iFileDivP() {

   
      $('#FN_iFile_' + iFileNum).css('display', 'none');

      iFileNum = iFileNum + 1;

      var iHtmlPC = '';

      iHtmlPC = iHtmlPC + '<span id="sFile_' + iFileNum + '"><div style="float:left;">'+ iFileNum +')</div>&nbsp;<input type="file" id="iFile_' + iFileNum + '" name="iFile" class="csfile" /><span id="FN_iFile_' + iFileNum + '" class="btn_icon">&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivP();">+</a>&nbsp;<a href="javascript:;" onclick="javascript:FN_iFileDivM(' + iFileNum + ');">-</a></span><br /></span>';

      iHtmlPC = iHtmlPC + '';

      $('#iFileDiv').append(iHtmlPC);

   
  }

  function FN_iFileDivM(i1) {

    if (i1 == "1") {

      $('#iFile_1').val('');

    }
    else {

      //alert('iFile_' + i1);
      $('#sFile_' + iFileNum).remove();
      iFileNum = iFileNum - 1;
      $('#FN_iFile_' + iFileNum).css('display', '');

    }

  }

  function OK_Link()
  {
	  if (document.getElementById('Search_GameTitleIDX').value =='')
	  {
		  alert('대회를 선택해 주시기 바랍니다');
		  return;
	  }
	  if (document.getElementById('iFile_1').value =='')
	  {
		  alert('이미지를 1개이상 선택해 주시기 바랍니다.');
		  return;
	  }
	  if (document.getElementById('Search_TeamGbIDX').value =='')
	  {
		  alert('종별을 선택하지 않았습니다. 참고해주시기 바랍니다.');
		  //return;
	  }
	  document.form1.submit();
  }

  function CancelLink()
  {
		$('form[name=form1]').attr('action',"./GMS_Stadium_Sketch.asp");		
		$('form[name=form1]').submit(); 
  }
	

  function Sketch_Result(sk_gubun,sketch_idx, idx)
  {
	  if(confirm("해당 사진을 삭제하시겠습니까?")){
		var strAjaxUrl="GMS_Stadium_Sketch_Result.asp?sk_gubun="+sk_gubun+ "&sketch_idx=" + sketch_idx + "&idx="+idx;
		//location.href = strAjaxUrl
		//alert(strAjaxUrl);
			var retDATA="";
			//alert(strAjaxUrl);
			 $.ajax({
				 type: 'GET',
				 url: strAjaxUrl,
				 dataType: 'html',
				 success: function(retDATA) {
					if(retDATA)
						{
							if(retDATA=='TRUE')
							{	

								alert('삭제완료');
								
								if (sk_gubun=='photo_delete')
								{
									var strAjaxUrl="GMS_Stadium_Sketch_ajax.asp?sketch_idx="+sketch_idx
									//location.href=strAjaxUrl
									//alert(strAjaxUrl);
										var retDATA="";
										//alert(strAjaxUrl);
										 $.ajax({
											 type: 'GET',
											 url: strAjaxUrl,
											 dataType: 'html',
											 success: function(retDATA) {
												if(retDATA)
													{
														document.getElementById('Sketch_div').innerHTML = retDATA;
													}
											 }
										 }); //close $.ajax(
								}
							}
							else
							{
								alert('error')
								return;
							}
						}
				 }
			 }); //close $.ajax(
	  }

  }

  function on_select_year(this_is)
  {
	var strAjaxUrl="GMS_Stadium_sketch_tennisTitle.asp?get_year="+this_is.value;
	//location.href = strAjaxUrl;
	//location.href = strAjaxUrl
	//alert(strAjaxUrl);
		var retDATA="";
		//alert(strAjaxUrl);
		 $.ajax({
			 type: 'GET',
			 url: strAjaxUrl,
			 dataType: 'html',
			 success: function(retDATA) {
				if(retDATA)
					{
						document.getElementById("Search_GameTitleIDX_div").innerHTML =retDATA;
					}
			 }
		 }); //close $.ajax(

  }

</script>

<section>
	<div id="content">

		<!-- S : 내용 시작 -->
		<div class="contents">
			<!-- S: 네비게이션 -->
			<div	class="navigation_box">
				<strong>경기관리</strong> &gt; 현장스케치
			</div>
			<!-- E: 네비게이션 -->
			<form id="form1" name="form1" action="./GMS_Stadium_Sketch_Write_p.asp" method="post" ENCTYPE="multipart/form-data">
				<input type="hidden" name="Idx" id="Idx" value="<%=Idx%>">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">
					<tr>
						<th style="width:10%;">대회선택</th>
						<td style="width:40%;">
							<select name="Search_Year" id="Search_Year" style="width:25%;" onchange="javascript:on_select_year(this);">
								<% For year_i = 2017 To year(date) %>
									<option value="<%=year_i%>" <% If year_i =gameyear Then %> selected<% End If %>><%= year_i%></option>
								<% next%>
							</select>
							<span id="Search_GameTitleIDX_div">
								<select name="Search_GameTitleIDX" id="Search_GameTitleIDX" style="width:70%;">
									<option value="">=대회선택=</option>
									<%
										If gameyear = "" Then 
											GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
											GSQL = GSQL & " from sd_TennisTitle  "
											GSQL = GSQL & " where   DelYN='N' and stateNo>=5 and MatchYN='Y' and ViewState='Y'"
											GSQL = GSQL & " ORDER BY GameS DESC"
										Else
											GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
											GSQL = GSQL & " from sd_TennisTitle  "
											GSQL = GSQL & " where   DelYN='N' and GameYear='"&gameyear&"' and stateNo>=5 and MatchYN='Y' and ViewState='Y'"
											GSQL = GSQL & " ORDER BY GameS DESC"
										End If 
											Response.write GSQL
											Set GRs = Dbcon.Execute(GSQL)
											If Not(GRs.Eof Or GRs.Bof) Then 
												Do Until GRs.Eof 
													%>
													<option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(GameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
													<%
													GRs.MoveNext
												Loop 
											End If 
									%>
								</select>
							</span>
						</td>
						<th style="width:10%;">종별선택</th>
						<td style="width:30%;">
							<select id="Search_TeamGbIDX" name="Search_TeamGbIDX" style="width:100%;">
							<%

								GSQL2 = "select		TeamGbIDX,			  "
								GSQL2 = GSQL2 & " 	teamgb,				  "
								GSQL2 = GSQL2 & " 	teamgbNM			  "
								GSQL2 = GSQL2 & " from 					  "
								GSQL2 = GSQL2 & " tblTeamGbInfo			  "
								GSQL2 = GSQL2 & " where sportsgb = 'tennis' "

								Set GSQL2_rs = Dbcon.Execute(GSQL2)
							%>
								<option value="">::종별선택::</option>
								<option value="" <% if CStr(TeamGbIDX) ="" Then %> selected<% End If %>>전체</option>
			                 <%  
								If Not(GSQL2_rs.Eof Or GSQL2_rs.Bof) Then 
									Do Until GSQL2_rs.Eof 
							            %>
							            <option value="<%=GSQL2_rs("TeamGbIDX")%>" <%If CStr(GSQL2_rs("TeamGbIDX")) = CStr(TeamGbIDX) Then %>selected<%End If%>><%=GSQL2_rs("teamgbNM")%></option>
							            <%
										GSQL2_rs.MoveNext
									Loop 
								End If 
							%>
							</select>
						</td>
						<th style="width:15%;">워터마크포함여부</th>
						<td style="width:10%;">
							<select id="watermark_yn" name="watermark_yn" >
								<option value="Y" selected>포함</option>
								<option value="N">미포함</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>이미지등록</th>
						<td  colspan="5" height="25" style="width:20%;">
							<span class="right_con">
								<div id="iFileDiv" name="iFileDiv"  style="float:left;">
									<span id="sFile_1">
										<input multiple="multiple"  type="file" name="iFile" id="iFile_1"/>(다중파일 선택가능)
										
									</span>
								</div>
								<div id="Sketch_div">
									<%
										ControlSql =" SELECT		   idx		 "	
										ControlSql = ControlSql & "	  ,Sketch_idx	 "	
										ControlSql = ControlSql & "	  ,Photo	 "	
										ControlSql = ControlSql & " FROM dbo.sd_Tennis_Stadium_Sketch_Photo	 "	
										ControlSql = ControlSql & " where Sketch_idx = '"&idx&"' 	 "	
										ControlSql = ControlSql & " and delyn = 'N' 	 "	
										SET CRs = DBCon5.Execute(ControlSql)	
									%>
									
									<%
										If Not(CRs.Eof Or CRs.Bof) Then 
											Do Until CRs.Eof 
									%>
									 <div style="width:100%;">
										<span id="FN_iFile_1" class="btn_icon_delte" style="float:left; margin-left:-15px;">&nbsp;
											<a href="javascript:Sketch_Result('photo_delete','<%=CRs("Sketch_idx")%>','<%=CRs("idx")%>');">-</a>&nbsp;
										</span><br />
										<img src="http://tennis.sportsdiary.co.kr/tennis/m_player/upload/sketch/<%=CRs("Photo")%>"><br>
									</div>
									<%
												CRs.MoveNext
											Loop 
										End If 
									%>
									
								</div>
								
							</span>	
							
						</td>
					</tr>
				</table>
				<div class="btn_list">
					<input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
					<input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />

					<input type="hidden" id="iAdminMenuListIDX" name="iAdminMenuListIDX" value="<%=iAdminMenuListIDX %>" />
					<input type="hidden" id="iType" name="iType" value="<%=iType %>" />
					<input type="hidden" id="iID" name="iID" value="<%=iUserID %>" />
					<input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
				</div>
      </form>

		</div>
		<!-- E : 내용 시작 -->
	</div>
<section>

<% if sType = 2 then %>
<script type="text/javascript">

	var LCnt1 = Number("<%=LCnt1%>");

	if (LCnt1 > 0) {

		var iRoleDetail1 = "<%=iRoleDetail1%>";

		var iRoleDetail1arr = iRoleDetail1.split("^");

		//alert(iRoleDetail1);

		for (var i = 1; i < LCnt1 + 1; i++) {
			$('#chkiRoleDetail2_' + iRoleDetail1arr[i] + '').prop("checked", true);
		}

	}

</script>
<% end if %>

<!--#include file="footer.asp"-->

</html>