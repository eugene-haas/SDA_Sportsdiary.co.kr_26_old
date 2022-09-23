
<!-- #include virtual = "/pub/ajax/reqTennisRankPlayer.asp" -->
<%

'#############################################
' 랭크 포인트 조회
'#############################################
	'request
    
    If hasown(oJSONoutput, "inputkey") = "ok" then	 '입금일짜
	    inputkey = oJSONoutput.inputkey
    else
        inputkey=""
    end if 
    If hasown(oJSONoutput, "groupcode") = "ok" then	 '입금일짜
	    groupcode = oJSONoutput.groupcode
    else
        groupcode=""
    end if 
    If hasown(oJSONoutput, "groupgrade") = "ok" then	 '입금일짜
	    groupgrade = oJSONoutput.groupgrade
    else
        groupgrade=""
    end if 
     
    If hasown(oJSONoutput, "gametitle") = "ok" then	 '입금일짜
	    gametitle = oJSONoutput.gametitle
    else
        gametitle=""
    end if 
    If hasown(oJSONoutput, "teamGb") = "ok" then	 '입금일짜
	    teamGb = oJSONoutput.teamGb
    else
        teamGb=""
    end if 
    If hasown(oJSONoutput, "userName") = "ok" then	 '입금일짜
	    userName = oJSONoutput.userName
    else
        userName=""
    end if  
    
	pageno = oJSONoutput.NKEY
	intPageNum = pageno
	intPageSize = 100

	Set db = new clsDBHelper

    '생성 여부 확인하고 찍어준다.
    strFieldName = " a.idx,a.titleGrade,a.titleCode,a.titleIDX,titleName,a.teamGb,a.teamGbName,a.rankno,a.PlayerIDX,a.userName,a.getpoint,a.ptuse,b.TeamNm,b.Team2Nm" 
    strTableName = " sd_TennisRPoint_log a left join tblplayer b on a.PlayerIDX = b.PlayerIDX and b.delyn='N' " 
    strWhere =  " 1=1 "
    strWhere = strWhere &  " and titleName not like '%업로드%'" 
   
    if inputkey <> "" then 
        strWhere = strWhere & " and a.idx ='"&inputkey&"'" 
    end if

    if groupcode <> "" then 
        strWhere = strWhere & " and a.titleCode ='"&groupcode&"'" 
    end if

    if groupgrade <> "" then 
        strWhere = strWhere & " and a.titleGrade ='"&groupgrade&"'" 
    end if

    if gametitle <> "" then 
        strWhere = strWhere & " and titleName like'%"&gametitle&"%'" 
    end if

    if teamGb <> "" then 
        strWhere = strWhere & " and a.teamGb ='"&teamGb&"'" 
    end if

    if userName <> "" then 
        strWhere = strWhere & " and a.userName ='"&userName&"'" 
    end if
    
	strSort = "  ORDER By titleName Desc,teamGb Asc,rankno Asc  "
	strSortR = "  ORDER By titleName Asc,teamGb Desc,rankno Desc  "	

   	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if  
    

	block_size = ((pageno-1) * intPageSize) +1
    
    Call oJSONoutput.Set("nowKEY", pageno )
    If CDbl(pageno) >= CDbl(intTotalPage) Then
	    lastpage = "_end"
        intPageNum = intTotalPage
    Else
	    lastpage = "_ing"
        intPageNum = pageno * intPageSize
        pageno = pageno +1
    End if

    
    '타입 석어서 보내기
    Call oJSONoutput.Set("result", "0" )
    Call oJSONoutput.Set("lastpage", lastpage )
 
    Call oJSONoutput.Set("intNowCnt", intPageNum )
    Call oJSONoutput.Set("intTotalCnt", intTotalCnt )

    Call oJSONoutput.Set("intTotalPage", intTotalPage )
    Call oJSONoutput.Set("NKEY", pageno )
     
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"

    '그룹 정보
    SQL =  " select titleCode,titleGrade,hostTitle from dbo.sd_TennisTitleCode where delYN='N' group by  titleCode,titleGrade,hostTitle " 
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then 
		titleCodearrRS = rs.GetRows()
	End if  
    
    sql ="select teamGb,teamGbName from dbo.sd_TennisRPoint_log group by teamGb,teamGbName order by teamGb"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then 
        TeamgbArr = rs.GetRows()
    End if

    i=block_size
    If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
            
            p_idx	                =arrRS(0, ar) 
			p_titleGrade			=arrRS(1, ar) 
			p_titleCode			    =arrRS(2, ar)
			p_titleIDX			    =arrRS(3, ar) 
			p_titleName		        =arrRS(4, ar) 
			p_teamGb		        =arrRS(5, ar) 
			p_teamGbName		    =arrRS(6, ar) 
			p_rankno		        =arrRS(7, ar) 
			p_PlayerIDX		        =arrRS(8, ar) 
			p_userName		        =arrRS(9, ar) 
			p_getpoint			    =arrRS(10, ar) 
			p_ptuse			        =arrRS(11, ar) 
			p_TeamNm			    =arrRS(12, ar) 
			p_Team2Nm			    =arrRS(13, ar) 
              
             if inputkey ="" then 
            %>

            <tr class="gametitle" id="Point_tr_<%=p_idx %>" style="cursor:pointer"   >
            <!-- onclick="mx_Rankplayer.TrSelect(<%=p_idx %>);"-->
		        <td ><%=i %></td> 
		        <td ><%=findcode(titleCodearrRS,p_titleCode ,p_titleGrade)%></td>
		        <td ><%=findGrade(p_titleGrade) %></td>
		        <td style="text-align:left;padding-left:10px;"><%=p_titleName %></td>
		        <td style="color:#A43A1D;"><%=p_teamGbName %></td>
		        <td ><span><%=p_rankno %></span></td>
		        <td ><span><%=p_userName %> [<%=p_TeamNm %> / <%=p_Team2Nm %>]</span></td>
		        <td ><span style="color:blue" id="onPoint_<%=p_idx %>"><%=p_getpoint %></span></td>
		        <td style=" max-width:90px;">
                    <input  type=text id="upPoint_<%=p_idx %>" value ="<%=p_getpoint %>" onfocus="this.select()"  onchange="mx_Rankplayer.changePoint(this);"  style=" max-width:50px; padding:5px;" /> 
                </td>
                <td>
                     <a href="javascript:mx_Rankplayer.btnDelete(<%=p_idx %>);;" id="btndelete" class="btn btn-delete"  accesskey="I" >삭제(D)</a>
                </td>
	        </tr>
            <%
            else
            %>
                <td >
                    <input type=text style=" width:120px; " id="i_groupcodeName" onfocus="this.select()"  value="<%=findcode(titleCodearrRS,p_titleCode ,p_titleGrade) %>" disabled/>
                    <input type=hidden style=" width:120px; " id="i_groupcode" value="<%=p_titleCode %>" disabled/>
                </td>
                <td >
                
                    <select id="i_groupgrade" style=" width:70px; " disabled>
						<option value="" <%if p_titleGrade ="" then  %> selected<%end if  %>>전체</option>
						<option value="2"<%if p_titleGrade ="GA" then  %> selected<%end if  %>>GA</option>
						<option value="1"<%if p_titleGrade ="SA" then  %> selected<%end if  %>>SA</option>
						<option value="3"<%if p_titleGrade ="A" then  %> selected<%end if  %>>A</option>
						<option value="4"<%if p_titleGrade ="B" then  %> selected<%end if  %>>B</option>
						<option value="5"<%if p_titleGrade ="C" then  %> selected<%end if  %>>C</option>
						<option value="6"<%if p_titleGrade ="D" then  %> selected<%end if  %>>D</option>
					</select>
                
                </td>
                <td >
                    <input type=text style=" width:200px; " id="i_titlename" placeholder="대회명 조회"  onfocus="this.select();" onkeyup="fnkeyup(this);"  value="<%=p_titleName %>"/>
                    <input type=hidden style=" width:200px; " id="i_titleidx" value="<%=p_titleIDX %>"/>
                </td>
                <td >
                      <select id="i_teamGb">
	                    <option value="">==선택==</option>
                        <% 
                            If IsArray(TeamgbArr) Then
		                        For arr = LBound(TeamgbArr, 2) To UBound(TeamgbArr, 2) 
                                    %> <option value="<%=TeamgbArr(0, arr) %>" <%if p_teamGb =TeamgbArr(0, arr) then  %> selected<%end if  %> ><%=TeamgbArr(1, arr) %></option><%
                                next
                             end if 
                        %>
                    </select> 
                </td>
                <td ><input type=text style=" width:50px; " id="i_rank" value="<%=p_rankno %>"/></td>
                <td >
                    <input type=text style=" width:120px; " id="i_playername" placeholder="선수명 조회"  onfocus="this.select();" onkeyup="fnkeyup(this);"  value="<%=p_userName %>"/>
                    <input type=hidden style=" width:120px; " id="i_playeridx" value="<%=p_PlayerIDX %>"/>
                </td>
                <td ><input type=text style=" width:60px; " id="i_point" onfocus="this.select()"  value="<%=p_getpoint %>"/></td>
                <td >
                    <p>
                        <a href="javascript:mx_Rankplayer.btnSave();" id="btnsave" class="btn"  accesskey="I" >등록(I)</a> 
                    </p>
                </td>
            <%
            end if 

            i=i+1
		Next
	end if

	'If Not rs.eof Then 
	'	Do Until rs.eof
	'	p_attcnt		= rs("attcnt")
	'	p_seedcnt		= rs("seedcnt")
	'	p_jonocnt		= rs("jonocnt")
	'	p_boxorder		= rs("boxorder")
	'	rs.movenext
	'	Loop
	'end if 
     

      
      
	'sql = "select a.tryoutgroupno,a.t_rank,a.rndno1,a.rndno2,a.userName a_userName,a.TeamANa a_TeamANa,a.TeamBNa a_TeamBNa,b.userName b_userName,b.TeamANa b_TeamANa,b.TeamBNa b_TeamBNa ,isnull(a.place,'')place " 
	'sql = sql & " from  sd_TennisMember a "  
	'sql = sql & " inner join sd_TennisMember_partner b on a.gameMemberIDX = b.gameMemberIDX "  
	'sql = sql & " where a.delyn='N' and  a.GameTitleIDX='"&tidx&"'  and  a.gamekey3 ='"&fstr2_str&"' and ISNULL(a.round,'')='' "  

	'Set srs = db.ExecSQLReturnRS(sql , null, ConStr)	
	'If Not srs.EOF Then 
	'	arrRS = srs.GetRows()
	'End if  
 
'	If IsArray(arrRS) Then
'		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
'			tryoutgroupno	=arrRS(0, ar) 
'			t_rank			=arrRS(1, ar) 
'			rndno1			=arrRS(2, ar)
'			rndno2			=arrRS(3, ar) 
'			a_userName		=arrRS(4, ar) 
'			a_TeamANa		=arrRS(5, ar) 
'			a_TeamBNa		=arrRS(6, ar) 
'			b_userName		=arrRS(7, ar) 
'			b_TeamANa		=arrRS(8, ar) 
'			b_TeamBNa		=arrRS(9, ar) 
'			t_place			=arrRS(10, ar) 
'
'			if  p_orderno =1 and  t_rank  = 1 then 
'				if  p_joono =rndno1 then
'					Response.write "["&t_place&"]"&tryoutgroupno&"조 - "&t_rank&"위 [  선수1 : "&a_userName&" ] [ 선수2 : "&b_userName &"]"
'				end if 
'			elseif   p_orderno =2 and  t_rank  = 2 then 
'				if  p_joono = rndno2 then
'					Response.write "["&t_place&"]"&tryoutgroupno&"조 - "&t_rank&"위 [  선수1 : "&a_userName&" ] [ 선수2 : "&b_userName&"]"
'				end if 
'			end if
'
'		Next
'	end if
 
  
db.Dispose
Set db = Nothing
%>