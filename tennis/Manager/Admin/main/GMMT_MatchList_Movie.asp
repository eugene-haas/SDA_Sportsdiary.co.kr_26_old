<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<% 
	RoleType = "GMMT"	
 %>
<!--#include file="CheckRole.asp"-->
<link href="./css/lib/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script src="../front/dist/js/bootstrap.min.js" type="text/javascript"></script>
 <%
    Search_Years            = fInject(Request("Search_Years"))
	Search_GameTitleIDX     = fInject(Request("Search_GameTitleIDX"))
    Search_GroupGameGb      = fInject(Request("Search_GroupGameGb"))
    Search_TeamGb           = fInject(Request("Search_TeamGb"))
    Search_Level            = fInject(Request("Search_Level"))
    Search_round            = fInject(Request("Search_round"))

    SportsGb="tennis"
    EnterType="A"

    if Search_Years="" then 
        YNSQL = "SELECT LEFT(CONVERT(NVARCHAR,GETDATE(),112),4) Years"
        Set YNRs = Dbcon.Execute(YNSQL)
    
        If Not(YNRs.Eof Or YNRs.Bof) Then 
	        Search_Years =YNRs("Years")
        End If 
    End If 

%>
<script type="text/javascript">
    function chk_frm(val) {
        var sf = document.search_frm;

        if (val == "FND") {
            sf.action = "./GMMT_MatchList_Movie.asp";
            sf.submit();
        } 
    }
</script>
<%
    ''컨트롤 조회
    Dim JSONarr()
    if  Search_Years <> ""  and Search_GameTitleIDX<>"" then 
        ControlSql =" select a.GameTitleIDX,a.GameTitleName,b.GameType,p1.PubName,b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm,isnull(d.Round,0) Round ,count(f.resultIDX)resultCnt " & _ 
                    " from sd_TennisTitle a  " & _ 
                    " inner join tblRGameLevel b on a.GameTitleIDX = b.GameTitleIDX and a.SportsGb = b.SportsGb and b.DelYN='N' " & _ 
                    " inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' " & _ 
                    " inner join sd_TennisMember d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.gamekey3 and d.DelYN='N' " & _ 
                    " inner join sd_TennisResult f on (f.gameMemberIDX1 = d.gameMemberIDX or f.gameMemberIDX2 = d.gameMemberIDX ) and f.GameTitleIDX = d.GameTitleIDX and f.Level = d.gamekey3 and f.delYN='N' " & _ 
                    " left join tblPubCode p1  on b.GameType = p1.PubCode and b.SportsGb = p1.SportsGb and p1.DelYN='N' and p1.PPubCode ='sd04' " & _ 
                    " where a.DelYN='N' and a.GameTitleIDX='"&Search_GameTitleIDX&"' and a.GameYear='"&Search_Years&"' and a.stateNo>=5  and a.MatchYN='Y' and a.ViewState='Y' " & _ 
                    " group by a.GameTitleIDX,a.GameTitleName,a.GameS,a.GameE,b.GameType,p1.PubName,b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm  ,isnull(d.Round,0) " & _ 
                    " ORDER BY GameS DESC " 

        Set Rs = Dbcon.Execute(ControlSql)
        rscnt =  Rs.RecordCount
        If Not(Rs.Eof Or Rs.Bof) Then 
			Do Until rs.eof
		    i = i + 1
		    rs.movenext
		    Loop
            rscnt = i

            ReDim JSONarr(rscnt)
            i = 0
		    Do Until rs.eof

		    Set rsarr = jsObject() 
			    rsarr("GameTitleIDX") = rs("GameTitleIDX")
			    rsarr("GameTitleName") = rs("GameTitleName") 
			    rsarr("GameType") = rs("GameType") 
			    rsarr("GameTypeNm") = rs("PubName")
			    rsarr("TeamGb") = rs("TeamGb")
			    rsarr("TeamGbNm") = rs("TeamGbNm")
			    rsarr("Level") = rs("Level")
			    rsarr("LevelNm") = rs("LevelNm")
			    rsarr("Round") = rs("Round")
                if rs("Round") = 0 and rs("LevelNm")="최종라운드" then 
                    rsarr("RoundNm")  = "예선"
                else 
                    if rs("resultCnt") <=2 then 
                        rsarr("RoundNm")  = "결승전"
                    elseif rs("resultCnt") >2 and rs("resultCnt") <=4   then 
                        rsarr("RoundNm")  = "준결승전"
                     elseif rs("resultCnt") >4 and rs("resultCnt") <=8   then 
                        rsarr("RoundNm")  = "8강"
                     elseif rs("resultCnt") >8 and rs("resultCnt") <=16   then 
                        rsarr("RoundNm")  = "16강"
                     elseif rs("resultCnt") >16 and rs("resultCnt") <=32   then 
                        rsarr("RoundNm")  = "32강"
                     elseif rs("resultCnt") >32 and rs("resultCnt") <=64   then 
                        rsarr("RoundNm")  = "64강"
                     elseif rs("resultCnt") >64 and rs("resultCnt") <=128   then 
                        rsarr("RoundNm")  = "128강"
                     elseif rs("resultCnt") >128 and rs("resultCnt") <=256   then 
                        rsarr("RoundNm")  = "256강"
                    end if 
                end if 
			    rsarr("resultCnt") = rs("resultCnt")   
			    Set JSONarr(i) = rsarr
		    i = i + 1
		    rs.movenext
		    Loop
		    datalen = Ubound(JSONarr) - 1
	        jsonstr = toJSON(JSONarr)
	        Set ojson = JSON.Parse(jsonstr)
        End If 
    end if 

 %>
	<section>		
		<div id="content">
			<div class="loaction">
				<strong>경기관리</strong> &gt; 동영상관리
			</div>
		<form method="post" name="search_frm" id="search_frm" action="GMMT_MatchList_Movie.asp"> 
		<div class="sch">
			<table class="sch-table">
				<caption>검색조건 선택 및 입력</caption>
				<colgroup>
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="50px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
				</colgroup>				 
				<tbody>
					<tr>
                        <th scope="row"><label for="competition-name-1">기간</label></th>
                        <td>
                          <select id="Search_Years" name="Search_Years" onchange="chk_frm('FND');">
                           <%   YEARSQL = " select GameYear "
                                YEARSQL =YEARSQL& " From sd_TennisTitle "
                                YEARSQL =YEARSQL& " where   DelYN='N' and stateNo>=5 and MatchYN='Y' and ViewState='Y' and isnull(GameYear,'')<>'' and  GameYear >='2017' "
                                YEARSQL =YEARSQL& " group by GameYear"
                                YEARSQL =YEARSQL& " ORDER BY GameYear DESC "
	                            Set YRs = Dbcon.Execute(YEARSQL)
	                            If Not(YRs.Eof Or YRs.Bof) Then 
		                            Do Until YRs.Eof 
                                    %><option value="<%=YRs("GameYear")%>" <%If YRs("GameYear") = Search_Years Then %>selected <% End If%> ><%=YRs("GameYear")%></option><%
			                        YRs.MoveNext
		                            Loop 
	                            End If %>
                          </select>
                        </td>
						<th scope="row"><label for="competition-name-2">대회선택</label></th>
						<td>
							<select name="Search_GameTitleIDX" id="Search_GameTitleIDX" onchange="chk_frm('FND');">
								<option value="">=대회선택=</option>
								<%
										GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
										GSQL = GSQL & " from sd_TennisTitle  "
										GSQL = GSQL & " where   DelYN='N' and GameYear='"&Search_Years&"' and stateNo>=5 and MatchYN='Y' and ViewState='Y'"
										GSQL = GSQL & " ORDER BY GameS DESC"
			                            
                                        Set GRs = Dbcon.Execute(GSQL)
										If Not(GRs.Eof Or GRs.Bof) Then 
											Do Until GRs.Eof 
								                %>
								                <option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(Search_GameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
								                <%
												GRs.MoveNext
											Loop 
										End If 
								%>
							</select>
						</td>
                        </tr>
                        <tr>			
						<th scope="row">대전방식</th>
						<td id="sel_Search_TeamGb">
							<select id="Search_TeamGb" name="Search_TeamGb" onchange="chk_frm('FND');">
								<option value="">::경기방식선택::</option>
							</select>
						</td>								
						<th scope="row">소속부</th>
						<td id="sel_Level">
                          <select id="Search_Level" name="Search_Level" onchange="chk_frm('FND');">
                            <option value="">::소속선택::</option>
                          </select>    								
						</td>							
						<th scope="row">라운드</th>
						<td id="sel_round">
                          <select id="Search_round" name="Search_round" onchange="chk_frm('FND');">
                            <option value="">::강수 선택::</option>
                          </select>    								
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</form>
		<!-- S : 리스트 -->
		<table class="table-list">
			<caption>대회 리스트</caption>
			<colgroup>
			<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
				<col style="min-width:150px" />
				<col style="min-width:150px" />
				<col style="min-width:50px" />
			</colgroup>
			<thead>
				<tr>
				    <th scope="col">No</th>
					<th scope="col">라운드</th>

                    <th scope="col">선수명</th>
					<th scope="col">파트너</th>
					<th scope="col">VS</th>
					<th scope="col">선수명</th>
					<th scope="col">파트너</th>
					
					<th scope="col">경로</th>
					<th scope="col">동영상시작</th>
					<th scope="col">동영상종료</th>
				</tr>
			</thead>
			<tbody>
            <%
            if  Search_Years <> ""  and Search_GameTitleIDX<>"" then 

             Response.Write "<br><br><br>"&ControlSql&"<br><br><br>"&rscnt&"<br><br><br>"&datalen&"<br><br><br>"&ojson.get(i)&"<br><br><br>"
             Response.End

             i=0
            for i = 0 to datalen+1
                    GameTitleIDX = ojson.Get(i).GameTitleIDX
					GameTitleName = ojson.Get(i).GameTitleName
					GameType = ojson.Get(i).GameType
					GameTypeNm = ojson.Get(i).GameTypeNm
					TeamGb = ojson.Get(i).TeamGb
					TeamGbNm = ojson.Get(i).TeamGbNm
					Level = ojson.Get(i).Level
					LevelNm = ojson.Get(i).LevelNm
					Round = ojson.Get(i).Round
					RoundNm = ojson.Get(i).RoundNm  
					resultCnt = ojson.Get(i).resultCnt  
            %>
                <tr>
                    <th scope="col"><%=i %></th>
					<th scope="col"><%=GameTitleIDX %></th>
                    <th scope="col"><%=GameTitleName %></th>
					<th scope="col"><%=GameType %></th>
					<th scope="col"><%=GameTypeNm %></th>
					<th scope="col"><%=TeamGb %></th>
					<th scope="col"><%=TeamGbNm %></th>
					<th scope="col"><%=Level %></th>
					<th scope="col"><%=LevelNm %></th>
					<th scope="col"><%=Round %></th>
					<th scope="col"><%=RoundNm %></th>
					<th scope="col"><%=resultCnt %></th>
					<th scope="col"><%=Round %></th>
					<th scope="col"><%=Round %></th>
                </tr>
            <%
            Next
            end if 
            %>
			</tbody>
		</table>
		<!-- E : 리스트 -->
		</div>
	<section>
