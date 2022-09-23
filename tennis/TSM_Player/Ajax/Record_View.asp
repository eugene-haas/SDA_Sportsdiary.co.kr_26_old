<!--#include file="../Library/ajax_config.asp"-->
<%
		PlayerIDX = request("PlayerIDX")
		totPnt = request("totPnt")
		userName  = request("userName")
		TeamNm = request("TeamNm")
		Team2Nm = request("Team2Nm")
		Search_NewTeamGbName = request("Search_NewTeamGbName") 
		%>
        <div class="playerDetail__bg">
			  <p class="playerDetail__tle">KATA랭킹</p>
			  <div class="l_recordList__content">
				<div class="playerDetail__header">
				  <div class="playerDetail__photo">
				  <img src="http://img.sportsdiary.co.kr/images/SD/img/tennis_record_default_pic_@3x.png" alt=""></div>
				  <div class="playerDetail__summary">
						<div class="playerDetail__name"><%=userName%></div>
						<div class="playerDetail__info s_top_round">
						  <p class="playerDetail__txt">기본클럽</p>
						  <p class="playerDetail__txt2"><%=TeamNm%></p>
						</div>
						<div class="playerDetail__info">
						  <p class="playerDetail__txt">기타클럽</p>
						  <p class="playerDetail__txt2"><%=Team2Nm%></p>
						</div>
						<!-- KATA홈페이지 데이터 동일하게. 생년월일 미노출 요청 -->
						<!--<div class="playerDetail__info s_bottom_round">
						  <p class="playerDetail__txt">프로필</p>
						  <p class="playerDetail__txt2">1990.01.01 / 여</p>
						</div>-->
						<div class="playerDetail__info s_round">
						  <p class="playerDetail__txt">총포인트</p>
						  <p class="playerDetail__txt2"><%=formatnumber(totPnt, 0)%>p</p>
						</div>
              </div>
            </div>
            <div class="playerDetail__list">
              <ul>
	<%
			LSQL = "EXEC Search_TennisRPing_log_RankingView 15, '"&Search_NewTeamGbName&"', '"&PlayerIDX&"'"
     	Set LRs = DBCon4.Execute(LSQL)

		  If Not (LRs.Eof Or LRs.Bof) Then
				Do Until LRs.Eof
				LCnt = LCnt + 1
			IF LRs("rankno") <= 3 THEN 
				ranknoNm = "위" 
			ElseIf LRs("rankno") = 4 THEN 
				ranknoNm = "3위" 
			ELSE 
				ranknoNm = "강"
			End If 
%>
                  <li>
                    <div class="playerDetail__listwrap">
                      <p class="playerDetail__listno"><%=LRs("RNum")%></p>
                      <div class="playerDetail__infos">
                        <p class="playerDetail__comp"><%=LRs("titleName")%> </p>
                        <div class="playerDetail__infotop">
                          <p class="playerDetail__point"><%=LRs("getpoint")%>p</p>
                          <p class="playerDetail__result"><% IF  LRs("rankno") = 4 then%><%else %><%=LRs("rankno")%><%end if%><%=ranknoNm%></p>
                          <p class="playerDetail__pos"> <%=LRs("teamGbName")%></p>
                        </div>
                      </div>
                    </div>
                  </li>
<%
		LRs.MoveNext
	Loop
End If
LRs.close
DBClose4()
%>
		  </ul>
		</div>
            <!--<button class="l_recordList__btn_add">더보기 <span><img src="http://tennis.sportsdiary.co.kr/tennis/tsm_player/record/btn_more.png" alt=""></span></button>-->
          </div>
        </div>