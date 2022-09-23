

<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<script language="Javascript" runat="server">

function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}

</script>

<%
  iLoginID = fInject(crypt.DecryptStringENC(Request.cookies(global_HP)("UserID")))
%>

<%
  REQ = Request("Req")
  'REQ = "{""tGameNationType"":"""",""tSido"":"""",""tSearchText"":"""",""NowPage"":""1"",""CMD"":7}"
  Set oJSONoutput = JSON.Parse(REQ)
  iNationType = fInject(crypt.DecryptStringENC(oJSONoutput.tGameNationType))
	iSido = fInject(crypt.DecryptStringENC(oJSONoutput.tSido))
  iSearchText  =fInject(oJSONoutput.tSearchText)

  If hasown(oJSONoutput, "PagePerData") = "ok" then
    PagePerData  =fInject(oJSONoutput.PagePerData)
  else
    PagePerData  = 15
	End if	

  
  If hasown(oJSONoutput, "BlockPage") = "ok" then
    BlockPage  =fInject(oJSONoutput.BlockPage)
  else
    BlockPage  = 15
	End if	

  
  If hasown(oJSONoutput, "iSearchCol") = "ok" then
    iSearchCol  =fInject(oJSONoutput.iSearchCol)
  else
    iSearchCol  = "T"
	End if	

  If hasown(oJSONoutput, "NowPage") = "ok" then
    NowPage  =fInject(oJSONoutput.NowPage)
  else
    NowPage  = 1
	End if	

  ' 전체 가져오기
  iType = "2"                      ' 1:조회, 2:총갯수

  LSQL = "EXEC tblGameTitle_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','"  & iNationType & "','"  & iSido & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
  
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If

%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
  'response.Write "iTotalCountiTotalCountiTotalCountiTotalCount="&iTotalCount&"<br>"
  'response.Write "iTotalPageiTotalPageiTotalPageiTotalPage="&iTotalPage&"<br>"
  

%>

<table class="table-list match_info">
    <thead>
      <tr>
        <th>번호</th>
        <th>기간(시작-종료)</th>
        <th>대회구분</th>
        <th>대회명</th>
        <th>선수구분</th>
        <th>주최</th>
        <th>지역</th>
        <th>노출</th>
        <th>종별관리</th>
        <th>장소관리</th>
        <th>추가정보</th>
		<th>심판</th>
        <th>종별</th>
      </tr>
    </thead>
    <tbody id="contest">
      <%
        iType = 1
        LSQL = "EXEC tblGameTitle_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','"  & iNationType & "','"  & iSido & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"

        'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
        'LSQL = LSQL & " FROM  tblGameTitle a "
        'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
        'LSQL = LSQL & " WHERE a.DELYN = 'N' "
        'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'response.End
        
        Set LRs = DBCon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          LCnt = LCnt + 1
              RGameTitleIDX = LRs("GameTitleIDX")
              crypt_RGameTitleIDX = crypt.EncryptStringENC(RGameTitleIDX)
              RGameGb = LRs("GameGb")
              RGameGbNm = LRs("GameGbNm")
              RGameTitleName = LRs("GameTitleName")
              RGameTitleHost = LRs("GameTitleHost")
              RGameS = LRs("GameS")
              RGameE = LRs("GameE")
              RGamePlace = LRs("GamePlace")
              RSido = LRs("Sido")
              RSidoNm = LRs("SidoNm")
              RSidoDtl = LRs("SidoDtl")
              REnterType = LRs("EnterType")
              RGameRcvDateS = LRs("GameRcvDateS")
              RGameRcvHourS = LRs("GameRcvHourS")
              RViewYN = LRs("ViewYN")
              RLevelCount = LRs("levelCount")
              RlevelGrooupNm = LRS("levelGrooupNm")
              RStadiumCount = LRS("StadiumCount")
              AddInfoCount = LRS("AddInfoCount")
			  RefereeInfoCount = LRS("RefereeInfoCount")
              %>
              <tr>
                  <!-- 번호-->
                  <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                        <%=RGameTitleIDX%>
                    </td>
                    <!-- 날짜 -->
                  <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                    <%if RGameS = "" and RGameE = ""  Then %>
                      <%Response.Write  "-"%>
                    <%else%>
                      <%=RGameS%> ~ <%=RGameE%>
                    <%end if%>
                    </td>
                    <!-- 대회구분 -->
                  <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                        <%=RGameGbNm%> 
                    </td>
                    <!-- 대회 이름-->
                  <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer" class="name">
                        <%=RGameTitleName%>
                    </td>

                    
                    <!-- 단체전-->
                  <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                        <%=REnterType%>
                    </td>

                      <!-- 주관 -->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                      <%
                          if(cdbl(Len(rGameTitleHost)) > 10) Then
                            response.write LEFT(rGameTitleHost, 10) & "..."
                          else
                            response.write rGameTitleHost
                          end if
                      %>
                    </td>
                    <!-- 지역-->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                      <%=RSidoNm%>
                    </td>
                    <!-- 단체전-->
                    <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                    <%=RViewYN%>
                    </td>
                    <td>
                    <%  IF CDBL(RLevelCount) = CDBL(0) Then %>
                      <a href="javascript:href_level('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-blue">종별등록 </a>
                    <%ELSE%>
                      <a href="javascript:href_level('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-blue-empty" >종별관리<span class="txt">(<%=RLevelCount%>)</span></a>
                    <%END IF%>
                    </td>
                    <td>
                    <%  IF CDBL(RStadiumCount) = CDBL(0) Then %>
                      <a href="javascript:href_stadium('<%=crypt_RGameTitleIDX%>');" class="btn list-btn btn-red" >장소등록</a>
                    <%ELSE%>
                      <a href="javascript:href_stadium('<%=crypt_RGameTitleIDX%>');" class="btn list-btn btn-red-empty" >장소관리<span class="txt">(<%=RStadiumCount%>)</span></a>
                    <%END IF%>
                    </td>
					<td title="대회요강, 연습일정표, 숙박/주변관광 정보를 등록관리합니다."><%  IF CDBL(AddInfoCount) = CDBL(0) Then %>
                <a href="javascript:href_addinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-red" >등록</a>
                <%ELSE%>
                <a href="javascript:href_addinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>');" class="btn list-btn btn-red-empty" >수정</a>
                <%END IF%></td>
              <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer"><%  IF CDBL(RefereeInfoCount) = CDBL(0) Then %>
                <a href="javascript:href_refereeinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>', 'WRITE');" class="btn list-btn btn-red" >등록</a>
                <%ELSE%>
                <a href="javascript:href_refereeinfo('<%=crypt_RGameTitleIDX%>','<%=NowPage%>', 'MOD');" class="btn list-btn btn-red-empty" >수정</a>
                <%END IF%></td>	  
                    
                    <!-- 종목 리스트-->
                  <td onclick="SelGameTitle('<%=crypt_RGameTitleIDX%>','<%=NowPage%>')" style="cursor:pointer">
                      <%=RlevelGrooupNm%>
                    </td>
                </tr>
              <%
            LRs.MoveNext
          Loop
        End If
        LRs.close
      %>
    </tbody>
    </div>
  </table>
  <%
  if cdbl(iTotalCount) > 0 then

  'Response.WRite "iTotalCount" & iTotalCount & "<br>"
  'Response.WRite "iTotalPage" & iTotalPage & "<br>"
  %>
    <!-- S: page_index -->
    <div class="page_index">
      <!--#include file="../../dev/dist/CommonPaging_Admin.asp"-->
    </div>
    <!-- E: page_index -->
  <%
    End If
  %>