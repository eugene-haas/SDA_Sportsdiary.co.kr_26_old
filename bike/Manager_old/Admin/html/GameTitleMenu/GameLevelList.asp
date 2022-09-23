<tr>
  <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
      <%=tGameLevelidx%>
  </td>
  <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
      <%=tPGameLevelidx%>
  </td>

  <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
      <%=tTeamGb%>&nbsp;<%=tGroupGameGbNm%>
  </td>
  <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
    <% IF tEnterType = "E" Then %>
    <%=tSex%><%=tTeamGb%><% if tGroupGameGb <> "B0030002" Then %>&nbsp;<%=tPlayType%><% end if%>
          <% IF tGroupGameGb <> "B0030002" Then %>
            (<%=tLevel%>)
            <%Else%>
            <%IF tTeamGb = tLevel Then%>
              (<%=tGroupGameGbNm%>)
            <%Else%>&nbsp;<%=tLevel%> (<%=tGroupGameGbNm%>)
            <% End if %>
          <% End IF %>
    <% End IF  %>

    <% IF tEnterType = "A" Then %>
      <%=LEFT(tSex, 1) %> <%=LEFT(tPlayType, 1)%>-<%=tLevel%>
      <% if tLevelJooName <> "B0110007" and tLevelJooName <> "" Then %>-<%=tLevelJooNameNm%><%IF(tLevelJooNum <> "") Then%>-<%=tLevelJooNum %><%End If%>
      <% End IF  %>
    <% End IF  %>
  </td>

  <td width ="100px"  style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
    <a href="javascript:href_LevelDtl('<%=crypt_tidx%>','<%=crypt_tGameLevelidx%>');"  class="btn-list type2"> 대진표 <%=tGameLevelDtlCount%><i><img src="../images/icon_more_right.png" alt=""></i></a>
  </td>

  <td width ="100px">
    <% if(tGroupGameGb <> "B0030002") Then %>
      <a href="javascript:href_Participate('<%=crypt_tidx%>','<%=crypt_tGameLevelidx%>');"  class="btn-list type2"> 개인전 현황 <%=tRequestGroupCnt%> <i><img src="../images/icon_more_right.png" alt=""></i></a>
    <%Else%>
    <a href="javascript:href_ParticipateTeam('<%=crypt_tidx%>','<%=crypt_tGameLevelidx%>');"  class="btn-list type2"> 단체전 현황 <%=tRequestTeamCnt%> <i><img src="../images/icon_more_right.png" alt=""></i></a>
    <%End If%>
  </td>

  <td style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
    <%=tRequestPlayerCnt%>명
  </td>


  <td style="cursor:pointer" >
    <% if cdbl(tPGameLevelidx) = 0 Then %>
    <div id="divSeedCnt_<%=crypt_tGameLevelidx%>">
      <label for="txtSeedCnt_<%=crypt_tGameLevelidx%>">시드개수</label>
      <input style="width:30px" type="text" id="txtSeedCnt_<%=crypt_tGameLevelidx%>" name="txtSeedCnt_<%=crypt_tGameLevelidx%>" value="<%=tSeedCnt%>">
      <input type="Button" id="btnLevelSeed" name="btnLevelSeed" value="적용" onclick="javascript:ApplyLevelSeed('<%=crypt_tGameLevelidx%>')">
    </div>
    <div id="divJooDivision_<%=crypt_tGameLevelidx%>">
      <label for="txtJooDivision_<%=crypt_tGameLevelidx%>">조 배분</label>
      <input style="width:30px" type="text" id="txtJooDivision_<%=crypt_tGameLevelidx%>" name="txtJooDivision_<%=crypt_tGameLevelidx%>" value="<%=tJooDivision%>">
      <input type="Button" id="btnLeveJoolDivision" name="btnLeveJoolDivision" value="적용" onclick="javascript:ApplyLevelJooDIvision('<%=crypt_tGameLevelidx%>',<%=NowPage%>)">
    </div>
    <div id="divGoUpRank_<%=crypt_tGameLevelidx%>">
      <label for="txtGoUpRank_<%=crypt_tGameLevelidx%>">본선 순위</label>
      <input style="width:30px" type="text" id="txtGoUpRank_<%=crypt_tGameLevelidx%>" name="txtGoUpRank_<%=crypt_tGameLevelidx%>"  value="<%=tJooRank%>">
      <input type="Button" id="btnLevelRank" name="btnLevelRank" value="적용" onclick="javascript:ApplyLevelRank('<%=crypt_tGameLevelidx%>')">
    </div>
    <% End If %>
  </td>

  <td  style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
    <%=tGameDay%>
  </td>

  <td  style="cursor:pointer" onclick="javascript:SelGameLevel('<%=crypt_tGameLevelidx%>')">
    <%=tViewYN%>
  </td>
</tr>