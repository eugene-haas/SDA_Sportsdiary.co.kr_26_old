<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
 
<%
Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennisAdmin/html.head.asp" -->   
<script type="text/javascript" src="/pub/js/tennis_RankPlayer.js?ver=1"></script>
</head>

<body <%=CONST_BODY%>>

<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->

<%
     sql = " select convert(nvarchar(4),Gamedate,112)Gamedate " & _ 
            "   from dbo.sd_TennisRPoint_log " & _ 
            "   where Gamedate between convert(nvarchar,YEAR(GETDATE())-1)+'-01-01' and convert(nvarchar,YEAR(GETDATE())+1)+'-12-31' " & _ 
            "   group by convert(nvarchar(4),Gamedate,112) " 
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then 
        YearsArr = rs.GetRows()
    End if

    sql ="select teamGb,teamGbName from dbo.sd_TennisRPoint_log group by teamGb,teamGbName order by teamGb"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then 
        TeamgbArr = rs.GetRows()
    End if

%>



<aside>
<!-- #include virtual = "/pub/html/tennisAdmin/html.left.asp" -->
</aside>

<article>

	<div class="top-navi-inner">
		<div class="top-navi-tp">
			<h3 class="top-navi-tit" style="height: 50px;">
				<strong>대회정보 > 포인트 관리 (sd_TennisRPoint_log)</strong>
			</h3>
		</div>

		<div class="top-navi-btm" >
			<div class="navi-tp-table-wrap" id="gameinput_area" >
                <table class="navi-tp-table">
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
				            <th scope="row"><label for="competition-name">대회등급</label></th>
				            <td> 
                                <select id="gamegrade">
						            <option value="">전체</option>
						            <option value="2">GA</option>
						            <option value="1">SA</option>
						            <option value="3">A</option>
						            <option value="4">B</option>
						            <option value="5">C</option>
						            <option value="6">D</option>
						        </select>
                            </td>
				            <th scope="row"><label for="competition-name">부(경기유형)</label></th>
				            <td> 
					            <select id="teamgb">
					                <option value="">==선택==</option>
                                    <% 
                                     If IsArray(TeamgbArr) Then
		                                For ar = LBound(TeamgbArr, 2) To UBound(TeamgbArr, 2) 
                                            %> <option value="<%=TeamgbArr(0, ar) %>"><%=TeamgbArr(1, ar) %></option><%
                                        next
                                    end if 
                                    %>
					            </select>
                            </td>
			            </tr> 
			            <tr> 
				            <th scope="row"><label for="competition-name" >대회명</label></th>
				            <td> 
					            <input type="text" id="gametitle" placeholder="대회명 조회"  value=""  onfocus="this.select();" onkeyup="fnkeyup(this);"> 
                               
                            </td>
				            <th scope="row"><label for="competition-name">선수명</label></th>
				            <td> 
					            <input type="text" id="userName" placeholder="선수명 조회"value=""  onfocus="this.select();" onkeyup="fnkeyup(this);" > 
                            </td>
                            <td>
                              <div class="btn-list">
		                            <a href="javascript:mx_Rankplayer.TableSearch(1);" id="btnsearch" class="btn"  accesskey="i">조회(S)</a> 
	                            </div>
                            </td>
			            </tr>   
		            </tbody>
	            </table>
			</div>
		</div>
	</div>

    <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" ></ul>
 
    <table class="table-list admin-table-list" id="gameinput_insert" > 
		<colgroup><col width="60px"><col width="20px"><col width="20px"><col width="20px"><col width="20px"><col width="20px"><col width="20px"><col width="20px"><col width="20px"></colgroup>
        <thead> 
			    <tr> 
                    <th ><label for="competition-name">그룹</label></th>
				    <th ><label for="competition-name">대회등급</label></th>
                    <th ><label for="competition-name">대회명</label>  </th>
				    <th ><label for="competition-name">부(경기유형)</label></th>
                    <th ><label for="competition-name">랭크</label></th>
				    <th ><label for="competition-name">선수명</label></th>
				    <th ><label for="competition-name">포인트</label></th>
				    <th ><label for="competition-name"></label></th>
				    <th ><label for="competition-name"></label></th>
			    </tr> 
        </thead>
		<tbody>  
			<tr id="gameinput_insert_Contents"> 
                <td >
                
                    <input type=text style=" width:120px; " id="i_groupcodeName" onfocus="this.select()"  value="<%=findcode(titleCodearrRS,p_titleCode ,p_titleGrade) %>" readonly disabled/>
                    <input type=hidden style=" width:120px; " id="i_groupcode" value="<%=p_titleCode %>" readonly disabled/>
                
                </td>
                <td >
                    <select id="i_groupgrade" style=" width:70px; " disabled>
						<option value="">전체</option>
						<option value="2">GA</option>
						<option value="1">SA</option>
						<option value="3">A</option>
						<option value="4">B</option>
						<option value="5">C</option>
						<option value="6">D</option>
					</select>
                </td>
                <td >
                    <input type=text style=" width:200px; " id="i_titlename"  placeholder="대회명 조회" onfocus="this.select();" onkeyup="fnkeyup(this);"  value="<%=p_titleName %>"/>
                    <input type=hidden style=" width:200px; " id="i_titleidx" value=""/>
                    <input type=hidden style=" width:200px; " id="i_titlegubun" value=""/>
                    
                </td>
                <td >
                    <select id="i_teamGb">
	                    <option value="">==선택==</option>
                        <% 
                            If IsArray(TeamgbArr) Then
		                    For ar = LBound(TeamgbArr, 2) To UBound(TeamgbArr, 2) 
                                %> <option value="<%=TeamgbArr(0, ar) %>" <%if p_teamGb =TeamgbArr(0, ar) then  %> selected<%end if  %> ><%=TeamgbArr(1, ar) %></option><%
                            next
                        end if 
                        %>
                    </select> 
                </td>
                <td ><input type=text style=" width:50px; " id="i_rank" value="<%=p_rankno %>"/></td>
                <td >
                    <input type=text style=" width:120px; " id="i_playername"  placeholder="선수명 조회"  onfocus="this.select();" onkeyup="fnkeyup(this);"   value="<%=p_userName %>"/>
                    <input type=hidden style=" width:120px; " id="i_playeridx" value="<%=p_PlayerIDX %>"/>
                </td>
                <td ><input type=text style=" width:60px; " id="i_point" onfocus="this.select()" onkeyup="fnkeyup(this);"  value="<%=p_getpoint %>"/></td>
                <td >
                    <p>
                        <a href="javascript:mx_Rankplayer.btnSave();" id="btnsave" class="btn"  accesskey="I" >포인트 추가 등록(I)</a> 
                    </p>
                </td>
                 <td>
                    <p>
                        <a href="javascript:mx_Rankplayer.btnSaveOpen(1);" id="btnsaveOpen" class="btn"  accesskey="I" >등록창 초기화(C)</a>
                    </p>
                </td>
               
			</tr>    
		</tbody>
	</table>
    
                               
   
    <div class="btn-left-list">
        <p class="btn-more-result">
            <a href="javascript:mx_Rankplayer.TableSearch($('#NKEY').val());"  id="NKEY1">
                전체 <strong class="current">(<strong id="nownum"></strong>/<strong id="totnum"></strong>)건 </strong> /
                현제 페이지 <strong class="current">( <span id="nowcnt"></span>/<span id="totcnt"></span>)</strong> 
            </a>
        </p> 
		<!--<a href="javascript:;" id="btndelete" class="btn"  accesskey="D" >삭제(D)</a>-->
	</div>
    <table class="table-list admin-table-list">
    <thead> 
    <tr>  
        <th width="30px">No.</th><th>그룹</th> <th>등급</th><th>대회명</th><th>부(경기유형)</th><th>랭크</th><th>선수명</th><th>포인트</th><th width="90px">포인트 변경</th><th width="50px"></th>
    </tr>
    </thead>
    <tbody id="contest"> 
    </tbody>
    </table> 
    <div class="more-box " id="morebox" >   <!--  btn-more-result   --> 
      <a class="btn-more-list btn-more-result" onclick="mx_Rankplayer.TableSearch($('#NKEY').val())"> <span > <span class="ic-deco"><i class="fa fa-plus"></i>더 보기 </span> </span>
        <input type=hidden id="NKEY" value=1 />
      </a>
     
    </div>
</article>

<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->	
</body>
</html>