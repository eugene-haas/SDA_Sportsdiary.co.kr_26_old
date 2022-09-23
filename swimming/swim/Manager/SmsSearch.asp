<!-- #include virtual = "/pub/header.swimAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
GameYears=request("GameYears")

if GameYears ="" then
    GameYears=year(date())
end if

gametitle=request("gametitle")
teamgb=request("gametitle")
Level=request("gametitle")

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
  <!-- #include virtual = "/pub/html/swimAdmin/html.head.v1.asp" -->
  <script type="text/javascript" src="/pub/js/swim/tennis_Sms.js<%=CONST_JSVER%>"></script>
  </head>
  <style>
  	.highlighted{background-color: yellow;}
  	.highlight{background-color: #fff34d;}

  	/*
  	 * Timepicker stylesheet
  	 * Highly inspired from datepicker
  	 * FG - Nov 2010 - Web3R
  	 *
  	 * version 0.0.3 : Fixed some settings, more dynamic
  	 * version 0.0.4 : Removed width:100% on tables
  	 * version 0.1.1 : set width 0 on tables to fix an ie6 bug
  	 */
  	.ui-timepicker-inline { display: inline; }
  	#ui-timepicker-div { padding: 0.2em; }
  	.ui-timepicker-table { display: inline-table; width: 0; }
  	.ui-timepicker-table table { margin:0.15em 0 0 0; border-collapse: collapse; }
  	.ui-timepicker-hours, .ui-timepicker-minutes { padding: 0.2em;  }
  	.ui-timepicker-table .ui-timepicker-title { line-height: 1.8em; text-align: center; }
  	.ui-timepicker-table td { padding: 0.1em; width: 2.2em; }
  	.ui-timepicker-table th.periods { padding: 0.1em; width: 2.2em; }

  	/* span for disabled cells */
  	.ui-timepicker-table td span {
  		display:block;
  		padding:0.2em 0.3em 0.2em 0.5em;
  		width: 1.2em;

  		text-align:right;
  		text-decoration:none;
  	}
  	/* anchors for clickable cells */
  	.ui-timepicker-table td a {
  		display:block;
  		padding:0.2em 0.3em 0.2em 0.5em;
  	   /* width: 1.2em;*/
  		cursor: pointer;
  		text-align:right;
  		text-decoration:none;
  	}


  	/* buttons and button pane styling */
  	.ui-timepicker .ui-timepicker-buttonpane {
  		background-image: none; margin: .7em 0 0 0; padding:0 .2em; border-left: 0; border-right: 0; border-bottom: 0;
  	}
  	.ui-timepicker .ui-timepicker-buttonpane button { margin: .5em .2em .4em; cursor: pointer; padding: .2em .6em .3em .6em; width:auto; overflow:visible; }
  	/* The close button */
  	.ui-timepicker .ui-timepicker-close { float: right }

  	/* the now button */
  	.ui-timepicker .ui-timepicker-now { float: left; }

  	/* the deselect button */
  	.ui-timepicker .ui-timepicker-deselect { float: left; }

  </style>
  <script src='//cdn.rawgit.com/fgelinas/timepicker/master/jquery.ui.timepicker.js'></script>

<body <%=CONST_BODY%>>

  <!-- <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-sm">

    </div>
  </div>
   -->
  <div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>

  <!-- #include virtual = "/pub/html/swimAdmin/html.header.asp" -->

  <%

      Set db = new clsDBHelper
      SQL ="selecT GameYear,GameYear+'년' GameYearNm from sd_TennisTitle where DelYN='N' and ISNULL(GameYear,'')<>'' group by  GameYear  order by GameYear desc"
      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
      If Not rs.EOF Then
          YearArr = rs.GetRows()
      End if

      SQL ="selecT GameTitleIDX,GameTitleName  from sd_TennisTitle  where DelYN='N'  and SportsGb ='tennis' and ViewYN='Y' and ISNULL(GameYear,'')='"&GameYears&"' "
      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
      If Not rs.EOF Then
          GameArr = rs.GetRows()
      End if


  %>

  <aside>
  <!-- #include virtual = "/pub/html/swimAdmin/html.left.asp" -->
  </aside>

  <article>

  	<div class="top-navi-inner">
  		<div class="top-navi-tp">
  			<h3 class="top-navi-tit" style="height: 50px;">
  				<strong>대회정보 > 참가신청 문자 발송 </strong>
  			</h3>
  		</div>
  		<div class="top-navi-btm" >
  			<div class="navi-tp-table-wrap" id="gameinput_area" >
                  <table class="navi-tp-table">
  		            <colgroup>
  			            <col width="80px">
  			            <col width="*">
  			            <col width="80px">
  			            <col width="*">
  			            <col width="150px">
  			            <col width="*">
  			            <col width="80px">
  			            <col width="*">
  		            </colgroup>
  		            <tbody>
                          <tr>
                              <th scope="row"><label for="competition-name">대회년도</label></th>
  				            <td>
  					            <select id="GameYears" onchange="mx_Sms.ControlSearch();">
                                      <%
                                       If IsArray(YearArr) Then
  		                                For ar = LBound(YearArr, 2) To UBound(YearArr, 2)
                                              %> <option value="<%=YearArr(0, ar) %>"<%if GameYears=YearArr(0, ar) then  %> selected<%end if  %>><%=YearArr(1, ar) %></option><%
                                          next
                                      end if
                                      %>
  					            </select>
                              </td>
  				            <th scope="row"><label for="competition-name" >대회명</label></th>
  				            <td>
  					            <select id="gametitle" onchange="mx_Sms.ControlSearch();">
                                      <%
                                       If IsArray(GameArr) Then
  		                                For ar = LBound(GameArr, 2) To UBound(GameArr, 2)
                                              %> <option value="<%=GameArr(0, ar) %>" <%if Cstr(gametitle)=Cstr(GameArr(0, ar)) then  %> selected<%end if  %> ><%=GameArr(1, ar) %></option><%
                                          next
                                      end if
                                      %>
  					            </select>
                              </td>
                          </tr>
  		            </tbody>
  	            </table>
  			</div>
  		</div>
  	</div>
      <p><span>※</span></p>
      <div class="top-navi-btm" >
  		<div class="navi-tp-table-wrap">
              <table class="navi-tp-table">

  		        <tbody>
                      <tr>
                          <th scope="row"><label for="competition-name">제목</label></th>
                          <td>
                              <input  type="text" id="SMS_title" value="" style=" width:300px"/>
                          </td>
                            <th scope="row"><label for="competition-name">발신번호</label></th>
                             <td>
                                  <input  type="text" id="SMS_Send_No" value="0222496130"  onfocus="this.select();" onkeyup=" this.value=this.value.replace(/[^0-9]/g, '')" maxlength=11 placeholder="0222496130"/>
                             </td>
                             <th scope="row"><label for="competition-name">예약시간</label></th>
                             <td>
                               <input  type="text" class="" id="SMS_dtStart" value="" style="width:150px;"  onfocus="this.select();"/>&nbsp;
                               <input  type="text" class="timepicker" id="SMS_dtStartTime" value="" style="width:150px;"  onfocus="this.select();"/>
                             </td>
                      </tr>
                      <tr>
                          <th scope="row"><label for="competition-name">내용</label></th>
                          <td  colspan="3">
                              <textarea rows="3" id="SMS_Contents" style=" width:100%; height:100px;"  ></textarea>
  							 <span id="bytes">0</span>bytes
                          </td>
                          <th scope="row"><label for="competition-name">수신번호</label></th>
                          <td  colspan="2">
                                  <input  type="text" id="SMS_Recive_No" value=""  onfocus="this.select();" onkeyup=" this.value=this.value.replace(/[^0-9]/g, '')" maxlength=11 placeholder="00000000000"/>

                                  <!--멀티로 변경 -->
                          </td>
                          <td >
                              <div class="btn-list">
  		                        <a href="javascript:mx_Sms.SmsSend();" id="btnsearch" class="btn"  accesskey="i">보내기(I)</a>
  	                        </div>
                          </td>
  						<td>
                              <div class="btn-list">
  		                        <a href="javascript:mx_Sms.LogList(1);" id="btnsearch" class="btn"  accesskey="i">로그확인</a>
  							</div>
  						</td>
                      </tr>
  		        </tbody>
  	        </table>
          </div>
      </div>
      <table class="table-list admin-table-list">
      <thead>
      <tr>
          <th width="30px" class="btn-center-list ">
              <a href="javascript:mx_Sms.chekall();" class=""><input type="checkbox" id="allCheck" onclick="mx_Sms.chekall();" style=" width:65%; height:65%;"/></a>
          </th>
          <th width="30px">No.</th>
          <th>대회명</th>
          <th>부(경기유형)</th>
          <th>랭크</th>
          <th>참가자</th>
          <th>전화번호</th>
          <th>파트너</th>
          <th>전화번호</th>
          <th>입금여부</th>
      </tr>
      </thead>
      <tbody id="contest">
      </tbody>
      </table>
  </article>

  <!-- #include virtual = "/pub/html/swimAdmin/html.footer.asp" -->
</body>
</html>
